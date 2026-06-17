# Security policy

## Supported versions

This repository is under active development.

Security fixes are applied to the latest version available on the `main` branch. Older tags and releases may not receive separate fixes.

## Reporting a vulnerability

Do not open a public GitHub issue for security vulnerabilities.

Instead, use GitHub private vulnerability reporting when it is available for this repository.

Include:

- a clear description of the vulnerability;
- the affected file, script, or configuration;
- steps to reproduce the issue;
- the potential impact;
- any suggested mitigation;
- logs or screenshots with secrets and personal information removed.

Please do not include:

- private keys;
- access tokens;
- passwords;
- personal paths containing sensitive information;
- production credentials;
- unredacted environment files.

## Response process

A report will be reviewed to determine:

- whether the issue is reproducible;
- the affected scope;
- the severity;
- the appropriate fix or documentation update.

Validated vulnerabilities should be corrected before public technical details are disclosed.

## Security scope

Relevant security concerns may include:

- accidental secret exposure;
- unsafe shell commands;
- insecure file permissions;
- dangerous installation or rollback instructions;
- dependency or GitHub Actions supply-chain risks;
- configuration examples that expose personal or machine-specific data.

General support questions and non-security bugs should use the normal GitHub issue templates.
