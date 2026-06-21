#!/usr/bin/env bash

set -euo pipefail

REPO_URL="${MAC_DEV_SETUP_REPO_URL:-https://github.com/labault/mac-dev-setup.git}"
INSTALL_DIR="${MAC_DEV_SETUP_INSTALL_DIR:-$HOME/.mac-dev-setup}"
BIN_DIR="${MAC_DEV_SETUP_BIN_DIR:-$HOME/.local/bin}"
CLI_NAME="${MAC_DEV_SETUP_CLI_NAME:-mac}"
CLI_TARGET="$INSTALL_DIR/scripts/cli.sh"
CLI_LINK="$BIN_DIR/$CLI_NAME"
PATH_MANAGER_SCRIPT="$INSTALL_DIR/scripts/lib/path_manager.sh"

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
  local target="$1"
  local link_target

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
  local directory="$1"

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

load_path_manager() {
  [ -f "$PATH_MANAGER_SCRIPT" ] || die "PATH manager not found at $PATH_MANAGER_SCRIPT."

  # shellcheck source=/dev/null
  source "$PATH_MANAGER_SCRIPT"
}

install_or_update_repo() {
  if [ -e "$INSTALL_DIR" ] && [ ! -d "$INSTALL_DIR" ]; then
    die "$INSTALL_DIR exists and is not a directory. Choose another path with MAC_DEV_SETUP_INSTALL_DIR."
  fi

  if [ -d "$INSTALL_DIR/.git" ]; then
    local origin_url
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
    local existing_target expected_target
    existing_target="$(resolve_path "$CLI_LINK")"
    expected_target="$(resolve_path "$CLI_TARGET")"

    if [ "$existing_target" = "$expected_target" ]; then
      success "CLI already installed at $CLI_LINK."
      return
    fi

    die "$CLI_LINK already exists and points to $existing_target. Refusing to overwrite it."
  fi

  local existing_command
  existing_command="$(command -v "$CLI_NAME" || true)"
  if [ -n "$existing_command" ]; then
    die "A '$CLI_NAME' command already exists at $existing_command. Refusing to shadow it."
  fi

  ln -s "$CLI_TARGET" "$CLI_LINK"
  success "Installed CLI: $CLI_LINK -> $CLI_TARGET"
}

uninstall_cli_link() {
  if [ ! -e "$CLI_LINK" ] && [ ! -L "$CLI_LINK" ]; then
    info "CLI link is not installed at $CLI_LINK."
    return 0
  fi

  local existing_target expected_target
  existing_target="$(resolve_path "$CLI_LINK")"
  expected_target="$(resolve_path "$CLI_TARGET")"

  if [ "$existing_target" != "$expected_target" ]; then
    die "$CLI_LINK points to $existing_target, not $expected_target. Refusing to remove it."
  fi

  rm -f "$CLI_LINK"
  success "Removed CLI link: $CLI_LINK"
}

print_next_steps() {
  if path_contains "$BIN_DIR"; then
    success "Run '$CLI_NAME help' to get started."
    return
  fi

  warn "$BIN_DIR is now managed in your shell profile, but is not in this shell's PATH yet."
  warn "Restart your shell, then run '$CLI_NAME help' to get started."
}

print_usage() {
  cat <<EOF
Usage: install.sh [--uninstall]

Options:
  --uninstall  Remove the managed CLI symlink and PATH block.
EOF
}

main() {
  case "${1:-}" in
    --help|-h)
      print_usage
      return 0
      ;;
    --uninstall)
      ensure_macos
      load_path_manager
      uninstall_cli_link
      path_manager_uninstall "$BIN_DIR"
      return 0
      ;;
    "")
      ;;
    *)
      print_usage >&2
      die "Unknown option: $1"
      ;;
  esac

  ensure_macos
  ensure_tools
  install_or_update_repo
  load_path_manager
  ensure_cli_target
  install_cli_link
  path_manager_install "$BIN_DIR"
  print_next_steps
}

main "$@"
