# Contributing

Thank you for considering a contribution to MacDevSetup.

This repository is curated rather than exhaustive. New tools, configurations, and workflows are reviewed individually and should be tested, understood, and documented before being accepted.

## Before opening an issue

Search the existing documentation and issues first.

Use:

- the bug report form for reproducible problems;
- the feature request form for new tools, configurations, workflows, or documentation improvements;
- the security policy for vulnerabilities.

Do not include secrets, private keys, access tokens, personal data, or unredacted machine-specific information.

## Proposing a new tool

A useful proposal should explain:

- the problem the tool solves;
- why it fits a macOS development environment;
- comparable alternatives;
- installation and removal methods;
- compatibility with Apple Silicon;
- known Intel limitations;
- whether configuration should be versioned;
- how the tool can be tested;
- any security, privacy, or maintenance concerns.

A tool is not accepted solely because it is popular.

## Development workflow

Create a dedicated branch from `main`:

```bash
git switch main
git pull --ff-only
git switch -c <type>/<short-description>
```

Keep changes focused and avoid combining unrelated work.

## Validation

Before opening a pull request, run the test suite and the quality hooks:

```bash
npm test                  # Bats test suite
pre-commit run --all-files
```

When GitHub Actions workflows are modified, also lint every workflow file:

```bash
actionlint .github/workflows/*.yml
```

The repository quality job can be tested locally with Act:

```bash
act pull_request \
  --job quality \
  --container-architecture linux/amd64 \
  -P ubuntu-latest=catthehacker/ubuntu:act-latest \
  --pull=false
```

A successful local Act run does not replace validation on GitHub Actions.

## Documentation

Update documentation whenever behavior, installation, rollback, compatibility, or maintenance instructions change.

Documentation should:

- use clear and direct language;
- avoid personal paths and machine-specific values;
- include verification steps;
- include rollback instructions when relevant;
- document unsupported or untested environments;
- use relative links for repository files.

## Commits

Use Conventional Commits with a relevant Gitmoji.

Examples:

```text
✨ feat: add a new developer tool
📝 docs: document installation and rollback
🐛 fix: correct a broken setup command
🔧 chore: update repository configuration
👷 ci: improve repository quality checks
🔒️ fix(security): harden secret detection
```

Prefer small, atomic commits with one clear purpose. See
[docs/git/gitmoji.md](docs/git/gitmoji.md) for the full format, the emoji
reference, and how the `commit-msg` hook enforces it.

## Pull requests

Pull requests should include:

- a concise summary;
- the motivation for the change;
- the main files changed;
- validation commands executed;
- compatibility notes;
- limitations or rollback information;
- screenshots or logs when useful.

The pull request template provides the expected checklist.

## Releases

Releases are cut manually by the maintainer. The full workflow — version
choice, changelog preparation, tagging, and the GitHub release — is documented
in [docs/releases/release-process.md](docs/releases/release-process.md). The
root [`CHANGELOG.md`](CHANGELOG.md) is the canonical record of notable changes;
keep its `Unreleased` section up to date as part of your change.

## Compatibility

Apple Silicon is the primary supported architecture.

Intel compatibility should be considered where relevant, but may remain best effort when it cannot be tested directly.

Linux and Windows are outside the scope of the documented local development environment, even when Linux runners are used for repository validation.

## Security and privacy

Never commit:

- credentials;
- private keys;
- access tokens;
- production secrets;
- unredacted environment files;
- personal home directory paths;
- local machine identifiers;
- private repository URLs.

Review staged changes before every commit:

```bash
git diff --cached
```

## Review process

A contribution may be:

- accepted;
- accepted with changes;
- kept optional;
- rejected when it does not fit the project scope.

Rejection does not necessarily mean that a tool or idea is poor. It may simply not match the curated setup maintained by this repository.
