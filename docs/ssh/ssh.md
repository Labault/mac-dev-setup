# SSH

This setup uses OpenSSH with an ED25519 key, the macOS Keychain, and an explicit host configuration for GitHub.

## Generate a key

Generate a new ED25519 key:

```bash
ssh-keygen -t ed25519 -C "your-email@example.com"
```

Use the default path unless a dedicated key name is required:

```text
~/.ssh/id_ed25519
```

Never commit a private key to a repository.

## Permissions

Apply restrictive permissions:

```bash
chmod 700 "$HOME/.ssh"
chmod 600 "$HOME/.ssh/config"
chmod 600 "$HOME/.ssh/id_ed25519"
chmod 644 "$HOME/.ssh/id_ed25519.pub"
```

Verify them:

```bash
stat -f '%Sp %N' \
  "$HOME/.ssh" \
  "$HOME/.ssh/config" \
  "$HOME/.ssh/id_ed25519" \
  "$HOME/.ssh/id_ed25519.pub"
```

## macOS Keychain

Add the private key to the SSH agent and macOS Keychain:

```bash
ssh-add --apple-use-keychain "$HOME/.ssh/id_ed25519"
```

List loaded identities:

```bash
ssh-add -l
```

## Configuration

A reusable example is stored in:

```text
configs/ssh/config.example
```

Copy it locally:

```bash
cp configs/ssh/config.example "$HOME/.ssh/config"
chmod 600 "$HOME/.ssh/config"
```

Review the file before replacing an existing SSH configuration.

The OrbStack include must remain before any `Host` block:

```text
Include ~/.orbstack/ssh/config
```

The GitHub block explicitly selects the expected identity and stores its passphrase in the macOS Keychain.

## GitHub

Display the public key:

```bash
cat "$HOME/.ssh/id_ed25519.pub"
```

Add this public key to the GitHub account, then test authentication:

```bash
ssh -T git@github.com
```

A successful test reports that authentication succeeded and that GitHub does not provide shell access.

Inspect the resolved configuration:

```bash
ssh -G github.com | grep -E \
  '^(hostname|user|identityfile|addkeystoagent|usekeychain|identitiesonly) '
```

## Validation

Validate the example configuration:

```bash
ssh -G -F configs/ssh/config.example github.com >/dev/null \
  && echo "SSH example configuration is valid."
```

Inspect the key fingerprint:

```bash
ssh-keygen -lf "$HOME/.ssh/id_ed25519.pub"
```

## Files that must stay local

Do not commit these files:

```text
~/.ssh/id_ed25519
~/.ssh/id_ed25519.pub
~/.ssh/known_hosts
~/.ssh/known_hosts.old
~/.ssh/environment-*
```

Public keys are not secret, but they are personal machine and account identifiers and are intentionally excluded from this repository.

## Rollback

Before replacing an existing configuration, create a backup:

```bash
cp "$HOME/.ssh/config" "$HOME/.ssh/config.backup"
```

Restore it with:

```bash
cp "$HOME/.ssh/config.backup" "$HOME/.ssh/config"
chmod 600 "$HOME/.ssh/config"
```

Remove a key from the current SSH agent without deleting it from disk:

```bash
ssh-add -d "$HOME/.ssh/id_ed25519"
```

---

[← Docs index](../README.md) · [Project README](../../README.md)
