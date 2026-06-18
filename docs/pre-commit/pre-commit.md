# Pre-commit

## Overview

[pre-commit](https://pre-commit.com/) manages automated checks that run before a Git commit is created.

It helps detect problems early and keeps repository checks consistent across development environments.

The tool is installed through Homebrew and declared in the project `Brewfile`.

## Installation

It is part of the curated Homebrew environment; see [`Homebrew setup`](../homebrew/homebrew.md) to install everything at once.

Verify the installation:

```bash
pre-commit --version
```

## Repository configuration

The hooks used by this repository are declared in:

```text
.pre-commit-config.yaml
```

Install the Git hook locally after cloning the repository:

```bash
pre-commit install
```

This creates the local hook at:

```text
.git/hooks/pre-commit
```

The generated Git hook is local to the repository and is not committed.

## Running the checks

Run the hooks against staged files:

```bash
pre-commit run
```

Run all hooks against every tracked file:

```bash
pre-commit run --all-files
```

Validate the configuration file:

```bash
pre-commit validate-config
```

Update hook revisions:

```bash
pre-commit autoupdate
```

Any revision update must be reviewed and tested before being committed.

## Gitleaks

Gitleaks is enabled as the first repository hook.

It scans committed content for secrets such as:

- API keys;
- access tokens;
- passwords;
- private credentials.

Run only the Gitleaks hook:

```bash
pre-commit run gitleaks --all-files
```

Gitleaks is an additional safety layer. Secrets must still never be deliberately added to the repository.

## Additional hooks

Beyond the built-in hooks, the configuration runs ShellCheck (shell scripts),
markdownlint-cli2 (Markdown), lychee (link checking), editorconfig-checker, and
Actionlint (GitHub Actions workflows). Gitleaks runs as a secret scanner.

Hadolint (Dockerfiles) is intentionally not enabled yet: the repository has no
Dockerfiles for it to validate. Hooks are only added once relevant files
exist.

## Troubleshooting

Reinstall the local Git hook:

```bash
pre-commit uninstall
pre-commit install
```

Clear cached hook environments:

```bash
pre-commit clean
```

Run hooks with verbose output:

```bash
pre-commit run --all-files --verbose
```

## Rollback

Remove the local Git hook:

```bash
pre-commit uninstall
```

Restore the committed configuration if needed:

```bash
git restore .pre-commit-config.yaml
```
