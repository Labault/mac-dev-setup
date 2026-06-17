#!/usr/bin/env bats

setup() {
  REPO_DIR="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
  source "$REPO_DIR/scripts/lib/command_registry.sh"
  COMMANDS_DIR="$REPO_DIR/scripts/commands"
}

@test "registry build lists the known commands" {
  run command_registry_build "$COMMANDS_DIR"
  [ "$status" -eq 0 ]
  [[ "$output" == *setup* ]]
  [[ "$output" == *doctor* ]]
  [[ "$output" == *update* ]]
  [[ "$output" == *uninstall* ]]
}

@test "registry captures the Description header" {
  run command_registry_build "$COMMANDS_DIR"
  [[ "$output" == *diagnostics* ]]
}

@test "command_exists distinguishes known and unknown commands" {
  run command_registry_command_exists "$COMMANDS_DIR" setup
  [ "$status" -eq 0 ]
  run command_registry_command_exists "$COMMANDS_DIR" nope
  [ "$status" -ne 0 ]
}

@test "command_script_path resolves to the command file" {
  run command_registry_command_path "$COMMANDS_DIR" doctor
  [ "$status" -eq 0 ]
  [[ "$output" == *"/commands/doctor.sh" ]]
}

@test "@name and @description metadata headers override defaults" {
  tmp_dir="$(mktemp -d)"
  cat >"$tmp_dir/whatever.sh" <<'CMD'
#!/bin/bash
# @name greet
# @description Say hello to the user.
echo hi
CMD
  chmod +x "$tmp_dir/whatever.sh"

  run command_registry_build "$tmp_dir"
  rm -rf "$tmp_dir"
  [ "$status" -eq 0 ]
  # The name column is overridden to "greet" (the filename would be "whatever").
  [[ "$output" == greet$'\t'* ]]
  [[ "$output" == *"Say hello to the user."* ]]
}

@test "non-executable files are ignored" {
  tmp_dir="$(mktemp -d)"
  printf '#!/bin/bash\n# Description: ignored\n' >"$tmp_dir/skip.sh"
  run command_registry_build "$tmp_dir"
  rm -rf "$tmp_dir"
  [ "$status" -eq 0 ]
  [ -z "$output" ]
}
