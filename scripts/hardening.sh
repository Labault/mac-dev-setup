#!/usr/bin/env bash

set -euo pipefail

echo "🔐 Running MacDevSetup hardening checks..."

# ----------------------------
# 1. Forbidden patterns
# ----------------------------
FORBIDDEN=(
  "orbctl"
  "brewfile"
  "lazygit"
  "watchexec"
  "hyperfine"
  "direnv"
  "mas"
)

for pattern in "${FORBIDDEN[@]}"; do
  if grep -R "$pattern" brewfiles/ >/dev/null 2>&1; then
    echo "❌ Forbidden tool detected: $pattern"
    exit 1
  fi
done

echo "✔ No forbidden tools"

# ----------------------------
# 2. Brew syntax strict check
# ----------------------------
for file in brewfiles/*; do
  echo "🔎 Checking $file"
  brew bundle check --file="$file"
done

echo "✔ Brewfiles syntax valid"

# ----------------------------
# 3. Ensure no empty installs
# ----------------------------
if grep -R 'brew ""' brewfiles/ >/dev/null 2>&1; then
  echo "❌ Empty brew declaration found"
  exit 1
fi

echo "✔ No empty declarations"

echo "🎉 Hardening checks passed"
