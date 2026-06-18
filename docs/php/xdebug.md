# Xdebug

[Xdebug](https://xdebug.org/docs/) is the PHP debugger expected by the VS Code
extension already installed by this setup.

Keep Xdebug disabled by default for normal PHP and Composer work. Enable it only
when debugging, profiling, or collecting Xdebug-specific diagnostics.

## Installation

Install Xdebug for the active Homebrew PHP version:

```bash
pecl install xdebug
```

Find the active PHP configuration directory:

```bash
php --ini
php -i | grep '^extension_dir'
```

Homebrew PHP configuration commonly lives under:

```text
$(brew --prefix)/etc/php/<version>/conf.d
```

## Disabled by Default

Keep a disabled config available, but do not load it automatically:

```ini
; xdebug.ini.disabled
zend_extension=xdebug
xdebug.mode=debug,develop
xdebug.start_with_request=yes
xdebug.client_host=127.0.0.1
xdebug.client_port=9003
```

In this setup you do not edit these files by hand. MacDevSetup ships a helper
that manages them for you:

```bash
mac php xdebug status    # show whether Xdebug is enabled or disabled
mac php xdebug enable     # activate Xdebug for a debugging session
mac php xdebug disable    # deactivate it again
```

The helper keeps `99-xdebug.ini.disabled` as the reusable disabled template
(created automatically on first run). `enable` copies it to `99-xdebug.ini` in
the active Homebrew PHP `conf.d` directory; `disable` removes that copy. The
template is never moved or symlinked, so it always stays available. Restart the
relevant PHP process (or `symfony server:stop && symfony server:start`) after
toggling.

## VS Code Workflow

The recommended VS Code extensions include `xdebug.php-debug`.

Use port `9003`, which is the Xdebug 3 default. In project workspaces, keep
debug settings in the project's `.vscode/launch.json` rather than the global
MacDevSetup VS Code settings.

For web debugging:

1. Enable Xdebug in the PHP runtime used by the project.
2. Start "Listen for Xdebug" in VS Code.
3. Trigger the HTTP request, CLI command, or test that should break.

## OrbStack and Docker

For PHP running inside containers, configure Xdebug in the container image or
compose override, not in the host Homebrew PHP config.

Use the host name exposed by the container runtime when `127.0.0.1` does not
point back to the Mac host. Keep container-specific path mappings in the project
workspace.

## Coverage Boundary

Use Xdebug for debugging and profiling. Use PCOV for fast coverage when the
project adopts it. Do not enable Xdebug coverage and PCOV in the same run.

## Validation

Check whether Xdebug is loaded:

```bash
mac php xdebug status
php -v
php --ri xdebug
```

Check the active mode:

```bash
php -r 'echo ini_get("xdebug.mode"), PHP_EOL;'
```
