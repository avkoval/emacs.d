;; manually installed from:
;; cd ~/.emacs.d/lisp && git clone https://github.com/Alexander-Miller/treemacs.git

; (setq load-path (cons "~/.emacs.d/treemacs" load-path))
; (require 'treemacs)
(global-set-key [f5] 'treemacs)
(global-set-key [M-f5] 'treemacs-projectile)
(global-set-key [(shift f5)] 'treemacs-add-project-to-workspace)
(global-set-key [(control shift f5)] 'treemacs-find-file)

(defun treemacs-my-ignore-files-list (file)
  "The default predicate to detect ignored files.
Will return t when FILE
1) starts with '.#' (lockfiles)
2) starts with 'flycheck_' (flycheck temp files)
3) ends with '~' (backup files)
4) is surrounded with # (auto save files)
5) is '.' or '..' (default dirs)"
  (s-matches? (rx bol
                  (or (seq (or ".#" "flycheck_") (1+ any))
                      (seq (1+ any) ".pyc")
                      (seq "#" (1+ any) "#")
                      (or "." ".."))
                  eol)
              file))

;; (defun treemacs--open-file (&optional window split-func)
;;   "Visit file of the current node.  Split WINDOW using SPLIT-FUNC.
;; Do nothing if current node is a directory.
;; Do not split window if SPLIT-FUNC is nil.
;; Use `next-window' if WINDOW is nil."
;;   (let* ((path     (treemacs--prop-at-point 'abs-path))
;;          (is-file? (f-file? path)))
;;     (if is-file?
;;         (progn
;;           (select-window (or window (next-window)))
;;           (when split-func
;;             (call-interactively split-func)
;;             (call-interactively 'other-window))
;;           (find-file path)
;;           )
;;       (dired path)
;;       )
;;     )
;;   )

(add-hook 'treemacs-mode-hook
          '(lambda ()
                                        ;	     (local-set-key [(s menu)] 'rope-code-assist)
			 (local-set-key [(mouse-3)] 'treemacs-visit-node-no-split)
             )
          )

(define-key treemacs-mode-map [mouse-1] #'treemacs-single-click-expand-action)
