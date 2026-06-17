# tokei

## Overview

[tokei](https://github.com/XAMPPRocky/tokei) analyzes source code and reports file counts, lines of code, comments, and blank lines by language.

It is useful for obtaining a quick quantitative overview of a repository.

The tool is installed through Homebrew and declared in the project `Brewfile`.

## Installation

Install all tools declared in the `Brewfile`:

```bash
brew bundle --file=Brewfile
```

Install tokei directly:

```bash
brew install tokei
```

Verify the installation:

```bash
tokei --version
brew list --formula | grep -x tokei
```

## Basic usage

Analyze the current directory:

```bash
tokei .
```

Analyze a specific project:

```bash
tokei ~/Documents/Projects/my-project
```

Display the files included in the analysis:

```bash
tokei --files .
```

## Excluding directories

Generated files and dependencies can distort the result.

Exclude common project directories:

```bash
tokei \
  --exclude '.git' \
  --exclude 'vendor' \
  --exclude 'node_modules' \
  --exclude 'var' \
  .
```

For a Symfony project, excluding `vendor` and `var` is especially important.

## Output formats

Display the result as JSON:

```bash
tokei --output json .
```

Display the result as YAML:

```bash
tokei --output yaml .
```

Structured output can be used in scripts, reports, or automated checks.

## Useful use cases

tokei is useful for:

- understanding the language distribution of a repository;
- tracking project growth;
- comparing branches or project versions;
- estimating the size of a codebase;
- detecting unexpectedly large generated directories;
- preparing technical reports.

## Interpretation

Line counts are quantitative indicators, not direct measures of:

- code quality;
- maintainability;
- complexity;
- productivity;
- project value.

A larger codebase is not necessarily better, and fewer lines do not automatically mean simpler code.

## Safety

tokei is read-only.

It scans files and reports statistics without modifying the repository.

Be careful when exporting or sharing results from private projects because language distribution and file structure can reveal implementation details.

## Troubleshooting

Display all options:

```bash
tokei --help
```

Confirm the executable path:

```bash
command -v tokei
```

If the result includes unwanted generated files, add explicit exclusions:

```bash
tokei --exclude 'path-to-ignore' .
```

## Updates

Update tokei through Homebrew:

```bash
brew upgrade tokei
```

## Rollback

Remove tokei with Homebrew:

```bash
brew uninstall tokei
```

Then remove its entry from `profiles/full/Brewfile`.
