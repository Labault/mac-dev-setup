#!/usr/bin/env bash

# Validate commit messages against this repo's gitmoji + Conventional Commits
# format. Replaces commitlint; mirrors the rules of commitlint-config-gitmoji
# (start-with-gitmoji, type-enum, subject-empty, subject-full-stop, scope-case,
# header-max-length, body-leading-blank).
#
# Usage:
#   lint-commit-msg.sh <commit-msg-file>      # commit-msg hook (one message)
#   lint-commit-msg.sh --range <from> <to>    # lint every commit in a range (CI)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/lib/logging.sh
source "$SCRIPT_DIR/lib/logging.sh"

# Conventional Commit types accepted (from @gitmoji/commit-types).
GITMOJI_TYPES='build ci docs feat fix perf refactor revert style test chore wip'

HEADER_MAX_LENGTH=100

# Valid gitmoji, Unicode form (variation selectors U+FE0F included).
GITMOJI_UNICODE='🎨
⚡️
🔥
🐛
🚑️
✨
📝
🚀
💄
🎉
✅
🔒️
🔐
🔖
🚨
🚧
💚
⬇️
⬆️
📌
👷
📈
♻️
➕
➖
🔧
🔨
🌐
✏️
💩
⏪️
🔀
📦️
👽️
🚚
📄
💥
🍱
♿️
💡
🍻
💬
🗃️
🔊
🔇
👥
🚸
🏗️
📱
🤡
🥚
🙈
📸
⚗️
🔍️
🏷️
🌱
🚩
🥅
💫
🗑️
🛂
🩹
🧐
⚰️
🧪
👔
🩺
🧱
🧑‍💻
💸
🧵
🦺
✈️'

# Valid gitmoji, :code: form.
GITMOJI_CODES=':art:
:zap:
:fire:
:bug:
:ambulance:
:sparkles:
:memo:
:rocket:
:lipstick:
:tada:
:white_check_mark:
:lock:
:closed_lock_with_key:
:bookmark:
:rotating_light:
:construction:
:green_heart:
:arrow_down:
:arrow_up:
:pushpin:
:construction_worker:
:chart_with_upwards_trend:
:recycle:
:heavy_plus_sign:
:heavy_minus_sign:
:wrench:
:hammer:
:globe_with_meridians:
:pencil2:
:poop:
:rewind:
:twisted_rightwards_arrows:
:package:
:alien:
:truck:
:page_facing_up:
:boom:
:bento:
:wheelchair:
:bulb:
:beers:
:speech_balloon:
:card_file_box:
:loud_sound:
:mute:
:busts_in_silhouette:
:children_crossing:
:building_construction:
:iphone:
:clown_face:
:egg:
:see_no_evil:
:camera_flash:
:alembic:
:mag:
:label:
:seedling:
:triangular_flag_on_post:
:goal_net:
:dizzy:
:wastebasket:
:passport_control:
:adhesive_bandage:
:monocle_face:
:coffin:
:test_tube:
:necktie:
:stethoscope:
:bricks:
:technologist:
:money_with_wings:
:thread:
:safety_vest:
:airplane:'

