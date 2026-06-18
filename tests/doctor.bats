#!/usr/bin/env bats

setup() {
  REPO_DIR="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
}

make_common_doctor_path() {
  bin="$(mktemp -d)"

  for tool in bash dirname find basename sort paste; do
    ln -s "$(command -v "$tool")" "$bin/$tool"
  done

  printf '#!/bin/sh\nprintf "macOS"\n' >"$bin/sw_vers"
  printf '#!/bin/sh\nprintf "arm64"\n' >"$bin/uname"
  printf '#!/bin/sh\nexit 0\n' >"$bin/git"
  printf '#!/bin/sh\nexit 0\n' >"$bin/zsh"
  printf '#!/bin/sh\nexit 0\n' >"$bin/mac"

  chmod +x "$bin/sw_vers" "$bin/uname" "$bin/git" "$bin/zsh" "$bin/mac"
}

@test "doctor exits non-zero and reports the missing tool" {
  make_common_doctor_path

  # Everything resolves except mac, so the diagnostic must fail.
  rm "$bin/mac"
  printf '#!/bin/sh\nexit 0\n' >"$bin/brew"
  chmod +x "$bin/brew"

  run env PATH="$bin" bash "$REPO_DIR/scripts/commands/doctor.sh"
  rm -rf "$bin"

  [ "$status" -ne 0 ]
  [[ "$output" == *"mac CLI missing"* ]]
  [[ "$output" == *"Doctor found problems"* ]]
}

@test "doctor --help is read-only and exits cleanly" {
  run bash "$REPO_DIR/scripts/commands/doctor.sh" --help
  [ "$status" -eq 0 ]
  [[ "$output" == *"Usage: mac doctor"* ]]
}

@test "doctor rejects an invalid profile" {
  run bash "$REPO_DIR/scripts/commands/doctor.sh" --profile "no/such"
  [ "$status" -ne 0 ]
  [[ "$output" == *"Invalid profile"* ]]
}

@test "doctor checks the selected profile Brewfile" {
  make_common_doctor_path
  log_file="$bin/brew.log"

  cat >"$bin/brew" <<BREW
#!/bin/sh
printf '%s\n' "\$*" >> "$log_file"
exit 0
BREW
  chmod +x "$bin/brew"

  run env PATH="$bin" bash "$REPO_DIR/scripts/commands/doctor.sh" --profile minimal
  brew_log="$(cat "$log_file")"
  rm -rf "$bin"

  [ "$status" -eq 0 ]
  [[ "$output" == *"Profile: minimal"* ]]
  [[ "$output" == *"profile packages in sync"* ]]
  [[ "$brew_log" == *"bundle check --file=$REPO_DIR/profiles/minimal/Brewfile"* ]]
}

@test "doctor exits non-zero when profile packages are missing" {
  make_common_doctor_path

  cat >"$bin/brew" <<'BREW'
#!/bin/sh
case "$*" in
  doctor) exit 0 ;;
  bundle\ check*) exit 1 ;;
  *) exit 0 ;;
esac
BREW
  chmod +x "$bin/brew"

  run env PATH="$bin" bash "$REPO_DIR/scripts/commands/doctor.sh" --profile minimal
  rm -rf "$bin"

  [ "$status" -ne 0 ]
  [[ "$output" == *"profile packages missing or outdated"* ]]
  [[ "$output" == *"Run: mac setup --profile minimal"* ]]
}
