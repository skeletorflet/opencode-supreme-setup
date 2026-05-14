---
name: env
description: Environment configuration, variables, and secret management. Use when setting up environments.
---

## env

Manage environment configuration.

### Best practices
- .env for local dev (never committed)
- .env.example for docs
- Validate at startup
- Secrets manager for production
- Different config per environment
- Never hardcode secrets

### Tools
- dotenv, doppler, vault
- GitHub Actions secrets
- Docker secrets
- Kubernetes secrets
- Cloud secret managers
