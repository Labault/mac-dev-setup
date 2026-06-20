#!/usr/bin/env bash

set -euo pipefail

PATH_MANAGER_BEGIN_MARKER="# >>> mac-dev-setup PATH >>>"
PATH_MANAGER_END_MARKER="# <<< mac-dev-setup PATH <<<"

path_manager_info() {
  if command -v info >/dev/null 2>&1; then
    info "$@"
    return
  fi

  printf '[INFO] %s\n' "$*"
}

path_manager_success() {
  if command -v success >/dev/null 2>&1; then
    success "$@"
    return
  fi

  printf '[OK] %s\n' "$*"
}

path_manager_warn() {
  if command -v warn >/dev/null 2>&1; then
    warn "$@"
    return
  fi

  printf '[WARN] %s\n' "$*" >&2
}

path_manager_shell_profile() {
  if [ -n "${MAC_DEV_SETUP_SHELL_CONFIG:-}" ]; then
    printf '%s\n' "$MAC_DEV_SETUP_SHELL_CONFIG"
    return
  fi

  case "${SHELL:-}" in
    */zsh) printf '%s\n' "$HOME/.zprofile" ;;
    */bash) printf '%s\n' "$HOME/.bash_profile" ;;
    *) printf '%s\n' "$HOME/.profile" ;;
  esac
}

path_manager_directory_is_safe() {
  local directory="$1"

  # The directory is interpolated into a double-quoted shell string that gets
  # written to the user's profile and executed on every new shell. Reject any
  # character that could break out of that string and inject commands. Ordinary
  # paths (including spaces or unicode) pass; only metacharacters that are
  # dangerous inside double quotes are refused.
  case "$directory" in
    "") return 1 ;;
    *'"'*) return 1 ;;
    *'$'*) return 1 ;;
    *'`'*) return 1 ;;
    *[\\]*) return 1 ;;
  esac

  case "$directory" in
    *$'\n'*) return 1 ;;
  esac

  return 0
}

path_manager_shell_literal() {
  local directory="$1"

  case "$directory" in
    "$HOME") printf '%s' "\$HOME" ;;
    "$HOME"/*) printf '%s/%s' "\$HOME" "${directory#"$HOME"/}" ;;
    *) printf '%s' "$directory" ;;
  esac
}

path_manager_file_contains_directory() {
  local file="$1"
  local directory="$2"
  local literal_directory home_suffix

  [ -f "$file" ] || return 1

  literal_directory="$(path_manager_shell_literal "$directory")"

  grep -F "$directory" "$file" >/dev/null 2>&1 && return 0
  grep -F "$literal_directory" "$file" >/dev/null 2>&1 && return 0

  if [ "$literal_directory" != "$directory" ]; then
    home_suffix="${literal_directory#\$HOME}"
    grep -F "\${HOME}${home_suffix}" "$file" >/dev/null 2>&1 && return 0
  fi

  return 1
}

path_manager_remove_block() {
  local file="$1"
  local tmp_file

  [ -f "$file" ] || return 0

  # Refuse to touch a file whose managed block is half-present. Without this
  # guard, an orphaned begin marker (end marker manually deleted) would make
  # awk treat everything to EOF as managed and silently drop the user's config.
  if grep -Fq "$PATH_MANAGER_BEGIN_MARKER" "$file" \
    && ! grep -Fq "$PATH_MANAGER_END_MARKER" "$file"; then
    path_manager_warn "Incomplete MacDevSetup PATH markers in $file; leaving it untouched."
    return 1
  fi

  tmp_file="${file}.mac-dev-setup.$$"
  awk -v begin="$PATH_MANAGER_BEGIN_MARKER" -v end="$PATH_MANAGER_END_MARKER" '
    $0 == begin {
      in_managed_block = 1
      next
    }
    $0 == end {
      in_managed_block = 0
      next
    }
    !in_managed_block {
      print
    }
  ' "$file" > "$tmp_file"

  if cmp -s "$file" "$tmp_file"; then
    rm -f "$tmp_file"
    return 1
  fi

  mv "$tmp_file" "$file"
  return 0
}

path_manager_write_block() {
  local file="$1"
  local directory="$2"
  local literal_directory
  literal_directory="$(path_manager_shell_literal "$directory")"

  mkdir -p "$(dirname "$file")"
  touch "$file"

  if [ -s "$file" ] && [ "$(tail -c 1 "$file")" != "" ]; then
    printf '\n' >> "$file"
  fi

  cat >> "$file" <<EOF
$PATH_MANAGER_BEGIN_MARKER
# Managed by MacDevSetup. Remove this block, or run install.sh --uninstall.
if [ -d "$literal_directory" ]; then
  case ":\$PATH:" in
    *":$literal_directory:"*) ;;
    *) export PATH="$literal_directory:\$PATH" ;;
  esac
fi
$PATH_MANAGER_END_MARKER
EOF
}

path_manager_install() {
  local directory="$1"
  local profile="${2:-$(path_manager_shell_profile)}"

  if ! path_manager_directory_is_safe "$directory"; then
    path_manager_warn "Refusing to add an unsafe directory to PATH: $directory"
    return 1
  fi

  path_manager_remove_block "$profile" || true

  if path_manager_file_contains_directory "$profile" "$directory"; then
    path_manager_success "$directory is already present in $profile."
    return 0
  fi

  path_manager_write_block "$profile" "$directory"
  path_manager_success "Added $directory to PATH in $profile."
}

path_manager_uninstall() {
  local directory="$1"
  local profile="${2:-$(path_manager_shell_profile)}"

  if path_manager_remove_block "$profile"; then
    path_manager_success "Removed MacDevSetup PATH block from $profile."
    return 0
  fi

  path_manager_info "No MacDevSetup PATH block found in $profile."

  if path_manager_file_contains_directory "$profile" "$directory"; then
    path_manager_warn "$profile contains an unmanaged $directory PATH entry; leaving it untouched."
  fi
}
