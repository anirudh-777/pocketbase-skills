# PocketBase Skill Suite Design

## Goal
Create a production-ready set of agent skills that covers the full lifecycle of PocketBase usage: setup, schema design, authentication/authorization, data operations, automations, and operations.

## Design Choice
Use multiple focused skills instead of a single large skill.

Why:
- Better trigger precision: each skill activates only for relevant tasks.
- Smaller context load: avoids shipping all PocketBase guidance into every request.
- Easier maintenance: update one domain without touching unrelated workflows.

## Skill Boundaries
1. `pocketbase-foundations`
- Environment setup, local/dev/prod topology, CLI admin flow, safe defaults.

2. `pocketbase-data-modeling`
- Collections, field types, relations, indexes, migrations, and data integrity patterns.

3. `pocketbase-auth-and-access`
- Auth flows for email/password and OAuth, record ownership, RBAC-like rules via PocketBase API rules.

4. `pocketbase-api-and-sdk`
- REST and JS SDK operations for CRUD, filtering, sorting, pagination, expansion, and batch workflows.

5. `pocketbase-automation-and-hooks`
- Realtime subscriptions, file lifecycle, webhooks, and PocketBase hook patterns for business logic.

6. `pocketbase-operations`
- Backups, restore, health checks, incident triage, logs, performance, and security hardening.

## Navigation Pattern
Each skill keeps only execution workflow in `SKILL.md` and puts larger examples into `references/`.

## Guardrails
- Never disable auth rules in production to “move faster.”
- Validate schema and rules before data migration.
- Treat backup+restore rehearsal as required before major releases.
- Prefer deterministic command sequences and explicit environment variables.

## Success Criteria
- Agent can complete common PocketBase requests without guessing hidden steps.
- Each skill has clear trigger wording (`Use when ...`).
- Cross-skill handoffs are explicit (e.g., modeling -> auth rules -> API integration -> ops verification).
