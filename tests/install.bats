#!/usr/bin/env bats

# install.sh targets macOS and clones MAC_DEV_SETUP_REPO_URL. Point the URL at
# the local repository so the test runs offline, and use a unique CLI name so it
# never collides with a real "mac" already on PATH.

setup() {
  REPO_DIR="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
  if [ "$(uname -s)" != "Darwin" ]; then
    skip "install.sh targets macOS only"
  fi
  # Clear inherited git env (e.g. when run inside a husky hook) so the local
  # clone in install.sh is not hijacked by the parent repo's GIT_DIR.
  unset GIT_DIR GIT_WORK_TREE GIT_INDEX_FILE GIT_PREFIX \
    GIT_OBJECT_DIRECTORY GIT_COMMON_DIR 2>/dev/null || true
  WORK="$(mktemp -d)"
  CLI_NAME="mds-test-cli"

  # Clone from a dedicated seed repo on a real "main" branch rather than the
  # working checkout, which may be detached (e.g. a PR merge ref) on CI and
  # would break the idempotent `git pull --ff-only` path.
  SEED="$WORK/seed"
  mkdir -p "$SEED"
  cp -R "$REPO_DIR/scripts" "$SEED/scripts"
  git -C "$SEED" init -q -b main
  git -C "$SEED" config user.email "test@example.com"
  git -C "$SEED" config user.name "Test"
  git -C "$SEED" add .
  git -C "$SEED" commit -qm "seed"

  export MAC_DEV_SETUP_REPO_URL="$SEED"
  export MAC_DEV_SETUP_INSTALL_DIR="$WORK/install"
  export MAC_DEV_SETUP_BIN_DIR="$WORK/bin"
  export MAC_DEV_SETUP_SHELL_CONFIG="$WORK/profile"
  export MAC_DEV_SETUP_CLI_NAME="$CLI_NAME"
  INSTALL="$REPO_DIR/install.sh"
}

teardown() {
  rm -rf "$WORK"
}

@test "install creates the CLI symlink and a managed PATH block" {
  run bash "$INSTALL"
  [ "$status" -eq 0 ]
  [ -L "$WORK/bin/$CLI_NAME" ]
  run grep -F "mac-dev-setup PATH" "$WORK/profile"
  [ "$status" -eq 0 ]
}

@test "install is idempotent" {
  bash "$INSTALL"
  run bash "$INSTALL"
  [ "$status" -eq 0 ]
  [[ "$output" == *"already installed"* ]]
}

@test "uninstall removes the symlink and the PATH block" {
  bash "$INSTALL"
  run bash "$INSTALL" --uninstall
  [ "$status" -eq 0 ]
  [ ! -e "$WORK/bin/$CLI_NAME" ]
  run grep -F "mac-dev-setup PATH" "$WORK/profile"
  [ "$status" -ne 0 ]
}

@test "install --help prints usage" {
  run bash "$INSTALL" --help
  [ "$status" -eq 0 ]
  [[ "$output" == *"Usage: install.sh"* ]]
}
