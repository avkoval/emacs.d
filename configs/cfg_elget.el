;; el-get loading
(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.githubusercontent.com/dimitri/el-get/master/el-get-install.el")
    (goto-char (point-max))
    (eval-print-last-sexp)))

(add-to-list 'el-get-recipe-path "~/.emacs.d/el-get/recipes")
(setq my:el-get-packages     ;; // different add-ons
      '(
        ropemacs
        pylookup
        ahg
;;        base16-themes
        ;;        avk-emacs-themes
        openapi-yaml-mode
;;        flycheck-swagger-tools
        ))

;; custom settings per modules above go to directory below
(el-get 'sync my:el-get-packages)
