# Homebrew

This document describes the curated Homebrew setup used by this project.

The goal is not to reproduce every package currently installed on a machine, but to keep a deliberate and tested selection of command-line tools and macOS applications.

## Brewfile

The root `Brewfile` contains only packages that have been manually reviewed, tested, and accepted for this setup.

It intentionally excludes packages that may still be installed locally but are no longer considered part of the curated environment.

## Install Homebrew

Install Homebrew using the official installer:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

On Apple Silicon Macs, Homebrew is installed under `/opt/homebrew`.

## Install the curated packages

From the repository root, install the accepted formulae and casks with:

```bash
brew bundle install --file=Brewfile
```

Homebrew skips packages that are already installed.

## Verify the setup

Check whether all dependencies declared in the Brewfile are already installed:

```bash
brew bundle check --file=Brewfile
```

A successful setup returns:

```text
The Brewfile's dependencies are satisfied.
```

## Formulae

### Shell and terminal

- `antidote`: manages Zsh plugins.
- `autojump`: provides fast navigation to frequently used directories.
- `lsd`: provides a modern and more visual alternative to `ls`.
- `terminal-notifier`: sends macOS notifications from terminal commands and scripts.
- `tldr`: provides concise, example-driven command documentation.

### PHP and Symfony

- `php`: provides the PHP runtime used by local Symfony projects.
- `composer`: manages PHP project dependencies.
- `symfony-cli/tap/symfony-cli`: provides the Symfony CLI for local development and project tooling.
- `libpq`: provides PostgreSQL client libraries and command-line tools without installing the full PostgreSQL server.

### Development utilities

- `gh`: provides the GitHub CLI for repository, pull request, issue, and workflow operations.
- `glances`: provides detailed system monitoring from the terminal, including remote sessions.
- `uv`: installs and runs Python-based command-line tools in isolated environments.

## Casks

### Menu bar and monitoring

- `codexbar`: displays Codex and Claude usage information in the macOS menu bar.
- `jordanbaird-ice`: organizes and hides menu bar items.
- `stats`: displays system metrics directly in the menu bar.

### Security

- `keeweb`: manages KeePass-compatible password databases in the KDBX format.

## Maintenance

Update Homebrew metadata and installed packages:

```bash
brew update
brew upgrade
```
