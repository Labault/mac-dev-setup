#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "🔐 MacDevSetup hardening checks..."

# Tools intentionally kept out of the curated setup. The check scans the
# declared profile Brewfiles (the contract this repository owns) instead of
# the machine's global `brew list`, which may legitimately contain these for
# unrelated reasons and would otherwise produce false positives.
FORBIDDEN_TOOLS="lazygit watchexec hyperfine direnv mas orbctl"

echo "✔ Checking forbidden tools in profiles..."
for tool in $FORBIDDEN_TOOLS; do
  if grep -RFq "\"$tool\"" "$REPO_DIR/profiles"; then
    echo "❌ Forbidden tool declared in a profile Brewfile: $tool"
    exit 1
  fi
done

if [ "${GITHUB_ACTIONS:-}" = "true" ]; then
  echo "ℹ Skipping host-global brew doctor/outdated checks on GitHub-hosted runners"
elif command -v brew >/dev/null 2>&1; then
  echo "✔ Checking brew doctor..."
  brew doctor || true

  echo "✔ Checking outdated packages..."
  brew outdated || true
fi

echo "✔ Hardening complete"
