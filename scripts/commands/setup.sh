#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

# shellcheck source=scripts/lib/logging.sh
source "$REPO_DIR/scripts/lib/logging.sh"

print_usage() {
  log_line "Usage: mac setup [--profile full|minimal] [--dry-run]"
}

main() {
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

  if PROFILE="$PROFILE" DRY_RUN="$DRY_RUN" bash "$REPO_DIR/scripts/setup.sh"; then
    return 0
  fi

  error "Setup failed"
  exit 1
}

main "$@"
