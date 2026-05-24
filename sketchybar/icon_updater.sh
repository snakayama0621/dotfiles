#!/usr/bin/env bash

set -euo pipefail

tmp_dir=$(mktemp -d "${TMPDIR:-/tmp}/sketchybar-icons.XXXXXX")
repo_dir="$tmp_dir/sketchybar-app-font-bg"
trap 'rm -rf "$tmp_dir"' EXIT

git clone https://github.com/SoichiroYamane/sketchybar-app-font-bg "$repo_dir"

cd "$repo_dir"

pnpm install
echo "done: pnpm install"

pnpm run build:install
echo "done: pnpm run build:install"

mkdir -p "$HOME/Library/Fonts" "$HOME/.config/sketchybar/helpers"

# replace ttf
install -m 0644 public/dist/sketchybar-app-font-bg.ttf "$HOME/Library/Fonts/sketchybar-app-font-bg.ttf"

# replace icon_map.lua
install -m 0644 public/dist/icon_map.lua "$HOME/.config/sketchybar/helpers/icon_map.lua"

echo "Font installed successfully to $HOME/Library/Fonts/sketchybar-app-font-bg.ttf"

brew services restart sketchybar
