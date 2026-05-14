---
name: ci
description: CI/CD pipeline configuration and automation. Use when setting up or modifying build, test, and deployment pipelines.
---

## ci

Set up CI/CD pipelines.

### Pipeline stages
- Lint: check code style
- Type-check: verify types
- Test: unit + integration + E2E
- Build: compile/bundle
- Deploy: publish

### Best practices
- Fastest checks first (fail fast)
- Cache dependencies
- Matrix builds for versions
- Store build artifacts
- Notify on failures
