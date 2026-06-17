#!/usr/bin/env bash

set -euo pipefail

echo "🚀 Installing MacDevSetup..."

TMP_DIR="$HOME/.mac-dev-setup"

if [ -d "$TMP_DIR" ]; then
  echo "Updating existing installation..."
  git -C "$TMP_DIR" pull
else
  git clone https://github.com/labault/mac-dev-setup.git "$TMP_DIR"
fi

cd "$TMP_DIR"

./scripts/bootstrap.sh

echo "🎉 Setup complete"
