---
name: pocketbase-agent-orchestrator
description: Use when a task spans multiple PocketBase domains and needs coordinated setup, schema, access, API, automation, and operations decisions in one workflow
---

# PocketBase Agent Orchestrator

## Overview
Use this skill when the request is broad or end-to-end and requires combining multiple PocketBase skills.

## Workflow
1. Start with `pocketbase-foundations` for environment and safety baseline.
2. If schema work is needed, apply `pocketbase-data-modeling`.
3. If auth/rules are involved, apply `pocketbase-auth-and-access`.
4. If app integration is needed, apply `pocketbase-api-and-sdk`.
5. If event-driven behavior is needed, apply `pocketbase-automation-and-hooks`.
6. Before completion for production-facing changes, apply `pocketbase-operations` checks.

## Quick Actions
Use these first for fast PocketBase management tasks.

### Prerequisites
Set credentials once:

```bash
export PB_URL="https://your-pocketbase.example.com"
export PB_ADMIN_EMAIL="admin@example.com"
export PB_ADMIN_PASSWORD="replace-me"
```

All commands below use:
`skills/pocketbase-operations/scripts/pb_request.sh`

### 1) Create collection

```bash
./skills/pocketbase-operations/scripts/pb_request.sh POST /api/collections '{
  "name": "tasks",
  "type": "base",
  "schema": [
    { "name": "title", "type": "text", "required": true },
    { "name": "done", "type": "bool" }
  ]
}'
```

### 2) List/update records

```bash
# list records
./skills/pocketbase-operations/scripts/pb_request.sh GET "/api/collections/tasks/records?page=1&perPage=20"

# update a record
./skills/pocketbase-operations/scripts/pb_request.sh PATCH /api/collections/tasks/records/RECORD_ID '{
  "done": true
}'
```

### 3) Fix rules

```bash
# find collection id by name
COLL_ID=$(./skills/pocketbase-operations/scripts/pb_request.sh GET "/api/collections?filter=name%3D%22tasks%22" | sed -n 's/.*"id":"\([^"]*\)".*/\1/p' | head -n 1)

# patch access rules
./skills/pocketbase-operations/scripts/pb_request.sh PATCH "/api/collections/$COLL_ID" '{
  "listRule": "@request.auth.id != \"\"",
  "viewRule": "@request.auth.id != \"\"",
  "createRule": "@request.auth.id != \"\"",
  "updateRule": "@request.auth.id != \"\"",
  "deleteRule": "@request.auth.id != \"\""
}'
```

### 4) Backup/health/logs

```bash
# health check
./skills/pocketbase-operations/scripts/pb_healthcheck.sh

# logs (auto-detect: docker, systemd, file, or custom command)
./skills/pocketbase-operations/scripts/pb_logs.sh --lines 300 --since 1h

# follow logs live
./skills/pocketbase-operations/scripts/pb_logs.sh --follow

# backup (self-hosted PocketBase data dir example)
tar -czf "pocketbase-backup-$(date +%Y%m%d-%H%M%S).tar.gz" /var/lib/pocketbase
```

## Routing Heuristics
- "Set up PocketBase" -> foundations
- "Design collections/relations" -> data modeling
- "Fix permissions/auth" -> auth and access
- "Build SDK/API integration" -> api and sdk
- "Realtime/hooks/files" -> automation and hooks
- "Backup/restore/incident" -> operations

## Completion Criteria
- All touched domains include explicit verification steps.
- Security and backup implications are called out for production changes.
