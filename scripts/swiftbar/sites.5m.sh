#!/usr/bin/env bash
set -euo pipefail

# SwiftBar plugin: monitor websites from a pipe-separated config file.
# Config format: label|url|expected_statuses|timeout_seconds|slow_threshold_ms

CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
CONFIG_FILE="${SWIFTBAR_SITES_CONFIG:-$CONFIG_HOME/swiftbar/sites.conf}"
DEFAULT_EXPECTED_STATUSES="200"
DEFAULT_TIMEOUT_SECONDS="8"
DEFAULT_SLOW_THRESHOLD_MS="1500"
COLOR_OK="#22863a"
COLOR_FAIL="#cb2431"
COLOR_SLOW="#b08800"

ok_count=0
fail_count=0
slow_count=0
total_count=0
total_ms=0
slowest_ms=0
slowest_label=""
details=()

trim() {
  local value="$1"
  value="${value#"${value%%[![:space:]]*}"}"
  value="${value%"${value##*[![:space:]]}"}"
  printf '%s' "$value"
}

status_is_expected() {
  local status="$1"
  local expected_csv="$2"
  local expected

  IFS=',' read -ra expected_statuses <<< "$expected_csv"
  for expected in "${expected_statuses[@]}"; do
    expected="$(trim "$expected")"
    if [[ "$status" == "$expected" ]]; then
      return 0
    fi
  done

  return 1
}

add_detail() {
  local icon="$1"
  local label="$2"
  local status="$3"
  local duration_ms="$4"
  local url="$5"
  local color="$6"

  details+=("$label | href=$url")
  details+=("--$icon | color=$color")
  details+=("--HTTP $status, ${duration_ms}ms")
}

duration_to_ms() {
  local duration_seconds="$1"
  awk -v seconds="$duration_seconds" 'BEGIN { printf "%d", (seconds * 1000) + 0.5 }'
}

if [[ ! -f "$CONFIG_FILE" ]]; then
  echo "Sites: config missing"
  echo "---"
  echo "Create $CONFIG_FILE"
  exit 0
fi

while IFS='|' read -r raw_label raw_url raw_expected raw_timeout raw_slow_ms _; do
  label="$(trim "${raw_label:-}")"
  url="$(trim "${raw_url:-}")"
  expected="$(trim "${raw_expected:-$DEFAULT_EXPECTED_STATUSES}")"
  timeout="$(trim "${raw_timeout:-$DEFAULT_TIMEOUT_SECONDS}")"
  slow_ms="$(trim "${raw_slow_ms:-$DEFAULT_SLOW_THRESHOLD_MS}")"

  [[ -z "$label" || "$label" == \#* ]] && continue
  [[ -z "$url" ]] && continue
  [[ -z "$expected" ]] && expected="$DEFAULT_EXPECTED_STATUSES"
  [[ -z "$timeout" ]] && timeout="$DEFAULT_TIMEOUT_SECONDS"
  [[ -z "$slow_ms" ]] && slow_ms="$DEFAULT_SLOW_THRESHOLD_MS"

  total_count=$((total_count + 1))

  response="$(
    curl \
      --location \
      --silent \
      --show-error \
      --output /dev/null \
      --write-out "%{http_code}|%{time_total}" \
      --max-time "$timeout" \
      "$url" 2>/dev/null
  )"

  if [[ -z "$response" ]]; then
    fail_count=$((fail_count + 1))
    details+=("X $label - no response | href=$url")
    continue
  fi

  status="${response%%|*}"
  duration="${response##*|}"
  duration_ms="$(duration_to_ms "$duration")"
  total_ms=$((total_ms + duration_ms))

  if [[ "$duration_ms" -gt "$slowest_ms" ]]; then
    slowest_ms="$duration_ms"
    slowest_label="$label"
  fi

  if status_is_expected "$status" "$expected"; then
    ok_count=$((ok_count + 1))
    if [[ "$duration_ms" -gt "$slow_ms" ]]; then
      slow_count=$((slow_count + 1))
      add_detail "SLOW" "$label" "$status" "$duration_ms" "$url" "$COLOR_SLOW"
    else
      add_detail "OK" "$label" "$status" "$duration_ms" "$url" "$COLOR_OK"
    fi
  else
    fail_count=$((fail_count + 1))
    add_detail "FAIL" "$label" "$status" "$duration_ms" "$url" "$COLOR_FAIL"
  fi
done < "$CONFIG_FILE"

if [[ "$total_count" -eq 0 ]]; then
  echo "Sites: none"
  echo "---"
  echo "Add sites to $CONFIG_FILE"
  exit 0
fi

average_ms=$((total_ms / total_count))

if [[ "$fail_count" -eq 0 ]]; then
  echo "Website OK ($ok_count/$total_count)"
else
  echo "Website FAIL ($fail_count/$total_count)"
fi

echo "---"
echo "Summary"
echo "--Average response: ${average_ms}ms"
echo "--Slow sites: $slow_count"
echo "--Slowest: $slowest_label (${slowest_ms}ms)"
echo "--Last check: $(date '+%H:%M:%S')"
echo "---"
echo "Sites"
printf '%s\n' "${details[@]}"
echo "---"
echo "Settings"
echo "--Config: $CONFIG_FILE"
echo "Refresh | refresh=true"
