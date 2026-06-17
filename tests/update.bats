#!/usr/bin/env bats

# Exercises scripts/commands/update.sh against a throwaway local remote, so no
# network access is required. update.sh resolves its REPO_DIR from its own
# location, so running the copy inside the clone operates on the clone.

setup() {
  REPO_DIR="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
  # When the suite runs inside a git hook (husky), git exports GIT_DIR/
  # GIT_INDEX_FILE etc.; clear them so `git -C <other repo>` is not hijacked.
  unset GIT_DIR GIT_WORK_TREE GIT_INDEX_FILE GIT_PREFIX \
    GIT_OBJECT_DIRECTORY GIT_COMMON_DIR 2>/dev/null || true
  WORK="$(mktemp -d)"
  REMOTE="$WORK/remote.git"
  SEED="$WORK/seed"
  CLONE="$WORK/clone"

  # Pin the bare repo's default branch so it matches the pushed branch
  # regardless of the runner's init.defaultBranch.
  git init -q --bare -b main "$REMOTE"

  mkdir -p "$SEED"
  cp -R "$REPO_DIR/scripts" "$SEED/scripts"
  git -C "$SEED" init -q -b main
  git -C "$SEED" config user.email "test@example.com"
  git -C "$SEED" config user.name "Test"
  git -C "$SEED" add .
  git -C "$SEED" commit -qm "init"
  git -C "$SEED" remote add origin "$REMOTE"
  git -C "$SEED" push -q -u origin main

  git clone -q "$REMOTE" "$CLONE"
  UPDATE="$CLONE/scripts/commands/update.sh"
}

teardown() {
  rm -rf "$WORK"
}

seed_new_commit() {
  echo "change $1" >>"$SEED/scripts/marker.txt"
  git -C "$SEED" add .
  git -C "$SEED" commit -qm "update $1"
  git -C "$SEED" push -q origin main
}

@test "update reports an up-to-date checkout" {
  run bash "$UPDATE"
  [ "$status" -eq 0 ]
  [[ "$output" == *"already up to date"* ]]
}

@test "dry run does not move HEAD" {
  seed_new_commit a
  before="$(git -C "$CLONE" rev-parse HEAD)"
  run bash "$UPDATE" --dry-run
  [ "$status" -eq 0 ]
  [[ "$output" == *"Dry run OK"* ]]
  [ "$(git -C "$CLONE" rev-parse HEAD)" = "$before" ]
}

@test "update fast-forwards to the remote tip" {
  seed_new_commit b
  target="$(git -C "$SEED" rev-parse HEAD)"
  run bash "$UPDATE"
  [ "$status" -eq 0 ]
  [ "$(git -C "$CLONE" rev-parse HEAD)" = "$target" ]
}

@test "update refuses when tracked files are dirty" {
  printf '\n# local edit\n' >>"$CLONE/scripts/cli.sh"
  run bash "$UPDATE"
  [ "$status" -ne 0 ]
  [[ "$output" == *"local changes"* ]]
}

@test "update --help prints usage" {
  run bash "$UPDATE" --help
  [ "$status" -eq 0 ]
  [[ "$output" == *"Usage: mac update"* ]]
}
