# autojump

## Overview

[autojump](https://github.com/wting/autojump) learns the directories you use most often and lets you jump to them with the `j` command.

It is installed in the full profile and loaded through the managed Zsh configuration.

## Installation

Install autojump directly:

```bash
brew install autojump
```

Verify the installation:

```bash
brew list --formula | grep -x autojump
```

## Usage

After the shell integration is loaded, move around as usual. autojump learns from `cd` history.

Jump to a known directory:

```bash
j project-name
```

Open the best matching directory in Finder:

```bash
jo project-name
```

Show known entries:

```bash
autojump --stat
```

## Troubleshooting

Start a fresh Zsh session after setup:

```bash
exec zsh
```

Confirm the shell knows the command:

```bash
type j
```

autojump is useful only after it has observed enough directory changes.

## Rollback

Remove autojump with:

```bash
brew uninstall autojump
```

Then remove it from the managed Zsh plugin list if it is no longer wanted.
