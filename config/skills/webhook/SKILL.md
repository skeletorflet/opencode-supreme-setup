---
name: webhook
description: Webhook implementation, handling, and security. Use when building or integrating webhooks.
---

## webhook

Implement and manage webhooks.

### Implementation
- POST with JSON payload
- Verify HMAC signature
- Respond 200 quickly, process async
- Idempotency keys for retry
- Event type in header
- Payload schema versioning

### Security
- Validate source IP
- HMAC shared secret
- Replay prevention (timestamp + nonce)
- Rate limit per source
- Log all events
