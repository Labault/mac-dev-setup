#!/usr/bin/env bash

set -euo pipefail

echo "🔐 MacDevSetup hardening checks..."

echo "✔ Checking forbidden tools..."
if brew list | grep -E "lazygit|watchexec|hyperfine|direnv|mas" >/dev/null 2>&1; then
  echo "❌ Forbidden tool detected"
  exit 1
fi

echo "✔ Checking brew doctor..."
brew doctor || true

echo "✔ Checking outdated packages..."
brew outdated || true

echo "✔ Hardening complete"
