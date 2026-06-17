# OrbStack

OrbStack provides a lightweight local environment for running Docker containers and Linux virtual machines on macOS.

It is used in this setup as the main container runtime for local development.

## Installation

OrbStack is installed through Homebrew Cask:

```bash
brew install --cask orbstack
```

It is also declared in `profiles/full/Brewfile`:

```bash
brew bundle install --file=Brewfile
```

## Launch OrbStack

Open OrbStack from the Applications folder or with:

```bash
open -a OrbStack
```

The application must be running before Docker-compatible commands can communicate with its container engine.

## Verify the installation

Check that the application is installed through Homebrew:

```bash
brew list --cask orbstack
```

Verify that the Docker client can communicate with OrbStack:

```bash
docker info
```

A warning may still be displayed depending on OrbStack's internal network configuration.

The important point is that the command exits successfully:

```bash
docker info >/dev/null
echo $?
```

A result of `0` confirms that the Docker-compatible engine is reachable.

## Docker compatibility

OrbStack exposes a Docker-compatible environment.

Existing commands and tools can therefore continue to use the standard Docker CLI:

```bash
docker ps
docker images
docker compose version
```

Tools such as Act can also use OrbStack as their local container runtime.

## Run a test container

Run a small disposable container to verify that image downloads and container execution work:

```bash
docker run --rm hello-world
```

The container is removed automatically after the command completes.

## Docker Compose

Verify that Docker Compose is available:

```bash
docker compose version
```

A Compose project can then be started with:

```bash
docker compose up -d
```

And stopped with:

```bash
docker compose down
```

## Resource usage

OrbStack manages CPU, memory, storage, networking, and Linux virtualization for local containers.

Resource settings should remain at their defaults until a real project demonstrates a need for different limits.

Increasing resource limits without a concrete requirement can unnecessarily reduce the resources available to macOS.

## Compatibility limitations

OrbStack provides strong Docker compatibility, but local execution is not always identical to a production Linux host or a GitHub-hosted runner.

Differences can include:

- CPU architecture;
- operating system kernel behavior;
- filesystem performance and permissions;
- networking;
- available memory and CPU;
- platform-specific container images.

Images should explicitly support the required architecture when necessary.

## Data and cleanup

Before deleting containers or volumes, inspect the current state:

```bash
docker ps -a
docker volume ls
docker image ls
```

Remove unused Docker resources with care:

```bash
docker system prune
```

This command can delete stopped containers, unused networks, and dangling images.

Avoid adding the `--volumes` option unless unused volumes and their data are intentionally meant to be deleted.

## Updates

Update OrbStack through Homebrew with:

```bash
brew upgrade --cask orbstack
```

After an update, verify the runtime again:

```bash
docker info
docker compose version
```

## Rollback

Before uninstalling OrbStack, verify whether important project data is stored in Docker volumes or Linux machines managed by the application.

Remove OrbStack with:

```bash
brew uninstall --cask orbstack
```

Then remove its entry from `profiles/full/Brewfile`.

Uninstalling the application and deleting its local data are separate operations. Local containers, images, volumes, or virtual machines should only be removed after confirming that they are no longer needed.
