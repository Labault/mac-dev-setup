# Homebrew.
if [[ -x "/opt/homebrew/bin/brew" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x "/usr/local/bin/brew" ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# User-local command-line tools.
if [[ -d "$HOME/.local/bin" ]]; then
  typeset -U path
  path=("$HOME/.local/bin" "${path[@]}")
fi

export PATH

# OrbStack command-line tools and shell integration.
[[ -r "$HOME/.orbstack/shell/init.zsh" ]] && source "$HOME/.orbstack/shell/init.zsh"
