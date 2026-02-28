# Multi-Tenancy Pattern

- Model `organizations` and `memberships` explicitly.
- Every tenant-scoped record includes `organization` relation.
- Access rules always validate membership for the current auth user.
- Never trust tenant filters from client input without rule enforcement.
