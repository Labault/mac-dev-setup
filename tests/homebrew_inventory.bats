#!/usr/bin/env bats

setup() {
  REPO_DIR="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
  INVENTORY="$REPO_DIR/docs/homebrew/inventory.md"
}

@test "Homebrew inventory mentions every profile package" {
  run sed -n \
    -e 's/^[[:space:]]*brew[[:space:]]*"\([^"]*\)".*/\1/p' \
    -e 's/^[[:space:]]*cask[[:space:]]*"\([^"]*\)".*/\1/p' \
    "$REPO_DIR"/profiles/*/Brewfile

  [ "$status" -eq 0 ]
  [ -n "$output" ]
  missing=""

  while IFS= read -r token; do
    name="${token##*/}"

    if ! grep -Fq -- "\`$name\`" "$INVENTORY"; then
      missing="$missing $name"
    fi
  done <<< "$output"

  if [ -n "$missing" ]; then
    printf 'Undocumented profile packages:%s\n' "$missing"
    return 1
  fi
}
