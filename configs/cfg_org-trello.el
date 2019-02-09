(require 'org-trello)
; (custom-set-variables '(org-trello-current-prefix-keybinding "C-c o"))
(add-hook 'org-trello-mode-hook
  (lambda ()
    (define-key org-trello-mode-map (kbd "C-c o v") 'org-trello-version)
    (define-key org-trello-mode-map (kbd "C-c o i") 'org-trello-install-key-and-token)
    (define-key org-trello-mode-map (kbd "C-c o I") 'org-trello-install-board-metadata)
    (define-key org-trello-mode-map (kbd "C-c o c") 'org-trello-sync-card)
    (define-key org-trello-mode-map (kbd "C-c o s") 'org-trello-sync-buffer)
    (define-key org-trello-mode-map (kbd "C-c o a") 'org-trello-assign-me)
    (define-key org-trello-mode-map (kbd "C-c o d") 'org-trello-check-setup)
    (define-key org-trello-mode-map (kbd "C-c o D") 'org-trello-delete-setup)
    (define-key org-trello-mode-map (kbd "C-c o b") 'org-trello-create-board-and-install-metadata)
    (define-key org-trello-mode-map (kbd "C-c o k") 'org-trello-kill-entity)
    (define-key org-trello-mode-map (kbd "C-c o K") 'org-trello-kill-cards)
    (define-key org-trello-mode-map (kbd "C-c o a") 'org-trello-archive-card)
    (define-key org-trello-mode-map (kbd "C-c o A") 'org-trello-archive-cards)
    (define-key org-trello-mode-map (kbd "C-c o j") 'org-trello-jump-to-trello-card)
    (define-key org-trello-mode-map (kbd "C-c o J") 'org-trello-jump-to-trello-board)
    (define-key org-trello-mode-map (kbd "C-c o C") 'org-trello-add-card-comments)
    (define-key org-trello-mode-map (kbd "C-c o o") 'org-trello-show-card-comments)
    (define-key org-trello-mode-map (kbd "C-c o l") 'org-trello-show-card-labels)
    (define-key org-trello-mode-map (kbd "C-c o u") 'org-trello-update-board-metadata)
    (define-key org-trello-mode-map (kbd "C-c o h") 'org-trello-help-describing-bindings)))