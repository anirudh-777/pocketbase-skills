---
name: pocketbase-automation-and-hooks
description: Use when implementing PocketBase realtime subscriptions, hooks, file workflows, and event-driven business logic around record lifecycle changes
---

# PocketBase Automation and Hooks

## Overview
Use this skill to implement event-driven behavior in PocketBase with predictable side effects.

## When to Use
- Record lifecycle hooks and validations
- Realtime subscription flows
- File upload/delete lifecycle behavior
- Webhook or downstream event integration

## Workflow
1. Define event contract:
- Trigger source (create/update/delete/auth event)
- Required payload fields
- Side effects and idempotency expectations

2. Implement hook logic:
- Keep hooks deterministic and fast
- Reject invalid state transitions early
- Avoid long blocking network operations inside critical path

3. Realtime design:
- Subscribe to minimal channels/topics
- Handle reconnect and duplicate event delivery
- Unsubscribe on teardown

4. File handling:
- Enforce allowed mime types and max size
- Apply naming and retention policies
- Clean up orphaned file references

5. Observability:
- Log event identifiers and error context
- Track retries and dead-letter behavior for async side effects

6. Handoff:
- API consumers -> `pocketbase-api-and-sdk`
- Operational hardening -> `pocketbase-operations`

## References
- [hooks-patterns.md](references/hooks-patterns.md)
- [realtime-patterns.md](references/realtime-patterns.md)
- [file-workflows.md](references/file-workflows.md)

## Common Mistakes
- Non-idempotent hooks causing duplicate side effects
- Heavy network calls in synchronous lifecycle hooks
- Realtime listeners not unsubscribed in long-running clients
