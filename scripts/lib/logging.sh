#!/usr/bin/env bash

# Keep all CLI output behind these helpers so silent mode can be added in one
# place later.

_log_supports_color() {
  fd="$1"

  if [ -n "${NO_COLOR:-}" ] || [ ! -t "$fd" ]; then
    return 1
  fi

  if command -v tput >/dev/null 2>&1; then
    colors="$(tput colors 2>/dev/null || printf '0')"
    [ "${colors:-0}" -ge 8 ]
    return
  fi

  [ -n "${TERM:-}" ] && [ "$TERM" != "dumb" ]
}

_log_color() {
  color="$1"

  case "$color" in
    cyan) printf '\033[36m' ;;
    green) printf '\033[32m' ;;
    yellow) printf '\033[33m' ;;
    red) printf '\033[31m' ;;
    reset) printf '\033[0m' ;;
  esac
}

_log_emit() {
  label="$1"
  color="$2"
  fd="$3"
  shift 3

  if _log_supports_color "$fd"; then
    line="$(_log_color "$color")[$label]$(_log_color reset) $*"
  else
    line="[$label] $*"
  fi

  if [ "$fd" -eq 2 ]; then
    printf '%s\n' "$line" >&2
  else
    printf '%s\n' "$line"
  fi
}

log_line() {
  printf '%s\n' "$*"
}

log_section() {
  log_line ""
  log_line "$*"
}

info() {
  _log_emit INFO cyan 1 "$@"
}

success() {
  _log_emit OK green 1 "$@"
}

warn() {
  _log_emit WARN yellow 2 "$@"
}

error() {
  _log_emit ERROR red 2 "$@"
}
