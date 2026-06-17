#!/bin/bash

set -e

# ----------------------------
# CONTEXT (FROM CLI)
# ----------------------------
PROFILE=${PROFILE:-}
DRY_RUN=${DRY_RUN:-false}

# ----------------------------
# CONTEXT
# ----------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=scripts/lib/logging.sh
source "$SCRIPT_DIR/lib/logging.sh"
# shellcheck source=scripts/lib/profiles.sh
source "$SCRIPT_DIR/lib/profiles.sh"

REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

print_usage() {
  log_line "Usage: scripts/setup.sh [--profile full|minimal] [--dry-run]"
  log_line "Profiles: $(profile_list "$REPO_DIR")"
}

parse_args() {
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
      --dry-run)
        DRY_RUN="true"
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
}

parse_args "$@"

PROFILE="${PROFILE:-$(profile_default)}"
BREWFILE="$(profile_brewfile "$REPO_DIR" "$PROFILE")"

if ! profile_validate "$REPO_DIR" "$PROFILE"; then
  error "Invalid profile: $PROFILE"
  info "Available profiles: $(profile_list "$REPO_DIR")"
  exit 1
fi

info "Mac Dev Setup - Bootstrap starting"
info "Profile: $PROFILE"
info "Brewfile: $BREWFILE"

# ----------------------------
# DRY RUN (MUST BE FIRST)
# ----------------------------
if [ "$DRY_RUN" = "true" ]; then
  info "Dry run mode activated - nothing will be executed"
  exit 0
fi

# ----------------------------
# LOGS
# ----------------------------
# Use an absolute, user-level location so the log never lands in whatever
# directory the user happened to run "mac setup" from.
LOG_DIR="${MAC_DEV_SETUP_LOG_DIR:-$HOME/Library/Logs/mac-dev-setup}"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/setup.log"

exec > >(tee -a "$LOG_FILE") 2>&1
info "Logging to $LOG_FILE"

# ----------------------------
# EXECUTION
# ----------------------------
PROFILE="$PROFILE" bash "$SCRIPT_DIR/brew.sh"
bash "$SCRIPT_DIR/git.sh"
bash "$SCRIPT_DIR/zsh.sh"

# ----------------------------
# POST VALIDATION
# ----------------------------
info "Post install validation"

command -v brew >/dev/null && success "brew ok"
command -v git >/dev/null && success "git ok"
command -v zsh >/dev/null && success "zsh ok"

# ----------------------------
# CI MODE
# ----------------------------
if [ "$CI" = "true" ]; then
  info "Running in CI mode"
fi

success "Mac Dev Setup completed successfully"
