(require 'notmuch)
(require 'org-notmuch)
(autoload 'notmuch-search "notmuch" nil t)
(autoload 'notmuch-hello "notmuch-hello" nil t)
(autoload 'notmuch-show "notmuch-show" nil t)
(global-set-key (kbd "C-z z") 'notmuch)
(global-set-key (kbd "C-c C-o") 'browse-url-at-point)

;; custom python script for notmuch mail address lookup
(require 'notmuch-address)
(setq notmuch-address-command "~/bin/notmuch_addresses.py")

; mark message as spam from list
(defun notmuch-show-tag-spam ()
  "mark message as spam"
  (interactive)
  (notmuch-search-tag '("+spam" "-inbox" "-unread"))
  (next-line)
  )
(define-key notmuch-search-mode-map "S" 'notmuch-show-tag-spam)

(defun notmuch-show-tag-deleted ()
  "mark message as deleted"
  (interactive)
  (notmuch-search-tag '("+deleted" "-inbox")))

(defun notmuch-show-tag-read ()
  "mark message as read"
  (interactive)
  (notmuch-search-tag '("-unread"))
  (next-line)
)

(define-key notmuch-search-mode-map "d" 'notmuch-show-tag-deleted)
(define-key notmuch-search-mode-map "~" 'notmuch-show-tag-read)
(define-key notmuch-search-mode-map "`" 'notmuch-show-tag-read)

(defun gnus-article-copy-string ()
  "Copy the string in the button to the kill ring."
  (interactive)
  (let ((data (get-text-property (point) 'gnus-string)))
    (when data
      (with-temp-buffer
	(insert data)
	(copy-region-as-kill (point-min) (point-max))
	(message "Copied %s" data)))))

;; Sign messages by default.
(add-hook 'message-setup-hook 'mml-secure-sign-pgpmime)

(custom-set-variables
 '(notmuch-search-oldest-first nil)
 '(notmuch-crypto-process-mime t)
 '(notmuch-message-headers (quote ("Subject" "To" "Cc" "Date" "X-Mailer" "User-Agent")))
 '(notmuch-fcc-dirs "ua2web/INBOX.sent"))

(add-hook 'notmuch-show-hook 'hide-trailing-whitespace)

(defun expand-only-unread-hook ()
  "eexpand only recent unreads"
  (interactive)
  (let ((unread nil)
        (open (notmuch-show-get-message-ids-for-open-messages)))
    (notmuch-show-mapc (lambda ()
                         (when (member "unread" (notmuch-show-get-tags))
                           (setq unread t))))
    (when unread
      (let ((notmuch-show-hook (remove 'expand-only-unread-hook notmuch-show-hook)))
        (notmuch-show-filter-thread "tag:unread")))))

(add-hook 'notmuch-show-hook 'expand-only-unread-hook)
