(require 'bm)

;; This is useful when you want to hard-mark some lines in your code and return
;; to them, cycle between them during *current* editing session.
;;
;; Memoize: b = bookmark, down, up, p -previous, n -next, space -set/clean

(global-set-key (kbd "C-z b") 'bm-toggle)
(global-set-key (kbd "C-z <up>") 'bm-previous)
(global-set-key (kbd "C-z C-p") 'bm-previous)
(global-set-key (kbd "C-z <down>") 'bm-next)
(global-set-key (kbd "C-z C-n") 'bm-next)
(global-set-key (kbd "C-z <SPC>") 'bm-show-all)