# Validate a single raw commit message. $2 is an optional label (a SHA in range
# mode) used in error output. Returns 0 when valid, 1 otherwise.
validate_message() {
  local raw="$1" label="$2"
  local -a lines=() errs=()
  local header="" header_index=-1 i h rest e prefix code type scope subject next
  local emoji_ok=0 _line

  # Drop the comment lines git adds to the commit-msg file.
  while IFS= read -r _line || [ -n "$_line" ]; do
    lines+=("$_line")
  done < <(printf '%s\n' "$raw" | grep -vE '^[[:space:]]*#' || true)

  # The header is the first line with non-whitespace content.
  for i in "${!lines[@]}"; do
    if [ -n "${lines[$i]//[[:space:]]/}" ]; then
      header="${lines[$i]}"
      header_index="$i"
      break
    fi
  done

  if [ -z "$header" ]; then
    error "invalid commit message${label:+ ($label)}: message is empty"
    return 1
  fi

  if [ "${#header}" -gt "$HEADER_MAX_LENGTH" ]; then
    errs+=("header is ${#header} characters, the maximum is $HEADER_MAX_LENGTH")
  fi

  # Strip any leading whitespace before the gitmoji (parserOpts allowed it).
  h="$header"
  h="${h#"${h%%[![:space:]]*}"}"

  # Match a leading gitmoji: Unicode form first, then the :code: form. A prefix
  # match against the exact list reproduces commitlint's variation-selector
  # sensitivity (e.g. the lock emoji is only valid with its U+FE0F selector).
  while IFS= read -r e; do
    [ -z "$e" ] && continue
    prefix="$e "
    if [ "${h#"$prefix"}" != "$h" ]; then
      rest="${h#"$prefix"}"
      emoji_ok=1
      break
    fi
  done <<< "$GITMOJI_UNICODE"

  if [ "$emoji_ok" -eq 0 ]; then
    code="${h%%[[:space:]]*}"
    case $'\n'"$GITMOJI_CODES"$'\n' in
      *$'\n'"$code"$'\n'*)
        prefix="$code "
        if [ "${h#"$prefix"}" != "$h" ]; then
          rest="${h#"$prefix"}"
          emoji_ok=1
        fi
        ;;
    esac
  fi

  # Parse "<type>(<scope>)?(!)?: <subject>" with parameter expansion rather than a
  # single regex: bash's =~ delegates to the platform regex engine, and older
  # libc builds (e.g. the macOS CI runner) mishandle the escaped scope parens and
  # the nested [:space:] class, rejecting every header that carries a scope.
  if [ "$emoji_ok" -eq 0 ]; then
    errs+=("must start with a valid gitmoji (Unicode emoji or :code:) — see https://gitmoji.dev/")
  else
    case "$rest" in
      *": "*)
        # Split on the first ": " into the "type(scope)!" prefix and the subject.
        prefix="${rest%%": "*}"
        subject="${rest#*": "}"
        prefix="${prefix%"!"}" # drop an optional breaking-change marker

        type="$prefix"
        scope=""
        case "$prefix" in
          *"("*")")
            type="${prefix%%"("*}"
            scope="${prefix#*"("}"
            scope="${scope%")"}"
            ;;
        esac

        case " $GITMOJI_TYPES " in
          *" $type "*) ;;
          *) errs+=("type \"$type\" is not allowed — use one of: $GITMOJI_TYPES") ;;
        esac

        # Enumerate the upper-case letters rather than use an [A-Z] range: under a
        # dictionary-collation locale (e.g. system bash on the macOS CI runner)
        # the range also matches lower-case letters, rejecting every valid scope.
        case "$scope" in
          *[ABCDEFGHIJKLMNOPQRSTUVWXYZ]*) errs+=("scope \"$scope\" must be lower-case") ;;
        esac

        if [ -z "${subject//[[:space:]]/}" ]; then
          errs+=("subject must not be empty")
        fi

        case "$subject" in
          *.) errs+=("subject must not end with a period") ;;
        esac
        ;;
      *)
        errs+=("header must match \"<emoji> <type>(<scope>): <subject>\"")
        ;;
    esac
  fi

  # body-leading-blank: a body must be separated from the header by a blank line.
  next=$((header_index + 1))
  if [ "$next" -lt "${#lines[@]}" ] && [ -n "${lines[$next]//[[:space:]]/}" ]; then
    errs+=("the body must be separated from the header by a blank line")
  fi

  if [ "${#errs[@]}" -gt 0 ]; then
    error "invalid commit message${label:+ ($label)}:"
    log_line "    $header"
    for e in "${errs[@]}"; do
      log_line "    x $e"
    done
    return 1
  fi

  return 0
}

lint_commits() {
  local commits sha body status=0
  if ! commits="$(git rev-list --reverse "$@")"; then
    error "Cannot determine commits: check the Git references and checkout history"
    return 1
  fi
  if [ -z "$commits" ]; then
    info "No commits to check"
    return 0
  fi
  while IFS= read -r sha; do
    if ! body="$(git log -1 --format=%B "$sha")"; then
      error "Cannot read commit $sha"
      return 1
    fi
    if ! validate_message "$body" "$sha"; then
      status=1
    fi
  done <<<"$commits"
  if [ "$status" -eq 0 ]; then
    success "all commit messages follow the gitmoji + Conventional Commits format"
  fi
  return "$status"
}

check_commit_ref() {
  if ! git rev-parse --verify --quiet --end-of-options "${1}^{commit}" >/dev/null; then
    error "Cannot determine commits: invalid commit reference $1"
    return 1
  fi
}

lint_range() {
  check_commit_ref "$1" || return 1
  check_commit_ref "$2" || return 1
  lint_commits "${1}..${2}"
}

lint_ci() {
  local from to
  case "${CI_EVENT:-}" in
    workflow_dispatch)
      info "No commit delta for workflow_dispatch; commit check skipped"
      return 0
      ;;
    pull_request)
      from="${PR_BASE_SHA:-}"
      to="${PR_HEAD_SHA:-}"
      ;;
    push)
      from="${PUSH_BEFORE_SHA:-}"
      to="${PUSH_AFTER_SHA:-}"
      if [[ "$from" =~ ^0+$ ]] && [ -n "$to" ]; then
        check_commit_ref "$to" || return 1
        lint_commits "$to"
        return "$?"
      fi
      ;;
    *)
      error "Unsupported CI event: ${CI_EVENT:-unset}"
      return 1
      ;;
  esac
  if [ -z "$from" ] || [ -z "$to" ]; then
    error "Cannot determine commits: missing CI references"
    return 1
  fi
  lint_range "$from" "$to"
}

main() {
  case "${1:-}" in
    --ci) lint_ci ;;
    --range)
      lint_range "${2:?--range requires <from> <to>}" "${3:?--range requires <from> <to>}"
      ;;
    *)
      local file body
      file="${1:?usage: lint-commit-msg.sh <commit-msg-file> | --range <from> <to> | --ci}"
      body="$(<"$file")"
      validate_message "$body" ""
      ;;
  esac
}

main "$@"
