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

log_test_dir="$(mktemp -d)"
(
  cd "$log_test_dir"
  bash "$REPO_DIR/scripts/setup.sh" --profile minimal --dry-run >/dev/null
)
if [ -e "$log_test_dir/logs" ]; then
  printf 'setup.sh must not create a logs directory in the current directory.\n' >&2
  rm -rf "$log_test_dir"
  exit 1
fi
rm -rf "$log_test_dir"

if grep -Eq 'mkdir -p logs|"logs/setup\.log"' "$REPO_DIR/scripts/setup.sh"; then
  printf 'setup.sh must use an absolute log path, not a relative logs/ directory.\n' >&2
  exit 1
fi

(
  # shellcheck source=scripts/lib/profiles.sh
  source "$REPO_DIR/scripts/lib/profiles.sh"
  if ! profile_name_is_valid full; then exit 1; fi
  if profile_name_is_valid "../etc"; then exit 1; fi
  if ! profile_validate "$REPO_DIR" minimal; then exit 1; fi
  if profile_validate "$REPO_DIR" no-such-profile; then exit 1; fi
) || {
  printf 'Profile validation contract failed.\n' >&2
  exit 1
}

uninstall_home="$(mktemp -d)"
cp "$REPO_DIR/configs/zsh/.zprofile" "$uninstall_home/.zprofile"
printf 'unmanaged content\n' >"$uninstall_home/.zshrc"
uninstall_config_output="$(HOME="$uninstall_home" bash "$REPO_DIR/scripts/commands/uninstall.sh" --remove-config --dry-run 2>&1)"
assert_contains "$uninstall_config_output" "Would remove .zprofile"
assert_contains "$uninstall_config_output" ".zshrc differs"
rm -rf "$uninstall_home"

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
