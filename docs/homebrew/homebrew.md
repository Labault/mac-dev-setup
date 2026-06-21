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

![brew bundle check successful output](../assets/screenshots/homebrew/brew-bundle-check.webp)

## Packages

The complete, classified list of every formula and cask — with its role
(used / installed / tooling) — lives in a single source of truth:

- [`docs/homebrew/inventory.md`](inventory.md)

Maintaining the list in one place avoids the drift that comes from duplicating
it across documents. The [README "What's included" tables](../../README.md#whats-included)
group the same tools by purpose with a short description and a link to each
tool's dedicated page.

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

---

[← Docs index](../README.md) · [Project README](../../README.md)
