#!/bin/bash

set -e

# Resolve real repo path from symlink
REAL_PATH="$(readlink "$0" || true)"
if [ -z "$REAL_PATH" ]; then
  REAL_PATH="$0"
fi
REPO_DIR="$(cd "$(dirname "$REAL_PATH")/.." && pwd)"

# shellcheck source=scripts/lib/logging.sh
source "$REPO_DIR/scripts/lib/logging.sh"
# shellcheck source=scripts/lib/command_discovery.sh
source "$REPO_DIR/scripts/lib/command_discovery.sh"

COMMANDS_DIR="$REPO_DIR/scripts/commands"

print_usage() {
  log_line "Usage: mac <command> [options]"
  log_line "Run 'mac help' to list available commands."
}

print_help() {
  command_records="$(command_registry_build "$COMMANDS_DIR")"

  log_line "mac CLI"
  log_line ""
  log_line "Usage:"
  log_line "  mac <command> [options]"
  log_line ""
  log_line "Commands:"

  if [ -z "$command_records" ]; then
    log_line "  No commands available."
    return 0
  fi

  printf '%s\n' "$command_records" | awk -F "$COMMAND_REGISTRY_FIELD_SEPARATOR" '
    {
      commands[NR] = $1
      descriptions[NR] = $3

      if (length($1) > max_command_length) {
        max_command_length = length($1)
      }
    }
    END {
      for (i = 1; i <= NR; i++) {
        if (descriptions[i] == "") {
          printf "  %s\n", commands[i]
        } else {
          printf "  %-*s  %s\n", max_command_length, commands[i], descriptions[i]
        }
      }
    }
  '
}

run_command_script() {
  command_name="$1"
  shift

  command_script="$(command_script_path "$COMMANDS_DIR" "$command_name")"

  if [ -z "$command_script" ]; then
    error "Command script not found: $command_name"
    exit 1
  fi

  bash "$command_script" "$@"
}

execute_command() {
  command_name="${1:-}"

  if [ "$#" -gt 0 ]; then
    shift
  fi

  case "$command_name" in
    help|--help|-h)
      print_help
      ;;
    *)
      if command_exists "$COMMANDS_DIR" "$command_name"; then
        run_command_script "$command_name" "$@"
        return
      fi

      if [ -n "$command_name" ]; then
        error "Unknown command: $command_name"
      fi
      print_usage
      exit 1
      ;;
  esac
}

execute_command "$@"
