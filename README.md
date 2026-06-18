# MacDevSetup

Set up a brand-new Mac for development with **one command**, then manage
everything afterwards through a small CLI called `mac`.

> **New here? Read this file top to bottom once.** It covers what's included,
> how to install everything, and every command you can run afterwards.

---

## What's included

Everything is documented. Click any link below to open the dedicated page for
a tool, which covers installation, configuration, and how to remove it.

Two quick habits work for *any* tool listed here:

```bash
tldr <tool>        # short, example-first cheatsheet (works offline)
brew info <tool>   # description, version, and homepage
```

### Shell & command-line tools

These run in the terminal. They replace or improve the macOS built-in commands.

| Tool | What it does | Documentation |
| --- | --- | --- |
| `bat` | `cat` with syntax highlighting and Git annotations | [docs/cli/bat.md](docs/cli/bat.md) |
| `lsd` | `ls` with colors, icons, and a tree view | [docs/cli/lsd.md](docs/cli/lsd.md) |
| `tree` | Show a directory as a tree | [docs/cli/tree.md](docs/cli/tree.md) |
| `duf` | Disk space overview (friendlier `df`) | [docs/cli/duf.md](docs/cli/duf.md) |
| `dust` | Show what is taking up disk space (friendlier `du`) | [docs/cli/dust.md](docs/cli/dust.md) |
| `tokei` | Count lines of code by language | [docs/cli/tokei.md](docs/cli/tokei.md) |
| `autojump` | Jump to a frequent directory with `j <partial-name>` | [docs/cli/autojump.md](docs/cli/autojump.md) |
| `tlrc` | Short, example-first manual pages (`tldr <command>`) | `tldr tldr` |
| `antidote` | Zsh plugin manager | [docs/zsh/antidote.md](docs/zsh/antidote.md) |
| `terminal-notifier` | Send macOS notifications from shell scripts | [docs/macos/terminal-notifier.md](docs/macos/terminal-notifier.md) |
| `swaks` | Send test emails from the terminal (useful for SMTP debugging) | [docs/email/swaks.md](docs/email/swaks.md) |
| `glances` | Real-time system monitor (CPU, memory, disk, network) | `tldr glances` |

---

### Git & security

| Tool | What it does | Documentation |
| --- | --- | --- |
| `git-delta` | Readable, coloured Git diffs | [docs/git/git-delta.md](docs/git/git-delta.md) |
| `gh` | GitHub from the terminal: open PRs, create issues, clone repos | `gh --help` |
| `gitleaks` | Scan your repo for accidentally committed secrets | [docs/security/gitleaks.md](docs/security/gitleaks.md) |
| KeeWeb | KeePass-compatible password manager (desktop app) | [docs/security/keeweb.md](docs/security/keeweb.md) |

---

### PHP & Symfony development

These are only installed with the `full` profile.

| Tool | What it does | Documentation |
| --- | --- | --- |
| `php` | PHP runtime (Homebrew-managed, Apple Silicon native) | [docs/php/php.md](docs/php/php.md) |
| `composer` | PHP dependency manager | [docs/php/php.md](docs/php/php.md) |
| `symfony-cli` | Create, run, and manage Symfony projects | [docs/php/php.md](docs/php/php.md) |
| `xdebug` | Step debugger for PHP | [docs/php/xdebug.md](docs/php/xdebug.md) |
| pcov | Fast PHP code coverage (project-level, replaces Xdebug for CI) | [docs/php/coverage.md](docs/php/coverage.md) |
| PHPStan / Psalm | Static analysis — catch bugs before running the code | [docs/php/static-analysis.md](docs/php/static-analysis.md) |
| Pest | Modern PHP test framework | [docs/php/pest.md](docs/php/pest.md) |
| PHP-CS-Fixer / Rector | Autoformat and auto-refactor PHP code | [docs/php/coding-standards.md](docs/php/coding-standards.md) |
| Infection | Mutation testing — verify your tests actually catch regressions | [docs/php/mutation-testing.md](docs/php/mutation-testing.md) |
| mise | Optional per-project PHP version switching | [docs/php/mise.md](docs/php/mise.md) |

---

### Node & Python

