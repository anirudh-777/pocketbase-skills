# Next.js App Router Pattern

## Recommended split
- Server routes/actions do privileged writes when needed.
- Browser code uses user-authenticated PocketBase operations only.

## Setup
- Initialize PocketBase client per request context on the server.
- Keep admin credentials out of browser bundles.

## Data fetching
- Use route handlers for filtered list endpoints requiring extra policy controls.
- Apply pagination defaults (`page`, `perPage`) consistently.

## Auth handling
- Persist auth state in secure storage patterns suitable for your Next.js deployment model.
- Validate session state before every server-side privileged operation.
