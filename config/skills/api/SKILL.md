---
name: api
description: Design and implement RESTful APIs, endpoints, and integration patterns. Use when building or modifying API endpoints.
---

## api

Design and implement APIs.

### RESTful design
- Nouns for resources: /users, /posts/:id
- HTTP methods: GET (read), POST (create), PUT (replace), PATCH (update), DELETE (remove)
- Consistent error responses
- Pagination for lists: ?page=1&limit=20
- Versioning: /v1/users

### Security
- Authentication via headers
- Input validation on all endpoints
- Rate limiting
- CORS configuration
- HTTPS only
