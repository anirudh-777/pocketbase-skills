#!/usr/bin/env bash
set -euo pipefail

# Secure interactive setup for PocketBase credentials.

target_file=".env.pocketbase.local"
force=false

usage() {
  cat <<'USAGE'
Usage: pb_creds_setup.sh [--file PATH] [--force]

Options:
  --file PATH   Destination env file (default: .env.pocketbase.local)
  --force       Overwrite existing file without prompt
  -h, --help    Show help

This script writes:
  PB_URL
  PB_ADMIN_EMAIL
  PB_ADMIN_PASSWORD

The file is created with chmod 600.
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --file)
      target_file="${2:-}"
      shift 2
      ;;
    --force)
      force=true
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

if [[ -f "$target_file" && "$force" != "true" ]]; then
  printf "File %s exists. Overwrite? (y/N): " "$target_file"
  read -r ans
  case "$ans" in
    y|Y|yes|YES) ;;
    *) echo "Aborted."; exit 1 ;;
  esac
fi

printf "PocketBase URL (e.g. https://pb.example.com): "
read -r pb_url
printf "PocketBase admin/service email: "
read -r pb_email
printf "PocketBase admin/service password: "
read -rs pb_password
echo

if [[ -z "$pb_url" || -z "$pb_email" || -z "$pb_password" ]]; then
  echo "All fields are required." >&2
  exit 1
fi

# Write with restrictive permissions.
umask 077
cat > "$target_file" <<ENV
PB_URL="$pb_url"
PB_ADMIN_EMAIL="$pb_email"
PB_ADMIN_PASSWORD="$pb_password"
ENV
chmod 600 "$target_file"

echo
printf "Saved credentials to %s with mode 600.\n" "$target_file"
echo "Load in current shell with:"
printf "  set -a; source %s; set +a\n" "$target_file"
echo "Security notes:"
echo "  - Never commit this file."
echo "  - Prefer secret managers in CI/production."
echo "  - Rotate credentials if exposed."
