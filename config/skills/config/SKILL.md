---
name: config
description: Configuration management for applications, tools, and environments. Use when setting up or modifying configs.
---

## config

Manage configuration effectively.

### Best practices
- Env vars for secrets (never hardcode)
- Config files for non-sensitive settings
- Validate at startup (fail fast)
- Type-safe schemas
- Defaults for optional settings
- Different configs per environment

### Tools
- dotenv for env files
- zod/yup for schema validation
- cosmiconfig for loading
- Docker env for containers
