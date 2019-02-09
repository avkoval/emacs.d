;g from http://www.emacswiki.org/emacs/EmacsNiftyTricks

;(setq default-cursor-type '(bar . 2))

(set-cursor-color "#1e9714")
(setq default-cursor-type 'box)
(unless (boundp 'default-cursor-color-list)
  (setq default-cursor-color-list '("deep sky blue" "red" "#1e9714"))
)

(setq hcz-set-cursor-color-color "")
(setq hcz-set-cursor-color-buffer "")
(defun hcz-set-cursor-color-according-to-mode ()
  "change cursor color according to some minor modes."
  ;; set-cursor-color is somewhat costly, so we only call it when needed:
  (let ((color
	 (if buffer-read-only (nth 0 default-cursor-color-list)
	   (if overwrite-mode (nth 1 default-cursor-color-list)
	     (nth 2 default-cursor-color-list)))))
    (unless (and
	     (string= color hcz-set-cursor-color-color)
	     (string= (buffer-name) hcz-set-cursor-color-buffer))
      (set-cursor-color (setq hcz-set-cursor-color-color color))
      (setq hcz-set-cursor-color-buffer (buffer-name)))))

(defun hcz-set-cursor-color-according-to-mode-dark ()
  "change cursor color according to some minor modes."
  ;; set-cursor-color is somewhat costly, so we only call it when needed:
  (let ((color
	 (if buffer-read-only "yellow"
	   (if overwrite-mode "deep sky blue"
	     "#ff1493"))))
    (unless (and
	     (string= color hcz-set-cursor-color-color)
	     (string= (buffer-name) hcz-set-cursor-color-buffer))
      (set-cursor-color (setq hcz-set-cursor-color-color color))
      (setq hcz-set-cursor-color-buffer (buffer-name)))))

(add-hook 'post-command-hook 'hcz-set-cursor-color-according-to-mode)
