---
name: github-actions
description: Workflow YAML, jobs/steps, matrix builds, actions marketplace, caching, environments, secrets, service containers, artifacts, self-hosted runners.
---

## github-actions

Automate CI/CD with GitHub Actions.

### Workflow structure
- on: push, pull_request, schedule, workflow_dispatch
- jobs: runs-on, strategy.matrix, needs
- steps: uses, run, env, with
- Conditional execution with if expressions

### Marketplace and actions
- Official actions: actions/checkout, actions/setup-node
- Community actions from GitHub Marketplace
- Docker container actions
- JavaScript and composite actions

### Optimization
- Dependency caching with actions/cache
- Matrix builds for cross-version testing
- Parallel job execution
- Artifact upload and download

### Security
- Environments with protection rules
- Encrypted secrets per environment
- OIDC for cloud provider auth
- Self-hosted runners for private infra
