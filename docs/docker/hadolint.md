# Hadolint

Hadolint analyzes Dockerfiles and reports common mistakes, unsafe patterns, portability issues, and maintainability problems.

It combines Dockerfile-specific rules with ShellCheck analysis for shell commands used inside `RUN` instructions.

## Installation

Hadolint is installed through Homebrew:

```bash
brew install hadolint
```

It is also declared in `profiles/full/Brewfile`:

```bash
brew bundle install --file=Brewfile
```

## Verify the installation

Check that Hadolint is available:

```bash
hadolint --version
```

## Analyze a Dockerfile

Run Hadolint against a Dockerfile with:

```bash
hadolint Dockerfile
```

A Dockerfile with a different name can also be analyzed:

```bash
hadolint path/to/Dockerfile.dev
```

To analyze all Dockerfiles tracked by Git:

```bash
git ls-files -z \
  | grep -zE '(^|/)(Dockerfile|Dockerfile\.[^/]+)$' \
  | xargs -0 -r hadolint
```

## Findings

Hadolint findings include a rule identifier such as `DL3008` or `SC2086`.

The `DL` prefix identifies Dockerfile-specific rules.

The `SC` prefix identifies ShellCheck rules applied to shell commands inside Dockerfile instructions.

Warnings should normally be corrected instead of ignored.

## Targeted exclusions

A specific rule can be ignored for the following instruction:

```dockerfile
# hadolint ignore=DL3008
RUN apt-get update && apt-get install -y curl
```

Exclusions should remain narrow and should only be added when the rule is not appropriate for the specific case.

Global exclusions should be avoided because they can hide future problems.

## Configuration

Hadolint can be configured with a `.hadolint.yaml` file at the repository root.

A configuration file should only be added when the project has concrete requirements that cannot be handled cleanly through the default rules.

The default configuration is preferred until such requirements appear.

## Pre-commit integration

Hadolint should eventually be integrated into `pre-commit` when Dockerfiles are present in the repository.

Homebrew manages the executable, while `pre-commit` will define which Dockerfiles are analyzed and when the checks run.

Until then, validation can be executed manually with:

```bash
hadolint Dockerfile
```

## Rollback

Remove Hadolint with:

```bash
brew uninstall hadolint
```

Then remove its entry from `profiles/full/Brewfile`.

Any related pre-commit hook or Hadolint configuration must also be removed separately.
