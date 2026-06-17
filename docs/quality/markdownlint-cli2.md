# markdownlint-cli2

## Overview

[markdownlint-cli2](https://github.com/DavidAnson/markdownlint-cli2)
validates Markdown files against configurable style and structure rules.

It helps keep the repository documentation consistent as the number of
Markdown files grows.

The tool is installed through Homebrew and declared in the project `Brewfile`.

## Installation

Install all tools declared in the `Brewfile`:

```bash
brew bundle --file=Brewfile
```

Install markdownlint-cli2 directly:

```bash
brew install markdownlint-cli2
```

Verify the installation:

```bash
markdownlint-cli2 --version
brew list --formula | grep -x markdownlint-cli2
```

## Repository configuration

The repository configuration is declared in:

```text
.markdownlint-cli2.yaml
```

Current configuration:

```yaml
config:
  MD013: false
```

The `MD013` line-length rule is disabled because enforcing an 80-character
limit would make the documentation unnecessarily difficult to maintain.

Other Markdown rules remain enabled.

## Running the checks

Check all Markdown files:

```bash
markdownlint-cli2 "**/*.md"
```

Check selected files:

```bash
markdownlint-cli2 README.md docs/**/*.md
```

Apply supported automatic fixes:

```bash
markdownlint-cli2 --fix "**/*.md"
```

Automatic fixes should be reviewed before being committed.

## Pre-commit integration

The repository runs markdownlint-cli2 through `pre-commit`.

The hook is configured as a local system hook:

```yaml
- id: markdownlint-cli2
  name: markdownlint-cli2
  entry: markdownlint-cli2
  language: system
  types: [markdown]
```

Run only this hook:

```bash
pre-commit run markdownlint-cli2 --all-files
```

## Common rules

markdownlint can detect issues such as:

- inconsistent heading levels;
- missing blank lines around lists or headings;
- repeated blank lines;
- malformed fenced code blocks;
- inconsistent list markers;
- missing language identifiers on code fences;
- trailing punctuation or spacing problems.

The exact active rules depend on the repository configuration.

## Fixing errors

Run the checker and review the reported file and line number:

```bash
markdownlint-cli2 "**/*.md"
```

For automatically fixable issues:

```bash
markdownlint-cli2 --fix "**/*.md"
```

Then inspect the changes:

```bash
git diff
```

Do not disable a rule globally when a local documentation issue can be fixed
cleanly.

## Configuration changes

Any rule change should be:

1. motivated by the repository's actual writing style;
2. applied narrowly;
3. documented when it affects contributors;
4. tested against all Markdown files.

Avoid disabling multiple rules simply to make the checker pass.

## Relationship with lychee

markdownlint-cli2 validates Markdown structure and style.

Lychee validates links found inside Markdown files.

Both tools are complementary:

```bash
markdownlint-cli2 "**/*.md"
lychee README.md 'docs/**/*.md'
```

## Troubleshooting

Display the available options:

```bash
markdownlint-cli2 --help
```

Confirm the executable path:

```bash
command -v markdownlint-cli2
```

Validate only the repository README:

```bash
markdownlint-cli2 README.md
```

If a configuration change is not applied, confirm that
`.markdownlint-cli2.yaml` exists at the repository root.

## Updates

Update markdownlint-cli2 through Homebrew:

```bash
brew upgrade markdownlint-cli2
```

After an update, rerun the complete documentation check because new rules or
rule behavior may be introduced.

## Rollback

Remove markdownlint-cli2 with Homebrew:

```bash
brew uninstall markdownlint-cli2
```

Then remove:

- its entry from `profiles/full/Brewfile`;
- its hook from `.pre-commit-config.yaml`;
- `.markdownlint-cli2.yaml` if no other Markdown tooling uses it.
