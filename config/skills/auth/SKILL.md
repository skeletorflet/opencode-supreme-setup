---
name: auth
description: Authentication and authorization patterns. Use when implementing login, permissions, or access control.
---

## auth

Implement secure authentication.

### Methods
- JWT: stateless tokens
- Session: server-side storage
- OAuth2: delegated auth (Google, GitHub)
- API keys: service-to-service
- WebAuthn: passwordless

### Security
- Hash passwords (bcrypt, argon2)
- HTTPS only
- Rate limit login
- CSRF protection
- CORS whitelist
- Token rotation
