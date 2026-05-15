---
name: turborepo
description: Turborepo — high-performance monorepo orchestration with caching, pipelines, and remote caching.
---

## turborepo

### Pipeline Configuration
- `turbo.json`: `{ "pipeline": { "build": { "dependsOn": ["^build"], "outputs": ["dist/**"] } } }`.
- `dependsOn: ["^build"]` — wait for dependency builds first (^ = upstream).
- `dependsOn: ["//#typecheck"]` — root-level tasks.
- `inputs: ["src/**", "tsconfig.json"]` — granular cache key.

### Caching
- Local cache: `.turbo` directory — automatic on task completion.
- Remote caching: `turbo login` + `turbo link` — share cache across CI/team.
- `--no-cache` to skip; `--force` to ignore cache; `--dry-run` to preview.
- Cache outputs: files, logs, artifacts matching `outputs` globs.

### Task Orchestration
- `turbo run build lint test --parallel` — run multiple tasks.
- `--filter="apps/web..."` — scope to package and its dependents.
- `--continue` — run all tasks regardless of failures.
- `--concurrency=4` — limit parallel execution count.

### Ecosystem Integration
- Next.js: `"build": { "outputs": [".next/**"] }` — automatic caching.
- pnpm workspaces: `packageManager: "pnpm@9.x"` in root `package.json`.
- Docker multi-stage: copy monorepo, prune dev deps, `turbo prune --scope=web`.
- `turbo gen` — code generators for packages and configurations.
