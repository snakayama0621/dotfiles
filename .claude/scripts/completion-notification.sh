#!/bin/bash
/usr/bin/afplay /System/Library/Sounds/Ping.aiff
osascript -e 'display notification "タスクが完了しました" with title "Claude Code" sound name "Ping"'
# WezTermのタブ通知用にベルを送信
printf '\a' > /dev/tty 2>/dev/null || true
