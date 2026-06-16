# Global setup script

The repository provides a single entry point for applying the supported setup steps:

~~~text
scripts/setup.sh
~~~

The script coordinates the existing installation and configuration scripts without replacing their individual documentation.

## Usage

Display the available options:

~~~bash
./scripts/setup.sh --help
~~~

Run every supported step:

~~~bash
./scripts/setup.sh --all
~~~

Run only selected steps:

~~~bash
./scripts/setup.sh --homebrew
./scripts/setup.sh --vscode
./scripts/setup.sh --keyboard
./scripts/setup.sh --macos
./scripts/setup.sh --warp
~~~

Several options can be combined:

~~~bash
./scripts/setup.sh --homebrew --vscode --warp
~~~

## Supported steps

### Homebrew

~~~bash
./scripts/setup.sh --homebrew
~~~

Installs the dependencies declared in the repository `Brewfile`.

### Visual Studio Code

~~~bash
./scripts/setup.sh --vscode
~~~

Installs the recommended VS Code extensions listed in:

~~~text
configs/vscode/extensions.txt
~~~

Optional extensions remain excluded from the global setup.

### French OSS keyboard layout

~~~bash
./scripts/setup.sh --keyboard
~~~

Installs the versioned French OSS keyboard layout bundle.

An existing installation is backed up before replacement.

A logout and login are still required before macOS reloads the layout.

### macOS defaults

~~~bash
./scripts/setup.sh --macos
~~~

Applies the curated Finder, Dock, screenshot, keyboard, and text-substitution preferences.

### Warp

~~~bash
./scripts/setup.sh --warp
~~~

Copies the versioned Warp configuration to:

~~~text
~/.warp/settings.toml
~~~

An existing configuration is backed up first under:

~~~text
~/Documents/Backups/warp
~~~

Warp should be restarted after applying the configuration.

## SSH exclusion

SSH is intentionally excluded from the global setup script.

Automatically replacing `~/.ssh/config` could overwrite personal hosts, identities, proxy settings, or server-specific configuration.

The SSH example must therefore be reviewed and installed manually.

## Validation

Validate the script with ShellCheck:

~~~bash
shellcheck scripts/setup.sh
~~~

Display its help output:

~~~bash
./scripts/setup.sh --help
~~~

Test an idempotent step:

~~~bash
./scripts/setup.sh --vscode
~~~

## Rollback

The global script does not provide one universal rollback command.

Each setup area keeps its own rollback procedure in the relevant documentation:

- Homebrew;
- Visual Studio Code;
- Warp;
- macOS defaults;
- French OSS keyboard layout.

Review the corresponding documentation before restoring or removing a configuration.
