# Learnings - Skills Ecosystem Expansion

## Conventions
- Skills format: YAML frontmatter + Markdown body
- All skills in flat structure: `config/skills/<name>/SKILL.md`
- No category migration - keep existing 53 where they are
- Validation: every SKILL.md must have frontmatter, description, >=15 body lines
- Batch generation for 150+ new skills from CSV template

## Key Decisions
- Flat structure (no categories)
- Dual-format audit plugin (md + json)
- Smart detection: check installed first, web search fallback
- Skills bundle archive for installer (not 200+ HTTP requests)

## Task 1 - Skill Generation Tooling (2026-05-14)
- Created `config/skills/_template/SKILL.md` - canonical template with 4 sections (Core Concepts, Common Patterns, Best Practices, Common Code Patterns)
- Created `scripts/generate-skills.ps1` - batch generator that reads CSV and creates skill directories/files
- Template verified: frontmatter `---` (line 1), `description:` field, body = 25 lines (>= 15 required)
- Script verified: `--csv <path>` mandatory, `--dry-run` preview, error handling for missing CSV/template, skip-existing-directory logic
- Script uses `[Parameter(Mandatory)]` attribute binding for csv param, `Import-Csv` for parsing
- Template placeholder `skill-name` and description are replaced via `-replace` operator
- Optional `topics` column in CSV gets injected as HTML comment + topic list
- No external dependencies in either file


## Task 2 - Skills Validation Script (2026-05-14)
- Created `scripts/validate-skills.ps1` - validation script for skills ecosystem
- Checks: skills.txt sync (bidirectional), frontmatter presence, description field
- Strict mode: body length >= 15 lines, description >= 20 chars
- Parameters: `--strict`, `--min-count <N>` (default 50), `--format text|json`
- Filters underscore-prefixed dirs (like `_template`) as non-skills
- Exit code 0 = valid, exit code 1 = failure
- Tested: base, json, strict, min-count threshold all pass

## Task 3 - Wave 2 Frontend Skills (2026-05-14)
- Created 5 frontend framework skill files: angular, solidjs, qwik, astro, htmx
- Each ~31-33 lines with frontmatter, 4 sections, framework-specific content
- All skill entries added to config/skills.txt in alphabetical order
- Validation now passes for all 5 new skills (only pre-existing nuxt/svelte/sveltekit/vue missing from txt)
- Body lines per file: angular=28, solidjs=27, qwik=28, astro=28, htmx=28 (excluding frontmatter)
## Wave 2 - Frontend Framework Skills (2026-05-14)
- Created 3 skill files: nextjs, remix, gatsby (config/skills/<name>/SKILL.md)
- Each: 30 lines total, 26 body lines (>= 20 required), framework-specific content
- Frontmatter: name + description with trigger keywords
- skills.txt must be updated when adding new skills or validation fails
- New skills added to skills.txt: gatsby (between find and git), nextjs (between naming and node), remix (between refactor and regex)
- Content per spec: Next.js covers App Router/RSC/Server Actions, Remix covers web standards/loaders/actions, Gatsby covers GraphQL data layer/plugins/migration
