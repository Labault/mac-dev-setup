# Troubleshooting

Use this guide when `mac setup`, `mac doctor`, Homebrew, Zsh, or managed
configuration files do not behave as expected.

Start with the project diagnostics:

```bash
mac doctor
```

Check a specific setup profile when investigating missing Homebrew packages:

```bash
mac doctor --profile minimal
mac doctor --profile full
```

If the `mac` command is not available yet, run the doctor script directly from
the checkout:

```bash
~/.mac-dev-setup/scripts/commands/doctor.sh
```

## Zsh issues

### `mac` is not available after install

Open a new terminal window, or reload the login shell configuration:

```bash
exec zsh -l
```

Check whether the managed command directory is on `PATH`:

```bash
print -r -- "$PATH" | tr ':' '\n' | grep "$HOME/.local/bin"
```

If it is missing, confirm that `~/.zprofile` exists and is readable:

```bash
ls -l "$HOME/.zprofile"
zsh -lic 'print -r -- "$PATH"'
```

### Zsh prints errors on startup

Run Zsh without loading the interactive configuration to confirm the shell
itself works:

```bash
zsh -f
```

Then test the managed configuration:

```bash
zsh -ic 'echo "interactive zsh loaded"'
zsh -lic 'echo "login zsh loaded"'
```

Common causes are missing Homebrew, missing Antidote, a stale plugin cache, or
custom commands in `~/.shell/local.zsh`.

Move local customizations out of the way temporarily:

```bash
mv "$HOME/.shell/local.zsh" "$HOME/.shell/local.zsh.disabled"
zsh -ic 'echo "zsh loaded without local customizations"'
```

Restore the file after testing:

```bash
mv "$HOME/.shell/local.zsh.disabled" "$HOME/.shell/local.zsh"
```

### Antidote or plugins do not load

Check whether Homebrew can find Antidote:

```bash
brew list antidote
brew --prefix antidote
```

Check the plugin file:

```bash
ls -l "$HOME/.zsh_plugins.txt"
zsh -ic 'type antidote'
```

Reinstall the curated shell tools through the selected profile:

```bash
mac setup --profile full
```

Use `--profile minimal` instead when the minimal profile is the intended
environment.

## PATH issues

### Confirm the active shell and PATH

Check the current shell:

```bash
echo "$SHELL"
ps -p "$$" -o comm=
```

Print the active `PATH` one entry per line:

```bash
print -r -- "$PATH" | tr ':' '\n'
```

Confirm where a command resolves:

```bash
command -v mac
command -v brew
command -v git
```

### Apple Silicon Homebrew is missing from PATH

On Apple Silicon Macs, Homebrew normally lives under `/opt/homebrew`.

Check whether `brew` exists there:

```bash
ls -l /opt/homebrew/bin/brew
```

Load the Homebrew shell environment for the current session:

```bash
eval "$(/opt/homebrew/bin/brew shellenv)"
```

Then verify:

```bash
command -v brew
brew --prefix
```

### Intel Homebrew is missing from PATH

On Intel Macs, Homebrew normally lives under `/usr/local`.

Check whether `brew` exists there:

```bash
ls -l /usr/local/bin/brew
```

Load the Homebrew shell environment for the current session:

```bash
eval "$(/usr/local/bin/brew shellenv)"
```

Then verify:

```bash
command -v brew
brew --prefix
```

### `~/.local/bin` is missing from PATH

MacDevSetup installs the `mac` command in:

```text
~/.local/bin
```

Check the command file:

```bash
ls -l "$HOME/.local/bin/mac"
```

Reload the login shell:

```bash
exec zsh -l
```

If the path is still missing, rerun the installer or reapply setup from the
checkout:

```bash
~/.mac-dev-setup/scripts/commands/setup.sh
```

## Homebrew issues

### Homebrew is not installed

Install Homebrew with the official installer:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

After installation, open a new terminal window and verify:

```bash
brew --version
brew doctor
```

### `brew bundle` fails

Update Homebrew metadata first:

```bash
brew update
```

Run bundle with verbose output from the repository root:

```bash
brew bundle install --file=Brewfile --verbose
```

Check whether the selected profile is valid:

```bash
find profiles -maxdepth 2 -name Brewfile -print
```

Then rerun setup with an explicit profile:

```bash
mac setup --profile minimal
mac setup --profile full
```

### Homebrew reports permission errors

Check ownership of the Homebrew prefix:

```bash
brew --prefix
ls -ld "$(brew --prefix)"
```

The Homebrew prefix should be writable by the current user. Avoid running
`brew` with `sudo`.

If files are owned by another user, inspect the affected paths from the
Homebrew error message before changing ownership. For a standard Apple Silicon
install, the prefix is usually:

```text
/opt/homebrew
```

For a standard Intel install, it is usually:

```text
/usr/local
```

### Cask installation fails

Some casks require closing the application before upgrade or reinstall.

Close the application, then retry:

```bash
brew reinstall --cask <cask>
```

If macOS blocks an application after installation, open:

```text
System Settings > Privacy & Security
```

Review the blocked application prompt and approve it only if the application is
expected and trusted.

## macOS permission issues

### Script is not executable

Check the file mode:

```bash
ls -l scripts/setup.sh scripts/commands/setup.sh install.sh
```

Make a script executable when needed:

```bash
chmod +x scripts/setup.sh scripts/commands/setup.sh install.sh
```

### Terminal cannot access files or folders

macOS may block terminal applications from accessing protected locations such as
Desktop, Documents, Downloads, external volumes, or network volumes.

Open:

```text
System Settings > Privacy & Security > Files and Folders
```

Allow access for the terminal application that runs setup.

For broader development access, review:

```text
System Settings > Privacy & Security > Full Disk Access
```

Grant access only to terminal applications you trust.

### Keyboard layout does not appear

The keyboard layout step installs a system input source, but macOS may not load
it immediately.

Log out and log back in, then check:

```text
System Settings > Keyboard > Text Input > Edit
```

If the layout still does not appear, rerun the keyboard setup step:

```bash
mac setup --profile full
```

### macOS defaults do not appear to apply

Some defaults only become visible after restarting the affected application.

Restart Finder and Dock:

```bash
killall Finder
killall Dock
```

If a setting still does not change, log out and log back in before rerunning the
setup command.

## Collecting diagnostics

When reporting an issue, include:

- the failing command;
- the complete error message;
- the macOS version;
- the Mac architecture;
- the selected setup profile;
- whether the terminal application has the required macOS permissions.

Collect the basic environment details with:

```bash
sw_vers
uname -m
echo "$SHELL"
command -v brew || true
command -v mac || true
mac doctor || true
```
