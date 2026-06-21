# Sentry

[Sentry](https://sentry.io/) is a cloud error tracking and performance monitoring
platform. It captures unhandled exceptions, logs structured context (request,
user, session), and groups recurring errors into issues.

Sentry is used in this setup for Symfony projects. There is no Homebrew cask —
integration is done at the project level through the PHP SDK.

## Account setup

Create a free account at <https://sentry.io/signup/>. The free tier covers one
project with 5 000 errors per month.

Create one project per Symfony application. Select **PHP** as the platform
during project creation to get a pre-filled DSN.

## Symfony integration

Install the Sentry SDK and the Symfony bundle:

```bash
composer require sentry/sentry-symfony
```

Set the DSN as an environment variable. Never commit it:

```dotenv
# .env.local
SENTRY_DSN=https://<key>@<org>.ingest.sentry.io/<project>
```

Configure the bundle in `config/packages/sentry.yaml`:

```yaml
sentry:
  dsn: '%env(SENTRY_DSN)%'
  register_error_listener: true
  tracing:
    enabled: true
    dbal:
      enabled: true
```

Verify the integration:

```bash
php bin/console sentry:test
```

## What gets captured automatically

- Unhandled exceptions and PHP fatal errors.
- Symfony HTTP exceptions (404, 500, etc.) above the configured level.
- Slow database queries (when `tracing.dbal` is enabled).
- Request metadata: URL, method, headers, POST data.

## Release tracking

Tag each deployment with the release version so errors are linked to the
correct code version:

```dotenv
# .env.local
SENTRY_RELEASE=1.4.2
```

Or inject it from CI:

```yaml
# .github/workflows/deploy.yml
env:
  SENTRY_RELEASE: ${{ github.sha }}
```

## Ignoring expected exceptions

Some exceptions are noise (404s from bots, user-facing validation). Ignore them
in `config/packages/sentry.yaml`:

```yaml
sentry:
  dsn: '%env(SENTRY_DSN)%'
  options:
    ignore_exceptions:
      - Symfony\Component\HttpKernel\Exception\NotFoundHttpException
      - Symfony\Component\Security\Core\Exception\AccessDeniedException
```

## Environments

Sentry distinguishes environments automatically from the `APP_ENV` variable.
Errors from `dev` and `test` environments can be filtered out in the Sentry
dashboard or suppressed at the bundle level:

```yaml
sentry:
  dsn: '%env(SENTRY_DSN)%'
  options:
    environment: '%kernel.environment%'
```

Disable Sentry in `test`:

```yaml
# config/packages/test/sentry.yaml
sentry:
  dsn: ~
```

## Secrets

- `SENTRY_DSN` must be in `.env.local` and never committed.
- Add it to your CI secrets if you run `sentry:test` in the pipeline.
- For production, inject it through the server environment or a secrets manager.

## Rollback

Remove the SDK and bundle:

```bash
composer remove sentry/sentry-symfony
```

Delete `config/packages/sentry.yaml` and remove `SENTRY_DSN` from all
`.env.local` files.

---

[← Docs index](../README.md) · [Project README](../../README.md)
