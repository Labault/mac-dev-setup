# OrbStack

## Overview

[OrbStack](https://orbstack.dev/) provides a lightweight Docker and Linux environment for macOS.

It is used in this setup as the local container runtime instead of Docker Desktop.

OrbStack is installed through Homebrew Cask and declared in the project `Brewfile`.

## Installation

Install all applications and tools declared in the `Brewfile`:

```bash
brew bundle --file=Brewfile
```

Verify the Homebrew installation:

```bash
brew list --cask | grep -x orbstack
```

Verify that the macOS application is present:

```bash
test -d "/Applications/OrbStack.app" \
  && echo "OrbStack application found."
```

## CLI verification

Check the installed OrbStack version:

```bash
orbctl version
```

Verify the active Docker context:

```bash
docker context show
```

The expected context is:

```text
orbstack
```

Verify the Docker client and server:

```bash
docker version
```

Both the macOS Docker client and the OrbStack Linux server should be available.

## Docker usage

Standard Docker commands work through OrbStack:

```bash
docker ps
docker images
docker compose version
```

Run a basic container test:

```bash
docker run --rm hello-world
```

OrbStack must be running before Docker commands can connect to its engine.

## Context management

List the available Docker contexts:

```bash
docker context ls
```

Switch explicitly to OrbStack:

```bash
docker context use orbstack
```

The previously active context can be restored with:

```bash
docker context use default
```

Only switch to `default` when another Docker engine is installed and running.

## Start and stop

Start OrbStack:

```bash
orbctl start
```

Stop OrbStack:

```bash
orbctl stop
```

Check its current state:

```bash
orbctl status
```

## Troubleshooting

Confirm the active Docker context:

```bash
docker context show
```

Restart OrbStack:

```bash
orbctl stop
orbctl start
```

Check whether the Docker engine responds:

```bash
docker info
```

If Docker still cannot connect, open the OrbStack macOS application and verify that its services are running.

## Rollback

Remove OrbStack with Homebrew:

```bash
brew uninstall --cask orbstack
```

Before uninstalling, back up any important containers, images, volumes, or Linux machines managed by OrbStack.
