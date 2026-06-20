#!/usr/bin/env bats

setup() {
  REPO_DIR="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
}

@test "info writes to stdout; error stays on stderr" {
  # error's stderr is discarded inside the command, so if error wrongly wrote
  # to stdout it would still surface in the captured output.
  run env NO_COLOR=1 REPO_DIR="$REPO_DIR" bash -c \
    'source "$REPO_DIR/scripts/lib/logging.sh"; info hi-out; error hi-err 2>/dev/null'
  [ "$status" -eq 0 ]
  [[ "$output" == *"[INFO] hi-out"* ]]
  [[ "$output" != *"hi-err"* ]]
}

@test "NO_COLOR produces plain bracketed output without escape codes" {
  run env NO_COLOR=1 REPO_DIR="$REPO_DIR" bash -c \
    'source "$REPO_DIR/scripts/lib/logging.sh"; warn careful'
  [ "$status" -eq 0 ]
  [[ "$output" == *"[WARN] careful"* ]]
  [[ "$output" != *$'\033'* ]]
}
