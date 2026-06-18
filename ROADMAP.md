# MacDevSetup — Product Roadmap

## Purpose

This document records the long-term direction of the **MacDevSetup** project.

The project has two complementary goals:

1. Reproduce a complete PHP/Symfony development environment on a new Mac.
2. Document and automate the broader Mac workstation used for development, productivity, AI, monitoring, design, and web operations.

Every new tool follows the same curation workflow:

```text
Proposed → Tested → Accepted or Rejected → Integrated → Documented
```

The end goal is not a huge opaque script. Every module must remain readable, optional when appropriate, idempotent, documented, testable, reversible, and free of secrets.

### Curation policy (read before proposing tools)

This repository is a **curated** workstation definition, not a "install everything popular" dump. Two mechanisms enforce that and **any roadmap item must respect them**:

- `docs/homebrew/inventory.md` classifies every tool as **USED / INSTALLED / TOOLING**.
- `scripts/hardening.sh` maintains a **forbidden-tools list** that CI enforces (the build fails if any of these appear in a profile Brewfile):

  ```text
  lazygit  watchexec  hyperfine  direnv  mas  orbctl
  ```

Adding any forbidden tool is therefore a **deliberate policy reversal**, not a default. If a future milestone wants one of them, the first step is to remove it from `hardening.sh` and justify the change — otherwise CI goes red.

---

## Current State (verified against the repository)

> ⚠️ **Reality check:** `v1.0.0` has **not** shipped yet. Latest tag is `v0.4.1`, `package.json` is at `0.5.0`, and the only published GitHub Release is `v0.1.0`. `docs/releases/v1.0.0.md` is a **release-criteria checklist** with several boxes still unchecked. Earlier drafts of this roadmap assumed v1.0.0 was already released — it is not.

MacDevSetup already provides:

### CLI

- Bootstrap installer (`install.sh`) with `curl | bash` support and `--uninstall`
- `mac` CLI with automatic command discovery, a command registry, and dynamic help
- Zsh tab completion (generated from the registry, verified in CI)
- Fuzzy command suggestions (Levenshtein distance)
- 7 command files + built-in `help`: `setup`, `doctor`, `update`, `uninstall`, `defaults`, `keyboard`, `vscode`

### Setup

- Homebrew bundle installation (profile-aware)
- Git configuration via a managed `include.path` (no direct writes to global config)
- Zsh + Antidote + Powerlevel10k
- VS Code extension installation (`mac vscode`, with `--with-optional`)
- macOS system defaults (`mac defaults`)
- Français OSS keyboard layout (`mac keyboard`)
- Automatic backup of existing shell files before replacement (to `~/Documents/Backups/...`)

**Already-versioned configuration** (this matters for the future backup/restore milestone — config versioning is largely already solved)

- `configs/zsh/` (`.zshrc`, `.zprofile`, `.p10k.zsh`, `.zsh_plugins.txt`, `alias.sh`, `_mac` completion)
- `configs/git/.gitconfig`, `configs/vscode/` (`settings.json` + `extensions.txt` + `extensions-optional.txt`)
- `configs/warp/settings.toml`, `configs/ssh/config.example`, `configs/keyboard/` (the layout bundle)

### Quality / CI

- 10 BATS test files (`cli`, `command_registry`, `completion`, `doctor`, `install`, `path_manager`, `profiles`, `setup`, `uninstall`, `update`)
- `scripts/verify.sh` — checks profile Brewfiles exist and `brew bundle check` passes
- `scripts/hardening.sh` — enforces the forbidden-tools list + `brew doctor`/`brew outdated`
- CI on Ubuntu (quality) **and** macOS (real full-profile install + setup + verify + hardening)
- Pre-commit: ShellCheck, markdownlint, EditorConfig, lychee link check
- Commitlint (gitmoji + conventional), Husky hooks, Dependabot
- `SECURITY.md`, `CONTRIBUTING.md`, `CHANGELOG.md`

