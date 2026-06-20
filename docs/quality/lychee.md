# lychee

[lychee](https://github.com/lycheeverse/lychee) checks links in Markdown,
HTML, and other text-based files.

It helps detect broken, redirected, or unreachable links across the repository
documentation.

The tool is installed through Homebrew and declared in the project `Brewfile`.

## Installation

It is part of the curated Homebrew environment; see [`Homebrew setup`](../homebrew/homebrew.md) to install everything at once.

Install lychee directly:

```bash
brew install lychee
```

Verify the installation:

```bash
lychee --version
brew list --formula | grep -x lychee
```

## Usage

Check the README and all documentation files:

```bash
lychee README.md 'docs/**/*.md'
```

![Lychee checking documentation links with zero errors](../assets/screenshots/quality/lychee.webp)

Check the current directory recursively:

```bash
lychee .
```

Check a single Markdown file:

```bash
lychee README.md
```

## Repository usage

The repository currently validates:

```text
README.md
docs/**/*.md
```

A successful run reports all links as valid and exits with status code `0`.

## Pre-commit integration

The repository runs lychee through `pre-commit`.

The hook is configured as a local system hook:

```yaml
- id: lychee
  name: lychee
  entry: lychee
  language: system
  pass_filenames: false
  args:
    - --exclude
    - 'https://claude\.ai'
    - README.md
    - docs/**/*.md
```

The `--exclude` entry skips `claude.ai`, which blocks automated link checkers
and would otherwise report false failures.

Run only this hook:

```bash
pre-commit run lychee --all-files
```

The hook scans the complete documentation set instead of only staged files.

## Interpreting results

Lychee reports broken links, unreachable hosts, redirected URLs, invalid local paths, unsupported schemes, timeouts, and blocked requests. Not every network failure means a link is permanently broken, since rate limiting, bot protection, DNS issues, temporary downtime, or authentication requirements can cause transient failures.

## Local links

Lychee also validates relative links between repository files.

Example:

```markdown
[Homebrew documentation](docs/homebrew/homebrew.md)
```

When documentation files are moved or renamed, the related links must be
updated before committing.

## External links

External links should point to stable and authoritative sources whenever
possible.

Prefer:

- official project documentation;
- official repositories;
- official package pages;
- stable documentation URLs.

Avoid relying on temporary search result URLs or tracking parameters.

## Excluding links

A link should only be excluded when it is intentionally inaccessible to the
checker and still valid for users.

Before excluding a link:

1. confirm that the URL is correct;
2. test it manually;
3. verify that the failure is reproducible;
4. prefer a more stable public URL when available.

Broad exclusions should be avoided because they can hide real failures.

## Relationship with markdownlint-cli2

Lychee validates links.

markdownlint-cli2 validates Markdown structure and style.

Both checks are complementary:

```bash
markdownlint-cli2 "**/*.md"
lychee README.md 'docs/**/*.md'
```

## Troubleshooting

Display all options:

```bash
lychee --help
```

Check one problematic URL directly:

```bash
lychee 'https://example.com'
```

Run with verbose output:

```bash
lychee --verbose README.md 'docs/**/*.md'
```

Confirm the executable path:

```bash
command -v lychee
```

When a remote site fails temporarily, rerun the check before changing the
documentation.

After an update, rerun the complete link check because HTTP handling or default
behavior may change.

## Rollback

Remove lychee with Homebrew:

```bash
brew uninstall lychee
```

Then remove:

- its entry from `profiles/full/Brewfile`;
- its hook from `.pre-commit-config.yaml`;
- any repository-specific lychee configuration no longer in use.
