---
name: pocketbase-api-and-sdk
description: Use when building PocketBase REST or SDK integrations for CRUD, filtering, expansion, pagination, and batch data workflows in client or server code
---

# PocketBase API and SDK

## Overview
Use this skill for reliable integration patterns with PocketBase REST and SDK APIs.

## When to Use
- CRUD endpoints and SDK method usage
- Filter/sort/paginate/expand query construction
- Batch workflows and idempotent write behavior
- Error handling and retry strategy in app integration

## Workflow
1. Choose execution context:
- Browser client
- Server-side app/service
- Background worker
- Stack profile: Next.js App Router, Node/Express, or React Native/Expo

2. Define data contract:
- Request fields and validation expectations
- Response projection and relation expansion requirements

3. Implement read patterns:
- Use pagination by default
- Use filter expressions intentionally
- Expand only required relations

4. Implement write patterns:
- Validate input before write
- Use deterministic retry for transient failures
- Prevent duplicate writes via business keys where needed

5. Error handling:
- Classify auth errors, validation errors, and transient/network errors
- Return structured errors to caller

6. Performance checks:
- Minimize over-expansion
- Avoid unbounded list pulls in production paths

7. Handoff:
- If schema pressure emerges -> `pocketbase-data-modeling`
- If permissions fail or leak -> `pocketbase-auth-and-access`
- If operational incidents appear -> `pocketbase-operations`

## References
- [rest-cheatsheet.md](references/rest-cheatsheet.md)
- [js-sdk-patterns.md](references/js-sdk-patterns.md)
- [filter-examples.md](references/filter-examples.md)
- [nextjs-app-router.md](references/nextjs-app-router.md)
- [node-express.md](references/node-express.md)
- [react-native-expo.md](references/react-native-expo.md)

## Common Mistakes
- Loading entire collections without pagination
- Expanding deep relations in latency-sensitive endpoints
- Treating all API errors as retryable
