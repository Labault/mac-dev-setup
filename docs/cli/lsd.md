# lsd

## Overview

[lsd](https://github.com/lsd-rs/lsd) is a modern replacement for `ls` with colors, icons, file type indicators, and tree output.

It is installed because the Zsh aliases use it for daily directory browsing.

## Installation

lsd is part of the curated Homebrew profiles.

Install it directly:

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

## Configuration

This repository exposes aliases in `configs/zsh/alias.sh`.

The most important one is:

```bash
ll
```

It maps to a detailed listing powered by lsd.

## Rollback

Remove lsd with:

```bash
brew uninstall lsd
```

Then remove or adjust aliases that call `lsd`.
