# Ukelele

## Overview

[Ukelele](https://software.sil.org/ukelele/) is a Unicode keyboard layout editor for macOS.

It is installed because this repository ships a custom French OSS keyboard layout and occasionally needs a graphical editor to inspect or evolve it.

## Installation

Install Ukelele directly:

```bash
brew install --cask ukelele
```

Verify the installation:

```bash
brew list --cask ukelele
```

## Usage

Open Ukelele from Applications or with:

```bash
open -a Ukelele
```

The bundled layout lives in:

```text
configs/keyboard/Francais-OSS-Mac.bundle
```

See [`french-oss.md`](french-oss.md) for installation and verification.

## Editing policy

Treat keyboard layout changes as source changes:

- edit the versioned bundle;
- verify the layout manually on macOS;
- update documentation when behavior changes;
- keep a backup before replacing the installed system layout.

## Rollback

Remove Ukelele with:

```bash
brew uninstall --cask ukelele
```
