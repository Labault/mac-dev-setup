#!/usr/bin/env bats

setup() {
  REPO_DIR="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
}

@test "doctor exits non-zero and reports the missing tool" {
  bin="$(mktemp -d)"
  for tool in bash dirname; do
    ln -s "$(command -v "$tool")" "$bin/$tool"
  done
  # Everything resolves except mac, so the diagnostic must fail.
  for stub in sw_vers uname brew git zsh; do
    printf '#!/bin/sh\nexit 0\n' >"$bin/$stub"
    chmod +x "$bin/$stub"
  done

  run env PATH="$bin" bash "$REPO_DIR/scripts/commands/doctor.sh"
  rm -rf "$bin"

  [ "$status" -ne 0 ]
  [[ "$output" == *"mac CLI missing"* ]]
  [[ "$output" == *"Doctor found problems"* ]]
}

@test "doctor --help is read-only and exits cleanly" {
  run bash "$REPO_DIR/scripts/commands/doctor.sh" --help
  [ "$status" -eq 0 ]
  [[ "$output" == *"Usage: mac doctor"* ]]
}
