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

@test "uninstall --help prints usage and exits cleanly" {
  run bash "$REPO_DIR/scripts/commands/uninstall.sh" --help
  [ "$status" -eq 0 ]
  [[ "$output" == *"Usage: mac uninstall"* ]]
}
