---
name: deploy
description: Deployment automation, strategies, and best practices. Use when setting up or modifying deployments.
---

## deploy

Automate and improve deployments.

### Strategies
- Rolling: gradual instance replacement
- Blue/Green: two environments, swap traffic
- Canary: release to small subset
- Feature flags: deploy disabled, enable gradually

### Best practices
- Fully automated
- Health checks before routing
- Rollback capability
- Zero-downtime
- DB migrations before code deploy
