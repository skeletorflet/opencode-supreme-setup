# OpenCode Supreme Setup

![OpenCode Supreme Setup Banner](https://github.com/skeletorflet/opencode-supreme-setup/blob/master/banner.webp?raw=true)

> **The ULTIMATE one-command OpenCode setup** — 480+ skills, 15 plugins, SDD (Spec-Driven Development), Self-Healing automation, Superpowers workflow engine, and Caveman.

[![OpenCode](https://img.shields.io/badge/OpenCode-powered-6366f1?style=flat-square)](https://opencode.ai)
[![oh-my-openagent](https://img.shields.io/badge/oh--my--openagent-57.8k⭐-22c55e?style=flat-square)](https://github.com/code-yeongyu/oh-my-openagent)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=flat-square)](LICENSE)
[![CI](https://img.shields.io/github/actions/workflow/status/skeletorflet/opencode-supreme-setup/ci.yml?style=flat-square)](https://github.com/skeletorflet/opencode-supreme-setup/actions)
[![GitHub](https://img.shields.io/badge/GitHub-skeletorflet%2Fopencode--supreme--setup-181717?style=flat-square&logo=github)](https://github.com/skeletorflet/opencode-supreme-setup)

---

## What You Get

| Category | Included |
|----------|----------|
| **Agent Orchestration** | oh-my-openagent (Sisyphus, Team Mode, 8 parallel agents) |
| **Caveman v4** | Ultra-efficient AGENTS.md — surgical edits (AST/LSP), zero-fluff, English-only output |
| **Custom Agents** | `caveman`, `spec-architect`, `self-healer`, `security-auditor`, `docs-writer`, `refactor` |
| **Skills** | 465+ (135 built-in + 330 marketplace + 13 Superpowers workflow) |
| **Plugins** | snippets, snip, notify, mem, quota, background-agents, worktree, context-pruning, smart-title, ocwatch, superpowers, supermemory |
| **Memory** | Persistent vector-DB memory (`opencode-mem`) — cross-session context |
| **Token Savings** | `snip` CLI — filters shell output, 60-90% fewer tokens |
| **Model** | 100% `opencode-go/deepseek-v4-flash` across all agents |
| **Optimizations** | Hashline edits, runtime fallback, dynamic context pruning, auto-resume, cross-platform |

## Prerequisites

- **Node.js** 18+ • **Bun** 1.x (auto-installed) • **PowerShell 7+** or **bash 4+**
- **OpenCode Go** subscription ([$10/mo](https://opencode.ai/pricing)) or other provider key

## Quick Install

### Windows (PowerShell 7+)

```powershell
irm https://raw.githubusercontent.com/skeletorflet/opencode-supreme-setup/master/install.ps1 | iex
```

### Linux / macOS

```bash
curl -fsSL https://raw.githubusercontent.com/skeletorflet/opencode-supreme-setup/master/install.sh | bash
```

### Or clone

```bash
git clone https://github.com/skeletorflet/opencode-supreme-setup.git && cd opencode-supreme-setup
# Windows: .\install.ps1
# Linux/macOS: chmod +x install.sh && ./install.sh
```

## What Gets Installed

The installer runs 13 automated steps:

| Step | What |
|------|------|
| 1 | Prerequisites (Node.js, PowerShell 7+) |
| 2 | OpenCode + Bun |
| 3 | Provider subscription configuration |
| 4 | oh-my-openagent (agent orchestration) |
| 5 | Config files + 135 built-in skills (SDD & Self-Healing) |
| 6 | Platform optimizations (tmux on/off, model overrides) |
| 7 | Developer tools (comment-checker, ast-grep, GitHub CLI) |
| 8 | **12 essential plugins** (snippets, snip, notify, mem, quota, background-agents, worktree, context-pruning, smart-title, ocwatch, superpowers, supermemory) |
| 9 | **OpenSkills — 100+ marketplace skills** (from anthropics/skills) |
| 10 | **Superpowers — 13 workflow skills** (from obra/superpowers) — TDD, debugging, planning, code review, subagent-driven dev, worktree isolation |
| 11 | Optional: agentsys (20 plugins, 49 agents, 41 skills) |
| 12 | Optional: supermemory, firecrawl, WakaTime, themes |
| 13 | Verification (oh-my-openagent doctor) |
| 14 | Summary |
| 15 | Done! |

## Plugins

| Plugin | What It Does |
|--------|-------------|
| **oh-my-openagent** | Sisyphus orchestrator, Team Mode, 8 parallel agents, Advanced MCPs |
| **opencode-snippets** | `#snippet` inline text expansion — DRY for prompts |
| **opencode-snip** | Auto-prefixes shell commands with `snip` → 60-90% token reduction |
| **opencode-notify** | Native OS notifications when tasks complete |
| **opencode-mem** | Persistent vector-DB memory with web UI (localhost:4747) |
| **opencode-quota** | Token usage and cost tracking with toasts |
| **opencode-background-agents** | Claude Code-style background/async agent delegation |
| **opencode-worktree** | Zero-friction isolated git worktrees |
| **opencode-dynamic-context-pruning** | Auto-prune obsolete tool outputs from context |
| **opencode-smart-title** | Auto-generates meaningful session titles |
| **ocwatch** | Real-time visual dashboard for agent activity monitoring |
| **superpowers** | Full-stack engineering workflow — brainstorming, TDD, subagent-driven development, systematic debugging, code review, worktrees, verification |
| **supermemory** | Persistent cross-session knowledge with web UI |

## Skills

### 135 Built-in Skills

**Core** (53): a11y, api, arch, async, auth, benchmark, caching, ci, cleanup, cli, config, css, data, db, debug, deploy, docker, docs, env, error, find, git, git-master, graphql, i18n, json, logging, markdown, mcp, migration, monitoring, naming, node, onboard, openspec, perf, playwright, pr-review, python, react, refactor, regex, rest, scaffold, security, self-healing, serialize, shell, state, test, typescript, ui, webhook

| Category | Skills |
|----------|--------|
| **Frontend** (12) | angular, astro, gatsby, gsap, htmx, motion-framer, nextjs, nuxt, svelte, tailwind, threejs, vue |
| **Backend** (16) | actix-web, aspnet-core, bun, django, elysia, express, fastapi, fastify, fiber, flask, gin, hono, koa, laravel, nestjs, rails |
| **Languages** (9) | dart, deno, elixir, go-lang, kotlin, rust, solidjs, swift, zig |
| **Mobile/Desktop** (4) | electron, flutter, react-native, tauri |
| **Databases** (7) | drizzle, mongodb, postgresql, prisma, redis, sqlite, supabase |
| **AI/ML** (6) | crewai, huggingface, langchain, ollama, pytorch, tensorflow |
| **DevOps** (6) | ansible, github-actions, helm, kubernetes, pulumi, terraform |
| **Testing** (3) | cypress, sentry, vitest |
| **Design** (7) | d3js, material-ui, shadcn, react-hook-form, tanstack-query, trpc, zustand |
| **Tools** (12) | clerk, esbuild, nx, pnpm, qwik, remix, spring-boot, stripe, sveltekit, turborepo, vite, zod |

### 100+ Marketplace Skills (via OpenSkills)
PDF manipulation, image analysis, data visualization, git workflows, code review, documentation, deployment, security auditing, and more.

Use: `npx openskills read <skill-name>`

### 13 Superpowers Workflow Skills (from obra/superpowers)
Engineering methodology pipeline: brainstorming → writing-plans → subagent-driven-development (with spec + quality review) → requesting-code-review → finishing-a-development-branch. Plus: systematic-debugging, verification-before-completion, test-driven-development, using-git-worktrees.

## Usage

```bash
opencode                    # Launch
ocwatch                     # Open visual dashboard (localhost:3000)
ulw <task>                  # Ultrawork mode (parallel agents)
Tab                         # Cycle: build → plan → caveman
@spec-architect             # Spec-Driven Development (SDD)
@self-healer                # Autonomous error correction
@security-auditor           # Security audit
@refactor <files>           # Refactor
@docs-writer                # Write docs
#snippet                    # Text expansion
npx openskills read <name>  # Load marketplace skill
```

## Files

| File | Purpose |
|------|---------|
| `config/opencode.json` | Main OpenCode config — plugins, agents, skills path |
| `config/oh-my-openagent.json` | oh-my-openagent plugin config — models, team mode |
| `config/AGENTS.md` | Global caveman instructions + skill references |
| `config/skills/*/SKILL.md` | 135 built-in skills |
| `config/skills.txt` | Inventory of all built-in skills |
| `install.ps1` | Windows installer (works piped from irm) |
| `install.sh` | Linux/macOS installer |
| `CONTRIBUTING.md` | Guide for adding skills, plugins, themes |
| `.github/workflows/ci.yml` | CI — validates config, skills, installers |

## Troubleshooting

| Problem | Solution |
|---------|----------|
| `ConfigInvalidError` | Delete `~/.config/opencode/opencode.jsonc` (old format) |
| Plugin not loading | `opencode` → type `/plugin remove <name>` then `/plugin add <name>` |
| Skills not triggering | Ensure `~/.config/opencode/skills/<name>/SKILL.md` exists |
| snip not reducing tokens | Run `snip --version`, reinstall with `go install github.com/edouard-claude/snip/cmd/snip@latest` |
| opencode-mem not working | Check web UI at `http://localhost:4747` |

## Post-Install

```powershell
opencode auth login   # Authenticate with your provider
```

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md). PRs welcome!

## License

MIT

---

<p align="center"><strong>Star the repo</strong> if you found this useful ⭐</p>
