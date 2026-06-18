# swaks

## Overview

[swaks](https://github.com/jetmore/swaks) is an SMTP test tool.

It is useful for validating local mail catchers, SMTP credentials, TLS settings, and application email delivery during development.

## Installation

Install swaks directly:

```bash
brew install swaks
```

Verify the installation:

```bash
swaks --version
brew list --formula | grep -x swaks
```

## Local testing

Send a test message to a local SMTP service:

```bash
swaks \
  --to dev@example.test \
  --from app@example.test \
  --server localhost:1025
```

This pairs well with mail-catching services exposed by Docker Compose.

## Remote SMTP

Use explicit host, port, authentication, and TLS settings:

```bash
swaks \
  --to user@example.com \
  --server smtp.example.com \
  --port 587 \
  --auth LOGIN \
  --auth-user "$SMTP_USER" \
  --auth-password "$SMTP_PASSWORD" \
  --tls
```

Keep credentials in environment variables or a local secret manager. Do not commit them.

## Rollback

Remove swaks with:

```bash
brew uninstall swaks
```
