#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
ZSH_CONFIG_DIR="$REPO_DIR/configs/zsh"

echo "🐚 [ZSH] Setup starting..."

if [ -f "$ZSH_CONFIG_DIR/.zshrc" ]; then
  cp "$ZSH_CONFIG_DIR/.zshrc" ~/.zshrc
  echo "✔ .zshrc applied"
fi

if [ -f "$ZSH_CONFIG_DIR/.p10k.zsh" ]; then
  cp "$ZSH_CONFIG_DIR/.p10k.zsh" ~/.p10k.zsh
  echo "✔ p10k config applied"
fi

if [ -d "$ZSH_CONFIG_DIR/completions" ]; then
  mkdir -p ~/.zsh/completions
  cp "$ZSH_CONFIG_DIR"/completions/* ~/.zsh/completions/
  echo "✔ zsh completions applied"
fi

# reload shell config (safe)
source ~/.zshrc 2>/dev/null || true

echo "🐚 [ZSH] Done"
