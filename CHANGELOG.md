# Changelog

<!-- markdownlint-disable MD024 -->

All notable changes to this project are documented in this file.

The format is inspired by Keep a Changelog, and the project follows semantic versioning where applicable.

## Unreleased

## 1.0.0 - 2026-06-17

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

For the complete release criteria, see [version 1.0.0 release criteria](docs/releases/v1.0.0.md).

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
