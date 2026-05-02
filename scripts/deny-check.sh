#!/bin/bash

set -u

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)
patterns_file="${DENY_PATTERNS_FILE:-$script_dir/deny-bash-patterns.txt}"

input=$(cat)
command=$(printf '%s' "$input" | jq -r '.tool_input.command // empty' 2>/dev/null || printf '')
tool_name=$(printf '%s' "$input" | jq -r '.tool_name // empty' 2>/dev/null || printf '')

if [ "$tool_name" != "Bash" ]; then
  exit 0
fi

[ -f "$patterns_file" ] || exit 0

trim_command() {
  local value="$1"
  value="${value#"${value%%[![:space:]]*}"}"
  value="${value%"${value##*[![:space:]]}"}"
  printf '%s' "$value"
}

matches_deny_pattern() {
  local cmd
  local pattern="$2"

  cmd=$(trim_command "$1")

  local converted_pattern="${pattern//:/ }"
  [[ "$cmd" == $pattern ]] || [[ "$cmd" == $converted_pattern ]]
}

check_command_part() {
  local cmd_part="$1"
  local pattern

  while IFS= read -r pattern; do
    [ -z "$pattern" ] && continue

    if matches_deny_pattern "$cmd_part" "$pattern"; then
      printf "Error: command denied: '%s' (pattern: '%s')\n" "$cmd_part" "$pattern" >&2
      exit 2
    fi
  done < "$patterns_file"
}

check_command_part "$command"

split_command="${command//;/$'\n'}"
split_command="${split_command//&&/$'\n'}"
split_command="${split_command//\|\|/$'\n'}"

while IFS= read -r cmd_part; do
  [ -z "$(printf '%s' "$cmd_part" | tr -d '[:space:]')" ] && continue
  check_command_part "$cmd_part"
done <<< "$split_command"

exit 0
