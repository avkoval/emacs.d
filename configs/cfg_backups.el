; I've decided to store backups locally becuase in some cases, for example
; when editing files via 'sshfs' emacs is delayed too much.

(setq backup-directory-alist `(("." . "~/.saves")))
(setq backup-by-copying t)
(setq backup-by-copying-when-linked t)
(setq delete-old-versions t
  kept-new-versions 20
  kept-old-versions 20
  version-control t)
