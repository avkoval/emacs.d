(yas-global-mode 1)
(define-key yas-minor-mode-map (kbd "<tab>") nil)
(define-key yas-minor-mode-map (kbd "TAB") nil)
(setq hippie-expand-try-functions-list
      (cons 'yas-hippie-try-expand hippie-expand-try-functions-list))
