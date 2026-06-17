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

print_usage() {
  log_line "Usage: mac setup [--profile full|minimal] [--dry-run]"
  log_line "       mac doctor"
}

print_help() {
  log_line "mac CLI"
  log_line ""
  log_line "Commands:"
  log_line "  setup   Install mac dev environment"
  log_line "  doctor  Diagnose system"
}

run_setup() {
  PROFILE="full"
  DRY_RUN="false"

  while [ "$#" -gt 0 ]; do
    case "$1" in
      --profile)
        PROFILE="${2:-}"
        shift 2
        ;;
      --profile=*)
        PROFILE="${1#*=}"
        shift
        ;;
      --dry-run)
        DRY_RUN="true"
        shift
        ;;
      *)
        error "Unknown option: $1"
        print_usage >&2
        exit 1
        ;;
    esac
  done

  case "$PROFILE" in
    full|minimal) ;;
    *)
      error "Invalid profile: $PROFILE"
      print_usage >&2
      exit 1
      ;;
  esac

  if ! PROFILE="$PROFILE" DRY_RUN="$DRY_RUN" bash "$REPO_DIR/scripts/setup.sh"; then
    error "Setup failed"
    exit 1
  fi
}

run_command_script() {
  command_name="$1"
  shift

  command_script="$REPO_DIR/scripts/commands/$command_name.sh"

  if [ ! -f "$command_script" ]; then
    error "Command script not found: $command_name"
    exit 1
  fi

  if ! bash "$command_script" "$@"; then
    error "Command failed: $command_name"
    exit 1
  fi
}

execute_command() {
  command_name="${1:-}"

  if [ "$#" -gt 0 ]; then
    shift
  fi

  case "$command_name" in
    setup)
      run_setup "$@"
      ;;
    doctor)
      run_command_script "$command_name" "$@"
      ;;
    help|--help|-h)
      print_help
      ;;
    *)
      if [ -n "$command_name" ]; then
        error "Unknown command: $command_name"
      fi
      print_usage
      exit 1
      ;;
  esac
}

execute_command "$@"
