# Workstation audit

A Brewfile describes what a new setup should install. A workstation snapshot
describes what is present today. Keep these separate so an old receipt or an
experiment does not become a permanent dependency.

## Capture the installed state

Store dated machine reports under `.tmp/audit-YYYY-MM-DD/`, which is ignored by
Git. Do not commit machine identifiers, account details, container metadata, or
private configuration with the public setup documentation.

These commands inspect the local environment without installing packages:

```bash
sw_vers
uname -m
HOMEBREW_NO_AUTO_UPDATE=1 brew info --json=v2 --installed
HOMEBREW_NO_AUTO_UPDATE=1 brew list --formula --installed-on-request
HOMEBREW_NO_AUTO_UPDATE=1 brew list --cask
HOMEBREW_NO_AUTO_UPDATE=1 brew services list
mac doctor --summary
```

`mac doctor` compares explicitly installed formulae and casks with all profiles.
It excludes formulae installed only as dependencies. Extra packages need a human
decision: add an intentional shared tool, keep it local, or remove it separately.
An inventory failure is reported as a failure, not as an empty installation.

The selected profile is checked with `brew bundle check`. This checks Homebrew's
package state; it is not a complete application or version audit.

## Check current releases

Local metadata can be stale. Refresh it before an operational update review:

```bash
brew update
brew outdated --greedy
softwareupdate --list
```

`brew update` changes package metadata, not installed software. `--greedy`
includes casks that declare their own updater. For a strictly read-only audit,
compare a saved installed inventory with the public
[formula catalogue](https://formulae.brew.sh/api/formula.json) and
[cask catalogue](https://formulae.brew.sh/api/cask.json), saved outside Homebrew.
Check external taps separately.

Use the app bundle's `CFBundleShortVersionString` and `CFBundleVersion` as evidence
of what is actually installed. An app can update itself after Homebrew created
its receipt. Conversely, a receipt can remain after the `.app` was removed.
Compare build numbers and release channels before calling a difference an update.
Do not downgrade an app just to match an older catalogue entry.

For App Store apps, check the Mac entry and account eligibility. A public iOS
listing with the same name or bundle ID is not evidence of a Mac update.
Built-in Apple apps normally follow macOS updates. Check standalone CLI tools,
editor extensions, and npm globals through their own installation channel.

See the [Homebrew manual](https://docs.brew.sh/Manpage) for command details.

## Before applying changes

1. Review backups and the release notes for major runtime or macOS upgrades.
2. Choose packages explicitly. `mac update` updates this repository; it does not
    update the workstation. `mac setup` can install or upgrade profile packages
    and reapply managed configuration.
3. Compare differing shell files first. Put personal initialization such as
    `fnm env` in `~/.shell/local.zsh` before reapplying the managed `.zshrc`.
4. Keep application removal and data cleanup separate from an audit.
5. Record the commands actually run and distinguish failures from skipped checks.

Sandboxed diagnostics can report false permission errors or incomplete system
state. Confirm those results in an ordinary authorized terminal before treating
them as machine faults. In particular, never apply a recursive `chown` based
solely on a sandboxed `brew doctor` warning.

---

[← Docs index](../README.md) · [Homebrew](homebrew.md)
