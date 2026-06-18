# KeeWeb

## Overview

[KeeWeb](https://keeweb.info/) is a KeePass-compatible password manager for KDBX databases.

It is installed as a desktop option for working with password databases without committing secrets to the repository.

## Installation

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
