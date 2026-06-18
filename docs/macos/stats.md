# Stats

## Overview

[Stats](https://github.com/exelban/stats) is a macOS menu bar system monitor.

It displays CPU, memory, disk, network, battery, and sensor information without opening a terminal.

## Installation

Install Stats directly:

```bash
brew install --cask stats
```

Verify the installation:

```bash
brew list --cask stats
```

## Usage

Open Stats from Applications or with:

```bash
open -a Stats
```

Use it for quick local resource checks before reaching for terminal tools such as `glances` or `ctop`.

## Configuration

Stats stores preferences in the user's Library.

Those settings are not versioned by this repository because they are personal and can include machine-specific sensor choices.

## Rollback

Remove Stats with:

```bash
brew uninstall --cask stats
```
