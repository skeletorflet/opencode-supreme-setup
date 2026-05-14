---
name: rest
description: REST API design principles and implementation. Use when designing or consuming REST APIs.
---

## rest

Design clean REST APIs.

### URL structure
- /resources - collection
- /resources/:id - single resource
- /resources/:id/sub - nested

### Response format
- Consistent envelope: data, meta, error
- Standard status codes
- Meaningful error messages

### Status codes
- 200 OK, 201 Created, 204 No Content
- 400, 401, 403, 404
- 409 Conflict, 422 Unprocessable, 429 Too Many
- 500, 503
