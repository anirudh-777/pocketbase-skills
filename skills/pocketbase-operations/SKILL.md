---
name: pocketbase-operations
description: Use when running PocketBase backups, restore drills, incident triage, health checks, security hardening, or production reliability workflows
---

# PocketBase Operations

## Overview
Use this skill for operating PocketBase reliably in staging and production.

## When to Use
- Backup and restore workflows
- Incident triage and degraded performance
- Log inspection and root-cause analysis
- Security hardening and operational readiness checks

## Workflow
1. Run health checks:
- API reachability
- auth path behavior
- storage path and disk pressure checks

2. Backup posture:
- Verify backup schedule and retention
- Verify backups are readable and restorable

3. Restore drill:
- Restore latest backup in staging
- Run smoke tests for critical auth and data paths

4. Incident triage:
- Capture timeline, affected endpoints, and error rates
- Classify issue: auth, query/performance, storage, network
- Apply safe rollback or mitigation

5. Security hardening:
- Rotate admin/service credentials regularly
- Confirm HTTPS and strict network boundaries
- Validate admin UI exposure policy

6. Handoff:
- Schema/query regressions -> `pocketbase-data-modeling`
- Rule/auth regression -> `pocketbase-auth-and-access`
- Client integration faults -> `pocketbase-api-and-sdk`

## Scripts
- `scripts/pb_healthcheck.sh`
- `scripts/pb_request.sh`

## References
- [incident-runbook.md](references/incident-runbook.md)
- [backup-restore-checklist.md](references/backup-restore-checklist.md)
- [security-hardening.md](references/security-hardening.md)

## Common Mistakes
- Assuming backup success without restore verification
- Investigating incidents without preserving timeline evidence
- Delaying secret rotation after admin credential exposure
