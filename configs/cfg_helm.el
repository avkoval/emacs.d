(require 'helm-config)
(require 'helm-files)
(require 'helm-swoop)

; (require 'helm-org-rifle)

(global-set-key [(control f12)] 'helm-mini)
;; (global-set-key [?\s- ] 'helm-buffers-list)
(global-set-key [(shift f9)] 'helm-buffers-list)
(global-set-key [M-f9] 'helm-mark-ring)
(global-set-key [M-f12] 'helm-resume)
(global-set-key (kbd "s-x") 'helm-M-x)
(global-set-key [f4] 'helm-recentf)
(global-set-key [f6] 'helm-mini)
(global-set-key [C-f6] 'helm-buffers-list)
; (global-set-key (kbd "<escape> <f6>") 'helm-projectile-switch-project)
(global-set-key "\C-cv" 'helm-imenu)
(global-set-key (kbd "s-<") 'helm-imenu)
(global-set-key (kbd "s-z") 'helm-imenu)
(global-set-key [(meta f2)] 'helm-imenu)
(global-set-key (kbd "<mouse-9>") 'helm-imenu)
(global-set-key (kbd "C-s-x") 'helm-M-x)
(global-set-key (kbd "C-c -") 'helm-swoop)
(global-set-key (kbd "C-x /") 'helm-surfraw)

(global-set-key [(s-tab)] 'helm-buffers-list)
(global-set-key [(M-s-tab)] 'helm-projectile-switch-to-buffer)
(global-set-key (kbd "C-z C-a") 'helm-mini)
(global-set-key (kbd "C-z C-b") 'helm-buffers-list)
(global-set-key (kbd "C-z C-r") 'helm-recentf)
(global-set-key (kbd "C-z C-r") 'helm-recentf)
(global-set-key (kbd "C-z C-f") 'helm-find-files)
(global-set-key (kbd "C-z f f") 'helm-etags-select)
(global-set-key (kbd "C-z p s") 'helm-pass)
; (global-set-key (kbd "C-c h h") 'helm-comint-input-ring) ;; search history for shell
(global-set-key (kbd "C-c h f") 'helm-firefox-bookmarks)
(global-set-key (kbd "C-c h c") 'helm-chrome-bookmarks)
(global-set-key (kbd "C-c h b") 'helm-bookmarks)
(global-set-key (kbd "C-c h p") 'helm-projectile)
(global-set-key (kbd "C-c h m") 'helm-mark-ring)
(global-set-key (kbd "C-c h r") 'helm-resume)
(global-set-key (kbd "C-c h i") 'helm-org-rifle)
(global-set-key (kbd "C-c h o") 'helm-org-rifle-occur)
(global-set-key (kbd "C-c h a") 'helm-ag)
(global-set-key (kbd "C-c h s s") 'helm-swoop)
(global-set-key (kbd "C-c h s o") 'helm-occur)
(global-set-key [(control S)] 'helm-swoop) ;; ctrl+shift+s
(global-set-key [(control O)] 'helm-occur) ;; ctrl+shift+o
(global-set-key (kbd "C-c h s m") 'helm-multi-swoop)
(global-set-key (kbd "C-c h s a") 'helm-multi-swoop-all)
(global-set-key (kbd "C-c h s p") 'helm-multi-swoop-projectile)
(global-set-key (kbd "C-z H") 'helm-org-in-buffer-headings)

;; (fset 'my-helm-switch-to-shell
;;    [f6 ?s ?h ?e ?l ?l])
;; (global-set-key (kbd "s-s s") 'my-helm-switch-to-shell)

;; from https://github.com/emacs-helm/helm/wiki#grepmarkedfiles2
;; (add-hook 'eshell-mode-hook
;;           #'(lambda ()
;;               (define-key eshell-mode-map
;;                 [remap eshell-pcomplete]
;;                 'helm-esh-pcomplete)))
;; (defun pcomplete/sudo ()
;;   (let ((prec (pcomplete-arg 'last -1)))
;;     (cond ((string= "sudo" prec)
;;            (while (pcomplete-here*
;;                     (funcall pcomplete-command-completion-function)
;;                     (pcomplete-arg 'last) t))))))
;;  (add-hook 'eshell-mode-hook
;;            #'(lambda ()
;;                (define-key eshell-mode-map
;;                  (kbd "M-p")
;;                  'helm-eshell-history)))

(global-set-key (kbd "C-z o") 'helm-occur)
;; (defun my-helm-projectile-ag ()
;;   "Copy current file name into ring before calling ag."
;;   (interactive)
;;   (if (not (eq last-command 'cua-copy-region))
;;         (kill-new (buffer-name)))
;;   (helm-projectile-ag)
;;   )

(global-set-key (kbd "C-c s") 'helm-projectile-ag)
(global-set-key (kbd "C-c d") 'deadgrep)
; (global-set-key (kbd "C-c s") 'helm-projectile-ag)

;; from https://www.reddit.com/r/emacs/comments/4wi7hz/how_do_you_go_through_directories_with_helm/
(define-key helm-find-files-map [(control tab)] 'helm-select-action)
(define-key helm-map (kbd "C-z") 'helm-select-action)
(define-key helm-map (kbd "<tab>")         'helm-execute-persistent-action)
(define-key helm-find-files-map (kbd "C-<backspace>") 'helm-find-files-up-one-level)

;;                                        ;(define-key helm-find-files-map [(M-mouse-4)] 'helm-previous-line)

;; FIXME - this might be *very* useful for Dired+Mouse
;; (define-key helm-find-files-map [(meta mouse-4)] 'helm-next-line)
;; (define-key helm-find-files-map [(meta mouse-5)] 'helm-previous-line)
;; (define-key helm-map [(meta mouse-4)] 'helm-next-line)
;; (define-key helm-map [(meta mouse-5)] 'helm-previous-line)

;; (defun helm-select-candidate-by-mouse (prefix event)
;;   "Select helm candidate by using mouse(click).  With PREFIX, also execute its first action."
;;   (interactive "P\ne")
;;   (if (helm-alive-p)
;;       (progn
;;         (with-helm-buffer
;;           (let* ((posn (elt event 1))
;;                  (cursor (line-number-at-pos (point)))
;;                  (pointer (line-number-at-pos (posn-point posn))))
;;             (helm--next-or-previous-line (if (> pointer cursor)
;;                                              'next
;;                                            'previous)
;;                                          (abs (- pointer cursor)))))
;;         (when prefix (helm-maybe-exit-minibuffer)))
;;     (mouse-drag-region event)))

; (bind-key* "<down-mouse-1>" #'helm-select-candidate-by-mouse)
; (bind-key* "<mouse-1>" #'ignore)

;; (defun meta-mouse-down (prefix event)
;;   "Meta-down to select next candidate."
;;   (interactive "P\ne")
;;   (if (helm-alive-p)
;;       (helm-next-line)
;;     (next-line))
;;   )

;; (defun meta-mouse-up (prefix event)
;;   "Meta-up to select prev candidate."
;;   (interactive "P\ne")
;;   (if (helm-alive-p)
;;       (helm-previous-line)
;;     (previous-line))
;;   )

;; (bind-key* "<M-mouse-4>" #'meta-mouse-up)
;; (bind-key* "<M-mouse-5>" #'meta-mouse-down)
;; (bind-key* "<mouse-1>" #'ignore)

;; (defun helm-mouse-select-candidate (prefix event)
;;   "Select candidate if we are in helm mode."
;;   (interactive "P\ne")
;;   (if (helm-alive-p)
;;       (helm-maybe-exit-minibuffer)
;;     ())
;;   )

;;(bind-key* "<M-down-mouse-1>" #'helm-mouse-select-candidate)

;; helm-dired-history
(require 'savehist)
(add-to-list 'savehist-additional-variables 'helm-dired-history-variable)
(savehist-mode 1)

;; (with-eval-after-load 'dired
;;   (require 'helm-dired-history)
;;   ;; if you are using ido,you'd better disable ido for dired
;;   ;; (define-key (cdr ido-minor-mode-map-entry) [remap dired] nil) ;in ido-setup-hook
;;   (define-key dired-mode-map "," 'dired))


;; https://github.com/emacs-helm/helm/issues/749
(setq helm-buffer-skip-remote-checking t)

;; https://www.reddit.com/r/emacs/comments/7rho4f/now_you_can_use_helm_with_frames_instead_of/
(setq helm-display-function 'helm-display-buffer-in-own-frame
        helm-display-buffer-reuse-frame t
        helm-use-undecorated-frame-option t)

(setq helm-swoop-pre-input-function
      (lambda () (if (boundp 'helm-swoop-pattern)
                     helm-swoop-pattern "")))

(require 'helm-bm)
(global-set-key [(meta f1)] 'helm-bm)
