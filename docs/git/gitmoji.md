# Gitmoji

[Gitmoji](https://gitmoji.dev/) is a convention that prefixes each commit
message with an emoji describing the intent of the change. The emoji gives an
at-a-glance summary of what a commit does before you read the text.

This repository uses Gitmoji on top of
[Conventional Commits](https://www.conventionalcommits.org/), so every commit
follows the same shape and the history stays scannable.

## Commit format

Each commit header combines a Gitmoji, a Conventional Commit type, an optional
scope, and a subject:

```text
<emoji> <type>(<scope>): <subject>
```

Examples:

```text
✨ feat(php): manage xdebug config
📝 docs(readme): document installation and rollback
🐛 fix(doctor): correct the missing-tool exit code
🔧 chore(docs): stabilize swaks reference link
```

The scope is optional; the emoji, type, and subject are required.

## How it is enforced

The format is validated automatically by
[commitlint](https://commitlint.js.org/), configured in `commitlint.config.cjs`:

- it extends `@commitlint/config-conventional` and the `gitmoji` config;
- the header pattern (built from `@gitmoji/gitmoji-regex`) requires a leading
  Gitmoji — as a Unicode emoji (`✨`) or as its code (`:sparkles:`) — followed
  by a valid Conventional Commit type.

Commit messages are linted both locally (via the Husky `commit-msg` hook) and in
CI (the `Repository quality` job runs `commitlint`). A commit that omits the
emoji or uses an unknown type is rejected.

## Common Gitmoji in this repository

| Emoji | Type | Used for |
| --- | --- | --- |
| ✨ | `feat` | A new tool, command, or capability |
| 📝 | `docs` | Documentation only |
| 🐛 | `fix` | A bug fix |
| ✅ | `test` | Adding or updating tests |
| 🔧 | `chore` | Configuration and tooling changes |
| ♻️ | `refactor` | Restructuring without behavior change |
| 👷 | `ci` | CI workflow changes |
| 💄 | `style` | Formatting and cosmetic doc/UI changes |
| 🔒 | `security` | Fixing or hardening a security concern |
| ⬆️ | `chore` | Upgrading dependencies |
| 🔖 | `chore` | Version bump / release tag |
| 🙈 | `chore` | Adding or updating `.gitignore` |

The full list of emojis and their meanings lives at
[gitmoji.dev](https://gitmoji.dev/). When in doubt, pick the emoji whose
description on that page best matches the change.

## Writing a commit

Choose the emoji that matches the intent, then write a Conventional Commit
subject in the imperative mood:

```bash
git commit -m "✨ feat(cli): add a profile selection flag"
git commit -m "🐛 fix(setup): handle a missing Homebrew prefix"
```

Prefer small, atomic commits with one clear purpose, so a single emoji
describes the whole change.

## Optional: gitmoji-cli

[gitmoji-cli](https://github.com/carloscuesta/gitmoji-cli) is an interactive
helper that prompts for the emoji and message instead of typing them by hand.
It is **not** part of this setup and is **not** declared in the `Brewfile` —
the commitlint convention above is all you need. If you want it anyway, install
it yourself:

```bash
brew install gitmoji        # or: npm install -g gitmoji-cli
gitmoji --commit            # interactive commit
```

## Reference

- [gitmoji.dev](https://gitmoji.dev/) — searchable list of all emojis
- [Conventional Commits](https://www.conventionalcommits.org/) — the type/scope
  grammar layered under the emoji
- [commitlint](https://commitlint.js.org/) — the linter that enforces the format
