#!/usr/bin/env bats

setup() {
  REPO_DIR="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
  PHP_COMMAND="$REPO_DIR/scripts/commands/php.sh"
}

make_php_path() {
  bin="$(mktemp -d)"

  for tool in bash dirname mkdir cp rm cat; do
    ln -s "$(command -v "$tool")" "$bin/$tool"
  done

  cat >"$bin/php" <<'PHP'
#!/bin/sh
case "$1" in
  -r)
    case "$2" in
      *extension_dir*) printf '%s' "$XDEBUG_EXTENSION_DIR" ;;
      *) printf '8.3' ;;
    esac
    ;;
  --ri)
    if [ "${XDEBUG_LOADED:-false}" = "true" ]; then
      printf 'xdebug\n'
      exit 0
    fi
    exit 1
    ;;
  *) printf 'PHP 8.3.0\n' ;;
esac
PHP

  cat >"$bin/brew" <<'BREW'
#!/bin/sh
case "$1" in
  --prefix) printf '/opt/homebrew' ;;
  *) exit 0 ;;
esac
BREW

  chmod +x "$bin/php" "$bin/brew"
}

@test "php command exposes help" {
  run bash "$PHP_COMMAND" --help
  [ "$status" -eq 0 ]
  [[ "$output" == *"Usage: mac php xdebug"* ]]
}

@test "php xdebug status reports disabled config" {
  make_php_path
  conf_dir="$(mktemp -d)"

  run env PATH="$bin" MAC_DEV_SETUP_PHP_CONF_DIR="$conf_dir" bash "$PHP_COMMAND" xdebug status
  rm -rf "$bin" "$conf_dir"

  [ "$status" -eq 0 ]
  [[ "$output" == *"PHP config dir: $conf_dir"* ]]
  [[ "$output" == *"Xdebug config disabled"* ]]
  [[ "$output" == *"Xdebug extension not loaded"* ]]
}

@test "php xdebug enable writes enabled config from disabled template" {
  make_php_path
  conf_dir="$(mktemp -d)"
  extension_dir="$(mktemp -d)"
  printf 'extension\n' >"$extension_dir/xdebug.so"

  run env PATH="$bin" MAC_DEV_SETUP_PHP_CONF_DIR="$conf_dir" XDEBUG_EXTENSION_DIR="$extension_dir" bash "$PHP_COMMAND" xdebug enable
  enabled_config="$(cat "$conf_dir/99-xdebug.ini")"
  disabled_config="$(cat "$conf_dir/99-xdebug.ini.disabled")"
  rm -rf "$bin" "$conf_dir" "$extension_dir"

  [ "$status" -eq 0 ]
  [[ "$output" == *"Xdebug enabled"* ]]
  [[ "$enabled_config" == *"zend_extension=xdebug"* ]]
  [[ "$enabled_config" == "$disabled_config" ]]
}

@test "php xdebug enable fails when the extension is not installed" {
  make_php_path
  conf_dir="$(mktemp -d)"
  extension_dir="$(mktemp -d)"

  run env PATH="$bin" MAC_DEV_SETUP_PHP_CONF_DIR="$conf_dir" XDEBUG_EXTENSION_DIR="$extension_dir" bash "$PHP_COMMAND" xdebug enable
  rm -rf "$bin" "$conf_dir" "$extension_dir"

  [ "$status" -ne 0 ]
  [[ "$output" == *"Xdebug extension not installed"* ]]
  [[ "$output" == *"pecl install xdebug"* ]]
}

@test "php xdebug disable removes enabled config and keeps disabled template" {
  make_php_path
  conf_dir="$(mktemp -d)"
  printf 'zend_extension=xdebug\n' >"$conf_dir/99-xdebug.ini"
  printf 'zend_extension=xdebug\n' >"$conf_dir/99-xdebug.ini.disabled"

  run env PATH="$bin" MAC_DEV_SETUP_PHP_CONF_DIR="$conf_dir" bash "$PHP_COMMAND" xdebug disable
  enabled_exists="false"
  [ -f "$conf_dir/99-xdebug.ini" ] && enabled_exists="true"
  disabled_exists="false"
  [ -f "$conf_dir/99-xdebug.ini.disabled" ] && disabled_exists="true"
  rm -rf "$bin" "$conf_dir"

  [ "$status" -eq 0 ]
  [[ "$output" == *"Xdebug disabled"* ]]
  [ "$enabled_exists" = "false" ]
  [ "$disabled_exists" = "true" ]
}
