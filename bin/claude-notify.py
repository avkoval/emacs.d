#!/usr/bin/env python
"""Claude Code Notification-hook handler.

Reads the hook's JSON payload from stdin and surfaces the message to the
user in two channels:

  1. Emacs   -- flashes the message in the minibuffer of the running server
                (and rings a soft bell so it's noticeable).
  2. Desktop -- a notify-send toast, titled with the project directory so
                you can tell *which* Claude session wants you.

Wired into ~/.claude/settings.json as a "Notification" hook. Claude fires
that hook when it needs permission to run a tool, or when the prompt has
been idle >=60s waiting for input.

Design notes:
  * Never let a failure in one channel block the other, and never hang the
    hook -- every external call has a short timeout and is best-effort.
  * The Emacs server socket path is computed explicitly (XDG_RUNTIME_DIR is
    not guaranteed to be set in the hook's environment).
"""

import json
import os
import subprocess
import sys


def read_payload():
    try:
        raw = sys.stdin.read()
        return json.loads(raw) if raw.strip() else {}
    except (ValueError, OSError):
        return {}


def emacs_socket():
    """Best guess at the running server's socket path."""
    runtime = os.environ.get("XDG_RUNTIME_DIR") or f"/run/user/{os.getuid()}"
    return os.path.join(runtime, "emacs", "server")


def notify_emacs(message):
    sock = emacs_socket()
    # elisp string escaping: backslash and double-quote
    esc = message.replace("\\", "\\\\").replace('"', '\\"')
    elisp = f'(progn (message "[Claude] {esc}") (ding))'
    cmd = ["emacsclient"]
    if os.path.exists(sock):
        cmd += ["-s", sock]
    cmd += ["-e", elisp]
    try:
        subprocess.run(
            cmd,
            timeout=5,
            check=False,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        )
    except (OSError, subprocess.TimeoutExpired):
        pass


def notify_desktop(message, title):
    try:
        subprocess.run(
            [
                "notify-send",
                "--app-name=Claude Code",
                "--urgency=normal",
                "--expire-time=10000",
                title,
                message,
            ],
            timeout=5,
            check=False,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        )
    except (OSError, subprocess.TimeoutExpired):
        pass


def default_message(event):
    """Fallback text when the payload carries no `message` (e.g. Stop)."""
    return {
        "Stop": "Claude finished responding",
        "SubagentStop": "A Claude subagent finished",
        "Notification": "Claude needs your attention",
    }.get(event, "Claude needs your attention")


def main():
    payload = read_payload()
    event = payload.get("hook_event_name") or "Notification"
    message = payload.get("message") or default_message(event)
    cwd = payload.get("cwd") or ""
    project = os.path.basename(cwd.rstrip("/")) if cwd else ""
    title = f"Claude — {project}" if project else "Claude Code"

    notify_emacs(message)
    notify_desktop(message, title)


if __name__ == "__main__":
    main()
