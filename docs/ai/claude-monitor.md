# claude-monitor

## Overview

`claude-monitor` is installed as a runtime-managed tool through `uv`.

It is used to monitor Claude usage from the command line without adding a separate Homebrew formula to the profiles.

## Installation

The full profile declares:

```ruby
uv "claude-monitor"
```

Install or refresh it manually with:

```bash
uv tool install claude-monitor
```

Verify the installation:

```bash
uv tool list
```

## Updates

Upgrade the tool with:

```bash
uv tool upgrade claude-monitor
```

## Secrets

Do not commit authentication tokens, account state, cache files, or exported usage data.

Keep any generated files local unless they are explicitly scrubbed and useful as documentation.

## Rollback

Remove claude-monitor with:

```bash
uv tool uninstall claude-monitor
```
