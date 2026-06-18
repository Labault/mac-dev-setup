# Pest

[Pest](https://pestphp.com/docs/installation) is the preferred test interface to
evaluate for new PHP projects in this setup. PHPUnit remains the underlying
engine and compatibility layer.

Install Pest per project with Composer. Do not install Pest globally.

## Installation

For a new project:

```bash
composer require --dev pestphp/pest
vendor/bin/pest --init
```

For Symfony projects, add the Symfony plugin when useful:

```bash
composer require --dev pestphp/pest-plugin-symfony
```

## Composer Scripts

Add scripts to the project `composer.json`:

```json
{
  "scripts": {
    "test": "pest",
    "test:unit": "pest tests/Unit",
    "test:integration": "pest tests/Integration",
    "test:functional": "pest tests/Functional",
    "test:coverage": "XDEBUG_MODE=off php -d pcov.enabled=1 vendor/bin/pest --coverage"
  }
}
```

Run them with:

```bash
composer test
composer test:coverage
```

## Test Types

Use a clear test layout:

- `tests/Unit` for isolated domain logic;
- `tests/Integration` for database, filesystem, queue, mailer, and service
  wiring checks;
- `tests/Functional` for HTTP and end-to-end application flows.

## Datasets

Use datasets for repeated input/output examples:

```php
it('normalizes email addresses', function (string $input, string $expected) {
    expect(normalize_email($input))->toBe($expected);
})->with([
    ['USER@example.com', 'user@example.com'],
    [' user@example.com ', 'user@example.com'],
]);
```

## Mocks

Prefer real services for unit-level value objects and pure domain code. Use mocks
for boundaries that are slow, remote, nondeterministic, or already covered
elsewhere.

## Coverage

Use PCOV for fast coverage when the project adopts coverage. Use Xdebug for
debugging. Do not run both coverage drivers at the same time.
