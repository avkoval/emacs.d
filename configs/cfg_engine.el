;;; Commentary:
;;; emacs-engine

;;; Code:
(require 'engine-mode)
(engine-mode t)

(defengine google
  "http://www.google.com/search?ie=utf-8&oe=utf-8&q=%s"
  :keybinding "gg")

(defengine google-translate
  "https://translate.google.com/#en/uk/%s"
  :keybinding "gt")
;;
