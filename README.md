# MacDevSetup

Set up a brand-new Mac for development with **one command**, then manage
everything afterwards through a small CLI called `mac`.

It installs a curated set of developer tools (via Homebrew), configures Git and
Zsh for you, and gives you repeatable commands to set up, check, update, and
remove that environment.

> **New here? Read this file top to bottom once.** It is the whole manual: how
> to install it, what gets installed and why, and every command you can run.

---

## How it works in 30 seconds

1. You run the installer (one line).
2. It downloads this project to `~/.mac-dev-setup` and adds a `mac` command to
    `~/.local/bin`.
3. You run `mac setup` — it installs the tools and applies the configuration.
4. From then on, `mac doctor`, `mac update`, and the other commands keep your
    machine in shape.

Nothing is hidden: every tool that gets installed is listed in a plain-text
[`Brewfile`](Brewfile), and every command lives in [`scripts/`](scripts).

---

## Requirements

- macOS
- Git
- An internet connection
- Permission to install Homebrew packages and macOS apps

---

## Install

Run this in your terminal:

```bash
curl -fsSL https://raw.githubusercontent.com/labault/mac-dev-setup/main/install.sh | bash
```

Then restart your shell (or open a new terminal tab) and confirm it worked:

```bash
mac help
```

If `mac` is not found, your shell just hasn't reloaded yet — open a new tab.

---

## Your first setup

Install the full development environment:

```bash
mac setup
```

Want to see what it *would* do without touching your machine? Add `--dry-run`:

```bash
mac setup --dry-run
```

`mac setup` does four things:

1. installs Homebrew if it is missing;
2. installs every package from the selected profile;
3. configures Git through a managed global include;
4. installs the Zsh configuration and shell completion.

---

## Profiles: minimal vs full

A **profile** decides *which* tools get installed. Pick one with `--profile`:

```bash
mac setup --profile minimal   # the essentials only
mac setup --profile full      # everything (this is the default)
```

| Profile | For whom | What you get |
| --- | --- | --- |
| `minimal` | A lightweight shell + Git workflow | Core CLI tools, Git helpers, `gh`, `node`, `pre-commit` |
| `full` | A complete dev workstation (default) | Everything in `minimal` **plus** language tooling (PHP, Symfony, `uv`), CI/quality linters, GUI apps, and container/database tools |

The exact lists live in
[`profiles/minimal/Brewfile`](profiles/minimal/Brewfile) and
[`profiles/full/Brewfile`](profiles/full/Brewfile). The root
[`Brewfile`](Brewfile) is a link to the full profile.

---

## The `mac` CLI

This is the full command reference. Every command also accepts `--help`.

| Command | What it does | Options |
| --- | --- | --- |
| `mac help` | List all available commands | — |
| `mac setup` | Install / reapply the environment | `--profile minimal\|full`, `--dry-run` |
| `mac doctor` | Check your machine and profile packages | `--profile minimal\|full`, `--fix` |
| `mac update` | Update MacDevSetup to the latest version | `--dry-run` |
| `mac uninstall` | Remove the CLI and its managed entries | `--remove-config`, `--remove-install-dir`, `--dry-run` |
| `mac defaults` | Apply curated macOS Finder/Dock/keyboard defaults | `--help` |
| `mac keyboard` | Install the *Français OSS Mac* keyboard layout | `--help` |
| `mac vscode` | Install the curated VS Code extensions | `--with-optional` |

### Everyday examples

```bash
# Did something break? Find out what is missing.
mac doctor

# Check a specific Homebrew profile.
mac doctor --profile minimal

# Print reconciliation commands without running them.
mac doctor --fix

# Pull the latest version of MacDevSetup.
mac update

# Preview an update without changing anything.
mac update --dry-run

# Install VS Code extensions, including the optional ones.
mac vscode --with-optional
```

### Opt-in commands

`mac setup` does **not** run these automatically — they change system or app
settings, so you run them yourself when you want them:

```bash
mac defaults   # macOS Finder/Dock/keyboard tweaks
mac keyboard   # the Français OSS Mac keyboard layout
mac vscode     # the curated VS Code extensions
```

### Removing everything

```bash
mac uninstall                       # remove the CLI + managed PATH entry
mac uninstall --dry-run             # preview what would be removed
mac uninstall --remove-config       # also remove safely managed config files
mac uninstall --remove-install-dir  # also remove ~/.mac-dev-setup
```

---

## What gets installed

Below is what each tool is for and where to learn more. Don't know a command?
Two beginner-friendly habits work for *any* tool here:

```bash
tldr <tool>        # short, example-first cheatsheet
brew info <tool>   # description, homepage, and version
```

### Command-line tools

