# Homebrew Inventory

This file documents the real usage status of every Homebrew formula and cask in this setup.

It ensures the Brewfile remains a **curated workstation definition**, not just a dump of installed tools.

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
- `gh` → GitHub CLI.
- `git-delta` → Git diff enhancement.
- `gitleaks` → security scanning.
- `markdownlint-cli2` → Markdown validation.
- `node` → JavaScript runtime for repository tooling and npm scripts.
- `pre-commit` → local quality pipeline.
- `shellcheck` → shell script validation.
- `tokei` → code statistics.
- `tree` → filesystem exploration.

---

### Containers

- `orbstack` → container runtime.
- `ctop` → container monitoring.
- `hadolint` → Dockerfile linting.

---

### macOS / dev UX

- `pearcleaner` → uninstall/cleanup tool.
- `visual-studio-code` → editor.
- `warp` → terminal.

---

### Database

- `beekeeper-studio` → graphical SQL client.
- `libpq` → PostgreSQL client libraries and command-line tools.

---

### Browsers and API clients

- `google-chrome` → primary development browser.
- `bruno` → git-friendly API client; collections stored as plain files.

---

## 🟡 INSTALLED (optional / partial usage)

- `firefox` → secondary browser for cross-browser testing.
- `duf` → disk usage viewer.
- `dust` → alternative disk usage analyzer.
- `editorconfig-checker` → formatting enforcement.
- `lsd` → alternative `ls` replacement.
- `lychee` → link checker.
- `swaks` → SMTP test tool.
- `terminal-notifier` → notification utility.
- `tlrc` → official `tldr` client for CLI help pages.
- `ukelele` → keyboard layout editor used to inspect or evolve the bundled French OSS layout.
- `uv` → Python package/tool runner, also used for runtime-managed tools.

---

## 🔴 TOOLING (not part of workflow but installed)

- `claude-monitor` → runtime-managed usage monitoring tool installed through `uv`.
- `codexbar` → auxiliary menu bar tooling.
- `glances` → system monitor.
- `jordanbaird-ice` → menu bar manager.
- `keeweb` → password manager.
- `stats` → macOS system monitoring.

---

## 📌 Notes

- No tool is strictly forbidden.
- Everything remains installed, but only some tools are part of the **documented workflow**.
- Future goal: progressively move tools from INSTALLED → USED or remove if unnecessary.

---

## 🎯 Principle

> Installed does not mean used. Documented does not mean essential.
