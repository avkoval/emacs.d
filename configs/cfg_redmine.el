; git clone git://github.com/gongo/org-redmine.git
; https://github.com/gongo/org-redmine

(require 'org-redmine)
(defun org-redmine-curl-args (uri)
  (let ((args '("-X" "GET" "-s" "-f" "--ciphers" "RC4-SHA:RC4-MD5")))
    (append
     args
     (cond (org-redmine-auth-api-key
            `("-G" "-d"
              ,(format "key=%s" org-redmine-auth-api-key)))
           (org-redmine-auth-username
            `("-u"
              ,(format "%s:%s"
                       org-redmine-auth-username (or org-redmine-auth-password ""))))
           (org-redmine-auth-netrc-use '("--netrc"))
           (t ""))
     `(,uri))))
(setq org-redmine-uri "https://<Your Redmine URL>")
(setq org-redmine-auth-api-key "<Please set your Redmine API key here>")

