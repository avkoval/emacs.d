;; Org-mode settings
(add-to-list 'load-path "/usr/share/emacs/site-lisp/org")
;(add-to-list 'load-path "~/.emacs.d/lisp/ob-async")
(require 'org-checklist)

(when (featurep 'notmuch)
  (require 'org-notmuch)
  )

;; to store links from eww
(require 'org-eww)
(require 'ob-http)
;(require 'org-bullets) - they slow down emacs org mode
(add-to-list 'load-path "~/.emacs.d/lisp/ob-async")
(require 'ob-async)
; (require 'ox-beamer)

(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (http . t)
   (restclient . t)
   (gnuplot . t)
   ))

;; optional exporters
(with-eval-after-load 'ox
  (require 'ox-latex)
  (loop for pkg in '(ox-gfm ox-pandoc ox-reveal ox-confluence ox-md ox-jira ox-textile ox-html5slide ox-ioslide)
        do (unless (require pkg nil 'noerror)
             (message (format "You need to install package %s" pkg))))
)

(require 'org-clock)
(setq org-replace-disputed-keys t)
(setq org-disputed-keys (quote (([(shift up)] . [(control c)(up)]) ([(shift down)] . [(control c)(down)]) ([(shift left)] . [(control c)(left)]) ([(shift right)] . [(control c)(right)]) ([(control shift right)] . [(meta shift +)]) ([(control shift left)] . [(meta shift _)]))))


(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)

(fset 'goto-org-agenda
   "\C-caa")


(global-set-key [XF86HomePage] 'goto-org-agenda)


(global-set-key [(meta f8)]  'org-clock-goto)
(global-set-key "\C-c\C-x\C-j"  'org-clock-goto)
(global-set-key "\C-z`" 'org-clock-in)
(global-set-key "\C-z~" 'org-clock-out)
(fset 'my-clock-in-current-task
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item '("`1" 0 "%d") arg)))
(global-set-key "\C-z1" 'my-clock-in-current-task)

(global-set-key [(control shift f5)] 'org-clock-out)


(global-font-lock-mode 1)

;; temp disabled
;; (defun my-org-mode-hook ()
;;   (local-set-key [(meta tab)] 'ido-switch-buffer)
;;   (local-set-key (kbd "C-z r g") 'org-redmine-get-issue)
;;   (yas-minor-mode)
;;   ;(org-bullets-mode 1)
;;   )
;; (add-hook 'org-mode-hook 'my-org-mode-hook)



(setq org-directory "~/org/")

(setq org-default-notes-file (concat org-directory "/notes.org"))
(define-key global-map "\C-cc" 'org-capture)

(defun org-todo-keyword-faces-dark()
  (interactive)
  (setq org-todo-keyword-faces
	'(
	  ("IDEA" . (:foreground "chartreuse" :weight bold))
	  ("WORKING" . (:foreground "forest green" :weight bold))
	  ("DELEGATE" . (:foreground "deep sky blue" :background "#032251" :weight normal))
	  ("DELEGATED" . (:foreground "LightSteelBlue" :background "#032251" :weight normal))
	  ("REVIEW" . (:foreground "light coral" :background "#032251" :weight normal))
	  ("FEEDBACK" . (:foreground "light coral" :background "#032251" :weight normal))
	  ("TOPAIR" . (:foreground "wheat" :background "#1c4b78" :weight normal))
	  ("ASSIGNED" . (:foreground "green yellow" :background "#032251" :weight normal))
	  ("CANCELLED" . (:foreground "dark green" :background "gray17" :weight bold :strike-through "coral"))
	  ("WORKSFORME" . (:foreground "dark green" :background "gray17" :weight bold :strike-through "coral"))
	  )
	)
)

(defun switch-to-agenda() ()
  (interactive)
  (if (get-buffer "*Org Agenda*")
      (switch-to-buffer "*Org Agenda*")
    (org-agenda))
)
(global-set-key (kbd "s-`") 'switch-to-agenda)


(setq org-completion-use-ido t)

(defun org-todo-keyword-faces-light()
  (interactive)
  (setq org-todo-keyword-faces
	'(
	("WORKING" . (:background "green yellow"))
	("TODO" . (:foreground "DarkSlateBlue" :weight bold))
	("DELEGATE" . (:foreground "black" :background "LightSeaGreen" :weight normal :slant italic))
	("DELEGATED" . (:foreground "DarkSlateBlue" :weight bold :slant italic))
	("REVIEW" . (:foreground "black" :background "LightGoldenrod" :weight normal :slant italic))
	("TOPAIR" . (:foreground "black" :background "PaleTurquoise" :weight normal :slant italic))
	("ASSIGNED" . (:foreground "black" :background "Yellow" :weight normal :slant italic))
	("CANCELLED" . (:foreground "white" :background "dark red" :weight bold :strike-through "coral"))
	("WORKSFORME" . (:foreground "white" :background "dark red" :weight bold :strike-through "coral"))
	)
))

(defun insert-time-with-seconds ()
  (interactive)
  (insert (format-time-string "%H:%M.%S")))


(global-set-key "\C-c0" 'insert-time-with-seconds)

;; (custom-set-variables
;;  '(org-agenda-custom-commands
;;    (quote
;;     (("p" . "Project TODOs")
;;      ("py" "Yacapaca" tags-todo "YP" nil)
;;      ("pt" "Tagvillage" tags-todo "tgv" nil)
;;      ("pb" "BonjourParis" tags-todo "BP" nil)
;;      ("pm" "Miles" tags-todo "miles" nil)
;;      ("p2" "UA2WEB" tags-todo "ua2web" nil)
;;      ("kevin" "Kevin Feltner" tags "kevin" nil)
;;      ("P" "projects GTD Block Agenda"
;;       ((tags-todo "YP" nil)
;;        (tags-todo "tgv" nil)
;;        (tags-todo "BP" nil)
;;        (tags-todo "miles" nil)
;;        (tags-todo "ua2web" nil)
;;        (tags-todo "taxi" nil))
;;       nil
;;       ("~/next-actions.html"))
;;      ("1" "AVK Custom Plan"
;;       ((agenda ""
;;                ((org-agenda-overriding-header "My Today Plan (AVK)")
;;                 (org-agenda-span
;;                  (quote day))))
;;        (todo "WORKING" nil)
;;        (todo "TOPAIR" nil)
;;        (todo "REVIEW" nil))
;;       nil nil))))
;;  '(org-agenda-files
;;    (quote
;;     ("~/org/work.org" "~/org/avk.org" "~/org/notes.org" "~/CData/hdgshare.org" "~/org/journal.org")))
;;  '(org-agenda-prefix-format
;;    (quote
;;     ((agenda . " %i %-6:c%?-12t% s")
;;      (timeline . "  % s")
;;      (todo . " %i %-6:c")
;;      (tags . " %i %-6:c")
;;      (search . " %i %-6:c"))))
;;  '(org-agenda-scheduled-leaders (quote ("S[.]: " "S[x].%2dx:")))
;;  '(org-agenda-skip-scheduled-if-deadline-is-shown nil)
;;  '(org-capture-templates
;;    (quote
;;     (("t" "Todo" entry
;;       (file+headline "~/org/notes.org" "Unsorted Tasks")
;;       "* TODO %?
;;   %i
;;   %a")
;;      ("j" "Journal" entry
;;       (file+datetree "~/org/journal.org")
;;       "* %?
;; Entered on %U
;;   %i
;;   %a")
;;      ("c" "Comment on project code" entry
;;       (file+headline "~/org/notes.org" "Code")
;;       "* TODO %?
;;   %i
;;   %a")
;;      ("m" "Money log" entry
;;       (file+datetree+prompt "~/org/money.org")
;;       "* %?
;; Entered on %U
;;   %i
;;   %a"))))
;;  '(org-clock-mode-line-total (quote all))
;;  '(org-directory "~/org")
;;  '(org-export-html-style
;;    "<style type=\"text/css\">
;;   html {
;; 	font-family: verdana, serif;
;; 	font-size: 12pt;
;;   }
;;   .title { text-align: center; }
;;   .todo  { color: red; }
;;   .done { color: green; }
;;   .timestamp { color: grey }
;;   .timestamp-kwd { color: CadetBlue }
;;   .tag { background-color:lightblue; font-weight:normal }
;;   .target { background-color: lavender; }
;;   pre {
;; 	border: 1pt solid #AEBDCC;
;; 	background-color: #F3F5F7;
;; 	padding: 5pt;
;; 	font-family: courier, monospace;
;;   }
;;   table { border-collapse: collapse; }
;;   td, th {
;; 	vertical-align: top;
;; 	<!--border: 1pt solid #ADB9CC;-->
;;   }
;; </style>")
;;  '(org-file-apps
;;    (quote
;;     ((auto-mode . emacs)
;;      ("\\.mm\\'" . default)
;;      ("\\.x?html?\\'" . emacs)
;;      ("\\.pdf\\'" . default))))
;;  '(org-fontify-done-headline t)
;;  '(org-fontify-emphasized-text t)
;;  '(org-hide-leading-stars t)
;;  '(org-insert-labeled-timestamps-at-point nil)
;;  '(org-log-done (quote time))
;;  '(org-log-into-drawer t)
;;  '(org-log-redeadline (quote time))
;;  '(org-priority-faces (quote ((65 . "red"))))
;;  '(org-replace-disputed-keys t)
;;  '(org-time-stamp-rounding-minutes (quote (5 5)))
;;  '(org-todo-keywords
;;    (quote
;;     ((sequence "IDEA(i!) TODO(t!)" "WORKING(w!)" "SLEEP(s@!)" "|" "DONE(x!)")
;;      (sequence "DELEGATE(e=!)" "DELEGATED(1!)" "FEEDBACK(f!)" "ASSIGNED(a!)" "REVIEW(r!)" "TOPAIR(p!)" "|" "TIMEOK(o!)")
;;      (sequence "DUP(d!)")
;;      (sequence "|" "CANCELLED(c@!)")
;;      (sequence "UNCLEAR(u!)")
;;      (sequence "REJECTED(j!)")
;;      (sequence "WORKSFORME(0!)")))))

(custom-set-faces
 '(org-done ((t (:strike-through t)))))


(defun my-org-insert-current-item-time()
  "Insert HH:MM into the buffer. Used during reporting of work done"
  (interactive)
  (let* (
         (clocked-time (org-clock-get-clocked-time))
         (h (/ clocked-time 60))
         (m (- clocked-time (* 60 h)))
         )
    (insert (format "%.2d:%.2d" h m))
    )
  )


;; (defun display-debug ()
;;   (interactive)
;;   (message (format "%.2f" org-clock-file-total-minutes))
;;   )
(defun my-org-insert-item-report-line()
  "Interactive reporting during work done"
  (interactive)
  (insert-time-with-seconds)
  (insert " (")
  (my-org-insert-current-item-time)
  (insert ") ")
  )

(global-set-key "\C-cit" 'my-org-insert-item-report-line)

(setq org-global-properties
      '(("Effort_ALL". "1:00 2:00 3:00 5:00 8:00 16:00 0:10 0:15 0:30 0")))

(setq org-columns-default-format
      "%40ITEM %5Effort(Estimated Effort){:} %8CLOCKSUM_T %TODO %3PRIORITY %TAGS")

(add-hook 'org-clock-out-hook
  (lambda ()
    (fix-frame-title)))

; http://orgmode.org/worg/org-contrib/babel/languages/ob-doc-dot.html#sec-2
;; (org-babel-do-load-languages
;;  'org-babel-load-languages
;;  '((dot . t))) ; this line activates dot

;; (org-babel-do-load-languages
;;  'org-babel-load-languages
;;  '((ditaa . t)))

;; (org-babel-do-load-languages
;;  'org-babel-load-languages
;;  '((plantuml . t)))

(defun switch-to-orgfile(bufname)
  (if (get-buffer bufname)
      (switch-to-buffer bufname)
    (pop-to-buffer (find-file (concat "~/org/" bufname))))
  )

(defun switch-to-labster()
  (interactive)
  (switch-to-orgfile "labster.org"))

(defun switch-to-work()
  (interactive)
  (switch-to-orgfile "work.org"))

(global-set-key "\C-z\C-l" 'switch-to-labster)
(global-set-key "\C-cw" 'switch-to-work)


(global-set-key (kbd "C-z n") 'helm-org-agenda-files-headings)
(define-key org-mode-map (kbd "C-z !") 'org-time-stamp-inactive)
(define-key org-mode-map (kbd "C-C C-r") 'org-reveal)
(define-key org-mode-map (kbd "C-x <insert>") 'org-meta-return)
(define-key org-mode-map (kbd "C-c b") 'org-tree-to-indirect-buffer)

(custom-set-variables
 '(markdown-command "/usr/bin/pandoc"))


(defun sync-google-calendar ()
  "Save google calender entries into dairy.
See more about this approach at https://www.youtube.com/watch?v=cIzzjSaq2N8&t=339s"
  (interactive)
  ;; (call-process "~/org/get_ical.py" nil 0 nil)
  (call-process "~/org/get_ical.py" nil nil)
  (switch-to-buffer "diary")
  (erase-buffer)
  (save-buffer)
  ;; (delete-file "~/.emacs.d/diary")
  (mapcar (
           lambda (icsfile)
                  (icalendar-import-file icsfile "~/.emacs.d/diary")
                  )
          (file-expand-wildcards "~/org/*.ics"))
  )

;;

(defun copy-password-to-buffer()
  "Yank password property"
  (interactive)
  (let ((password (org-entry-get (point) "password")))
    (kill-new password)
    (gui-set-selection "PRIMARY" password)
    )
  )

(define-key global-map (kbd "C-z p p") 'copy-password-to-buffer)

; https://emacs.stackexchange.com/questions/2952/display-errors-and-warnings-in-an-org-mode-code-block
(defvar org-babel-eval-verbose nil
  "A non-nil value makes `org-babel-eval' display")

; http://kitchingroup.cheme.cmu.edu/blog/2015/01/04/Redirecting-stderr-in-org-mode-shell-blocks/                                       ;
(setq org-babel-default-header-args:sh
'((:prologue . "exec 2>&1") (:epilogue . ":"))
)
; (set-time-zone-rule "GMT-2")

(setq org-babel-default-header-args:bash
'((:prologue . "exec 2>&1") (:epilogue . ":"))
)


(defun org-babel-eval (cmd body)
  "Run CMD on BODY.
If CMD succeeds then return its results, otherwise display
STDERR with `org-babel-eval-error-notify'."
  (let ((err-buff (get-buffer-create " *Org-Babel Error*")) exit-code)
    (with-current-buffer err-buff (erase-buffer))
    (with-temp-buffer
      (insert body)
      (setq exit-code
            (org-babel--shell-command-on-region
             (point-min) (point-max) cmd err-buff))
      (if (or (not (numberp exit-code)) (> exit-code 0)
              (and org-babel-eval-verbose (> (buffer-size err-buff) 0))) ; new condition
          (progn
            (with-current-buffer err-buff
              (org-babel-eval-error-notify exit-code (buffer-string)))
            nil)
        (buffer-string)))))

; (require 'async-org-babel)

; redisplay inline images inline in realtime?
(add-hook 'org-babel-after-execute-hook 'org-redisplay-inline-images)
(add-hook 'org-mode-hook #'yas-minor-mode)
(add-hook 'org-mode-hook (lambda ()
                           (visual-line-mode -1)))
;;

(require 'ox-latex)
(add-to-list 'org-latex-classes
             '("beamer"
               "\\documentclass\[presentation\]\{beamer\}"
               ("\\section\{%s\}" . "\\section*\{%s\}")
               ("\\subsection\{%s\}" . "\\subsection*\{%s\}")
               ("\\subsubsection\{%s\}" . "\\subsubsection*\{%s\}")))

;; https://github.com/unhammer/org-rich-yank
(require 'org-rich-yank)
(define-key org-mode-map (kbd "C-M-y") #'org-rich-yank)


;; org speed keys
;; https://emacs.stackexchange.com/questions/33310/how-to-use-org-mode-speed-commands-speed-keys
;; https://notesyoujustmightwanttosave.blogspot.com/2011/12/org-speed-keys.html?showComment=1535219875417
(defun forward-and-preview ()
    "Go to same level next heading and show preview in dedicated buffer"
    (hide-subtree)
    (org-speed-move-safe (quote outline-next-visible-heading))
    (show-children)
    (org-tree-to-indirect-buffer)
    )
(defun back-and-preview ()
    "Go to same level previous heading and show preview in dedicated buffer"
    (hide-subtree)
    (org-speed-move-safe (quote outline-previous-visible-heading))
    (show-children)
    (org-tree-to-indirect-buffer)
    )
(defun up-back-and-preview ()
    "Go to previous level heading and show preview in dedicated buffer"
    (org-speed-move-safe (quote outline-up-heading))
    (org-tree-to-indirect-buffer)
    (hide-subtree)
    )
(defun up-forward-and-preview ()
    "Go to previous level next heading and show preview in dedicated buffer"
    (org-speed-move-safe (quote outline-up-heading))
    (hide-subtree)
    (org-speed-move-safe (quote outline-next-visible-heading))
    (org-tree-to-indirect-buffer)
    )
(defun inside-and-preview ()
    "Go to next level heading and show preview in dedicated buffer"
    (org-speed-move-safe (quote outline-next-visible-heading))
    (show-children)
    (org-tree-to-indirect-buffer)
    )
(add-to-list 'org-speed-commands-user '("l" inside-and-preview))
(add-to-list 'org-speed-commands-user '("j" forward-and-preview))
(add-to-list 'org-speed-commands-user '("k" back-and-preview))
(add-to-list 'org-speed-commands-user '("J" up-forward-and-preview))
(add-to-list 'org-speed-commands-user '("K" up-back-and-preview))

(setq org-use-speed-commands t)
(setq org-use-speed-commands t)

;; (require 'org-sidebar)
;;

;; https://emacs.stackexchange.com/questions/7211/collapse-src-blocks-in-org-mode-by-default
(defvar org-blocks-hidden nil)
(defun org-toggle-blocks ()
  (interactive)
  (if org-blocks-hidden
      (org-show-block-all)
    (org-hide-block-all))
  (setq-local org-blocks-hidden (not org-blocks-hidden)))
(add-hook 'org-mode-hook 'org-toggle-blocks)
(define-key org-mode-map (kbd "C-c t") 'org-toggle-blocks)
(global-set-key "\C-z'" 'poporg-dwim)
