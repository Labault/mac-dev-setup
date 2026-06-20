# Visual Assets Roadmap

This roadmap tracks the screenshots and images to add across the repository.
The goal is to make the project easier to understand visually without making
the repository heavy.

Last synced with the repository documentation on 2026-06-20.

## Capture Rules

- Prefer `.webp` for screenshots and `.png` only when text sharpness is better.
- Keep screenshots at `1200px` wide maximum.
- Aim for `100-400 KB` per image, with `800 KB` as a hard ceiling.
- Use kebab-case filenames.
- Hide personal data: usernames, hostnames, private paths, tokens, project names,
  email addresses, internal URLs, and API keys.
- Capture focused windows, not the full desktop, unless the macOS setting itself
  needs context.
- Keep terminal screenshots visually consistent: same theme, same font size, and
  similar window width.
- Add a short alt text when inserting each image in Markdown.

## Validation Checklist

Each image should be reviewed before it is added to a documentation page:

- The image explains a real feature or workflow.
- Text is readable at GitHub README width.
- No private or distracting information is visible.
- The filename and destination match this roadmap.
- The file size is reasonable.
- The surrounding Markdown references the image with useful alt text.

## Current Status

All actioned roadmap assets are present in the repository.

## Phase 1 - Core Repository Story

These images should be created first. They give the README and main setup flow a
clear visual identity.

| Priority | Asset | Path | Used in | What to show |
| --- | --- | --- | --- | --- |
| P0 | CLI help | `docs/assets/screenshots/readme/mac-help.webp` | `README.md` | `mac help` output with the command list visible. |
| P0 | Setup dry run | `docs/assets/screenshots/readme/mac-setup-dry-run.webp` | `README.md` | `mac setup --dry-run` showing planned actions without changes. |
| P0 | Doctor report | `docs/assets/screenshots/readme/mac-doctor.webp` | `README.md`, `docs/troubleshooting/troubleshooting.md` | `mac doctor` showing a clean or useful diagnostic report. |
| P2 | Doctor fix summary | `docs/assets/screenshots/troubleshooting/mac-doctor-fix-summary.webp` | `docs/troubleshooting/troubleshooting.md` | `mac doctor --fix --summary` showing compact diagnostic and fix suggestions. |
| P0 | Setup walkthrough | `docs/assets/screenshots/setup/setup-flow.webp` | `docs/setup/setup.md` | A terminal section showing install, shell reload, and `mac setup`. |
| P0 | Profile selection | `docs/assets/screenshots/setup/setup-profile.webp` | `docs/setup/setup.md` | `mac setup --profile minimal --dry-run` or `full` profile preview. |

## Phase 2 - CLI Experience

These screenshots make the custom `mac` command feel tangible.

| Priority | Asset | Path | Used in | What to show |
| --- | --- | --- | --- | --- |
| P1 | Command completion | `docs/assets/screenshots/cli/mac-completion.webp` | `docs/zsh/zsh.md` | Terminal completion for `mac <Tab>` or command suggestions. |
| P1 | PHP helper | `docs/assets/screenshots/cli/mac-php-xdebug.webp` | `docs/php/xdebug.md`, `docs/php/php.md` | `mac php xdebug status` with enabled/disabled state. |
| P1 | Update preview | `docs/assets/screenshots/cli/mac-update-dry-run.webp` | `README.md` or `docs/setup/setup.md` | `mac update --dry-run` showing the safety behavior. |
| P1 | Uninstall preview | `docs/assets/screenshots/cli/mac-uninstall-dry-run.webp` | `docs/setup/setup.md` | `mac uninstall --dry-run` showing what would be removed. |

## Phase 3 - Shell And Terminal Polish

Use these to show the day-to-day terminal experience after installation.

