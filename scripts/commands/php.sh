#!/bin/bash
# Description: Manage PHP development helpers.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

# shellcheck source=scripts/lib/logging.sh
source "$REPO_DIR/scripts/lib/logging.sh"

print_usage() {
  log_line "Usage: mac php xdebug <enable|disable|status> [--help]"
  log_line ""
  log_line "Manage the Homebrew PHP Xdebug configuration."
}

php_minor_version() {
  php -r 'echo PHP_MAJOR_VERSION.".".PHP_MINOR_VERSION;'
}

php_extension_dir() {
  php -r 'echo ini_get("extension_dir");'
}

php_conf_dir() {
  if [ -n "${MAC_DEV_SETUP_PHP_CONF_DIR:-}" ]; then
    printf '%s\n' "$MAC_DEV_SETUP_PHP_CONF_DIR"
    return 0
  fi

  version="$(php_minor_version)"
  printf '%s/etc/php/%s/conf.d\n' "$(brew --prefix)" "$version"
}

xdebug_enabled_file() {
  printf '%s/99-xdebug.ini\n' "$(php_conf_dir)"
}

xdebug_disabled_file() {
  printf '%s/99-xdebug.ini.disabled\n' "$(php_conf_dir)"
}

xdebug_extension_file() {
  printf '%s/xdebug.so\n' "$(php_extension_dir)"
}

write_xdebug_template() {
  target_file="$1"

  mkdir -p "$(dirname "$target_file")"
  cat >"$target_file" <<'EOF'
zend_extension=xdebug
xdebug.mode=debug,develop
xdebug.start_with_request=yes
xdebug.client_host=127.0.0.1
xdebug.client_port=9003
EOF
}

ensure_xdebug_disabled_template() {
  disabled_file="$(xdebug_disabled_file)"

  if [ ! -f "$disabled_file" ]; then
    write_xdebug_template "$disabled_file"
  fi

  printf '%s\n' "$disabled_file"
}

require_php_runtime() {
  if ! command -v php >/dev/null; then
    error "php is required. Run: mac setup --profile full"
    exit 1
  fi
}

require_brew_when_needed() {
  [ -n "${MAC_DEV_SETUP_PHP_CONF_DIR:-}" ] && return 0

  if ! command -v brew >/dev/null; then
    error "brew is required to locate the Homebrew PHP config directory"
    exit 1
  fi
}

require_xdebug_extension() {
  extension_file="$(xdebug_extension_file)"

  if [ ! -f "$extension_file" ]; then
    error "Xdebug extension not installed: $extension_file"
    log_line "Run: pecl install xdebug"
    exit 1
  fi
}

xdebug_enable() {
  require_php_runtime
  require_brew_when_needed
  require_xdebug_extension

  enabled_file="$(xdebug_enabled_file)"
  disabled_file="$(ensure_xdebug_disabled_template)"

  mkdir -p "$(dirname "$enabled_file")"
  cp "$disabled_file" "$enabled_file"
  success "Xdebug enabled: $enabled_file"
}

xdebug_disable() {
  require_php_runtime
  require_brew_when_needed

  enabled_file="$(xdebug_enabled_file)"

  if [ -f "$enabled_file" ]; then
    rm -f "$enabled_file"
    success "Xdebug disabled"
  else
    success "Xdebug already disabled"
  fi
}

xdebug_status() {
  require_php_runtime
  require_brew_when_needed

  enabled_file="$(xdebug_enabled_file)"
  disabled_file="$(xdebug_disabled_file)"

  log_line "PHP config dir: $(php_conf_dir)"

  if [ -f "$enabled_file" ]; then
    success "Xdebug config enabled: $enabled_file"
  else
    warn "Xdebug config disabled"
  fi

  if [ -f "$disabled_file" ]; then
    log_line "Disabled template: $disabled_file"
  fi

  if php --ri xdebug >/dev/null 2>&1; then
    success "Xdebug extension loaded"
  else
    warn "Xdebug extension not loaded in current PHP process"
  fi

  if [ -f "$(xdebug_extension_file)" ]; then
    success "Xdebug extension installed: $(xdebug_extension_file)"
  else
    warn "Xdebug extension file not found. Run: pecl install xdebug"
  fi
}

main() {
  case "${1:-}" in
    --help|-h)
      print_usage
      exit 0
      ;;
    "")
      print_usage
      exit 1
      ;;
    xdebug)
      shift
      case "${1:-}" in
        enable) xdebug_enable ;;
        disable) xdebug_disable ;;
        status) xdebug_status ;;
        --help|-h|"") print_usage ;;
        *)
          error "Unknown Xdebug action: $1"
          print_usage >&2
          exit 1
          ;;
      esac
      ;;
    *)
      error "Unknown PHP command: $1"
      print_usage >&2
      exit 1
      ;;
  esac
}

main "$@"
