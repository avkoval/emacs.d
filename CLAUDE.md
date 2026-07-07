# Emacs config — working notes for Claude

## Org-tangle: don't tangle for the user

Several files in this repo are literate sources that tangle to a real
runtime file (e.g. `youtrack/youtrack.org` → `youtrack/youtrack.el`, and
the top-level `README.org` tangling into various `.el` blocks).

When editing a literate source, **skip running the tangle step**. The
user runs `org-babel-tangle` themselves (usually with `C-c C-v t`) and
prefers to control when the runtime file changes.

Exceptions where tangling *is* appropriate:

- You need to byte-compile the tangled output to verify syntax /
  compile-clean-ness of the changes (e.g. `emacs -Q --batch -f
  batch-byte-compile file.el`). Clean up the resulting `.elc` when done.
- The user explicitly asks you to tangle.

When you edit a literate source, also mirror the same edit into the
already-tangled file (keeps both files in sync until the user tangles
next). Do **not** rely on the user to re-tangle before testing — apply
the change to both.
