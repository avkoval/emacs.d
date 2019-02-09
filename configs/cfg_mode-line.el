;; Mode line setup

(setq-default
 mode-line-format
 '(; Position, including warning for 80 columns
   (:propertize "%4l:" face mode-line-position-face)
   (:eval (propertize "%3c" 'face
                      (if (>= (current-column) 80)
                          'mode-line-80col-face
                        'mode-line-position-face)))
   ; emacsclient [default -- keep?]
   mode-line-client
   " (%p) "
   ; read-only or modified status
   (:eval
    (cond (buffer-read-only
           (propertize " RO " 'face 'mode-line-read-only-face))
          ((buffer-modified-p)
           (propertize " ** " 'face 'mode-line-modified-face))
          (t "      ")))
   "    "
   ; directory and buffer/file name
   "%Z"

 ;  (:propertize (:eval (shorten-directory default-directory 30))
 ;               face mode-line-folder-face)
   (:propertize "%b"
                face mode-line-filename-face)
   ; narrow [default -- keep?]
   " %n "

   ; mode indicators: vc, recursive edit, major mode, minor modes, process, global
   (vc-mode vc-mode)
   "  %["
   (:propertize mode-name
                face mode-line-mode-face)
   "%] "
   (:eval (propertize (format-mode-line minor-mode-alist)
                      'face 'mode-line-minor-mode-face))
   (:propertize mode-line-process
                face mode-line-process-face)
   (global-mode-string global-mode-string)
   "    "
   ; nyan-mode uses nyan cat as an alternative to %p
   ; (:eval (when nyan-mode (list (nyan-create))))
   ))

;; Helper function
(defun shorten-directory (dir max-length)
  "Show up to `max-length' characters of a directory name `dir'."
  (let ((path (reverse (split-string (abbreviate-file-name dir) "/")))
        (output ""))
    (when (and path (equal "" (car path)))
      (setq path (cdr path)))
    (while (and path (< (length output) (- max-length 4)))
      (setq output (concat (car path) "/" output))
      (setq path (cdr path)))
    (when path
      (setq output (concat ".../" output)))
    output))

;; Extra mode line faces
(make-face 'mode-line-read-only-face)
(make-face 'mode-line-modified-face)
(make-face 'mode-line-folder-face)
(make-face 'mode-line-filename-face)
(make-face 'mode-line-position-face)
(make-face 'mode-line-mode-face)
(make-face 'mode-line-minor-mode-face)
(make-face 'mode-line-process-face)
(make-face 'mode-line-80col-face)

(defun mode-line-faces-light()
  (interactive)

  (set-face-attribute 'mode-line nil
		      :foreground "black" :background "#d0e5cc"
		      :inverse-video nil
              :box '(:line-width -1 :color nil :style released-button)
;		      :box '(:line-width 6 :color "#d0e5cc" :style nil)
              )

  (set-face-attribute 'mode-line-inactive nil
		      :foreground "black" :background "SlateGray2"
		      :inverse-video nil
;		      :box '(:line-width 6 :color "SlateGray2" :style nil)
              )

  (set-face-attribute 'mode-line-read-only-face nil
		      :foreground "Firebrick"
		      :weight 'bold
;		      :box '(:line-width 2 :color "MediumBlue")
              )

  (set-face-attribute 'mode-line-modified-face nil
		      :foreground "dark red"
		      :background "#d0e5cc"
;		      :height 150
		      :weight 'bold
;		      :box '(:line-width 2 :color "#4177b8")
              )

  (set-face-attribute 'mode-line-folder-face nil
		      :foreground "gray30")

  (set-face-attribute 'mode-line-filename-face nil
		      :foreground "dark green"
		      :weight 'bold)

  (set-face-attribute 'mode-line-position-face nil
		      :family "Menlo" 
;              :height 100
              )

  (set-face-attribute 'mode-line-mode-face nil
		      :weight 'bold
		      :foreground "RoyalBlue")

  (set-face-attribute 'mode-line-minor-mode-face nil
		      :foreground "DarkSlateBlue"
;		      :height 110
              )

  (set-face-attribute 'mode-line-process-face nil
		      :foreground "LimeGreen")

  (set-face-attribute 'mode-line-80col-face nil
		      :inherit 'mode-line-position-face
		      :foreground "black" :background "#eab700")

  )



(defun mode-line-faces-dark()
  (interactive)
  (set-face-attribute 'mode-line nil
		      :foreground "gray90" :background "#315068"
		      :inverse-video nil
		      :box '(:line-width 2 :color "#315068" :style released-button)
              )


  (set-face-attribute 'mode-line-inactive nil
		      :foreground "gray60" :background "#27313f"
		      :inverse-video nil
		      :box '(:line-width 1 :color "#27313f" :style nil)
              )


  (set-face-attribute 'mode-line-read-only-face nil
		      :foreground "cyan3"
;		      :box '(:line-width 2 :color "cyan3")
              )

  (set-face-attribute 'mode-line-modified-face nil
		      :foreground "white smoke"
		      :background "#007400"
;		      :box '(:line-width 2 :color "chartreuse3")
              )

  (set-face-attribute 'mode-line-folder-face nil
		      :foreground "gray60")

  (set-face-attribute 'mode-line-filename-face nil
		      :foreground "#eab700"
		      :weight 'bold)

  (set-face-attribute 'mode-line-position-face nil
		      :family "Menlo" 
;              :height 100
              )

  (set-face-attribute 'mode-line-mode-face nil
		      :foreground "gray80")

  (set-face-attribute 'mode-line-minor-mode-face nil
		      :foreground "gray40"
;		      :height 110
              )

  (set-face-attribute 'mode-line-process-face nil
		      :foreground "LimeGreen")

  (set-face-attribute 'mode-line-80col-face nil
		      :inherit 'mode-line-position-face
		      :foreground "black" :background "#eab700")
  )
