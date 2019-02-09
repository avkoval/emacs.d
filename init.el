;; Use org-babel to load configuration
(require 'org)

;; In case if there are no package for file I place it to 'lisp'
(add-to-list 'load-path "~/.emacs.d/lisp")

(org-babel-load-file
 (expand-file-name "README.org"
                   user-emacs-directory))


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(helm-firefox-show-structure t t)
 '(helm-idle-delay 0.2 t)
 '(package-selected-packages '(dash auto-compile use-package))
 '(uniquify-buffer-name-style 'post-forward nil (uniquify)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
