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

## Installation

Copy or link the public configuration files to their expected locations:

```bash
cp configs/zsh/.zprofile "$HOME/.zprofile"
cp configs/zsh/.zshrc "$HOME/.zshrc"
cp configs/zsh/.zsh_plugins.txt "$HOME/.zsh_plugins.txt"
cp configs/zsh/.p10k.zsh "$HOME/.p10k.zsh"

mkdir -p "$HOME/.shell"
cp configs/zsh/alias.sh "$HOME/.shell/alias.sh"
```

The configuration expects Homebrew and Antidote to be installed before starting a new shell session.

Private or machine-specific settings should be stored in:

```text
~/.shell/local.zsh
```

This file is optional and must not be committed to the repository.

## Zsh profile

The `configs/zsh/.zprofile` file prepares the login-shell environment before the interactive Zsh configuration is loaded.

It performs three tasks:

- initializes Homebrew on Apple Silicon through `/opt/homebrew/bin/brew`;
- falls back to `/usr/local/bin/brew` for Intel-based Macs;
- prepends `$HOME/.local/bin` to `PATH` when the directory exists.

It also loads OrbStack shell integration when the following file is available:

`$HOME/.orbstack/shell/init.zsh`

The Homebrew detection keeps the configuration portable across both Apple Silicon and Intel Macs, while OrbStack integration remains optional.
