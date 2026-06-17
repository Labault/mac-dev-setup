#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

# shellcheck source=scripts/lib/logging.sh
source "$REPO_DIR/scripts/lib/logging.sh"

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
