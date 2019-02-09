(defvar modi/htmlize-output-directory
  (let ((dir (concat temporary-file-directory
                     (getenv "USER") "/.htmlize/"))) ; must end with /
    (make-directory dir :parents)
    dir)
  "Output directory for files exported by `modi/htmlize-region-to-file'.")

(defvar modi/htmlize-css-file (concat user-emacs-directory
                                      "leuven_theme.css")
  "CSS file to be embedded in the html file created using the
             `modi/htmlize-region-to-file' function.")

(defun modi/htmlize-region-to-file (option)
  "Export the selected region to an html file. If a region is not
selected, export the whole buffer.

The output file is saved to `modi/htmlize-output-directory' and its fontification
is done using `modi/htmlize-css-file'.

If OPTION is non-nil (for example, using `\\[universal-argument]' prefix), copy
the output file name to kill ring.
If OPTION is \\='(16) (using `\\[universal-argument] \\[universal-argument]' prefix),
do the above and also open the html file in the default browser."
  (interactive "P")
  (let ((org-html-htmlize-output-type 'css)
        (org-html-htmlize-font-prefix "org-")
        (fname (concat modi/htmlize-output-directory
                       (if (buffer-file-name)
                           (file-name-nondirectory (buffer-file-name))
                         "temp")
                       ".html"))
        start end html-string)
    (if (use-region-p)
        (progn
          (setq start (region-beginning))
          (setq end (region-end)))
      (progn
        (setq start (point-min))
        (setq end (point-max))))
    (setq html-string (org-html-htmlize-region-for-paste start end))
    (with-temp-buffer
      ;; Insert the `modi/htmlize-css-file' contents in the temp buffer
      (insert-file-contents modi/htmlize-css-file nil nil nil :replace)
      ;; Go to the beginning of the buffer and insert comments and
      ;; opening tags for `html', `head' and `style'. These are
      ;; inserted *above* the earlier inserted css code.
      (goto-char (point-min))
      (insert (concat "<!-- This file is generated using the "
                      "`modi/htmlize-region-to-file' function\n"
                      "from https://github.com/kaushalmodi/.emacs.d/"
                      "blob/master/setup-files/setup-org.el -->\n"))
      (insert "<html>\n<head>\n<style media=\"screen\" type=\"text/css\">\n")
      ;; Go to the end of the buffer (end of the css code) and
      ;; insert the closing tags for `style' and `head' and opening
      ;; tag for `body'.
      (goto-char (point-max))
      (insert "</style>\n</head>\n<body>\n")
      ;; Insert the HTML for fontified text in `html-string'.
      (insert html-string)
      ;; Close the `body' and `html' tags.
      (insert "</body>\n</html>\n")
      (write-file fname)
      (when option
        (kill-new fname)
        (when (= 16 (car option))
          (browse-url-of-file fname))))))

(with-eval-after-load 'region-bindings-mode
    (define-key region-bindings-mode-map (kbd "H") #'modi/htmlize-region-to-file))
