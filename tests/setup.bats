#!/usr/bin/env bats

setup() {
  REPO_DIR="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
}

@test "setup dry run reports the dry-run mode and exits cleanly" {
  run bash "$REPO_DIR/scripts/cli.sh" setup --profile minimal --dry-run
  [ "$status" -eq 0 ]
  [[ "$output" == *"Dry run mode activated"* ]]
}

@test "setup dry run creates no logs directory in the working directory" {
  tmp="$(mktemp -d)"
  ( cd "$tmp" && bash "$REPO_DIR/scripts/setup.sh" --profile minimal --dry-run >/dev/null )
  result=1
  [ -e "$tmp/logs" ] || result=0
  rm -rf "$tmp"
  [ "$result" -eq 0 ]
}

@test "setup.sh uses an absolute log path, not a relative logs/ directory" {
  run grep -Eq 'mkdir -p logs|"logs/setup\.log"' "$REPO_DIR/scripts/setup.sh"
  [ "$status" -ne 0 ]
}

@test "setup rejects an unsafe profile name" {
  run bash "$REPO_DIR/scripts/cli.sh" setup --profile "no/such"
  [ "$status" -ne 0 ]
  [[ "$output" == *"Invalid profile"* ]]
}
