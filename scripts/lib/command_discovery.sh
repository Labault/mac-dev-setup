#!/bin/bash

discover_commands() {
  commands_dir="$1"

  if [ ! -d "$commands_dir" ]; then
    return 0
  fi

  for command_script in "$commands_dir"/*; do
    if [ ! -f "$command_script" ] || [ ! -x "$command_script" ]; then
      continue
    fi

    command_file="$(basename "$command_script")"
    command_name="${command_file%.*}"

    printf '%s:%s\n' "$command_name" "$command_script"
  done
}

command_script_path() {
  commands_dir="$1"
  requested_command="$2"

  if [ ! -d "$commands_dir" ]; then
    return 0
  fi

  for command_script in "$commands_dir"/*; do
    if [ ! -f "$command_script" ] || [ ! -x "$command_script" ]; then
      continue
    fi

    command_file="$(basename "$command_script")"
    command_name="${command_file%.*}"

    if [ "$command_name" = "$requested_command" ]; then
      printf '%s\n' "$command_script"
      return 0
    fi
  done
}

command_exists() {
  commands_dir="$1"
  requested_command="$2"

  [ -n "$(command_script_path "$commands_dir" "$requested_command")" ]
}
