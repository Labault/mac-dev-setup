#!/usr/bin/env bats

setup() {
  load test_helper
  REPO_DIR="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
  # Sourcing loads the pure helpers without running main (BASH_SOURCE != $0).
  source "$REPO_DIR/scripts/swiftbar/sites.5m.sh"
  # The plugin enables `set -euo pipefail`; relax it for the test driver.
  set +e +u +o pipefail
}

@test "trim strips leading and trailing whitespace" {
  run trim "   hello world   "
  [ "$output" = "hello world" ]
}

@test "status_is_expected matches a single expected status" {
  run status_is_expected "200" "200"
  [ "$status" -eq 0 ]
}

@test "status_is_expected matches within a CSV list and tolerates spaces" {
  run status_is_expected "301" "200, 301, 302"
  [ "$status" -eq 0 ]
}

@test "status_is_expected rejects an unlisted status" {
  run status_is_expected "500" "200,301"
  [ "$status" -ne 0 ]
}

@test "duration_to_ms converts seconds to rounded milliseconds" {
  run duration_to_ms "1.5"
  [ "$output" = "1500" ]
  run duration_to_ms "0.2503"
  [ "$output" = "250" ]
}

@test "main reports config missing when the file does not exist" {
  run env SWIFTBAR_SITES_CONFIG="/nonexistent/$$/sites.conf" \
    bash "$REPO_DIR/scripts/swiftbar/sites.5m.sh"
  [ "$status" -eq 0 ]
  [[ "$output" == *"config missing"* ]]
}

@test "main reports an OK site using a stubbed curl" {
  make_stub_bin bash awk date
  write_stub "$bin/curl" <<'CURL'
#!/bin/sh
printf '200|0.123'
CURL
  conf="$(mktemp)"
  printf 'Example|https://example.com|200|8|1500\n' >"$conf"

  run env PATH="$bin" SWIFTBAR_SITES_CONFIG="$conf" \
    bash "$REPO_DIR/scripts/swiftbar/sites.5m.sh"
  rm -rf "$bin" "$conf"

  [ "$status" -eq 0 ]
  [[ "$output" == *"Website OK (1/1)"* ]]
  [[ "$output" == *"Example | href=https://example.com"* ]]
}
