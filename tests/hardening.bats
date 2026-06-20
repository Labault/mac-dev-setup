#!/usr/bin/env bats

setup() {
  REPO_DIR="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
  # hardening.sh derives REPO_DIR from its own location, so run a copy from a
  # throwaway tree whose profiles/ we control. This exercises the enforcement
  # logic without touching the real profile Brewfiles.
  fake_repo="$(mktemp -d)"
  mkdir -p "$fake_repo/scripts" "$fake_repo/profiles/test"
  cp "$REPO_DIR/scripts/hardening.sh" "$fake_repo/scripts/hardening.sh"
}

teardown() {
  rm -rf "$fake_repo"
}

@test "hardening fails when a forbidden tool is declared in a profile" {
  cat >"$fake_repo/profiles/test/Brewfile" <<'BREW'
brew "bash"
brew "lazygit"
BREW

  run env GITHUB_ACTIONS=true bash "$fake_repo/scripts/hardening.sh"
  [ "$status" -ne 0 ]
  [[ "$output" == *"Forbidden tool"* ]]
  [[ "$output" == *"lazygit"* ]]
}

@test "hardening passes when no forbidden tool is declared" {
  cat >"$fake_repo/profiles/test/Brewfile" <<'BREW'
brew "bash"
brew "git"
BREW

  run env GITHUB_ACTIONS=true bash "$fake_repo/scripts/hardening.sh"
  [ "$status" -eq 0 ]
  [[ "$output" == *"Hardening complete"* ]]
}
