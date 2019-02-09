(require 'package)
(package-initialize)

(setq package-archives
      `(
        ("melpa" . "https://melpa.org/packages/")
        ("gnu" . "https://elpa.gnu.org/packages/")
        ("elpy" . "https://jorgenschaefer.github.io/packages/")
        ))

;; temp fix for: https://www.reddit.com/r/emacs/comments/7tb0ss/package_system_now_shows_a_lot_of_incompatible/
(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/") t)

(setq tls-program
      '("gnutls-cli --x509cafile /etc/ssl/certs/ca-certificates.crt -p %p %h"
        "gnutls-cli --x509cafile /etc/ssl/certs/ca-certificates.crt -p %p %h --protocols ssl3"
        "openssl s_client -connect %h:%p -CAfile /etc/ssl/certs/ca-certificates.crt -no_ssl2 -ign_eof"))

(unless package-archive-contents
  (package-refresh-contents))

(setq load-path (cons "~/.emacs.d/elpa/" load-path))


;; Now emacs automatically stores all required packages into
;; package-selected-packages - lets try to reuse this
;; (defun install-packages ()
;;   "Install all required packages."
;;   (interactive)
;;   (unless package-archive-contents
;;     (package-refresh-contents))
;;   (dolist (package package-selected-packages)
;;     (unless (package-installed-p package)
;;       (package-install package))))
;; (install-packages)
(package-install-selected-packages)

;; (install-packages)

(if (and (>= emacs-major-version 24) (>= emacs-minor-version 4))
    (package-install 'magit)
  (ding)
  (message "Magit requires emacs >= 24.4"))
