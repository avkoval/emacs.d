;;; early-init.el --- Runs before package and GUI init  -*- lexical-binding: t -*-

;; libgccjit guesses the macOS deployment target from the Darwin kernel
;; version and gets it wrong on new releases (Darwin 27 -> "18.0"), which
;; clang rejects, so every native compilation fails.  Pin it to the real
;; macOS version before anything gets native-compiled.
(when (and (eq system-type 'darwin)
           (not (getenv "MACOSX_DEPLOYMENT_TARGET")))
  (let ((ver (string-trim
              (shell-command-to-string "sw_vers -productVersion"))))
    (when (string-match "\\`[0-9]+\\(?:\\.[0-9]+\\)*\\'" ver)
      (setenv "MACOSX_DEPLOYMENT_TARGET" ver))))

;; AeroSpace starts the real binary (Emacs-arm64-11) instead of the
;; emacsformacosx launcher, so do the launcher's LIBRARY_PATH setup here;
;; without it libgccjit can't link (ld: library 'emutls_w' not found).
(when (and (eq system-type 'darwin)
           (string-match "\\`Emacs-\\(.+\\)\\'" invocation-name))
  (let* ((lib (expand-file-name (format "lib-%s/libgccjit" (match-string 1 invocation-name))
                                invocation-directory))
         (dirs (seq-filter #'file-directory-p
                           (list lib
                                 (expand-file-name "apple-darwin" lib)
                                 (expand-file-name "sdk-libs" lib))))
         (old (getenv "LIBRARY_PATH"))
         (cur (and old (split-string old path-separator t))))
    (dolist (dir dirs)
      (unless (member dir cur)
        (setq cur (append cur (list dir)))))
    (when cur
      (setenv "LIBRARY_PATH" (string-join cur path-separator)))))

;;; early-init.el ends here
