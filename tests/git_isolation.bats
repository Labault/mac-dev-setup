#!/usr/bin/env bats

setup() {
  load test_helper
  WORK="$(mktemp -d)"
}

teardown() {
  rm -rf "$WORK"
}

@test "temporary repositories ignore inherited signing and hooks" {
  mkdir "$WORK/hooks"
  write_stub "$WORK/hooks/pre-commit" <<'SH'
#!/bin/sh
exit 1
SH
  cat >"$WORK/personal-gitconfig" <<CONFIG
[user]
  name = Personal
  email = personal@example.com
[commit]
  gpgsign = true
[gpg]
  program = false
[core]
  hooksPath = $WORK/hooks
CONFIG
  export GIT_CONFIG_GLOBAL="$WORK/personal-gitconfig"
  export GIT_CONFIG_COUNT=1 GIT_CONFIG_KEY_0=commit.gpgsign GIT_CONFIG_VALUE_0=true
  isolate_git
  git init -q -b main "$WORK/repo"
  git -C "$WORK/repo" config user.name Test
  git -C "$WORK/repo" config user.email test@example.com
  run git -C "$WORK/repo" commit -q --allow-empty -m 'test fixture'
  [ "$status" -eq 0 ]
}
