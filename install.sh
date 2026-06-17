#!/usr/bin/env bash

set -euo pipefail

REPO_URL="${MAC_DEV_SETUP_REPO_URL:-https://github.com/labault/mac-dev-setup.git}"
INSTALL_DIR="${MAC_DEV_SETUP_INSTALL_DIR:-$HOME/.mac-dev-setup}"
BIN_DIR="${MAC_DEV_SETUP_BIN_DIR:-$HOME/.local/bin}"
CLI_NAME="${MAC_DEV_SETUP_CLI_NAME:-mac}"
CLI_TARGET="$INSTALL_DIR/scripts/cli.sh"
CLI_LINK="$BIN_DIR/$CLI_NAME"

info() {
  printf '[INFO] %s\n' "$*"
}

success() {
  printf '[OK] %s\n' "$*"
}

warn() {
  printf '[WARN] %s\n' "$*" >&2
}

error() {
  printf '[ERROR] %s\n' "$*" >&2
}

die() {
  error "$*"
  exit 1
}

resolve_path() {
  target="$1"

  if command -v python3 >/dev/null 2>&1; then
    python3 -c 'import os, sys; print(os.path.realpath(sys.argv[1]))' "$target"
    return
  fi

  if [ -L "$target" ]; then
    link_target="$(readlink "$target")"
    case "$link_target" in
      /*) printf '%s\n' "$link_target" ;;
      *) printf '%s\n' "$(cd "$(dirname "$target")" && cd "$(dirname "$link_target")" && pwd)/$(basename "$link_target")" ;;
    esac
    return
  fi

  printf '%s\n' "$(cd "$(dirname "$target")" && pwd)/$(basename "$target")"
}

path_contains() {
  directory="$1"

  case ":$PATH:" in
    *":$directory:"*) return 0 ;;
    *) return 1 ;;
  esac
}

ensure_macos() {
  [ "$(uname -s)" = "Darwin" ] || die "This installer supports macOS only."
}

ensure_tools() {
  command -v git >/dev/null 2>&1 || die "git is required to install MacDevSetup."
  command -v mkdir >/dev/null 2>&1 || die "mkdir is required to install MacDevSetup."
  command -v ln >/dev/null 2>&1 || die "ln is required to install MacDevSetup."
}

install_or_update_repo() {
  if [ -e "$INSTALL_DIR" ] && [ ! -d "$INSTALL_DIR" ]; then
    die "$INSTALL_DIR exists and is not a directory. Choose another path with MAC_DEV_SETUP_INSTALL_DIR."
  fi

  if [ -d "$INSTALL_DIR/.git" ]; then
    origin_url="$(git -C "$INSTALL_DIR" config --get remote.origin.url || true)"

    case "$origin_url" in
      "$REPO_URL"|git@github.com:labault/mac-dev-setup.git|https://github.com/labault/mac-dev-setup.git|https://github.com/Labault/mac-dev-setup.git)
        info "Existing installation detected at $INSTALL_DIR."
        info "Updating from origin..."
        git -C "$INSTALL_DIR" pull --ff-only
        return
        ;;
      *)
        die "$INSTALL_DIR is a git repository for '$origin_url', not MacDevSetup. Refusing to overwrite it."
        ;;
    esac
  fi

  if [ -d "$INSTALL_DIR" ] && [ -n "$(find "$INSTALL_DIR" -mindepth 1 -maxdepth 1 -print -quit)" ]; then
    die "$INSTALL_DIR already exists and is not empty. Refusing to overwrite it."
  fi

  info "Installing MacDevSetup into $INSTALL_DIR..."
  git clone "$REPO_URL" "$INSTALL_DIR"
}

ensure_cli_target() {
  [ -f "$CLI_TARGET" ] || die "CLI entrypoint not found at $CLI_TARGET."
  chmod +x "$CLI_TARGET"
}

install_cli_link() {
  mkdir -p "$BIN_DIR"

  if [ -e "$CLI_LINK" ] || [ -L "$CLI_LINK" ]; then
    existing_target="$(resolve_path "$CLI_LINK")"
    expected_target="$(resolve_path "$CLI_TARGET")"

    if [ "$existing_target" = "$expected_target" ]; then
      success "CLI already installed at $CLI_LINK."
      return
    fi

    die "$CLI_LINK already exists and points to $existing_target. Refusing to overwrite it."
  fi

  existing_command="$(command -v "$CLI_NAME" || true)"
  if [ -n "$existing_command" ]; then
    die "A '$CLI_NAME' command already exists at $existing_command. Refusing to shadow it."
  fi

  ln -s "$CLI_TARGET" "$CLI_LINK"
  success "Installed CLI: $CLI_LINK -> $CLI_TARGET"
}

print_next_steps() {
  if path_contains "$BIN_DIR"; then
    success "Run '$CLI_NAME help' to get started."
    return
  fi

  warn "$BIN_DIR is not currently in your PATH."
  warn "Add this to your shell profile, then restart your shell:"
  warn "  export PATH=\"$BIN_DIR:\$PATH\""
  warn "After that, run '$CLI_NAME help' to get started."
}

main() {
  ensure_macos
  ensure_tools
  install_or_update_repo
  ensure_cli_target
  install_cli_link
  print_next_steps
}

main "$@"
