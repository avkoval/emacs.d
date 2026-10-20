;;; org-babel-runbook.el --- Reliable org-babel shell sessions for runbooks -*- lexical-binding: t; -*-

;; Copyright (c) 2026 Oleksii Koval

;; Author: Oleksii Koval
;; Version: 0.1.0
;; Package-Requires: ((emacs "29.1") (org "9.7"))
;; Keywords: outlines, processes, tools
;; SPDX-License-Identifier: MIT

;;; Commentary:

;; Run org files as runbooks: `#+begin_src bash :session pi :dir /ssh:pi:'
;; blocks executed with C-c C-c, each in a named Emacs shell buffer, locally
;; or on a remote host over TRAMP.  Out of the box this breaks in three ways;
;; `org-babel-runbook-mode' fixes them:
;;
;; 1. sudo eats ob-shell's end marker.  ob-shell types the block into the
;;    session and then one more line, `echo <marker>', whose output tells
;;    org the block is done.  That line waits in the terminal's input queue
;;    while the block runs.  sudo >= 1.9.14 (use_pty, the default on Debian
;;    13, Arch, Fedora...) works on /dev/tty and takes or flushes that queued
;;    input, so the marker never prints: the commands run, but #+RESULTS:
;;    stays at the async placeholder uuid forever (or Emacs hangs in a sync
;;    block).  Any program reading the terminal (xdg-open, script, ...) does
;;    the same.  Redirecting the block's stdin doesn't help.
;;    Fix: async session bodies are sent as
;;        eval "$(cat <<'OB_BLOCK_END'
;;        ...block...
;;        OB_BLOCK_END
;;        )" </dev/null; \
;;    The trailing backslash joins the marker line onto the same command, so
;;    the shell has read everything before the first command runs and no
;;    input is left in the queue to steal.
;;
;; 2. ob-async hijacks session blocks.  If ob-async is installed, it takes
;;    every block with :async and runs it in a child Emacs that has no
;;    session buffers ("No buffer named pi", or a crash while the child loads
;;    your init).  Shell blocks with a :session are routed past it to
;;    ob-shell's own :async, which runs inside the session.
;;
;; 3. Session buffers are invisible.  `org-babel-runbook-list-sessions'
;;    lists them (live first, host and directory, [visible] / [dead]) and
;;    switches to the chosen one.
;;
;; Setup:
;;   (require 'org-babel-runbook)
;;   (org-babel-runbook-mode 1)
;;   (global-set-key (kbd "C-c b s") #'org-babel-runbook-list-sessions)
;;
;; In the org file:
;;   #+PROPERTY: header-args:bash :results output :async yes
;;
;; Use :async yes for every block that runs sudo: only async blocks are
;; wrapped (ob-shell's synchronous path splits output by prompts and
;; returns nothing for a wrapped body).  Opt out per block: :tty-guard no.
;; See README.md for the full story and runbook conventions.

;;; Code:

(require 'org)
(require 'ob-shell)
(require 'ob-comint)
(require 'seq)

(defvar comint-prompt-regexp)
(defvar org-babel-runbook-mode)

(defgroup org-babel-runbook nil
  "Reliable org-babel shell sessions for runbooks."
  :group 'org-babel
  :prefix "org-babel-runbook-")

(defcustom org-babel-runbook-guard-delimiter "OB_BLOCK_END"
  "Heredoc delimiter used to wrap async session bodies.
A block must not contain a line consisting of exactly this string."
  :type 'string)

(defcustom org-babel-runbook-shell-languages '("bash" "sh" "shell" "zsh")
  "Babel languages whose :session blocks get the guard and the ob-async bypass.
The guard uses POSIX `eval' and a quoted heredoc, so only Bourne-style
shells belong here."
  :type '(repeat string))

;;;; 1. sudo-safe async session bodies

(defun org-babel-runbook--guard-body (body)
  "Return BODY wrapped so the shell reads it and the next line before running."
  (let ((d org-babel-runbook-guard-delimiter))
    (concat "eval \"$(cat <<'" d "'\n" (org-trim body) "\n" d "\n)\" </dev/null; \\")))

(defun org-babel-runbook--tty-guard (args)
  "Filter-args advice for `org-babel-sh-evaluate'.
ARGS is (SESSION BODY PARAMS STDIN CMDLINE).  Wrap BODY of async
session blocks with `org-babel-runbook--guard-body' unless the block
says :tty-guard no."
  (pcase-let ((`(,session ,body ,params ,stdin ,cmdline) args))
    (if (and session (not stdin) (not cmdline)
             (org-babel-comint-use-async params)
             (not (equal (cdr (assq :tty-guard params)) "no")))
        (list session (org-babel-runbook--guard-body body) params stdin cmdline)
      args)))

;;;; 2. ob-async bypass

(defun org-babel-runbook--skip-ob-async (fn orig-fun &optional arg info params)
  "Around advice for `ob-async-org-babel-execute-src-block' (FN).
Shell blocks with a :session go straight to ORIG-FUN (ARG INFO PARAMS),
so ob-shell's own :async runs them inside the named session buffer."
  (let* ((i (or info (org-babel-get-src-block-info 'light)))
         (session (cdr (assq :session (nth 2 i)))))
    (if (and session (not (equal session "none"))
             (member (nth 0 i) org-babel-runbook-shell-languages))
        (funcall orig-fun arg info params)
      (funcall fn orig-fun arg info params))))

(defun org-babel-runbook--advise-ob-async ()
  "Install the ob-async bypass if ob-async is loaded and the mode is on."
  (when (and org-babel-runbook-mode
             (fboundp 'ob-async-org-babel-execute-src-block))
    (advice-add 'ob-async-org-babel-execute-src-block :around
                #'org-babel-runbook--skip-ob-async)))

;;;; 3. Sessions whose shell died

(defun org-babel-runbook--drop-dead-session (&optional session &rest _)
  "Before advice for `org-babel-sh-initiate-session'.
Kill the SESSION buffer when its shell process is gone, so ob-shell
starts a fresh session instead of restarting the shell in the old
buffer.  A restart in place keeps `org-babel-comint-async-filter' in
`comint-output-filter-functions' (permanent-local) while `shell-mode'
resets the async state it needs, and the next block fails with
\(wrong-type-argument stringp nil).  This happens after the remote host
of a TRAMP session rebooted or the connection dropped."
  (when-let* (((stringp session))
              ((not (string= session "none")))
              (buf (get-buffer session))
              ((not (process-live-p (get-buffer-process buf)))))
    (let ((kill-buffer-query-functions nil))
      (kill-buffer buf))))

;;;; 4. Session list

(defun org-babel-runbook--session-p (buf)
  "Non-nil if BUF is an org-babel shell :session buffer."
  (with-current-buffer buf
    (and (derived-mode-p 'shell-mode)
         (or (bound-and-true-p org-babel-sh--prompt-initialized)
             (and (boundp 'org-babel-sh-prompt)
                  (stringp comint-prompt-regexp)
                  (string-match-p (regexp-quote (regexp-quote org-babel-sh-prompt))
                                  comint-prompt-regexp))))))

(defun org-babel-runbook--session-label (buf)
  "Completion label for session buffer BUF."
  (with-current-buffer buf
    (let ((host (file-remote-p default-directory 'host))
          (dir (or (file-remote-p default-directory 'localname) default-directory)))
      (concat (buffer-name buf)
              "  " (if host (format "%s:%s" host dir) (abbreviate-file-name dir))
              (and (get-buffer-window buf t) "  [visible]")
              (and (not (process-live-p (get-buffer-process buf))) "  [dead]")))))

(defun org-babel-runbook-sessions ()
  "Return org-babel shell session buffers, live ones first, then by name."
  (sort (seq-filter #'org-babel-runbook--session-p (buffer-list))
        (lambda (a b)
          (let ((la (process-live-p (get-buffer-process a)))
                (lb (process-live-p (get-buffer-process b))))
            (if (eq (not la) (not lb))
                (string< (buffer-name a) (buffer-name b))
              (and la t))))))

;;;###autoload
(defun org-babel-runbook-list-sessions ()
  "List org-babel shell :session buffers and switch to the selected one."
  (interactive)
  (let ((buffers (org-babel-runbook-sessions)))
    (unless buffers (user-error "No org-babel shell sessions"))
    (let* ((candidates (mapcar (lambda (b) (cons (org-babel-runbook--session-label b) b))
                               buffers))
           (choice (completing-read "Switch to babel session: " candidates nil t))
           (buf (cdr (assoc choice candidates))))
      (when (buffer-live-p buf)
        (pop-to-buffer buf)))))

;;;; Mode

;;;###autoload
(define-minor-mode org-babel-runbook-mode
  "Make org-babel shell :session blocks reliable for runbooks.
Wraps async session bodies so sudo can't steal ob-shell's end marker,
routes shell session blocks past ob-async, and starts a fresh session
when a session's shell has died."
  :global t
  :group 'org-babel-runbook
  (if org-babel-runbook-mode
      (progn
        (advice-add 'org-babel-sh-evaluate :filter-args #'org-babel-runbook--tty-guard)
        (advice-add 'org-babel-sh-initiate-session :before
                    #'org-babel-runbook--drop-dead-session)
        (org-babel-runbook--advise-ob-async)
        (with-eval-after-load 'ob-async (org-babel-runbook--advise-ob-async)))
    (advice-remove 'org-babel-sh-evaluate #'org-babel-runbook--tty-guard)
    (advice-remove 'org-babel-sh-initiate-session #'org-babel-runbook--drop-dead-session)
    (when (fboundp 'ob-async-org-babel-execute-src-block)
      (advice-remove 'ob-async-org-babel-execute-src-block #'org-babel-runbook--skip-ob-async))))

(provide 'org-babel-runbook)
;;; org-babel-runbook.el ends here
