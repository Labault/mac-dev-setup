#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

printf 'MacDevSetup bootstrap now delegates to scripts/setup.sh.\n'
exec bash "$SCRIPT_DIR/setup.sh" "$@"
