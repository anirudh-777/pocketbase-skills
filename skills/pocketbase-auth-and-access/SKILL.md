---
name: pocketbase-auth-and-access
description: Use when implementing PocketBase authentication, authorization rules, ownership checks, and role-based access behavior across collections
---

# PocketBase Auth and Access

## Overview
Use this skill to implement secure auth flows and record-level access rules.

## When to Use
- User auth flows (email/password, OAuth providers)
- Access rule design for list/view/create/update/delete
- Ownership and team-based access patterns
- Session/token lifecycle and secure client usage

## Workflow
1. Identify actor model:
- Public user
- Authenticated user
- Elevated/internal actor

2. Define collection rules by operation:
- `listRule`, `viewRule`, `createRule`, `updateRule`, `deleteRule`
- Enforce least privilege and explicit owner/team checks

3. Map roles and claims:
- Represent role in user or membership records
- Evaluate role + resource ownership in rules

4. Validate auth flows:
- Sign up, sign in, refresh, sign out
- Password reset and email verification
- OAuth account linking behavior

5. Threat checks:
- Confirm private data cannot be listed via weak rules
- Confirm cross-tenant access is blocked
- Confirm server-side operations use secure service paths

6. Handoff:
- API integration with correct token handling -> `pocketbase-api-and-sdk`
- Incident response for auth failures -> `pocketbase-operations`

## References
- [rule-patterns.md](references/rule-patterns.md)
- [auth-flow-checklist.md](references/auth-flow-checklist.md)
- [multitenancy-pattern.md](references/multitenancy-pattern.md)

## Common Mistakes
- Using permissive list rules and relying on client filtering
- Encoding critical authorization only in frontend logic
- Forgetting to test unauthorized and cross-tenant access cases
