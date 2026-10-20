;;; org-babel-runbook-test.el --- Tests for org-babel-runbook -*- lexical-binding: t; -*-

;; Run from the package directory:
;;   emacs -Q --batch -L . -l test/org-babel-runbook-test.el -f ert-run-tests-batch-and-exit
;; With a newer org than the built-in one, add  -L /path/to/org/lisp  first.
;; Remote tests run when `ssh -o BatchMode=yes localhost true' works.
;;
;; sudo itself would need a password, so the tests use a stand-in that does
;; what sudo >= 1.9.14 does to the session: wait a moment, then flush the
;; terminal's pending input through /dev/tty (perl POSIX::tcflush).

;;; Code:

(require 'ert)
(require 'org)
(require 'ob-shell)
(require 'org-babel-runbook)

(defconst obr-test-tty-thief
  "perl -MPOSIX=tcflush,TCIFLUSH -e 'select(undef,undef,undef,0.5); open(my $t, \"<\", \"/dev/tty\") or die; tcflush(fileno($t), TCIFLUSH); print \"flushed\\n\"'"
  "Shell command that steals pending terminal input like sudo's use_pty does.")

(defvar ob-async-no-async-languages-alist)

(defun obr-test--remote-ok ()
  (eq 0 (call-process "ssh" nil nil nil "-o" "BatchMode=yes" "-o" "ConnectTimeout=3" "localhost" "true")))

(defun obr-test--run (header blocks &optional wait)
  "Insert HEADER and BLOCKS (list of (HEADER-ARGS . BODY)) into a temp org buffer.
Execute each block, pump the event loop WAIT seconds after each, and
return the list of result strings (nil when no #+RESULTS: was written)."
  (let ((org-confirm-babel-evaluate nil)
        (results nil))
    (with-temp-buffer
      (org-mode)
      (insert header "\n\n")
      (dolist (b blocks)
        (insert (format "#+begin_src bash %s\n%s\n#+end_src\n\n" (car b) (cdr b))))
      (org-set-regexps-and-options)
      (goto-char (point-min))
      (dotimes (_ (length blocks))
        (re-search-forward "^#\\+begin_src")
        (with-timeout (10 nil) (org-babel-execute-src-block))
        (let ((end (+ (float-time) (or wait 4))))
          (while (< (float-time) end) (accept-process-output nil 0.1))))
      (goto-char (point-min))
      (dotimes (_ (length blocks))
        (re-search-forward "^#\\+begin_src")
        (push (save-excursion
                (when (re-search-forward "^#\\+end_src" nil t)
                  (forward-line 1)
                  (skip-chars-forward "\n")
                  (when (looking-at "#\\+RESULTS:")
                    (let ((v (org-babel-read-result)))
                      (if (stringp v) (string-trim v) v)))))
              results)))
    (nreverse results)))

(defun obr-test--kill-sessions (&rest names)
  (dolist (n names)
    (when-let* ((b (get-buffer n)))
      (let ((kill-buffer-query-functions nil))
        (kill-buffer b)))))

(defconst obr-test-header
  "#+PROPERTY: header-args:bash :results output :async yes\n#+PROPERTY: header-args:bash+ :var vv=\"V1\"")

(defun obr-test--thief-block (session)
  (cons (format ":session %s" session)
        (concat obr-test-tty-thief " && echo step1 $vv\n"
                "cat <<'EOF'\nheredoc {x} \"q\" $vv\nEOF\nkeep=persisted")))

(ert-deftest obr-without-mode-tty-thief-loses-results ()
  "Reproduce the bug: without the mode the result stays a uuid."
  (org-babel-runbook-mode -1)
  (unwind-protect
      ;; keep ob-async (if loaded) out of it: without the mode it would run the
      ;; block in a child Emacs instead of the session
      (let* ((ob-async-no-async-languages-alist '("bash"))
             (r (car (obr-test--run obr-test-header (list (obr-test--thief-block "obr-off"))))))
        (should (string-match-p "\\`[0-9a-f-]\\{36\\}\\'" r)))
    (obr-test--kill-sessions "obr-off")))

(ert-deftest obr-guard-keeps-results-and-state ()
  (org-babel-runbook-mode 1)
  (unwind-protect
      (let ((r (obr-test--run obr-test-header
                              (list (obr-test--thief-block "obr-on")
                                    (cons ":session obr-on" "echo second $keep")))))
        (should (equal (nth 0 r) "flushed\nstep1 V1\nheredoc {x} \"q\" $vv"))
        (should (equal (nth 1 r) "second persisted")))
    (obr-test--kill-sessions "obr-on")))

