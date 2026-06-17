#!/usr/bin/env bash

set -euo pipefail

# IMPORTANT: always run from repo root
cd "$(dirname "$0")/.."

echo "🚀 MacDevSetup bootstrap starting..."

# ----------------------------
# 1. Check Homebrew
# ----------------------------
if ! command -v brew >/dev/null 2>&1; then
  echo "📦 Homebrew not found. Installing..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo "✅ Homebrew OK"

# ----------------------------
# 2. Update Brew
# ----------------------------
echo "🔄 Updating Homebrew..."
brew update

# ----------------------------
# 3. Install Brewfiles (split)
# ----------------------------
echo "📦 Installing base..."
brew bundle --file=brewfiles/Brewfile.base

echo "📦 Installing dev..."
brew bundle --file=brewfiles/Brewfile.dev

echo "📦 Installing casks..."
brew bundle --file=brewfiles/Brewfile.casks

# ----------------------------
# 4. Basic verification
# ----------------------------
echo "🧪 Running sanity checks..."

command -v git >/dev/null && echo "✔ git"
command -v jq >/dev/null && echo "✔ jq"
command -v orbctl >/dev/null && echo "✔ orbctl"
command -v gitleaks >/dev/null && echo "✔ gitleaks"
command -v shellcheck >/dev/null && echo "✔ shellcheck"

if [ -d "/Applications/OrbStack.app" ]; then
  echo "✔ OrbStack installed"
else
  echo "⚠ OrbStack missing"
fi

echo "🧪 Running pre/post verification..."
./scripts/verify.sh

echo "🎉 Bootstrap completed successfully!"
