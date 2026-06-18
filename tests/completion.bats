#!/usr/bin/env bats

setup() {
  REPO_DIR="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
}

@test "the committed zsh completion matches the generator output" {
  completion_file="$REPO_DIR/configs/zsh/completions/_mac"
  before_file="$(mktemp)"
  cp "$completion_file" "$before_file"

  bash "$REPO_DIR/scripts/generate-zsh-completion.sh" >/dev/null
  run cmp "$before_file" "$completion_file"
  rm -f "$before_file"

  [ "$status" -eq 0 ]
}
