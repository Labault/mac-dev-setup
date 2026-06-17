# Pearcleaner

Pearcleaner is a lightweight macOS application uninstaller.

It removes an application together with related files that may remain in the user's Library after a normal drag-and-drop deletion.

## Installation

Pearcleaner is installed through Homebrew Cask:

```bash
brew install --cask pearcleaner
```

It is also declared in `profiles/full/Brewfile`:

```bash
brew bundle install --file=Brewfile
```

## Launch the application

Open Pearcleaner from the Applications folder or with:

```bash
open -a Pearcleaner
```

## Verify the installation

Check that Pearcleaner is installed through Homebrew:

```bash
brew list --cask pearcleaner
```

## Usage

To remove an application:

1. Open Pearcleaner.
2. Select the application to uninstall.
3. Review the related files detected by the application.
4. Confirm that none of the selected files contain data that must be preserved.
5. Run the removal.

Pearcleaner should be used as a review tool, not as an automatic permission to delete every detected file.

## Related files

Depending on the application, related files may include:

```text
~/Library/Application Support/
~/Library/Caches/
~/Library/Containers/
~/Library/Group Containers/
~/Library/Logs/
~/Library/Preferences/
~/Library/Saved Application State/
```

Not every related file is necessarily disposable.

Application Support and container directories can contain:

- databases;
- account configuration;
- saved connections;
- local projects;
- user preferences;
- licenses;
- application-specific documents.

## Before removing an application

Before uninstalling an application with important local data:

1. Export or back up the required data.
2. Check whether the application uses cloud synchronization.
3. Review Application Support and container directories.
4. Confirm that the application is not still running.
5. Review every file selected by Pearcleaner before deletion.

Extra care is required for password managers, database clients, development tools, virtual machines, and container runtimes.

## Full disk access

Pearcleaner may require additional macOS permissions to inspect or remove files from protected locations.

When needed, grant access from:

```text
System Settings
→ Privacy & Security
→ Full Disk Access
```

Only grant this permission to the installed and trusted Pearcleaner application.

After changing the permission, quit and reopen Pearcleaner.

## Comparison with manual removal

Deleting an application from `/Applications` removes the application bundle but usually leaves its user-specific data behind.

Pearcleaner helps identify those remaining files.

Manual cleanup remains preferable when:

- the application stores valuable data;
- the detected files are ambiguous;
- only part of the local configuration should be removed;
- the application's official uninstaller performs additional cleanup.

## Applications with official uninstallers

Some applications install privileged services, system extensions, background agents, or kernel-level components.

For those applications, prefer the official uninstaller when one is provided.

Pearcleaner can still be used afterward to inspect harmless remaining user files, but it should not replace a vendor-specific uninstall procedure blindly.

## Updates

Update Pearcleaner through Homebrew with:

```bash
brew upgrade --cask pearcleaner
```

## Rollback

Remove Pearcleaner with:

```bash
brew uninstall --cask pearcleaner
```

Then remove its entry from `profiles/full/Brewfile`.

Removing Pearcleaner does not restore applications or files that were previously deleted with it.
