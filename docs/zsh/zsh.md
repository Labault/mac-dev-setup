# Zsh

## Overview

This setup provides a curated Zsh environment for macOS, with:

- Homebrew environment initialization;
- Antidote-based plugin management;
- a small, reviewed plugin list;
- separate public and private shell configuration;
- a dedicated Powerlevel10k configuration;
- explicit testing and rollback procedures.

The configuration is intentionally kept small, readable, and machine-aware. Public files are stored in this repository, while sensitive or machine-specific values remain outside version control.

## File structure

The public Zsh configuration is split across a small set of focused files:

- `configs/zsh/.zprofile` initializes Homebrew, user-local command-line tools, and OrbStack shell integration;
- `configs/zsh/.zshrc` loads Antidote, plugins, aliases, private configuration, and Powerlevel10k;
- `configs/zsh/.zsh_plugins.txt` defines the curated Antidote plugin list;
- `configs/zsh/alias.sh` contains public, reusable aliases;
- `configs/zsh/.p10k.zsh` contains the curated Powerlevel10k configuration.

Machine-specific or sensitive shell configuration is intentionally kept outside the repository.
