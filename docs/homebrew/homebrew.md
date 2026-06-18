# Homebrew

This document describes the curated Homebrew setup used by this project.

The goal is not to reproduce every package currently installed on a machine, but to keep a deliberate and tested selection of command-line tools and macOS applications.

## Brewfile

`profiles/full/Brewfile` contains the complete package inventory that has been
manually reviewed, tested, and accepted for this setup.

The root `Brewfile` is a compatibility link to `profiles/full/Brewfile`, so
existing `brew bundle --file=Brewfile` commands continue to work without
duplicating the inventory.

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
- `tlrc`: provides the maintained official `tldr` command for concise,
  example-driven command documentation.

### PHP and Symfony

- `php`: provides the PHP runtime used by local Symfony projects.
- `composer`: manages PHP project dependencies.
- `symfony-cli/tap/symfony-cli`: provides the Symfony CLI for local development and project tooling.
- `libpq`: provides PostgreSQL client libraries and command-line tools without installing the full PostgreSQL server.

### Development utilities

- `act`: executes GitHub Actions workflows locally using a container runtime.
- `actionlint`: validates GitHub Actions workflow files and expressions.
- `gh`: provides the GitHub CLI for repository, pull request, issue, and workflow operations.
- `glances`: provides detailed system monitoring from the terminal, including remote sessions.
- `gitleaks`: detects secrets, credentials, and sensitive values in repositories.
- `hadolint`: analyzes Dockerfiles for common mistakes and unsafe patterns.
- `pre-commit`: manages repository hooks that run checks before commits.
- `shellcheck`: detects errors and unsafe patterns in shell scripts.
- `uv`: installs and runs Python-based command-line tools in isolated environments.

## Casks

### Development

- `beekeeper-studio`: provides a graphical client for browsing and administering SQL databases.
- `orbstack`: provides the local Docker-compatible container runtime and Linux virtualization environment.

### Menu bar and monitoring

- `codexbar`: displays Codex and Claude usage information in the macOS menu bar.
- `jordanbaird-ice`: organizes and hides menu bar items.
- `stats`: displays system metrics directly in the menu bar.

### Security

- `keeweb`: manages KeePass-compatible password databases in the KDBX format.

### macOS maintenance

- `pearcleaner`: removes macOS applications and helps identify related leftover files.

## Maintenance

Update Homebrew metadata and installed packages:

```bash
brew update
brew upgrade
```

Check the Homebrew installation for potential problems:

```bash
brew doctor
```

Remove outdated package versions and cached downloads:

```bash
brew cleanup
```

## Rollback

Remove a formula with:

```bash
brew uninstall <formula>
```

Remove a cask with:

```bash
brew uninstall --cask <cask>
```

After uninstalling a package, remove its entry from `profiles/full/Brewfile`
and run the verification command again.
