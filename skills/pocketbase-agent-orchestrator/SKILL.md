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
