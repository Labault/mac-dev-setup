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

suggest_commands() {
  requested_command="$1"
  command_records="$(command_registry_build "$COMMANDS_DIR")"

  if [ -z "$requested_command" ] || [ -z "$command_records" ]; then
    return 0
  fi

  printf '%s\n' "$command_records" | awk -F "$COMMAND_REGISTRY_FIELD_SEPARATOR" -v requested="$requested_command" '
    function min(a, b, c) {
      value = a
      if (b < value) {
        value = b
      }
      if (c < value) {
        value = c
      }
      return value
    }

    function levenshtein(a, b, i, j, cost) {
      delete distance

      for (i = 0; i <= length(a); i++) {
        distance[i, 0] = i
      }
      for (j = 0; j <= length(b); j++) {
        distance[0, j] = j
      }

      for (i = 1; i <= length(a); i++) {
        for (j = 1; j <= length(b); j++) {
          cost = (substr(a, i, 1) == substr(b, j, 1)) ? 0 : 1
          distance[i, j] = min(distance[i - 1, j] + 1, distance[i, j - 1] + 1, distance[i - 1, j - 1] + cost)
        }
      }

      return distance[length(a), length(b)]
    }

    {
      score = levenshtein(requested, $1)

      if (index($1, requested) == 1 || index(requested, $1) == 1) {
        score = 0
      } else if (index($1, requested) > 0 || index(requested, $1) > 0) {
        score = 1
      }

      if (score <= 3) {
        suggestions[$1] = score
      }
    }

    END {
      for (i = 1; i <= 3; i++) {
        best_command = ""
        best_score = 4

        for (command in suggestions) {
          if (suggestions[command] < best_score || (suggestions[command] == best_score && command < best_command)) {
            best_command = command
            best_score = suggestions[command]
          }
        }

        if (best_command == "") {
          break
        }

        print best_command
        delete suggestions[best_command]
      }
    }
  '
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

handle_unknown_command() {
  command_name="$1"
  suggestions="$(suggest_commands "$command_name")"

  error "Unknown command: $command_name"

  if [ -n "$suggestions" ]; then
    log_line ""
    log_line "Did you mean?"
    printf '%s\n' "$suggestions" | while IFS= read -r suggested_command; do
      log_line "  mac $suggested_command"
    done
  fi

  log_line ""
  print_usage
  exit 1
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
        handle_unknown_command "$command_name"
      fi

      print_usage
      exit 1
      ;;
  esac
}

execute_command "$@"
