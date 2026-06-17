#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
ZSH_CONFIG_DIR="$REPO_DIR/configs/zsh"
BACKUP_DIR="$HOME/Documents/Backups/mac-dev-setup/zsh"

# shellcheck source=scripts/lib/logging.sh
source "$SCRIPT_DIR/lib/logging.sh"

info "[ZSH] Setup starting"

backup_target_if_needed() {
  source_file="$1"
  target_file="$2"
  label="$3"

  if [ ! -f "$target_file" ] || cmp -s "$source_file" "$target_file"; then
    return 0
  fi

  mkdir -p "$BACKUP_DIR"
  backup_file="$BACKUP_DIR/$(basename "$target_file").$(date +%Y%m%d-%H%M%S).backup"
  cp -p "$target_file" "$backup_file"
  info "Backed up existing $label to $backup_file"
}

install_file() {
  source_file="$1"
  target_file="$2"
  label="$3"

  if [ ! -f "$source_file" ]; then
    return 0
  fi

  mkdir -p "$(dirname "$target_file")"
  backup_target_if_needed "$source_file" "$target_file" "$label"

  if [ -f "$target_file" ] && cmp -s "$source_file" "$target_file"; then
    success "$label already up to date"
    return 0
  fi

  cp "$source_file" "$target_file"
  success "$label applied"
}

install_file "$ZSH_CONFIG_DIR/.zprofile" "$HOME/.zprofile" ".zprofile"
install_file "$ZSH_CONFIG_DIR/.zshrc" "$HOME/.zshrc" ".zshrc"
install_file "$ZSH_CONFIG_DIR/.zsh_plugins.txt" "$HOME/.zsh_plugins.txt" ".zsh_plugins.txt"
install_file "$ZSH_CONFIG_DIR/.p10k.zsh" "$HOME/.p10k.zsh" "p10k config"
install_file "$ZSH_CONFIG_DIR/alias.sh" "$HOME/.shell/alias.sh" "zsh aliases"

# The completion file is generated and committed during development (and
# verified in CI), so setup installs the versioned copy as-is instead of
# regenerating it inside the install tree.
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
