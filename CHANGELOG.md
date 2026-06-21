# Changelog

<!-- markdownlint-disable MD024 -->

All notable changes to this project are documented in this file.

The format is inspired by Keep a Changelog, and the project follows semantic versioning where applicable.

## Unreleased

### Added

- `mac doctor --summary` flag to collapse the undeclared Homebrew package list
  to a count, making the output usable in screenshots and narrow terminals.
- Screenshots for `bat`, `duf`, `dust`, `lsd`, `tokei`, and
  `mac doctor --fix --summary` illustrating tool behavior and diagnostic output
  directly in the docs.
- Visual assets roadmap (`docs/assets/ROADMAP.md`) tracking all planned and
  actioned screenshots across 12 phases with capture rules and a validation
  checklist.
- `lsd --tree scripts/` screenshot in the architecture documentation.

### Changed

- Merged `docs/containers/` (ctop, OrbStack) into `docs/docker/` so all
  container tooling lives in one place; updated the inbound links.
- Documented the existing `mac doctor --summary` and `mac vscode --with-optional`
  flags in the README so it matches the scripts.
- Removed a stray `</details>` tag from the README "What's included" section.
- Hardened the command-layer and setup scripts with `set -euo pipefail`
  (doctor, setup, uninstall, defaults, keyboard, vscode, brew, git, zsh, php)
  and guarded the previously unset `$CI` reference in `scripts/setup.sh`.
- Unified shell style across the CLI: every executable now uses
  `set -euo pipefail`, function-local variables are declared with `local`, and
  small nits (`--help|-h` spacing, `$HOME` paths, quoting) were normalized.
- Normalized documentation headings to sentence case (notably the `docs/php/`
  pages) and added the missing Rollback section to `docs/php/xdebug.md`.
- Restructured the SwiftBar `sites.5m.sh` plugin so its pure helpers are unit
  testable, and guarded its detail-array expansion under `set -u`.
- Expanded the Bats suite from 78 to 99 tests, adding coverage for the
  hardening guard, uninstall safety refusals, the SwiftBar helpers, `brew.sh`,
  `zsh.sh` backup/idempotency, and the logging stderr routing.
- Extracted `tests/test_helper.bash` (`make_stub_bin`, `write_stub`) and adopted
  it in the doctor, php, brew, and swiftbar tests, removing four divergent copies
  of the stub-PATH setup idiom.
- Inserted missing image references in `docs/git/git.md` (git-delta diff) and
  `docs/troubleshooting/troubleshooting.md` (`mac doctor` report and
  `mac doctor --fix --summary`).
- Fixed `.git/info/exclude` pattern from `ROADMAP.md` to `/ROADMAP.md` to
  prevent the local planning file from inadvertently excluding
  `docs/assets/ROADMAP.md`.
- Standardized all shell script shebangs from `#!/bin/bash` to
  `#!/usr/bin/env bash` for consistency and portability.

### Removed

- Removed the per-version release-criteria documents (`docs/releases/v0.1.0.md`,
  `docs/releases/v1.0.0.md`); the `CHANGELOG.md` is now the single source of
  truth for release history. The release workflow remains in
  `docs/releases/release-process.md`.

### Security

- `path_manager` now rejects directories containing shell metacharacters before
  writing the managed PATH block into the user's profile, closing a
  command-injection sink reachable through `MAC_DEV_SETUP_BIN_DIR`.
- `mac php xdebug enable`/`disable` back up an existing `99-xdebug.ini` before
  overwriting or removing it, preventing silent loss of a custom config.

## 1.7.0 - 2026-06-18

### Added

- Added SwiftBar to the full profile for shell-script-driven menu bar
  monitoring with documentation covering multi-site uptime scripts.
- Added Sentry documentation for Symfony projects covering bundle integration,
  release tracking, environment filtering, and exception ignore list.

## 1.6.0 - 2026-06-18

### Added

- Added Claude desktop app, Ollama, and Sublime Text to the full profile with
  inventory classification and focused documentation under `docs/ai/` and
  `docs/vscode/`.
- Added Codex CLI documentation covering installation, workflow, and comparison
  with Claude Code.
- Promoted codexbar from TOOLING to USED with expanded documentation.
- Excluded `claude.ai` from lychee link checking as it redirects to login.

## 1.5.0 - 2026-06-18

### Added

- Added Raycast, CleanShot X, Obsidian, Notion, and GIMP to the full profile
  Brewfile with inventory classification and focused documentation under
  `docs/productivity/`.

## 1.4.0 - 2026-06-18

### Added

- Added Bruno, Google Chrome, and Firefox to the full profile Brewfile with
  inventory classification and focused documentation under `docs/web/`.
- Added web service documentation for Excalidraw (web app and VS Code
  extension workflow), RealFaviconGenerator, remove.bg, and ImageMagick.

## 1.3.0 - 2026-06-18

### Added

- `mac php xdebug status|enable|disable` command to manage the Homebrew PHP
  Xdebug configuration while keeping it disabled by default.
- PHP/Symfony toolchain documentation covering the shared Homebrew runtime,
  Xdebug policy, and PHPStan project setup.
- PHP project-level guides for PCOV coverage, Pest, PHP-CS-Fixer, Rector, and
  Infection mutation testing.

## 1.2.0 - 2026-06-18

### Changed

