#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
readonly ROOT_DIR

run_homebrew=false
run_vscode=false
run_keyboard=false
run_macos=false
run_warp=false

usage() {
  cat <<'USAGE'
Usage: ./scripts/setup.sh [options]

Options:
  --all         Run all supported setup steps
  --homebrew    Install Brewfile dependencies
  --vscode      Install recommended VS Code extensions
  --keyboard    Install the French OSS keyboard layout
  --macos       Apply macOS defaults
  --warp        Install the versioned Warp configuration
  --help        Show this help message
USAGE
}

if [[ $# -eq 0 ]]; then
  usage
  exit 1
fi

while [[ $# -gt 0 ]]; do
  case "$1" in
    --all)
      run_homebrew=true
      run_vscode=true
      run_keyboard=true
      run_macos=true
      run_warp=true
      ;;
    --homebrew)
      run_homebrew=true
      ;;
    --vscode)
      run_vscode=true
      ;;
    --keyboard)
      run_keyboard=true
      ;;
    --macos)
      run_macos=true
      ;;
    --warp)
      run_warp=true
      ;;
    --help)
      usage
      exit 0
      ;;
    *)
      printf 'Error: unknown option: %s\n\n' "$1" >&2
      usage >&2
      exit 1
      ;;
  esac

  shift
done

if [[ "$run_homebrew" == true ]]; then
  printf '\n==> Installing Homebrew dependencies\n'
  brew bundle --file="$ROOT_DIR/brew/Brewfile"
fi

if [[ "$run_vscode" == true ]]; then
  printf '\n==> Installing recommended VS Code extensions\n'
  "$ROOT_DIR/scripts/install-vscode-extensions.sh"
fi

if [[ "$run_keyboard" == true ]]; then
  printf '\n==> Installing French OSS keyboard layout\n'
  (
    cd "$ROOT_DIR"
    ./scripts/install-keyboard-layout.sh
  )
fi

if [[ "$run_macos" == true ]]; then
  printf '\n==> Applying macOS defaults\n'
  "$ROOT_DIR/scripts/apply-macos-defaults.sh"
fi

if [[ "$run_warp" == true ]]; then
  printf '\n==> Installing Warp configuration\n'

  source_file="$ROOT_DIR/configs/warp/settings.toml"
  target_dir="$HOME/.warp"
  target_file="$target_dir/settings.toml"

  if [[ ! -f "$source_file" ]]; then
    printf 'Error: Warp configuration not found: %s\n' "$source_file" >&2
    exit 1
  fi

  mkdir -p "$target_dir"

  if [[ -f "$target_file" ]]; then
    backup_dir="$HOME/Documents/Backups/warp"
    backup_file="$backup_dir/settings.toml.$(date +%Y%m%d-%H%M%S).backup"

    mkdir -p "$backup_dir"
    cp "$target_file" "$backup_file"

    printf 'Existing Warp configuration backed up to:\n%s\n' "$backup_file"
  fi

  cp "$source_file" "$target_file"
  printf 'Warp configuration installed in:\n%s\n' "$target_file"
fi

printf '\nSetup completed successfully.\n'
