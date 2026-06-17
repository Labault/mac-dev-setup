#!/bin/bash

set -e

echo "🍺 [BREW] Setup starting..."

# Install Homebrew if needed
if ! command -v brew >/dev/null 2>&1; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo "Updating Homebrew..."
brew update

echo "Installing Brewfile dependencies..."

if [ -f "brew/Brewfile" ]; then
  brew bundle check --file=brew/Brewfile || brew bundle --file=brew/Brewfile
else
  echo "ERROR: brew/Brewfile not found"
  exit 1
fi

echo "🍺 [BREW] Done"
