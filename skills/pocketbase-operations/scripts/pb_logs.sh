#!/usr/bin/env bash
set -euo pipefail

# PocketBase log viewer with auto-detection for common deployment styles.
# Supported sources: systemd, docker, file, custom command.

mode="${PB_LOG_MODE:-auto}"
lines=200
since=""
follow=false

systemd_unit="${PB_LOG_SYSTEMD_UNIT:-pocketbase.service}"
docker_container="${PB_LOG_DOCKER_CONTAINER:-pocketbase}"
log_file="${PB_LOG_FILE:-/var/log/pocketbase.log}"
log_cmd="${PB_LOG_CMD:-}"

usage() {
  cat <<'EOF'
Usage: pb_logs.sh [--mode auto|systemd|docker|file|cmd] [--lines N] [--since DURATION] [--follow]

Options:
  --mode    Log source mode (default: auto)
  --lines   Number of log lines to show (default: 200)
  --since   Time window for logs (examples: 15m, 1h, 1d)
  --follow  Stream logs continuously

Environment:
  PB_LOG_MODE              Default mode if --mode not provided
  PB_LOG_SYSTEMD_UNIT      systemd unit (default: pocketbase.service)
  PB_LOG_DOCKER_CONTAINER  Docker container name (default: pocketbase)
  PB_LOG_FILE              Log file path (default: /var/log/pocketbase.log)
  PB_LOG_CMD               Custom log command (used in cmd mode)
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --mode)
      mode="${2:-}"
      shift 2
      ;;
    --lines)
      lines="${2:-}"
      shift 2
      ;;
    --since)
      since="${2:-}"
      shift 2
      ;;
    --follow)
      follow=true
      shift
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

is_number() {
  [[ "$1" =~ ^[0-9]+$ ]]
}

if ! is_number "$lines"; then
  echo "--lines must be a positive integer" >&2
  exit 1
fi

detect_mode() {
  if [[ -n "$log_cmd" ]]; then
    echo "cmd"
    return
  fi

  if command -v docker >/dev/null 2>&1; then
    if docker ps --format '{{.Names}}' | grep -Fxq "$docker_container"; then
      echo "docker"
      return
    fi
  fi

  if command -v systemctl >/dev/null 2>&1; then
    if systemctl list-units --all --type=service --no-legend 2>/dev/null | awk '{print $1}' | grep -Fxq "$systemd_unit"; then
      echo "systemd"
      return
    fi
  fi

  if [[ -f "$log_file" ]]; then
    echo "file"
    return
  fi

  echo "none"
}

run_systemd() {
  local -a cmd=(journalctl -u "$systemd_unit" -n "$lines" --no-pager)
  if [[ -n "$since" ]]; then
    cmd+=(--since "-$since")
  fi
  if [[ "$follow" == "true" ]]; then
    cmd+=(-f)
  fi
  "${cmd[@]}"
}

run_docker() {
  local -a cmd=(docker logs --tail "$lines")
  if [[ -n "$since" ]]; then
    cmd+=(--since "$since")
  fi
  if [[ "$follow" == "true" ]]; then
    cmd+=(-f)
  fi
  cmd+=("$docker_container")
  "${cmd[@]}"
}

run_file() {
  if [[ "$follow" == "true" ]]; then
    tail -n "$lines" -f "$log_file"
  else
    tail -n "$lines" "$log_file"
  fi
}

run_cmd() {
  if [[ -z "$log_cmd" ]]; then
    echo "PB_LOG_CMD is required when mode=cmd" >&2
    exit 1
  fi
  bash -lc "$log_cmd"
}

if [[ "$mode" == "auto" ]]; then
  mode="$(detect_mode)"
fi

case "$mode" in
  systemd)
    run_systemd
    ;;
  docker)
    run_docker
    ;;
  file)
    run_file
    ;;
  cmd)
    run_cmd
    ;;
  *)
    echo "Unable to detect PocketBase logs automatically." >&2
    echo "Set one of these and retry:" >&2
    echo "  PB_LOG_SYSTEMD_UNIT, PB_LOG_DOCKER_CONTAINER, PB_LOG_FILE, or PB_LOG_CMD" >&2
    echo "Or use: --mode systemd|docker|file|cmd" >&2
    exit 1
    ;;
esac
