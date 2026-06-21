# Release process

This document describes the release workflow for MacDevSetup.

The project uses semantic versioning where applicable and maintains notable changes in the root `CHANGELOG.md` file.

Releases are performed **manually** by following the steps below. There is no
automated release bot: the repository's gitmoji-first commit convention does not
map cleanly onto conventional-commit release automation, so the changelog,
version bump, tag, and GitHub release are prepared by a maintainer.

## Release preparation

Before starting a release:

- ensure the working tree is clean;
- pull the latest changes from `main`;
- confirm that the `Unreleased` section of `CHANGELOG.md` is accurate;
- verify that accepted tools, applications, configurations, and documentation are committed;
- confirm that rejected tools are not included;
- review compatibility notes and known limitations.

Run:

```bash
git switch main
git pull --ff-only
git status --short
```

The working tree should be clean before continuing.

## Choose the version number

Select the next version according to the scope of the release:

- patch: backward-compatible fixes and documentation corrections;
- minor: new backward-compatible tools, configurations, or workflows;
- major: incompatible changes to the documented setup or repository structure.

Examples:

```text
0.1.0 -> 0.1.1
0.1.0 -> 0.2.0
0.1.0 -> 1.0.0
```

Pre-1.0 releases may still contain significant changes. The selected version should clearly communicate the expected impact.

## Prepare the changelog

Move the relevant entries from `Unreleased` into a new version section.

Use this structure:

```markdown
## Unreleased

## X.Y.Z - YYYY-MM-DD

### Added

- Describe newly introduced features.

### Changed

- Describe changes to existing behavior.

### Fixed

- Describe resolved problems.

### Security

- Describe security-related improvements.
```

Remove empty categories when they are not needed.

Keep an empty `Unreleased` section at the top for future work.

## Add release criteria

Create a release criteria document when the release introduces a substantial milestone:

```text
docs/releases/vX.Y.Z.md
```

The document should cover the areas relevant to the release, such as:

- repository quality;
- package management;
- shell environment;
- GitHub Actions;
- documentation;
- compatibility;
- release publication.

Small patch releases may rely on the changelog and validation workflow without requiring a dedicated checklist.

## Validate the repository

Run the complete repository validation:

```bash
pre-commit run --all-files
```

Verify the Homebrew environment when the `Brewfile` changed:

```bash
brew bundle check --file=Brewfile
```

Validate shell configuration when shell files changed:

```bash
zsh -ic 'echo "Zsh configuration loaded successfully"'
```

Validate the GitHub Actions workflow locally when workflow or CI dependencies changed:

```bash
act pull_request \
  --job quality \
  --container-architecture linux/amd64 \
  -P ubuntu-latest=catthehacker/ubuntu:act-latest \
  --pull=false
```

Local Act validation does not replace the real GitHub Actions run.

## Review the release changes

Review all changes that will be included:

```bash
git status --short
git diff
git log --oneline <previous-tag>..HEAD
```

Confirm that:

- no secrets or personal information are present;
- documentation links are valid;
- version numbers and dates are correct;
- installation and rollback instructions remain accurate;
- the changelog reflects the actual commits;
- no generated or temporary files are staged.

## Commit the release preparation

Stage only the intended release files:

```bash
git add CHANGELOG.md docs/releases/
git diff --cached
```

Commit using the repository conventions:

```bash
git commit -m "🚀 chore: prepare version X.Y.Z"
```

Push the release preparation commit:

```bash
git push origin main
```

## Verify GitHub Actions

Wait for the main CI workflow to complete successfully.

Run:

```bash
gh run list \
  --workflow CI \
  --limit 3
```

Inspect a failed run before publishing the release:

```bash
gh run view <run-id> --log-failed
```

Do not create the release tag while the required workflow is failing.

## Create and push the tag

Create an annotated tag from the validated release commit:

```bash
git tag -a vX.Y.Z -m "Release vX.Y.Z"
git push origin vX.Y.Z
```

Verify the tag:

```bash
git show vX.Y.Z --stat
git ls-remote --tags origin vX.Y.Z
```

Tags should not normally be moved or replaced after publication.

## Create the GitHub release

Create the release from the pushed tag:

```bash
gh release create vX.Y.Z \
  --title "vX.Y.Z" \
  --notes-from-tag
```

Release notes may instead be written manually from the corresponding changelog section.

Verify the published release:

```bash
gh release view vX.Y.Z
```

## Post-release verification

After publication:

- verify that the GitHub release points to the correct tag;
- verify that the tag points to the intended commit;
- confirm that CI remains green;
- confirm that changelog and release documentation links work;
- test important installation or setup instructions when practical;
- ensure the working tree is clean.

Run:

```bash
git status --short
git describe --tags --exact-match
gh release view vX.Y.Z
```

## Start the next development cycle

Keep the `Unreleased` section available for the next changes.

When necessary, add an initial placeholder:

```markdown
## Unreleased
```

Commit any post-release changelog preparation separately.

## Correcting a failed release

If a release has not yet been published, fix the issue normally and repeat validation.

If a tag was pushed but no GitHub release was published, prefer creating a new corrected version rather than moving a public tag.

If an incorrect GitHub release was published:

1. document the problem;
2. prepare and validate the correction;
3. publish a new patch version;
4. mark the incorrect release as superseded when appropriate.

Avoid deleting or rewriting published release history unless the release exposes sensitive information.

## Emergency security correction

For a security-sensitive release:

- avoid publishing exploit details before a fix is available;
- follow the repository security policy;
- validate that secrets and sensitive logs are removed;
- publish the corrected version promptly;
- document only the information appropriate for public disclosure.

See the root [security policy](../../SECURITY.md) for reporting guidance.

---

[← Docs index](../README.md) · [Project README](../../README.md)
