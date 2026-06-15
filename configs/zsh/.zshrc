# Enable Powerlevel10k instant prompt.
# Keep this block close to the top of ~/.zshrc.
# Commands requiring user interaction must be placed above it.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ---------------------------------------------------------------------------
# Oh My Zsh, plugins, and Powerlevel10k through Antidote
# ---------------------------------------------------------------------------

ANTIDOTE_SCRIPT="${HOMEBREW_PREFIX}/opt/antidote/share/antidote/antidote.zsh"
ANTIDOTE_PLUGINS="${ZDOTDIR:-$HOME}/.zsh_plugins.txt"

if [[ -r "$ANTIDOTE_SCRIPT" && -r "$ANTIDOTE_PLUGINS" ]]; then
  source "$ANTIDOTE_SCRIPT"
  antidote load "$ANTIDOTE_PLUGINS"
else
  print -u2 "Warning: Antidote or its plugin list could not be loaded."
fi

# Personal aliases.
[[ -r "$HOME/.shell/alias.sh" ]] && source "$HOME/.shell/alias.sh"

# Private and machine-specific configuration.
[[ -r "$HOME/.shell/local.zsh" ]] && source "$HOME/.shell/local.zsh"

# Powerlevel10k configuration.
[[ -r "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"
