---
name: logging
description: Logging best practices and observability. Use when adding or reviewing logging in applications.
---

## logging

Implement effective logging.

### Log levels
- ERROR: needs immediate attention
- WARN: unexpected but handled
- INFO: normal milestones
- DEBUG: detailed diagnostics
- TRACE: very detailed flow

### Best practices
- Structured data (JSON)
- Include context: request ID, user ID
- Never log sensitive data
- Correlation IDs across services
- Appropriate levels per environment
