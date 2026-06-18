# PHP Static Analysis

## Overview

[PHPStan](https://phpstan.org/user-guide/getting-started) is the static
analysis tool chosen for this setup. The VS Code extension list already includes
`sanderronde.phpstan-vscode`, so projects should standardize on PHPStan rather
than splitting between multiple analyzers.

Install PHPStan per project with Composer. Do not install it globally with
Homebrew.

## Installation

For a Symfony project:

```bash
composer require --dev \
  phpstan/phpstan \
  phpstan/extension-installer \
  phpstan/phpstan-symfony \
  phpstan/phpstan-doctrine
```

For a non-Symfony PHP project:

```bash
composer require --dev phpstan/phpstan
```

## Configuration

Create `phpstan.neon` in the project:

```neon
parameters:
    level: 5
    paths:
        - src
        - tests
```

Start at a level the project can sustain, then raise it progressively. Avoid
jumping directly to the maximum level on legacy applications.

## Composer Scripts

Add a project script:

```json
{
  "scripts": {
    "analyse": "phpstan analyse --memory-limit=1G"
  }
}
```

Run it with:

```bash
composer analyse
```

## Baseline Strategy

Use a baseline only for existing projects with known debt:

```bash
vendor/bin/phpstan analyse --generate-baseline
```

Commit the baseline with the project, then reduce it over time. Do not use a
baseline to hide new errors in new code.

## IDE Integration

The recommended VS Code extensions include PHPStan integration. Keep
project-specific binary paths in the project's `.vscode/settings.json` when the
extension cannot auto-detect `vendor/bin/phpstan`.

## Psalm

Psalm is intentionally not the default analyzer for this setup. PHPStan is
already reflected in the editor extensions and keeps the project workflow
focused on one primary static-analysis tool.
