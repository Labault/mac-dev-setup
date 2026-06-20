#!/usr/bin/env bats

setup() {
  REPO_DIR="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
}

@test "uninstall --remove-config removes managed files only when identical" {
  home="$(mktemp -d)"
  cp "$REPO_DIR/configs/zsh/.zprofile" "$home/.zprofile"
  printf 'unmanaged content\n' >"$home/.zshrc"

  run env HOME="$home" bash "$REPO_DIR/scripts/commands/uninstall.sh" \
    --remove-config --dry-run
  rm -rf "$home"

  [ "$status" -eq 0 ]
  [[ "$output" == *"Would remove .zprofile"* ]]
  [[ "$output" == *".zshrc differs"* ]]
}

@test "uninstall refuses to remove a CLI link that points elsewhere" {
  home="$(mktemp -d)"
  bindir="$(mktemp -d)"
  other="$(mktemp -d)"
  printf '#!/bin/sh\n' >"$other/foreign"
  ln -s "$other/foreign" "$bindir/mac"

  run env HOME="$home" MAC_DEV_SETUP_BIN_DIR="$bindir" \
    bash "$REPO_DIR/scripts/commands/uninstall.sh"
  link_present="false"
  [ -L "$bindir/mac" ] && link_present="true"
  rm -rf "$home" "$bindir" "$other"

  [ "$status" -ne 0 ]
  [[ "$output" == *"Refusing to remove"* ]]
  [ "$link_present" = "true" ]
}

@test "uninstall --remove-config deletes identical managed files but preserves modified ones" {
  home="$(mktemp -d)"
  bindir="$(mktemp -d)"
  cp "$REPO_DIR/configs/zsh/.zprofile" "$home/.zprofile"
  printf 'my own zshrc\n' >"$home/.zshrc"

  run env HOME="$home" MAC_DEV_SETUP_BIN_DIR="$bindir" \
    bash "$REPO_DIR/scripts/commands/uninstall.sh" --remove-config
  zprofile_present="false"; [ -f "$home/.zprofile" ] && zprofile_present="true"
  zshrc_present="false"; [ -f "$home/.zshrc" ] && zshrc_present="true"
  rm -rf "$home" "$bindir"

  [ "$status" -eq 0 ]
  [ "$zprofile_present" = "false" ]
  [ "$zshrc_present" = "true" ]
}

@test "uninstall --help prints usage and exits cleanly" {
  run bash "$REPO_DIR/scripts/commands/uninstall.sh" --help
  [ "$status" -eq 0 ]
  [[ "$output" == *"Usage: mac uninstall"* ]]
}
