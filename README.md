# OpenCode Supreme Setup

![OpenCode Supreme Setup Banner](https://github.com/skeletorflet/opencode-supreme-setup/blob/master/banner.webp?raw=true)

> **The ULTIMATE one-command OpenCode setup** — 343+ skills, 13 plugins, Caveman mode, Team Mode (8 parallel agents), Self-Healing, Superpowers workflow engine, and SDD.

[![OpenCode](https://img.shields.io/badge/OpenCode-powered-6366f1?style=flat-square)](https://opencode.ai)
[![oh-my-openagent](https://img.shields.io/badge/oh--my--openagent-57.8k⭐-22c55e?style=flat-square)](https://github.com/code-yeongyu/oh-my-openagent)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=flat-square)](LICENSE)
[![CI](https://img.shields.io/github/actions/workflow/status/skeletorflet/opencode-supreme-setup/ci.yml?style=flat-square)](https://github.com/skeletorflet/opencode-supreme-setup/actions)
[![GitHub](https://img.shields.io/badge/GitHub-skeletorflet%2Fopencode--supreme--setup-181717?style=flat-square&logo=github)](https://github.com/skeletorflet/opencode-supreme-setup)

---

## What You Get

| Category | Included |
|----------|----------|
| **Agent Orchestration** | oh-my-openagent — Sisyphus loops, Team Mode (8 parallel), 10 sub-agents |
| **Team Mode** | 8 max parallel members, team task system, team messaging |
| **Caveman Mode** | Ultra-efficient AGENTS.md — zero fluff, surgical AST/LSP edits, English-only output |
| **Custom Agents** | `caveman`, `spec-architect`, `self-healer`, `security-auditor`, `docs-writer`, `refactor` |
| **Sub-Agents** | `sisyphus`, `oracle`, `librarian`, `explore`, `multimodal-looker`, `prometheus`, `metis`, `momus`, `atlas`, `sisyphus-junior` |
| **Agent Categories** | visual-engineering, ultrabrain, deep, artistry, quick, unspecified-low, unspecified-high, writing |
| **Skills** | 343+ unique (326 `~/.claude/skills` + 9 `~/.agents/skills` + 8 unique project) |
| **Plugins** | 13 plugins — snippets, snip, notify, mem, quota, background-agents, worktree, context-pruning, smart-title, ocwatch, superpowers, supermemory, oh-my-openagent |
| **MCP Servers** | web-search (Tavily), pdf-reader, google-drive, memory-plus |
| **Memory** | opencode-mem (vector-DB, web UI localhost:4747) + supermemory (cross-session knowledge) |
| **Token Savings** | `snip` CLI — filters shell output, 60-90% fewer tokens |
| **Model** | 100% `opencode-go/deepseek-v4-flash` across all agents + fallbacks |
| **Optimizations** | Hashline edits, runtime fallback (auto-retry 400/429/503/529), dynamic context pruning (dedup, supersede writes, purge errors), auto-resume, aggressive truncation, streaming tools |

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

The installer runs 15 automated steps:

| Step | What |
|------|------|
| 1 | Prerequisites (Node.js, PowerShell 7+) |
| 2 | OpenCode + Bun |
| 3 | Provider subscription configuration |
| 4 | oh-my-openagent (agent orchestration) |
| 5 | Config files + built-in skills |
| 6 | Platform optimizations (tmux on/off, model overrides) |
| 7 | Developer tools (comment-checker, ast-grep, GitHub CLI) |
| 8 | **13 essential plugins** |
| 9 | **OpenSkills — marketplace skills** (from anthropics/skills) |
| 10 | **Superpowers — workflow skills** (from obra/superpowers) |
| 11 | **Sub-agents** — sisyphus, oracle, librarian, explore, prometheus, metis, momus, atlas |
| 12 | **Team Mode** — 8 parallel members, task system, messaging |
| 13 | **MCP servers** — web-search (Tavily), pdf-reader, google-drive, memory-plus |
| 14 | Optional: supermemory, themes |
| 15 | Verification + Summary |

## Plugins

| Plugin | What It Does |
|--------|-------------|
| **oh-my-openagent** | Sisyphus orchestrator, Team Mode (8 parallel), 10 sub-agents, Advanced MCPs, runtime fallback, category routing |
| **opencode-snippets** | `#snippet` inline text expansion — DRY for prompts |
| **opencode-snip** | Auto-prefixes shell commands with `snip` → 60-90% token reduction |
| **opencode-notify** | Native OS notifications when tasks complete |
| **opencode-mem** | Persistent vector-DB memory with web UI (localhost:4747) |
| **opencode-quota** | Token usage and cost tracking with toasts |
| **opencode-background-agents** | Async agent delegation (8 concurrent default, 5 model-specific) |
| **opencode-worktree** | Zero-friction isolated git worktrees |
| **opencode-dynamic-context-pruning** | Auto-prune obsolete tool outputs — dedup, supersede writes, purge errors after 5 turns |
| **opencode-smart-title** | Auto-generates meaningful session titles |
| **ocwatch** | Real-time visual dashboard for agent activity monitoring |
| **superpowers** | Full-stack engineering workflow — brainstorming, TDD, subagent-driven development, systematic debugging, code review, worktrees, verification |
| **supermemory** | Persistent cross-session knowledge with web UI |

## Skills

### 343+ Unique Skills

Skills are aggregated from 3 sources:

| Source | Count |
|--------|-------|
| `~/.claude/skills/` | 326 — CKMs (brand, design, ui-styling), community plugins, HTML decks, creative tools |
| `~/.agents/skills/` | 9 — build-your-own-x, compress, find-skills, skill-sync |
| Project `.claude/skills/` | 334 — 8 additional unique project-specific skills |

**Categories include:**

| Category | Skills |
|----------|--------|
| **Frontend** | angular, astro, gatsby, gsap, htmx, motion-framer, nextjs, nuxt, svelte, tailwind, threejs, vue |
| **Backend** | actix-web, aspnet-core, bun, django, elysia, express, fastapi, fastify, fiber, flask, gin, hono, koa, laravel, nestjs, rails |
| **Languages** | dart, deno, elixir, go-lang, kotlin, rust, solidjs, swift, zig |
| **Mobile/Desktop** | electron, flutter, react-native, tauri |
| **Databases** | drizzle, mongodb, postgresql, prisma, redis, sqlite, supabase |
| **AI/ML** | crewai, huggingface, langchain, ollama, pytorch, tensorflow |
| **DevOps** | ansible, github-actions, helm, kubernetes, pulumi, terraform |
| **Design** | d3js, material-ui, shadcn, ui-styling, ui-ux-pro-max, banner-design, brand, design |
| **Creative** | hyperframes, algorithmic-art, canvas-design, sprite-animation, shader-dev, hand-drawn-diagrams |
| **HTML Decks (50+)** | html-ppt, kami-deck, deck-swiss-international, guizang-ppt, 40+ Zhangzara templates |
| **Media** | fal-generate, fal-3d, fal-video-edit, imagem, sora, replicate, venice-* |
| **Methodology** | brainstorming, TDD, diagnose, systematic-debugging, review, verification-before-completion |
| **Workflow** | superpowers (dispatching-parallel-agents, executing-plans, writing-plans, subagent-driven-development, finishing-a-development-branch) |

Use: `skill(name="<skill-name>")` to load any skill.

### MCP Servers

| Server | Purpose |
|--------|---------|
| **web-search** (Tavily) | Real-time web search via MCP |
| **pdf-reader** | Read and analyze PDF documents |
| **google-drive** | Access files in Google Drive |
| **memory-plus** | Advanced graph-based memory |

## Agents

### Primary Agents

| Agent | Description |
|-------|-------------|
| `caveman` | **Default** — Ultra-efficient coder, zero fluff, max output |
| `@spec-architect` | Spec-Driven Development — creates SPEC.md from requirements |
| `@self-healer` | Autonomous debugging — fixes build/test failures silently |
| `@security-auditor` | Security audit — finds vulns, secrets, injection risks |
| `@refactor` | Code refactoring specialist — reduces duplication, modernizes |
| `@docs-writer` | Documentation writer — clear, concise markdown docs |

### Sub-Agents (oh-my-openagent)

| Agent | Category | Purpose |
|-------|----------|---------|
| `sisyphus` | — | Main orchestrator, persistent loops |
| `oracle` | ultrabrain | Deep analysis and research |
| `librarian` | quick | Fast file search and code navigation |
| `explore` | quick | Codebase exploration and discovery |
| `multimodal-looker` | visual-engineering | Image/visual analysis |
| `prometheus` | deep | Strategic planning and architecture |
| `metis` | deep | Technical design and problem-solving |
| `momus` | writing | Critique and review |
| `atlas` | unspecified-high | Heavy implementation work |
| `sisyphus-junior` | unspecified-low | Lightweight task execution |

## Team Mode

Team Mode is **enabled** with:
- **8 max parallel members**
- Task system with dependency tracking (`blockedBy`)
- Team messaging and broadcasting
- Shutdown approval workflow
- Supports categories: deep, ultrabrain, quick, visual-engineering, artistry, writing, unspecified-low, unspecified-high

Use `team_create`, `team_send_message`, `team_task_*` tools.

## Usage

```bash
opencode                          # Launch (caveman mode default)
@spec-architect                   # Create SPEC.md (SDD)
@self-healer                      # Auto-fix build/test failures
@security-auditor                 # Security audit
@refactor <files>                 # Refactor code
@docs-writer                      # Generate documentation
skill(name="<skill>")             # Load any skill
ulw <task>                        # Ultrawork mode (parallel agents)
#snippet                          # Text expansion
npx openskills read <name>        # Load marketplace skill
```

## Files

| File | Purpose |
|------|---------|
| `~/.config/opencode/opencode.json` | Main config — plugins, agents, model, skills path |
| `~/.config/opencode/oh-my-openagent.json` | Plugin config — sub-agents, team mode, MCP servers, fallback, pruning |
| `~/.config/opencode/AGENTS.md` | Global caveman instructions + skill references |
| `config/opencode.json` | Reference template (project copy) |
| `config/oh-my-openagent.json` | Reference template (project copy) |
| `config/AGENTS.md` | Reference template (project copy) |
| `install.ps1` | Windows installer |
| `install.sh` | Linux/macOS installer |
| `.claude/skills/` | 334 project-level skills |
| `CONTRIBUTING.md` | Guide for adding skills, plugins, themes |
| `.github/workflows/ci.yml` | CI — validates config, skills, installers |

## Troubleshooting

| Problem | Solution |
|---------|----------|
| `ConfigInvalidError` | Delete `~/.config/opencode/opencode.jsonc` (old format) |
| Plugin not loading | `/plugin remove <name>` then `/plugin add <name>` |
| Skills not triggering | Ensure `~/.config/opencode/skills/<name>/SKILL.md` exists |
| snip not reducing tokens | `snip --version`, reinstall with `go install github.com/edouard-claude/snip/cmd/snip@latest` |
| opencode-mem not working | Check web UI at `http://localhost:4747` |
| Team Mode not working | Verify `team_mode.enabled: true` in oh-my-openagent.json |

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
