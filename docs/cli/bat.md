# bat

## Overview

[bat](https://github.com/sharkdp/bat) is a command-line file viewer with syntax
highlighting, line numbers, Git integration, and paging.

It is used as a more readable alternative to the standard `cat` command.

The tool is installed through Homebrew and declared in the project `Brewfile`.

## Installation

Install all tools declared in the `Brewfile`:

```bash
brew bundle --file=Brewfile
```

Install bat directly:

```bash
brew install bat
```

Verify the installation:

```bash
bat --version
brew list --formula | grep -x bat
```

## Basic usage

Display a file:

```bash
bat README.md
```

Display several files:

```bash
bat README.md Brewfile
```

Display line numbers:

```bash
bat --number README.md
```

Disable paging:

```bash
bat --paging=never README.md
```

## Syntax highlighting

bat automatically detects the file type and applies syntax highlighting.

Force a language when detection is incorrect:

```bash
bat --language yaml .pre-commit-config.yaml
```

List the supported languages:

```bash
bat --list-languages
```

## Git integration

Inside a Git repository, bat can display modified lines in the gutter.

This makes it useful for reviewing configuration and documentation changes
without opening an editor.

## Relationship with cat

Use `cat` when raw, unformatted output is required in a script or pipeline.

Use `bat` for interactive reading in the terminal.

Avoid replacing `cat` globally in scripts because bat adds formatting and may
invoke a pager.

## Useful examples

Review the Brewfile:

```bash
bat Brewfile
```

Review the pre-commit configuration:

```bash
bat .pre-commit-config.yaml
```

Display a specific line range:

```bash
bat --line-range 20:60 README.md
```

## Shell alias

An optional interactive alias can be added:

```bash
alias cat='bat --paging=never'
```

This alias should only be used interactively and should not be relied on in
portable scripts.

## Troubleshooting

Display all options:

```bash
bat --help
```

Confirm the executable path:

```bash
command -v bat
```

On some Linux distributions, the executable may be named `batcat`, but the
Homebrew installation uses `bat`.

## Updates

Update bat through Homebrew:

```bash
brew upgrade bat
```

## Rollback

Remove bat with Homebrew:

```bash
brew uninstall bat
```

Then remove its entry from `profiles/full/Brewfile`.
