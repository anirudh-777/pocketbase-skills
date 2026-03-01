#!/usr/bin/env bash
set -euo pipefail

# Query PocketBase API logs from /api/logs with common filters.

base_url="${PB_URL:-${NEXT_PUBLIC_POCKETBASE_URL:-}}"
identity="${PB_ADMIN_EMAIL:-${PB_SUPERUSER_EMAIL:-${POCKETBASE_SERVICE_EMAIL:-}}}"
password="${PB_ADMIN_PASSWORD:-${PB_SUPERUSER_PASSWORD:-${POCKETBASE_SERVICE_PASSWORD:-}}}"

status_gte=400
limit=120
page=1
sort="-created"
match_csv=""
since=""
format="text"

usage() {
  cat <<'USAGE'
Usage: pb_api_logs.sh [options]

Options:
  --status-gte N      Include logs with status >= N (default: 400)
  --limit N           perPage limit (default: 120)
  --page N            Page number (default: 1)
  --sort VALUE        Sort field (default: -created)
  --match CSV         Case-insensitive keyword list, comma-separated
  --since ISO_8601    Include logs with created >= timestamp (UTC ISO8601)
  --format text|json  Output mode (default: text)
  -h, --help          Show help

Credentials (first non-empty wins):
  URL:      PB_URL | NEXT_PUBLIC_POCKETBASE_URL
  identity: PB_ADMIN_EMAIL | PB_SUPERUSER_EMAIL | POCKETBASE_SERVICE_EMAIL
  password: PB_ADMIN_PASSWORD | PB_SUPERUSER_PASSWORD | POCKETBASE_SERVICE_PASSWORD

Example:
  pb_api_logs.sh --status-gte 400 --match "candidates,applications,resumes" --limit 80
USAGE
}

is_number() {
  [[ "$1" =~ ^[0-9]+$ ]]
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --status-gte)
      status_gte="${2:-}"
      shift 2
      ;;
    --limit)
      limit="${2:-}"
      shift 2
      ;;
    --page)
      page="${2:-}"
      shift 2
      ;;
    --sort)
      sort="${2:-}"
      shift 2
      ;;
    --match)
      match_csv="${2:-}"
      shift 2
      ;;
    --since)
      since="${2:-}"
      shift 2
      ;;
    --format)
      format="${2:-}"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage
      exit 1
      ;;
  esac
done

if [[ -z "$base_url" || -z "$identity" || -z "$password" ]]; then
  echo "Missing credentials. Set PB_URL/NEXT_PUBLIC_POCKETBASE_URL and service credentials." >&2
  exit 1
fi

if ! is_number "$status_gte" || ! is_number "$limit" || ! is_number "$page"; then
  echo "--status-gte, --limit, and --page must be integers" >&2
  exit 1
fi

if [[ "$format" != "text" && "$format" != "json" ]]; then
  echo "--format must be one of: text, json" >&2
  exit 1
fi

if ! command -v jq >/dev/null 2>&1; then
  echo "jq is required. Install jq and retry." >&2
  exit 1
fi

base="${base_url%/}"

get_token() {
  local -a paths=(
    "/api/collections/_superusers/auth-with-password"
    "/api/admins/auth-with-password"
  )

  local p response token
  for p in "${paths[@]}"; do
    response=$(curl -sS -X POST "$base$p" \
      -H 'Content-Type: application/json' \
      -d "{\"identity\":\"$identity\",\"password\":\"$password\"}" || true)
    token=$(printf '%s' "$response" | jq -r '.token // empty')
    if [[ -n "$token" ]]; then
      printf '%s' "$token"
      return 0
    fi
  done

  return 1
}

token="$(get_token)" || {
  echo "Failed to authenticate against PocketBase superuser/admin endpoints." >&2
  exit 1
}

query="perPage=$limit&page=$page&sort=$sort"
if [[ -n "$since" ]]; then
  since_filter=$(printf 'created >= "%s"' "$since" | jq -sRr @uri)
  query="$query&filter=$since_filter"
fi

raw=$(curl -sS "$base/api/logs?$query" -H "Authorization: Bearer $token")

jq_filter='(.items // [])
  | map(select(((.data.status // 0) >= $status_gte)))'

if [[ -n "$match_csv" ]]; then
  jq_filter="$jq_filter | map(select(
    ((.data.url // "") | test(\$match_regex; "i")) or
    ((.data.error // "") | test(\$match_regex; "i")) or
    ((.data.details // "") | test(\$match_regex; "i"))
  ))"
fi

if [[ "$format" == "json" ]]; then
  if [[ -n "$match_csv" ]]; then
    printf '%s' "$raw" | jq --argjson status_gte "$status_gte" --arg match_regex "$(printf '%s' "$match_csv" | sed 's/,/|/g')" "$jq_filter"
  else
    printf '%s' "$raw" | jq --argjson status_gte "$status_gte" "$jq_filter"
  fi
  exit 0
fi

text_filter='map("[\(.created // "unknown")] status=\(.data.status // 0) method=\(.data.method // "") url=\(.data.url // "")\n  error=\(.data.error // "")\n  details=\(.data.details // "")") | .[]'

if [[ -n "$match_csv" ]]; then
  printf '%s' "$raw" | jq -r --argjson status_gte "$status_gte" --arg match_regex "$(printf '%s' "$match_csv" | sed 's/,/|/g')" "$jq_filter | $text_filter"
else
  printf '%s' "$raw" | jq -r --argjson status_gte "$status_gte" "$jq_filter | $text_filter"
fi
