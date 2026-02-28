# REST Cheatsheet

- List records: `GET /api/collections/{collection}/records`
- View record: `GET /api/collections/{collection}/records/{id}`
- Create record: `POST /api/collections/{collection}/records`
- Update record: `PATCH /api/collections/{collection}/records/{id}`
- Delete record: `DELETE /api/collections/{collection}/records/{id}`

Common query params:
- `page`, `perPage`
- `filter`, `sort`
- `expand`, `fields`
