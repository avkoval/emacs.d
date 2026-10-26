---
name: org-babel-runbook
description: Use when the user wants an org-mode task file / runbook / install guide whose steps are executed from Emacs with org-babel — "write a task file to install X on the Pi", "make an org babel file for setting up Y", "runbook with bash sessions", "convert this tmux runbook to bash sessions" — or when debugging one ("results stay as a hash/uuid", "block hangs", "output shows in the session but not in RESULTS", "No buffer named pi"). Writes named `bash :session` blocks over TRAMP with the org-babel-runbook Emacs package's conventions: results type, sudo-safe async, idempotency tags with Check blocks, when to keep ob-tmux, and progress tracking (numbered `[ ]` checkbox per block, `[/]` cookie on every step heading) for both bash and tmux blocks.
---

# Org-babel runbooks (bash sessions, local or over TRAMP)

The Emacs side is the **org-babel-runbook** package; this skill lives inside it (`claude-skill/org-babel-runbook/`,
symlinked into `~/.claude/skills/`). Package directory: resolve the symlink of this skill and go two levels up —
`README.md` explains the three fixes, `example/demo.org` is a minimal runbook, `test/` holds the batch tests. On the
author's machines it's `~/.emacs.d/org-babel-runbook/`; a full real-world runbook is
`~/dev/DellSSDReplaceM2/logs-victorialogs.org` (read it if present and copy its skeleton).

## 0. Check the Emacs side first

The runbook only works with `org-babel-runbook-mode` on. If the user reports a symptom, verify before editing blocks:
- `grep -rn org-babel-runbook-mode ~/.emacs.d/` (their init), and if Emacs runs a server:
  `emacsclient --eval "(list org-babel-runbook-mode (advice-member-p 'org-babel-runbook--tty-guard 'org-babel-sh-evaluate))"`.
- In the session buffer, an async block must start with `eval "$(cat <<'OB_BLOCK_END'`. If it doesn't, the mode isn't
  active in that Emacs (common after editing a literate init without tangling/evaluating it).

What the mode fixes (details in README.md):
1. [@1]  **sudo eats ob-shell's end marker.** sudo ≥ 1.9.14 (`use_pty`) takes pending terminal input, including the
   `echo <marker>` line ob-shell types after the block → commands run, `#+RESULTS:` stays a uuid (async) or Emacs
   hangs (sync). Also `xdg-open`, `script`, anything reading /dev/tty. Stdin redirection does not help. The mode
   wraps *async* session bodies; sync ones are not wrapped → **blocks with sudo need `:async yes`**.
2. [@2]  **ob-async hijacks session blocks** (child Emacs without session buffers: "No buffer named pi", or a child
   crash "Recursive load …"). The mode routes shell `:session` blocks past ob-async.
3. [@3]  `org-babel-runbook-list-sessions` lists session buffers (bind it; the author uses `C-z <f3>`).

## 1. File skeleton

```org
#+TITLE: <what gets set up, on which hosts>
#+PROPERTY: header-args:bash :results output :async yes
#+PROPERTY: header-args:bash+ :var some_ver="v1.2.3"
#+PROPERTY: header-args:bash+ :var some_ip="192.168.1.50"

* How the blocks run      ← session table (name / runs on / :dir), the rules below in two lines each, tag legend
* Decisions               ← what was chosen and why
* Layout                  ← #+begin_example diagram of hosts, ports, data paths
* Variables               ← table: variable / where its value comes from / which step sets it
* TODO 1. <step> [/]                                              :read_only:
* TODO 2. <step> [/]                                               :rerun_ok:
* TODO 3. <step with sub-steps> [/]                              :disruptive:
** TODO <sub-step> [/]                                             :rerun_ok:
* Operations              ← Upgrade / Remove / Later
```

### Progress: numbered checkboxes + `[/]` cookie on the heading

The human runs blocks one by one and easily misses the second block under a heading (seen: a heading with two
blocks, the first ran, the second still showed a uuid in RESULTS). So every action the reader must take is a checkbox:

```org
* TODO 3. Service, then Caddy [/]                                :disruptive:
1. [@1]  [ ] Bind VictoriaLogs to localhost.
#+begin_src bash :session pi :dir /ssh:user@pi-host:
…
#+end_src
Expected: =OK=.

2. [@2]  [ ] Replace the Caddy block and reload.
#+begin_src bash :session pi :dir /ssh:user@pi-host:
…
#+end_src
Expected: =Valid configuration=, =active=.

3. [@3]  [ ] Check.
#+begin_src bash :session pi :dir /ssh:user@pi-host:
…
#+end_src
Expected: …
```

- Applies the same to `bash :session` and ob-tmux blocks (and mixed files): the checkbox tracks the human's action,
  not the block type — a tmux block that runs for an hour is exactly the one that gets forgotten.