| Priority | Asset | Path | Used in | What to show |
| --- | --- | --- | --- | --- |
| P1 | Zsh prompt | `docs/assets/screenshots/zsh/powerlevel10k-prompt.webp` | `docs/zsh/powerlevel10k.md`, `docs/zsh/zsh.md` | A clean terminal prompt with Git branch/status visible. |
| P1 | Aliases in use | `docs/assets/screenshots/zsh/aliases.webp` | `docs/zsh/zsh.md` | A short example of an alias improving a common command. |
| P2 | Antidote plugins | `docs/assets/screenshots/zsh/antidote-plugins.webp` | `docs/zsh/antidote.md` | Plugin list or install/update output. |
| P2 | Warp terminal | `docs/assets/screenshots/apps/warp-terminal.webp` | `docs/warp/warp.md` | Warp running a `mac` command or showing command blocks. |

## Phase 4 - Homebrew And Inventory

These are useful for explaining what gets installed and how drift is checked.

| Priority | Asset | Path | Used in | What to show |
| --- | --- | --- | --- | --- |
| P1 | Brew bundle check | `docs/assets/screenshots/homebrew/brew-bundle-check.webp` | `docs/homebrew/homebrew.md` | `brew bundle check --file profiles/full/Brewfile`. |
| P1 | Inventory overview | `docs/assets/screenshots/homebrew/inventory-overview.webp` | `docs/homebrew/inventory.md` | A readable excerpt of package categories or counts. |
| P2 | Minimal vs full profile | `docs/assets/images/profile-comparison.webp` | `README.md`, `docs/homebrew/inventory.md` | Simple visual comparison of `minimal` and `full`. Source SVG at `docs/assets/images/profile-comparison.svg`. |

## Phase 5 - macOS Features

These screenshots explain the visual macOS integrations better than text alone.
The menu bar docs now live in one consolidated page:
`docs/macos/menu-bar.md`, covering Ice, Stats, and SwiftBar.

| Priority | Asset | Path | Used in | What to show |
| --- | --- | --- | --- | --- |
| P0 | Menu bar overview | `docs/assets/screenshots/macos/menu-bar-overview.webp` | `docs/macos/menu-bar.md`, `README.md` | A focused macOS menu bar showing Ice, Stats, and SwiftBar together. |
| P0 | SwiftBar status dropdown | `docs/assets/screenshots/macos/menu-bar-swiftbar-status.webp` | `docs/macos/menu-bar.md#swiftbar`, `README.md` | SwiftBar menu item and dropdown showing demo site status. |
| P1 | macOS defaults | `docs/assets/screenshots/macos/finder-defaults.webp` | `docs/macos/macos-defaults.md` | Finder after defaults are applied, with visible useful settings. |
| P1 | Keyboard layout | `docs/assets/screenshots/macos/french-oss-keyboard.webp` | `docs/keyboard/french-oss.md` | macOS keyboard input source list with Francais OSS Mac. |
| P1 | Stats menu bar | `docs/assets/screenshots/macos/stats-menu.webp` | `docs/macos/menu-bar.md#stats` | Stats menu bar widgets or dropdown. |
| P1 | Ice menu bar | `docs/assets/screenshots/macos/ice-menu-bar.webp` | `docs/macos/menu-bar.md#ice` | Before/after or compact menu bar organization. |
| P2 | Pearcleaner uninstall | `docs/assets/screenshots/macos/pearcleaner.webp` | `docs/macos/pearcleaner.md` | App cleanup screen with generic app example. |
| P2 | Terminal notifier | `docs/assets/screenshots/macos/terminal-notifier.webp` | `docs/macos/terminal-notifier.md` | macOS notification triggered from terminal. |

## Phase 6 - Editors And Productivity Apps

These should be clean app-window screenshots with no personal workspaces open.