| Tool | What it does | Documentation |
| --- | --- | --- |
| `node` | JavaScript runtime + `npm` | [nodejs.org/docs](https://nodejs.org/en/docs) |
| `uv` | Fast Python package and tool installer | [docs/python/uv.md](docs/python/uv.md) |
| `libpq` | PostgreSQL client libraries (required by some PHP/Python packages) | [docs/database/libpq.md](docs/database/libpq.md) |

---

### Quality, CI & containers

Linting and quality tools run automatically before each commit via `pre-commit`.

| Tool | What it does | Documentation |
| --- | --- | --- |
| `pre-commit` | Run quality checks automatically before every `git commit` | [docs/pre-commit/pre-commit.md](docs/pre-commit/pre-commit.md) |
| `shellcheck` | Find bugs and bad patterns in shell scripts | [docs/shell/shellcheck.md](docs/shell/shellcheck.md) |
| `actionlint` | Validate GitHub Actions workflow files | [docs/github-actions/actionlint.md](docs/github-actions/actionlint.md) |
| `act` | Run GitHub Actions locally (no push needed to test a workflow) | [docs/github-actions/act.md](docs/github-actions/act.md) |
| `hadolint` | Lint Dockerfiles | [docs/docker/hadolint.md](docs/docker/hadolint.md) |
| `markdownlint-cli2` | Enforce consistent Markdown formatting | [docs/quality/markdownlint-cli2.md](docs/quality/markdownlint-cli2.md) |
| `editorconfig-checker` | Enforce `.editorconfig` rules across the repo | [docs/quality/editorconfig-checker.md](docs/quality/editorconfig-checker.md) |
| `lychee` | Find broken links in documentation | [docs/quality/lychee.md](docs/quality/lychee.md) |
| OrbStack | Fast, lightweight Docker Desktop replacement | [docs/containers/orbstack.md](docs/containers/orbstack.md) |
| `ctop` | Live container resource monitor, `top`-style | [docs/containers/ctop.md](docs/containers/ctop.md) |

---

### Editors & terminal

| App | What it does | Documentation |
| --- | --- | --- |
| Visual Studio Code | Primary code editor | [docs/vscode/vscode.md](docs/vscode/vscode.md) |
| Sublime Text | Lightweight editor for quick edits and large files | [docs/vscode/sublime-text.md](docs/vscode/sublime-text.md) |
| Warp | Modern terminal with AI autocompletion | [docs/warp/warp.md](docs/warp/warp.md) |

---

### Databases

| App | What it does | Documentation |
| --- | --- | --- |
| Beekeeper Studio | SQL editor with a clean interface (PostgreSQL, MySQL, SQLite) | [docs/database/beekeeper-studio.md](docs/database/beekeeper-studio.md) |

---

### Productivity & macOS

| App | What it does | Documentation |
| --- | --- | --- |
| Raycast | Launcher that replaces Spotlight: clipboard history, snippets, window management | [docs/productivity/raycast.md](docs/productivity/raycast.md) |
| CleanShot X | Screenshot and screen recording with annotation and OCR | [docs/productivity/cleanshot.md](docs/productivity/cleanshot.md) |
| Obsidian | Local-first Markdown note-taking app | [docs/productivity/obsidian.md](docs/productivity/obsidian.md) |
| Notion | Collaborative workspace for notes, databases, and project tracking | [docs/productivity/notion.md](docs/productivity/notion.md) |
| GIMP | Open-source image editor for retouching and export | [docs/productivity/gimp.md](docs/productivity/gimp.md) |
| Stats | System monitor in the menu bar (CPU, memory, network) | [docs/macos/stats.md](docs/macos/stats.md) |
| Ice | Menu bar manager — hide, organise, and reorder menu bar icons | [docs/macos/ice.md](docs/macos/ice.md) |
| SwiftBar | Turn any shell script into a menu bar item with auto-refresh | [docs/macos/swiftbar.md](docs/macos/swiftbar.md) |
| Pearcleaner | Cleanly uninstall apps and their leftover files | [docs/macos/pearcleaner.md](docs/macos/pearcleaner.md) |
| Ukelele | Keyboard layout editor | [docs/keyboard/ukelele.md](docs/keyboard/ukelele.md) |

---

### Web & API

| App | What it does | Documentation |
| --- | --- | --- |
| Google Chrome | Primary development browser | [docs/web/chrome.md](docs/web/chrome.md) |
| Firefox | Secondary browser for cross-browser testing | [docs/web/firefox.md](docs/web/firefox.md) |
| Bruno | Git-friendly API client — collections stored as plain files in your repo | [docs/web/bruno.md](docs/web/bruno.md) |
| Excalidraw | Hand-drawn-style diagrams in the browser or VS Code | [docs/web/excalidraw.md](docs/web/excalidraw.md) |
| RealFaviconGenerator | Generate favicons for all platforms from a single source image | [docs/web/favicons.md](docs/web/favicons.md) |
| remove.bg | Remove image backgrounds automatically | [docs/web/image-services.md](docs/web/image-services.md) |

---

### AI assistants

| Tool | What it does | Documentation |
| --- | --- | --- |
| Claude (desktop app) | AI assistant for reasoning, writing, design, and code review | [docs/ai/claude.md](docs/ai/CLAUDE.md) |
| Claude Code (CLI) | Agentic coding from the terminal — reads and edits your project | [docs/ai/claude.md](docs/ai/CLAUDE.md) |
| Codex (CLI) | OpenAI's coding assistant, installed globally via `npm` | [docs/ai/codex.md](docs/ai/codex.md) |
| Ollama | Run large language models locally (Mistral, Llama, etc.) | [docs/ai/ollama.md](docs/ai/ollama.md) |
| CodexBar | Menu bar app tracking token usage and cost across AI providers | [docs/ai/codexbar.md](docs/ai/codexbar.md) |
| claude-monitor | Real-time token usage monitor for active Claude Code sessions | [docs/ai/claude-monitor.md](docs/ai/claude-monitor.md) |

---

### Monitoring & error tracking

| Tool | What it does | Documentation |
| --- | --- | --- |
| SwiftBar + custom scripts | Lightweight VPS and site uptime monitoring in the menu bar | [docs/macos/swiftbar.md](docs/macos/swiftbar.md) |
| Sentry | Error tracking and performance monitoring for Symfony projects | [docs/monitoring/sentry.md](docs/monitoring/sentry.md) |

---

The complete, always-up-to-date package inventory (with USED / INSTALLED /
TOOLING classification) lives in
[docs/homebrew/inventory.md](docs/homebrew/inventory.md).

---

## Installation

### Prerequisites

Before you start, make sure you have:

- **macOS** (Apple Silicon or Intel)
- **Git** — comes pre-installed on macOS; check with `git --version`
- An **internet connection**
- Permission to install software (admin account)

You do **not** need to install Homebrew beforehand — the setup does it for you.

---

### Step 1 — Run the installer

Open **Terminal** (or Warp, iTerm2 — any terminal works) and paste this
command:

```bash
curl -fsSL https://raw.githubusercontent.com/labault/mac-dev-setup/main/install.sh | bash
```

What this does:

- Downloads this repository to `~/.mac-dev-setup` on your machine.
- Creates a `mac` command available from anywhere in your terminal.
- Adds `~/.local/bin` to your shell `PATH` so the command is found.

It does **not** install any tools yet — that happens in Step 3.

---

### Step 2 — Reload your shell

Close and reopen your terminal (or open a new tab). Then confirm the `mac`
command is available:

```bash
mac help
```

You should see a list of commands. If `mac` is not found, open a new terminal
tab — your shell just hasn't reloaded yet.

---

### Step 3 — Install the development environment

```bash
mac setup
```

This is the main step. It:

1. Installs **Homebrew** if it is not already on your machine.
2. Installs every package from your selected **profile** (see below).
3. Configures **Git** through a managed global include.
4. Installs the **Zsh** configuration and shell completion for `mac`.

This will take a few minutes the first time (Homebrew downloads and compiles
packages).

Want to preview what it *would* do without changing anything?

```bash
mac setup --dry-run
```

---

### Step 4 — Choose a profile

A **profile** decides which tools get installed. Pass it with `--profile`:

```bash
mac setup --profile minimal   # the essentials only
mac setup --profile full      # everything (this is the default)
```

| Profile | Best for | What you get |
| --- | --- | --- |
| `minimal` | Lightweight shell + Git workflow | Core CLI tools, Git helpers, `gh`, `node`, `pre-commit` |
| `full` | Complete dev workstation (default) | Everything in `minimal` + PHP/Symfony stack, quality linters, GUI apps, containers, databases, AI tools |

The exact lists live in
[`profiles/minimal/Brewfile`](profiles/minimal/Brewfile) and
[`profiles/full/Brewfile`](profiles/full/Brewfile).

---

### Step 5 — Apply optional settings (when you're ready)

These commands change system or app settings. They are **not** run
automatically — you decide when you want them:

```bash
mac defaults   # apply curated macOS Finder / Dock / keyboard tweaks
mac keyboard   # install the Français OSS Mac keyboard layout
mac vscode     # install the curated VS Code extensions
```

---

### Files MacDevSetup manages

To configure your shell and Git, these user-level files may be created or
updated:

- `~/.zprofile`, `~/.zshrc`, `~/.zsh_plugins.txt`, `~/.p10k.zsh`
- `~/.shell/alias.sh`
- `~/.zsh/completions/_mac`
- a global Git `include.path`

Your existing files are **backed up before replacement** when they differ from
the versioned ones. Backups go to `~/Documents/Backups/mac-dev-setup/zsh`.

---

## The `mac` CLI — command reference

Every command accepts `--help` for a detailed description:

```bash
mac <command> --help
```

### All commands

| Command | What it does |
| --- | --- |
| `mac help` | List all available commands |
| `mac setup` | Install or reapply the full development environment |
| `mac doctor` | Check your machine against the selected profile — reports what is missing, out of date, or drifted |
| `mac php` | Manage PHP development helpers (Xdebug on/off) |
| `mac update` | Update MacDevSetup itself to the latest version |
| `mac uninstall` | Remove the `mac` CLI and its managed configuration |
| `mac defaults` | Apply curated macOS Finder / Dock / keyboard defaults *(opt-in)* |
| `mac keyboard` | Install the Français OSS Mac keyboard layout *(opt-in)* |
| `mac vscode` | Install the curated VS Code extensions *(opt-in)* |

---

### `mac setup`

Installs and configures the full development environment.

```bash
mac setup                       # install everything (full profile)
mac setup --profile minimal     # install the minimal profile only
mac setup --dry-run             # preview what would happen, change nothing
```

---

### `mac doctor`

Checks your machine against the expected state. Useful after switching
machines, pulling updates, or debugging a broken tool.

```bash
mac doctor                      # check your machine (uses your current profile)
mac doctor --profile minimal    # check against the minimal profile specifically
mac doctor --fix                # print the commands that would fix each issue (does not run them)
```

`mac doctor` reports three things:

- **Missing** — a tool declared in the profile is not installed.
- **Drift** — a managed config file differs from the versioned copy.
- **Undeclared** — a tool is installed but not declared in any profile.

---

### `mac php`

Manages PHP-specific helpers without touching Homebrew directly.

```bash
mac php xdebug status    # show whether Xdebug is enabled or disabled
mac php xdebug enable    # enable Xdebug (for local debugging)
mac php xdebug disable   # disable Xdebug (for performance / CI)
```

Xdebug is kept **disabled by default** — it adds overhead to every request.
Enable it only when you are actively debugging.

---

### `mac update`

Pulls the latest version of MacDevSetup from GitHub and fast-forwards your
local copy.

```bash
mac update              # update to the latest version
mac update --dry-run    # preview the update, change nothing
```

If you have uncommitted local changes, `mac update` will refuse to proceed to
avoid overwriting your work.

---

### `mac uninstall`

Removes MacDevSetup from your machine. The installed tools (Homebrew packages,
apps) are **not** removed — only the `mac` CLI and its managed entries.

```bash
mac uninstall                       # remove the CLI + managed PATH entry
mac uninstall --remove-config       # also remove managed config files (only if identical to the versioned copies)
mac uninstall --remove-install-dir  # also remove ~/.mac-dev-setup
mac uninstall --dry-run             # preview what would be removed, change nothing
```

---

## Going further

Full documentation lives in [`docs/`](docs). Good entry points:

- [Setup walkthrough](docs/setup/setup.md)
- [Homebrew & the package inventory](docs/homebrew/homebrew.md)
- [Zsh configuration](docs/zsh/zsh.md)
- [Git configuration](docs/git/git.md)
- [How the CLI is built](docs/architecture/current-architecture.md)
- [Troubleshooting](docs/troubleshooting/troubleshooting.md)

---

## License

MacDevSetup is released under the MIT License. See [`LICENSE`](LICENSE) for
details.
