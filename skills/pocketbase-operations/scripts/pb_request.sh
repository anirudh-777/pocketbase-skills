#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 2 ]]; then
  echo "Usage: $0 <METHOD> <PATH> [JSON_BODY]" >&2
  echo "Example: $0 GET /api/collections/tasks/records" >&2
  exit 1
fi

base_url="${PB_URL:-${NEXT_PUBLIC_POCKETBASE_URL:-}}"
identity="${PB_ADMIN_EMAIL:-${PB_SUPERUSER_EMAIL:-${POCKETBASE_SERVICE_EMAIL:-}}}"
password="${PB_ADMIN_PASSWORD:-${PB_SUPERUSER_PASSWORD:-${POCKETBASE_SERVICE_PASSWORD:-}}}"

: "${base_url:?PB_URL or NEXT_PUBLIC_POCKETBASE_URL is required}"
: "${identity:?Set PB_ADMIN_EMAIL/PB_SUPERUSER_EMAIL/POCKETBASE_SERVICE_EMAIL}"
: "${password:?Set PB_ADMIN_PASSWORD/PB_SUPERUSER_PASSWORD/POCKETBASE_SERVICE_PASSWORD}"

method="$1"
path="$2"
body="${3:-}"

base="${base_url%/}"
admin_token=""
for auth_path in "/api/collections/_superusers/auth-with-password" "/api/admins/auth-with-password"; do
  admin_token=$(
    curl -sS -X POST "$base$auth_path" \
      -H 'Content-Type: application/json' \
      -d "{\"identity\":\"$identity\",\"password\":\"$password\"}" \
      | sed -n 's/.*"token":"\([^"]*\)".*/\1/p'
  )
  if [[ -n "$admin_token" ]]; then
    break
  fi
done

if [[ -z "$admin_token" ]]; then
  echo "Failed to obtain admin/superuser token" >&2
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
