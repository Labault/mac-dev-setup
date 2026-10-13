#!/usr/bin/env bats

setup() {
  load test_helper
  REPO_DIR="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
  WORK="$(mktemp -d)"
  cp -R "$REPO_DIR/scripts" "$WORK/scripts"
  cp -R "$REPO_DIR/profiles" "$WORK/profiles"
  # Relocate system prefixes in this disposable copy, never on the host.
  if [ -f "$WORK/scripts/lib/homebrew.sh" ]; then
    sed "s|/opt/homebrew|$WORK/arm|g; s|/usr/local|$WORK/intel|g" \
      "$WORK/scripts/lib/homebrew.sh" >"$WORK/helper"
    mv "$WORK/helper" "$WORK/scripts/lib/homebrew.sh"
  fi
  make_stub_bin bash awk dirname mkdir tee
  export MAC_DEV_SETUP_LOG_DIR="$WORK/logs"
  export BOOT_WORK="$WORK"
  write_stub "$bin/uname" <<'SH'
#!/bin/sh
echo "${BOOT_ARCH:-arm64}"
SH
  write_stub "$WORK/brew" <<'SH'
#!/bin/sh
if [ "$1" = shellenv ]; then
  echo "export PATH=\"$(dirname "$0"):\$PATH\""
else
  echo "BREW $*"
fi
SH
  for step in git zsh; do
    write_stub "$WORK/scripts/$step.sh" <<'SH'
#!/bin/bash
brew --version
SH
  done
  write_stub "$bin/curl" <<'SH'
#!/bin/sh
cat <<'INSTALL'
mkdir -p "$BOOT_WORK/${BOOT_PREFIX:-arm}/bin"
cp "$BOOT_WORK/brew" "$BOOT_WORK/${BOOT_PREFIX:-arm}/bin/brew"
INSTALL
SH
  # Installer subprocess uses ordinary file tools, provided as stubs/symlinks.
  for tool in cat cp; do
    ln -s "$(command -v "$tool")" "$bin/$tool"
  done
}

teardown() {
  rm -rf "$WORK" "$bin"
}

@test "bootstrap reuses Apple Silicon Homebrew outside PATH" {
  mkdir -p "$WORK/arm/bin"
  cp "$WORK/brew" "$WORK/arm/bin/brew"
  run env PATH="$bin" bash "$WORK/scripts/brew.sh"
  [ "$status" -eq 0 ]
  [[ "$output" != *"Installing Homebrew"* ]]
  [[ "$output" == *"BREW update"* ]]
}

@test "bootstrap reuses Intel Homebrew outside PATH" {
  mkdir -p "$WORK/intel/bin"
  cp "$WORK/brew" "$WORK/intel/bin/brew"
  run env PATH="$bin" BOOT_ARCH=x86_64 bash "$WORK/scripts/brew.sh"
  [ "$status" -eq 0 ]
  [[ "$output" != *"Installing Homebrew"* ]]
  [[ "$output" == *"BREW update"* ]]
}

@test "cold bootstrap exposes Homebrew to subsequent setup steps" {
  run env PATH="$bin" bash "$WORK/scripts/setup.sh" --profile minimal
  [ "$status" -eq 0 ]
  [[ "$output" == *"Installing Homebrew"* ]]
  [[ "$output" == *"BREW --version"* ]]
  [[ "$output" == *"completed successfully"* ]]
}

@test "download failure stops setup before Git and Zsh" {
  write_stub "$bin/curl" <<'SH'
#!/bin/sh
exit 22
SH
  run env PATH="$bin" bash "$WORK/scripts/setup.sh"
  [ "$status" -ne 0 ]
  [[ "$output" == *"Cannot download Homebrew installer"* ]]
  [[ "$output" != *"BREW --version"* ]]
  [[ "$output" != *"completed successfully"* ]]
}

@test "installer failure stops setup" {
  write_stub "$bin/curl" <<'SH'
#!/bin/sh
echo 'exit 7'
SH
  run env PATH="$bin" bash "$WORK/scripts/setup.sh"
  [ "$status" -ne 0 ]
  [[ "$output" == *"Homebrew installation failed"* ]]
  [[ "$output" != *"completed successfully"* ]]
}

@test "successful installer without brew fails explicitly" {
  write_stub "$bin/curl" <<'SH'
#!/bin/sh
echo 'exit 0'
SH
  run env PATH="$bin" bash "$WORK/scripts/setup.sh"
  [ "$status" -ne 0 ]
  [[ "$output" == *"Homebrew executable not found"* ]]
}

@test "cold Intel bootstrap exposes Homebrew to subsequent steps" {
  run env PATH="$bin" BOOT_ARCH=x86_64 BOOT_PREFIX=intel bash "$WORK/scripts/setup.sh"
  [ "$status" -eq 0 ]
  [[ "$output" == *"BREW --version"* ]]
}

@test "existing brew shellenv failure does not trigger reinstallation" {
  write_stub "$bin/brew" <<'SH'
#!/bin/sh
exit 9
SH
  run env PATH="$bin" bash "$WORK/scripts/brew.sh"
  [ "$status" -ne 0 ]
  [[ "$output" == *"Cannot activate existing Homebrew"* ]]
  [[ "$output" != *"Installing Homebrew"* ]]
}
