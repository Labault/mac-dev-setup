#!/bin/bash
# Description: Run system diagnostics for the macOS development setup.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

# shellcheck source=scripts/lib/logging.sh
source "$REPO_DIR/scripts/lib/logging.sh"
# shellcheck source=scripts/lib/profiles.sh
source "$REPO_DIR/scripts/lib/profiles.sh"

print_usage() {
  log_line "Usage: mac doctor [--profile <profile>] [--help]"
  log_line "Profiles: $(profile_list "$REPO_DIR")"
  log_line ""
  log_line "Run read-only diagnostics for the macOS development setup."
}

parse_args() {
  PROFILE="$(profile_default)"

  while [ "$#" -gt 0 ]; do
    case "$1" in
      --profile)
        PROFILE="${2:-}"
        if [ -z "$PROFILE" ] || [ "${PROFILE#--}" != "$PROFILE" ]; then
          error "Missing value for --profile"
          print_usage >&2
          exit 1
        fi
        shift 2
        ;;
      --profile=*)
        PROFILE="${1#*=}"
        if [ -z "$PROFILE" ]; then
          error "Missing value for --profile"
          print_usage >&2
          exit 1
        fi
        shift
        ;;
      --help|-h)
        print_usage
        exit 0
        ;;
      *)
        error "Unknown option: $1"
        print_usage >&2
        exit 1
        ;;
    esac
  done

  if ! profile_validate "$REPO_DIR" "$PROFILE"; then
    error "Invalid profile: $PROFILE"
    print_usage >&2
    exit 1
  fi
}

DOCTOR_STATUS=0

check_command() {
  command_name="$1"
  label="$2"

  if command -v "$command_name" >/dev/null; then
    success "$label installed"
  else
    error "$label missing"
    DOCTOR_STATUS=1
  fi
}

check_profile_brewfile() {
  profile="$1"
  brewfile="$(profile_brewfile "$REPO_DIR" "$profile")"

  log_line "Profile: $profile"

  if ! command -v brew >/dev/null; then
    warn "brew unavailable; skipping profile package check"
    return
  fi

  if brew bundle check --file="$brewfile" >/dev/null; then
    success "profile packages in sync"
  else
    error "profile packages missing or outdated"
    log_line "Run: mac setup --profile $profile"
    DOCTOR_STATUS=1
  fi
}

main() {
  parse_args "$@"

  info "Mac Doctor - System diagnostics"

  log_section "System"
  log_line "OS: $(sw_vers -productName) $(sw_vers -productVersion)"
  log_line "Arch: $(uname -m)"

  log_section "Tools"

  check_command brew "brew"
  check_command git "git"
  check_command zsh "zsh"

  log_section "Homebrew"

  if command -v brew >/dev/null; then
    if brew doctor >/dev/null 2>&1; then
      success "brew OK"
    else
      warn "brew warnings"
    fi
  fi

  check_profile_brewfile "$PROFILE"

  log_section "mac CLI"

  check_command mac "mac CLI"

  log_line ""

  if [ "$DOCTOR_STATUS" -eq 0 ]; then
    success "Doctor done"
  else
    error "Doctor found problems"
  fi

  return "$DOCTOR_STATUS"
}

main "$@"
