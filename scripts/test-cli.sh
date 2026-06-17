#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

assert_contains() {
  haystack="$1"
  needle="$2"

  if ! printf '%s\n' "$haystack" | grep -F "$needle" >/dev/null; then
    printf 'Expected output to contain: %s\n' "$needle" >&2
    exit 1
  fi
}

help_output="$(bash "$REPO_DIR/scripts/cli.sh" help)"
assert_contains "$help_output" "doctor"
assert_contains "$help_output" "setup"
assert_contains "$help_output" "uninstall"
assert_contains "$help_output" "update"

setup_help_output="$(bash "$REPO_DIR/scripts/setup.sh" --help)"
assert_contains "$setup_help_output" "Usage: scripts/setup.sh"

mac_setup_help_output="$(bash "$REPO_DIR/scripts/cli.sh" setup --help)"
assert_contains "$mac_setup_help_output" "Usage: mac setup"

mac_doctor_help_output="$(bash "$REPO_DIR/scripts/cli.sh" doctor --help)"
assert_contains "$mac_doctor_help_output" "Usage: mac doctor"

setup_dry_run_output="$(bash "$REPO_DIR/scripts/cli.sh" setup --profile minimal --dry-run)"
assert_contains "$setup_dry_run_output" "Dry run mode activated"

if bash "$REPO_DIR/scripts/cli.sh" updte >/tmp/mac-dev-setup-cli-test.out 2>&1; then
  printf 'Expected an unknown command to fail.\n' >&2
  exit 1
fi
assert_contains "$(cat /tmp/mac-dev-setup-cli-test.out)" "mac update"
rm -f /tmp/mac-dev-setup-cli-test.out

doctor_bin="$(mktemp -d)"
for bootstrap_tool in bash dirname; do
  ln -s "$(command -v "$bootstrap_tool")" "$doctor_bin/$bootstrap_tool"
done
for stub in sw_vers uname brew git zsh; do
  printf '#!/bin/sh\nexit 0\n' >"$doctor_bin/$stub"
  chmod +x "$doctor_bin/$stub"
done
# mac is intentionally absent so the diagnostic must report a failure.
if PATH="$doctor_bin" bash "$REPO_DIR/scripts/commands/doctor.sh" >/tmp/mac-dev-setup-doctor.out 2>&1; then
  printf 'Expected doctor to exit non-zero when a required tool is missing.\n' >&2
  rm -rf "$doctor_bin" /tmp/mac-dev-setup-doctor.out
  exit 1
fi
assert_contains "$(cat /tmp/mac-dev-setup-doctor.out)" "mac CLI missing"
assert_contains "$(cat /tmp/mac-dev-setup-doctor.out)" "Doctor found problems"
rm -rf "$doctor_bin" /tmp/mac-dev-setup-doctor.out

bash "$REPO_DIR/scripts/generate-zsh-completion.sh" >/dev/null
git -C "$REPO_DIR" diff --exit-code -- configs/zsh/completions/_mac >/dev/null

printf 'CLI smoke tests passed.\n'
