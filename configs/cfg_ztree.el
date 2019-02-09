;;;
;; Ztree is very good directory tree display
(require 'ztree)
(defun ztree-do-dired ()
  (interactive)
  "Jump to dired in specified place of ZTree-dir"
  (let* ((line (line-number-at-pos))
         (node (ztree-find-node-in-line line)))
    (when node
      (dired node))
    )
  )
(define-key ztree-mode-map (kbd "D") 'ztree-do-dired)
; (global-set-key [f5] 'ztree-dir)
(global-set-key (kbd "C-x <f5>") 'ztree-dir)
(global-set-key (kbd "M-<f3>") 'ztree-dir)

(fset 'ztree-side
   [?\C-x ?z return ?\C-x ?3 ?\C-x ?\C-- ?\C-x ?w ?w ?\s-w ?\C-x right ?\s-w])
(global-set-key (kbd "<C-f3>") 'ztree-side)
