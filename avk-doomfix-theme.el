(deftheme avk-doomfix
  "Created 2017-08-01.")

(custom-theme-set-faces
 'avk-doomfix
 `(vertical-border ((t (:foreground "SlateBlue" :background "#1b1b1b"))))
 `(helm-selection ((t (:inherit hl-line :background "gray8"))))
 `(org-agenda-clocking ((t (:background "gray2"))))
 `(cursor ((t (:background "#7fff00"))))
 `(font-lock-variable-name-face ((t (:foreground "forest green"))))
 `(font-lock-type-face ((t (:foreground "royal blue"))))
)

(provide-theme 'avk-doomfix)
