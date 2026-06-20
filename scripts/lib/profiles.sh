#!/usr/bin/env bash

profile_default() {
  printf '%s\n' "full"
}

profile_dir() {
  repo_dir="$1"

  printf '%s\n' "$repo_dir/profiles"
}

profile_brewfile() {
  repo_dir="$1"
  profile="$2"

  printf '%s\n' "$(profile_dir "$repo_dir")/$profile/Brewfile"
}

profile_exists() {
  repo_dir="$1"
  profile="$2"

  [ -f "$(profile_brewfile "$repo_dir" "$profile")" ]
}

profile_name_is_valid() {
  profile="$1"

  # Accept any profile that ships a directory under profiles/, but keep the
  # name to a safe charset so it can never escape the profiles directory.
  case "$profile" in
    "") return 1 ;;
    *[!a-zA-Z0-9_-]*) return 1 ;;
    *) return 0 ;;
  esac
}

profile_list() {
  repo_dir="$1"
  profiles_dir="$(profile_dir "$repo_dir")"

  if [ ! -d "$profiles_dir" ]; then
    return 0
  fi

  find "$profiles_dir" -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | sort | paste -sd ' ' -
}

profile_validate() {
  repo_dir="$1"
  profile="$2"

  if [ -z "$profile" ]; then
    return 1
  fi

  if ! profile_name_is_valid "$profile"; then
    return 1
  fi

  profile_exists "$repo_dir" "$profile"
}
