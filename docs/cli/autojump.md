# autojump

[autojump](https://github.com/wting/autojump) learns the directories you use most often and lets you jump to them with the `j` command.

The tool is installed through Homebrew and declared in the project `Brewfile`.

## Installation

It is part of the curated Homebrew environment; see [`Homebrew setup`](../homebrew/homebrew.md) to install everything at once.

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

Then remove its entry from `profiles/full/Brewfile` and remove it from the managed Zsh plugin list if it is no longer wanted.
