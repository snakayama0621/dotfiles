#!/bin/bash

set -u

title="${1:-Codex}"
message="${2:-タスクが完了しました}"

/usr/bin/afplay /System/Library/Sounds/Ping.aiff >/dev/null 2>&1 || true

osascript - "$title" "$message" <<'APPLESCRIPT' >/dev/null 2>&1 || true
on run argv
  display notification (item 2 of argv) with title (item 1 of argv) sound name "Ping"
end run
APPLESCRIPT

printf '\a' > /dev/tty 2>/dev/null || true