| Priority | Asset | Path | Used in | What to show |
| --- | --- | --- | --- | --- |
| P1 | VS Code extensions | `docs/assets/screenshots/apps/vscode-extensions.webp` | `docs/vscode/vscode.md` | Extensions view showing a few curated installed extensions. |
| P1 | VS Code settings | `docs/assets/screenshots/apps/vscode-settings.webp` | `docs/vscode/vscode.md` | Settings JSON or UI showing managed editor preferences. |
| P1 | Raycast launcher | `docs/assets/screenshots/apps/raycast-launcher.webp` | `docs/productivity/raycast.md` | Raycast command palette with a useful command. |
| P2 | Obsidian workspace | `docs/assets/screenshots/apps/obsidian-workspace.webp` | `docs/productivity/obsidian.md` | Clean demo vault or generic notes workspace. |
| P2 | Notion workspace | `docs/assets/screenshots/apps/notion-workspace.webp` | `docs/productivity/notion.md` | Empty or demo page, no private workspace data. |
| P2 | CleanShot annotation | `docs/assets/screenshots/apps/cleanshot-annotation.webp` | `docs/productivity/cleanshot.md` | A screenshot being annotated or exported. |
| P2 | GIMP export | `docs/assets/screenshots/apps/gimp-export.webp` | `docs/productivity/gimp.md` | Export dialog or image optimization workflow. |
| P3 | Sublime Text | `docs/assets/screenshots/apps/sublime-text.webp` | `docs/vscode/sublime-text.md` | Sublime editing a neutral config or Markdown file. |

## Phase 7 - Web, API, And Database Tools

Create these only with demo data or public example URLs.

| Priority | Asset | Path | Used in | What to show |
| --- | --- | --- | --- | --- |
| P1 | Bruno request | `docs/assets/screenshots/web/bruno-request.webp` | `docs/web/bruno.md` | A demo API request against `https://httpbin.org` or similar. |
| P1 | Browser devtools | `docs/assets/screenshots/web/chrome-devtools.webp` | `docs/web/chrome.md` | Chrome DevTools on a public demo page. |
| P2 | Firefox testing | `docs/assets/screenshots/web/firefox-testing.webp` | `docs/web/firefox.md` | Same public demo page in Firefox. |
| P2 | Excalidraw diagram | `docs/assets/screenshots/web/excalidraw-diagram.webp` | `docs/web/excalidraw.md` | A simple architecture sketch for MacDevSetup. |
| P2 | Favicons generated | `docs/assets/screenshots/web/favicons-result.webp` | `docs/web/favicons.md` | RealFaviconGenerator result page with generic input. |
| P2 | Image service before/after | `docs/assets/images/image-services-before-after.webp` | `docs/web/image-services.md` | Before/after example using non-private sample image. |
| P2 | Beekeeper Studio | `docs/assets/screenshots/apps/beekeeper-studio.webp` | `docs/database/beekeeper-studio.md` | Demo SQLite/PostgreSQL connection with fake data. |

## Phase 8 - Git, Quality, CI, And Containers

Terminal captures are enough for most of these. Keep them short and readable.
This phase now includes the Gitmoji convention page added under `docs/git/`.

