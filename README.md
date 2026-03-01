# PocketBase Skills

Open-source skill pack for AI coding agents to build and operate PocketBase apps end-to-end.

## What this repo includes

- `pocketbase-agent-orchestrator`: routes broad requests across domain skills
- `pocketbase-foundations`: setup, environment, admin bootstrap, safety baseline
- `pocketbase-data-modeling`: collections, relations, indexes, migrations
- `pocketbase-auth-and-access`: auth flows and access rules
- `pocketbase-api-and-sdk`: REST/SDK integration and query patterns
- `pocketbase-automation-and-hooks`: hooks, realtime, and file workflows
- `pocketbase-operations`: backups, restore drills, incident and hardening workflows

## Quick start

1. Copy `skills/*` folders into your Codex/agent skills directory.
2. Trigger the relevant skill by asking for a task in that domain.
3. For end-to-end tasks, start with `pocketbase-agent-orchestrator`.

## Quick actions

Set credentials:

```bash
export PB_URL="https://your-pocketbase.example.com"
export PB_ADMIN_EMAIL="admin@example.com"
export PB_ADMIN_PASSWORD="replace-me"
```

Run immediate operations:

```bash
# create collection
./skills/pocketbase-operations/scripts/pb_request.sh POST /api/collections '{"name":"tasks","type":"base","schema":[{"name":"title","type":"text","required":true},{"name":"done","type":"bool"}]}'

# list records
./skills/pocketbase-operations/scripts/pb_request.sh GET "/api/collections/tasks/records?page=1&perPage=20"

# update record
./skills/pocketbase-operations/scripts/pb_request.sh PATCH /api/collections/tasks/records/RECORD_ID '{"done":true}'

# health check
./skills/pocketbase-operations/scripts/pb_healthcheck.sh

# API logs (filtered)
./skills/pocketbase-operations/scripts/pb_api_logs.sh --status-gte 400 --match "candidates,applications,resumes" --limit 80

# logs
./skills/pocketbase-operations/scripts/pb_logs.sh --lines 300 --since 1h
```

For rule updates, live log follow, and backup flow, use the full Quick Actions block in:
`skills/pocketbase-agent-orchestrator/SKILL.md`.

## Stack packs

`pocketbase-api-and-sdk` includes practical references for:
- Next.js (App Router)
- Node.js/Express server integrations
- React Native/Expo mobile clients

## License

MIT
