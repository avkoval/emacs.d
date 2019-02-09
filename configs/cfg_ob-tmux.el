(require 'ob-tmux)
(setq org-babel-default-header-args:tmux
  '((:results . "silent")		;
    (:session . "default")	; The default tmux session to send code to
    (:socket  . nil)              ; The default tmux socket to communicate with
    ;; You can use "xterm" and "gnome-terminal".
    ;; On mac, you can use "iterm" as well.
    (:terminal . "urxvt")))

;; The tmux sessions are prefixed with the following string.
;; You can customize this if you like.
(setq org-babel-tmux-session-prefix "ob-")

