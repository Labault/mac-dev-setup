# uv

## Overview

[uv](https://docs.astral.sh/uv/) is a fast Python package and tool manager.

This setup uses it for Python-based command-line tools that should not be installed into the system Python.

## Installation

Install uv directly:

```bash
brew install uv
```

Verify the installation:

```bash
uv --version
brew list --formula | grep -x uv
```

## Tool usage

Install a Python CLI as an isolated tool:

```bash
uv tool install <package>
```

List installed tools:

```bash
uv tool list
```

Upgrade a tool:

```bash
uv tool upgrade <package>
```

## Project usage

uv can also manage Python project dependencies, but this repository currently uses it mainly as a tool runner.

Keep project-specific Python decisions inside the project that needs them.

## Rollback

Remove uv with:

```bash
brew uninstall uv
```

Remove uv-managed tools separately:

```bash
uv tool uninstall <package>
```