**Documentation:** 37 Markdown files across CLI tools, containers, database, Docker, Git, GitHub Actions, Homebrew, keyboard, macOS, pre-commit, quality, releases, security, setup, shell, SSH, VS Code, Warp, Zsh, and architecture.

### Installed tools (full profile)

| Category | Tools |
| --- | --- |
| Shell | antidote, autojump, bash, lsd, tlrc |
| File/disk | bat, duf, dust, tree |
| Dev | act, actionlint, composer, editorconfig-checker, gh, gitleaks, hadolint, libpq, lychee, markdownlint-cli2, node, php, pre-commit, shellcheck, symfony-cli, uv |
| Stats/monitoring | ctop, glances, tokei |
| Notification | swaks, terminal-notifier |
| Database | beekeeper-studio, libpq |
| GUI | codexbar, jordanbaird-ice (Ice), keeweb, orbstack, pearcleaner, stats, ukelele, visual-studio-code, warp |
| Runtime-managed | claude-monitor (via uv) |

The technical foundation is solid. The remaining work is sequenced below.

---

## Release Roadmap

---

### v1.0.0 — Ship the First Stable Release

**Goal:** Actually publish `v1.0.0`. The criteria already live in `docs/releases/v1.0.0.md`; most boxes are checked. This milestone closes the remaining ones. **No new features** — shipping discipline only.

**Remaining checklist items (from `docs/releases/v1.0.0.md`)**

- [ ] Bump `package.json` version `0.5.0` → `1.0.0`
- [ ] Bump `package-lock.json` to `1.0.0`
- [ ] Add a dated `## 1.0.0 - YYYY-MM-DD` section to `CHANGELOG.md` (move everything out of `Unreleased`)
- [ ] Push the release-prep commit to `main`
- [ ] Confirm GitHub Actions pass on `main` (Ubuntu + macOS gates)
- [ ] Tag `v1.0.0` and push the tag
- [ ] Create the GitHub Release from the tag

#### Cold-start validation on a clean Mac (do this before tagging)

```bash
curl -fsSL .../install.sh | bash        # bootstrap
mac help
mac setup --profile minimal --dry-run
mac setup --profile minimal
mac doctor
mac setup --profile full
mac defaults
mac keyboard
mac vscode --with-optional
mac update --dry-run
mac uninstall --dry-run
npm test
```

Also verify: repeated setup is idempotent, Zsh/Git backups land in `~/Documents/Backups/...`, and executable permissions are correct.

**Estimated effort:** 2–3 h

---

### v1.1.0 — Close the "installed but undocumented" gap

**Goal:** Several tools are in the `full` Brewfile with no documentation page, and `docs/homebrew/inventory.md` is **incomplete** (it omits Ice, Ukulele, swaks, terminal-notifier, libpq, uv, claude-monitor). New users can't see why these are installed.

**Fix the inventory first**, then write one focused page per tool.

| Tool | Cask/Formula | Inventory status today | Action |
| --- | --- | --- | --- |
| Ice | `jordanbaird-ice` | **missing** | add + document (menu bar manager) |
| Ukulele | `ukelele` | **missing** | add + document (layout editor; powers Français OSS) |
| swaks | `swaks` | **missing** | add + document (SMTP test tool) |
| terminal-notifier | `terminal-notifier` | listed, no doc | document |
| libpq | `libpq` | **missing** | add + document (Postgres client libs) |
| uv | `uv` | **missing** | document (Python/tool runner; manages claude-monitor) |
| claude-monitor | via `uv` | TOOLING | document install/upgrade/uninstall |
| Stats | `stats` | TOOLING | document; decide USED vs TOOLING |
| KeeWeb | `keeweb` | TOOLING | document |
| lsd | `lsd` | INSTALLED | document |
| autojump | `autojump` | USED, no doc | document |
| antidote | `antidote` | USED, only in zsh.md | dedicated page |

**Also:** add a CI consistency check (a BATS test) that fails when a Brewfile entry has no matching inventory line — so this gap can't silently reappear.

