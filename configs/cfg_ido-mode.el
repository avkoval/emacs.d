;; http://www.emacswiki.org/cgi-bin/wiki/InteractivelyDoThings

(ido-mode t)
(setq enable-recursive-minibuffers t)

(defun ido-my-keys ()
  "Add my keybindings for ido."
  (when (eq ido-cur-item 'file)
    (define-key ido-mode-map (kbd "ESC DEL") 'ido-delete-backward-updir)
    (define-key ido-mode-map (kbd "C-e") 'ido-my-edit-input)
    (define-key ido-mode-map (kbd "<backspace>") 'ido-my-edit-input)
    ))

(global-set-key [(s tab)] 'ido-switch-buffer) ;; win+Tab

(custom-set-variables
 '(ido-work-directory-list-ignore-regexps (quote (".*")))
 '(ido-max-work-directory-list 500)
 '(ido-max-directory-size 90000)
 '(ido-everywhere t)
 '(ido-enable-flex-matching nil))
