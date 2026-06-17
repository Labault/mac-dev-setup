# ShellCheck

ShellCheck analyzes shell scripts and reports common errors, unsafe patterns, portability problems, and style issues.

It is included in this setup to improve the reliability of Bash and shell scripts before they are committed or executed.

## Installation

ShellCheck is installed through Homebrew:

```bash
brew install shellcheck
```

It is part of the curated Homebrew environment; see [`Homebrew setup`](../homebrew/homebrew.md) to install everything at once.

## Verify the installation

Check that ShellCheck is available:

```bash
shellcheck --version
```

## Analyze a script

Run ShellCheck against a shell script with:

```bash
shellcheck path/to/script.sh
```

Several scripts can be analyzed in a single command:

```bash
shellcheck script-one.sh script-two.sh
```

To analyze all shell scripts tracked by Git:

```bash
git ls-files '*.sh' -z | xargs -0 -r shellcheck
```

## Shell dialect

ShellCheck uses the script shebang to determine which shell dialect should be analyzed.

For example:

```bash
#!/usr/bin/env bash
```

Scripts should declare an explicit and accurate shebang so that ShellCheck can apply the correct rules.

A dialect can also be selected manually:

```bash
shellcheck --shell=bash path/to/script.sh
```

## Findings

ShellCheck findings include a code such as `SC2086` or `SC2155`.

These codes make it possible to:

- understand the reported problem;
- consult the corresponding rule documentation;
- suppress one specific rule when there is a justified exception.

Warnings should normally be fixed instead of ignored.

## Targeted exclusions

A specific finding can be disabled for the following line:

```bash
# shellcheck disable=SC2086
command $value
```

Exclusions should remain narrow and include enough context to explain why the warning is intentionally ignored.

Project-wide exclusions should be avoided unless they are clearly justified.

## Pre-commit integration

ShellCheck should eventually be integrated into `pre-commit` when shell scripts are present in the repository.

Homebrew will continue to manage the executable, while `pre-commit` will define when and against which files it runs.

Until then, ShellCheck can be executed manually:

```bash
git ls-files '*.sh' -z | xargs -0 -r shellcheck
```

## Rollback

Remove ShellCheck with:

```bash
brew uninstall shellcheck
```

Then remove its entry from `profiles/full/Brewfile`.

Any related pre-commit hook must also be removed separately.
