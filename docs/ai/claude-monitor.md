# claude-monitor

## Overview

[claude-monitor](https://github.com/Maciek-roboblog/Claude-Code-Usage-Monitor)
is a command-line tool that tracks Claude API usage and costs in real time. It
reads the local Claude Code session data and displays token consumption,
estimated cost, and usage against your plan limits.

It is installed as a runtime-managed tool through `uv` and declared in the
full profile Brewfile.

## Installation

The full profile declares:

```ruby
uv "claude-monitor"
```

Install or refresh it manually:

```bash
uv tool install claude-monitor
```

Verify the installation:

```bash
uv tool list
```

## Usage

Run claude-monitor in a terminal alongside an active Claude Code session:

```bash
claude-monitor
```

The display refreshes automatically and shows:

- Tokens used in the current session (input / output / cache).
- Estimated cost based on current Anthropic pricing.
- Usage against your plan limits when applicable.

Run with a specific refresh interval (in seconds):

```bash
claude-monitor --interval 5
```

## Updates

Upgrade claude-monitor to the latest version:

```bash
uv tool upgrade claude-monitor
```

## Secrets and privacy

claude-monitor reads local session files written by Claude Code. It does not
send data to any external service. Do not commit session files, usage exports,
or cache data to any repository.

## Rollback

Remove claude-monitor with:

```bash
uv tool uninstall claude-monitor
```

Then remove the `uv "claude-monitor"` line from `profiles/full/Brewfile`.
