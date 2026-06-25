#!/usr/bin/env bats

setup() {
  REPO_DIR="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
  LINT="$REPO_DIR/scripts/lint-commit-msg.sh"
  MSG="$(mktemp)"
}

teardown() {
  rm -f "$MSG"
}

# Lint a message passed as the first argument; result is in $status/$output.
lint() {
  printf '%s' "$1" >"$MSG"
  run env NO_COLOR=1 "$LINT" "$MSG"
}

@test "accepts a well-formed gitmoji + Conventional Commit header" {
  lint '✨ feat(cli): add a profile flag'
  [ "$status" -eq 0 ]
}

@test "accepts the :code: gitmoji form" {
  lint ':sparkles: feat(cli): add a profile flag'
  [ "$status" -eq 0 ]
}

@test "accepts a header without a scope" {
  lint '🐛 fix: handle a missing Homebrew prefix'
  [ "$status" -eq 0 ]
}

@test "accepts a breaking-change marker" {
  lint '✨ feat(cli)!: drop the legacy flag'
  [ "$status" -eq 0 ]
}

@test "accepts an emoji that requires its U+FE0F variation selector" {
  lint '🔒️ fix(tls): harden the cipher suite'
  [ "$status" -eq 0 ]
}

@test "rejects the same emoji without its variation selector" {
  lint '🔒 fix(tls): harden the cipher suite'
  [ "$status" -ne 0 ]
  [[ "$output" == *"valid gitmoji"* ]]
}

@test "rejects an emoji that is not a gitmoji" {
  lint '🧹 chore: tidy up'
  [ "$status" -ne 0 ]
  [[ "$output" == *"valid gitmoji"* ]]
}

@test "rejects a missing gitmoji" {
  lint 'feat(cli): add a profile flag'
  [ "$status" -ne 0 ]
  [[ "$output" == *"valid gitmoji"* ]]
}

@test "rejects an unknown type" {
  lint '✨ unknown(cli): do a thing'
  [ "$status" -ne 0 ]
  [[ "$output" == *"is not allowed"* ]]
}

@test "rejects an upper-case scope" {
  lint '✨ feat(CLI): add a profile flag'
  [ "$status" -ne 0 ]
  [[ "$output" == *"lower-case"* ]]
}

@test "rejects a trailing period in the subject" {
  lint '✨ feat(cli): add a profile flag.'
  [ "$status" -ne 0 ]
  [[ "$output" == *"period"* ]]
}

@test "rejects an empty subject" {
  lint '✨ feat(cli): '
  [ "$status" -ne 0 ]
  [[ "$output" == *"subject must not be empty"* ]]
}

@test "rejects a header longer than 100 characters" {
  lint "✨ feat(cli): $(printf 'a%.0s' {1..100})"
  [ "$status" -ne 0 ]
  [[ "$output" == *"maximum is 100"* ]]
}

@test "rejects a body not separated from the header by a blank line" {
  printf '%s\n%s' '✨ feat(cli): add a flag' 'body on the next line' >"$MSG"
  run env NO_COLOR=1 "$LINT" "$MSG"
  [ "$status" -ne 0 ]
  [[ "$output" == *"blank line"* ]]
}

@test "ignores comment lines in the commit-msg file" {
  printf '%s\n%s\n' '✨ feat(cli): add a flag' '# this comment is ignored' >"$MSG"
  run env NO_COLOR=1 "$LINT" "$MSG"
  [ "$status" -eq 0 ]
}

@test "--range validates every commit and reports the offending SHA" {
  repo="$(mktemp -d)"
  (
    cd "$repo"
    git init -q
    git config user.email t@e.st
    git config user.name tester
    git commit -q --allow-empty -m '🎉 chore: initial commit'
    git commit -q --allow-empty -m '✨ feat(cli): valid header'
    git commit -q --allow-empty -m 'bad header without gitmoji'
  )
  run env NO_COLOR=1 bash -c "cd '$repo' && '$LINT' --range HEAD~2 HEAD"
  rm -rf "$repo"
  [ "$status" -ne 0 ]
  [[ "$output" == *"bad header without gitmoji"* ]]
}
