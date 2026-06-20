#!/usr/bin/env bats

setup() {
  REPO_DIR="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
}

@test "brew setup reports the Brewfile entry count and checks the bundle" {
  bin="$(mktemp -d)"
  for tool in bash awk dirname; do ln -s "$(command -v "$tool")" "$bin/$tool"; done
  brew_log="$(mktemp)"
  cat >"$bin/brew" <<BREW
#!/bin/sh
echo "brew \$*" >>"$brew_log"
exit 0
BREW
  chmod +x "$bin/brew"

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
  bin="$(mktemp -d)"
  for tool in bash awk dirname; do ln -s "$(command -v "$tool")" "$bin/$tool"; done
  printf '#!/bin/sh\nexit 1\n' >"$bin/brew"
  chmod +x "$bin/brew"

  run env PATH="$bin" PROFILE="../etc" bash "$REPO_DIR/scripts/brew.sh"
  rm -rf "$bin"

  [ "$status" -ne 0 ]
  [[ "$output" == *"Invalid profile"* ]]
}
