#!/bin/bash

set -e

# ----------------------------
# CONTEXT (FROM CLI)
# ----------------------------
PROFILE=${PROFILE:-full}
DRY_RUN=${DRY_RUN:-false}

echo "🚀 Mac Dev Setup - Bootstrap starting..."
echo "📦 Profile: $PROFILE"

# ----------------------------
# DRY RUN (MUST BE FIRST)
# ----------------------------
if [ "$DRY_RUN" = "true" ]; then
  echo "🧪 Dry run mode activated - nothing will be executed"
  exit 0
fi

# ----------------------------
# LOGS
# ----------------------------
mkdir -p logs
LOG_FILE="logs/setup.log"

exec > >(tee -a "$LOG_FILE") 2>&1

# ----------------------------
# CONTEXT
# ----------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ----------------------------
# PROFILE LOGIC
# ----------------------------
if [ "$PROFILE" = "minimal" ]; then
  echo "⚙️ Minimal install mode"
fi

# ----------------------------
# EXECUTION
# ----------------------------
bash "$SCRIPT_DIR/brew.sh"
bash "$SCRIPT_DIR/git.sh"
bash "$SCRIPT_DIR/zsh.sh"

# ----------------------------
# POST VALIDATION
# ----------------------------
echo "🔍 Post install validation..."

command -v brew >/dev/null && echo "✔ brew ok"
command -v git >/dev/null && echo "✔ git ok"
command -v zsh >/dev/null && echo "✔ zsh ok"

# ----------------------------
# CI MODE
# ----------------------------
if [ "$CI" = "true" ]; then
  echo "🤖 Running in CI mode"
fi

echo "✅ Mac Dev Setup completed successfully!"