| Priority | Asset | Path | Used in | What to show |
| --- | --- | --- | --- | --- |
| P1 | Git delta diff | `docs/assets/screenshots/git/git-delta-diff.webp` | `docs/git/git-delta.md`, `docs/git/git.md` | A small colored diff with syntax highlighting. |
| P1 | Gitmoji commit examples | `docs/assets/screenshots/git/gitmoji-log.webp` | `docs/git/gitmoji.md`, `README.md` | `git log --oneline` with a few sanitized Gitmoji + Conventional Commit messages. |
| P1 | Commitlint Gitmoji check | `docs/assets/screenshots/git/commitlint-gitmoji.webp` | `docs/git/gitmoji.md` | A small commitlint example showing the convention being enforced. |
| P1 | Pre-commit run | `docs/assets/screenshots/quality/pre-commit-run.webp` | `docs/pre-commit/pre-commit.md` | Successful hooks summary. |
| P1 | GitHub Actions CI | `docs/assets/screenshots/quality/github-actions-ci.webp` | `docs/github-actions/ci.md` | Green workflow summary in GitHub Actions. |
| P2 | Act local run | `docs/assets/screenshots/quality/act-run.webp` | `docs/github-actions/act.md` | Local workflow execution summary. |
| P2 | Actionlint output | `docs/assets/screenshots/quality/actionlint.webp` | `docs/github-actions/actionlint.md` | Clean command output or a small example error. |
| P2 | Shellcheck output | `docs/assets/screenshots/quality/shellcheck.webp` | `docs/shell/shellcheck.md` | A concise ShellCheck example. |
| P2 | Markdownlint output | `docs/assets/screenshots/quality/markdownlint.webp` | `docs/quality/markdownlint-cli2.md` | A clean or intentionally small example output. |
| P2 | Lychee link check | `docs/assets/screenshots/quality/lychee.webp` | `docs/quality/lychee.md` | Link check summary. |
| P2 | EditorConfig checker | `docs/assets/screenshots/quality/editorconfig-checker.webp` | `docs/quality/editorconfig-checker.md` | Clean check summary. |
| P2 | ctop containers | `docs/assets/screenshots/quality/ctop.webp` | `docs/docker/ctop.md` | Demo containers only. |
| P2 | OrbStack dashboard | `docs/assets/screenshots/apps/orbstack.webp` | `docs/docker/orbstack.md` | OrbStack dashboard with demo containers. |
| P3 | Hadolint output | `docs/assets/screenshots/quality/hadolint.webp` | `docs/docker/hadolint.md` | Small Dockerfile lint example. |

## Phase 9 - PHP And Symfony Tooling

Prefer terminal screenshots against a tiny demo project, not a private client
project.

| Priority | Asset | Path | Used in | What to show |
| --- | --- | --- | --- | --- |
| P1 | PHP version | `docs/assets/screenshots/php/php-version.webp` | `docs/php/php.md` | `php -v` and `composer --version`. |
| P1 | Xdebug mode | `docs/assets/screenshots/php/xdebug-status.webp` | `docs/php/xdebug.md` | `mac php xdebug status`. |
| P2 | Pest tests | `docs/assets/screenshots/php/pest-run.webp` | `docs/php/pest.md` | Passing Pest test run in a demo project. |
| P2 | Coverage summary | `docs/assets/screenshots/php/coverage-summary.webp` | `docs/php/coverage.md` | Small coverage report summary. |
| P2 | Static analysis | `docs/assets/screenshots/php/static-analysis.webp` | `docs/php/static-analysis.md` | PHPStan or Psalm successful output. |
| P2 | Coding standards | `docs/assets/screenshots/php/coding-standards.webp` | `docs/php/coding-standards.md` | PHP-CS-Fixer dry run or fix summary. |
| P3 | Mutation testing | `docs/assets/screenshots/php/mutation-testing.webp` | `docs/php/mutation-testing.md` | Infection summary from demo project. |

## Phase 10 - AI Tools

Use neutral prompts and avoid showing conversations, tokens, API keys, or
private repositories.

| Priority | Asset | Path | Used in | What to show |
| --- | --- | --- | --- | --- |
| P1 | Codex CLI | `docs/assets/screenshots/ai/codex-cli.webp` | `docs/ai/codex.md` | Codex help/version or a neutral demo task. |
| P1 | Claude desktop | `docs/assets/screenshots/ai/claude-desktop.webp` | `docs/ai/claude.md` | Claude app with a generic prompt, no private context. |
| P1 | CodexBar | `docs/assets/screenshots/ai/codexbar.webp` | `docs/ai/codexbar.md` | Menu bar cost/token overview with safe demo values. |
| P2 | Ollama run | `docs/assets/screenshots/ai/ollama-run.webp` | `docs/ai/ollama.md` | `ollama run` or `ollama list` with public model names. |

## Phase 11 - Architecture And Concept Images

These can be generated diagrams instead of screenshots. Keep them simple and
maintainable.