| Tool | What it's for | Learn more |
| --- | --- | --- |
| `bat` | `cat` with syntax highlighting and Git integration | [docs/cli/bat.md](docs/cli/bat.md) |
| `lsd` | `ls` with colors, icons, and a tree view | [docs/cli/lsd.md](docs/cli/lsd.md) |
| `tree` | Show a folder as a tree | [docs/cli/tree.md](docs/cli/tree.md) |
| `duf` | A friendlier `df` (disk usage / free space) | [docs/cli/duf.md](docs/cli/duf.md) |
| `dust` | A friendlier `du` (what's taking up space) | [docs/cli/dust.md](docs/cli/dust.md) |
| `tokei` | Count lines of code, fast *(full)* | [docs/cli/tokei.md](docs/cli/tokei.md) |
| `tlrc` | Maintained client for short, example-first `tldr` pages | `tldr tldr` |
| `autojump` | Jump to frequent directories with `j` *(full)* | [docs/cli/autojump.md](docs/cli/autojump.md) |
| `ctop` | Live container metrics, top-style *(full)* | [docs/containers/ctop.md](docs/containers/ctop.md) |
| `glances` | System monitor *(full)* | `tldr glances` |
| `swaks` | Test SMTP / send test emails *(full)* | [docs/email/swaks.md](docs/email/swaks.md) |
| `terminal-notifier` | Send macOS notifications from scripts *(full)* | [docs/macos/terminal-notifier.md](docs/macos/terminal-notifier.md) |
| `antidote` | Zsh plugin manager | [docs/zsh/antidote.md](docs/zsh/antidote.md) |

### Git & security

| Tool | What it's for | Learn more |
| --- | --- | --- |
| `git-delta` | Beautiful, readable Git diffs | [docs/git/git-delta.md](docs/git/git-delta.md) |
| `gh` | GitHub from the terminal (PRs, issues, repos) | `gh --help` |
| `gitleaks` | Scan repos for leaked secrets | [docs/security/gitleaks.md](docs/security/gitleaks.md) |

### Languages & package managers

| Tool | What it's for | Learn more |
| --- | --- | --- |
| `node` | JavaScript runtime + `npm` | [nodejs.org/docs](https://nodejs.org/en/docs) |
| `php` | PHP runtime *(full)* | `brew info php` |
| `composer` | PHP dependency manager *(full)* | `brew info composer` |
| `symfony-cli` | Manage Symfony projects *(full)* | `symfony help` |
| `libpq` | PostgreSQL client libraries *(full)* | [docs/database/libpq.md](docs/database/libpq.md) |
| `uv` | Fast Python package installer *(full)* | [docs/python/uv.md](docs/python/uv.md) |

### Quality, CI & containers *(full profile)*

| Tool | What it's for | Learn more |
| --- | --- | --- |
| `pre-commit` | Run checks automatically before each commit | [docs/pre-commit/pre-commit.md](docs/pre-commit/pre-commit.md) |
| `shellcheck` | Lint shell scripts | [docs/shell/shellcheck.md](docs/shell/shellcheck.md) |
| `actionlint` | Lint GitHub Actions workflows | [docs/github-actions/actionlint.md](docs/github-actions/actionlint.md) |
| `act` | Run GitHub Actions locally | [docs/github-actions/act.md](docs/github-actions/act.md) |
| `hadolint` | Lint Dockerfiles | [docs/docker/hadolint.md](docs/docker/hadolint.md) |
| `markdownlint-cli2` | Lint Markdown files | [docs/quality/markdownlint-cli2.md](docs/quality/markdownlint-cli2.md) |
| `editorconfig-checker` | Enforce `.editorconfig` rules | [docs/quality/editorconfig-checker.md](docs/quality/editorconfig-checker.md) |
| `lychee` | Check for broken links | [docs/quality/lychee.md](docs/quality/lychee.md) |

### GUI apps *(full profile)*

| App | What it's for | Learn more |
| --- | --- | --- |
| Visual Studio Code | Code editor | [docs/vscode/vscode.md](docs/vscode/vscode.md) |
| Warp | Modern terminal | [docs/warp/warp.md](docs/warp/warp.md) |
| OrbStack | Fast Docker Desktop replacement | [docs/containers/orbstack.md](docs/containers/orbstack.md) |
| Beekeeper Studio | SQL editor / database manager | [docs/database/beekeeper-studio.md](docs/database/beekeeper-studio.md) |
| Pearcleaner | Cleanly uninstall apps | [docs/macos/pearcleaner.md](docs/macos/pearcleaner.md) |
| Stats / Ice | Menu-bar system monitor / manager | [docs/macos/stats.md](docs/macos/stats.md), [docs/macos/ice.md](docs/macos/ice.md) |
| KeeWeb | KeePass-compatible password manager | [docs/security/keeweb.md](docs/security/keeweb.md) |
| Ukelele | Keyboard layout editor | [docs/keyboard/ukelele.md](docs/keyboard/ukelele.md) |
| claude-monitor | Claude usage monitoring tool | [docs/ai/claude-monitor.md](docs/ai/claude-monitor.md) |

The complete, always-up-to-date inventory lives in
[docs/homebrew/inventory.md](docs/homebrew/inventory.md).

---

## Files MacDevSetup manages

To configure your shell and Git, these user-level files may be created or
updated:

- `~/.zprofile`, `~/.zshrc`, `~/.zsh_plugins.txt`, `~/.p10k.zsh`
- `~/.shell/alias.sh`
- `~/.zsh/completions/_mac`
- a global Git `include.path`

Your existing shell files are **backed up before replacement** when they differ
from the versioned ones. Backups go to
`~/Documents/Backups/mac-dev-setup/zsh`.

---

## Where to go next

Full documentation lives in [`docs/`](docs). Good starting points:

- [Setup walkthrough](docs/setup/setup.md)
- [How the CLI is built](docs/architecture/current-architecture.md)
- [Troubleshooting](docs/troubleshooting/troubleshooting.md)
- [Homebrew & the package inventory](docs/homebrew/homebrew.md)
- [Zsh configuration](docs/zsh/zsh.md)
- [Git configuration](docs/git/git.md)

---

## License

MacDevSetup is released under the MIT License. See [`LICENSE`](LICENSE) for
details.
