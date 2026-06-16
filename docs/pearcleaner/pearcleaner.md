# Pearcleaner

## Overview

[Pearcleaner](https://github.com/alienator88/Pearcleaner) is a lightweight macOS application uninstaller.

It helps remove an application together with related files such as preferences, caches, containers, logs, and support files that may remain after moving the application to the Trash.

Pearcleaner is installed through Homebrew Cask and declared in the project `Brewfile`.

## Installation

Install all applications and tools declared in the `Brewfile`:

```bash
brew bundle --file=Brewfile
```

Verify the Homebrew installation:

```bash
brew list --cask | grep -x pearcleaner
```

Verify that the application is present:

```bash
test -d "/Applications/Pearcleaner.app" \
  && echo "Pearcleaner application found."
```

Display the Homebrew package information:

```bash
brew info --cask pearcleaner
```

## Usage

Open Pearcleaner from the Applications folder or with:

```bash
open -a Pearcleaner
```

Select an installed application to inspect the related files detected by Pearcleaner.

Review the list carefully before confirming removal.

## Why use Pearcleaner

Moving an application to the Trash usually removes only the main application bundle.

Additional files may remain in locations such as:

```text
~/Library/Application Support/
~/Library/Caches/
~/Library/Containers/
~/Library/Group Containers/
~/Library/Preferences/
~/Library/Logs/
~/Library/Saved Application State/
```

Pearcleaner helps identify these files and remove them together with the application.

## Permissions

macOS may request additional permissions so Pearcleaner can inspect or remove files from protected locations.

Depending on the macOS version, this can include:

- Full Disk Access;
- access to application data;
- access to removable or network volumes.

Permissions should only be granted when required and can be reviewed in:

```text
System Settings > Privacy & Security
```

## Safety precautions

Before removing an application:

- confirm that important data is synchronized or backed up;
- review every detected file;
- preserve databases, projects, profiles, or configuration files that may be needed later;
- avoid deleting shared files used by other applications;
- close the target application before removal.

Applications that store important local data may require a manual backup before uninstalling.

## Homebrew-managed applications

For applications installed with Homebrew Cask, the preferred uninstall command remains:

```bash
brew uninstall --cask <application>
```

Pearcleaner can then be used to inspect and remove leftover files when necessary.

Do not combine both removal methods without checking whether the application has already been removed.

## Troubleshooting

Open the application manually:

```bash
open -a Pearcleaner
```

Verify its installation path:

```bash
ls -ld "/Applications/Pearcleaner.app"
```

Review the current Homebrew package information:

```bash
brew info --cask pearcleaner
```

If expected files are not detected, verify the application permissions in macOS System Settings.

## Rollback

Remove Pearcleaner with Homebrew:

```bash
brew uninstall --cask pearcleaner
```

Removing Pearcleaner does not restore applications or files that were previously deleted with it.
