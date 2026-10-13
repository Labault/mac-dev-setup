#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
PROFILE="${PROFILE:-}"

# shellcheck source=scripts/lib/logging.sh
source "$SCRIPT_DIR/lib/logging.sh"
# shellcheck source=scripts/lib/profiles.sh
source "$SCRIPT_DIR/lib/profiles.sh"

# shellcheck source=scripts/lib/homebrew.sh
source "$SCRIPT_DIR/lib/homebrew.sh"

PROFILE="${PROFILE:-$(profile_default)}"
BREWFILE="$(profile_brewfile "$REPO_DIR" "$PROFILE")"

brewfile_entry_count() {
  awk '
    /^[[:space:]]*(brew|cask|tap)[[:space:]]+"/ {
      count++
    }
    END {
      print count + 0
    }
  ' "$BREWFILE"
}

if ! profile_validate "$REPO_DIR" "$PROFILE"; then
  error "Invalid profile: $PROFILE"
  info "Available profiles: $(profile_list "$REPO_DIR")"
  exit 1
fi

info "[BREW] Setup starting"
info "[BREW] Profile: $PROFILE"

# The downloaded installer runs in a child shell; activate its result here.
if activate_homebrew; then
  :
else
  activation_status=$?
  if [ "$activation_status" -ne 1 ]; then
    error "Cannot activate existing Homebrew environment"
    exit 1
  fi
  info "Installing Homebrew"
  if ! installer="$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; then
    error "Cannot download Homebrew installer"
    exit 1
  fi
  if ! /bin/bash -c "$installer"; then
    error "Homebrew installation failed"
    exit 1
  fi
  if ! activate_homebrew; then
    error "Homebrew executable not found or shellenv failed after installation"
    exit 1
  fi
fi

info "Updating Homebrew"
brew update

info "Installing Brewfile dependencies"

if [ -f "$BREWFILE" ]; then
  entry_count="$(brewfile_entry_count)"
  info "Checking $entry_count Brewfile entries"
  info "Homebrew may pause on 'Fetching ...' while it downloads packages and apps"
  brew bundle check --file="$BREWFILE" || brew bundle --file="$BREWFILE"
else
  error "$BREWFILE not found"
  exit 1
fi

success "[BREW] Done"
