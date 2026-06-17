#!/bin/bash
# Description: Run system diagnostics for the macOS development setup.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

# shellcheck source=scripts/lib/logging.sh
source "$REPO_DIR/scripts/lib/logging.sh"

print_usage() {
  log_line "Usage: mac doctor [--help]"
  log_line ""
  log_line "Run read-only diagnostics for the macOS development setup."
}

parse_args() {
  while [ "$#" -gt 0 ]; do
    case "$1" in
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
}

main() {
  parse_args "$@"

  info "Mac Doctor - System diagnostics"

  log_section "System"
  log_line "OS: $(sw_vers -productName) $(sw_vers -productVersion)"
  log_line "Arch: $(uname -m)"

  log_section "Tools"

  if command -v brew >/dev/null; then
    success "brew installed"
  else
    error "brew missing"
  fi

  if command -v git >/dev/null; then
    success "git installed"
  else
    error "git missing"
  fi

  if command -v zsh >/dev/null; then
    success "zsh installed"
  else
    error "zsh missing"
  fi

  log_section "Homebrew"

  if command -v brew >/dev/null; then
    if brew doctor >/dev/null 2>&1; then
      success "brew OK"
    else
      warn "brew warnings"
    fi
  fi

  log_section "mac CLI"

  if command -v mac >/dev/null; then
    success "mac CLI OK"
  else
    error "mac CLI missing"
  fi

  log_line ""
  success "Doctor done"
}

main "$@"
