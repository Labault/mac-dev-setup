#!/bin/bash

set -e

# Resolve real repo path from symlink
REAL_PATH="$(readlink "$0" || true)"
if [ -z "$REAL_PATH" ]; then
  REAL_PATH="$0"
fi
REPO_DIR="$(cd "$(dirname "$REAL_PATH")/.." && pwd)"

case "$1" in
  setup)
    shift
    PROFILE="full"
    DRY_RUN="false"

    while [ "$#" -gt 0 ]; do
      case "$1" in
        --profile)
          PROFILE="${2:-}"
          shift 2
          ;;
        --profile=*)
          PROFILE="${1#*=}"
          shift
          ;;
        --dry-run)
          DRY_RUN="true"
          shift
          ;;
        *)
          echo "Unknown option: $1" >&2
          echo "Usage: mac setup [--profile full|minimal] [--dry-run]" >&2
          exit 1
          ;;
      esac
    done

    case "$PROFILE" in
      full|minimal) ;;
      *)
        echo "Invalid profile: $PROFILE" >&2
        echo "Usage: mac setup [--profile full|minimal] [--dry-run]" >&2
        exit 1
        ;;
    esac

    PROFILE="$PROFILE" DRY_RUN="$DRY_RUN" bash "$REPO_DIR/scripts/setup.sh"
    ;;
  *)
    echo "Usage: mac setup [--profile full|minimal] [--dry-run]"
    ;;
esac
