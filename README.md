# MacDevSetup

![macOS](https://img.shields.io/badge/macOS-dev_environment-blue)
![status](https://img.shields.io/badge/status-stable-green)
![brew](https://img.shields.io/badge/homebrew-based-orange)

A curated macOS development environment built step by step, with real-world validation.
This repository documents tools, configurations, and workflows used on a daily developer machine (Apple Silicon).
Every change is tested and intentionally chosen.

---

## ✨ Why this exists

Setting up a new macOS development environment is repetitive, error-prone, and inconsistent.

MacDevSetup solves this by providing:

- a fully reproducible setup
- a clean Homebrew-based architecture
- automated validation and safety checks
- zero manual configuration drift

---

## 🚀 Quick start

### Recommended

```bash
git clone https://github.com/labault/mac-dev-setup.git
cd mac-dev-setup
./scripts/bootstrap.sh
```

---

### One-line install

```bash
curl -fsSL https://raw.githubusercontent.com/labault/mac-dev-setup/main/install.sh | bash`
```

---

## ⚙️ What it installs

### Core system tools

- git
- curl / wget
- jq
- tree
- openssl
- antidote
- gitleaks

### Development tools

- shellcheck
- hadolint
- actionlint
- act

### macOS apps

- OrbStack
- Beekeeper Studio
- Pearcleaner

---

## 🧪 Validation

Run full environment check:

./scripts/verify.sh

Run security hardening:

./scripts/hardening.sh

---

## 🧱 Architecture

brew/
  Brewfile

brewfiles/
  Brewfile.base
  Brewfile.dev
  Brewfile.casks

scripts/
  bootstrap.sh
  verify.sh
  hardening.sh
  install.sh

---

## 🧠 Philosophy

This is not a dotfiles repository.

It is a deterministic macOS development system.

No manual setup. No guessing. No drift.

---

## 🚀 Status

Stable v0.3.x — ready for production use
