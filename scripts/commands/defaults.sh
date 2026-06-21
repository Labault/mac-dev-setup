#!/usr/bin/env bash
# Description: Apply the curated macOS system defaults.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

# shellcheck source=scripts/lib/logging.sh
source "$REPO_DIR/scripts/lib/logging.sh"

print_usage() {
  log_line "Usage: mac defaults [--help]"
  log_line ""
  log_line "Apply curated macOS system defaults:"
  log_line "  - Finder: show all extensions, hidden files, and the status bar"
  log_line "  - Dock: auto-hide, hide recents, 50px tiles, minimize into app icon"
  log_line "  - Screenshots: save to ~/Pictures/Screenshots as PNG"
  log_line "  - Keyboard: fast key repeat, short initial delay, no press-and-hold"
  log_line "  - Text: disable auto-capitalization and smart dash/quote substitution"
  log_line ""
  log_line "Settings are stored in scripts/apply-macos-defaults.sh."
  log_line "All changes are reversible via System Settings."
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

  exec bash "$REPO_DIR/scripts/apply-macos-defaults.sh"
}

main "$@"
