#!/usr/bin/env bats

setup() {
  REPO_DIR="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
  INVENTORY="$REPO_DIR/docs/homebrew/inventory.md"
}

@test "Homebrew inventory mentions every profile package" {
  missing=""

  while IFS= read -r token; do
    name="${token##*/}"

    if ! grep -Fq -- "$name" "$INVENTORY"; then
      missing="$missing $name"
    fi
  done < <(
    awk '
      match($0, /^[[:space:]]*(brew|cask)[[:space:]]+"([^"]+)"/, entry) {
        print entry[2]
      }
    ' "$REPO_DIR"/profiles/*/Brewfile | sort -u
  )

  [ -z "$missing" ]
}
