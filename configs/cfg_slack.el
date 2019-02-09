(require 'slack)
(defun helm-slack ()
    "Helm Slack"
    (interactive)
    (setf helm-slack-source
          `((name . "Helm Slack")
            (action . (lambda (candidate)
                        (setf foo candidate)
                        (slack-room-display (first candidate) (second candidate))))
            (candidates 
             ,@(loop
                for team in slack-teams
                as team-name = (oref team name)
                nconc (let ((channels
                             (loop
                              for channel in (oref team channels)
                              as channel-name = (oref channel name)
                              as label = (format "%s channel %s" team-name channel-name)
                              unless (oref channel is-archived)
                              collect `(,label ,channel ,team)))
                            (users nil)
                            ;;  (loop
                            ;;   for (user-name . user-plist) in (slack-user-names team)
                            ;;   as label = (format "%s member %s, %s"
                            ;;                      team-name user-name (getf user-plist :real_name))
                            ;;   collect `(,label ,team ,user-plist)))
                            )
                        (nconc channels users))))))
    (helm
     :prompt "Channel or user: "
     :sources 'helm-slack-source
     :history 'helm-slack-source-history))
