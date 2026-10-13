# Homebrew Inventory

This file records the intended role of every formula and cask in the profiles.
It is a curated selection, not a live inventory or proof that an app is used.

It ensures the Brewfile remains a **curated workstation definition**, not just a dump of installed tools.

![Homebrew inventory overview](../assets/screenshots/homebrew/inventory-overview.webp)

---

## 🟢 USED (actively integrated in workflow)

### Core development

- `act` → local GitHub Actions execution.
- `actionlint` → GitHub Actions workflow validation.
- `antidote` → Zsh plugin manager.
- `autojump` → directory navigation.
- `bash` → modern Homebrew-provided Bash for script compatibility.
- `bat` → file viewer with syntax highlighting.
- `composer` / `php` / `symfony-cli` → backend stack.
- `fnm` → project-specific Node.js versions; shell activation is opt-in.
- `gh` → GitHub CLI.
- `git` → Homebrew-managed Git.
- `git-filter-repo` → deliberate Git history cleanup.
- `git-delta` → Git diff enhancement.
- `gitleaks` → security scanning.
- `jq` → inspect and transform JSON.
- `markdownlint-cli2` → Markdown validation.
- `node` → JavaScript runtime for repository tooling and npm scripts.
- `pre-commit` → local quality pipeline.
- `ripgrep` → source-code search independent of editor-bundled binaries.
- `shellcheck` → shell script validation.
- `shfmt` → shell formatting.
- `tokei` → code statistics.
- `tree` → filesystem exploration.
- `uv` → Python environments and isolated CLI tools.

---

### Containers

- `orbstack` → container runtime.
- `ctop` → container monitoring.
- `hadolint` → Dockerfile linting.

---

### macOS / dev UX

- `cleanshot` → screenshot and screen recording tool; annotations, scrolling capture, OCR. Licence required, activated manually.
- `gimp` → open-source image editor for manual retouching, background removal, and export.
- `obsidian` → local-first Markdown note-taking app. Personal vault stays outside this repository.
- `pearcleaner` → uninstall/cleanup tool.
- `raycast` → productivity launcher; replaces Spotlight with clipboard history, snippets, and window management.
- `swiftbar` → menu bar app runner; shell scripts in a folder become auto-refreshing menu bar items (used for VPS/site monitoring).
- `sublime-text` → fast and lightweight text editor; used for quick file edits and large file handling.
- `visual-studio-code` → editor.
- `warp` → terminal.

---

### Database

- `beekeeper-studio` → graphical SQL client.
- `libpq` → PostgreSQL client libraries and command-line tools.

---

### Browsers and API clients

- `google-chrome` → primary development browser.

---

## 🟡 INSTALLED (optional / partial usage)

- `firefox` → secondary browser for cross-browser testing.
- `duf` → disk usage viewer.
- `dust` → alternative disk usage analyzer.
- `editorconfig-checker` → formatting enforcement.
- `lsd` → alternative `ls` replacement.
- `lychee` → link checker.
- `terminal-notifier` → notification utility.
- `tlrc` → official `tldr` client for CLI help pages.

---

### AI assistants

- `claude` → Claude desktop app by Anthropic; used for reasoning, design, and code review.
- `codexbar` → menu bar app tracking Claude and Codex usage and costs.
- `ollama-app` → run large language models locally; used for privacy-sensitive tasks and offline work.

---

## 🔴 TOOLING (not part of workflow but installed)

- `glances` → system monitor.
- `thaw` → menu bar manager (replaces Ice in the full profile).
- `keeweb` → password manager.

---

## 📌 Notes

- Profile policy checks live in `scripts/hardening.sh`.
- Removing a profile entry does not uninstall an existing application.
- Bruno, Notion, and Stats are optional tools outside the current profiles.
  Their guides remain available for manual installation.
- See [workstation audits](audit.md) for versions, updates, and local snapshots.
- See [development CLI tools](../cli/development-tools.md) for the shared
  Git, JSON, search, Node.js, Python, and formatting utilities.
- Future goal: progressively move tools from INSTALLED → USED or remove if unnecessary.

---

## 🎯 Principle

> Installed does not mean used. Documented does not mean essential.

---

[← Docs index](../README.md) · [Project README](../../README.md)
