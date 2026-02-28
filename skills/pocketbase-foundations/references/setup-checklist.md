# Setup Checklist

## Service
- Confirm PocketBase binary/container version is pinned.
- Confirm data path persistence policy.
- Confirm file storage strategy (local filesystem or external mount).

## Access
- Create admin only in secure environment.
- Store admin secrets in secret manager, not in repo.
- Validate `/api/health` and admin auth endpoints.

## Network
- Enforce HTTPS in production.
- Restrict CORS to explicit origins.
- Restrict admin UI/network access where possible.

## Recovery
- Define backup frequency and retention.
- Run at least one restore drill on staging.
