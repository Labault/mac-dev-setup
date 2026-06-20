#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
GITCONFIG="$REPO_DIR/configs/git/.gitconfig"

# shellcheck source=scripts/lib/logging.sh
source "$SCRIPT_DIR/lib/logging.sh"

info "[GIT] Setup starting"

if [ -f "$GITCONFIG" ]; then
  if git config --global --get-all include.path 2>/dev/null | grep -Fx "$GITCONFIG" >/dev/null; then
    git config --global --fixed-value --unset-all include.path "$GITCONFIG" 2>/dev/null \
      || git config --global --unset-all include.path "$GITCONFIG" 2>/dev/null \
      || true
  fi

  git config --global --no-includes --add include.path "$GITCONFIG"
  success "gitconfig applied"
else
  warn "$GITCONFIG not found"
fi

success "[GIT] Done"
