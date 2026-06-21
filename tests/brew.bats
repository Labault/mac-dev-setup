#!/usr/bin/env bats

setup() {
  load test_helper
  REPO_DIR="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
}

@test "brew setup reports the Brewfile entry count and checks the bundle" {
  make_stub_bin bash awk dirname
  brew_log="$(mktemp)"
  write_stub "$bin/brew" <<BREW
#!/bin/sh
echo "brew \$*" >>"$brew_log"
exit 0
BREW

  run env PATH="$bin" PROFILE=minimal bash "$REPO_DIR/scripts/brew.sh"
  log="$(cat "$brew_log")"
  rm -rf "$bin"
  rm -f "$brew_log"

  [ "$status" -eq 0 ]
  [[ "$output" == *"Checking"*"Brewfile entries"* ]]
  [[ "$output" == *"[BREW] Done"* ]]
  [[ "$log" == *"brew update"* ]]
  [[ "$log" == *"bundle check"* ]]
}

@test "brew setup rejects an invalid profile before touching Homebrew" {
  make_stub_bin bash awk dirname
  write_stub "$bin/brew" <<'BREW'
#!/bin/sh
exit 1
BREW

  run env PATH="$bin" PROFILE="../etc" bash "$REPO_DIR/scripts/brew.sh"
  rm -rf "$bin"

  [ "$status" -ne 0 ]
  [[ "$output" == *"Invalid profile"* ]]
}
