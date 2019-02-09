;; ;;; python-mode site-lisp configuration

;; (require 'compile)

(if (fboundp 'elpy-enable)
    (elpy-enable)
  (message "Not enabling elpy as module not loaded"))
;(setq load-path (cons "~/.emacs.d/" load-path))

;; ; (setq load-path (cons "/usr/share/emacs/site-lisp/python-mode" load-path))
;; ;; (setq auto-mode-alist
;; ;;       (cons '("\\.py$" . python-mode) auto-mode-alist))
;; ;; (add-to-list 'auto-mode-alist '("\\.doctest$" . doctest-mode))
;; ;; (setq interpreter-mode-alist
;; ;;       (cons '("python" . python-mode)
;; ;;             interpreter-mode-alist))
;; ;; (autoload 'python-mode "python-mode" "Python editing mode." t)
;; ;; (autoload 'doctest-mode "doctest-mode" "Editing mode for Python Doctest examples." t)
;; ; (require 'pycomplete)


;; ;; this is for python-mode.el from Barry
;; ;; (autoload 'python-mode "python-mode" "Python Mode." t)
;; ;; (add-to-list 'auto-mode-alist '("\\.py\\'" . python-mode))
;; ;; (add-to-list 'interpreter-mode-alist '("python" . python-mode))
;; ;; (defun run-python (&rest args) nil)
;; ;; (defun python-mode (&rest args) nil)
;; ;; (defun jython-mode (&rest args) nil)
;; ;; (defun python-shell (&rest args) nil)
;; ;; (require 'python-mode)
;; ;; end barry

;; ;; this is for old school python.el, https://github.com/leoliu/python-el.git
;; ;; (setq load-path (cons "~/.emacs.d/python-el/" load-path))
;; ;; (require 'python)

;; ; pymacs & rope
(setq pymacs-python-command "/usr/bin/python3")
;; (require 'pymacs)

;(if (fboundp 'pymacs-load)
;    (pymacs-load "ropemacs" "rope-")
;  (message "Pymacs not installed, not loading ropemacs and rope"))

;; (setq ropemacs-enable-autoimport t)

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;; Auto-completion
;; ;;; from http://www.enigmacurry.com/2009/01/21/autocompleteel-python-code-completion-in-emacs/
;; ;;;  Integrates:
;; ;;;   1) Rope
;; ;;;   2) Yasnippet
;; ;;;   all with AutoComplete.el
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; (defun prefix-list-elements (list prefix)
;; ;;   (let (value)
;; ;;     (nreverse
;; ;;      (dolist (element list value)
;; ;;       (setq value (cons (format "%s%s" prefix element) value))))))
;; ;; (defvar ac-source-rope
;; ;;   '((candidates
;; ;;      . (lambda ()
;; ;;          (prefix-list-elements (rope-completions) ac-target))))
;; ;;   "Source for Rope")
;; ;; (defun ac-python-find ()
;; ;;   "Python `ac-find-function'."
;; ;;   (require 'thingatpt)
;; ;;   (let ((symbol (car-safe (bounds-of-thing-at-point 'symbol))))
;; ;;     (if (null symbol)
;; ;;         (if (string= "." (buffer-substring (- (point) 1) (point)))
;; ;;             (point)
;; ;;           nil)
;; ;;       symbol)))
;; ;; (defun ac-python-candidate ()
;; ;;   "Python `ac-candidates-function'"
;; ;;   (let (candidates)
;; ;;     (dolist (source ac-sources)
;; ;;       (if (symbolp source)
;; ;;           (setq source (symbol-value source)))
;; ;;       (let* ((ac-limit (or (cdr-safe (assq 'limit source)) ac-limit))
;; ;;              (requires (cdr-safe (assq 'requires source)))
;; ;;              cand)
;; ;;         (if (or (null requires)
;; ;;                 (>= (length ac-target) requires))
;; ;;             (setq cand
;; ;;                   (delq nil
;; ;;                         (mapcar (lambda (candidate)
;; ;;                                   (propertize candidate 'source source))
;; ;;                                 (funcall (cdr (assq 'candidates source)))))))
;; ;;         (if (and (> ac-limit 1)
;; ;;                  (> (length cand) ac-limit))
;; ;;             (setcdr (nthcdr (1- ac-limit) cand) nil))
;; ;;         (setq candidates (append candidates cand))))
;; ;;     (delete-dups candidates)))
;; ;; (add-hook 'python-mode-hook
;; ;;           (lambda ()
;; ;;                  (auto-complete-mode 1)
;; ;;                  (set (make-local-variable 'ac-sources)
;; ;;                       (append ac-sources '(ac-source-rope) '(ac-source-yasnippet)))
;; ;;                  (set (make-local-variable 'ac-find-function) 'ac-python-find)
;; ;;                  (set (make-local-variable 'ac-candidate-function) 'ac-python-candidate)
;; ;;                  (set (make-local-variable 'ac-auto-start) nil)))

;; ;; ;;Ryan's python specific tab completion
;; ;; (defun ryan-python-tab ()
;; ;;   ; Try the following:
;; ;;   ; 1) Do a yasnippet expansion
;; ;;   ; 2) Do a Rope code completion
;; ;;   ; 3) Do an indent
;; ;;   (interactive)
;; ;;   (if (eql (ac-start) 0)
;; ;;       (indent-for-tab-command)))

;; ;; (defadvice ac-start (before advice-turn-on-auto-start activate)
;; ;;   (set (make-local-variable 'ac-auto-start) t))
;; ;; (defadvice ac-cleanup (after advice-turn-off-auto-start activate)
;; ;;   (set (make-local-variable 'ac-auto-start) nil))

;; ;(define-key python-mode-map "\t" 'ryan-python-tab)
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;; End Auto Completion
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; ;(define-key python-mode-map "\t" 'ryan-python-tab)

;; ; django
;; ;; (define-skeleton django-trans
;; ;;   "django translate template tag"
;; ;;   nil
;; ;;   "{% trans '" _ "' %}")
;; ;; (define-key global-map  "\C-xt"         'django-trans)

;; ;; (define-skeleton django-trans
;; ;;   "django translate template tag"
;; ;;   nil
;; ;;   "{% trans '" _ "' %}")
;; ;; (define-key global-map  "\C-xt"         'django-trans)

;; ;; (define-skeleton redmine-pre-python-class
;; ;;   "redmine pre for region"
;; ;;   nil
;; ;;   "<pre><code class=\"python\">" _ "</code></pre>")
;; ;; (define-key global-map  "\C-cpp"         'redmine-pre-python-class)


;; ;; (define-skeleton django-trans-str
;; ;;   "django translate string"
;; ;;   nil
;; ;;   "_(" _ ")")
;; ;; (define-key global-map  "\C-xj"         'django-trans-str)


;; ; AV: save place and rope-goto-definition
;; (defun rope-goto-definition-save-place ()
;;    """ save current place as 'save-place' bookmark and rope-goto-definition """
;;    (interactive)
;;    (bookmark-set "save-place" 1)
;;    (rope-goto-definition)
;; )

;; ; AV: return to saved place of rope-goto-definition-save-place
;; (defun rope-return ()
;;    """ save current place as 'save-place' bookmark and rope-goto-definition """
;;    (interactive)
;;    (bookmark-jump "save-place")
;; )

;; (global-set-key [(M return)] 'rope-goto-definition-save-place)
;; (global-set-key [(M shift return)] 'rope-return)

;; ; (require 'gpycomplete)


;; ; django/html
;; (defvar django-tag-face (make-face 'django-tag-face))
;; (defvar django-variable-face (make-face 'django-variable-face))
;; (defvar django-comment-face (make-face 'django-comment-face))
;; ;(set-face-background 'django-tag-face "#306141")
;; ;(set-face-foreground 'django-tag-face "gray")

;; ;(set-face-foreground 'django-variable-face "yellow green")
;; ;(set-face-foreground 'django-comment-face "gray30")


;; (font-lock-add-keywords
;;  'html-mode
;;  '(("\\({%[^%]*%}\\)" 1 django-tag-face prepend)
;;    ("\\({#[^%]*#}\\)" 1 django-comment-face prepend)
;;    ("\\({{[^}]*}}\\)" 1 django-variable-face prepend)))

;; ; pylint
;; ; (require 'python-pylint)
;; ; (global-set-key (kbd "C-c p l") 'pylint)

;; ; pep8
                                        ;(require 'python-pep8)
(defun pycodestyle-current-buffer()
  (interactive)
  (compile (concat "pycodestyle " (buffer-file-name)) nil)
  )

(global-set-key (kbd "C-c p 8") 'pycodestyle-current-buffer)

;; ; moving blocks around
;; (defun unindent-dwim (&optional count-arg)
;;   "Keeps relative spacing in the region.  Unindents to the next multiple of the current tab-width"
;;   (interactive)
;;   (let ((deactivate-mark nil)
;;         (beg (or (and mark-active (region-beginning)) (line-beginning-position)))
;;         (end (or (and mark-active (region-end)) (line-end-position)))
;;         (min-indentation)
;;         (count (or count-arg 1)))
;;     (save-excursion
;;       (goto-char beg)
;;       (while (< (point) end)
;;         (add-to-list 'min-indentation (current-indentation))
;;         (forward-line)))
;;     (if (< 0 count)
;;         (if (not (< 0 (apply 'min min-indentation)))
;;             (error "Can't indent any more.  Try `indent-rigidly` with a negative arg.")))
;;     (if (> 0 count)
;;         (indent-rigidly beg end (* (- 0 tab-width) count))
;;       (let (
;;             (indent-amount
;;              (apply 'min (mapcar (lambda (x) (- 0 (mod x tab-width))) min-indentation))))
;;         (indent-rigidly beg end (or
;;                                  (and (< indent-amount 0) indent-amount)
;;                                  (* (or count 1) (- 0 tab-width))))))))

;; (defun indent-dwim ()
;;   "Reverse back unindent-dwim"
;;   (interactive)
;;   (unindent-dwim -1)
;;   (unindent-dwim)
;; )


;; ;; (defun py-to-start-of-class()
;; ;;   (interactive)
;; ;;   (py-beginning-of-def-or-class 'class)
;; ;; )

;; ;; (defun py-to-end-of-class()
;; ;;   (interactive)
;; ;;   (py-end-of-def-or-class 'class)
;; ;; )

;; (defun add-rope-to-ac-sources()
;;   (interactive)
;;   (set (make-local-variable 'ac-sources)
;;      (append ac-sources '(ac-ac-source-ropemacs)))
;; )

;; (defun ac-rope-setup ()
;;   (interactive)
;;   (setq ac-sources (append ac-sources '(ac-source-ropemacs))))


;; (add-hook 'python-mode-hook
;;           '(lambda ()
;;                                         ;	     (local-set-key [(s menu)] 'rope-code-assist)
;;              (global-set-key [(control shift menu)] 'pylookup-lookup)

;;                                         ;	     (local-set-key [(s up)] 'python-move-to-start-of-class)
;;                                         ;	     (local-set-key [(s down)] 'python-move-to-end-of-class)
;;              (local-set-key [(meta up)] 'python-nav-beginning-of-block)
;;              (local-set-key [(meta down)] 'python-nav-end-of-block)
;;                                         ;	     (local-set-key (kbd "C-c C-a") 'python-move-to-start-of-class)
;;                                         ;	     (local-set-key (kbd "C-c C-e") 'python-move-to-end-of-class)
;;              (local-set-key (kbd "C-c >") 'python-indent-shift-right)
;;              (local-set-key (kbd "C-c <") 'python-indent-shift-left)
;;              (linum-mode t)
;;              (define-key python-mode-map "\r" 'newline-and-indent))
;;           )

(add-hook 'python-mode-hook
          '(lambda ()
                                        ;	     (local-set-key [(s menu)] 'rope-code-assist)
             (global-set-key [(control shift menu)] 'pylookup-lookup)
             (local-set-key (kbd "C-c >") 'python-indent-shift-right)
             (local-set-key (kbd "C-c <") 'python-indent-shift-left)
             (local-set-key [(control up)] 'backward-paragraph)
			 (local-set-key [(control down)] 'forward-paragraph)
;             (local-set-key [mouse-3] 'helm-imenu)
             (display-line-numbers-mode t)
             (define-key python-mode-map "\r" 'newline-and-indent))
          )


(define-key global-map (kbd "C-z p l") 'pylookup-lookup)
(define-key global-map (kbd "C-z C-o") 'pylookup-lookup)

;; (fset 'macro-ugettext_new
;;    (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ([24 114 105 97 right right right] 0 "%d")) arg)))



;; (fset 'macro-ugettextlazy
;;    [?_ ?\( ?\C-s ?\' ?\C-s right left ?\) left left ?\C-r ?\' left left])

;; ;; (fset 'python-move-to-start-of-class
;; ;;    [(menu-bar) Python Go\ to\ start\ of\ class])

;; ;; (fset 'python-move-to-end-of-class
;; ;;    [(menu-bar) Python Move\ to\ end\ of\ class])


;; ; folding?
;; ; this get called after python mode is enabled
;; ;; (add-hook 'python-mode-hook 'outline-minor-mode)
;; ;; (setq outline-minor-mode-prefix (kbd "C-;"))


;; ; create empty __init__.py at the place
(defun python-create-empty-init-py()
  (interactive)
  (shell-command "touch __init__.py")
)
(global-set-key (kbd "C-z p i") 'python-create-empty-init-py)


(defun create-TAGS()
  (interactive)
  (shell-command "find . -type f -name '*.py' | xargs etags")
)
(global-set-key (kbd "C-x p t") 'create-TAGS)


;; (global-set-key [(control menu)] 'rope-lucky-assist)


(defun elpy-nav-backward-block()
  (interactive)
  (backward-paragraph)
)

(defun elpy-nav-forward-block()
  (interactive)
  (forward-paragraph)
)

(defun elpy-show-current-func()
  (interactive)
  (let ((current-defun (python-info-current-defun)))
    (when current-defun
      (message (format "In: %s()" current-defun))))
  )
(global-set-key (kbd "C-z f d") 'elpy-show-current-func)

;; https://github.com/marcwebbie/auto-virtualenv
(setq load-path (cons "~/.emacs.d/lisp/auto-virtualenv/" load-path))
(require 'auto-virtualenv)
(setq auto-virtualenv-verbose t)

(defun auto-virtualenv-set-virtualenv-interactive ()
  "Interactive call to set virtualenv"
  (interactive)
  (auto-virtualenv-set-virtualenv)
  )

(global-set-key (kbd "C-z p v") 'auto-virtualenv-set-virtualenv-interactive)
;; (add-hook 'python-mode-hook 'auto-virtualenv-set-virtualenv)



;; (defun check-pyenv()
;;   (interactive)
;;   (auto-virtualenv-set-virtualenv)
;;   )

;; (require 'lsp-mode)
;; (lsp-define-stdio-client lsp-python "python"
;;                          #'projectile-project-root
;;                          '("pyls"))


;; (use-package lsp-mode
;;   :ensure t
;;   :config

;;   ;; make sure we have lsp-imenu everywhere we have LSP
;;   (require 'lsp-imenu)
;;   (add-hook 'lsp-after-open-hook 'lsp-enable-imenu)  
;;   ;; get lsp-python-enable defined
;;   ;; NB: use either projectile-project-root or ffip-get-project-root-directory
;;   ;;     or any other function that can be used to find the root directory of a project
;;   (lsp-define-stdio-client lsp-python "python"
;;                            #'projectile-project-root
;;                            '("pyls"))

;;   ;; make sure this is activated when python-mode is activated
;;   ;; lsp-python-enable is created by macro above 
;;   (add-hook 'python-mode-hook
;;             (lambda ()
;;               (lsp-python-enable)))

;;   ;; lsp extras
;;   (use-package lsp-ui
;;     :ensure t
;;     :bind (("C-z =" . lsp-ui-imenu))
;;     :config
;;     (setq lsp-ui-sideline-ignore-duplicate nil)
;;     (add-hook 'lsp-mode-hook 'lsp-ui-mode))

;;   (use-package company-lsp
;;     :config
;;     (push 'company-lsp company-backends))

  ;; NB: only required if you prefer flake8 instead of the default
  ;; send pyls config via lsp-after-initialize-hook -- harmless for
  ;; other servers due to pyls key, but would prefer only sending this
  ;; when pyls gets initialised (:initialize function in
  ;; lsp-define-stdio-client is invoked too early (before server
  ;; start)) -- cpbotha
  ;; (defun lsp-set-cfg ()
  ;;   (let ((lsp-cfg `(:pyls (:configurationSources ("flake8")))))
  ;;     ;; TODO: check lsp--cur-workspace here to decide per server / project
  ;;     (lsp--set-configuration lsp-cfg)))

  ;; (add-hook 'lsp-after-initialize-hook 'lsp-set-cfg)
;;  )

;; (require 'lsp-mode)
;; (require 'lsp-python)
;; (add-hook 'python-mode-hook #'lsp-python-enable)

