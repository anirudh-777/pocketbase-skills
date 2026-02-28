#!/usr/bin/env bash
set -euo pipefail

if [[ -z "${PB_URL:-}" ]]; then
  echo "PB_URL is required" >&2
  exit 1
fi

health_url="${PB_URL%/}/api/health"
status=$(curl -sS -o /tmp/pb-health.json -w "%{http_code}" "$health_url")

if [[ "$status" != "200" ]]; then
  echo "Health check failed: HTTP $status" >&2
  cat /tmp/pb-health.json >&2 || true
  exit 1
fi

echo "PocketBase health check OK"
cat /tmp/pb-health.json
