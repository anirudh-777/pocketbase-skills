# PocketBase Skills

Open-source skill pack for easy PocketBase management with one default entry skill.

## Recommended usage
Start with `pocketbase-agent-orchestrator` for almost everything.

## Primary skill
- `pocketbase-agent-orchestrator`: default skill for setup, collection management, rules, health checks, API logs, and backup actions.

## Advanced skills (optional)
Use these only for deeper domain work:
- `pocketbase-foundations`
- `pocketbase-data-modeling`
- `pocketbase-auth-and-access`
- `pocketbase-api-and-sdk`
- `pocketbase-automation-and-hooks`
- `pocketbase-operations`

## Quick actions
Set credentials securely (recommended):

```bash
./skills/pocketbase-operations/scripts/pb_creds_setup.sh
set -a; source .env.pocketbase.local; set +a
```

Manual export (alternative):

```bash
export PB_URL="https://your-pocketbase.example.com"
export PB_ADMIN_EMAIL="admin@example.com"
export PB_ADMIN_PASSWORD="replace-me"
```

Run immediate operations:

```bash
# create collection
./skills/pocketbase-operations/scripts/pb_request.sh POST /api/collections '{"name":"tasks","type":"base","schema":[{"name":"title","type":"text","required":true},{"name":"done","type":"bool"}]}'

# list and update records
./skills/pocketbase-operations/scripts/pb_request.sh GET "/api/collections/tasks/records?page=1&perPage=20"
./skills/pocketbase-operations/scripts/pb_request.sh PATCH /api/collections/tasks/records/RECORD_ID '{"done":true}'

# API logs (filtered)
./skills/pocketbase-operations/scripts/pb_api_logs.sh --status-gte 400 --match "candidates,applications,resumes" --limit 80

# health check
./skills/pocketbase-operations/scripts/pb_healthcheck.sh
```

Optional runtime logs:

```bash
./skills/pocketbase-operations/scripts/pb_logs.sh --lines 300 --since 1h
./skills/pocketbase-operations/scripts/pb_logs.sh --follow
```

## License
MIT