| Priority | Asset | Path | Used in | What to show |
| --- | --- | --- | --- | --- |
| P1 | CLI architecture | `docs/assets/images/cli-architecture.webp` | `docs/architecture/current-architecture.md` | Flow from `mac` entrypoint to command discovery and command scripts. |
| P2 | Scripts tree | `docs/assets/screenshots/architecture/scripts-tree.webp` | `docs/architecture/current-architecture.md` | `lsd --tree scripts/ --depth 2` showing commands, lib, and swiftbar layout. |
| P1 | Command discovery | `docs/assets/images/command-discovery.webp` | `docs/architecture/cli-discovery.md` | How command metadata and scripts become CLI commands. |
| P2 | Setup lifecycle | `docs/assets/images/setup-lifecycle.webp` | `docs/setup/setup.md` | Install, setup, doctor, update, uninstall lifecycle. |
| P2 | Managed files map | `docs/assets/images/managed-files.webp` | `README.md`, `docs/setup/setup.md` | Which user-level files are managed or backed up. |

## Phase 12 - Low-Value Or Optional Visuals

These pages do not need screenshots unless a specific visual example is useful.

| Priority | Page | Recommendation |
| --- | --- | --- |
| P3 | `docs/security/gitleaks.md` | `docs/assets/screenshots/security/gitleaks.webp` — terminal output with a fake secret. Used in `docs/security/gitleaks.md`. |
| P3 | `docs/security/keeweb.md` | Optional app screenshot with demo database only. |
| P3 | `docs/ssh/ssh.md` | Usually no screenshot; terminal commands are enough. |
| P3 | `docs/database/libpq.md` | Usually no screenshot; command examples are enough. |
| P3 | `docs/cli/bat.md` | `docs/assets/screenshots/cli/bat.webp` — `bat` rendering a file with line numbers and syntax highlighting. Used in `docs/cli/bat.md`. |
| P3 | `docs/cli/duf.md` | `docs/assets/screenshots/cli/duf.webp` — `duf` showing local macOS filesystems and disk usage. Used in `docs/cli/duf.md`. |
| P3 | `docs/cli/dust.md` | `docs/assets/screenshots/cli/dust.webp` — `dust` showing a compact disk usage tree. Used in `docs/cli/dust.md`. |
| P3 | `docs/cli/lsd.md` | `docs/assets/screenshots/cli/lsd.webp` — `lsd --tree docs/cli` showing Nerd Font icons and colors. Used in `docs/cli/lsd.md`. |
| P3 | `docs/cli/tree.md` | Optional `tree -L 2` output. |
| P3 | `docs/cli/tokei.md` | `docs/assets/screenshots/cli/tokei.webp` — `tokei .` run from the mac-dev-setup root showing the language breakdown table. Used in `docs/cli/tokei.md`. |
| P3 | `docs/cli/autojump.md` | Usually no screenshot; command examples are enough. |
| P3 | `docs/releases/*.md` | No screenshots needed. |
| P3 | `CHANGELOG.md`, `CONTRIBUTING.md`, `SECURITY.md` | No screenshots needed. |

## Suggested Review Order

Use this order when adding and validating screenshots:

1. Create Phase 1 images and validate them one by one.
2. Insert the approved Phase 1 images into `README.md` and `docs/setup/setup.md`.
3. Create the menu bar overview and SwiftBar dropdown from Phase 5.
4. Create the Gitmoji and commitlint images from Phase 8.
5. Create shell, Zsh, and Homebrew images from Phases 3 and 4.
6. Create app screenshots from Phases 6 and 7.
7. Create quality, CI, PHP, and AI screenshots only where they improve a page.
8. Add architecture diagrams after the screenshot style is stable.

## Per-Image Review Template

When reviewing an image, record:

```text
Image:
Destination:
Page(s):
Status: accepted / needs edits / skipped
Notes:
```

## Current First Batch

The original first batch is complete. Future image work should be driven by new
documentation changes or by the optional opportunities listed above, not by this
initial checklist.
