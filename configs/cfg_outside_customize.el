;; ;
;; ; Variables and function calls which I were unable to set via M-x customize
;; ;


;; ; enable disabled advanced features
(put 'downcase-region 'disabled nil)
(put 'scroll-left 'disabled nil)
(put 'upcase-region 'disabled nil)

(set-frame-position (selected-frame) 614 38)

;; ;; follow-mode allows easier editing of long files
;; (follow-mode t) ;; !!!! this causes emacs to fail loading files which needs to be recovered!!!!

;; ; type y or n
(fset 'yes-or-no-p 'y-or-n-p)