- Made `mac doctor` profile-aware: it now runs `brew bundle check` against the
  active profile and reports which declared packages are missing.
- Added non-blocking Homebrew drift detection to `mac doctor` for installed
  packages not declared by any setup profile.
- Added managed Zsh configuration drift reporting to `mac doctor`.
- Added `mac doctor --fix` flag that prints reconciliation commands without
  executing them.
- Clarified `mac doctor` status output with explicit in-sync, drift, and
  missing markers.

## 1.1.0 - 2026-06-18

### Added

- BATS consistency check that fails when a Homebrew profile entry is missing
  from the inventory (`docs/homebrew/inventory.md`).

### Changed

- Added focused inventory documentation for Antidote, autojump, Ice, KeeWeb,
  libpq, lsd, Stats, and terminal-notifier.
- Expanded the Homebrew inventory so every profile package is represented.
- Updated the macOS CI Node setup action to `actions/setup-node@v6`.
- Skipped host-global Homebrew diagnostics on GitHub-hosted runners so CI only
  reports issues owned by the repository profiles.
- Replaced the deprecated Homebrew `tldr` formula with the maintained official
  `tlrc` client while keeping the `tldr` command available.
- Removed the deprecated `vial` cask from the full profile until Homebrew offers
  a trusted installation path again.

## 1.0.0 - 2026-06-18

### Added

- `mac` command-line interface with a modular, auto-discovered command
  architecture (setup, doctor, update, uninstall) and dynamic help built from a
  command registry.
- Official `install.sh` bootstrap that clones the repository, manages the `mac`
  symlink, and safely manages the shell PATH block.
- Self-update mechanism (`mac update`) using a temporary worktree and
  fast-forward-only updates with rollback.
- Full uninstall command (`mac uninstall`) with `--remove-config` and
  `--remove-install-dir`, removing only managed files that match the versioned
  copies (now covering all managed Zsh dotfiles).
- Setup profiles system (`full` and `minimal`) with profile-aware Brewfiles and
  dynamic profile validation.
- Generated Zsh completion for `mac`, built from the command registry and
  verified in CI.
- Structured logging helpers and unified error handling across the CLI.
- Opt-in `mac defaults`, `mac keyboard` and `mac vscode` commands wrapping the
  macOS defaults, keyboard layout and VS Code extension scripts.
- A bats test suite covering the libraries, CLI, update and install flows, run
  via `npm test` in CI.

### Changed

- Homebrew setup split into profile Brewfiles; the root `Brewfile` is now a
  compatibility symlink to `profiles/full/Brewfile`.
- Git configuration relies solely on the managed `include.path`, with no direct
  writes to the global config.
- macOS CI consolidated into a single gate, and commits are linted with
  commitlint across the pull request range.
- Shell scripts are linted with shellcheck in CI.
- VS Code extensions are no longer declared in the Brewfile (which made the
  macOS CI depend on the flaky extension marketplace); install them with
  `mac vscode`, the single source of truth being the configs/vscode lists.
- `mac setup` writes its log to a user-level location instead of the current
  working directory.
- Releases are performed manually following the documented process; the
  unreliable release-please workflow was removed.

### Fixed

- `mac setup --help` and `mac doctor --help` print usage instead of failing or
  silently running diagnostics.
- `mac doctor` exits non-zero when a required tool is missing.
- Setup no longer regenerates the versioned completion file, no longer fails
  when completion is not yet active in the current shell, and reports a reliable
  exit status.

## 0.4.1 - 2026-06-17

### Added

- macOS bootstrap system with split Brewfiles and validation scripts.
- Fast, optimized CI pipeline.
- Standardized gitmoji commit conventions with commitlint and husky.

### Fixed

- Stabilized the Homebrew install flow and hardening order in CI.

## 0.2.0 - 2026-06-17

### Added

- Global setup script for selective or complete environment installation.
- French OSS keyboard layout configuration and installation script.
- Reproducible macOS development defaults.
- Versioned Warp terminal configuration.
- Advanced Git workflow configuration.
- SSH configuration example and documentation.
- Visual Studio Code configuration, extension lists, and installation script.
- Repository-wide GitHub Actions quality workflow.
- Local CI validation with Act.
- CI status badge in the README.
- Dependabot configuration for GitHub Actions dependencies.
- Pull request and issue templates.
- Security policy.
- Contribution guidelines.
- Continuous integration documentation.

### Changed

- Visual Studio Code is now managed through Homebrew Cask.
- README documentation links were reorganized by functional category.
- The version 0.1.0 release checklist was updated after publication.
- Repository quality validation is centralized through `pre-commit`.

### Fixed

- Replaced an unstable Tree project link with its maintained repository URL.

### Security

- Added private vulnerability reporting guidance.
- Added automated secret detection and repository security checks to CI.

## 0.1.0 - 2026-06-16

### Added

- Initial documented and reproducible macOS development environment.
- Homebrew package and application management through the root `Brewfile`.
- Zsh configuration with Antidote and Powerlevel10k.
- Git and Git Delta configuration.
- Pre-commit validation with Gitleaks.
- Markdown, link, EditorConfig, shell, Dockerfile, and GitHub Actions validation tools.
- OrbStack container runtime documentation.
- Curated command-line utilities and macOS applications.
- Installation, verification, maintenance, and rollback documentation.
- Apple Silicon support with best-effort Intel compatibility.
- Initial GitHub Actions workflow and local Act support.
