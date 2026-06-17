#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
ZSH_CONFIG_DIR="$REPO_DIR/configs/zsh"

# shellcheck source=scripts/lib/logging.sh
source "$SCRIPT_DIR/lib/logging.sh"

info "[ZSH] Setup starting"

if [ -f "$ZSH_CONFIG_DIR/.zshrc" ]; then
  cp "$ZSH_CONFIG_DIR/.zshrc" ~/.zshrc
  success ".zshrc applied"
fi

if [ -f "$ZSH_CONFIG_DIR/.p10k.zsh" ]; then
  cp "$ZSH_CONFIG_DIR/.p10k.zsh" ~/.p10k.zsh
  success "p10k config applied"
fi

if [ -x "$REPO_DIR/scripts/generate-zsh-completion.sh" ]; then
  bash "$REPO_DIR/scripts/generate-zsh-completion.sh"
fi

if [ -d "$ZSH_CONFIG_DIR/completions" ]; then
  mkdir -p ~/.zsh/completions
  cp "$ZSH_CONFIG_DIR"/completions/* ~/.zsh/completions/
  success "zsh completions applied"
fi

# reload shell config (safe)
# shellcheck source=/dev/null
source ~/.zshrc 2>/dev/null || true

success "[ZSH] Done"
