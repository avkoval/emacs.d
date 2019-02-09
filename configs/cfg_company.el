(require 'company)

(setq company-global-modes '(not org-mode))
(global-company-mode 1)
(global-set-key (kbd "C-z C-c") 'company-mode)
