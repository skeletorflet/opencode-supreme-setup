# Skills Ecosystem Expansion Plan

## TL;DR

> **Quick Summary**: Expand opencode-supreme-setup from 53 to 200+ built-in skills across all major frameworks, create auto-audit plugin for README badge, implement smart skill detection in AGENTS.md, and integrate top OpenSkills mega-repos. Maximum breadth AND depth.
>
> **Deliverables**:
> - 150+ new SKILL.md files (53 → 200+ total)
> - `scripts/skill-audit.ps1` + `scripts/skill-audit.sh` auto-audit plugin
> - Updated `.github/workflows/ci.yml` with badge generation
> - Updated `config/AGENTS.md` with smart-detection directive
> - Updated `install.ps1` + `install.sh` for new skills + mega-repos
> - Updated `README.md` with dynamic skill count badge + table
> - Updated `config/skills.txt` with all new skills
>
> **Estimated Effort**: XL (75-100+ tasks)
> **Parallel Execution**: YES - 7 waves
> **Critical Path**: Foundation → Skill Generation (batch) → Audit Plugin → CI → AGENTS.md → Installers → README → QA

---

## Context

### Original Request
Create an advanced and complete plan to add skills to the opencode-supreme-setup repo. Build a plugin/script to auto-detect skill count for README updates. Search the internet for hundreds of useful missing skills (svelte, sveltekit, vue, net, react, etc.). Implement them all. The global agent MUST always try to find relevant skills for the user's prompt.

### Interview Summary
**Key Decisions**:
- **Maximum Both**: Hundreds of skills with deep content (~20-30 lines each)
- **Audit Output**: Both markdown table (for README) + JSON (for CI/badge)
- **Smart Detection**: Check installed skills first, web search if no match
- **Flat Structure**: Keep existing flat `skills/<name>/SKILL.md` (no category migration)
- **Batch Generation**: Delegate skill creation to parallel build agents with templates
- **De-duplication**: Built-in skills take priority over marketplace; document in AGENTS.md

### Research Findings
**OpenSkills Ecosystem**: 3 CLI tools, 12+ registries, ~350K indexed skills total. Major collections: ComposioHQ/awesome-claude-skills (1,000+), sickn33/antigravity-awesome-skills (1,453+), agent-skills-hub (790+).
**120 Technologies Identified**: Across 10 tiers (frontend, backend, languages, mobile, databases, AI/ML, devops, testing, design, misc).
**GitHub Repos**: 40+ repos found with reusable skills. Top: everything-claude-code (182K ⭐), mattpocock/skills (82K ⭐), caveman (60K ⭐), graphify (48K ⭐), open-design (40K ⭐).

### Metis Review
**Key Gaps Addressed**:
- **Flat vs Categorical**: Solved → Flat structure. No migration of existing 53.
- **Skill Discovery**: Built-in skills auto-discovered via `skills.paths`. No AGENTS.md listing needed.
- **Target Count**: 150+ new skills (53 → 200+ total). Tier 1-5 skills all covered.
- **De-duplication**: Built-in wins over marketplace. Documented in AGENTS.md.
- **Installer Reliability**: Skills bundled into a single archive (skills.zip) to avoid 200+ HTTP requests.
- **Quality Gate**: Every SKILL.md validated: YAML frontmatter, description field, ≥15 lines body.
- **Badge Mechanism**: Shields.io dynamic JSON badge via GitHub Pages raw content.

---

## Work Objectives

### Core Objective
Transform opencode-supreme-setup from 53 to 200+ built-in skills covering every major framework, language, and tool, with auto-auditing CI and smart agent discovery.

### Concrete Deliverables
- 150+ new `config/skills/<name>/SKILL.md` files with YAML frontmatter + detailed patterns
- `scripts/skill-audit.ps1` (PowerShell) + `scripts/skill-audit.sh` (Bash) dual-format audit plugin
- `.github/workflows/ci.yml` updated with skill count badge generation
- `config/AGENTS.md` updated with smart-detection directive section
- `install.ps1` + `install.sh` updated with new skills + mega-repo integration
- `config/skills.txt` updated with all new skills (200+ entries)
- `README.md` updated with dynamic skill count badge + categorized skill table
- OpenSkills mega-repos installed via installer: caveman, graphify, open-design, mattpocock/skills, ui-ux-pro-max

### Definition of Done
- [ ] `ls -d config/skills/*/ | wc -l` >= 200 skills total
- [ ] Every SKILL.md has valid YAML frontmatter + ≥15 body lines + description field
- [ ] `scripts/skill-audit.ps1 --format md` produces valid markdown table
- [ ] `scripts/skill-audit.sh --format json` produces valid JSON with `{count: N, skills: [...]}`
- [ ] CI passes: all validations, badge URL resolves
- [ ] `diff <(ls -d config/skills/*/ | xargs basename | sort) <(cat config/skills.txt | sort)` returns empty
- [ ] `.\install.ps1 -NonInteractive` completes without errors
- [ ] All 53 original skills still present (no regressions)

### Must Have
- 150+ new built-in skills covering all tiers
- Skill audit plugin with dual format output
- CI badge for skill count
- Smart skill detection in AGENTS.md
- OpenSkills mega-repo integration in installer
- All acceptance criteria met

### Must NOT Have (Guardrails)
- NO category migration (keep flat structure)
- NO inline skill listing in AGENTS.md (too many tokens)
- NO modification to existing 53 skills (only append)
- NO paid/paywalled skills
- NO runtime skill execution engine changes
- NO auto-commit bot on README (manual commit with CI verification)

---

## Verification Strategy

> **ZERO HUMAN INTERVENTION** - ALL verification is agent-executed. No exceptions.

### Test Decision
- **Infrastructure exists**: YES (GitHub Actions + scripts)
- **Automated tests**: Tests-after
- **Validation tools**: bash scripting, YAML parsing, JSON parsing

