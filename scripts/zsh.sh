#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
ZSH_CONFIG_DIR="$REPO_DIR/configs/zsh"

# shellcheck source=scripts/lib/logging.sh
source "$SCRIPT_DIR/lib/logging.sh"

info "[ZSH] Setup starting"

if [ -f "$ZSH_CONFIG_DIR/.zprofile" ]; then
  cp "$ZSH_CONFIG_DIR/.zprofile" ~/.zprofile
  success ".zprofile applied"
fi

if [ -f "$ZSH_CONFIG_DIR/.zshrc" ]; then
  cp "$ZSH_CONFIG_DIR/.zshrc" ~/.zshrc
  success ".zshrc applied"
fi

if [ -f "$ZSH_CONFIG_DIR/.zsh_plugins.txt" ]; then
  cp "$ZSH_CONFIG_DIR/.zsh_plugins.txt" ~/.zsh_plugins.txt
  success ".zsh_plugins.txt applied"
fi

if [ -f "$ZSH_CONFIG_DIR/.p10k.zsh" ]; then
  cp "$ZSH_CONFIG_DIR/.p10k.zsh" ~/.p10k.zsh
  success "p10k config applied"
fi

if [ -f "$ZSH_CONFIG_DIR/alias.sh" ]; then
  mkdir -p ~/.shell
  cp "$ZSH_CONFIG_DIR/alias.sh" ~/.shell/alias.sh
  success "zsh aliases applied"
fi

if [ -x "$REPO_DIR/scripts/generate-zsh-completion.sh" ]; then
  bash "$REPO_DIR/scripts/generate-zsh-completion.sh"
fi

if [ -d "$ZSH_CONFIG_DIR/completions" ]; then
  mkdir -p ~/.zsh/completions
  cp "$ZSH_CONFIG_DIR"/completions/* ~/.zsh/completions/
  success "zsh completions applied"
fi

if command -v zsh >/dev/null; then
  if ZDOTDIR="$HOME" zsh -ic '[[ "${_comps[mac]:-}" == "_mac" ]]' >/dev/null 2>&1; then
    success "mac zsh completion registered"
  else
    error "mac zsh completion could not be registered"
    exit 1
  fi
fi

success "[ZSH] Done"
