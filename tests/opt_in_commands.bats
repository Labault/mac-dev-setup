#!/usr/bin/env bats

setup() {
  REPO_DIR="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
  CLI="$REPO_DIR/scripts/cli.sh"
  DEFAULTS_CMD="$REPO_DIR/scripts/commands/defaults.sh"
  KEYBOARD_CMD="$REPO_DIR/scripts/commands/keyboard.sh"
  VSCODE_CMD="$REPO_DIR/scripts/commands/vscode.sh"
}

# ---------------------------------------------------------------------------
# mac defaults
# ---------------------------------------------------------------------------

@test "mac defaults --help prints usage and exits cleanly" {
  run bash "$CLI" defaults --help
  [ "$status" -eq 0 ]
  [[ "$output" == *"Usage: mac defaults"* ]]
}

@test "mac defaults -h is identical to --help" {
  run bash "$CLI" defaults -h
  [ "$status" -eq 0 ]
  [[ "$output" == *"Usage: mac defaults"* ]]
}

@test "mac defaults rejects an unknown option" {
  run bash "$DEFAULTS_CMD" --unknown-flag
  [ "$status" -ne 0 ]
  [[ "$output" == *"Unknown option"* ]]
}

@test "mac defaults delegates to apply-macos-defaults.sh" {
  run grep -q 'apply-macos-defaults.sh' "$DEFAULTS_CMD"
  [ "$status" -eq 0 ]
}

@test "apply-macos-defaults.sh exists and is executable" {
  [ -x "$REPO_DIR/scripts/apply-macos-defaults.sh" ]
}

# ---------------------------------------------------------------------------
# mac keyboard
# ---------------------------------------------------------------------------

@test "mac keyboard --help prints usage and exits cleanly" {
  run bash "$CLI" keyboard --help
  [ "$status" -eq 0 ]
  [[ "$output" == *"Usage: mac keyboard"* ]]
}

@test "mac keyboard -h is identical to --help" {
  run bash "$CLI" keyboard -h
  [ "$status" -eq 0 ]
  [[ "$output" == *"Usage: mac keyboard"* ]]
}

@test "mac keyboard rejects an unknown option" {
  run bash "$KEYBOARD_CMD" --unknown-flag
  [ "$status" -ne 0 ]
  [[ "$output" == *"Unknown option"* ]]
}

@test "mac keyboard delegates to install-keyboard-layout.sh" {
  run grep -q 'install-keyboard-layout.sh' "$KEYBOARD_CMD"
  [ "$status" -eq 0 ]
}

@test "install-keyboard-layout.sh exists and is executable" {
  [ -x "$REPO_DIR/scripts/install-keyboard-layout.sh" ]
}

@test "mac keyboard usage mentions log out" {
  run bash "$KEYBOARD_CMD" --help
  [ "$status" -eq 0 ]
  [[ "$output" == *"Log out"* ]] || [[ "$output" == *"log out"* ]]
}

# ---------------------------------------------------------------------------
# mac vscode
# ---------------------------------------------------------------------------

@test "mac vscode --help prints usage and exits cleanly" {
  run bash "$CLI" vscode --help
  [ "$status" -eq 0 ]
  [[ "$output" == *"Usage: mac vscode"* ]]
}

@test "mac vscode -h is identical to --help" {
  run bash "$CLI" vscode -h
  [ "$status" -eq 0 ]
  [[ "$output" == *"Usage: mac vscode"* ]]
}

@test "mac vscode usage mentions --with-optional" {
  run bash "$VSCODE_CMD" --help
  [ "$status" -eq 0 ]
  [[ "$output" == *"--with-optional"* ]]
}

@test "mac vscode delegates to install-vscode-extensions.sh" {
  run grep -q 'install-vscode-extensions.sh' "$VSCODE_CMD"
  [ "$status" -eq 0 ]
}

@test "install-vscode-extensions.sh exists and is executable" {
  [ -x "$REPO_DIR/scripts/install-vscode-extensions.sh" ]
}

@test "vscode extensions list exists and is non-empty" {
  [ -s "$REPO_DIR/configs/vscode/extensions.txt" ]
}

@test "vscode optional extensions list exists" {
  [ -f "$REPO_DIR/configs/vscode/extensions-optional.txt" ]
}

@test "vscode extensions list contains no blank required lines" {
  run bash -c "grep -v '^#' '$REPO_DIR/configs/vscode/extensions.txt' | grep -c '\S'"
  [ "$status" -eq 0 ]
  [ "$output" -gt 0 ]
}