### QA Policy
Every task MUST include agent-executed QA scenarios. Evidence saved to `.sisyphus/evidence/task-{N}-{scenario}.{ext}`.
- **Skill files**: Bash (YAML parsing, line counting, grep validation)
- **Scripts**: Bash (run with test flags, validate output)
- **CI**: Local simulation of CI steps
- **Installers**: Local dry-run with -NonInteractive

---

## Execution Strategy

### Parallel Execution Waves

```
Wave 1 (Foundation - configs, templates, scripts):
├── Task 1: Skill generation tooling (template + batch script)
├── Task 2: Installer dependency updates (skills bundle)
├── Task 3: skills.txt format + CI validation prep
└── Task 4: AGENTS.md smart-detection section design

Wave 2 (BATCH SKILL GENERATION - Tier 1 Frontend - 12 skills):
├── Task 5: nextjs skill
├── Task 6: vue skill
├── Task 7: svelte skill
├── Task 8: angular skill
├── Task 9: solidjs skill
├── Task 10: qwik skill
├── Task 11: astro skill
├── Task 12: sveltekit skill
├── Task 13: nuxt skill
├── Task 14: remix skill
├── Task 15: gatsby skill
└── Task 16: htmx skill

Wave 3 (BATCH SKILL GENERATION - Tier 2 Backend - 16 skills):
├── Task 17: express skill
├── Task 18: nestjs skill
├── Task 19: fastify skill
├── Task 20: hono skill
├── Task 21: elysia skill
├── Task 22: fastapi skill
├── Task 23: django skill
├── Task 24: flask skill
├── Task 25: spring-boot skill
├── Task 26: gin skill
├── Task 27: fiber skill
├── Task 28: rails skill
├── Task 29: laravel skill
├── Task 30: aspnet-core skill
├── Task 31: koa skill
└── Task 32: actix-web skill

Wave 4 (BATCH SKILL GENERATION - Tier 3-5 Languages/Mobile/DB - 20 skills):
├── Task 33: go skill (lang)
├── Task 34: rust skill
├── Task 35: kotlin skill
├── Task 36: swift skill
├── Task 37: zig skill
├── Task 38: elixir skill
├── Task 39: bun skill
├── Task 40: deno skill
├── Task 41: dart skill
├── Task 42: react-native skill
├── Task 43: flutter skill
├── Task 44: tauri skill
├── Task 45: electron skill
├── Task 46: prisma skill
├── Task 47: drizzle skill
├── Task 48: supabase skill
├── Task 49: mongodb skill
├── Task 50: postgresql skill
├── Task 51: redis skill
└── Task 52: sqlite skill

Wave 5 (BATCH SKILL GENERATION - Tier 6-8 AI/DevOps/Testing - 24 skills):
├── Task 53: langchain skill
├── Task 54: ollama skill
├── Task 55: huggingface skill
├── Task 56: pytorch skill
├── Task 57: tensorflow skill
├── Task 58: crewai skill
├── Task 59: n8n skill
├── Task 60: claude-api skill (upgrade existing? no - new)
├── Task 61: terraform skill
├── Task 62: kubernetes skill
├── Task 63: ansible skill
├── Task 64: github-actions skill
├── Task 65: helm skill
├── Task 66: pulumi skill
├── Task 67: vitest skill
├── Task 68: cypress skill
├── Task 69: testing-library skill
├── Task 70: msw skill
├── Task 71: storybook skill
├── Task 72: jest skill
├── Task 73: lighthouse-ci skill
└── Task 74: sentry skill

Wave 6 (BATCH SKILL GENERATION - Tier 9-10 Design/Misc - 30 skills):
├── Task 75: tailwind skill
├── Task 76: shadcn skill
├── Task 77: motion-framer skill
├── Task 78: threejs skill
├── Task 79: gsap skill
├── Task 80: d3js skill
├── Task 81: material-ui skill
├── Task 82: zod skill
├── Task 83: trpc skill
├── Task 84: zustand skill
├── Task 85: tanstack-query skill
├── Task 86: vite skill
├── Task 87: pnpm skill
├── Task 88: turborepo skill
├── Task 89: nx skill
├── Task 90: esbuild skill
├── Task 91: rspack skill
├── Task 92: react-hook-form skill
├── Task 93: stripe skill
├── Task 94: clerk skill
├── Task 95: posthog skill
├── Task 96: immer skill
├── Task 97: rxjs skill
├── Task 98: biome skill
├── Task 99: openapi skill
├── Task 100: graphql skill (upgrade existing? no - already exists, skip)
├── Task 101: playwright skill (already exists, skip)
├── Task 102: security skill (already exists, skip)
└── Task 103: node skill (already exists, skip)

Wave 7 (Infrastructure - scripts, CI, docs - 15 tasks):
├── Task 104: Create scripts/skill-audit.ps1
├── Task 105: Create scripts/skill-audit.sh
├── Task 106: Update .github/workflows/ci.yml for badge + audit
├── Task 107: Update config/AGENTS.md with smart-detection section
├── Task 108: Update config/skills.txt (add all new entries)
├── Task 109: Update install.ps1 (skills bundle + mega-repos)
├── Task 110: Update install.sh (skills bundle + mega-repos)
├── Task 111: Update README.md (badge + skill count table)
├── Task 112: Update config/opencode.json (skills paths if needed)
├── Task 113: Update CONTRIBUTING.md (new skill creation process)
├── Task 114: Create skills bundle archive config/skills.tar.gz
├── Task 115: Validation pass - all SKILL.md files
├── Task 116: Validation pass - skills.txt in sync
├── Task 117: Validation pass - audit plugin output
└── Task 118: Validation pass - installers dry-run

Wave FINAL (Review - 4 parallel agents):
├── Task F1: Plan compliance audit (oracle)
├── Task F2: Code quality + skill content review (unspecified-high)
├── Task F3: Real manual QA - audit plugin, CI, installers (unspecified-high)
└── Task F4: Scope fidelity check (deep)
```

