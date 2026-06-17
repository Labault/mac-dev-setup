#!/usr/bin/env bash

set -euo pipefail

echo "🧪 Verifying MacDevSetup..."

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

# shellcheck source=scripts/lib/profiles.sh
source "$SCRIPT_DIR/lib/profiles.sh"

# ----------------------------
# Profile Brewfiles existence
# ----------------------------
profiles="$(profile_list "$REPO_DIR")"

if [ -z "$profiles" ]; then
  echo "❌ No setup profiles found"
  exit 1
fi

for profile in $profiles; do
  brewfile="$(profile_brewfile "$REPO_DIR" "$profile")"

  if [ ! -f "$brewfile" ]; then
    echo "❌ Missing: $brewfile"
    exit 1
  fi
done

echo "✔ Profile Brewfiles exist"

# ----------------------------
# Brew profile check
# ----------------------------
for profile in $profiles; do
  brew bundle check --file="$(profile_brewfile "$REPO_DIR" "$profile")" >/dev/null
done

echo "✔ Profile Brewfiles satisfied"

# ----------------------------
# Check forbidden tools
# ----------------------------
if grep -Rq "orbctl" "$REPO_DIR/profiles"; then
  echo "❌ Forbidden tool detected: orbctl"
  exit 1
fi

echo "✔ No forbidden tools detected"

echo "🔐 Running hardening layer..."
./scripts/hardening.sh

echo "✅ All checks passed!"
