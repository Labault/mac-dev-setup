#!/bin/bash

set -e

# ----------------------------
# CONTEXT (FROM CLI)
# ----------------------------
PROFILE=${PROFILE:-full}
DRY_RUN=${DRY_RUN:-false}

# ----------------------------
# CONTEXT
# ----------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=scripts/lib/logging.sh
source "$SCRIPT_DIR/lib/logging.sh"

info "Mac Dev Setup - Bootstrap starting"
info "Profile: $PROFILE"

# ----------------------------
# DRY RUN (MUST BE FIRST)
# ----------------------------
if [ "$DRY_RUN" = "true" ]; then
  info "Dry run mode activated - nothing will be executed"
  exit 0
fi

# ----------------------------
# LOGS
# ----------------------------
mkdir -p logs
LOG_FILE="logs/setup.log"

exec > >(tee -a "$LOG_FILE") 2>&1

# ----------------------------
# PROFILE LOGIC
# ----------------------------
if [ "$PROFILE" = "minimal" ]; then
  info "Minimal install mode"
fi

# ----------------------------
# EXECUTION
# ----------------------------
bash "$SCRIPT_DIR/brew.sh"
bash "$SCRIPT_DIR/git.sh"
bash "$SCRIPT_DIR/zsh.sh"

# ----------------------------
# POST VALIDATION
# ----------------------------
info "Post install validation"

command -v brew >/dev/null && success "brew ok"
command -v git >/dev/null && success "git ok"
command -v zsh >/dev/null && success "zsh ok"

# ----------------------------
# CI MODE
# ----------------------------
if [ "$CI" = "true" ]; then
  info "Running in CI mode"
fi

success "Mac Dev Setup completed successfully"
