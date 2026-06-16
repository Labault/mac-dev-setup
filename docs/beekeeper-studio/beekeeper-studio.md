# Beekeeper Studio

## Overview

Beekeeper Studio is a graphical database client used to connect to, inspect, query, and administer relational databases.

It is the database administration tool selected for this setup.

Beekeeper Studio is installed through Homebrew Cask and declared in the project `Brewfile`.

## Installation

Install all applications and tools declared in the `Brewfile`:

```bash
brew bundle --file=Brewfile
```

Verify the Homebrew installation:

```bash
brew list --cask | grep -x beekeeper-studio
```

Verify that the application is present:

```bash
test -d "/Applications/Beekeeper Studio.app" \
  && echo "Beekeeper Studio application found."
```

Display the Homebrew package information:

```bash
brew info --cask beekeeper-studio
```

Open the application:

```bash
open -a "Beekeeper Studio"
```

## Supported use cases

Beekeeper Studio can be used for tasks such as:

- creating and managing database connections;
- browsing schemas, tables, views, and columns;
- running SQL queries;
- editing table data;
- inspecting indexes and constraints;
- exporting query results;
- managing local and remote development databases.

Database features may vary depending on the selected database engine.

## Creating a connection

A database connection usually requires:

```text
Connection type
Host
Port
Database name
Username
Password
SSL configuration
```

For a local Docker or OrbStack database, the host is commonly:

```text
127.0.0.1
```

The port must match the port exposed by the container.

Example Docker inspection commands:

```bash
docker ps
docker compose ps
```

## Connection URLs

Some projects provide a single database URL instead of separate connection fields.

Example format:

```text
postgresql://username:password@127.0.0.1:5432/database_name
```

For Symfony projects, the value may be stored in an environment variable such as:

```text
DATABASE_URL
```

Do not commit real credentials or production connection strings to the repository.

## SSH tunnels

For remote databases that are not exposed publicly, use an SSH tunnel when supported.

Typical SSH information includes:

```text
SSH host
SSH port
SSH username
SSH private key
Remote database host
Remote database port
```

Private keys and credentials must remain outside the repository.

Direct public exposure of a production database should be avoided.

## SSL connections

Production or hosted databases may require SSL.

Depending on the provider, the connection may require:

- SSL enabled;
- certificate verification;
- a certificate authority file;
- a client certificate;
- a client private key.

Use the settings provided by the database host rather than disabling certificate verification without understanding the consequences.

## Local application data

Beekeeper Studio may store local settings and connection information inside the user Library directory.

Possible locations can be inspected with:

```bash
find "$HOME/Library/Application Support" \
  -maxdepth 1 \
  -iname '*beekeeper*' \
  -print
```

Additional related files can be searched with:

```bash
find "$HOME/Library" \
  -maxdepth 3 \
  -iname '*beekeeper*' \
  -print 2>/dev/null
```

The exact paths may vary between application versions.

## Backup before migration or removal

Close Beekeeper Studio before copying its application data:

```bash
osascript -e 'quit app "Beekeeper Studio"' 2>/dev/null || true
```

Create a backup directory:

```bash
mkdir -p "$HOME/Documents/Backups"
```

First identify the actual application data directory:

```bash
find "$HOME/Library/Application Support" \
  -maxdepth 1 \
  -iname '*beekeeper*' \
  -print
```

Then copy the existing directory using the exact path returned by the previous command.

Example:

```bash
cp -a \
  "$HOME/Library/Application Support/<actual-beekeeper-directory>" \
  "$HOME/Documents/Backups/Beekeeper-Studio"
```

Do not assume a directory name before verifying that it exists.

## Credential safety

Database credentials must not be stored in:

- committed configuration files;
- shell history;
- documentation examples;
- screenshots published online;
- shared SQL files;
- GitHub Actions logs.

Prefer:

- local environment files excluded by Git;
- a password manager;
- short-lived credentials;
- read-only accounts when write access is unnecessary;
- separate accounts for development and production.

Before sharing a screenshot, verify that it does not expose hosts, usernames, database names, tokens, or query results containing sensitive data.

## Production precautions

Before connecting to a production database:

- confirm that the selected connection is the correct one;
- prefer a read-only database user;
- disable automatic commits when appropriate;
- review `UPDATE`, `DELETE`, `DROP`, and migration queries carefully;
- create or verify backups before destructive operations;
- avoid editing production data directly unless necessary.

A graphical interface makes database operations easier, but it does not make destructive SQL safer.

## Troubleshooting

Open the application manually:

```bash
open -a "Beekeeper Studio"
```

Verify the application path:

```bash
ls -ld "/Applications/Beekeeper Studio.app"
```

Verify that the target database port is reachable:

```bash
nc -vz 127.0.0.1 <port>
```

Inspect running Docker containers:

```bash
docker ps
```

For a Docker Compose project:

```bash
docker compose ps
docker compose logs <database-service>
```

Test the same credentials with the database engine's command-line client when available.

## Rollback

Remove Beekeeper Studio with Homebrew:

```bash
brew uninstall --cask beekeeper-studio
```

Homebrew may not remove all local settings or connection data stored in the user Library directory.

Review those files manually before deleting them:

```bash
find "$HOME/Library" \
  -maxdepth 3 \
  -iname '*beekeeper*' \
  -print 2>/dev/null
```

Do not delete local application data until any useful connections or configuration have been backed up.
