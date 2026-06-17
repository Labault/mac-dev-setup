# Visual Studio Code

Visual Studio Code is installed and managed through Homebrew Cask.

## Installation

Install Visual Studio Code with Homebrew:

~~~bash
brew install --cask visual-studio-code
~~~

Verify the installation:

~~~bash
brew list --cask | grep -x visual-studio-code

test -d "/Applications/Visual Studio Code.app" \
  && echo "Visual Studio Code application found."

code --version
~~~

The `code` command must be available in the shell.

## Configuration

The shared VS Code settings are stored in:

~~~text
configs/vscode/settings.json
~~~

They contain only generic and reusable preferences. Personal themes, account-dependent extensions, project-specific paths, and local container names are intentionally excluded.

## Recommended extensions

Recommended extensions are listed in:

~~~text
configs/vscode/extensions.txt
~~~

They cover the main PHP and Symfony development workflow:

- PHP language support with Intelephense
- path autocompletion
- Git history and annotations
- GitHub Actions support
- PHP namespace imports
- PHPStan integration
- Twig support
- Xdebug integration
- DotEnv syntax support
- YAML validation and completion

Install them with the CLI:

~~~bash
mac vscode
~~~

Or run the script directly:

~~~bash
./scripts/install-vscode-extensions.sh
~~~

The command is idempotent and skips extensions that are already installed.

## Optional extensions

Optional extensions are listed separately in:

~~~text
configs/vscode/extensions-optional.txt
~~~

They include personal, visual, AI-assisted, and specialized workflow extensions.

Install both recommended and optional extensions with:

~~~bash
mac vscode --with-optional
~~~

Or run the script directly:

~~~bash
./scripts/install-vscode-extensions.sh --with-optional
~~~

## Project-specific settings

Settings tied to a single project must not be stored in the global VS Code user configuration.

Examples include:

- Docker container names
- PHPUnit commands
- PHPStan binary paths
- project-specific formatter rules
- workspace folder mappings
- Symfony console paths

These settings should instead be stored in the relevant project's `.vscode/settings.json` file when appropriate.

## Validation

Validate the shared settings:

~~~bash
python3 -m json.tool configs/vscode/settings.json >/dev/null
~~~

Validate the installation script:

~~~bash
shellcheck scripts/install-vscode-extensions.sh
~~~

Test the extension installation:

~~~bash
./scripts/install-vscode-extensions.sh
./scripts/install-vscode-extensions.sh --with-optional
~~~

## Rollback

Uninstall Visual Studio Code managed by Homebrew:

~~~bash
brew uninstall --cask visual-studio-code
~~~

The VS Code user configuration is stored separately under:

~~~text
~/Library/Application Support/Code/User
~~~

Uninstalling the application does not automatically remove these user settings.

To remove one extension:

~~~bash
code --uninstall-extension publisher.extension
~~~

To remove a shared configuration file from this repository, delete it and restore the previous version through Git.
