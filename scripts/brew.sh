#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=scripts/lib/logging.sh
source "$SCRIPT_DIR/lib/logging.sh"

info "[BREW] Setup starting"

# Install Homebrew if needed
if ! command -v brew >/dev/null 2>&1; then
  info "Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

info "Updating Homebrew"
brew update

info "Installing Brewfile dependencies"

if [ -f "brew/Brewfile" ]; then
  brew bundle check --file=brew/Brewfile || brew bundle --file=brew/Brewfile
else
  error "brew/Brewfile not found"
  exit 1
fi

success "[BREW] Done"
