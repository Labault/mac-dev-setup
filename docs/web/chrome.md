# Google Chrome

## Overview

[Google Chrome](https://www.google.com/chrome/) is the primary development browser
in this setup. It provides the most comprehensive DevTools suite and is the
reference browser for Lighthouse audits.

It is installed through Homebrew and declared in the project `Brewfile`.

## Installation

It is part of the curated Homebrew environment; see [`Homebrew setup`](../homebrew/homebrew.md) to install everything at once.

Install Chrome directly:

```bash
brew install --cask google-chrome
```

Verify the installation:

```bash
brew list --cask | grep google-chrome
```

## Profiles

Use separate Chrome profiles to avoid mixing personal browsing data with
development work:

- **Personal profile** — personal Google account, bookmarks, and extensions.
- **Dev profile** — development extensions only; no personal account required.

Create a new profile from the avatar menu in the top-right corner.

## DevTools

Open DevTools with `Cmd+Option+I` or `F12`.

Key panels for web development:

| Panel | Use |
| --- | --- |
| Elements | Inspect and edit the live DOM and CSS |
| Console | Run JavaScript, read logs and errors |
| Network | Inspect HTTP requests, headers, payloads, timing |
| Sources | Set breakpoints and step through JavaScript |
| Application | Inspect cookies, localStorage, service workers |
| Performance | Record and profile rendering and scripting |

## Lighthouse

Lighthouse audits performance, accessibility, best practices, and SEO.

Run an audit from DevTools → Lighthouse tab, or from the command line:

```bash
npx lighthouse https://example.com --view
```

## Recommended extensions (dev profile only)

Install extensions in the dev profile only. Keep the number small to reduce
attack surface and startup time.

| Extension | Purpose |
| --- | --- |
| axe DevTools | Accessibility audit directly in DevTools |
| JSON Formatter | Readable JSON in the browser |
| React / Vue DevTools | Component tree inspection (install only what the project uses) |

Never install extensions that request access to all sites or that handle
authentication tokens unless the source is verified.

## Rollback

Remove Chrome with Homebrew:

```bash
brew uninstall --cask google-chrome
```

Then remove its entry from `profiles/full/Brewfile`.

Chrome user data (profiles, history, extensions) lives in
`~/Library/Application Support/Google/Chrome` and is not removed by the cask
uninstall.