## TODOs

### Wave 1: Foundation (Tasks 1-4)

**All Wave 1 tasks run in parallel. Foundation for all other waves.**

---

- [x] 1. Create skill generation tooling (template + batch scaffold)

  **What to do**: Create `config/skills/_template/SKILL.md` with canonical format (YAML frontmatter, ### sections for concepts/patterns/best-practices/code). Create `scripts/generate-skills.ps1` that reads a CSV and creates directories + SKILL.md files.

  **Must NOT do**: Don't generate actual skills here (just tooling)

  **Category**: `quick` | Parallel Group: Wave 1 (foundation) | Blocks: Wave 2-6 | Blocked By: None

  **QA Scenarios**:
  ```
  Scenario: Template validates
    Tool: Bash | Steps: 1) head -1 config/skills/_template/SKILL.md | grep -q '^---$'  2) grep -q '^description:' config/skills/_template/SKILL.md
    Expected: Both pass | Evidence: .sisyphus/evidence/task-1-template-valid.txt
  ```

  **Commit**: `feat(skills): add skill generation tooling and template`

---

- [x] 2. Create skills bundle script

  **What to do**: Create `scripts/bundle-skills.ps1` that packages all config/skills/ into a single tar.gz archive for installer use.

  **Category**: `quick` | Parallel Group: Wave 1 (parallel with 3,4) | Blocks: 109,110

  **QA**:
  ```
  Scenario: Bundle creates valid archive
    Tool: Bash | Steps: 1) pwsh -f scripts/bundle-skills.ps1  2) tar -tzf config/skills.tar.gz | head -5
    Expected: Archive contains SKILL.md files | Evidence: .sisyphus/evidence/task-2-bundle-valid.txt
  ```

  **Commit**: `feat(skills): add skill generation tooling and template`

---

- [x] 3. Create skills validation script

  **What to do**: Create `scripts/validate-skills.ps1` that checks skills.txt sync and validates each SKILL.md.

  **Category**: `quick` | Parallel Group: Wave 1 (parallel with 2,4) | Blocks: 106

  **QA**:
  ```
  Scenario: Validation passes when in sync
    Tool: Bash | Steps: pwsh -f scripts/validate-skills.ps1 | Expected: Exit code 0 | Evidence: .sisyphus/evidence/task-3-validate-pass.txt
  ```

  **Commit**: `feat(skills): add skill generation tooling and template`

---

- [x] 4. Design AGENTS.md smart-detection directive

  **What to do**: Draft smart-detection section (< 15 lines). Check installed skills first, then web search/openskills. Save to `.sisyphus/drafts/smart-detection.md`.

  **Category**: `writing` | Parallel Group: Wave 1 (parallel with 2,3) | Blocks: 107

  **QA**:
  ```
  Scenario: Draft exists and is compact
    Tool: Bash | Steps: 1) test -f .sisyphus/drafts/smart-detection.md  2) wc -l < .sisyphus/drafts/smart-detection.md
    Expected: File exists, < 15 lines | Evidence: .sisyphus/evidence/task-4-draft-exists.txt
  ```

  **Commit**: NO (applied in Task 107)

---

### Wave 2: Frontend Skills (Tasks 5-16)

**12 skills - all parallel. Depend on Task 1.**

> **Validation**: Per-skill QA delegated to Task 115 (batch file check: exists, frontmatter, description, body >= 15 lines).

- [x] 5. nextjs skill

  **What to do**: Create `config/skills/nextjs/SKILL.md` with: App Router, RSC, Server Actions, middleware, data fetching, ISR/SSR/SSG, API routes, auth patterns, Vercel deployment. 20-30 lines.

  **Category**: `writing` | Parallel Group: Wave 2 (parallel 5-16) | Blocked By: 1

  **Commit**: `feat(skills): add Tier 1 frontend skills`

---

- [x] 6. vue skill

  **What to do**: Create `config/skills/vue/SKILL.md` with: Composition API, SFC, reactivity, directives, vue-router, Pinia, slots, transitions. 20-30 lines.

  **Category**: `writing` | Parallel Group: Wave 2 (parallel) | Blocked By: 1

  **Commit**: `feat(skills): add Tier 1 frontend skills`

---

- [x] 7. svelte skill

  **What to do**: Create `config/skills/svelte/SKILL.md` with: Svelte 5 runes ($state, $derived, $effect), components, props, slots, stores, transitions, actions. 20-30 lines.

  **Category**: `writing` | Parallel Group: Wave 2 (parallel) | Blocked By: 1

  **Commit**: `feat(skills): add Tier 1 frontend skills`

---

- [x] 8. angular skill

  **What to do**: Create `config/skills/angular/SKILL.md` with: standalone components, signals, DI, routing, forms (reactive + template), RxJS, guards. 20-30 lines.

  **Category**: `writing` | Parallel Group: Wave 2 (parallel) | Blocked By: 1

  **Commit**: `feat(skills): add Tier 1 frontend skills`

---

- [x] 9. solidjs skill

  **What to do**: Create `config/skills/solidjs/SKILL.md` with: signals, effects, JSX without VDOM, SolidStart, resources, createResource, createMemo. 20-30 lines.

  **Category**: `writing` | Parallel Group: Wave 2 (parallel) | Blocked By: 1

  **Commit**: `feat(skills): add Tier 1 frontend skills`

---

- [x] 10. qwik skill

  **What to do**: Create `config/skills/qwik/SKILL.md` with: resumability, lazy loading, Qwik City, $() lazy symbols, islands. 20-30 lines.

  **Category**: `writing` | Parallel Group: Wave 2 (parallel) | Blocked By: 1

  **Commit**: `feat(skills): add Tier 1 frontend skills`

---

- [x] 11. astro skill

  **What to do**: Create `config/skills/astro/SKILL.md` with: islands, content collections, multi-framework, SSG/SSR, Astro DB, integrations. 20-30 lines.

  **Category**: `writing` | Parallel Group: Wave 2 (parallel) | Blocked By: 1

  **Commit**: `feat(skills): add Tier 1 frontend skills`

---

- [x] 12. sveltekit skill

  **What to do**: Create `config/skills/sveltekit/SKILL.md` with: file-based routing, +page/+layout/+server, load functions, form actions, hooks, auth patterns. 20-30 lines.

  **Category**: `writing` | Parallel Group: Wave 2 (parallel) | Blocked By: 1

  **Commit**: `feat(skills): add Tier 1 frontend skills`

---

- [x] 13. nuxt skill

  **What to do**: Create `config/skills/nuxt/SKILL.md` with: auto-imports, Nuxt modules, pages routing, server routes, data fetching, useAsyncData. 20-30 lines.

  **Category**: `writing` | Parallel Group: Wave 2 (parallel) | Blocked By: 1

  **Commit**: `feat(skills): add Tier 1 frontend skills`

---

- [x] 14. remix skill

  **What to do**: Create `config/skills/remix/SKILL.md` with: web standards, nested routes, loaders/actions, progressive enhancement, forms, error boundaries. 20-30 lines.

  **Category**: `writing` | Parallel Group: Wave 2 (parallel) | Blocked By: 1

  **Commit**: `feat(skills): add Tier 1 frontend skills`

---

- [x] 15. gatsby skill

  **What to do**: Create `config/skills/gatsby/SKILL.md` with: GraphQL data layer, Gatsby nodes, plugins, image optimization, migration patterns. 20-30 lines.

  **Category**: `writing` | Parallel Group: Wave 2 (parallel) | Blocked By: 1

  **Commit**: `feat(skills): add Tier 1 frontend skills`

---

- [x] 16. htmx skill

  **What to do**: Create `config/skills/htmx/SKILL.md` with: hx-* attributes, AJAX partial rendering, hypermedia-driven UI, SSR integration, WebSockets. 20-30 lines.

  **Category**: `writing` | Parallel Group: Wave 2 (parallel) | Blocked By: 1

  **Commit**: `feat(skills): add Tier 1 frontend skills`

---

### Wave 3: Backend Skills (Tasks 17-32)

**16 skills - all parallel. Depend on Task 1.**

> **Validation**: Per-skill QA delegated to Task 115.

- [x] 17. express skill

  **What to do**: Create `config/skills/express/SKILL.md` with: middleware pattern, routing, error handling, static files, template engines, REST API design, security (helmet, cors), testing with supertest. 20-30 lines.

  **Category**: `writing` | Parallel Group: Wave 3 (parallel 17-32) | Blocked By: 1
  **Commit**: `feat(skills): add Tier 2 backend skills`

---

- [x] 18. nestjs skill

  **What to do**: Create `config/skills/nestjs/SKILL.md` with: modules, controllers, providers, DI, guards, interceptors, pipes, filters, OpenAPI/Swagger, TypeORM/Prisma integration, testing. 20-30 lines.

  **Category**: `writing` | Parallel Group: Wave 3 (parallel) | Blocked By: 1
  **Commit**: `feat(skills): add Tier 2 backend skills`

---

- [x] 19. fastify skill

  **What to do**: Create `config/skills/fastify/SKILL.md` with: schema validation, hooks/plugins, serialization, TypeScript, encapsulation, logging, testing. 20-30 lines.

  **Category**: `writing` | Parallel Group: Wave 3 (parallel) | Blocked By: 1
  **Commit**: `feat(skills): add Tier 2 backend skills`

---

- [x] 20. hono skill

  **What to do**: Create `config/skills/hono/SKILL.md` with: multi-runtime (CF Workers, Deno, Bun, Node), middleware, routing, RPC, JWT auth, Zod validation. 20-30 lines.

  **Category**: `writing` | Parallel Group: Wave 3 (parallel) | Blocked By: 1
  **Commit**: `feat(skills): add Tier 2 backend skills`

---

- [x] 21. elysia skill

  **What to do**: Create `config/skills/elysia/SKILL.md` with: Bun-native, Eden plugin, Elysia treaty types, validation, file upload, WebSocket, rate limiting. 20-30 lines.

  **Category**: `writing` | Parallel Group: Wave 3 (parallel) | Blocked By: 1
  **Commit**: `feat(skills): add Tier 2 backend skills`

---

- [x] 22. fastapi skill

  **What to do**: Create `config/skills/fastapi/SKILL.md` with: async endpoints, Pydantic v2, dependency injection, OpenAPI/Swagger, WebSocket, background tasks, CORS, testing. 20-30 lines.

  **Category**: `writing` | Parallel Group: Wave 3 (parallel) | Blocked By: 1
  **Commit**: `feat(skills): add Tier 2 backend skills`

---

- [x] 23. django skill

  **What to do**: Create `config/skills/django/SKILL.md` with: ORM, admin, class-based views, DRF, Ninja API, signals, middleware, auth, testing. 20-30 lines.

  **Category**: `writing` | Parallel Group: Wave 3 (parallel) | Blocked By: 1
  **Commit**: `feat(skills): add Tier 2 backend skills`

---

- [x] 24. flask skill

  **What to do**: Create `config/skills/flask/SKILL.md` with: blueprints, Jinja2, SQLAlchemy, Flask-RESTful, error handling, app factories, extensions, testing. 20-30 lines.

  **Category**: `writing` | Parallel Group: Wave 3 (parallel) | Blocked By: 1
  **Commit**: `feat(skills): add Tier 2 backend skills`

---

- [x] 25. spring-boot skill

  **What to do**: Create `config/skills/spring-boot/SKILL.md` with: auto-config, JPA/Hibernate, REST controllers, security, Actuator, testing, profiles, Gradle/Maven. 20-30 lines.

  **Category**: `writing` | Parallel Group: Wave 3 (parallel) | Blocked By: 1
  **Commit**: `feat(skills): add Tier 2 backend skills`

---

- [x] 26. gin skill

  **What to do**: Create `config/skills/gin/SKILL.md` with: routing, middleware, JSON/XML binding, validation, grouping, file upload, testing httptest. 20-30 lines.

  **Category**: `writing` | Parallel Group: Wave 3 (parallel) | Blocked By: 1
  **Commit**: `feat(skills): add Tier 2 backend skills`

---

- [x] 27. fiber skill

  **What to do**: Create `config/skills/fiber/SKILL.md` with: Express-like API, middleware, static files, testing, Fiber client, WebSocket, validation. 20-30 lines.

  **Category**: `writing` | Parallel Group: Wave 3 (parallel) | Blocked By: 1
  **Commit**: `feat(skills): add Tier 2 backend skills`

---

- [x] 28. rails skill

  **What to do**: Create `config/skills/rails/SKILL.md` with: MVC, Active Record, migrations, routes, RESTful resources, Hotwire/Stimulus/Turbo, Action Cable, testing (RSpec). 20-30 lines.

  **Category**: `writing` | Parallel Group: Wave 3 (parallel) | Blocked By: 1
  **Commit**: `feat(skills): add Tier 2 backend skills`

---

- [x] 29. laravel skill

  **What to do**: Create `config/skills/laravel/SKILL.md` with: Eloquent ORM, Artisan CLI, Blade templates, routing, middleware, Livewire, Inertia, Sail/Docker, testing. 20-30 lines.

  **Category**: `writing` | Parallel Group: Wave 3 (parallel) | Blocked By: 1
  **Commit**: `feat(skills): add Tier 2 backend skills`

---

- [x] 30. aspnet-core skill

  **What to do**: Create `config/skills/aspnet-core/SKILL.md` with: minimal APIs, MVC, Blazor, Entity Framework Core, auth (Identity/JWT), middleware, DI, testing. 20-30 lines.

  **Category**: `writing` | Parallel Group: Wave 3 (parallel) | Blocked By: 1
  **Commit**: `feat(skills): add Tier 2 backend skills`

---

- [x] 31. koa skill

  **What to do**: Create `config/skills/koa/SKILL.md` with: async middleware, context, routing, error handling, Koa vs Express differences, body parsing, CORS, testing. 20-30 lines.

  **Category**: `writing` | Parallel Group: Wave 3 (parallel) | Blocked By: 1
  **Commit**: `feat(skills): add Tier 2 backend skills`

---

- [x] 32. actix-web skill

  **What to do**: Create `config/skills/actix-web/SKILL.md` with: actors, routing, middleware, extractors, error handling, WebSocket, testing, Actix RT. 20-30 lines.

  **Category**: `writing` | Parallel Group: Wave 3 (parallel) | Blocked By: 1
  **Commit**: `feat(skills): add Tier 2 backend skills`

---

### Wave 4: Languages/Mobile/DB Skills (Tasks 33-52)

**20 skills - all parallel. Depend on Task 1.**

> **Validation**: Per-skill QA delegated to Task 115.

- [x] 33. go-lang skill

  **What to do**: Create `config/skills/go-lang/SKILL.md` with: goroutines, channels, interfaces, structs, error handling, modules/packages, testing (table-driven), context, standard lib patterns. 20-30 lines.

  **Category**: `writing` | Parallel Group: Wave 4 (parallel 33-52) | Blocked By: 1
  **Commit**: `feat(skills): add Tier 3-5 skills (languages, mobile, databases)`

---

- [x] 34. rust skill

  **What to do**: Create `config/skills/rust/SKILL.md` with: ownership/borrowing, structs/enums/traits, pattern matching, error handling (Result/Option), async/await, cargo, testing, common crates. 20-30 lines.

  **Category**: `writing` | Parallel Group: Wave 4 (parallel) | Blocked By: 1
  **Commit**: `feat(skills): add Tier 3-5 skills`

---

- [x] 35. kotlin skill

  **What to do**: Create `config/skills/kotlin/SKILL.md` with: null safety, coroutines, data classes, extension functions, sealed classes, flows, KMP, Compose Multiplatform. 20-30 lines.

  **Category**: `writing` | Parallel Group: Wave 4 (parallel) | Blocked By: 1
  **Commit**: `feat(skills): add Tier 3-5 skills`

---

- [x] 36. swift skill

  **What to do**: Create `config/skills/swift/SKILL.md` with: SwiftUI, async/await, structs vs classes, optionals, protocols, generics, Codable, result builders, Swift Package Manager. 20-30 lines.

  **Category**: `writing` | Parallel Group: Wave 4 (parallel) | Blocked By: 1
  **Commit**: `feat(skills): add Tier 3-5 skills`

---

- [x] 37. zig skill

  **What to do**: Create `config/skills/zig/SKILL.md` with: comptime, allocators, Zig vs C patterns, cross-compilation, build system, error union types, testing. 20-30 lines.

  **Category**: `writing` | Parallel Group: Wave 4 (parallel) | Blocked By: 1
  **Commit**: `feat(skills): add Tier 3-5 skills`

---

- [x] 38. elixir skill

  **What to do**: Create `config/skills/elixir/SKILL.md` with: OTP, GenServer, Supervision trees, Phoenix framework, LiveView, Ecto, |> pipe operator, pattern matching. 20-30 lines.

  **Category**: `writing` | Parallel Group: Wave 4 (parallel) | Blocked By: 1
  **Commit**: `feat(skills): add Tier 3-5 skills`

---

- [x] 39. bun skill

  **What to do**: Create `config/skills/bun/SKILL.md` with: Bun.serve, Bun.file, Bun.sqlite, test runner, package manager, Bun.build, Bun plugin system, Node.js compatibility. 20-30 lines.

  **Category**: `writing` | Parallel Group: Wave 4 (parallel) | Blocked By: 1
  **Commit**: `feat(skills): add Tier 3-5 skills`

---

- [x] 40. deno skill

  **What to do**: Create `config/skills/deno/SKILL.md` with: permissions model, std library, modules (URL imports), Deno.serve, KV store, npm compatibility, testing. 20-30 lines.

  **Category**: `writing` | Parallel Group: Wave 4 (parallel) | Blocked By: 1
  **Commit**: `feat(skills): add Tier 3-5 skills`

---

- [x] 41. dart skill

  **What to do**: Create `config/skills/dart/SKILL.md` with: isolates, streams, futures, null safety, records/patterns, Dart FFI, package management, Flutter integration. 20-30 lines.

  **Category**: `writing` | Parallel Group: Wave 4 (parallel) | Blocked By: 1
  **Commit**: `feat(skills): add Tier 3-5 skills`

---

- [x] 42. react-native skill

  **What to do**: Create `config/skills/react-native/SKILL.md` with: Expo framework, core components, navigation, state management, native modules, EAS Build, over-the-air updates, debugging. 20-30 lines.

  **Category**: `writing` | Parallel Group: Wave 4 (parallel) | Blocked By: 1
  **Commit**: `feat(skills): add Tier 3-5 skills`

---

- [x] 43. flutter skill

  **What to do**: Create `config/skills/flutter/SKILL.md` with: widget tree, state management (Riverpod/Bloc), Material/Cupertino, navigation, animations, platform channels, testing, Dart FFI. 20-30 lines.

  **Category**: `writing` | Parallel Group: Wave 4 (parallel) | Blocked By: 1
  **Commit**: `feat(skills): add Tier 3-5 skills`

---

- [x] 44. tauri skill

  **What to do**: Create `config/skills/tauri/SKILL.md` with: IPC commands, Rust backend, Tauri v2, plugins, window management, file system, system tray, bundling. 20-30 lines.

  **Category**: `writing` | Parallel Group: Wave 4 (parallel) | Blocked By: 1
  **Commit**: `feat(skills): add Tier 3-5 skills`

---

- [x] 45. electron skill

  **What to do**: Create `config/skills/electron/SKILL.md` with: main/renderer process, IPC, contextBridge, native APIs, packaging (electron-builder), auto-update, security best practices. 20-30 lines.

  **Category**: `writing` | Parallel Group: Wave 4 (parallel) | Blocked By: 1
  **Commit**: `feat(skills): add Tier 3-5 skills`

---

- [x] 46. prisma skill

  **What to do**: Create `config/skills/prisma/SKILL.md` with: schema DSL, migrations, Prisma Client (CRUD, relations, filtering), Prisma Studio, extensions, edge/deploy. 20-30 lines.

  **Category**: `writing` | Parallel Group: Wave 4 (parallel) | Blocked By: 1
  **Commit**: `feat(skills): add Tier 3-5 skills`

---

- [x] 47. drizzle skill

  **What to do**: Create `config/skills/drizzle/SKILL.md` with: schema definitions, queries (select/insert/update/delete), relations, migrations (drizzle-kit), edge support, Drizzle Studio. 20-30 lines.

  **Category**: `writing` | Parallel Group: Wave 4 (parallel) | Blocked By: 1
  **Commit**: `feat(skills): add Tier 3-5 skills`

---

- [x] 48. supabase skill

  **What to do**: Create `config/skills/supabase/SKILL.md` with: database (Postgres/RLS), auth, storage, realtime subscriptions, Edge Functions, client SDK, local dev. 20-30 lines.

  **Category**: `writing` | Parallel Group: Wave 4 (parallel) | Blocked By: 1
  **Commit**: `feat(skills): add Tier 3-5 skills`

---

- [x] 49. mongodb skill

  **What to do**: Create `config/skills/mongodb/SKILL.md` with: aggregation pipeline, indexes, schema design, Atlas, Atlas Search (vector), Mongoose/MongoDB driver, transactions. 20-30 lines.

  **Category**: `writing` | Parallel Group: Wave 4 (parallel) | Blocked By: 1
  **Commit**: `feat(skills): add Tier 3-5 skills`

---

- [x] 50. postgresql skill

  **What to do**: Create `config/skills/postgresql/SKILL.md` with: advanced queries, CTEs, window functions, indexes, extensions (PostGIS, pgvector), partitioning, performance tuning, pgAdmin. 20-30 lines.

  **Category**: `writing` | Parallel Group: Wave 4 (parallel) | Blocked By: 1
  **Commit**: `feat(skills): add Tier 3-5 skills`

---

- [x] 51. redis skill

  **What to do**: Create `config/skills/redis/SKILL.md` with: data structures (strings, hashes, lists, sets, sorted sets), caching patterns, pub/sub, Redis Stack (JSON, Search), Lua scripting. 20-30 lines.

  **Category**: `writing` | Parallel Group: Wave 4 (parallel) | Blocked By: 1
  **Commit**: `feat(skills): add Tier 3-5 skills`

---

- [x] 52. sqlite skill

  **What to do**: Create `config/skills/sqlite/SKILL.md` with: zero-config, WAL mode, CLI usage, SQL features (window functions, CTEs), performance pragmas, extensions, backup/restore. 20-30 lines.

  **Category**: `writing` | Parallel Group: Wave 4 (parallel) | Blocked By: 1
  **Commit**: `feat(skills): add Tier 3-5 skills`

---

### Wave 5: AI/DevOps/Testing Skills (Tasks 53-76)

**24 skills - all parallel. Depend on Task 1.**

> **Validation**: Per-skill QA delegated to Task 115.

  **Category**: `writing` | **All parallel** | Blocked By: 1

---

### Wave 6: Design/Misc Skills (Tasks 77-103)

**~27 new skills - all parallel. Depend on Task 1.**

> **Validation**: Per-skill QA delegated to Task 115.

  **Category**: `writing` | **All parallel** | Blocked By: 1

---

### Wave 7: Infrastructure - Scripts, CI, Docs (Tasks 104-118)

**15 infrastructure tasks - some parallel, some sequential.**

---

- [x] 104. Create scripts/skill-audit.ps1

  **What to do**: Create PowerShell script with flags: `--format md` (markdown table output), `--format json` (JSON with count, names, categories), `--check` (exit code 0/1 for CI). Output includes: total count, per-category counts, last-updated timestamp, skills list.

  **Category**: `quick` | Parallel Group: Wave 7 (parallel 104-105) | Blocked By: 1

  **QA Scenarios**:
  ```
  Scenario: JSON output valid
    Tool: Bash | Steps: pwsh scripts/skill-audit.ps1 --format json | python3 -c "import json,sys; d=json.load(sys.stdin); assert d['count'] >= 200"
    Expected: Valid JSON with count | Evidence: .sisyphus/evidence/task-104-json-valid.txt
  ```

  **Commit**: `feat(scripts): add skill-audit plugin (ps1 + sh)`

---

- [x] 105. Create scripts/skill-audit.sh

  **What to do**: Same as Task 104 but in Bash for Linux/macOS CI compatibility. Same flags and output format.

  **Category**: `quick` | Parallel Group: Wave 7 (parallel 104) | Blocked By: 1

  **Commit**: `feat(scripts): add skill-audit plugin (ps1 + sh)`

---

- [x] 106. Update CI pipeline (.github/workflows/ci.yml)

  **What to do**: Add steps: (1) install python3 for JSON validation, (2) run skill-audit.sh --format json, (3) validate count >= 200, (4) generate shields.io badge URL, (5) check skills.txt sync, (6) validate all SKILL.md files.

  **Category**: `unspecified-high` | Parallel Group: Wave 7 (sequential after 104-105) | Blocked By: 104, 105

  **Commit**: `ci: update CI pipeline with skill count badge`

---

- [x] 107. Update AGENTS.md with smart-detection directive

  **What to do**: Apply the smart-detection section from `.sisyphus/drafts/smart-detection.md` into `config/AGENTS.md`. Section must be < 15 lines. Content: "When user asks a task, first check available skills in skills directory. If no match, use web search or npx openskills read to find relevant skill. Only proceed if no skill exists."

  **Category**: `writing` | Parallel Group: Wave 7 (sequential after 4) | Blocked By: 4

  **QA**:
  ```
  Scenario: Smart detection present
    Tool: Bash | Steps: grep -q 'smart.skill.detection' config/AGENTS.md
    Expected: Match found | Evidence: .sisyphus/evidence/task-107-smart-detect.txt
  ```

  **Commit**: `feat(config): update AGENTS.md with smart-detection directive`

---

- [x] 108. Update config/skills.txt

  **What to do**: Regenerate skills.txt with ALL 200+ skill names (existing 53 + all new). One name per line, sorted alphabetically.

  **Category**: `quick` | Parallel Group: Wave 7 (parallel 108-113) | Blocked By: 2

  **QA**:
  ```
  Scenario: skills.txt in sync
    Tool: Bash | Steps: diff <(ls -d config/skills/*/ | xargs -I{} basename {} | sort) <(cat config/skills.txt | sort)
    Expected: No diff | Evidence: .sisyphus/evidence/task-108-skills-txt-sync.txt
  ```

  **Commit**: `docs: update README, CONTRIBUTING.md, skills.txt`

---

- [x] 109. Update install.ps1 for skills bundle + mega-repos

  **What to do**: Replace 200+ sequential HTTP downloads with single skills.tar.gz download from repo. Add OpenSkills mega-repo installations: `npx openskills install mattpocock/skills -y`, `npx openskills install JuliusBrussee/caveman -y`, `npx openskills install safishamsi/graphify -y`, `npx openskills install nexu-io/open-design -y`, `npx openskills install nextlevelbuilder/ui-ux-pro-max-skill -y`.

  **Category**: `unspecified-high` | Parallel Group: Wave 7 (parallel 109-110) | Blocked By: 2

  **Commit**: `feat(installer): update installers for skills bundle + mega-repos`

---

- [x] 110. Update install.sh for skills bundle + mega-repos

  **What to do**: Same changes as Task 109 but in Bash syntax.

  **Category**: `unspecified-high` | Parallel Group: Wave 7 (parallel 109) | Blocked By: 2

  **Commit**: `feat(installer): update installers for skills bundle + mega-repos`

---

- [x] 111. Update README.md

  **What to do**: Add dynamic skill count badge `[![Skills](https://img.shields.io/badge/skills-200%2B-blue)](...)`. Update skill tables with categories. Add smart-detection section. Update numbers (53 -> 200+). Add OpenSkills mega-repos section.

  **Category**: `writing` | Parallel Group: Wave 7 (parallel 108-113) | Blocked By: 108

  **Commit**: `docs: update README, CONTRIBUTING.md, skills.txt`

---

- [x] 112. Update opencode.json if needed

  **What to do**: Verify skills.paths config still works with 200+ skills. Add new skills path if needed.

  **Category**: `quick` | Parallel Group: Wave 7 (parallel 108-113)

  **Commit**: `feat(config): update opencode.json for expanded skills path`

---

- [x] 113. Update CONTRIBUTING.md

  **What to do**: Update skill adding instructions for new batch process. Add audit plugin usage. Add CI validation steps. Add mega-repo contribution guide.

  **Category**: `writing` | Parallel Group: Wave 7 (parallel 108-113)

  **Commit**: `docs: update README, CONTRIBUTING.md, skills.txt`

---

- [x] 114. Create skills bundle archive

  **What to do**: Run `scripts/bundle-skills.ps1` to create `config/skills.tar.gz`. Add to repo.

  **Category**: `quick` | Parallel Group: Wave 7 (after 2) | Blocked By: 2

  **Commit**: `chore: add skills bundle archive for installer`

---

- [x] 115. Validation - all SKILL.md files

  **What to do**: Run validation script across ALL new skills. Check: YAML frontmatter present, description non-empty, body >= 15 lines, no duplicate descriptions.

  **Category**: `quick` | Parallel Group: Wave 7 (parallel 115-118) | Blocked By: 104

  **QA**:
  ```
  Scenario: All skills validate
    Tool: Bash | Steps: pwsh scripts/validate-skills.ps1 --strict
    Expected: Exit code 0 | Evidence: .sisyphus/evidence/task-115-all-valid.txt
  ```

---

- [x] 116. Validation - skills.txt sync

  **What to do**: Verify skills.txt matches filesystem exactly.

  **Category**: `quick` | Parallel Group: Wave 7 (parallel 115-118) | Blocked By: 108

---

- [x] 117. Validation - audit plugin output

  **What to do**: Run audit plugin both formats. Verify markdown table renders correctly. Verify JSON parses and contains expected fields.

  **Category**: `quick` | Parallel Group: Wave 7 (parallel 115-118) | Blocked By: 104, 105

---

- [x] 118. Validation - installers dry-run

  **What to do**: Run install.ps1 -NonInteractive locally (clone mode). Verify it completes without errors. Verify OpenSkills mega-repos install correctly.

  **Category**: `unspecified-high` | Parallel Group: Wave 7 (parallel 115-118) | Blocked By: 109, 110

---

## Final Verification Wave

> 4 review agents run in PARALLEL. ALL must APPROVE.

- [x] F1. **Plan Compliance Audit** — `oracle`
  Read the plan end-to-end. For each "Must Have": verify implementation exists. For each "Must NOT Have": search codebase for forbidden patterns. Check evidence files in `.sisyphus/evidence/`. Compare deliverables against plan.
  Output: `Must Have [N/N] | Must NOT Have [N/N] | Tasks [N/N] | VERDICT: APPROVE/REJECT`

- [x] F2. **Skill Content Quality Review** — `unspecified-high`
  Sample 20% of new SKILL.md files. Check: valid YAML frontmatter, description starts with trigger keywords, body ≥15 lines, practical instructions, no hallucinated APIs. Check for AI slop: vague descriptions, generic examples.
  Output: `Samples [N/N pass] | Issues [N] | VERDICT`

- [x] F3. **Real Manual QA** — `unspecified-high`
  Run audit plugin both formats. Simulate CI steps. Validate badge URL. Test installer dry-run. Check skills.txt diff. Run every validation script.
  Output: `Audit [PASS/FAIL] | CI [PASS/FAIL] | Installer [PASS/FAIL] | skills.txt [PASS/FAIL] | VERDICT`

- [x] F4. **Scope Fidelity Check** — `deep`
  For each wave: read "What to do", read actual diff. Verify 1:1 — everything in spec was built, nothing beyond spec. Check "Must NOT do" compliance. Detect cross-task contamination.
  Output: `Waves [N/N compliant] | Contamination [CLEAN/N issues] | Unaccounted [CLEAN/N files] | VERDICT`

---

## Commit Strategy

- **Wave 1**: `feat(skills): add foundation tooling for skill generation`
- **Wave 2**: `feat(skills): add Tier 1 frontend skills (nextjs, vue, svelte, angular, etc.)`
- **Wave 3**: `feat(skills): add Tier 2 backend skills (express, nestjs, fastapi, spring-boot, etc.)`
- **Wave 4**: `feat(skills): add Tier 3-5 skills (languages, mobile, databases)`
- **Wave 5**: `feat(skills): add Tier 6-8 skills (AI/ML, devops, testing)`
- **Wave 6**: `feat(skills): add Tier 9-10 skills (design, tools, misc)`
- **Wave 7a**: `feat(scripts): add skill-audit plugin (ps1 + sh)`
- **Wave 7b**: `ci: update CI pipeline with skill count badge`
- **Wave 7c**: `feat(config): update AGENTS.md with smart-detection directive`
- **Wave 7d**: `feat(installer): update installers for skills bundle + mega-repos`
- **Wave 7e**: `docs: update README, CONTRIBUTING.md, skills.txt`
- **Final**: `chore: validation passes and QA cleanup`

---

## Success Criteria

### Verification Commands
```bash
# Skills count
count=$(ls -d config/skills/*/ | wc -l); echo "Skills: $count"; [ "$count" -ge 200 ]

# skills.txt sync
diff <(ls -d config/skills/*/ | xargs -I{} basename {} | sort) <(cat config/skills.txt | sort) || echo "FAIL"

# Audit plugin - Markdown
scripts/skill-audit.ps1 --format md | grep -q "| Total Skills |"

# Audit plugin - JSON
scripts/skill-audit.sh --format json | python3 -c "import json,sys; d=json.load(sys.stdin); assert d['count'] >= 200"

# Smart detection in AGENTS.md
grep -q "smart.skill.detection" config/AGENTS.md || echo "FAIL"

# Existing 53 not touched
for s in a11y api arch async auth benchmark caching ci cleanup cli config css data db debug deploy docker docs env error find git git-master graphql i18n json logging markdown mcp migration monitoring naming node onboard openspec perf playwright pr-review python react refactor regex rest scaffold security self-healing serialize shell state test typescript ui webhook; do
  head -3 "config/skills/$s/SKILL.md" | grep -q "^---$" || echo "MISSING: $s"
done; echo "All 53 existing skills present"
```

### Final Checklist
- [ ] All "Must Have" present (150+ new skills, audit plugin, CI, AGENTS.md, installers)
- [ ] All "Must NOT Have" absent (no category migration, no inline listing, no existing skill changes)
- [ ] All validation commands pass
- [ ] All 53 original skills intact
- [ ] skills.txt in sync with filesystem
