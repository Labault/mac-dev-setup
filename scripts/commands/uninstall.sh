#!/usr/bin/env bash
# Description: Remove the mac CLI symlink and managed shell PATH entry.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

# shellcheck source=scripts/lib/logging.sh
source "$REPO_DIR/scripts/lib/logging.sh"
# shellcheck source=scripts/lib/path_manager.sh
source "$REPO_DIR/scripts/lib/path_manager.sh"

INSTALL_DIR="${MAC_DEV_SETUP_INSTALL_DIR:-$HOME/.mac-dev-setup}"
BIN_DIR="${MAC_DEV_SETUP_BIN_DIR:-$HOME/.local/bin}"
CLI_NAME="${MAC_DEV_SETUP_CLI_NAME:-mac}"
CLI_TARGET="$REPO_DIR/scripts/cli.sh"
CLI_LINK="$BIN_DIR/$CLI_NAME"
REMOVE_CONFIG="false"
REMOVE_INSTALL_DIR="false"
DRY_RUN="false"

print_usage() {
  log_line "Usage: mac uninstall [--remove-config] [--remove-install-dir] [--dry-run]"
  log_line ""
  log_line "Options:"
  log_line "  --remove-config       Remove MacDevSetup-managed config only when it is safe."
  log_line "  --remove-install-dir  Remove the installed checkout when it matches MAC_DEV_SETUP_INSTALL_DIR."
  log_line "  --dry-run             Show what would be removed without changing anything."
}

die() {
  error "$*"
  exit 1
}

resolve_path() {
  target="$1"

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

run_or_preview() {
  message="$1"
  shift

  if [ "$DRY_RUN" = "true" ]; then
    info "Would $message"
    return 0
  fi

  "$@"
  success "$message"
}

parse_args() {
  while [ "$#" -gt 0 ]; do
    case "$1" in
      --remove-config)
        REMOVE_CONFIG="true"
        shift
        ;;
      --remove-install-dir)
        REMOVE_INSTALL_DIR="true"
        shift
        ;;
      --dry-run)
        DRY_RUN="true"
        shift
        ;;
      --help|-h)
        print_usage
        exit 0
        ;;
      *)
        error "Unknown option: $1"
        print_usage >&2
        exit 1
        ;;
    esac
  done
}

remove_cli_link() {
  if [ ! -e "$CLI_LINK" ] && [ ! -L "$CLI_LINK" ]; then
    info "CLI link is not installed at $CLI_LINK."
    return 0
  fi

  existing_target="$(resolve_path "$CLI_LINK")"
  expected_target="$(resolve_path "$CLI_TARGET")"

  if [ "$existing_target" != "$expected_target" ]; then
    die "$CLI_LINK points to $existing_target, not $expected_target. Refusing to remove it."
  fi

  run_or_preview "remove CLI link: $CLI_LINK" rm -f "$CLI_LINK"
}

remove_path_entry() {
  profile="$(path_manager_shell_profile)"

  if [ "$DRY_RUN" = "true" ]; then
    if [ -f "$profile" ] && grep -F "$PATH_MANAGER_BEGIN_MARKER" "$profile" >/dev/null 2>&1; then
      info "Would remove MacDevSetup PATH block from $profile."
    else
      info "No MacDevSetup PATH block found in $profile."
    fi
    return 0
  fi

  path_manager_uninstall "$BIN_DIR"
}

remove_if_identical() {
  source_file="$1"
  target_file="$2"
  label="$3"

  if [ ! -f "$source_file" ] || [ ! -f "$target_file" ]; then
    info "$label is not installed."
    return 0
  fi

  if ! cmp -s "$source_file" "$target_file"; then
    warn "$target_file differs from MacDevSetup's copy; leaving it untouched."
    return 0
  fi

  run_or_preview "remove $label: $target_file" rm -f "$target_file"
}

remove_git_include() {
  gitconfig="$REPO_DIR/configs/git/.gitconfig"

  command -v git >/dev/null 2>&1 || {
    info "git is not available; skipping global git config cleanup."
    return 0
  }

  if ! git config --global --get-all include.path >/dev/null 2>&1; then
    info "No global git include.path entries found."
    return 0
  fi

  matching_entry="false"

  while IFS= read -r include_path; do
    [ "$include_path" = "$gitconfig" ] || continue
    matching_entry="true"

    if [ "$DRY_RUN" = "true" ]; then
      info "Would remove global git include.path: $gitconfig"
      continue
    fi

    git config --global --fixed-value --unset-all include.path "$gitconfig" 2>/dev/null \
      || die "Could not remove global git include.path safely; your git may not support --fixed-value."
    success "Removed global git include.path: $gitconfig"
    return 0
  done < <(git config --global --get-all include.path)

  if [ "$matching_entry" = "false" ]; then
    info "No MacDevSetup global git include.path entry found."
  fi
}

remove_config() {
  remove_git_include
  remove_if_identical "$REPO_DIR/configs/zsh/.zprofile" "$HOME/.zprofile" ".zprofile"
  remove_if_identical "$REPO_DIR/configs/zsh/.zshrc" "$HOME/.zshrc" ".zshrc"
  remove_if_identical "$REPO_DIR/configs/zsh/.zsh_plugins.txt" "$HOME/.zsh_plugins.txt" ".zsh_plugins.txt"
  remove_if_identical "$REPO_DIR/configs/zsh/.p10k.zsh" "$HOME/.p10k.zsh" "p10k config"
  remove_if_identical "$REPO_DIR/configs/zsh/alias.sh" "$HOME/.shell/alias.sh" "zsh aliases"
  remove_if_identical "$REPO_DIR/configs/zsh/completions/_mac" "$HOME/.zsh/completions/_mac" "zsh completion"
}

remove_install_dir() {
  install_dir_real="$(resolve_path "$INSTALL_DIR")"
  repo_dir_real="$(resolve_path "$REPO_DIR")"

  if [ "$install_dir_real" != "$repo_dir_real" ]; then
    die "Refusing to remove $REPO_DIR because it does not match MAC_DEV_SETUP_INSTALL_DIR ($INSTALL_DIR)."
  fi

  run_or_preview "remove install directory: $INSTALL_DIR" rm -rf "$INSTALL_DIR"
}

main() {
  parse_args "$@"

  remove_cli_link
  remove_path_entry

  if [ "$REMOVE_CONFIG" = "true" ]; then
    remove_config
  else
    info "Config cleanup skipped. Re-run with --remove-config to remove safe MacDevSetup-managed config."
  fi

  if [ "$REMOVE_INSTALL_DIR" = "true" ]; then
    remove_install_dir
  else
    info "Install directory left in place. Re-run with --remove-install-dir to remove $INSTALL_DIR."
  fi

  success "Uninstall complete."
}

main "$@"
