(require 'ahg)
(global-set-key (kbd "C-z h") 'ahg-status)

;; And here I start extending ahg.
;; (unless (require 'hydra nil 'noerror)
;;      (package-install 'hydra))

;; (defvar ahg-pull-consider-extra-switches nil)
;; (defvar ahg-pull-extra-switches)

;; (defun ahg-pull (&rest extra-switches)
;;   "Run hg pull. When called non-interactively, it is possible
;; to pass extra switches to hg status."
;;   (interactive)
;;   (let ((buf (get-buffer-create "*aHg-pull*"))
;;         (curdir default-directory)
;;         (show-message (called-interactively-p 'interactive))
;;         (root (ahg-root)))
;;     (when ahg-pull-consider-extra-switches
;;       (let ((sbuf (ahg-get-status-buffer root)))
;;         (when sbuf
;;           (with-current-buffer sbuf
;;             (setq extra-switches ahg-pull-extra-switches)))))
;;     (with-current-buffer buf
;;       (let ((inhibit-read-only t))
;;         (erase-buffer))
;;       (setq default-directory (file-name-as-directory curdir))
;;       (set (make-local-variable 'ahg-root) root)
;;       (set (make-local-variable 'ahg-status-extra-switches) extra-switches)
;;       (ahg-push-window-configuration))
;;     (ahg-generic-command
;;      "status" extra-switches
;;      (lexical-let ((no-pop ahg-status-no-pop)
;;                    (point-pos ahg-status-point-pos))
;;        (lambda (process status)
;;          (ahg-status-sentinel process status no-pop point-pos))) buf
;;          nil (not show-message))))

;; (defhydra ahg-pull-push-menu (:columns 1)
;;   "Pull and Push operations"
;;   ("p" ahg-pull-menu/body "pull")
;;   ("P" ahg-push-menu/body "Push")
;;   )

;; (defhydra ahg-status-menu (:columns 6)
;;    "mercurial"
;;    ("A" ahg-graft "grAft")
;;    ("b" ahg-branches "Branches")
;;    ("d" ahg-diff "Diff")
;;    ("H" ahg-heads "Heads")
;;    ("l" ahg-log-menu/body "Logging")
;;    ("m" ahg-merge-menu/body "Merging")
;;    ("M" ahg-remotes "Remoting")
;;    ("p" ahg-pull-push-menu/body "Pull, Push")
;;    ("s" ahg-serve "Serve")
;;    ("t" ahg-tags "Tags")
;;    ("v" ahg-version "version")
;; )


;; ;; (add-hook 'aHg-status-mode-hook
;; ;;           '(lambda ()
;; ;;              (local-set-key (kbd "s-s h") 'ahg-status-menu)
;; ;; ))

;; (define-key ahg-status-mode-map (kbd "/") 'ahg-status-menu/body)
