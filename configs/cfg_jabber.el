(require 'helm-misc)
(require 'jabber-keymap)
(defun my-jabber-chat-hook ()
  (hide-trailing-whitespace)
  )

(add-hook 'jabber-chat-hook 'my-jabber-chat-hook)

;;; Jabber Contacts (jabber.el)
(defun helm-jabber-online-contacts ()
  "List online Jabber contacts."
  (with-no-warnings
    (cl-loop for item in (jabber-concat-rosters)
          collect
          (if (get item 'name)
              (cons (get item 'name) item)
            (cons (symbol-name item) item)))))

(defun jabber-talk-to ()
  (interactive)
  (helm :sources '(helm-source-jabber-contacts))
  )

(global-unset-key (kbd "C-z j"))
(global-set-key (kbd "C-z C-j C-j") 'jabber-talk-to)
(global-set-key (kbd "C-z C-j C-l") 'jabber-activity-switch-to)
(global-set-key (kbd "C-z C-j C-c") 'jabber-connect-all)
(global-set-key (kbd "C-z C-j C-d") 'jabber-disconnect)
