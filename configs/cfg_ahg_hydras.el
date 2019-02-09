;;; Hydra menus for aHg with the plan to move it into separate
;;; emacs package
(require 'hydra)


(defhydra ahg-pull-menu (:columns 1 :exit t)
  "Push & Server operations"
  ("p" ahg-pull "hg pull")
  ("u" ahg-pull-update "hg pull --update")
  ("r" ahg-pull-rebase "hg pull --rebase")
  )

;; Define layer for ahg-status
(defhydra ahg-status-hydramenu (:columns 3 :exit t)
  "aHg Status menu"
  ("f" ahg-status-visit-file "Visit file")
  ("o" ahg-status-visit-file-other-window "Visit file in other window")
  ("c" ahg-status-commit "Commit")
  ("ic" ahg-record "Interactive Commit (Record)")
  ("Cs" ahg-status-commit-secret "Secret commit")
  ("Ca"  ahg-status-commit-amend "Amend")
  ("a"  ahg-status-add "Add")
  ("r"  ahg-status-remove "Remove")
  ("A"  ahg-status-addremove "Add/Remove")
  ("I"  ahg-status-add-to-hgignore "Add to .hgignore")
  ("U"  ahg-status-undo "Undo")
  ;; New (custom)
  ("p" ahg-pull-menu/body "Pull (from remote) operations")
  ("P" ahg-push-menu/body "Push, Pull, remote operations")
  ("s" ahg-show-files-hydramenu/body "Show files")
  ("u" ahg-update "Update")
  ;; end of custom
  ("d"  ahg-status-delete "Delete")
  ("!" ahg-status-do-command "Hg Command")
  ("$" ahg-status-shell-command "Shell Command")
  (" " ahg-status-toggle-mark "Toggle Mark")
  ("m"  ahg-status-mark "Mark")
  ("u"  ahg-status-unmark "Unmark")
  ("M-DEL" ahg-status-unmark-all "Unmark All")
  ("F" ahg-status-dired-find "Show Marked in Dired")
  ("l" ahg-short-log "Log Summary")
  ("L" ahg-log "Detailed Log")
  ("G" ahg-glog "Revision DAG")
  ("H" ahg-heads "Heads")
  ("T" ahg-tags "Tags")
  ("B" ahg-bookmarks "Bookmarks")
  ("=" ahg-status-diff "Diff")
  ("D" ahg-status-diff-all "Diff Marked")
  ("e" ahg-status-diff-ediff "Ediff")
  ("Q" ahg-mq-hydramenu/body "Mercurial Queues")
  ("iQn" ahg-record-qnew "MQ/New Interactive Patch")
  ("h" ahg-command-help "Help on Hg Command")
  ("g" ahg-status-refresh "Refresh")
  ("q" ahg-buffer-quit "Quit")
  )


(defhydra ahg-mq-hydramenu (:columns 3 :exit t)
  "Mercurial Queues"
  ("n" ahg-qnew "New Patch...")
  ("in" ahg-record-qnew "New Interactive Patch")
  ("=" ahg-qdiff "View Qdiff")
  ("r" ahg-qrefresh "Refresh Current Patch")
  ("g" ahg-qgoto "Go to Patch...")
  ("m" ahg-qmove "Move to Patch...")
  ("s" ahg-qswitch "Switch to Patch...")
  ("a" ahg-qapply "Apply Patch to the Working Copy...")
  ("p" ahg-qpop-all "Pop All Patches")
  ("t" ahg-qtop "Show Name of Current Patch")
  ("l" ahg-mq-list-patches "List All Patches")
  ("d" ahg-qdelete "Delete Patch...")
  )

(defhydra ahg-show-files-hydramenu (:columns 6 :exit t)
  "Choose to show files"
  ("s" ahg-status-show-default "Default")
  ("A" ahg-status-show-all "All")
  ("t" ahg-status-show-tracked "Tracked")
  ("m" ahg-status-show-modified "Modified")
  ("a" ahg-status-show-added "Added")
  ("r" ahg-status-show-removed "Removed")
  ("d" ahg-status-show-deleted "Deleted")
  ("c" ahg-status-show-clean "Clean")
  ("u" ahg-status-show-unknown "Unknown")
  ("i" ahg-status-show-ignored "Ignored")
)


(defhydra ahg-short-log-mode-hydramenu (:columns 3 :exit t)
  "Push & Server operations"
  ("g" ahg-short-log-refresh "Refresh")
  ("s" ahg-status "Switch to status screen")
  ("=" ahg-short-log-view-diff "View diff")
  ("D" ahg-short-log-view-diff-select-rev "Diff against revision")
  (" " ahg-short-log-view-details "View log details")
  ("\r" ahg-short-log-update-to-rev "Update to selected revision")
  ("r" ahg-short-log-goto-revision "Goto revision")
  ("n" ahg-short-log-next "Next")
  ("p" ahg-short-log-previous "Previous")
  ("!" ahg-do-command "Run mercurial command")
  ("h" ahg-command-help "Help")
  ("E" ahg-histedit-hydramenu/body "History edit")
  ("B" ahg-bookmarks "Bookmarks")
  ("b" ahg-branches "Branches")
  ("G" ahg-glog "Graphlog")
  ("H" ahg-heads "Heads")
  ("L" ahg-log "Log")
  ("l" ahg-short-log "Short log")
  ("T" ahg-tags "Tags")
  ("q" ahg-buffer-quit "Quit")
  )

(defhydra ahg-histedit-hydramenu (:columns 2 :exit t)
  "History edit (histedit extension)"
  ("m" ahg-short-log-histedit-mess "Edit commit message")
  ("d" ahg-short-log-histedit-drop "Drop commit")
  ("x" ahg-short-log-histedit-xtract "Extract the given revision from history.")
  ("f" ahg-short-log-histedit-fold "Fold changesets")
  ("r" ahg-short-log-histedit-roll "Fold the given revision with its parent")
)

(defhydra ahg-remotes-menu (:columns 1 :exit t)
  "Operations w/remotes."
  ("i" ahg-show-incoming "Show incoming changesets")
  ("o" ahg-show-outgoing "Show outgoing changesets")
  ("p" ahg-show-paths "Show remote repository paths")
  )

(defun ahg-push-new-branch ()
  "Run hg push with new branch."
  (interactive)
  (ahg-do-command "push -b . --new-branch"))


(defhydra ahg-push-menu (:columns 2 :exit t)
  "Push & Server operations"
  ("p" ahg-pull-menu/body "Pull (from remote) operations")
  ("i" ahg-show-incoming "Show Incoming changesets")
  ("o" ahg-show-outgoing "Show Outgoing changesets")
  ("." ahg-push-current "Push current existing branch")
  ("u" ahg-push-current "Push current existing branch")
  ("P" ahg-push-current "Push current existing branch")
  ("nb" ahg-push-new-branch "Push current new branch")
  ("*" ahg-push-all "Push Everything")
  )




(define-key ahg-status-mode-map (kbd "?") 'ahg-status-hydramenu/body)
(define-key ahg-status-mode-map (kbd "/") 'ahg-status-hydramenu/body)
(define-key ahg-short-log-mode-map (kbd "?") 'ahg-short-log-mode-hydramenu/body)
(define-key ahg-short-log-mode-map (kbd "/") 'ahg-short-log-mode-hydramenu/body)


(defhydra ahg-glog-mode-menu (:columns 3 :exit t)
  "glog menu"
  ("\r" ahg-glog-update-to-rev "Update to revision")
  (" " ahg-glog-view-details "View details")
  ("!" ahg-do-command "Run hg command")
  ("=" ahg-glog-view-diff "View diff")
  ("B" ahg-bookmarks "Bookmarks")
  ("b" ahg-branches "Branches")
  ("D" ahg-glog-view-diff-select-rev "Diff against revision")
  ("G" ahg-glog "Glog")
  ("g" ahg-glog "Glog")
  ("H" ahg-heads "Heads")
  ("L" ahg-log "Log")
  ("l" ahg-short-log "Short Log")
  ("T" ahg-tags "Tags")
  ("p" ahg-glog-previous "Previous")
  ("n" ahg-glog-next "Next")
  ("s" ahg-status "Switch to status screen")
  ("Q" ahg-mq-hydramenu/body "Mercurial Queues")

  ("h" ahg-command-help "help")
  ("q" ahg-buffer-quit "Quit")
  )

(define-key ahg-glog-mode-map (kbd "?") 'ahg-glog-mode-menu/body)
(define-key ahg-glog-mode-map (kbd "/") 'ahg-glog-mode-menu/body)