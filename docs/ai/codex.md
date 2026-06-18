# Codex CLI

## Overview

[Codex CLI](https://github.com/openai/codex) is an agentic coding tool by
OpenAI that operates directly in the terminal. It reads the project context,
proposes file changes, runs commands, and iterates until the task is complete.

It is installed globally via npm and is not declared in the Brewfile.

## Installation

Requires Node.js (already part of this setup). Install Codex globally:

```bash
npm install -g @openai/codex
```

Verify the installation:

```bash
codex --version
```

Codex authenticates with an OpenAI API key. Set the key in your shell
environment (do not commit it):

```bash
export OPENAI_API_KEY="..."
```

Add this export to `~/.shell/local.zsh` (gitignored) so it is available in
every session without being versioned.

## Basic usage

Run Codex in any project directory:

```bash
codex "add input validation to the registration form"
```

Codex reads the surrounding files, proposes changes, and asks for approval
before writing anything. Review each diff before accepting.

Useful flags:

```bash
codex --help
codex "task description" --model gpt-4o
```

## Workflow

Codex works best on well-scoped, atomic tasks:

- One feature or fix per session.
- Clear, specific instructions referencing file names or class names when
  possible.
- Always review the proposed diff before approving.
- Commit immediately after a successful change so the history stays clean.

## Comparison with Claude Code

| Aspect | Codex CLI | Claude Code |
| --- | --- | --- |
| Provider | OpenAI | Anthropic |
| Model | GPT-4o (default) | Claude Sonnet / Opus |
| Auth | `OPENAI_API_KEY` env var | Anthropic account |
| Billing | OpenAI API usage | Anthropic subscription or API |
| Project instructions | `AGENTS.md` | `.claude/CLAUDE.md` |

Use whichever fits the task or the model you prefer. Both tools can coexist in
the same project.

## Per-project configuration

Codex reads `AGENTS.md` from the project root if it exists:

```text
my-project/
  AGENTS.md      # project-specific instructions for Codex
  .claude/
    CLAUDE.md    # project-specific instructions for Claude Code
```

## Security

- The `OPENAI_API_KEY` must never be committed to any repository.
- Store it in `~/.shell/local.zsh` or a secrets manager.
- Codex operates with the permissions of the current user. Review all proposed
  changes before approving.
- Do not run Codex with auto-approve in a production environment.

## Uninstall

Remove Codex with npm:

```bash
npm uninstall -g @openai/codex
```
