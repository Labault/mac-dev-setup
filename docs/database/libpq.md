# libpq

[libpq](https://www.postgresql.org/docs/current/libpq.html) provides PostgreSQL client libraries and command-line tools without installing the full PostgreSQL server.

It is included for projects that need `psql`, `pg_dump`, client headers, or Composer packages that compile against PostgreSQL libraries.

The tool is installed through Homebrew and declared in the project `Brewfile`.

## Installation

It is part of the curated Homebrew environment; see [`Homebrew setup`](../homebrew/homebrew.md) to install everything at once.

Install libpq directly:

```bash
brew install libpq
```

Verify the installation:

```bash
brew list --formula | grep -x libpq
brew --prefix libpq
```

## Command-line tools

Homebrew installs libpq as keg-only. Use the full path when needed:

```bash
$(brew --prefix libpq)/bin/psql --version
$(brew --prefix libpq)/bin/pg_dump --version
```

Add it to `PATH` only when a project or workflow really needs global PostgreSQL client commands.

## Build flags

Some native extensions may need explicit flags:

```bash
export LDFLAGS="-L$(brew --prefix libpq)/lib"
export CPPFLAGS="-I$(brew --prefix libpq)/include"
```

Keep those exports project-local when possible.

## Rollback

Remove libpq with:

```bash
brew uninstall libpq
```

---

[← Docs index](../README.md) · [Project README](../../README.md)