**Estimated effort:** 2–4 h

---

### v1.2.0 — Smarter `doctor` + Drift Detection ("Smart Layer")

**Goal:** This was the project's *own* original roadmap intent ("machine audit, missing-tools detection, Brewfile drift analysis") and it's the cheapest high-value win after 1.0. Today `mac doctor` only checks that `brew`/`git`/`zsh`/`mac` exist plus `brew doctor` — it is blind to profiles, drift, and config state.

#### Work

- Make `mac doctor` **profile-aware**: read the active profile's Brewfile and report which declared packages are missing (reuse `brew bundle check` like `verify.sh` does).
- **Drift detection:** packages installed on the machine but **not** declared in any profile (candidates to adopt or remove) — the inverse of the forbidden-tools check `hardening.sh` already does.
- **Config drift:** report when a managed dotfile on disk differs from the versioned copy (the uninstall command already computes this comparison — reuse it).
- Optional `mac doctor --fix` suggestions (print the exact `mac setup` / `brew bundle` command to reconcile).
- Surface results clearly: ✅ in sync / ⚠️ drift / ❌ missing.

**Why now:** it turns the existing `verify.sh` + uninstall-diff logic (already written) into a user-facing diagnostic, and it makes every later tool-integration milestone self-checking.

**Estimated effort:** 3–5 h

---

### v1.3.0 — PHP, Symfony, Testing, and Code Quality

