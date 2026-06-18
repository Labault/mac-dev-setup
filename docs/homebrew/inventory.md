# Homebrew Inventory

This file documents the real usage status of every Homebrew formula and cask in this setup.

It ensures the Brewfile remains a **curated workstation definition**, not just a dump of installed tools.

---

## 🟢 USED (actively integrated in workflow)

### Core development

- act → local GitHub Actions execution
- actionlint → CI validation
- antidote → Zsh plugin manager
- autojump → directory navigation
- bat → file viewer
- composer / php / symfony-cli → backend stack
- git-delta → git diff enhancement
- gitleaks → security scanning
- markdownlint-cli2 → markdown validation
- pre-commit → local pipeline
- shellcheck → shell scripts validation
- tokei → code statistics
- tree → filesystem exploration
- gh → GitHub CLI

---

### Containers

- orbstack → container runtime
- ctop → container monitoring
- hadolint → Docker linting

---

### macOS / dev UX

- pearcleaner → uninstall/cleanup tool
- visual-studio-code → editor
- warp → terminal

---

## 🟡 INSTALLED (optional / partial usage)

- duf → disk usage viewer
- dust → alternative disk usage analyzer
- lychee → link checker (CI only)
- editorconfig-checker → formatting enforcement
- lsd → alternative ls replacement
- terminal-notifier → notification utility
- tlrc → official tldr client for CLI help pages

---

## 🔴 TOOLING (not part of workflow but installed)

- glances → system monitor
- stats → macOS system monitoring
- keeweb → password manager
- codexbar → auxiliary tooling

---

## 📌 Notes

- No tool is strictly forbidden.
- Everything remains installed, but only some tools are part of the **documented workflow**.
- Future goal: progressively move tools from INSTALLED → USED or remove if unnecessary.

---

## 🎯 Principle

> Installed does not mean used. Documented does not mean essential.
