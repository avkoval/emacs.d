;; http://www.emacswiki.org/emacs/FrameTitle
;; display full file name in window title
;;
;; This feature is not yet complete - since it seems org-mode
;; looses current settings after clock-out.
;;

(defun fix-frame-title ()
  (interactive)
  (setq frame-title-format
        '("%S" (buffer-file-name "%f"
                                 (dired-directory dired-directory "%b"))))
  )
(fix-frame-title)
;(add-hook 'after-make-frame-functions 'fix-frame-title)

(define-key global-map  "\C-cft" 'fix-frame-title)
