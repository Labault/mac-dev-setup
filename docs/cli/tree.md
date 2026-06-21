# tree

[tree](https://gitlab.com/OldManProgrammer/unix-tree) displays directory structures as a recursive tree.

It is useful for inspecting a project layout, documenting repository structure, and sharing a concise overview of files and folders.

The tool is installed through Homebrew and declared in the project `Brewfile`.

## Installation

It is part of the curated Homebrew environment; see [`Homebrew setup`](../homebrew/homebrew.md) to install everything at once.

Install tree directly:

```bash
brew install tree
```

Verify the installation:

```bash
tree --version
brew list --formula | grep -x tree
```

## Usage

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

- documenting or reviewing a repository layout;
- sharing an architecture overview;
- comparing folder structures before and after a change.

## Safety

tree is read-only.

It displays filesystem contents and does not modify files or directories.

Be careful before sharing its output publicly, as file and directory names can expose sensitive paths and filenames.

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

## Rollback

Remove tree with Homebrew:

```bash
brew uninstall tree
```

Then remove its entry from `profiles/full/Brewfile`.

---

[← Docs index](../README.md) · [Project README](../../README.md)
