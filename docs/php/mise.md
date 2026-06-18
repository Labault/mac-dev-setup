# mise

## Overview

[mise](https://mise.jdx.dev/) is a runtime version manager that can manage
multiple PHP, Node, Python, and other tool versions per project.

It is not currently installed by MacDevSetup. It is a candidate for future
adoption because it changes the boundary between Homebrew-provided shared
runtimes and project-specific runtimes.

## Current Boundary

Today, this setup uses:

- Homebrew PHP for the shared local PHP runtime;
- Homebrew Node for repository tooling and general JavaScript work;
- project-level Composer and npm dependencies for application tools.

Adopting mise would mean some projects could pin runtime versions in files such
as `.mise.toml`, instead of relying on the Homebrew runtime version.

## Evaluation Criteria

Before adding mise to a profile:

- confirm it solves a real multi-version runtime problem;
- document how it interacts with Homebrew PHP, Node, and Composer;
- classify it in `docs/homebrew/inventory.md`;
- add it to the appropriate Brewfile only after the workflow is clear;
- verify CI and setup behavior on a clean macOS runner.

## Example Project Config

If a project chooses mise independently:

```toml
[tools]
php = "8.3"
node = "22"
```

Keep project runtime pins in the project repository, not in MacDevSetup.

## Decision

For now, mise remains an evaluated candidate, not an installed dependency.
