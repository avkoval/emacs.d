; I like this variation from
; http://stackoverflow.com/questions/88399/how-do-i-duplicate-a-whole-line-in-emacs
; because: it does not uses kill ring

(defun jr-duplicate-line ()
  "EASY"
  (interactive)
  (save-excursion
    (let ((line-text (buffer-substring-no-properties
		      (line-beginning-position)
		      (line-end-position))))
      (move-end-of-line 1)
      (newline)
      (insert line-text))))

(global-set-key [(control =)] 'jr-duplicate-line) ;; Ctrl+
