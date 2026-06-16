# Actionlint

Actionlint validates GitHub Actions workflow files.

It detects syntax errors, invalid expressions, incorrect event configurations, unsupported keys, and several common workflow mistakes before they reach GitHub.

## Installation

Actionlint is installed through Homebrew:

```bash
brew install actionlint
```

It is also declared in the root `Brewfile`:

```bash
brew bundle install --file=Brewfile
```

## Verify the installation

Check that Actionlint is available:

```bash
actionlint --version
```

## Analyze workflows

From the root of a repository, run:

```bash
actionlint
```

By default, Actionlint searches for workflow files in:

```text
.github/workflows/
```

A specific workflow can also be analyzed directly:

```bash
actionlint .github/workflows/ci.yml
```

## Output

Actionlint reports:

- the affected file;
- the line and column;
- a description of the problem;
- the relevant workflow expression or YAML fragment.

A successful validation produces no output and returns a zero exit status.

## ShellCheck integration

When ShellCheck is installed, Actionlint can use it to analyze shell commands embedded in GitHub Actions steps.

Both tools are included in this setup through Homebrew.

This provides additional validation for steps such as:

```yaml
- name: Run checks
  run: |
    echo "$VALUE"
    ./scripts/check.sh
```

## Workflow availability

Actionlint is included in the curated environment even when a repository does not yet contain GitHub Actions workflows.

It should be integrated into `pre-commit` once workflow files are added to the repository.

Until then, validation can be run manually with:

```bash
actionlint
```

## Pre-commit integration

The future pre-commit hook should target files under:

```text
.github/workflows/
```

Homebrew manages the Actionlint executable, while `pre-commit` will control when validation is executed.

## Rollback

Remove Actionlint with:

```bash
brew uninstall actionlint
```

Then remove its entry from the root `Brewfile`.

Any related pre-commit hook must also be removed separately.
