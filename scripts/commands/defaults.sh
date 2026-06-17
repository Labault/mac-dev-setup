#!/bin/bash
# Description: Apply the curated macOS system defaults.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

# shellcheck source=scripts/lib/logging.sh
source "$REPO_DIR/scripts/lib/logging.sh"

print_usage() {
  log_line "Usage: mac defaults [--help]"
  log_line ""
  log_line "Apply the curated Finder, Dock, screenshot, and keyboard defaults."
}

main() {
  case "${1:-}" in
    "") ;;
    --help | -h)
      print_usage
      exit 0
      ;;
    *)
      error "Unknown option: $1"
      print_usage >&2
      exit 1
      ;;
  esac

  exec bash "$REPO_DIR/scripts/apply-macos-defaults.sh"
}

main "$@"
