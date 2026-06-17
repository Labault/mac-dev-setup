# MacDevSetup

Production-ready macOS development setup managed through a small `mac` CLI.

MacDevSetup installs a curated Homebrew environment, applies Git and Zsh
configuration, and provides repeatable commands for setup, diagnostics, updates,
and uninstalling.

## Requirements

- macOS
- Git
- Internet access
- Permission to install Homebrew packages and macOS applications

The installer creates a checkout at `~/.mac-dev-setup` and installs the `mac`
command in `~/.local/bin`.

## Install

Run the installer:

```bash
curl -fsSL https://raw.githubusercontent.com/labault/mac-dev-setup/main/install.sh | bash
```

Restart your shell if `mac` is not available immediately, then confirm the CLI is
installed:

```bash
mac help
```

## Set Up Your Mac

Install the default development environment:

```bash
mac setup
```

The default profile is `full`. To choose a profile explicitly:

```bash
mac setup --profile full
mac setup --profile minimal
```

Preview a setup command without changing your system:

```bash
mac setup --profile minimal --dry-run
```

During setup, MacDevSetup:

- installs Homebrew if it is missing;
- installs packages from the selected profile;
- configures Git through a managed global include;
- applies the included Zsh configuration and completion files.

## Profiles

`minimal` installs the core command-line environment for shell, Git, and project
maintenance.

`full` installs everything in the curated developer environment, including
language tooling, quality tools, GUI applications, VS Code extensions, and
container/database utilities.

## CLI Usage

List available commands:

```bash
mac help
```

Install or reapply the development environment:

```bash
mac setup [--profile full|minimal] [--dry-run]
```

Run diagnostics:

```bash
mac doctor
```

Update MacDevSetup:

```bash
mac update
mac update --dry-run
```

Uninstall the CLI and managed PATH entry:

```bash
mac uninstall
```

Preview uninstall actions:

```bash
mac uninstall --dry-run
```

Remove safely managed configuration too:

```bash
mac uninstall --remove-config
```

Remove the installed checkout when it matches `~/.mac-dev-setup`:

```bash
mac uninstall --remove-install-dir
```

## Managed Files

MacDevSetup may manage these user-level files:

- `~/.zprofile`
- `~/.zshrc`
- `~/.zsh_plugins.txt`
- `~/.p10k.zsh`
- `~/.shell/alias.sh`
- `~/.zsh/completions/_mac`
- global Git `include.path`

Review or back up existing shell files before running `mac setup` if you already
maintain custom Zsh configuration.

## Documentation

Detailed tool documentation is available in [`docs`](docs). Start with:

- [`docs/setup/setup.md`](docs/setup/setup.md)
- [`docs/troubleshooting/troubleshooting.md`](docs/troubleshooting/troubleshooting.md)
- [`docs/homebrew/homebrew.md`](docs/homebrew/homebrew.md)
- [`docs/zsh/zsh.md`](docs/zsh/zsh.md)
- [`docs/git/git.md`](docs/git/git.md)

## License

MacDevSetup is released under the MIT License. See [`LICENSE`](LICENSE) for details.