**Goal:** Turn the PHP install (php + composer + symfony-cli already present) into a complete toolchain. **The editor is already pre-wired:** `configs/vscode/extensions.txt` ships `xdebug.php-debug` and `sanderronde.phpstan-vscode` — so **PHPStan is the implied static-analysis choice** (don't re-litigate Psalm) and **Xdebug** is the expected debugger. This milestone installs the runtime side to match.

#### Xdebug (editor already configured for it)

- Install the Xdebug extension for the Homebrew PHP version
- Document `xdebug.ini`; keep it **disabled by default**, with explicit enable/disable
- Document the VS Code debug workflow (already half-configured), the debugger port, and OrbStack/Docker usage
- Optional commands (only if implementation stays trivial): `mac php xdebug enable|disable|status`

#### PCOV (fast coverage)

- Xdebug for debugging/profiling; **PCOV for coverage**; never both in one run
- Benchmark on a real Symfony project: baseline vs Xdebug-coverage vs PCOV; HTML + Clover support

#### PHPStan (already the chosen analyser)

- Install/document PHPStan + `phpstan/extension-installer` + Symfony/Doctrine extensions
- Baseline strategy, progressive levels, IDE integration (extension already installed)
- Document Psalm only as a rejected alternative, with the reason

#### Pest

- Evaluate Pest as the preferred interface over PHPUnit (kept as engine)
- Per-project Composer dev dependency — **never** global/Homebrew
- Document unit/integration/functional tests, datasets, mocks, coverage; add `composer test*` scripts

#### PHP-CS-Fixer & Rector

- PHP-CS-Fixer for formatting (check + fix modes; pre-commit integration optional)
- Rector for controlled upgrades — **never** auto-run; always review the diff; versioned config per project

#### Infection (optional)

- Mutation testing as a slow, manual / dedicated-CI-job step (`composer mutation`)

#### mise (runtime version manager) — evaluate

- Manage multiple PHP/Node versions per project without per-language managers. **Not forbidden**, but it's a real addition: classify it in the inventory and document the boundary with Homebrew PHP before adopting.

**Docs:** `docs/php/{php,xdebug,coverage,pest,static-analysis,coding-standards,mutation-testing,mise}.md`

**Estimated effort:** 5–8 h

---

### v1.4.0 — API Tools, Browsers, and Curated CLI Additions

**Goal:** Round out the web-development workflow.

#### CLI additions — subject to the curation policy

These are **not** in the forbidden list and are reasonable candidates, but each is a curation decision (add to inventory, justify, document):

| Tool | Purpose | Note |
| --- | --- | --- |
| `jq` | JSON processor | near-essential for API work |
| `fd` | better `find` | |
| `ripgrep` | better `grep` | |
| `fzf` | fuzzy finder + Zsh `Ctrl+R`/`Ctrl+T` | |
| `mkcert` | local HTTPS certs for Symfony | |
| `httpie` or `xh` | friendlier `curl` | |

> ❌ **Do not** propose `lazygit`, `direnv`, `hyperfine`, `watchexec`, `mas` here — they are on the enforced forbidden list. Including any of them would fail `hardening.sh` in CI. Adopting one requires first editing `hardening.sh` and recording the rationale.

#### Insomnia (or Bruno)

- Install via Cask; add to `full` or a future `web` module
- Document workspaces, environments, Bearer/OAuth, OpenAPI import, export/backup, OrbStack networking, no-secrets policy
- **Bruno** is worth a serious look as the git-friendly alternative (collections are plain files, safely versionable)

#### Browsers

- **Chrome** — primary dev browser: profiles, DevTools, Lighthouse, curated extensions
- **Firefox** — cross-browser testing: pick standard *or* Developer Edition (install only one); Grid/Flexbox/accessibility inspectors
- **Arc** — optional, `full`-only; decide long-term value vs Chrome overlap

#### Web services (documented, not installed)

- **RealFaviconGenerator** — favicon/manifest/Apple-touch + Twig integration
- **remove.bg** — background removal; free-tier limits, privacy, local alternatives

**Docs:** `docs/web/{browsers,chrome,firefox,arc,insomnia,favicons,image-services}.md`, `docs/cli/{jq,fzf,mkcert}.md`

**Estimated effort:** 4–6 h

---

### v1.5.0 — Productivity, Notes, and Design

**Goal:** Document/configure the productivity & design workflow. Note **Stats and Ice are already installed** — this is mostly configuration + docs for them, plus new tools.

- **Stats** (installed) — widgets, menu-bar layout, launch at login
- **Ice** (installed) — menu-bar hiding/sections; **define ownership of window management vs Raycast to avoid conflicts**
- **Raycast** (new, high priority) — Cask; replace Spotlight; clipboard history, snippets, quicklinks, window management, dev extensions; version only non-sensitive config (`configs/raycast/`)
- **CleanShot X** — screenshots/annotations/scrolling/OCR/GIF; **license activation is manual, never implied as automated**
- **Obsidian** — Cask; vault structure, essential plugins, sync/backup; **personal vault stays out of the repo**
- **Excalidraw** — pick workflow (web/desktop/Obsidian plugin); use it for the repo's own diagrams (v1.8.0)
- **GIMP** (manual edits) + **ImageMagick** (scriptable: `magick in.png -resize 1600x out.png`)

**Estimated effort:** 4–7 h

---

### v1.6.0 — AI Tools and Development Assistants

**Goal:** Document/configure the AI environment safely. **CodexBar and claude-monitor are already installed** (both TOOLING) — promote them to USED if part of daily flow.

- **Claude** — distinguish desktop app / Claude Code CLI / Anthropic account+API / `.claude/` repo config / permissions / auth; document install, per-project config, safe permissions, secret handling
- **Codex** — CLI vs ChatGPT account vs OpenAI API; project instructions, atomic-commit workflow, prompt templates; **prohibit auto commit/push unless explicitly requested**; compare with Claude Code
- **CodexBar** (installed) — providers, auth, launch-at-login, metrics
- **claude-monitor** (installed via uv) — `uv tool upgrade`, what it tracks, uninstall
- **Ollama** — local models; storage/disk, service start/stop, lightweight default model, local API + Symfony integration, privacy, full uninstall

| Need | Preferred tool |
| --- | --- |
| Repository implementation | Claude Code or Codex |
| Reasoning/design | Claude or ChatGPT |
| Local/sensitive | Ollama |
| Usage tracking | CodexBar + claude-monitor |

**Docs:** `docs/ai/{overview,claude,claude-code,codex,codexbar,claude-monitor,ollama,security}.md`

**Estimated effort:** 4–7 h

---

### v1.7.0 — VPS and Website Monitoring

**Goal:** Continuous monitoring with quick Mac menu-bar visibility. **glances + ctop (USED) and Stats are already installed** — the gap is the remote/alerting layer. The monitoring system must keep running while the Mac is off.

- **Level 1 — external uptime:** HTTP status, latency, TLS/domain expiry, content, API (Better Stack / UptimeRobot / HetrixTools)
- **Level 2 — self-hosted:** Uptime Kuma; don't host the monitor on the same VPS it watches
- **Level 3 — VPS resources:** glances/ctop over SSH (already installed) + Hetzner metrics + Sentry; add Netdata/Prometheus+Grafana only if those become insufficient
- **Level 4 — menu bar:** Stats covers local; for remote status evaluate **SwiftBar** or Raycast script commands

```text
Alerts → external provider   Quick status → SwiftBar/Raycast
Dashboards → browser         Diagnostics → SSH + glances/ctop
```

**Docs:** `docs/monitoring/{strategy,uptime,vps,application-errors,mac-menu-bar,incident-checklist}.md`; optional `configs/swiftbar/`, `scripts/monitoring/`

**Estimated effort:** 5–9 h

---

### v1.8.0 — Branding, Screenshots, and Illustrated Documentation

**Goal:** Make the repo visually clear.

- **Branding:** logo, icon, GitHub banner, light/dark, palette, typography
- **CLI screenshots:** install, `mac help`, `setup --dry-run`, `doctor`, completion, unknown-command suggestion, update, uninstall
- **App screenshots:** VS Code, Warp, OrbStack, Beekeeper, Pearcleaner, Stats, Ice, Raycast, CleanShot X, Obsidian, Insomnia, CodexBar, Ollama
- **Excalidraw diagrams:** install flow, CLI/registry architecture, profile architecture, doctor/drift flow, PHP quality workflow, AI workflow, monitoring, curation lifecycle
- **Image pipeline:** CleanShot X → GIMP (manual) → ImageMagick (reproducible) → `assets/`
- **Rules:** redact secrets/hosts/paths; consistent dimensions; compress; alt text; no decorative-only or fast-rotting screenshots

```text
assets/{branding,screenshots/{cli,shell,development,productivity,ai,monitoring},diagrams}/
```

**Estimated effort:** 5–10 h

---

### v1.9.0 — Backup, Restore, and Migration

**Goal:** Safe, repeatable migration to a new Mac. **Note: config versioning is already mostly done** (`configs/` holds zsh, git, vscode, warp, ssh example, keyboard). The real gap is a `mac backup` command and capturing machine-specific, non-versioned state.

```bash
mac backup    mac restore    mac diff
```

**May be backed up:** exportable Raycast settings, Insomnia config (no secrets), app inventory, documented preferences, monitoring scripts, SwiftBar plugins, references to (not contents of) the Obsidian vault.

**Must never be in Git:** tokens, passwords, browser sessions/cookies, licenses, personal Obsidian content, large Ollama models, secret-bearing Insomnia exports, Claude/Codex auth.

**Estimated effort:** 6–10 h

---

### v1.10.0 — Expand Test Coverage and Security Hardening

**Goal:** Extend what already exists — this is **expansion, not creation**. 10 BATS files, `verify.sh`, `hardening.sh`, `SECURITY.md`, ShellCheck/Actionlint/lychee in CI all exist today.

- **Untested commands:** add BATS for `mac defaults`, `mac keyboard`, `mac vscode` (none are covered yet)
- **Consistency tests:** Brewfile↔inventory (started in v1.1.0), accepted-app↔doc-page, referenced-image↔`assets/`, every script executable
- **Installer edge cases:** missing repo, existing repo (idempotent re-run), missing Homebrew, missing PATH, user-modified configs, partial failure/recovery
- **Security:** expand `SECURITY.md` with the `curl | bash` trust model + download provenance/checksums; **add gitleaks to CI** (it's in the Brewfile but not yet a CI gate); document the forbidden-tools policy as a security control

**Estimated effort:** 4–7 h

---

### v2.0.0 — Fully Reproducible and Modular Mac Setup

**Goal:** Turn the two flat profiles into composable modules.

```text
core  shell  php  web  browsers  containers  database  productivity  design  ai  monitoring
```

```bash
mac setup --interactive          # module selector
mac setup --module ai
mac doctor --module php          # builds on v1.2.0 drift detection
mac list ; mac info raycast ; mac status
mac backup ; mac restore ; mac diff
```

Every module stays: readable, optional when personal, idempotent, documented, reversible, testable, secret-free, replaceable.

**Estimated effort:** 8–15 h

---

## Tool Classification

### Already installed — needs documentation/configuration only

Stats, Ice (`jordanbaird-ice`), KeeWeb, Ukulele, lsd, autojump, glances, ctop, CodexBar, claude-monitor, swaks, terminal-notifier, libpq, uv.

Vial was removed from the installed profile after Homebrew deprecated the cask
for failing Gatekeeper checks. Re-evaluate it only if the cask becomes trusted
again or a safer installation path is documented.

### High-priority new integration

Xdebug, PCOV, Pest, **PHPStan** (already chosen via VS Code extension), Raycast, Claude Code, Codex CLI, Insomnia/Bruno, external uptime monitoring, `jq`, `fzf`, `fd`, `ripgrep`, `mkcert`.

### Integrate after testing

Ollama, CleanShot X, Obsidian, Chrome, Firefox (or Dev Edition), Arc, Excalidraw, GIMP, ImageMagick, SwiftBar, Uptime Kuma, Proxyman, mise, PHP-CS-Fixer, Rector, Infection, httpie/xh, Bruno, Sentry, Better Stack/UptimeRobot, Netdata.

### Document as web services (not installed)

remove.bg, RealFaviconGenerator.

### ❌ Forbidden by `hardening.sh` (do not add without reversing policy)

`lazygit`, `watchexec`, `hyperfine`, `direnv`, `mas`, `orbctl`.

---

## Recommended Execution Order

| # | Version | Goal | Estimate |
| ---: | --- | --- | ---: |
| 1 | `v1.0.0` | **Ship** the first stable release | 2–3 h |
| 2 | `v1.1.0` | Document installed-but-undocumented tools + fix inventory | 2–4 h |
| 3 | `v1.2.0` | Smarter `doctor` + drift detection | 3–5 h |
| 4 | `v1.3.0` | PHP/Symfony toolchain (Xdebug, PCOV, PHPStan, Pest…) | 5–8 h |
| 5 | `v1.4.0` | API clients, browsers, curated CLI additions | 4–6 h |
| 6 | `v1.5.0` | Raycast, CleanShot, Obsidian, design | 4–7 h |
| 7 | `v1.6.0` | Claude, Codex, Ollama, AI workflow | 4–7 h |
| 8 | `v1.7.0` | VPS & website monitoring | 5–9 h |
| 9 | `v1.8.0` | Branding, screenshots, diagrams | 5–10 h |
| 10 | `v1.9.0` | Backup, restore, migration | 6–10 h |
| 11 | `v1.10.0` | Expand tests & security hardening | 4–7 h |
| 12 | `v2.0.0` | Modular architecture | 8–15 h |

## Global Estimate

- Through `v1.4.0` (shipped 1.0 + smart doctor + full PHP stack): **~16–26 h**
- Through `v1.8.0`: **~34–59 h**
- Through `v2.0.0`: **~52–91 h**

MacDevSetup is no longer only a dotfiles repository. It is becoming a documented, self-checking provisioning platform for a complete Mac workstation — built on a curation contract that the tooling itself enforces.
