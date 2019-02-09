;; Open files in Docker containers like so: /docker:drunk_bardeen:/etc/passwd
(push
 (cons
  "docker"
  '((tramp-login-program "docker")
    (tramp-login-args (("exec" "-it") ("%h") ("/bin/sh")))
    (tramp-remote-shell "/bin/sh")
    (tramp-remote-shell-args ("-i") ("-c"))))
 tramp-methods)

(defadvice tramp-completion-handle-file-name-all-completions
  (around dotemacs-completion-docker activate)
  "(tramp-completion-handle-file-name-all-completions \"\" \"/docker:\" returns
    a list of active Docker container names, followed by colons."
  (if (equal (ad-get-arg 1) "/docker:")
      (let* ((dockernames-raw (shell-command-to-string "docker ps | awk '$NF != \"NAMES\" { print $NF \":\" }'"))
             (dockernames (cl-remove-if-not
                           #'(lambda (dockerline) (string-match ":$" dockerline))
                           (split-string dockernames-raw "\n"))))
        (setq ad-return-value dockernames)
        (message dockernames)
        )
    ad-do-it))

;; Problem with su: often many system accounts are hidden under /sbin/nologin due to reasons explained here:
;; https://unix.stackexchange.com/questions/155139/does-usr-sbin-nologin-as-a-login-shell-serve-a-security-purpose
;; ... as result 'su' won't work, but with lisp it is easy to define 'sush' which will do -s /bin/sh
(push
 (cons
  "sush"
  '((tramp-login-program "su")
  (tramp-login-args (("-") ("%u") ("-s" "/bin/sh")))
  (tramp-remote-shell "/bin/sh")
  (tramp-remote-shell-login
   ("-l"))
  (tramp-remote-shell-args
   ("-c"))
  (tramp-connection-timeout 10)))
 tramp-methods)
;;

;; from https://emacs.stackexchange.com/questions/17543/tramp-mode-is-much-slower-than-using-terminal-to-ssh
(setq remote-file-name-inhibit-cache nil)
(setq vc-ignore-dir-regexp
      (format "%s\\|%s"
                    vc-ignore-dir-regexp
                    tramp-file-name-regexp))
(setq tramp-verbose 1)


(push
 (cons
  "ocrsh"
  '((tramp-login-program "oc")
    (tramp-login-args (("rsh") ("%h") ("/bin/sh")))
    (tramp-remote-shell "/bin/sh")
    (tramp-remote-shell-args ("-i"))))
 tramp-methods)

(push
 (cons
  "kube"
  '((tramp-login-program "kubectl")
    (tramp-login-args (("exec") ("%h") ("-it") ("/bin/sh")))
    (tramp-remote-shell "/bin/sh")
    (tramp-remote-shell-args ("-i"))))
 tramp-methods)

(defun tramp-refresh ()
  (interactive)
  ;; (recentf-cleanup)
  (tramp-cleanup-all-buffers)
  (tramp-cleanup-all-connections))
