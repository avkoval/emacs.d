(global-set-key [(control f4)] 'flycheck-mode)
(message "Flycheck load")
(require 'flycheck)
(define-key flycheck-mode-map (kbd "C-c ! !") 'org-time-stamp-inactive)
