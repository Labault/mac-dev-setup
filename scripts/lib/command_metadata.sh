#!/bin/bash

COMMAND_METADATA_FIELD_SEPARATOR="$(printf '\t')"

command_metadata_parse() {
  command_path="$1"

  awk -v separator="$COMMAND_METADATA_FIELD_SEPARATOR" '
    function trim(value) {
      sub(/^[[:space:]]+/, "", value)
      sub(/[[:space:]]+$/, "", value)
      return value
    }

    NR == 1 && /^#!/ {
      next
    }

    /^[[:space:]]*$/ {
      next
    }

    /^[[:space:]]*#/ {
      line = $0

      if (line ~ /^[[:space:]]*#[[:space:]]*@name([[:space:]]*:|[[:space:]]|$)/) {
        sub(/^[[:space:]]*#[[:space:]]*@name([[:space:]]*:)?[[:space:]]*/, "", line)
        name = trim(line)
      } else if (line ~ /^[[:space:]]*#[[:space:]]*@description([[:space:]]*:|[[:space:]]|$)/) {
        sub(/^[[:space:]]*#[[:space:]]*@description([[:space:]]*:)?[[:space:]]*/, "", line)
        description = trim(line)
      } else if (description == "" && line ~ /^[[:space:]]*#[[:space:]]*Description:[[:space:]]*/) {
        sub(/^[[:space:]]*#[[:space:]]*Description:[[:space:]]*/, "", line)
        description = trim(line)
      }

      next
    }

    {
      exit
    }

    END {
      printf "%s%s%s\n", name, separator, description
    }
  ' "$command_path"
}

command_metadata_name_from_record() {
  metadata_record="$1"

  printf '%s\n' "${metadata_record%%"$COMMAND_METADATA_FIELD_SEPARATOR"*}"
}

command_metadata_description_from_record() {
  metadata_record="$1"

  printf '%s\n' "${metadata_record#*"$COMMAND_METADATA_FIELD_SEPARATOR"}"
}
