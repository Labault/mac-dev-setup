# Development CLI tools

Keep shared tools in Homebrew and project versions in the project. This avoids
depending on a binary bundled inside an editor or an AI desktop app.

| Tool | Profile | Purpose |
| --- | --- | --- |
| `git` | Both | A Homebrew-managed Git version |
| `jq` | Both | Inspect and transform JSON |
| `ripgrep` (`rg`) | Both | Search source trees, respecting ignore files |
| `fnm` | Full | Select the Node.js version required by a project |
| `git-filter-repo` | Full | Deliberate history rewrites, with a separate backup |
| `shfmt` | Full | Format shell scripts |
| `uv` | Full | Manage Python environments and isolated CLI tools |

## Node.js: shared tooling and project runtimes

Homebrew `node` remains in both profiles for shared tooling. It follows the
Homebrew release channel and can change major version during upgrades.

The full profile installs `fnm` without selecting or downloading a Node version.
To opt in, add this to `~/.shell/local.zsh`, which survives `mac setup`:

```zsh
if command -v fnm >/dev/null 2>&1; then
  eval "$(fnm env --use-on-cd --shell zsh)"
fi
```

Remove any duplicate `fnm env` initialization from your personal `.zshrc` after
moving it. The managed `.zshrc` loads `~/.shell/local.zsh`.

Keep the required version in each project's `.node-version` or `.nvmrc`. From
that project, install and select its version explicitly:

```bash
fnm install
fnm use
node --version
npm --version
npm prefix -g
```

Global npm packages belong to the selected Node installation. Updating Homebrew
Node does not update a Node installation managed by `fnm`, or its global packages.
See the [fnm shell setup](https://github.com/Schniz/fnm#shell-setup).

## Python and shell tools

Use `uv` environments or `uv tool` for Python CLI applications; keep project
dependencies in their own environment. Installing `uv` does not install an
application or select a project Python version.

`shfmt` is available for explicit formatting. It does not introduce an automatic
repository-wide rewrite or a new pre-commit hook.

```bash
git --version
git filter-repo --version
jq --version
rg --version
shfmt --version
uv --version
```

## PHP remains a project decision

The full profile's `php` formula also follows Homebrew's current release channel.
Match each project's PHP requirement in its container or chosen local runtime
before upgrading. This setup does not pin every project to the host PHP version.

---

[← Docs index](../README.md) · [Project README](../../README.md)
