---
name: pocketbase-foundations
description: Use when setting up PocketBase environments, configuring initial admin access, or planning safe local-to-production rollout for new PocketBase projects
---

# PocketBase Foundations

## Overview
Use this skill to establish a safe PocketBase baseline before schema, auth rules, or app integration work.

## When to Use
- New PocketBase project setup
- Local/dev/prod environment planning
- Admin bootstrap and API endpoint sanity checks
- Pre-flight checks before handing off to modeling/auth/api skills

Do not use this skill for detailed schema design or auth rules. Hand off to domain skills.

## Workflow
1. Confirm runtime mode:
- Local development with ephemeral data
- Shared staging environment
- Production environment with persistent storage

2. Establish required environment variables:
- `PB_URL`
- `PB_ADMIN_EMAIL`
- `PB_ADMIN_PASSWORD`
- `PB_DATA_DIR` (if self-hosted deployment structure is managed)

3. Verify service reachability and version:
- Confirm API health and auth endpoint response
- Confirm expected PocketBase version and plugin compatibility

4. Create admin and lock down access:
- Use strong credentials
- Restrict admin credentials to runtime secret stores
- Never embed admin credentials in client applications

5. Baseline security posture:
- Ensure HTTPS for all non-local deployments
- Confirm CORS origins are intentionally configured
- Confirm backup directory and retention plan exist

6. Handoff:
- If designing schema -> `pocketbase-data-modeling`
- If defining access controls -> `pocketbase-auth-and-access`
- If wiring client/server integration -> `pocketbase-api-and-sdk`
- If deployment hardening/monitoring -> `pocketbase-operations`

## References
- [setup-checklist.md](references/setup-checklist.md)
- [env-template.md](references/env-template.md)

## Common Mistakes
- Using admin credentials in frontend code
- Skipping HTTPS and secure cookie validation in production
- Treating staging data as disposable when it is needed for migration rehearsal
