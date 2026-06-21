#!/usr/bin/env bash
# Description: Install the French OSS keyboard layout.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

# shellcheck source=scripts/lib/logging.sh
source "$REPO_DIR/scripts/lib/logging.sh"

print_usage() {
  log_line "Usage: mac keyboard [--help]"
  log_line ""
  log_line "Install the bundled French OSS Mac keyboard layout. Log out and"
  log_line "back in, then enable it in macOS Input Sources."
}

main() {
  case "${1:-}" in
    "") ;;
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

  exec bash "$REPO_DIR/scripts/install-keyboard-layout.sh"
}

main "$@"
