#!/bin/bash

set -e

echo "🚀 Mac Dev Setup - Bootstrap starting..."

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

bash "$SCRIPT_DIR/brew.sh"
bash "$SCRIPT_DIR/git.sh"
bash "$SCRIPT_DIR/zsh.sh"

echo "✅ Mac Dev Setup completed successfully!"
