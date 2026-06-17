#!/bin/bash
# Description: Install and configure the macOS development setup.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

# shellcheck source=scripts/lib/logging.sh
source "$REPO_DIR/scripts/lib/logging.sh"
# shellcheck source=scripts/lib/profiles.sh
source "$REPO_DIR/scripts/lib/profiles.sh"

print_usage() {
  log_line "Usage: mac setup [--profile <profile>] [--dry-run]"
  log_line "Profiles: $(profile_list "$REPO_DIR")"
}

main() {
  PROFILE="$(profile_default)"
  DRY_RUN="false"

  while [ "$#" -gt 0 ]; do
    case "$1" in
      --profile)
        PROFILE="${2:-}"
        if [ -z "$PROFILE" ] || [ "${PROFILE#--}" != "$PROFILE" ]; then
          error "Missing value for --profile"
          print_usage >&2
          exit 1
        fi
        shift 2
        ;;
      --profile=*)
        PROFILE="${1#*=}"
        if [ -z "$PROFILE" ]; then
          error "Missing value for --profile"
          print_usage >&2
          exit 1
        fi
        shift
        ;;
      --dry-run)
        DRY_RUN="true"
        shift
        ;;
      --help|-h)
        print_usage
        exit 0
        ;;
      *)
        error "Unknown option: $1"
        print_usage >&2
        exit 1
        ;;
    esac
  done

  if ! profile_validate "$REPO_DIR" "$PROFILE"; then
    error "Invalid profile: $PROFILE"
    print_usage >&2
    exit 1
  fi

  if PROFILE="$PROFILE" DRY_RUN="$DRY_RUN" bash "$REPO_DIR/scripts/setup.sh"; then
    return 0
  fi

  error "Setup failed"
  exit 1
}

main "$@"
