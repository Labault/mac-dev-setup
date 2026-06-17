#!/bin/bash

set -e

echo "🐚 [ZSH] Setup starting..."

if [ -f "zsh/.zshrc" ]; then
  cp zsh/.zshrc ~/.zshrc
fi

if [ -f "zsh/p10k.zsh" ]; then
  cp zsh/p10k.zsh ~/.p10k.zsh
fi

echo "🐚 [ZSH] Done"
