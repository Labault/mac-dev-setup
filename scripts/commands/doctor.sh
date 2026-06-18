#!/bin/bash
# Description: Run system diagnostics for the macOS development setup.

set -eo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

# shellcheck source=scripts/lib/logging.sh
source "$REPO_DIR/scripts/lib/logging.sh"
# shellcheck source=scripts/lib/profiles.sh
source "$REPO_DIR/scripts/lib/profiles.sh"

print_usage() {
  log_line "Usage: mac doctor [--profile <profile>] [--fix] [--help]"
  log_line "Profiles: $(profile_list "$REPO_DIR")"
  log_line ""
  log_line "Run read-only diagnostics for the macOS development setup."
  log_line ""
  log_line "Options:"
  log_line "  --profile <profile>  Check the selected setup profile."
  log_line "  --fix                Print reconciliation commands without running them."
}

parse_args() {
  PROFILE="$(profile_default)"
  FIX="false"

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
      --fix)
        FIX="true"
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
FIX_SUGGESTIONS=""

doctor_in_sync() {
  success "✅ in sync: $*"
}

doctor_drift() {
  warn "⚠️ drift: $*"
}

doctor_missing() {
  error "❌ missing: $*"
}

add_fix_suggestion() {
  suggestion="$1"

  case "$FIX_SUGGESTIONS" in
    *"$suggestion"*) return 0 ;;
  esac

  FIX_SUGGESTIONS="${FIX_SUGGESTIONS}${suggestion}
"
}

check_command() {
  command_name="$1"
  label="$2"

  if command -v "$command_name" >/dev/null; then
    doctor_in_sync "$label installed"
  else
    doctor_missing "$label"
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
    doctor_in_sync "profile packages"
  else
    doctor_missing "profile packages missing or outdated"
    log_line "Run: mac setup --profile $profile"
    add_fix_suggestion "mac setup --profile $profile"
    add_fix_suggestion "brew bundle --file=\"$brewfile\""
    DOCTOR_STATUS=1
  fi
}

declared_homebrew_packages() {
  for profile in $(profile_list "$REPO_DIR"); do
    brewfile="$(profile_brewfile "$REPO_DIR" "$profile")"

    sed -n \
      -e 's/^[[:space:]]*brew[[:space:]]*"\([^"]*\)".*/\1/p' \
      -e 's/^[[:space:]]*cask[[:space:]]*"\([^"]*\)".*/\1/p' \
      "$brewfile"
  done | sed 's#.*/##' | sort -u
}

installed_homebrew_packages() {
  {
    brew list --formula 2>/dev/null || true
    brew list --cask 2>/dev/null || true
  } | sort -u
}

check_homebrew_drift() {
  if ! command -v brew >/dev/null; then
    warn "brew unavailable; skipping undeclared package check"
    return
  fi

  cleanup() { rm -f "${declared_file:-}" "${installed_file:-}" "${drift_file:-}"; }
  trap cleanup EXIT

  declared_file="$(mktemp)"
  installed_file="$(mktemp)"
  drift_file="$(mktemp)"

  declared_homebrew_packages >"$declared_file"
  installed_homebrew_packages >"$installed_file"
  comm -13 "$declared_file" "$installed_file" >"$drift_file"

  if [ -s "$drift_file" ]; then
    doctor_drift "undeclared Homebrew packages installed"
    while IFS= read -r package; do
      log_line "  - $package"
      add_fix_suggestion "brew uninstall \"$package\""
    done <"$drift_file"
    log_line "Consider adding intentional tools to a profile Brewfile, or uninstalling local-only packages."
  else
    doctor_in_sync "no undeclared Homebrew packages"
  fi

  rm -f "$declared_file" "$installed_file" "$drift_file"
}

managed_config_files() {
  printf '%s\t%s\t%s\n' "$REPO_DIR/configs/zsh/.zprofile" "$HOME/.zprofile" ".zprofile"
  printf '%s\t%s\t%s\n' "$REPO_DIR/configs/zsh/.zshrc" "$HOME/.zshrc" ".zshrc"
  printf '%s\t%s\t%s\n' "$REPO_DIR/configs/zsh/.zsh_plugins.txt" "$HOME/.zsh_plugins.txt" ".zsh_plugins.txt"
  printf '%s\t%s\t%s\n' "$REPO_DIR/configs/zsh/.p10k.zsh" "$HOME/.p10k.zsh" "p10k config"
  printf '%s\t%s\t%s\n' "$REPO_DIR/configs/zsh/alias.sh" "$HOME/.shell/alias.sh" "zsh aliases"
  printf '%s\t%s\t%s\n' "$REPO_DIR/configs/zsh/completions/_mac" "$HOME/.zsh/completions/_mac" "zsh completion"
}

check_config_drift() {
  config_status=0

  while IFS="$(printf '\t')" read -r source_file target_file label; do
    if [ ! -f "$source_file" ]; then
      doctor_drift "$label source missing: $source_file"
      config_status=1
      continue
    fi

    if [ ! -f "$target_file" ]; then
      doctor_drift "$label not installed: $target_file"
      config_status=1
      continue
    fi

    if ! cmp -s "$source_file" "$target_file"; then
      doctor_drift "$label differs from MacDevSetup copy: $target_file"
      config_status=1
    fi
  done < <(managed_config_files)

  if [ "$config_status" -eq 0 ]; then
    doctor_in_sync "managed config files"
  else
    log_line "Run: mac setup --profile $PROFILE"
    add_fix_suggestion "mac setup --profile $PROFILE"
  fi
}

print_fix_suggestions() {
  [ "$FIX" = "true" ] || return 0

  log_section "Fix suggestions"

  if [ -z "$FIX_SUGGESTIONS" ]; then
    success "No fix suggestions"
    return 0
  fi

  while IFS= read -r suggestion; do
    [ -n "$suggestion" ] || continue
    log_line "  $suggestion"
  done <<EOF
$FIX_SUGGESTIONS
EOF
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
      doctor_in_sync "brew doctor"
    else
      doctor_drift "brew doctor warnings"
    fi
  fi

  check_profile_brewfile "$PROFILE"
  check_homebrew_drift

  log_section "Config"
  check_config_drift

  log_section "mac CLI"

  check_command mac "mac CLI"

  print_fix_suggestions

  log_line ""

  if [ "$DOCTOR_STATUS" -eq 0 ]; then
    success "Doctor done"
  else
    error "Doctor found problems"
  fi

  return "$DOCTOR_STATUS"
}

main "$@"
