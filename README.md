# MacDevSetup

A curated macOS development environment built for reproducibility, clarity, and control.

This repo defines a fully reproducible development setup for macOS using Homebrew, Zsh, and a curated toolchain.

---

## 🚀 Quick start

git clone <https://github.com/Labault/mac-dev-setup.git>
cd mac-dev-setup

REPO_ROOT="$(git rev-parse --show-toplevel)"
cd "$REPO_ROOT"

./scripts/bootstrap.sh

---

## ⚙️ What it installs

### 🧱 Base tools

- git
- curl / wget
- jq (JSON tooling)
- tree
- openssl
- antidote (Zsh plugin manager)
- gitleaks (security scanning)

### 🧪 Dev tooling

- shellcheck
- hadolint
- actionlint
- act

### 🖥️ Applications

- OrbStack
- Beekeeper Studio
- Pearcleaner

---

## 🧪 Validation

Run:

./scripts/verify.sh

---

## 🧱 Structure

brewfiles/
  Brewfile.base
  Brewfile.dev
  Brewfile.casks

scripts/
  bootstrap.sh
  verify.sh

---

## ⚠️ Rules

- No fake Homebrew packages
- No guessing tool names
- Everything must be reproducible via Brewfile
- All install goes through bootstrap

---

## 🔥 Philosophy

This setup is not a list of tools.

It is a reproducible macOS dev environment definition.
