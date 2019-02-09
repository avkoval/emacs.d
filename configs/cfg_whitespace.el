(setq whitespace-style '(face empty tabs lines-tail trailing))
(setq whitespace-line-column 79)

(add-hook 'prog-mode-hook
  (lambda ()
    (whitespace-mode)))

(add-hook 'python-mode-hook
  (lambda ()
    (whitespace-mode)))

; don't show long lines in HTML
(defun my-web-mode-hook ()
  (interactive)
  (whitespace-mode 0)
  (setq-local whitespace-style '(face empty tabs trailing))
  (whitespace-mode 1)
  )

(add-hook 'web-mode-hook
  (lambda ()
    (my-web-mode-hook)))
