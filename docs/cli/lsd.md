# lsd

## Overview

[lsd](https://github.com/lsd-rs/lsd) is a modern replacement for `ls` with colors, icons, file type indicators, and tree output.

The tool is installed through Homebrew and declared in the project `Brewfile`.

## Installation

It is part of the curated Homebrew environment; see [`Homebrew setup`](../homebrew/homebrew.md) to install everything at once.

Install lsd directly:

```bash
brew install lsd
```

Verify the installation:

```bash
lsd --version
brew list --formula | grep -x lsd
```

## Usage

List files:

```bash
lsd
```

Show details:

```bash
lsd -la
```

Show a tree:

```bash
lsd --tree --depth 2
```

The repository's Zsh aliases define `ll`, which maps to `lsd -la`.

lsd's icons require a Nerd Font (a patched font that includes extra glyphs), the same dependency Powerlevel10k needs.

## Rollback

Remove lsd with Homebrew:

```bash
brew uninstall lsd
```

Then remove its entry from `profiles/full/Brewfile`, and remove or adjust aliases that call `lsd`.
