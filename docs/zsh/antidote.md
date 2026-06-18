# Antidote

[Antidote](https://antidote.sh/) is the Zsh plugin manager used by this setup.

It reads the managed plugin list and generates a fast static plugin bundle for Zsh startup.

The tool is installed through Homebrew and declared in the project `Brewfile`.

## Installation

It is part of the curated Homebrew environment; see [`Homebrew setup`](../homebrew/homebrew.md) to install everything at once.

Install Antidote directly:

```bash
brew install antidote
```

Verify the installation:

```bash
brew list --formula | grep -x antidote
brew --prefix antidote
```

## Managed configuration

The main Zsh documentation lives in [`zsh.md`](zsh.md).

The managed files are:

```text
configs/zsh/.zshrc
configs/zsh/.zsh_plugins.txt
```

The plugin list is versioned so a new Mac gets the same shell behavior.

## Refresh plugins

Open a new shell or run:

```bash
zsh -ic 'antidote update'
```

Then restart Zsh:

```bash
exec zsh
```

## Troubleshooting

Confirm Antidote loads:

```bash
zsh -ic 'type antidote'
```

If plugins do not load, verify that the Homebrew prefix is available before `.zshrc` initializes Antidote.

## Rollback

Remove Antidote with:

```bash
brew uninstall antidote
```

Then remove Antidote-specific lines from the managed Zsh files before applying setup again.