(ert-deftest obr-guard-over-tramp ()
  (skip-unless (obr-test--remote-ok))
  (require 'tramp)
  (org-babel-runbook-mode 1)
  (unwind-protect
      (let ((r (obr-test--run obr-test-header
                              (list (cons ":session obr-tr :dir /ssh:localhost:"
                                          (cdr (obr-test--thief-block "obr-tr")))
                                    (cons ":session obr-tr :dir /ssh:localhost:" "echo second $keep"))
                              8)))
        (should (string-match-p "step1 V1" (nth 0 r)))
        (should (equal (nth 1 r) "second persisted")))
    (obr-test--kill-sessions "obr-tr")))

(ert-deftest obr-sync-blocks-unchanged ()
  (org-babel-runbook-mode 1)
  (unwind-protect
      (should (equal (car (obr-test--run "#+PROPERTY: header-args:bash :results output"
                                         (list (cons ":session obr-sync" "echo sync-plain"))
                                         1))
                     "sync-plain"))
    (obr-test--kill-sessions "obr-sync")))

(ert-deftest obr-opt-out ()
  (org-babel-runbook-mode 1)
  (should (equal (org-babel-runbook--tty-guard
                  (list "s" "echo x" '((:async . "yes") (:session . "s") (:tty-guard . "no")) nil nil))
                 (list "s" "echo x" '((:async . "yes") (:session . "s") (:tty-guard . "no")) nil nil))))

(ert-deftest obr-guard-body-shape ()
  (should (equal (org-babel-runbook--guard-body "  echo a\necho b\n")
                 "eval \"$(cat <<'OB_BLOCK_END'\necho a\necho b\nOB_BLOCK_END\n)\" </dev/null; \\")))

(ert-deftest obr-session-list ()
  (org-babel-runbook-mode 1)
  (unwind-protect
      (progn
        (obr-test--run obr-test-header (list (cons ":session obr-list" "echo listed")) 1)
        (save-window-excursion (shell "*obr-plain-shell*"))
        (let ((names (mapcar #'buffer-name (org-babel-runbook-sessions))))
          (should (member "obr-list" names))
          (should-not (member "*obr-plain-shell*" names))))
    (obr-test--kill-sessions "obr-list" "*obr-plain-shell*")))

(ert-deftest obr-ob-async-bypass ()
  (skip-unless (require 'ob-async nil t))
  (org-babel-runbook-mode 1)
  (should (advice-member-p #'org-babel-runbook--skip-ob-async 'ob-async-org-babel-execute-src-block))
  (unwind-protect
      (should (equal (car (obr-test--run obr-test-header (list (cons ":session obr-async" "echo via-session"))))
                     "via-session"))
    (obr-test--kill-sessions "obr-async")))

(defun obr-test--restart-run (session)
  "Run a block in SESSION, kill its shell process, run another; return results."
  (let ((first (car (obr-test--run obr-test-header (list (cons (format ":session %s" session) "echo before"))))))
    (delete-process (get-buffer-process session))
    (list first
          (car (obr-test--run obr-test-header
                              (list (cons (format ":session %s" session) "echo after-restart")))))))

(ert-deftest obr-dead-session-restarts-without-mode ()
  "Reproduce: a session whose shell died fails with (wrong-type-argument stringp nil)."
  (skip-unless (get 'comint-output-filter-functions 'permanent-local))
  (org-babel-runbook-mode -1)
  (unwind-protect
      (let ((ob-async-no-async-languages-alist '("bash")))
        (should-error (obr-test--restart-run "obr-dead-off") :type 'wrong-type-argument))
    (obr-test--kill-sessions "obr-dead-off")
    (org-babel-runbook-mode 1)))

(ert-deftest obr-dead-session-restarts ()
  (org-babel-runbook-mode 1)
  (unwind-protect
      (should (equal (obr-test--restart-run "obr-dead") '("before" "after-restart")))
    (obr-test--kill-sessions "obr-dead")))

(ert-deftest obr-mode-off-removes-advice ()
  (org-babel-runbook-mode 1)
  (org-babel-runbook-mode -1)
  (should-not (advice-member-p #'org-babel-runbook--tty-guard 'org-babel-sh-evaluate))
  (should-not (advice-member-p #'org-babel-runbook--drop-dead-session 'org-babel-sh-initiate-session))
  (org-babel-runbook-mode 1))

;;; org-babel-runbook-test.el ends here
