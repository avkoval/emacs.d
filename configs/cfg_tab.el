; http://stackoverflow.com/questions/69934/set-4-space-indent-in-emacs-in-text-mode

(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
; (setq indent-line-function 'insert-tab)

(add-hook 'text-mode-hook
  (function
   (lambda ()
     (setq tab-width 4)
     (define-key text-mode-map "\C-i" 'self-insert-command)
     )))

(setq tab-stop-list (number-sequence 4 200 4))
