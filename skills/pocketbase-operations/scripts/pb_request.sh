#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 2 ]]; then
  echo "Usage: $0 <METHOD> <PATH> [JSON_BODY]" >&2
  echo "Example: $0 GET /api/collections/tasks/records" >&2
  exit 1
fi

: "${PB_URL:?PB_URL is required}"
: "${PB_ADMIN_EMAIL:?PB_ADMIN_EMAIL is required}"
: "${PB_ADMIN_PASSWORD:?PB_ADMIN_PASSWORD is required}"

method="$1"
path="$2"
body="${3:-}"

base="${PB_URL%/}"
admin_auth_endpoint="$base/api/admins/auth-with-password"

admin_token=$(
  curl -sS -X POST "$admin_auth_endpoint" \
    -H 'Content-Type: application/json' \
    -d "{\"identity\":\"$PB_ADMIN_EMAIL\",\"password\":\"$PB_ADMIN_PASSWORD\"}" \
    | sed -n 's/.*"token":"\([^"]*\)".*/\1/p'
)

if [[ -z "$admin_token" ]]; then
  echo "Failed to obtain admin token" >&2
  exit 1
fi

url="$base${path}"

if [[ -n "$body" ]]; then
  curl -sS -X "$method" "$url" \
    -H "Authorization: Bearer $admin_token" \
    -H 'Content-Type: application/json' \
    -d "$body"
else
  curl -sS -X "$method" "$url" \
    -H "Authorization: Bearer $admin_token"
fi
