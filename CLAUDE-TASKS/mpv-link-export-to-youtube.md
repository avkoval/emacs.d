# Task: define `mpv:` org-link export-to-HTML behaviour

**Created:** 2026-06-30 by Claude (Opus 4.7) while working on
`/mnt/main/home/oleksii/dev/rg/presale-estimate-analisys-framework/`.

**Status:** open. A workaround exists already (post-export Python script that
rewrites `[BROKEN LINK: mpv:…]` markers in the generated HTML). This task is
the *proper* Emacs-side fix that makes the workaround unnecessary.

## Problem

When org documents reference `mpv:~/Videos/foo.mkv#HH:MM:SS` timestamps and
get exported to HTML via `emacs --batch -Q` (which is what `just export`
does in
`/mnt/main/home/oleksii/dev/rg/presale-estimate-analisys-framework/Justfile`),
the export sees `mpv:` as an unknown link type, marks them broken, and
either aborts the export or — with `org-export-with-broken-links 'mark` —
renders them in the HTML as the literal text:

```
[BROKEN LINK: mpv:~/Videos/Some%20Talk%20%5BdxxvnKu8WAo%5D.mkv#00:12:30]
```

This pollutes published documents (e.g. the Jonathan Stark transcript at
`https://scr.ua2web.com/avk/rg-projects/presale-estimate-analisys-framework/framework/jonathan-stark-ditching-hourly-myob-2022.html`
had **162** such markers before the workaround).

## Why this happens

The `mpv:` org-link type is registered at runtime by `mpvi` (or `mpv.el`)
when the user opens an org file interactively in their full Emacs session.
In batch mode with `-Q`, those packages don't load, so the link type is
unregistered → org treats it as broken.

## Proper fix

Add a custom `mpv:` link export handler that:

1. Parses the link as `mpv:<path>#<timestamp>` where `<timestamp>` is
   `HH:MM:SS` (or `MM:SS`).
2. If `<path>` contains a `[<YT_ID>]` suffix (yt-dlp's default naming
   convention for files downloaded from YouTube — 11-char IDs from
   `[A-Za-z0-9_-]`), export to HTML as:
   `<a href="https://youtu.be/<YT_ID>?t=<SECONDS>">HH:MM:SS</a>`.
3. Otherwise, export as plain text fallback (e.g. just the timestamp label,
   or a `file://` link). Do **not** mark broken.
4. For other backends (LaTeX, ASCII, ODT): export as plain `HH:MM:SS` text.

Implementation sketch (in `~/.emacs.d/configs/` or wherever org config
lives — probably the org-mode-loading section of `README.org`):

```elisp
(with-eval-after-load 'ol
  (require 'org-element)

  (defun ok/mpv-link-export (path desc backend)
    "Export mpv: org-links to HTML as YouTube anchors when the path
encodes a yt-dlp-style [VIDEO_ID].mkv basename."
    (let* ((parts (split-string path "#" t))
           (file (car parts))
           (timestamp (cadr parts))
           (yt-id (when (string-match "\\[\\([A-Za-z0-9_-]\\{11\\}\\)\\]" file)
                    (match-string 1 file)))
           (secs (when (and timestamp (string-match
                                       "\\([0-9]+\\):\\([0-9]+\\):\\([0-9]+\\)"
                                       timestamp))
                   (+ (* 3600 (string-to-number (match-string 1 timestamp)))
                      (*   60 (string-to-number (match-string 2 timestamp)))
                      (string-to-number (match-string 3 timestamp)))))
           (label (or desc timestamp file)))
      (cond
       ((and (eq backend 'html) yt-id secs)
        (format "<a href=\"https://youtu.be/%s?t=%d\" target=\"_blank\" rel=\"noopener\" class=\"yt-timestamp\">%s</a>"
                yt-id secs label))
       ((eq backend 'html)
        (format "<span class=\"mpv-timestamp\">%s</span>" label))
       (t label))))

  (org-link-set-parameters
   "mpv"
   :export #'ok/mpv-link-export
   ;; :follow → leave to mpvi/mpv.el when interactively present
   ))
```

After this is in `init.el` (or any file loaded by it that always runs in
batch too), batch export with `--load ~/.emacs.d/init.el` will produce
working YouTube anchors directly, no post-processing needed.

## Side note: batch + heavy init.el

The Justfile currently uses `emacs --batch -Q` and skips loading user
init.el because the user's `init.el` loads a literate `README.org` with
many packages — slow + risky in batch. Two ways to make this work:

1. Refactor org-link setup into a small file that can be `--load`ed
   independently (e.g. `~/.emacs.d/configs/batch-export-links.el`), and
   point the Justfile at it via `--load`.
2. Add `(when noninteractive ...)` guards to expensive parts of README.org
   so batch loads stay fast.

Option (1) is less invasive. The Justfile would then change from:

```just
emacs --batch -Q \
    --eval "(require 'org)" \
    --eval "(require 'ox-html)" \
    --eval "(setq org-confirm-babel-evaluate nil)" \
    --eval "(setq org-resource-download-policy t)" \
    --eval "(setq org-export-with-broken-links 'mark)" \
    "$org" \
    --funcall org-html-export-to-html
```

to (adding `--load`):

```just
emacs --batch -Q \
    --eval "(require 'org)" \
    --eval "(require 'ox-html)" \
    --eval "(setq org-confirm-babel-evaluate nil)" \
    --eval "(setq org-resource-download-policy t)" \
    --load "~/.emacs.d/configs/batch-export-links.el" \
    "$org" \
    --funcall org-html-export-to-html
```

(with `org-export-with-broken-links 'mark` removed, since `mpv:` would no
longer be broken).

## Acceptance check

After implementation, running:

```
cd ~/dev/rg/presale-estimate-analisys-framework
just export
grep -c "BROKEN LINK" framework/jonathan-stark-ditching-hourly-myob-2022.html
```

should print `0` (or 2 — the 2 remaining intra-org `*fuzzy heading` broken
links that are an unrelated issue in the org source). The 162 `mpv:` ones
should disappear without needing `just rewrite-links`.

Additionally, in the generated HTML:

```
grep -oE '<a href="https://youtu.be/[^"]+"' framework/jonathan-stark-…2022.html | wc -l
```

should still print `162`.

## Related files (in the framework repo)

- `scripts/rewrite-mpv-links.py` — the current post-export workaround.
  Once the Emacs-side fix lands, this script + its `just rewrite-links`
  recipe can be deleted (or kept as a fallback when running export from
  CI without user's Emacs config).
- `Justfile` — recipes `export`, `export-one`, `rewrite-links`,
  `publish`, `deploy`.
