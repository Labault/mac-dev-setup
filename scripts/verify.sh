#!/usr/bin/env bash

set -euo pipefail

echo "🧪 Verifying MacDevSetup..."

# ----------------------------
# Brewfiles existence
# ----------------------------
for file in \
  brewfiles/Brewfile.base \
  brewfiles/Brewfile.dev \
  brewfiles/Brewfile.casks
do
  if [ ! -f "$file" ]; then
    echo "❌ Missing: $file"
    exit 1
  fi
done

echo "✔ Brewfiles exist"

# ----------------------------
# Brew syntax check
# ----------------------------
brew bundle check --file=brewfiles/Brewfile.base >/dev/null
brew bundle check --file=brewfiles/Brewfile.dev >/dev/null
brew bundle check --file=brewfiles/Brewfile.casks >/dev/null

echo "✔ Brewfile syntax valid"

# ----------------------------
# Check forbidden tools
# ----------------------------
if grep -q "orbctl" brewfiles/*; then
  echo "❌ Forbidden tool detected: orbctl"
  exit 1
fi

echo "✔ No forbidden tools detected"

echo "🔐 Running hardening layer..."
./scripts/hardening.sh

echo "✅ All checks passed!"
