# editorconfig-checker

## Overview

[editorconfig-checker](https://github.com/editorconfig-checker/editorconfig-checker)
verifies that repository files respect the formatting rules declared in
`.editorconfig`.

It helps keep indentation, line endings, character encoding, final newlines,
and trailing whitespace consistent across editors and operating systems.

The tool is installed through Homebrew and declared in the project `Brewfile`.

## Installation

Install all tools declared in the `Brewfile`:

```bash
brew bundle --file=Brewfile
```

Install editorconfig-checker directly:

```bash
brew install editorconfig-checker
```

Verify the installation:

```bash
editorconfig-checker --version
brew list --formula | grep -x editorconfig-checker
```

## Repository configuration

The formatting rules are declared in:

```text
.editorconfig
```

The repository uses `.editorconfig` as the shared source of truth for basic
text formatting.

Example configuration:

```ini
root = true

[*]
charset = utf-8
end_of_line = lf
insert_final_newline = true
trim_trailing_whitespace = true
indent_style = space
indent_size = 2

[Makefile]
indent_style = tab

[*.md]
trim_trailing_whitespace = false
```

## Running the check

Check the entire repository:

```bash
editorconfig-checker
```

A successful check may produce no output.

Check specific files:

```bash
editorconfig-checker README.md Brewfile
```

Display all options:

```bash
editorconfig-checker --help
```

## Pre-commit integration

The repository runs editorconfig-checker through `pre-commit`.

The hook is configured as a local system hook:

```yaml
- id: editorconfig-checker
  name: editorconfig-checker
  entry: editorconfig-checker
  language: system
  pass_filenames: false
```

Run it through pre-commit:

```bash
pre-commit run editorconfig-checker --all-files
```

## Relationship with other hooks

editorconfig-checker complements the existing repository hooks:

- `trailing-whitespace` removes unwanted trailing spaces;
- `end-of-file-fixer` ensures a final newline;
- editorconfig-checker verifies the broader `.editorconfig` rules.

These checks overlap intentionally in a limited way to provide fast automatic
fixes and explicit repository-wide validation.

## Markdown exception

Markdown files may intentionally use trailing spaces for explicit line breaks.

The repository therefore disables automatic trimming for Markdown:

```ini
[*.md]
trim_trailing_whitespace = false
```

This exception should only be changed after reviewing the existing
documentation style.

## Editor support

Most modern editors support `.editorconfig` directly or through an extension.

The file helps keep formatting consistent in:

- Visual Studio Code;
- JetBrains IDEs;
- Vim and Neovim;
- text editors used by contributors;
- automated repository checks.

Editor support improves the editing experience, while editorconfig-checker
enforces the rules independently in the terminal.

## Troubleshooting

Confirm that `.editorconfig` exists:

```bash
test -f .editorconfig \
  && echo ".editorconfig found."
```

Run the checker from the repository root:

```bash
editorconfig-checker
```

Inspect whitespace and line-ending changes with Git:

```bash
git diff --check
git diff
```

If a file is intentionally exceptional, prefer adding a precise
`.editorconfig` section instead of disabling checks globally.

## Updates

Update editorconfig-checker through Homebrew:

```bash
brew upgrade editorconfig-checker
```

## Rollback

Remove editorconfig-checker with Homebrew:

```bash
brew uninstall editorconfig-checker
```

Then remove:

- its entry from `profiles/full/Brewfile`;
- its hook from `.pre-commit-config.yaml`;
- `.editorconfig` only if the repository no longer needs shared formatting
  rules.
