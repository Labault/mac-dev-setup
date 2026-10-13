# Shared helpers for the Bats suite. Load with `load test_helper` in setup().

# Create a throwaway directory of real tools symlinked by name, so a test can
# run a script under a minimal PATH. Sets the global `bin` to the new directory.
# Usage: make_stub_bin bash awk dirname
make_stub_bin() {
  bin="$(mktemp -d)"
  local tool
  for tool in "$@"; do
    ln -s "$(command -v "$tool")" "$bin/$tool"
  done
}

# Write an executable stub at the given path; the body is read from stdin.
# Usage:
#   write_stub "$bin/brew" <<'SH'
#   #!/bin/sh
#   exit 0
#   SH
write_stub() {
  local path="$1"
  cat >"$path"
  chmod +x "$path"
}

# Keep temporary repositories independent of personal signing and hooks.
isolate_git() {
  unset GIT_DIR GIT_WORK_TREE GIT_INDEX_FILE GIT_PREFIX \
    GIT_OBJECT_DIRECTORY GIT_COMMON_DIR GIT_CONFIG GIT_CONFIG_PARAMETERS
  export GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_COUNT=0
}
