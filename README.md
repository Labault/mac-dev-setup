# Mac Dev Setup

A curated and evolving macOS development environment built one decision at a time.

This repository documents the tools, configurations, workflows, and practical tips that I personally use and validate on my Mac. It is not intended to be an exhaustive list of recommended software or an automated copy of my current machine.

Every component is reviewed, tested, and understood before becoming part of the documented setup. New tools and alternative configurations may be explored over time, but they remain experimental until they have been manually validated.

> [!WARNING]
> This project is under active development. The repository will grow progressively as each configuration is tested and accepted.

## Compatibility

This setup is developed and manually validated on an Apple Silicon Mac.

Apple Silicon is the primary supported architecture for version 0.1.0. Homebrew is expected under `/opt/homebrew`, and the documented configurations have been tested in that environment.

Intel-based Macs are supported on a best-effort basis. Some configurations include fallbacks for the Intel Homebrew prefix `/usr/local`, but the complete setup has not been manually validated on Intel hardware.

Other operating systems, including Linux and Windows, are outside the scope of this repository. GitHub Actions may use Linux runners for repository validation, but the documented local development environment targets macOS.

## Available documentation

### Package management and macOS

* [Homebrew setup, packages, maintenance, and rollback](docs/homebrew/homebrew.md)
* [Pearcleaner macOS application uninstaller](docs/macos/pearcleaner.md)
* [macOS development defaults](docs/macos/macos-defaults.md)
* [French OSS keyboard layout](docs/keyboard/french-oss.md)

### Shell

* [Powerlevel10k setup and rollback](docs/zsh/powerlevel10k.md)
* [ShellCheck shell script analysis](docs/shell/shellcheck.md)
* [Zsh setup, plugins, testing, and rollback](docs/zsh/zsh.md)

### Git, quality, and security

* [editorconfig-checker repository formatting validation](docs/quality/editorconfig-checker.md)
* [Git workflow configuration](docs/git/git.md)
* [Git Delta readable Git diffs](docs/git/git-delta.md)
* [Gitleaks secret detection and repository scanning](docs/security/gitleaks.md)
* [lychee documentation link validation](docs/quality/lychee.md)
* [markdownlint-cli2 Markdown validation](docs/quality/markdownlint-cli2.md)
* [Pre-commit and Gitleaks](docs/pre-commit/pre-commit.md)

### GitHub Actions

* [Actionlint GitHub Actions workflow validation](docs/github-actions/actionlint.md)
* [Act local GitHub Actions execution](docs/github-actions/act.md)

### Containers and Docker

* [ctop container monitoring dashboard](docs/containers/ctop.md)
* [Hadolint Dockerfile analysis](docs/docker/hadolint.md)
* [OrbStack local containers and Linux virtualization](docs/containers/orbstack.md)

### Command-line utilities

* [bat syntax-aware file viewer](docs/cli/bat.md)
* [duf filesystem usage viewer](docs/cli/duf.md)
* [dust disk usage analyzer](docs/cli/dust.md)
* [tokei source code statistics](docs/cli/tokei.md)
* [tree directory structure viewer](docs/cli/tree.md)

### Remote access

* [SSH keys, macOS Keychain, and GitHub authentication](docs/ssh/ssh.md)

### Editors

* [Visual Studio Code setup and extensions](docs/vscode/vscode.md)
* [Warp terminal setup and configuration](docs/warp/warp.md)

### Database

* [Beekeeper Studio database client](docs/database/beekeeper-studio.md)
