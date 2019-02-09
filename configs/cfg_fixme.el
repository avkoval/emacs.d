
;; (defun add-something-to-mode-hooks (mode-list something)
;;   "helper function to add a callback to multiple hooks"
;;   (dolist (mode mode-list)
;;     (add-hook (intern (concat (symbol-name mode) "-mode-hook")) something)))

;; (add-something-to-mode-hooks '(prog yaml) 'turn-on-fic-mode)
(require 'hl-todo)
(global-hl-todo-mode)
