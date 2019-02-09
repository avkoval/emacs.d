; http://www.emacsblog.org/2008/04/04/package-faves-js2-mode/
; http://steve-yegge.blogspot.com/2008/03/js2-mode-new-javascript-mode-for-emacs.html

;; tried js2-mode, did not liked it
;; (autoload 'js2-mode "js2" nil t)
;; (add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))

;; switched back to standard supplied mode
(autoload 'javascript-mode "javascript" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . javascript-mode))
(setq js-indent-level 2)

;; jslint
(require 'flymake-jslint)
(add-hook 'js-mode-hook 'flymake-jslint-load)
(require 'flymake-cursor)
