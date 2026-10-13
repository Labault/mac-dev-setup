#!/usr/bin/env bash

# Activate an existing installation in the calling shell. Keep the brew already
# selected by PATH; otherwise prefer the native macOS installation prefix.
activate_homebrew() {
  local prefix candidate shellenv
  if ! command -v brew >/dev/null 2>&1; then
    case "$(uname -m)" in
      arm64) prefix=/opt/homebrew ;;
      *) prefix=/usr/local ;;
    esac
    for candidate in "$prefix/bin/brew" /opt/homebrew/bin/brew /usr/local/bin/brew; do
      if [ -x "$candidate" ]; then
        export PATH="${candidate%/brew}:$PATH"
        break
      fi
    done
  fi
  command -v brew >/dev/null 2>&1 || return 1
  shellenv="$(brew shellenv)" || return 2
  eval "$shellenv"
}
