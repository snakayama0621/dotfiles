#!/bin/bash

set -u

input=$(cat)

format_file() {
  local file_path="$1"

  [ -n "$file_path" ] || return 0
  [ -f "$file_path" ] || return 0

  case "$file_path" in
    *.js|*.ts|*.jsx|*.tsx|*.json|*.css|*.md)
      npx prettier --write "$file_path" >/dev/null 2>&1 || true
      ;;
    *.py)
      black "$file_path" >/dev/null 2>&1 || true
      ;;
  esac
}

direct_file=$(printf '%s' "$input" | jq -r '.tool_input.file_path // empty' 2>/dev/null || printf '')
format_file "$direct_file"

patch_command=$(printf '%s' "$input" | jq -r '.tool_input.command // empty' 2>/dev/null || printf '')

printf '%s\n' "$patch_command" |
  sed -n 's/^\*\*\* \(Add\|Update\) File: //p' |
  while IFS= read -r file_path; do
    format_file "$file_path"
  done

exit 0
