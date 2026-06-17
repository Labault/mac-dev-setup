#!/bin/bash

# shellcheck source=scripts/lib/command_metadata.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/command_metadata.sh"

COMMAND_REGISTRY_FIELD_SEPARATOR="$(printf '\t')"

command_registry_record() {
  command_name="$1"
  command_path="$2"
  command_description="$3"

  printf '%s\t%s\t%s\n' "$command_name" "$command_path" "$command_description"
}

command_registry_filename_name() {
  command_path="$1"

  command_file="$(basename "$command_path")"
  printf '%s\n' "${command_file%.*}"
}

command_registry_build() {
  commands_dir="$1"

  if [ ! -d "$commands_dir" ]; then
    return 0
  fi

  for command_path in "$commands_dir"/*; do
    if [ ! -f "$command_path" ] || [ ! -x "$command_path" ]; then
      continue
    fi

    command_name="$(command_registry_filename_name "$command_path")"
    command_metadata="$(command_metadata_parse "$command_path")"
    metadata_name="$(command_metadata_name_from_record "$command_metadata")"
    command_description="$(command_metadata_description_from_record "$command_metadata")"

    if [ -n "$metadata_name" ]; then
      command_name="$metadata_name"
    fi

    command_registry_record "$command_name" "$command_path" "$command_description"
  done
}

command_registry_find() {
  commands_dir="$1"
  requested_command="$2"

  command_registry_build "$commands_dir" | while IFS="$COMMAND_REGISTRY_FIELD_SEPARATOR" read -r command_name command_path command_description; do
    if [ "$command_name" = "$requested_command" ]; then
      command_registry_record "$command_name" "$command_path" "$command_description"
      return 0
    fi
  done
}

command_registry_name() {
  command_record="$1"

  IFS="$COMMAND_REGISTRY_FIELD_SEPARATOR" read -r command_name _command_path _command_description <<< "$command_record"
  printf '%s\n' "$command_name"
}

command_registry_path() {
  command_record="$1"

  IFS="$COMMAND_REGISTRY_FIELD_SEPARATOR" read -r _command_name command_path _command_description <<< "$command_record"
  printf '%s\n' "$command_path"
}

command_registry_description_from_record() {
  command_record="$1"

  IFS="$COMMAND_REGISTRY_FIELD_SEPARATOR" read -r _command_name _command_path command_description <<< "$command_record"
  printf '%s\n' "$command_description"
}

command_registry_command_path() {
  commands_dir="$1"
  requested_command="$2"
  command_record="$(command_registry_find "$commands_dir" "$requested_command")"

  if [ -z "$command_record" ]; then
    return 0
  fi

  command_registry_path "$command_record"
}

command_registry_command_exists() {
  commands_dir="$1"
  requested_command="$2"

  [ -n "$(command_registry_command_path "$commands_dir" "$requested_command")" ]
}
