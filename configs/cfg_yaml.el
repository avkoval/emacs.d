(add-hook 'yaml-mode-hook 'highlight-indentation-mode)

;; https://stackoverflow.com/questions/12648388/emacs-yaml-editing

(defun yaml-next-field ()
  "Jump to next yaml field"
  (interactive)
  (search-forward-regexp ": *"))

(defun yaml-prev-field ()
  "Jump to next yaml field"
  (interactive)
  (search-backward-regexp ": *"))

(add-hook 'yaml-mode-hook
          (lambda ()
            (display-line-numbers-mode t)
            (define-key yaml-mode-map "\C-m" 'newline-and-indent)
            (define-key yaml-mode-map "\M-\r" 'insert-ts)
            (define-key yaml-mode-map (kbd "C-<tab>") 'yaml-next-field)
            (define-key yaml-mode-map (kbd "C-S-<tab>") 'yaml-prev-field)
            )
          )

(require 'indent-tools)
(global-set-key (kbd "C-c .") 'indent-tools-hydra/body)
