# React Native / Expo Pattern

## Client strategy
- Use a mobile-safe auth store strategy and explicit logout cleanup.
- Avoid embedding admin/service credentials in app code.

## Sync model
- Use paginated pull + selective realtime subscriptions for active screens.
- Reconcile duplicate events defensively.

## Offline behavior
- Queue writes locally when offline.
- Replay writes with idempotency keys when connectivity resumes.
