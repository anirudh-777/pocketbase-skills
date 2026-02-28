# Filter Examples

- Exact match: `status = "active"`
- Date range: `created >= "2026-01-01" && created < "2026-02-01"`
- Ownership: `owner = @request.auth.id`
- Membership style: `organization = "ORG_ID" && archived = false`

Always validate filter shape and avoid user-provided raw filter injection.
