#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
GITCONFIG="$REPO_DIR/configs/git/.gitconfig"

# shellcheck source=scripts/lib/logging.sh
source "$SCRIPT_DIR/lib/logging.sh"

info "[GIT] Setup starting"

if [ -f "$GITCONFIG" ]; then
  git config --global --no-includes --unset-all include.path 2>/dev/null || true
  git config --global --no-includes --add include.path "$GITCONFIG"
  success "gitconfig applied"
else
  warn "$GITCONFIG not found"
fi

# Optional: global identity (important)
git config --global init.defaultBranch main

success "[GIT] Done"
