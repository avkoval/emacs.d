;; Function keys
(global-unset-key (kbd "C-z"))

(global-set-key [f1]  'man)
(global-set-key [(shift f1)] 'helm-man-woman)
(global-set-key [f2]  'save-buffer)
(global-set-key [f3]  'helm-find-files)
;; (global-set-key [f6]  'next-multiframe-window)
;; (global-set-key [f7]  'query-replace) # Use M-% or C-M-% instead
(global-set-key [S-f7]  'search-forward-regexp)
(global-set-key [M-f7]  'query-replace-regexp)
(global-set-key [f8]  'next-error)
(global-set-key [C-f8] 'bookmark-jump)
(global-set-key [(shift f8)] 'previous-error)
(global-unset-key [f9])
(global-set-key [f9]  'ibuffer)
(global-set-key [f11] 'display-line-numbers-mode)
;; f10 - std emacs key binding (menu-bar)
(global-set-key [C-f10] 'menu-bar-mode)
(global-set-key [f12] 'toggle-truncate-lines)
(global-set-key (kbd "C-x t") 'toggle-truncate-lines)
(global-set-key (kbd "C-x b") 'ivy-switch-buffer)

;; man/help
;; (global-set-key [(meta f1)] 'man)

; other function key combinations
(global-set-key [C-f9] 'compile)
(global-set-key [C-f7] 'rgrep)

;; alternative ways to open file
(global-set-key [M-f3] 'find-file) ;; this is using IDO mode/std
(global-set-key [(shift f3)] 'find-file-at-point) ;; this is std. emacs open



;; window movement - <shift> <win> + <arrow key>
(global-set-key [(shift s left)] 'windmove-left)
(global-set-key [(shift s right)] 'windmove-right)
(global-set-key [(shift s up)] 'windmove-up)
(global-set-key [(shift s down)] 'windmove-down)
(global-set-key [(s w)] 'other-window)
(global-set-key [(s q)] 'delete-other-windows)


(global-set-key [mouse-2] 'yank) ;; paste on middle mouse key

(global-unset-key [(control \#)])
(global-set-key [(control \#)] 'comment-or-uncomment-region)
(global-set-key [(control shift z)] 'comment-or-uncomment-region)
(global-set-key [(control shift f7)] 'occur)
(global-set-key [XF86Reload] 'ido-switch-buffer)

;

(global-set-key [Scroll_Lock] 'speedbar)


;; quick manual override of mode switch
;; memoize: c -Control m -Mode
(define-key global-map  "\C-cmj"         'javascript-mode)
(define-key global-map  "\C-cmp"         'python-mode)
(define-key global-map  "\C-cmh"         'html-mode)
(define-key global-map  "\C-cmw"         'web-mode)
(define-key global-map  "\C-cmn"         'nxhtml-mode)
; (define-key global-map  "\C-cmx"         'nxml-mode) / somehow I press it sometimes in org-mode?
(define-key global-map  "\C-cmd"         'django-html-mumamo-mode)
(define-key global-map  "\C-cmc"         'conf-mode)
(define-key global-map  "\C-cmc"         'conf-mode)
(define-key global-map  "\C-cma"         'annotate-mode)
(define-key global-map  "\C-cms"         'speedbar)

(defun show-trailing-whitespace ()
  (interactive)
  (setq show-trailing-whitespace t)
)

(defun hide-trailing-whitespace ()
  (interactive)
  (setq show-trailing-whitespace nil)
)


(global-unset-key [(control z)])
(global-set-key (kbd "C-z a") 'align-regexp)
(global-set-key [C-f5] 'call-last-kbd-macro)
(global-set-key (kbd "C-z !") 'call-last-kbd-macro)

(define-key global-map  "\C-zws"         'show-trailing-whitespace)
(define-key global-map  "\C-zwh"         'hide-trailing-whitespace)
(define-key global-map  "\C-zwd"         'delete-trailing-whitespace)
(defun my-whitespace-newline ()
  (interactive)
  (whitespace-mode t)  
  (whitespace-newline-mode t) 
)
(define-key global-map  "\C-zwn"         'my-whitespace-newline)

;  AV: cua-paste-pop (or use "yank-pop") in reverse
; (global-set-key [(M shift y)] '(lambda () (interactive) (cua-paste-pop -1)))

;
(global-set-key (kbd "C-` qp") 'sql-postgres)
(global-set-key (kbd "C-` qm") 'sql-mysql)
(global-set-key (kbd "C-c t") 'proced)

(global-set-key (kbd "<C-Scroll_Lock>") 'scroll-lock-mode)
(global-set-key "\M- " 'hippie-expand)
(global-set-key (kbd "C-z l") 'display-line-numbers-mode)
(global-set-key (kbd "C-z s") 'whitespace-mode)
(global-set-key (kbd "C-c r") 'revert-buffer)
(global-set-key [(meta f5)] 'revert-buffer)
(global-set-key [(control shift f)] 'find-name-dired)
(global-set-key [M-f11] 'global-hl-line-mode)

;; (defun switch-to-sql ()
;;   (interactive)
;;   (switch-to-buffer '"*SQL*")
;; )
;; (global-set-key [(control f11)] 'switch-to-sql)

(global-set-key [(control f11)] 'scroll-bar-mode)

(defun just-insert-line-above ()
  (interactive)
  (setq c (current-column))
  (move-beginning-of-line 1)
  (newline)
  (move-to-column c)
  )

(global-set-key [ (control insert) ] 'kill-ring-save)
(global-set-key [ (control shift insert) ] 'just-insert-line-above)
(global-set-key [ (control +) ] 'just-insert-line-above)

(define-key global-map  "\C-zd"         'delete-whitespace-rectangle)

(define-key global-map  "\C-c'"         'electric-pair-mode)

; justify
(fset 'justify-region
   [menu ?s ?e ?t ?- ?j ?u ?s ?t tab return ?f tab return])
(define-key global-map  "\C-cj"         'justify-region)


(global-set-key [backtab] 'indent-according-to-mode)
(global-set-key (kbd "<mouse-8>") 'ibuffer)
(global-set-key (kbd "C-z i") 'ibuffer)
(global-set-key (kbd "C-z r n") 'rename-buffer)

; this is for android devices, where Ctrl+Space is occupied by language
; switch
(define-key  global-map  "\C-zm"  'set-mark-command)


;(global-set-key [(control tab)] 'previous-buffer)
(global-set-key (kbd "C-z g") 'magit-status)

(define-key global-map (kbd "C-z t t") 'customize-themes)
(define-key global-map (kbd "C-z r r") 'revert-buffer)
(define-key global-map (kbd "C-c p k") 'projectile-kill-buffers)

(global-set-key [(control f4)] 'flycheck-mode)
(global-set-key (kbd "C-z e") 'zeal-at-point)
(global-set-key [(control escape)] 'delete-other-windows)


;; no idea where to place this function, let it hang here
(defun sort-lines-nocase ()
  (interactive)
  (let ((sort-fold-case t))
    (call-interactively 'sort-lines)))


;; remap alt mouse wheel keys to generate Up/Down
(global-set-key [(meta mouse-4)] 'previous-line)
(global-set-key [(meta mouse-5)] 'next-line)
;
(global-set-key [(control mouse-4)] 'backward-paragraph)
(global-set-key [(control mouse-5)] 'forward-paragraph)
(global-set-key [(control mouse-8)] 'previous-buffer)
(global-set-key [(control mouse-9)] 'next-buffer)

;; (defun visit-magit-diff-file (event &optional promote-to-region)
;;   "Visit file by right mouse click at point in magit-diff."
;;   (interactive)
;;   (mouse-set-point)
;;   (magit-diff-visit-file)
;;   )

;; FIXME: need to mouse-set-point first
(defadvice magit-diff (after switch-to-diff activate)
  (local-set-key [mouse-3] 'magit-diff-visit-file))
;; (add-hook 'magit-diff-mode
;;           '(lambda ()
;;              (local-set-key [mouse-3] '(lamda ()
;;                                               (message "come here")
;;                                               (mouse-set-point)
;;                                               (magit-diff-visit-file)))
;;           ))


;; FIXME
;;(if (require 'gh-md nil 'noerror)
;;    (define-key markdown-mode-map (kbd "C-z r m") 'gh-md-render-buffer))



(defun toggle-frame-split ()
  "If the frame is split vertically, split it horizontally or vice versa.
Assumes that the frame is only split into two."
  (interactive)
  (unless (= (length (window-list)) 2) (error "Can only toggle a frame split in two"))
  (let ((split-vertically-p (window-combined-p)))
    (delete-window) ; closes current window
    (if split-vertically-p
        (split-window-horizontally)
      (split-window-vertically)) ; gives us a split with the other window twice
    (switch-to-buffer nil))) ; restore the original window in this part of the frame

;; I don't use the default binding of 'C-x 5', so use toggle-frame-split instead
(global-set-key (kbd "C-x 5 t") 'toggle-frame-split)

; (global-set-key (kbd "C-x x") 'repeat)
(global-set-key (kbd "C-x z") 'ztree-dir)



(defun geosoft-kill-buffer ()
  "Kill default buffer without the extra questions."
  (interactive)
  (kill-buffer (buffer-name))
  )
(global-set-key [M-delete] 'geosoft-kill-buffer)

; (global-set-key (kbd "C-z C-z") 'suspend-frame)

(fset 'switch-to-tree
   [f9 ?s ?m ?s ?v escape ?< ?\C-s ?Z ?t ?r ?e ?e ?\C-a return])


(global-set-key (kbd "C-c C-t") 'switch-to-tree)
(global-set-key (kbd "s-s m") 'discover-my-major)

(defun insert-file-name ()
  "Insert current file name."
  (interactive)
   (insert (buffer-file-name (window-buffer (minibuffer-selected-window)))))

(defun insert-buffer-name ()
  "Insert current buffer name."
  (interactive)
   (insert (buffer-name (window-buffer (minibuffer-selected-window)))))
(global-set-key (kbd "C-c i f") 'insert-file-name)
(global-set-key (kbd "C-c i b") 'insert-buffer-name)

(defun mouse-yank-at-point (click)
  "Insert the primary selection at the position clicked on.
Move point to the end of the inserted text, and set mark at
beginning.  If `mouse-yank-at-point' is non-nil, insert at point
regardless of where you click."
  (interactive "e")
  ;; Give temporary modes such as isearch a chance to turn off.
  (run-hooks 'mouse-leave-buffer-hook)
  ;; Without this, confusing things happen upon e.g. inserting into
  ;; the middle of an active region.
  (when select-active-regions
    (let (select-active-regions)
      (deactivate-mark)))
  (let ((primary (gui-get-primary-selection)))
    (push-mark (point))
    (insert-for-yank primary)))


(global-set-key [mouse-2] 'mouse-yank-at-point)


(defun shift-region (distance)
  (let ((mark (mark)))
    (save-excursion
      (indent-rigidly (region-beginning) (region-end) distance)
      (push-mark mark t t)
      ;; Tell the command loop not to deactivate the mark
      ;; for transient mark mode
      (setq deactivate-mark nil))))

(defun shift-right ()
  (interactive)
  (shift-region 1))

(defun shift-left ()
  (interactive)
  (shift-region -1))

;; Bind (shift-right) and (shift-left) function to your favorite keys. I use
;; the following so that Ctrl-Shift-Right Arrow moves selected text one
;; column to the right, Ctrl-Shift-Left Arrow moves selected text one
;; column to the left:

(global-set-key [(control <)] 'shift-left)
(global-set-key [(control >)] 'shift-right)

;;
;; speedbar and neotree
; (global-set-key [(meta f7)] 'sr-speedbar-toggle)
(global-set-key [(meta f6)] 'neotree-toggle)
(global-set-key [(S-f3)] 'neotree-find)

(defun fit-window-to-buffer-width (&optional window max-width min-width)
  "Fit WINDOW according to its buffer's width.
WINDOW, MAX-WIDTH and MIN-WIDTH have the same meaning as in
`fit-window-to-buffer'."
  (interactive)
  (let ((fit-window-to-buffer-horizontally 'only))
    (fit-window-to-buffer window nil nil max-width min-width)))

;; https://emacs.stackexchange.com/questions/19126/auto-resize-window-widths-to-accomodate-line-length
(defun fit-window-to-buffer-width (&optional window max-width min-width)
  "Fit WINDOW according to its buffer's width.
WINDOW, MAX-WIDTH and MIN-WIDTH have the same meaning as in
`fit-window-to-buffer'."
  (interactive)
  (let ((fit-window-to-buffer-horizontally 'only))
    (fit-window-to-buffer window nil nil max-width min-width)))

(defun fit-window-to-buffer-height (&optional window max-height min-height)
  "Fit WINDOW according to its buffer's height.
WINDOW, MAX-HEIGHT and MIN-HEIGHT have the same meaning as in
`fit-window-to-buffer'."
  (interactive)
  (let ((fit-window-to-buffer-horizontally nil))
    (fit-window-to-buffer window max-height min-height nil nil)))

(defun fit-window-to-buffer-height-or-width
    (&optional window max-height min-height max-width min-width)
  "Fit WINDOW according to its buffer's height and width.
WINDOW, MAX-HEIGHT, MIN-HEIGHT, MAX-WIDTH and MIN-WIDTH have the same meaning
as in `fit-window-to-buffer'."
  (interactive)
  (let ((fit-window-to-buffer-horizontally t))
    (fit-window-to-buffer window max-height min-height max-width min-width)))

(global-set-key (kbd "C-x w w") 'fit-window-to-buffer-width)
(global-set-key (kbd "C-x w h") 'fit-window-to-buffer)

(fset 'org-insert-task-from-redmine
   [?\[ ?\[ ?\C-y ?\C-  C-left ?\M-w C-right ?\] ?\[ ?\C-y ?\] ?\]])

(fset 'close-frame-below
   [S-s-down ?\C-x ?0])
(fset 'close-frame-up
   [S-s-up ?\C-x ?0])
(fset 'close-frame-right
   [S-s-right ?\C-x ?0])
(fset 'close-frame-left
   [S-s-left ?\C-x ?0])
(global-set-key (kbd "C-x 9 d") 'close-frame-below)
(global-set-key (kbd "C-x 9 u") 'close-frame-up)
(global-set-key (kbd "C-x 9 l") 'close-frame-left)
(global-set-key (kbd "C-x 9 r") 'close-frame-right)

;; LastPass replacement - this macro will find password in my password storage and place it
;; into clipboard
(fset 'find-password
   [?\C-c ?a ?s ?\C-y return ?\C-s ?p ?a ?s ?s ?w ?d return return ?\C-z ?p ?p])

(defun copy-file-name-to-clipboard ()
  "Copy the current buffer file name to the clipboard."
  (interactive)
  (let ((filename (if (equal major-mode 'dired-mode)
                      default-directory
                    (buffer-file-name))))
    (when filename
      (kill-new filename)
      (message "Copied buffer file name '%s' to the clipboard." filename))))
(global-set-key (kbd "C-c F") 'copy-file-name-to-clipboard)

(defun xml-pretty-print (beg end &optional arg)
  "Reformat the region between BEG and END.
    With optional ARG, also auto-fill."
  (interactive "*r\nP")
  (let ((fill (or (bound-and-true-p auto-fill-function) -1)))
    (sgml-mode)
    (when arg (auto-fill-mode))
    (sgml-pretty-print beg end)
    (nxml-mode)
    (auto-fill-mode fill)))

;; (global-set-key (kbd "C-c x") 'xml-pretty-print)

(global-set-key (kbd "M-\\") 'shrink-whitespace)

(fset 'insert_org_fileref
   [?\C-x ?\C-s C-f9 ?\C-  ?\C-a ?m ?v ?  ?\C-y ?  ?. return ?\[ ?\[ ?f ?i ?l ?e ?: ?\C-u escape ?! ?b ?a ?s ?e ?n ?a ?m ?e ?  ?\C-y return ?\C-e ?\] ?\] ?\C-a ?\C-e return])

;; foward/backward whitespace
(global-set-key (kbd "M-F") 'forward-whitespace)

(fset 'replace_selected_with_clipboard
   [?\C-x ?r ?s ?1 ?\C-  ?\C-e ?\C-g ?\C-  C-left C-left C-left C-left ?\C-x ?\( ?\C-x ?r ?s ?1 ?\C-x ?b ?t ?e ?m ?p ?_ ?c ?l ?i ?b backspace ?p ?b ?o ?a ?r ?d ?. ?t ?m ?p return ?\C-y ?\C-  ?\C-a ?\C-w ?\C-x ?k return ?\C-a f7 ?\C-x ?r ?i ?1 return ?\C-y return ?\C-x])


(defun replace-selected-with-clipboard()
  "Replace marked with contents of x-clipboard.
This happends quite often when I need to replace some string in my file
with something already in clipboard."
  (interactive)
  (let ((emacs-selected (buffer-substring (mark) (point)))
        (x-clipboard (gui--selection-value-internal 'CLIPBOARD)))
    (beginning-of-line)
    (message emacs-selected)
    (query-replace emacs-selected x-clipboard)
    )
  )

(global-set-key (kbd "C-x 6 x") 'replace-selected-with-clipboard)

(global-set-key (kbd "M-g l") 'avy-goto-line)
(global-set-key "\C-z+" 'ivy-push-view)
(global-set-key "\C-z-" 'ivy-pop-view)
(global-set-key "\C-z=" 'imenu-list)

(fset 'close-other-window
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item '("o0" 0 "%d") arg)))

(global-set-key "\C-z0" 'close-other-window)

(defun my-clipboard-browse ()
  "Replacement of CopyQ and other clipboard managers"
  (interactive)
  (switch-to-buffer "*kill-ring-paste*")
  (erase-buffer)
  (helm-show-kill-ring)
)
