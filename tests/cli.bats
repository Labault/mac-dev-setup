#!/usr/bin/env bats

setup() {
  REPO_DIR="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
  CLI="$REPO_DIR/scripts/cli.sh"
}

@test "mac help lists every command" {
  run bash "$CLI" help
  [ "$status" -eq 0 ]
  [[ "$output" == *setup* ]]
  [[ "$output" == *doctor* ]]
  [[ "$output" == *php* ]]
  [[ "$output" == *update* ]]
  [[ "$output" == *uninstall* ]]
  [[ "$output" == *defaults* ]]
  [[ "$output" == *keyboard* ]]
  [[ "$output" == *vscode* ]]
}

@test "the extra commands expose --help" {
  for cmd in defaults keyboard php vscode; do
    run bash "$CLI" "$cmd" --help
    [ "$status" -eq 0 ]
    [[ "$output" == *"Usage: mac $cmd"* ]]
  done
}

@test "mac --help and -h behave like help" {
  run bash "$CLI" --help
  [ "$status" -eq 0 ]
  [[ "$output" == *setup* ]]
  run bash "$CLI" -h
  [ "$status" -eq 0 ]
  [[ "$output" == *setup* ]]
}

@test "unknown command fails and suggests the nearest match" {
  run bash "$CLI" updte
  [ "$status" -ne 0 ]
  [[ "$output" == *"mac update"* ]]
}

@test "no arguments prints usage and fails" {
  run bash "$CLI"
  [ "$status" -ne 0 ]
  [[ "$output" == *"mac help"* ]]
}

@test "mac setup --help prints usage without running" {
  run bash "$CLI" setup --help
  [ "$status" -eq 0 ]
  [[ "$output" == *"Usage: mac setup"* ]]
}

@test "mac doctor --help prints usage without diagnostics" {
  run bash "$CLI" doctor --help
  [ "$status" -eq 0 ]
  [[ "$output" == *"Usage: mac doctor"* ]]
}
