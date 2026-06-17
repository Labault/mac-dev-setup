#!/usr/bin/env bats

setup() {
  REPO_DIR="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
}

@test "the committed zsh completion matches the generator output" {
  bash "$REPO_DIR/scripts/generate-zsh-completion.sh" >/dev/null
  run git -C "$REPO_DIR" diff --exit-code -- configs/zsh/completions/_mac
  [ "$status" -eq 0 ]
}
