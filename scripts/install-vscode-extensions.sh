#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
readonly ROOT_DIR
readonly REQUIRED_FILE="$ROOT_DIR/configs/vscode/extensions.txt"
readonly OPTIONAL_FILE="$ROOT_DIR/configs/vscode/extensions-optional.txt"

install_extensions() {
  local file="$1"

  while IFS= read -r extension || [[ -n "$extension" ]]; do
    [[ -z "$extension" || "$extension" == \#* ]] && continue

    if code --list-extensions | grep -Fqx "$extension"; then
      printf 'Already installed: %s\n' "$extension"
    else
      printf 'Installing: %s\n' "$extension"
      code --install-extension "$extension"
    fi
  done < "$file"
}

if ! command -v code >/dev/null 2>&1; then
  printf 'Error: the VS Code "code" command is unavailable.\n' >&2
  exit 1
fi

if [[ ! -f "$REQUIRED_FILE" ]]; then
  printf 'Error: required extension list not found: %s\n' "$REQUIRED_FILE" >&2
  exit 1
fi

printf 'Installing recommended VS Code extensions...\n'
install_extensions "$REQUIRED_FILE"

if [[ "${1:-}" == "--with-optional" ]]; then
  if [[ ! -f "$OPTIONAL_FILE" ]]; then
    printf 'Error: optional extension list not found: %s\n' "$OPTIONAL_FILE" >&2
    exit 1
  fi

  printf '\nInstalling optional VS Code extensions...\n'
  install_extensions "$OPTIONAL_FILE"
fi

printf '\nVS Code extension installation completed.\n'
