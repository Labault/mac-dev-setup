#!/usr/bin/env bash
# Description: Install the curated VS Code extensions.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

# shellcheck source=scripts/lib/logging.sh
source "$REPO_DIR/scripts/lib/logging.sh"

print_usage() {
  log_line "Usage: mac vscode [--with-optional] [--help]"
  log_line ""
  log_line "Install the recommended VS Code extensions, optionally including"
  log_line "the optional set with --with-optional."
}

main() {
  case "${1:-}" in
    --help|-h)
      print_usage
      exit 0
      ;;
  esac

  exec bash "$REPO_DIR/scripts/install-vscode-extensions.sh" "$@"
}

main "$@"
