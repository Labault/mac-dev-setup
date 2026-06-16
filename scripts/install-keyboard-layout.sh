#!/usr/bin/env bash

set -euo pipefail

SOURCE_DIR="configs/keyboard/Francais-OSS-Mac.bundle"
TARGET_DIR="$HOME/Library/Keyboard Layouts/Francais-OSS-Mac.bundle"

if [[ ! -d "$SOURCE_DIR" ]]; then
  printf 'Error: keyboard layout bundle not found: %s\n' "$SOURCE_DIR" >&2
  exit 1
fi

mkdir -p "$HOME/Library/Keyboard Layouts"

if [[ -d "$TARGET_DIR" ]]; then
  BACKUP_DIR="$HOME/Documents/Backups/keyboard-layouts"
  BACKUP_PATH="$BACKUP_DIR/Francais-OSS-Mac.bundle.$(date +%Y%m%d-%H%M%S)"

  mkdir -p "$BACKUP_DIR"
  cp -a "$TARGET_DIR" "$BACKUP_PATH"

  printf 'Existing keyboard layout backed up to:\n%s\n' "$BACKUP_PATH"
  rm -rf "$TARGET_DIR"
fi

cp -a "$SOURCE_DIR" "$TARGET_DIR"

printf 'Keyboard layout installed in:\n%s\n' "$TARGET_DIR"
printf '\nLog out and back in, then enable "Francais OSS Mac" in macOS Input Sources.\n'
