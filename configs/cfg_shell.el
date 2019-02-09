; various shells
(require 'python)
(add-hook 'shell-output-filter-functions
	  '(lambda () "" 
	     (when (shell-interactive-process)
	       (python-pdbtrack-set-tracked-buffer 
            (buffer-substring (shell-beginning-of-output) shell-last-output-end)))))

(global-unset-key (kbd "s-s"))
(defun switch-to-shell(n) ()
  (interactive)
  (if (get-buffer (concat "*shell*<" n ">"))
      (switch-to-buffer (concat "*shell*<" n ">"))
    (shell (concat "*shell*<" n ">")))
)

(global-set-key (kbd "s-s 1") (lambda () (interactive) (switch-to-shell "1")))
(global-set-key (kbd "s-s 2") (lambda () (interactive) (switch-to-shell "2")))
(global-set-key (kbd "s-s 3") (lambda () (interactive) (switch-to-shell "3")))
(global-set-key (kbd "s-s 4") (lambda () (interactive) (switch-to-shell "4")))
(global-set-key (kbd "s-s 5") (lambda () (interactive) (switch-to-shell "5")))
(global-set-key (kbd "s-s 6") (lambda () (interactive) (switch-to-shell "6")))
(global-set-key (kbd "s-s 7") (lambda () (interactive) (switch-to-shell "7")))
(global-set-key (kbd "s-s 8") (lambda () (interactive) (switch-to-shell "8")))
(global-set-key (kbd "s-s 9") (lambda () (interactive) (switch-to-shell "9")))
(global-set-key (kbd "s-s 0") 'shell)
(global-set-key (kbd "s-s e") 'eshell)

(global-set-key (kbd "C-z x 1") (lambda () (interactive) (switch-to-shell "1")))
(global-set-key (kbd "C-z x 2") (lambda () (interactive) (switch-to-shell "2")))
(global-set-key (kbd "C-z x 3") (lambda () (interactive) (switch-to-shell "3")))
(global-set-key (kbd "C-z x 4") (lambda () (interactive) (switch-to-shell "4")))
(global-set-key (kbd "C-z x 5") (lambda () (interactive) (switch-to-shell "5")))
(global-set-key (kbd "C-z x 6") (lambda () (interactive) (switch-to-shell "6")))
(global-set-key (kbd "C-z x 7") (lambda () (interactive) (switch-to-shell "7")))
(global-set-key (kbd "C-z x 8") (lambda () (interactive) (switch-to-shell "8")))
(global-set-key (kbd "C-z x 9") (lambda () (interactive) (switch-to-shell "9")))
(global-set-key (kbd "C-z x 0") 'shell)


; ansi-term
(defun switch-to-ansi-term(n) ()
       (interactive)
       (setq ansi-term-color-vector
             [term term-color-black term-color-red term-color-green term-color-yellow 
                   term-color-blue term-color-magenta term-color-cyan term-color-white])
       (if (get-buffer (concat "**ansi-term<" n ">**"))
           (switch-to-buffer (concat "**ansi-term<" n ">**"))
         (ansi-term "/bin/zsh" (concat "*ansi-term<" n ">*")))
       )

(global-set-key [(control meta menu)] 'pylookup-lookup)
(global-set-key (kbd "C-x a 1") (lambda () (interactive) (switch-to-ansi-term "1")))
(global-set-key (kbd "C-x a 2") (lambda () (interactive) (switch-to-ansi-term "2")))
(global-set-key (kbd "C-x a 3") (lambda () (interactive) (switch-to-ansi-term "3")))
(global-set-key (kbd "C-x a 4") (lambda () (interactive) (switch-to-ansi-term "4")))
(global-set-key (kbd "C-x a 5") (lambda () (interactive) (switch-to-ansi-term "5")))
(global-set-key (kbd "C-x a 6") (lambda () (interactive) (switch-to-ansi-term "6")))
(global-set-key (kbd "C-x a 7") (lambda () (interactive) (switch-to-ansi-term "7")))
(global-set-key (kbd "C-x a 8") (lambda () (interactive) (switch-to-ansi-term "8")))
(global-set-key (kbd "C-x a 9") (lambda () (interactive) (switch-to-ansi-term "9")))
(global-set-key (kbd "C-x a 0") 'ansi-term)

;; http://emacs.stackexchange.com/questions/5585/how-to-copy-command-output-in-ansi-term-mode
(require 'term)
(defun jnm/term-toggle-mode ()
  "Toggles term between line mode and char mode"
  (interactive)
  (if (term-in-line-mode)
      (term-char-mode)
    (term-line-mode)))

(define-key term-mode-map (kbd "C-c C-j") 'jnm/term-toggle-mode)
(define-key term-mode-map (kbd "C-c C-k") 'jnm/term-toggle-mode)

(define-key term-raw-map (kbd "C-c C-j") 'jnm/term-toggle-mode)
(define-key term-raw-map (kbd "C-c C-k") 'jnm/term-toggle-mode)

(global-set-key (kbd "s-s t") '(lambda ()
                                 (interactive)
                                 (call-process "i3-sensible-terminal" nil 0 nil)))

(fset 'myshells
   [?\M-x ?i ?b ?u ?f ?f ?e ?r return ?/ ?/ ?/ ?m ?s ?h ?e ?l ?l ?- ?m ?o ?d ?e return ?s ?f])

(global-set-key (kbd "s-s l") 'myshells)

(defun my-shell-mode-hook ()
  (hide-trailing-whitespace)
  )

(add-hook 'shell-mode-hook 'my-shell-mode-hook)
(add-hook 'term-mode-hook 'my-shell-mode-hook)

;; from http://stackoverflow.com/questions/13185729/npm-dont-display-prompt-correctly-under-emacs-eshell
;; to filter out npm special chars
(add-to-list
         'comint-preoutput-filter-functions
         (lambda (output)
           (replace-regexp-in-string "\033\[[0-9]+[AGK]" "" output)))

(defun ansible-highlight()
  "Hightlight ok, failed, changed lines"
  (interactive)
  (highlight-lines-matching-regexp "^ok:" 'hi-green-b)
  (highlight-phrase "failed:" 'flycheck-error)
  (highlight-phrase "FAILED\!" 'flycheck-error)
  (highlight-lines-matching-regexp "changed:" 'font-lock-warning-face)
  )

(defun sql-highlight()
  "SQL updates, inserts"
  (interactive)
  (highlight-lines-matching-regexp "INSERT\sINTO\s" 'hi-pink)
  (highlight-lines-matching-regexp "DELETE\sFROM\s" 'hi-red-b)
  (highlight-lines-matching-regexp "UPDATE\s" 'hi-yellow)
  )
