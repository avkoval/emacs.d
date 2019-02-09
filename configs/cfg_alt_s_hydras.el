(require 'hydra)
(defun copy-current-buffer-name()
  (interactive)
  (kill-new (buffer-name))
  )
(defhydra alt_s_hydras_menu (:columns 2 :exit t)
  "M-s menu"

  ("." isearch-forward-symbol-at-point "Isearch symbol at point")
  ("_" isearch-forward-symbol "Do incremental search forward for a symbol")
  ("o" occur "Show occurencies")
  ("f" copy-current-buffer-name "Remember current buffer name")
  ("w" isearch-forward-word "Isearch forward word")
  ("h." highlight-symbol-at-point "Highlight symbol at point")
  ("hl" highlight-lines-matching-regexp "Highlight lines matcing RegExp")
  ("hp" highlight-phrase "Highlight phrase")
  ("hr" highlight-regexp "Highlight RegExp")
  ("hu" unhighlight-regexp "Unhighlight RegExp")
  ("hw" hi-lock-write-interactive-patterns "Write interactive patterns")
  ("M-w" eww-search-words "Search the web for the text")
  )
(global-set-key "\M-s" 'alt_s_hydras_menu/body)
