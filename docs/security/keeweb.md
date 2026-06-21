# KeeWeb

[KeeWeb](https://keeweb.info/) is a KeePass-compatible password manager for KDBX databases.

It is installed as a desktop option for working with password databases without committing secrets to the repository.

The tool is installed through Homebrew and declared in the project `Brewfile`.

> **Maintenance note:** KeeWeb's active development has slowed considerably. It
> still reads and writes the standard KDBX format, so your data is not locked
> in, but if you want an actively maintained alternative for the same format,
> consider [KeePassXC](https://keepassxc.org/) (`brew install --cask keepassxc`).

## Installation

It is part of the curated Homebrew environment; see [`Homebrew setup`](../homebrew/homebrew.md) to install everything at once.

Install KeeWeb directly:

```bash
brew install --cask keeweb
```

Verify the installation:

```bash
brew list --cask keeweb
```

## Usage

Open KeeWeb from Applications or with:

```bash
open -a KeeWeb
```

Store password databases outside the repository.

## Security notes

Never commit:

- KDBX files;
- key files;
- exported passwords;
- screenshots containing secrets;
- generated recovery material.

Back up password databases through a deliberate personal backup process.

## Rollback

Remove KeeWeb with:

```bash
brew uninstall --cask keeweb
```

Review local application data before deleting it.

---

[← Docs index](../README.md) · [Project README](../../README.md)
