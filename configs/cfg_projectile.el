;;https://github.com/bbatsov/projectile/issues/358
(require 'projectile)
; (projectile-global-mode)
(setq projectile-enable-caching t)
; helm-projectile
(require 'helm-projectile)
(helm-projectile-on)
;(defalias 'helm-buffer-match-major-mode 'helm-buffers-list--match-fn)
(global-set-key (kbd "C-c p h") 'helm-projectile)
(global-set-key (kbd "C-c p k") 'projectile-kill-buffers)

; https://github.com/bbatsov/projectile/issues/1183
;(setq projectile-mode-line
;         '(:eval (format " Projectile[%s]"
;                        (projectile-project-name))))

(setq projectile-file-exists-local-cache-expire (* 5 60))

;; (defadvice projectile-on (around exlude-tramp activate)
;;   "This should disable projectile when visiting a remote file"
;;   (unless  (--any? (and it (file-remote-p it))
;;                    (list
;;                     (buffer-file-name)
;;                     list-buffers-directory
;;                     default-directory
;;                     dired-directory))
;;     ad-do-it))
(setq projectile-mode-line "Pt")
