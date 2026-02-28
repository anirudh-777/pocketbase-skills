# Environment Template

```bash
PB_URL=https://your-pocketbase.example.com
PB_ADMIN_EMAIL=admin@example.com
PB_ADMIN_PASSWORD=replace-me
PB_DATA_DIR=/var/lib/pocketbase
```

Notes:
- Never commit secrets.
- Use `.env.local` for development and secret manager injection for production.