- One item per source block (Check blocks included), and per manual action without a block ("open the URL in the
  browser", "type the password in the session buffer", "edit the router config"). Short imperative text naming what
  the block does — the reader ticks it with `C-c C-c` on the item after comparing with `Expected:`.
- Numbered `N. [@N]  [ ]` (counter cookie, two spaces, then the checkbox); numbering restarts at 1 under every
  heading. Blocks stay unindented between items — the heading cookie counts every checkbox in the section, even when
  the blocks split it into several lists, and `[@N]` keeps the numbers right.
- `[/]` goes at the end of the heading text, before the tags. It counts the checkboxes in that heading's own body.
- A heading with sub-headings (step 3 above) gets `[/]` too, and then counts its `TODO`/`DONE` children — so its own
  body holds prose only, no checkboxes (mixing both makes the two counters overwrite each other). Its sub-headings
  carry the checkboxes.
- A heading with a single block still gets the checkbox and `[/]` — uniform, and `[1/1]` is the signal to mark DONE.
- Cookies refresh on `C-c C-c` on the cookie or a checkbox; a freshly written file shows `[/]` until then — say so.
- Converting an existing runbook: add `[/]` to every step heading and turn each block's lead-in sentence into the
  item text; keep ticks `[X]` for blocks whose RESULTS show the step already ran (step is DONE).

Header rules:
- `:results output` — plain `: …` lines. The default `value` turns whitespace-separated output into an org table.
- `:async yes` — required for sudo (above); Emacs stays usable; RESULTS shows a uuid until the block finishes.
- `:var` values become shell variables in the session on every run. Header args can't use them, so hosts in `:dir`
  are written literally.
- Never put `\"`-quoted strings in `:prologue`/`:epilogue` on a `#+PROPERTY` line — org's parser mangles them and
  swallows the following args. Use an elisp call `(fn)` if a computed value is ever needed.
- Tell the user: after a `#+PROPERTY` line changes (or the file changed on disk while open), `C-c C-c` on a property
  line or `M-x org-mode-restart`, and kill stale session buffers.

## 2. Blocks

```org
#+begin_src bash :session pi :dir /ssh:user@pi-host:
…
#+end_src
Expected: <short, exact output to compare>.
```

- One named session per host/user (`pi`, `edge` with `:dir /ssh:root@host:`, `dell` local without `:dir`). No `ssh`
  login blocks: TRAMP opens the session, sudo prompts appear in the minibuffer. Remote shell is bash; write POSIX.
- `:dir` only applies when the session is created; later blocks reuse the shell and its cwd → subshells
  `( cd /tmp && … )`, never a bare `cd`.
- Heredocs quoted (`<<'EOF'`), no variables inside. A line `OB_BLOCK_END` is reserved by the guard.
- No keyboard reads in blocks (`read -rs`, interactive installers): stdin is /dev/null under the guard. Secrets are
  typed by the user in the session buffer, or that step stays in tmux.
- Quiet, comparable output: `apt-get -y -qq install`, `ip -color=never`, `curl -sS`, end with a short check
  (`systemctl is-active`, a count, `OK`). Write an `Expected:` line under every block.
- Long-running foreground processes (`ssh -N -L`, `tail -f`) occupy a session → ob-tmux block with its own session.
- Never `exit` in a block. Portable commands if the user also works on macOS (no `sed -i` without suffix etc.).

## 3. Idempotency: tags and Check blocks

| Tag             | Meaning                                                                    |
|-----------------+----------------------------------------------------------------------------|
| `:read_only:`   | changes nothing                                                            |
| `:rerun_ok:`    | second run converges to the same state and finishes a half-done first run  |
| `:disruptive:`  | safe to repeat, but restarts something users notice                        |
| `:destructive:` | deletes data                                                               |

- Every step that changes something ends with a read-only **Check** block + `Expected:` (its own checkbox item, last
  in the list). Mark DONE when Check passes and the cookie is full;
  unsure whether a step went through (Emacs restarted mid-step): run Check, if it fails run the step again.
- Re-runnable by construction: `tee` whole files (not `>>`), `install -d`, self-replacing nft tables
  (`table inet x {}` / `delete table inet x` / `table inet x {…}`), `id u || useradd …`,
  `systemctl enable X && systemctl restart X` instead of `enable --now` (a no-op on a running service).
- When asked "is step N done?", check the host read-only yourself if reachable (`ssh -o BatchMode=yes host '…'`).

## 4. tmux or bash session?

Bash sessions for short, non-interactive steps watched from Emacs. ob-tmux when steps run for minutes–hours and must
survive an Emacs restart (copies, migrations, backups), need a real terminal (less, htop, editors) or read secrets.
Don't mass-convert a reviewed tmux runbook.

ob-tmux passes `:var` the same way as ob-shell: it types `name="value"` assignments before the block (no textual
substitution). So in tmux blocks too: no `~` in variable values (`archive_dir="~/x"` stays a literal `~`; use
`$HOME/x`), and heredocs that use variables must be unquoted (`<<EOF`, with any other `$`, backticks and
backslashes inside escaped) — a quoted `<<'EOF'` writes `$name` literally into the config.

The sudo problem hits ob-tmux too: the block is pasted at once, and while a `sudo …` line runs, sudo takes the pasted
lines still waiting — they are silently lost (seen: a `systemctl enable --now` after a `sudo tee <<EOF` heredoc never
ran). Write every tmux block as ONE command chain: put commands that follow a heredoc on the heredoc's first line
(`sudo tee f >/dev/null <<'EOF' && sudo systemctl daemon-reload && …`; several heredocs on one line work:
`<<'EOF' && sudo tee g <<'EOF2' && …`), and give `read -rs` its own block (otherwise it reads the next pasted line).

## 5. Testing Emacs-side changes

`cd <package> && emacs -Q --batch -L . -l test/org-babel-runbook-test.el -f ert-run-tests-batch-and-exit` (add
`-L <org/lisp>` for a non-built-in org; `--eval '(progn (require (quote package)) (package-initialize))'` to include
ob-async). The tests use a sudo stand-in (perl `POSIX::tcflush` on /dev/tty) and `/ssh:localhost:` when key login to
localhost works.
