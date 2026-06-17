#!/usr/bin/env bats

setup() {
  REPO_DIR="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
  source "$REPO_DIR/scripts/lib/profiles.sh"
}

@test "profile_default is full" {
  [ "$(profile_default)" = "full" ]
}

@test "profile_list returns discovered profiles, sorted" {
  run profile_list "$REPO_DIR"
  [ "$status" -eq 0 ]
  [ "$output" = "full minimal" ]
}

@test "profile_brewfile builds the expected path" {
  [ "$(profile_brewfile "$REPO_DIR" minimal)" = "$REPO_DIR/profiles/minimal/Brewfile" ]
}

@test "profile_validate accepts existing profiles" {
  run profile_validate "$REPO_DIR" full
  [ "$status" -eq 0 ]
  run profile_validate "$REPO_DIR" minimal
  [ "$status" -eq 0 ]
}

@test "profile_validate rejects empty, unknown and traversal names" {
  run profile_validate "$REPO_DIR" ""
  [ "$status" -ne 0 ]
  run profile_validate "$REPO_DIR" nope
  [ "$status" -ne 0 ]
  run profile_validate "$REPO_DIR" "../etc"
  [ "$status" -ne 0 ]
  run profile_validate "$REPO_DIR" "a/b"
  [ "$status" -ne 0 ]
}

@test "profile_name_is_valid enforces a safe charset" {
  run profile_name_is_valid full
  [ "$status" -eq 0 ]
  run profile_name_is_valid my-profile_2
  [ "$status" -eq 0 ]
  run profile_name_is_valid "with space"
  [ "$status" -ne 0 ]
  run profile_name_is_valid "../x"
  [ "$status" -ne 0 ]
}
