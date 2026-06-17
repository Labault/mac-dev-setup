#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
PROFILE="${PROFILE:-}"

# shellcheck source=scripts/lib/logging.sh
source "$SCRIPT_DIR/lib/logging.sh"
# shellcheck source=scripts/lib/profiles.sh
source "$SCRIPT_DIR/lib/profiles.sh"

PROFILE="${PROFILE:-$(profile_default)}"
BREWFILE="$(profile_brewfile "$REPO_DIR" "$PROFILE")"

if ! profile_validate "$REPO_DIR" "$PROFILE"; then
  error "Invalid profile: $PROFILE"
  info "Available profiles: $(profile_list "$REPO_DIR")"
  exit 1
fi

info "[BREW] Setup starting"
info "[BREW] Profile: $PROFILE"

# Install Homebrew if needed
if ! command -v brew >/dev/null 2>&1; then
  info "Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

info "Updating Homebrew"
brew update

info "Installing Brewfile dependencies"

if [ -f "$BREWFILE" ]; then
  brew bundle check --file="$BREWFILE" || brew bundle --file="$BREWFILE"
else
  error "$BREWFILE not found"
  exit 1
fi

success "[BREW] Done"
