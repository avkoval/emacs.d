;;; cfg-default-face --- Changes font faces
;;; Commentary:
;;    The font face is changed for current frame or for default frame creation.
;;    You can set your default font via custom variable: fontify-frame-default-font
;;    or use "C-z f a" keybinding to change font during session

(require 'subr-x)

(defcustom my-frame-default-font "" "Default font used for fontify new frames")

(unless (boundp 'helm-xfonts-cache)
  (defvar helm-xfonts-cache nil))

(defun fontify-frame (frame)
  (unless (= (length my-frame-default-font) 0)
   (set-frame-parameter frame 'font my-frame-default-font))
   )

(fontify-frame nil)
(push 'fontify-frame after-make-frame-functions)

(defun change_font (new-font where &optional size)
  (interactive)
  (let
      ((font-with-size (split-string new-font "-"))
       (size (or size (read-from-minibuffer "Font size: " "14"))))
    (setcar (nthcdr 7 font-with-size) size)
    (let ((new-font-final (string-join font-with-size "-")))
      (if (string= where "default")
          (progn
            (set-face-font 'default new-font-final)
            (setq my-frame-default-font new-font-final))
            (set-frame-parameter nil 'font new-font-final))
        )
    (message (format "Default font set to %s of size %s" new-font size))
    ))


;; (defun my-set-default-font()
;;   (interactive)
;;   (set-face-font 'default my-frame-default-font)
;;   (set-frame-parameter nil 'font my-frame-default-font)
;;   )

;; (advice-add 'my-set-default-font :after 'customize-themes)

(defvar avk-change-default-font18
  (helm-build-sync-source "AVK font selection"
    :init (lambda ()
            (unless helm-xfonts-cache
              (setq helm-xfonts-cache
                    (x-list-fonts "*")))
            )
    :candidates 'helm-xfonts-cache
    :action '(("Set default font" . (lambda (new-font)
                                      (kill-new new-font)
                                      (change_font new-font "default")
                                      ))
              ("Set current frame font" . (lambda (new-font)
                                      (kill-new new-font)
                                      (change_font new-font "frame")
                                ))
              )
    :persistent-action (lambda (new-font)
                         (set-frame-font new-font 'keep-size)
                         (kill-new new-font))
    :persistent-help "Preview font and copy to kill-ring"))

(defun avk-change-default-font-fn ()
  (interactive)
  (helm :sources '(avk-change-default-font18))
  )

(define-key global-map (kbd "C-z f a") 'avk-change-default-font-fn)

; this theme needs explicit require ?
(require 'moe-theme)

;; emoji
(set-fontset-font "fontset-default" '(#x1F300 . #x1F55F) (font-spec :size 20 :name "Unifont Upper"))

;; (use-package circadian
;;   :load-path "~/.emacs.d/config/circadian/"
;;   :ensure t
;;   :config
;;   (setq circadian-themes '(("00:00" . warm-night)
;;                            ("04:00" . base16-materia)
;;                            ("11:00" . avk-daylight)
;;                            ("18:30" . avk-darkblue-yellow)
;;                            ("22:00" . warm-night)))
;;   (circadian-setup))

;;; cfg_default_face.el ends here
