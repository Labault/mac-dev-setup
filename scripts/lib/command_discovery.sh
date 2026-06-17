#!/bin/bash

# shellcheck source=scripts/lib/command_registry.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/command_registry.sh"

discover_commands() {
  commands_dir="$1"

  command_registry_build "$commands_dir" | while IFS="$COMMAND_REGISTRY_FIELD_SEPARATOR" read -r command_name command_path _command_description; do
    printf '%s:%s\n' "$command_name" "$command_path"
  done
}

command_script_path() {
  commands_dir="$1"
  requested_command="$2"

  command_registry_command_path "$commands_dir" "$requested_command"
}

command_exists() {
  commands_dir="$1"
  requested_command="$2"

  command_registry_command_exists "$commands_dir" "$requested_command"
}
