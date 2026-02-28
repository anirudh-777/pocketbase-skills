# JS SDK Patterns

## Client Setup
Create one configured PocketBase client per runtime context and set auth store strategy explicitly.

## Reads
Prefer `getList(page, perPage, { filter, sort, expand, fields })` for predictable pagination.

## Writes
Use `create`, `update`, `delete` with validated payloads.

## Realtime
Subscribe only where needed and always unsubscribe on teardown.
