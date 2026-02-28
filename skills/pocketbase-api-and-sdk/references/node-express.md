# Node.js / Express Pattern

## Service model
- Build a thin PocketBase service layer (`pbClient`, `query helpers`, `error mapper`).
- Centralize retries and timeout behavior in service utilities.

## API handlers
- Validate request payloads before hitting PocketBase.
- Map PocketBase errors to stable HTTP responses.

## Security
- Keep admin/service credentials server-side only.
- Enforce tenant or ownership checks at both API and PocketBase rule layers.
