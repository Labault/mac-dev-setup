#!/usr/bin/env bats

setup() {
  REPO_DIR="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
}

make_common_doctor_path() {
  bin="$(mktemp -d)"

  for tool in bash dirname find basename sort paste sed mktemp comm rm cat cmp mkdir cp; do
    ln -s "$(command -v "$tool")" "$bin/$tool"
  done

  printf '#!/bin/sh\nprintf "macOS"\n' >"$bin/sw_vers"
  printf '#!/bin/sh\nprintf "arm64"\n' >"$bin/uname"
  printf '#!/bin/sh\nexit 0\n' >"$bin/git"
  printf '#!/bin/sh\nexit 0\n' >"$bin/zsh"
  printf '#!/bin/sh\nexit 0\n' >"$bin/mac"

  chmod +x "$bin/sw_vers" "$bin/uname" "$bin/git" "$bin/zsh" "$bin/mac"
}

copy_managed_config_to_home() {
  home="$1"

  mkdir -p "$home/.shell" "$home/.zsh/completions"
  cp "$REPO_DIR/configs/zsh/.zprofile" "$home/.zprofile"
  cp "$REPO_DIR/configs/zsh/.zshrc" "$home/.zshrc"
  cp "$REPO_DIR/configs/zsh/.zsh_plugins.txt" "$home/.zsh_plugins.txt"
  cp "$REPO_DIR/configs/zsh/.p10k.zsh" "$home/.p10k.zsh"
  cp "$REPO_DIR/configs/zsh/alias.sh" "$home/.shell/alias.sh"
  cp "$REPO_DIR/configs/zsh/completions/_mac" "$home/.zsh/completions/_mac"
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
  [[ "$output" == *"❌ missing: mac CLI"* ]]
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
  [[ "$output" == *"✅ in sync: profile packages"* ]]
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
  [[ "$output" == *"❌ missing: profile packages missing or outdated"* ]]
  [[ "$output" == *"Run: mac setup --profile minimal"* ]]
}

@test "doctor reports no Homebrew drift when installed packages are declared" {
  make_common_doctor_path

  cat >"$bin/brew" <<'BREW'
#!/bin/sh
case "$*" in
  doctor) exit 0 ;;
  bundle\ check*) exit 0 ;;
  list\ --formula) printf '%s\n' bash bat gh ;;
  list\ --cask) printf '%s\n' visual-studio-code ;;
  *) exit 0 ;;
esac
BREW
  chmod +x "$bin/brew"

  run env PATH="$bin" bash "$REPO_DIR/scripts/commands/doctor.sh" --profile minimal
  rm -rf "$bin"

  [ "$status" -eq 0 ]
  [[ "$output" == *"✅ in sync: no undeclared Homebrew packages"* ]]
}

@test "doctor warns about installed packages missing from all profiles" {
  make_common_doctor_path

  cat >"$bin/brew" <<'BREW'
#!/bin/sh
case "$*" in
  doctor) exit 0 ;;
  bundle\ check*) exit 0 ;;
  list\ --formula) printf '%s\n' bash local-only-tool ;;
  list\ --cask) printf '%s\n' visual-studio-code local-only-app ;;
  *) exit 0 ;;
esac
BREW
  chmod +x "$bin/brew"

  run env PATH="$bin" bash "$REPO_DIR/scripts/commands/doctor.sh" --profile minimal
  rm -rf "$bin"

  [ "$status" -eq 0 ]
  [[ "$output" == *"⚠️ drift: undeclared Homebrew packages installed"* ]]
  [[ "$output" == *"local-only-tool"* ]]
  [[ "$output" == *"local-only-app"* ]]
}

@test "doctor reports managed config files in sync" {
  make_common_doctor_path
  home="$(mktemp -d)"
  copy_managed_config_to_home "$home"

  cat >"$bin/brew" <<'BREW'
#!/bin/sh
case "$*" in
  doctor) exit 0 ;;
  bundle\ check*) exit 0 ;;
  list\ --formula) printf '%s\n' bash bat gh ;;
  list\ --cask) printf '%s\n' visual-studio-code ;;
  *) exit 0 ;;
esac
BREW
  chmod +x "$bin/brew"

  run env PATH="$bin" HOME="$home" bash "$REPO_DIR/scripts/commands/doctor.sh" --profile minimal
  rm -rf "$bin" "$home"

  [ "$status" -eq 0 ]
  [[ "$output" == *"✅ in sync: managed config files"* ]]
}

@test "doctor warns when managed config differs" {
  make_common_doctor_path
  home="$(mktemp -d)"
  copy_managed_config_to_home "$home"
  printf 'local change\n' >>"$home/.zshrc"

  cat >"$bin/brew" <<'BREW'
#!/bin/sh
case "$*" in
  doctor) exit 0 ;;
  bundle\ check*) exit 0 ;;
  list\ --formula) printf '%s\n' bash bat gh ;;
  list\ --cask) printf '%s\n' visual-studio-code ;;
  *) exit 0 ;;
esac
BREW
  chmod +x "$bin/brew"

  run env PATH="$bin" HOME="$home" bash "$REPO_DIR/scripts/commands/doctor.sh" --profile minimal
  rm -rf "$bin" "$home"

  [ "$status" -eq 0 ]
  [[ "$output" == *"⚠️ drift: .zshrc differs from MacDevSetup copy"* ]]
  [[ "$output" == *"Run: mac setup --profile minimal"* ]]
}

@test "doctor --fix prints reconciliation commands without running them" {
  make_common_doctor_path
  home="$(mktemp -d)"
  copy_managed_config_to_home "$home"
  printf 'local change\n' >>"$home/.zshrc"

  cat >"$bin/brew" <<'BREW'
#!/bin/sh
case "$*" in
  doctor) exit 0 ;;
  bundle\ check*) exit 1 ;;
  list\ --formula) printf '%s\n' bash local-only-tool ;;
  list\ --cask) printf '%s\n' visual-studio-code ;;
  uninstall*) exit 42 ;;
  *) exit 0 ;;
esac
BREW
  chmod +x "$bin/brew"

  run env PATH="$bin" HOME="$home" bash "$REPO_DIR/scripts/commands/doctor.sh" --profile minimal --fix
  rm -rf "$bin" "$home"

  [ "$status" -ne 0 ]
  [[ "$output" == *"Fix suggestions"* ]]
  [[ "$output" == *"mac setup --profile minimal"* ]]
  [[ "$output" == *"brew bundle --file=\"$REPO_DIR/profiles/minimal/Brewfile\""* ]]
  [[ "$output" == *"brew uninstall \"local-only-tool\""* ]]
}

@test "doctor --fix reports no suggestions when everything is in sync" {
  make_common_doctor_path
  home="$(mktemp -d)"
  copy_managed_config_to_home "$home"

  cat >"$bin/brew" <<'BREW'
#!/bin/sh
case "$*" in
  doctor) exit 0 ;;
  bundle\ check*) exit 0 ;;
  list\ --formula) printf '%s\n' bash bat gh ;;
  list\ --cask) printf '%s\n' visual-studio-code ;;
  *) exit 0 ;;
esac
BREW
  chmod +x "$bin/brew"

  run env PATH="$bin" HOME="$home" bash "$REPO_DIR/scripts/commands/doctor.sh" --profile minimal --fix
  rm -rf "$bin" "$home"

  [ "$status" -eq 0 ]
  [[ "$output" == *"No fix suggestions"* ]]
}
