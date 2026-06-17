#!/usr/bin/env bash

set -euo pipefail

echo "🚀 MacDevSetup installer starting..."

# ----------------------------
# Clone repo in temp dir
# ----------------------------
TMP_DIR="$HOME/.mac-dev-setup"

if [ -d "$TMP_DIR" ]; then
  echo "📦 Repo already exists, pulling latest..."
  git -C "$TMP_DIR" pull
else
  echo "📦 Cloning repo..."
  git clone https://github.com/labault/mac-dev-setup.git "$TMP_DIR"
fi

cd "$TMP_DIR"

# ----------------------------
# Run bootstrap
# ----------------------------
echo "⚙️ Running bootstrap..."
./scripts/bootstrap.sh

echo "🎉 MacDevSetup installed successfully!"
