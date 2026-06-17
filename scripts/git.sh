#!/bin/bash

set -e

echo "🔧 [GIT] Setup starting..."

if [ -f "git/gitconfig" ]; then
  cp git/gitconfig ~/.gitconfig
  echo "Git config applied"
else
  echo "No git config found, skipping"
fi

echo "🔧 [GIT] Done"
