#!/bin/bash

/usr/bin/afplay /System/Library/Sounds/Ping.aiff >/dev/null 2>&1 || true
osascript -e 'display notification "タスクが完了しました" with title "Codex" sound name "Ping"' >/dev/null 2>&1 || true
printf '\a' > /dev/tty 2>/dev/null || true
