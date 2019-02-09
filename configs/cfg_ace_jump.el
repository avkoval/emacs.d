;; https://github.com/winterTTr/ace-jump-mode

;; (global-set-key "\M-]" 'ace-jump-mode)
(global-set-key "\M-]" 'avy-goto-char-timer)

(global-set-key "\M-[" 'ace-window)

(autoload
  'ace-jump-mode-pop-mark
  "ace-jump-mode"
  "Ace jump back:-)"
  t)
(eval-after-load "ace-jump-mode"
  '(ace-jump-mode-enable-mark-sync))
(define-key global-map (kbd "C-x x") 'ace-jump-mode-pop-mark)
