---
name: pocketbase-data-modeling
description: Use when designing PocketBase collections, relations, indexes, and migrations, or when evolving schema without breaking existing data flows
---

# PocketBase Data Modeling

## Overview
Use this skill for collection design, schema evolution, and data integrity in PocketBase.

## When to Use
- Creating new collections/fields
- Adding relations and constraints
- Designing indexes and query patterns
- Planning breaking/non-breaking schema changes

## Workflow
1. Define access pattern first:
- Key reads, writes, filters, and sorting requirements
- Expected cardinality and data growth

2. Model collections:
- Use one collection per aggregate boundary
- Use relation fields instead of denormalizing blindly
- Keep metadata fields explicit (`status`, `createdBy`, `updatedBy`)

3. Define validation and integrity:
- Required fields and field-level constraints
- Enum-like constraints via select fields
- Unique indexes for identity fields

4. Add migration plan:
- Backward-compatible change first
- Data backfill/transform step
- Cleanup/deprecation step in later release

5. Validate with representative queries:
- Filtering, sorting, relation expansion, and pagination costs

6. Handoff:
- Rule implications -> `pocketbase-auth-and-access`
- API usage optimization -> `pocketbase-api-and-sdk`
- Migration safety and backups -> `pocketbase-operations`

## References
- [schema-patterns.md](references/schema-patterns.md)
- [migration-playbook.md](references/migration-playbook.md)
- [index-guidelines.md](references/index-guidelines.md)

## Common Mistakes
- Using one mega collection for unrelated entities
- Shipping breaking schema changes without staged migrations
- Adding relations without considering expansion/query performance
