#!/usr/bin/env bats

setup() {
  REPO_DIR="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
}

@test "zsh setup installs managed files into a fresh HOME" {
  home="$(mktemp -d)"
  run env HOME="$home" bash "$REPO_DIR/scripts/zsh.sh"
  zshrc_ok="no"
  [ -f "$home/.zshrc" ] && zshrc_ok="yes"
  rm -rf "$home"

  [ "$status" -eq 0 ]
  [ "$zshrc_ok" = "yes" ]
  [[ "$output" == *".zshrc applied"* ]]
}

@test "zsh setup is idempotent and reports files already up to date" {
  home="$(mktemp -d)"
  env HOME="$home" bash "$REPO_DIR/scripts/zsh.sh" >/dev/null 2>&1
  run env HOME="$home" bash "$REPO_DIR/scripts/zsh.sh"
  rm -rf "$home"

  [ "$status" -eq 0 ]
  [[ "$output" == *"already up to date"* ]]
}

@test "zsh setup backs up a pre-existing differing file" {
  home="$(mktemp -d)"
  printf 'my own zshrc\n' >"$home/.zshrc"
  run env HOME="$home" bash "$REPO_DIR/scripts/zsh.sh"
  backup_made="no"
  [ -d "$home/Documents/Backups/mac-dev-setup/zsh" ] && backup_made="yes"
  rm -rf "$home"

  [ "$status" -eq 0 ]
  [ "$backup_made" = "yes" ]
  [[ "$output" == *"Backed up existing .zshrc"* ]]
}
