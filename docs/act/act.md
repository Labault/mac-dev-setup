# act

## Overview

[act](https://github.com/nektos/act) runs GitHub Actions workflows locally by using Docker containers.

It helps validate workflows before pushing commits to GitHub and reduces the feedback delay caused by remote CI runs.

The tool is installed through Homebrew and declared in the project `Brewfile`.

## Installation

Install all tools declared in the `Brewfile`:

```bash
brew bundle --file=Brewfile
```

Verify the Homebrew installation:

```bash
brew list --formula | grep -x act
```

Check the installed version:

```bash
act --version
```

Display the available commands and options:

```bash
act --help
```

## Requirements

`act` requires a working Docker-compatible container runtime.

This setup uses OrbStack:

```bash
docker context show
docker version
```

The expected Docker context is:

```text
orbstack
```

## Workflow discovery

By default, `act` reads GitHub Actions workflows from:

```text
.github/workflows/
```

List the detected jobs without running them:

```bash
act --list
```

A repository without workflows cannot yet perform a meaningful execution test.

## Running workflows

Run the default event:

```bash
act
```

Run workflows triggered by a push event:

```bash
act push
```

Run workflows triggered by a pull request event:

```bash
act pull_request
```

Run a specific job:

```bash
act --job <job-name>
```

Run a specific workflow file:

```bash
act --workflows .github/workflows/<workflow>.yaml
```

## Dry run

Inspect what would be executed without starting the jobs:

```bash
act --dryrun
```

This is useful for validating workflow discovery, job selection, matrices, and dependencies.

## Secrets

Pass a secret explicitly:

```bash
act --secret SECRET_NAME=value
```

Load secrets from a file:

```bash
act --secret-file .secrets
```

Secret files must never be committed.

A suitable local secrets file should be excluded through `.gitignore`.

## Variables

Pass a GitHub Actions variable:

```bash
act --var VARIABLE_NAME=value
```

Load variables from a file:

```bash
act --var-file .vars
```

## Platform images

`act` maps GitHub-hosted runners to Docker images.

A custom image can be selected with:

```bash
act \
  --platform ubuntu-latest=<docker-image>
```

Larger runner images provide better compatibility but require more disk space and take longer to download.

## Limitations

Local runs are not a perfect replacement for GitHub-hosted runners.

Differences can include:

- available system packages;
- hardware architecture;
- operating system behavior;
- GitHub-specific services;
- permissions and tokens;
- network configuration;
- unsupported workflow features.

A workflow passing locally must still be validated on GitHub Actions.

## Planned repository validation

A real `act` execution test will be added when the first workflow exists in:

```text
.github/workflows/
```

At that point, the repository should validate at least:

```bash
act --list
act --dryrun
act
```

The exact commands may depend on the workflow events and required secrets.

## Troubleshooting

Verify that Docker is running:

```bash
docker info
```

Confirm that OrbStack is active:

```bash
orbctl status
```

Inspect the detected workflows and jobs:

```bash
act --list
```

Run with verbose output:

```bash
act --verbose
```

Remove downloaded `act` container images with normal Docker commands when disk cleanup is required:

```bash
docker image ls
docker image rm <image>
```

## Rollback

Remove `act` with Homebrew:

```bash
brew uninstall act
```

Removing `act` does not modify the workflows stored in `.github/workflows/`.
