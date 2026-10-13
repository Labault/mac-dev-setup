#!/usr/bin/env bats

setup() {
  load test_helper
  isolate_git
  REPO_DIR="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
  LINT="$REPO_DIR/scripts/lint-commit-msg.sh"
  WORK="$(mktemp -d)"
  export GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_NOSYSTEM=1
  git init -q -b main "$WORK"
  cd "$WORK"
  git config user.name Test
  git config user.email test@example.com
}

teardown() {
  cd "$REPO_DIR"
  rm -rf "$WORK"
}

commit() {
  git commit -q --allow-empty -m "$1"
}

ci() {
  run env CI_EVENT="$1" PR_BASE_SHA="${2:-}" PR_HEAD_SHA="${3:-}" \
    PUSH_BEFORE_SHA="${2:-}" PUSH_AFTER_SHA="${3:-}" bash "$LINT" --ci
}

@test "CI dispatch explicitly skips commit selection" {
  ci workflow_dispatch
  [ "$status" -eq 0 ]
  [[ "$output" == *"No commit delta"* ]]
}

@test "invalid range fails without a success message" {
  commit '✨ feat: root'
  run bash "$LINT" --range missing HEAD
  [ "$status" -ne 0 ]
  [[ "$output" != *"[OK]"* ]]
}

@test "first push checks an invalid root even as the only commit" {
  commit 'invalid root'
  ci push 0000000000000000000000000000000000000000 HEAD
  [ "$status" -ne 0 ]
  [[ "$output" == *"invalid root"* ]]
}

@test "first push checks root before a valid tip" {
  commit 'invalid root'
  commit '✨ feat: tip'
  ci push 0000000000000000000000000000000000000000 HEAD
  [ "$status" -ne 0 ]
  [[ "$output" == *"invalid root"* ]]
}

@test "push checks intermediate commits" {
  commit '✨ feat: root'
  commit 'invalid middle'
  commit '✨ feat: tip'
  ci push HEAD~2 HEAD
  [ "$status" -ne 0 ]
  [[ "$output" == *"invalid middle"* ]]
}

@test "force push checks new history with accessible before" {
  commit '✨ feat: root'
  commit '✨ feat: old'
  before="$(git rev-parse HEAD)"
  git checkout -q -b replacement HEAD~1
  commit 'invalid replacement'
  ci push "$before" HEAD
  [ "$status" -ne 0 ]
  [[ "$output" == *"invalid replacement"* ]]
}

@test "missing before fails explicitly" {
  commit '✨ feat: tip'
  ci push deadbeef HEAD
  [ "$status" -ne 0 ]
  [[ "$output" == *"Cannot determine commits"* ]]
}

@test "divergent PR excludes base commits and checks PR commits" {
  commit '✨ feat: root'
  git checkout -q -b feature
  commit '✨ feat: feature'
  git checkout -q main
  commit 'invalid base'
  ci pull_request main feature
  [ "$status" -eq 0 ]
  git checkout -q feature
  commit 'invalid feature'
  ci pull_request main feature
  [ "$status" -ne 0 ]
  [[ "$output" == *"invalid feature"* ]]
  [[ "$output" != *"invalid base"* ]]
}

@test "valid empty range is explicit" {
  commit '✨ feat: root'
  run bash "$LINT" --range HEAD HEAD
  [ "$status" -eq 0 ]
  [[ "$output" == *"No commits to check"* ]]
}

@test "first push with valid history succeeds" {
  commit '✨ feat: root'
  commit '✨ feat: tip'
  ci push 0000000000000000000000000000000000000000 HEAD
  [ "$status" -eq 0 ]
}

@test "first push rejects a tree instead of a commit" {
  commit '✨ feat: root'
  tree="$(git rev-parse 'HEAD^{tree}')"
  ci push 0000000000000000000000000000000000000000 "$tree"
  [ "$status" -ne 0 ]
  [[ "$output" == *"Cannot determine commits"* ]]
}
