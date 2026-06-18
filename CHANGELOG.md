# Changelog

<!-- markdownlint-disable MD024 -->

All notable changes to this project are documented in this file.

The format is inspired by Keep a Changelog, and the project follows semantic versioning where applicable.

## Unreleased

### Changed

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

For the complete release criteria, see [version 0.1.0 release criteria](docs/releases/v0.1.0.md).
