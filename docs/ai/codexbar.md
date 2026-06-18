# CodexBar

## Overview

[CodexBar](https://codexbar.app/) is a macOS menu bar app that tracks usage and
costs for AI coding tools, including Claude and Codex. It provides a quick
at-a-glance view of token consumption and spend without leaving the desktop.

It is installed through Homebrew and declared in the project `Brewfile`.

## Installation

It is part of the curated Homebrew environment; see [`Homebrew setup`](../homebrew/homebrew.md) to install everything at once.

Install CodexBar directly:

```bash
brew install --cask codexbar
```

After installation, open CodexBar from the Applications folder. It appears in
the menu bar and starts tracking usage automatically once configured.

## Configuration

CodexBar connects to AI provider APIs using your credentials:

- **Claude / Anthropic** — provide your Anthropic API key or account token.
- **OpenAI / Codex** — provide your OpenAI API key.

Enter credentials in CodexBar preferences. Keys are stored in the macOS
Keychain and are never committed to any repository.

## What it tracks

| Metric | Description |
| --- | --- |
| Token usage | Input, output, and cached tokens per session |
| Estimated cost | Real-time cost estimate based on provider pricing |
| Daily / monthly totals | Cumulative usage across sessions |
| Model breakdown | Usage split by model (Sonnet, Opus, GPT-4o, etc.) |

## Relationship with claude-monitor

| Tool | Interface | Scope |
| --- | --- | --- |
| CodexBar | Menu bar, always visible | Multi-provider, persistent |
| claude-monitor | Terminal, run on demand | Claude Code sessions only |

Use CodexBar for a persistent overview of total spend. Use claude-monitor for
real-time token tracking during an active Claude Code session.

## Rollback

Remove CodexBar with Homebrew:

```bash
brew uninstall --cask codexbar
```

Then remove its entry from `profiles/full/Brewfile`.

Credentials stored in the macOS Keychain are not removed automatically. Remove
them manually from `Keychain Access` if needed.
