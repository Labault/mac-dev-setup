# Firefox

## Overview

[Firefox](https://www.mozilla.org/firefox/) is the secondary browser in this setup,
used for cross-browser testing. Its Gecko rendering engine behaves differently from
Chrome's Blink in edge cases related to CSS layout, form behaviour, and JavaScript
APIs.

It is installed through Homebrew and declared in the project `Brewfile`.

## Installation

It is part of the curated Homebrew environment; see [`Homebrew setup`](../homebrew/homebrew.md) to install everything at once.

Install Firefox directly:

```bash
brew install --cask firefox
```

Verify the installation:

```bash
brew list --cask | grep -x firefox
```

## Cross-browser testing workflow

Use Firefox as a second pass after validating the golden path in Chrome:

1. Open the page in Firefox.
2. Check layout consistency (Grid, Flexbox, custom properties).
3. Check form behaviour (date inputs, validation messages).
4. Check font rendering and scroll behaviour.
5. Run the accessibility inspector.

## DevTools highlights

Firefox DevTools include tools not available in Chrome:

| Tool | Location |
| --- | --- |
| Grid Inspector | Elements → Grid overlay — visualises CSS Grid lines and areas |
| Flexbox Inspector | Elements → Flex overlay — shows flex item alignment |
| Accessibility Inspector | Accessibility tab — full accessibility tree with role and name |
| Font Inspector | Inspector → Fonts — shows the resolved font stack |

## Usage policy

Use Firefox for testing only. Do not synchronise a personal Firefox account to
the test browser instance. Keep personal browsing in a separate profile or
browser to avoid mixing usage data.

## Rollback

Remove Firefox with Homebrew:

```bash
brew uninstall --cask firefox
```

Then remove its entry from `profiles/full/Brewfile`.

Firefox profile data lives in `~/Library/Application Support/Firefox` and is
not removed by the cask uninstall.
