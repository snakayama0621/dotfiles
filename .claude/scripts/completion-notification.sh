#!/bin/bash

set -euo pipefail

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)
repo_root=$(CDPATH= cd -- "$script_dir/../.." && pwd -P)

exec /bin/bash "$repo_root/scripts/notify.sh" "Claude Code" "タスクが完了しました"
