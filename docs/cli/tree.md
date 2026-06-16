# tree

## Overview

[tree](https://oldmanprogrammer.net/source.php?dir=projects/tree) displays directory structures as a recursive tree.

It is useful for inspecting a project layout, documenting repository structure, and sharing a concise overview of files and folders.

The tool is installed through Homebrew and declared in the project `Brewfile`.

## Installation

Install all tools declared in the `Brewfile`:

```bash
brew bundle --file=Brewfile
```

Install tree directly:

```bash
brew install tree
```

Verify the installation:

```bash
tree --version
brew list --formula | grep -x tree
```

## Basic usage

Display the current directory structure:

```bash
tree
```

Limit the displayed depth:

```bash
tree -L 2
```

Include hidden files:

```bash
tree -a
```

Display directories only:

```bash
tree -d
```

## Excluding large directories

Project directories often contain generated or dependency folders that make the output difficult to read.

Exclude common heavy directories:

```bash
tree -L 3 -I '.git|vendor|node_modules'
```

For a Symfony project:

```bash
tree -L 3 -I '.git|vendor|node_modules|var'
```

## Useful output options

Display file sizes:

```bash
tree -h
```

Display full relative paths:

```bash
tree -f
```

Export the structure to a text file:

```bash
tree -L 3 -I '.git|vendor|node_modules' > project-tree.txt
```

The generated file should only be committed when it provides lasting documentation value.

## Useful use cases

tree is useful for:

- documenting a repository layout;
- reviewing a new project;
- sharing an architecture overview;
- inspecting generated directories;
- preparing bug reports or technical discussions;
- comparing folder structures before and after a change.

## Safety

tree is read-only.

It displays filesystem contents and does not modify files or directories.

Be careful before sharing its output publicly because file and directory names may reveal:

- project names;
- usernames;
- client information;
- environment names;
- internal architecture;
- sensitive filenames.

## Troubleshooting

Display the available options:

```bash
tree --help
```

Confirm the executable path:

```bash
command -v tree
```

If the output is too large, reduce the depth or exclude additional directories:

```bash
tree -L 2 -I '.git|vendor|node_modules|var|cache'
```

## Updates

Update tree through Homebrew:

```bash
brew upgrade tree
```

## Rollback

Remove tree with Homebrew:

```bash
brew uninstall tree
```

Then remove its entry from the root `Brewfile`.
