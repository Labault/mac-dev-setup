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
