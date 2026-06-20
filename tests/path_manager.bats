#!/usr/bin/env bats

setup() {
  REPO_DIR="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
  source "$REPO_DIR/scripts/lib/path_manager.sh"
  # path_manager.sh enables `set -euo pipefail`; relax it so the test driver
  # behaves normally (the functions do not rely on it).
  set +e +u +o pipefail
  PROFILE_FILE="$(mktemp)"
  BIN_DIR="$HOME/.local/bin"
}

teardown() {
  rm -f "$PROFILE_FILE"
}

@test "install writes a managed PATH block" {
  path_manager_install "$BIN_DIR" "$PROFILE_FILE"
  run grep -F "$PATH_MANAGER_BEGIN_MARKER" "$PROFILE_FILE"
  [ "$status" -eq 0 ]
  run grep -F "$PATH_MANAGER_END_MARKER" "$PROFILE_FILE"
  [ "$status" -eq 0 ]
}

@test "install is idempotent" {
  path_manager_install "$BIN_DIR" "$PROFILE_FILE"
  path_manager_install "$BIN_DIR" "$PROFILE_FILE"
  run grep -cF "$PATH_MANAGER_BEGIN_MARKER" "$PROFILE_FILE"
  [ "$output" -eq 1 ]
}

@test "uninstall removes the managed block" {
  path_manager_install "$BIN_DIR" "$PROFILE_FILE"
  path_manager_uninstall "$BIN_DIR" "$PROFILE_FILE"
  run grep -F "$PATH_MANAGER_BEGIN_MARKER" "$PROFILE_FILE"
  [ "$status" -ne 0 ]
}

@test "uninstall preserves unrelated content" {
  printf 'export EXISTING=1\n' >"$PROFILE_FILE"
  path_manager_install "$BIN_DIR" "$PROFILE_FILE"
  path_manager_uninstall "$BIN_DIR" "$PROFILE_FILE"
  run grep -F "export EXISTING=1" "$PROFILE_FILE"
  [ "$status" -eq 0 ]
}

@test "uninstall on a clean file is a no-op" {
  printf 'export EXISTING=1\n' >"$PROFILE_FILE"
  run path_manager_uninstall "$BIN_DIR" "$PROFILE_FILE"
  [ "$status" -eq 0 ]
}

@test "install refuses a directory containing shell metacharacters" {
  run path_manager_install '/tmp/x";rm -rf ~;#' "$PROFILE_FILE"
  [ "$status" -ne 0 ]
  [[ "$output" == *"Refusing to add an unsafe directory"* ]]
  run grep -F "$PATH_MANAGER_BEGIN_MARKER" "$PROFILE_FILE"
  [ "$status" -ne 0 ]
}

@test "remove refuses an orphaned begin marker and preserves config" {
  {
    printf 'export EXISTING=1\n'
    printf '%s\n' "$PATH_MANAGER_BEGIN_MARKER"
    printf 'export STILL_HERE=1\n'
  } >"$PROFILE_FILE"

  run path_manager_remove_block "$PROFILE_FILE"
  [ "$status" -ne 0 ]

  run grep -F "export EXISTING=1" "$PROFILE_FILE"
  [ "$status" -eq 0 ]
  run grep -F "export STILL_HERE=1" "$PROFILE_FILE"
  [ "$status" -eq 0 ]
}
