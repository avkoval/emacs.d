(setq web-mode-markup-indent-offset 2)
(setq web-mode-css-indent-offset 2)
(setq web-mode-code-indent-offset 2)
(setq web-mode-indent-style 2)
(add-to-list 'auto-mode-alist '("\\.html\\'" . web-mode))
(setq web-mode-engines-alist '(("django" . "\\.html\\'") ) )

(add-hook 'web-mode-hook
          '(lambda ()
             (yas-minor-mode)
             (yas-activate-extra-mode 'web-mode)
             (display-line-numbers-mode)
             )
          )

;; ;; http://web-mode.org/
;; (add-hook 'web-mode-before-auto-complete-hooks
;;           '(lambda ()
;;              (let ((web-mode-cur-language
;;                     (web-mode-language-at-pos)))
;;                (if (string= web-mode-cur-language "django")
;;                    (progn
;;                      (message "web-mode: we are here")
;;                      (yas-activate-extra-mode 'web-mode)
;;                      (yas-minor-mode))
;;                  (message "web-mode: not there")
;;                  ))))

(fset 'macro-insert-trans
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item '([23 116 114 97 110 115 tab tab return 25] 0 "%d") arg)))
