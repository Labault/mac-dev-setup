#!/usr/bin/env bash
# Description: Update the mac CLI from its git repository.

set -eo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

# shellcheck source=scripts/lib/logging.sh
source "$REPO_DIR/scripts/lib/logging.sh"

REMOTE_NAME="${MAC_DEV_SETUP_UPDATE_REMOTE:-origin}"
DEFAULT_BRANCH="${MAC_DEV_SETUP_UPDATE_BRANCH:-main}"
TEMP_WORKTREE=""
ORIGINAL_HEAD=""
UPDATE_STARTED="false"

print_usage() {
  log_line "Usage: mac update [--dry-run]"
}

cleanup_temp_worktree() {
  if [ -n "$TEMP_WORKTREE" ]; then
    git -C "$REPO_DIR" worktree remove --force "$TEMP_WORKTREE" >/dev/null 2>&1 || rm -rf "$TEMP_WORKTREE"
  fi
}

rollback_update() {
  exit_code="$?"

  if [ "$UPDATE_STARTED" = "true" ] && [ -n "$ORIGINAL_HEAD" ]; then
    warn "Update failed; restoring previous version."
    git -C "$REPO_DIR" reset --hard "$ORIGINAL_HEAD" >/dev/null 2>&1 || true
  fi

  cleanup_temp_worktree
  exit "$exit_code"
}

die() {
  error "$*"
  exit 1
}

parse_args() {
  DRY_RUN="false"

  while [ "$#" -gt 0 ]; do
    case "$1" in
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

ensure_git_repo() {
  command -v git >/dev/null 2>&1 || die "git is required to update MacDevSetup."
  git -C "$REPO_DIR" rev-parse --is-inside-work-tree >/dev/null 2>&1 || die "$REPO_DIR is not a git repository."
  git -C "$REPO_DIR" remote get-url "$REMOTE_NAME" >/dev/null 2>&1 || die "Remote '$REMOTE_NAME' is not configured."
}

ensure_tracked_files_clean() {
  git -C "$REPO_DIR" update-index -q --refresh

  if ! git -C "$REPO_DIR" diff-files --quiet -- || ! git -C "$REPO_DIR" diff-index --cached --quiet HEAD --; then
    die "Tracked files have local changes. Commit or stash them before updating."
  fi
}

current_branch() {
  git -C "$REPO_DIR" symbolic-ref --quiet --short HEAD 2>/dev/null || true
}

upstream_ref() {
  git -C "$REPO_DIR" rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>/dev/null || true
}

select_target_ref() {
  branch="$(current_branch)"
  upstream="$(upstream_ref)"

  if [ -n "$upstream" ]; then
    printf '%s\n' "$upstream"
    return
  fi

  if [ -n "$branch" ] && git -C "$REPO_DIR" rev-parse --verify --quiet "$REMOTE_NAME/$branch" >/dev/null; then
    printf '%s\n' "$REMOTE_NAME/$branch"
    return
  fi

  if git -C "$REPO_DIR" rev-parse --verify --quiet "$REMOTE_NAME/$DEFAULT_BRANCH" >/dev/null; then
    printf '%s\n' "$REMOTE_NAME/$DEFAULT_BRANCH"
    return
  fi

  die "Could not find an update target. Set an upstream branch or MAC_DEV_SETUP_UPDATE_BRANCH."
}

prepare_target_worktree() {
  target_ref="$1"
  target_sha="$2"

  TEMP_WORKTREE="$(mktemp -d "${TMPDIR:-/tmp}/mac-dev-setup-update.XXXXXX")"
  rm -rf "$TEMP_WORKTREE"

  git -C "$REPO_DIR" worktree add --detach "$TEMP_WORKTREE" "$target_sha" >/dev/null

  [ -f "$TEMP_WORKTREE/scripts/cli.sh" ] || die "Fetched version is missing scripts/cli.sh."
  [ -d "$TEMP_WORKTREE/scripts/commands" ] || die "Fetched version is missing CLI commands."

  info "Prepared $target_ref in a temporary worktree."
}

ensure_fast_forward() {
  target_ref="$1"
  target_sha="$2"

  current_sha="$(git -C "$REPO_DIR" rev-parse HEAD)"

  if [ "$current_sha" = "$target_sha" ]; then
    success "MacDevSetup is already up to date."
    exit 0
  fi

  if ! git -C "$REPO_DIR" merge-base --is-ancestor HEAD "$target_sha"; then
    die "Update is not a fast-forward from the current checkout to $target_ref."
  fi
}

apply_update() {
  target_ref="$1"
  target_sha="$2"

  ORIGINAL_HEAD="$(git -C "$REPO_DIR" rev-parse HEAD)"
  UPDATE_STARTED="true"

  git -C "$REPO_DIR" merge --ff-only "$target_sha"
  chmod +x "$REPO_DIR/scripts/cli.sh"

  UPDATE_STARTED="false"
  success "Updated MacDevSetup to $(git -C "$REPO_DIR" rev-parse --short HEAD) from $target_ref."
}

main() {
  parse_args "$@"
  trap rollback_update EXIT INT TERM

  info "Checking MacDevSetup installation at $REPO_DIR."
  ensure_git_repo
  ensure_tracked_files_clean

  info "Fetching latest version from $REMOTE_NAME..."
  git -C "$REPO_DIR" fetch --prune "$REMOTE_NAME"

  target_ref="$(select_target_ref)"
  target_sha="$(git -C "$REPO_DIR" rev-parse "$target_ref")"

  ensure_fast_forward "$target_ref" "$target_sha"
  prepare_target_worktree "$target_ref" "$target_sha"

  if [ "$DRY_RUN" = "true" ]; then
    success "Dry run OK. Would update to $(git -C "$REPO_DIR" rev-parse --short "$target_sha") from $target_ref."
    cleanup_temp_worktree
    trap - EXIT INT TERM
    return 0
  fi

  apply_update "$target_ref" "$target_sha"
  cleanup_temp_worktree
  trap - EXIT INT TERM
}

main "$@"
