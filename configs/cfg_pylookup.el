(require 'pylookup)
(setq pylookup-program "~/.emacs.d/pylookup.py")
(setq pylookup-db-file "~/var/pylookup/pylookup.db")
(global-set-key [(control shift menu)] 'pylookup-lookup)
