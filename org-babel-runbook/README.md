# org-babel-runbook

Run org files as **runbooks**: every step is a `#+begin_src bash :session NAME` block that you execute with `C-c C-c`,
in a named Emacs shell buffer on this machine or on a server through TRAMP. The commands, their explanation and the
output they printed live together in one plain-text file that you can re-read, re-run, diff and commit.

Out of the box, org-babel shell sessions break in ways that make this unusable for real admin work — most visibly,
**any block that runs `sudo` never gets its output**. This package fixes that, adds a session switcher, and comes
with conventions (and a [Claude Code](https://claude.com/claude-code) skill) for writing runbooks that are safe to
re-run.

```org
#+PROPERTY: header-args:bash :results output :async yes
#+PROPERTY: header-args:bash+ :var vl_ver="v1.53.0"

* TODO 3. Service, port filter, start                                       :rerun_ok:
#+begin_src bash :session pi :dir /ssh:oleksii@mypi:
sudo tee /etc/systemd/system/app.service >/dev/null <<'EOF'
[Service]
ExecStart=/usr/local/bin/app
EOF
sudo systemctl daemon-reload && sudo systemctl enable app && sudo systemctl restart app && systemctl is-active app
#+end_src

#+RESULTS:
: active
```

## What it fixes

### 1. sudo eats ob-shell's end marker — results stay a uuid forever

**Symptom.** The commands of the block clearly ran (the file was written, the service started, the session buffer
even shows `OK`), but `#+RESULTS:` stays at a placeholder like `: 608d60d0-abc2-459a-870b-c28a9492d4e8` (with
`:async yes`), or Emacs freezes until `C-g` (without it). Blocks without sudo work fine, which makes it look random.

**Cause.** A session is an interactive shell in a comint buffer. ob-shell types the whole block into it and then one
more line — `echo 'ob_comint_async_shell_end_<uuid>'` (async) or `echo 'org_babel_sh_eoe'` (sync). The output of that
line is how org knows the block is finished. While the block runs, that line waits in the terminal's input queue:

```
terminal input queue:   [ sudo tee …  ][ EOF ][ sudo systemctl … ][ echo 'ob_…_end_<uuid>' ]
                          ^ the shell is running this one           ^ waits here to be read next
```

sudo 1.9.14 (2023) made `use_pty` the default: sudo runs the command in a new pseudo-terminal and works on the user's
terminal (`/dev/tty`) directly, taking or discarding what's pending there. The queued `echo` line is gone, the marker
never prints, and org waits forever. Seen with sudo 1.9.16 (Debian 13) and 1.9.17 (Arch); any distribution with sudo
≥ 1.9.14 behaves the same. Programs that read the terminal do it too (`xdg-open`, `script`, …).
Redirecting the block's stdin (`{ …; } </dev/null`) does **not** help: sudo doesn't use stdin for this.

**Fix.** `org-babel-runbook-mode` sends every async session block as

```sh
eval "$(cat <<'OB_BLOCK_END'
…your block, verbatim…
OB_BLOCK_END
)" </dev/null; \
echo 'ob_comint_async_shell_end_<uuid>'
```

The trailing backslash continues the command onto ob-shell's marker line, so the shell reads the block *and* the marker
as one command line before it runs anything. Nothing is left in the input queue for sudo to take. The quoted heredoc
keeps the block literal (inner heredocs, `$`, quotes and braces all pass through), `eval` runs it in the session shell
itself (variables persist between blocks), and sudo still asks for its password on the terminal (Emacs shows the
prompt in the minibuffer).

Only async blocks are wrapped: ob-shell's synchronous path splits the output by prompts and would return nothing for
a joined command line. **Use `:async yes` for blocks that run sudo** — simplest as a file-wide header argument.

### 2. ob-async hijacks session blocks

If [ob-async](https://github.com/astahlman/ob-async) is installed, it takes every block that has `:async` and runs it
in a separate child Emacs. That child has no session buffers: you get `No buffer named pi`, or the child crashes
loading your init (`Recursive load …`). ob-shell has had its own `:async` for sessions since org 9.7, so the mode
routes shell blocks that have a `:session` past ob-async. Other languages and session-less blocks keep using ob-async.

### 3. Session buffers are invisible

A `:session pi` block runs in a buffer named `pi` that doesn't show up anywhere unless you know its name.
`org-babel-runbook-list-sessions` lists all ob-shell session buffers — live ones first, with host (for TRAMP) and
current directory, `[visible]` / `[dead]` — and switches to the one you pick.

## Installation

Requirements: Emacs 29.1+, org 9.7+ (Emacs 30's built-in org is fine).

The package currently lives in the [`org-babel-runbook/`](.) directory of the author's
[emacs.d](https://github.com/avkoval/emacs.d). Copy that directory anywhere, or install it straight from git:

```elisp
;; Emacs 30+: package-vc
(package-vc-install '(org-babel-runbook :url "https://github.com/avkoval/emacs.d"
                                        :lisp-dir "org-babel-runbook"))

;; or a manual copy
(add-to-list 'load-path "~/path/to/org-babel-runbook")
```

Then:

```elisp
(with-eval-after-load 'ob-shell
  (require 'org-babel-runbook)
  (org-babel-runbook-mode 1))
(autoload 'org-babel-runbook-list-sessions "org-babel-runbook" nil t)
(global-set-key (kbd "C-c b s") #'org-babel-runbook-list-sessions) ; any key you like
```

and make sure shell blocks are enabled: `(org-babel-do-load-languages 'org-babel-load-languages '((shell . t)))`.

## Usage

File header:

```org
#+PROPERTY: header-args:bash :results output :async yes
#+PROPERTY: header-args:bash+ :var app_ver="1.2.3"
```

- `:results output` — the block's output as plain `: …` lines. org's default (`value`) turns any whitespace-separated
  output (`df`, `free`, `ip -br addr`) into a table.
- `:async yes` — needed for sudo (see above); Emacs stays usable while `apt` runs. The uuid in `#+RESULTS:` is
  replaced by the output when the block finishes.
- `:var` values are set as shell variables in the session on every run.

Blocks:

```org
#+begin_src bash :session pi :dir /ssh:me@pi.lan:
uname -m; df -h /var/lib
#+end_src
```

- One named session per machine and user. `:dir /ssh:user@host:` makes TRAMP open the session on that host — no
  `ssh host` line in the block; sudo prompts come to the minibuffer.
- `:dir` matters only when the session starts; later blocks reuse the shell and its current directory. Use
  subshells `( cd /tmp && … )` instead of a bare `cd`.
- After editing a `#+PROPERTY` line press `C-c C-c` on it (or `M-x org-mode-restart`); an open buffer keeps the old
  header arguments otherwise.
- A session stuck waiting (e.g. after an unguarded block): kill its buffer, the next block opens a fresh one.
- Opt a single block out of the wrapper with `:tty-guard no`.

Limitations of the wrapper:

- A block can't read the keyboard (`read -s`, interactive installers): its stdin is `/dev/null`. Type such input in
  the session buffer, or keep that step in a terminal.
- A line consisting of exactly `OB_BLOCK_END` ends the wrapper early (customize `org-babel-runbook-guard-delimiter`).
- Bourne-style shells only (bash, sh, zsh — `org-babel-runbook-shell-languages`).
- The session buffer shows the wrapper lines around each block.

## Writing runbooks that are safe to re-run

The point of a runbook is that you can stop half-way, restart Emacs, come back next week and still know where you are.
These conventions grew out of using it for real server setups ([`example/demo.org`](example/demo.org) shows them in
miniature):

- **Tag every step heading** with what a re-run does:

  | Tag             | Meaning                                                                   |
  |-----------------|---------------------------------------------------------------------------|
  | `:read_only:`   | changes nothing                                                           |
  | `:rerun_ok:`    | a second run converges to the same state, and finishes a half-done first one |
  | `:disruptive:`  | safe to repeat, but restarts something users notice                       |
  | `:destructive:` | deletes data                                                              |

  `C-c \` (`org-match-sparse-tree`) on a tag shows only those steps.
- **End every changing step with a read-only Check block** and an `Expected:` line. "Did step 3 actually go through
  before Emacs crashed?" becomes: run Check; if it fails, run the step again.
- **Make steps converge**: write whole files with `tee`/`cat >` (never append), `install -d`, `id u || useradd …`,
  firewall tables that delete and recreate themselves, and `systemctl enable X && systemctl restart X` instead of
  `enable --now` (which does nothing to a running service, so changed config wouldn't apply).
- **Quiet, comparable output**: `apt-get -qq`, `ip -color=never`, `curl -sS`, and finish with a one-word check
  (`systemctl is-active`, `OK`, a count).
- **Keep a terminal (e.g. [ob-tmux](https://github.com/ahendriksen/ob-tmux)) for** steps that run for hours and must
  survive an Emacs restart, need a full-screen terminal, or read secrets interactively.

## Claude Code skill

[`claude-skill/org-babel-runbook/SKILL.md`](claude-skill/org-babel-runbook/SKILL.md) teaches
[Claude Code](https://claude.com/claude-code) all of the above: ask it to *"write an org babel task file to install
VictoriaLogs on my Pi"* and it produces a runbook with the right header arguments, sessions, tags, Check blocks and
`Expected:` lines — and when a block misbehaves, it knows the failure modes. Install by linking it into your skills
directory (same command on Linux and macOS):

```sh
ln -s ~/path/to/org-babel-runbook/claude-skill/org-babel-runbook ~/.claude/skills/org-babel-runbook
```

Keeping the skill inside the package means one git repository carries the Emacs code and the instructions for the
assistant to every machine you work on.

## Tests

```sh
cd org-babel-runbook
emacs -Q --batch -L . -l test/org-babel-runbook-test.el -f ert-run-tests-batch-and-exit
```

Add `-L /path/to/org/lisp` to test against another org, and
`--eval '(progn (require (quote package)) (package-initialize))'` to load an installed ob-async. sudo would need a
password, so the tests use a stand-in that does what sudo does to the session — a perl one-liner that flushes the
terminal's pending input through `/dev/tty`. Without the mode it reproduces the stuck uuid; with it the output arrives.
The TRAMP test runs when `ssh -o BatchMode=yes localhost true` works.

## License

MIT — see [LICENSE](LICENSE).
