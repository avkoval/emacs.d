(require 'dired-x)
(setq dired-omit-files "^\\...+$")

(defun avk-dired-mode-hook ()
  (local-set-key [(tab)] 'other-window))

(add-hook 'dired-mode-hook 'avk-dired-mode-hook)


; With dired-x installed you can use F , which visits all marked
; files. Importantly, it will attempt to open files and give each
; file its own window — which you may not want. To avoid
; this, and open them in the background, type C-u F .
;
; | Keys      | Description                         |
; |-----------+-------------------------------------|
; | M-s a C-s | ISearches all marked files          |
; | Q         | Query replace regexp marked files   |
; | !         | Shell command on marked files       |
; | &         | Async shell command on marked files |
(require 'dired-x)
(global-unset-key (kbd "C-x C-j"))
(global-set-key (kbd "C-x C-j C-c") 'jabber-connect-all)

;; (require 'openwith)
;; (setq openwith-associations '(("\\.pdf\\'" "xdg-open" (file))))
;; (openwith-mode t)

(defun open-vault-file(arg)
  "Decrypt vault file specified in ARG by calling ansible-vault and .vaultfile password
   from any upper directory"
  (let ((vaultfile ".vaultfile"))
    (let ((vault-file-dir (locate-dominating-file default-directory vaultfile)))
      (if vault-file-dir
          (call-process "ansible-vault" nil 0 nil
                        "--vault-password-file"
                        (concat vault-file-dir ".vaultfile")
                            "edit" arg)
        (message (format "%s not found in current or upper directories" vaultfile)))
      ))
  )

;; from https://emacs.stackexchange.com/questions/15208/using-tramp-for-logs
;; (defun dired-tail-log(arg)
;;   "Tail log file"
;;   (interactive)
;;   (start-process-shell-command "dired-tail" "test" "tail" "-f" arg)
;; ;;  (call-process-shell-command "tail" nil "test" nil "-f" arg)
;;   )

;; (defun dired-tail-logs()
;;   "Tail marked files."
;;   (interactive)
;;   (mapc 'dired-tail-log (dired-get-marked-files t))
;;   )

(defun open-vault-files()
  "Open marked files (or current one) to edit via ansible-vault."
  (interactive)
  (require 'server)
  (unless (server-running-p)
    (server-start))
  (setenv "EDITOR" "emacsclient")
  (mapc 'open-vault-file (dired-get-marked-files t))
  )

(global-set-key (kbd "C-z v") 'open-vault-files)

(defun open-file-externally(arg)
  (async-shell-command (format "xdg-open \"%s\"" arg))
  )

(defun open-files-externally()
  "Open marked files (or current one) to edit via ansible-vault."
  (interactive)
  (mapc 'open-file-externally (dired-get-marked-files t))
  )

(global-set-key (kbd "C-c e") 'open-files-externally)

(add-to-list 'auto-mode-alist '("all.open" . yaml-mode))

(define-key dired-mode-map ";" 'dired-subtree-toggle)

 (defun dired-get-size ()
  (interactive)
  (let ((files (dired-get-marked-files)))
    (with-temp-buffer
      (apply 'call-process "/usr/bin/du" nil t nil "-sch" files)
      (message "Size of all marked files: %s"
               (progn 
                 (re-search-backward "\\(^[0-9.,]+[A-Za-z]+\\).*total$")
                  (match-string 1))))))

 (define-key dired-mode-map (kbd "?") 'dired-get-size)
(define-key global-map  "\C-xj"         'dired-jump)
(define-key global-map  "\C-cfd"         'find-dired)

(autoload 'dired-async-mode "dired-async.el" nil t)
;(dired-async-mode 1)
;(dired-collapse-mode)

; (require 'ranger)
(global-set-key (kbd "C-z c c") 'dired-ranger-copy)
(global-set-key (kbd "C-z c a") 'dired-ranger-add)
(global-set-key (kbd "C-z c p") 'dired-ranger-paste)
(treemacs-icons-dired-mode t)
