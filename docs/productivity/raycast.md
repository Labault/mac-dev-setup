# Raycast

[Raycast](https://www.raycast.com/) is a productivity launcher that replaces
Spotlight. It provides instant app launching, clipboard history, text snippets,
window management, and a large extension ecosystem.

It is installed through Homebrew and declared in the project `Brewfile`.

## Installation

It is part of the curated Homebrew environment; see [`Homebrew setup`](../homebrew/homebrew.md) to install everything at once.

Install Raycast directly:

```bash
brew install --cask raycast
```

After installation, open Raycast and follow the onboarding to disable Spotlight
(`System Settings → Keyboard → Keyboard Shortcuts → Spotlight`) and set
`Cmd+Space` as the Raycast hotkey.

## Core features

### App launcher

Type any app name to open it. Raycast indexes installed apps faster than
Spotlight and supports fuzzy matching.

### Clipboard history

`Cmd+Shift+V` (default) opens the clipboard history. Search and paste any
previously copied item, including images and files.

### Snippets

Define text snippets with a keyword trigger. Type the keyword anywhere to
expand it:

```text
;addr  →  123 Rue de la Paix, 75001 Paris
;sig   →  Cordialement, ...
```

### Window management

Raycast includes built-in window management without requiring a separate app
(Rectangle, Magnet). Assign keyboard shortcuts to tile windows left, right,
maximise, or move between displays.

Disable any third-party window manager before enabling Raycast window
management to avoid conflicts.

### Quicklinks

Create quicklinks to open URLs with a search query:

```text
gh <repo>  →  https://github.com/search?q={query}
mdn <term> →  https://developer.mozilla.org/search?q={query}
```

## Extensions

The Raycast extension store provides integrations with common developer tools.
Install only extensions you actively use — each extension runs in the Raycast
process.

Useful extensions for this setup:

| Extension | Purpose |
| --- | --- |
| GitHub | Search repos, open PRs, manage issues |
| OrbStack | Start and stop containers from Raycast |
| Google Chrome | Search open tabs, bookmarks |

## Configuration versioning

Raycast settings can be exported from `Raycast Preferences → Advanced → Export`.
The export file is safe to commit (it contains no secrets if snippets and
quicklinks are kept secret-free).

Store the export at `configs/raycast/raycast-settings.rayconfig`.

## Rollback

Uninstall Raycast and re-enable Spotlight:

```bash
brew uninstall --cask raycast
```

Re-enable Spotlight from `System Settings → Keyboard → Keyboard Shortcuts →
Spotlight → Show Spotlight search`.
