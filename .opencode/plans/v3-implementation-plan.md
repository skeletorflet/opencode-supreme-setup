# OpenCode Supreme Setup v3.0 — Implementation Plan

## Overview
Transform the repo into the ULTIMATE opencode setup: 130+ skills, 12 plugins, persistent memory, snip token savings, CI/CD, themes, and beautiful CLI.

---

## Files to Modify

### install.ps1 (REWRITE)
- Add plugins: snip, mem, quota, background-agents, worktree, dynamic-context-pruning, smart-title
- Add openskills integration (npx openskills install anthropics/skills)
- Add snip CLI installation
- Add theme installation
- Deduplicate plugin step8/step1  
- Better summary box with all new features

### install.sh (REWRITE to match install.ps1)
- Same plugin additions
- snip via brew/go install
- openskills integration

### config/opencode.json (UPDATE)
```json
{
  "plugin": [
    "oh-my-openagent",
    "opencode-snippets",
    "opencode-snip",
    "opencode-notify",
    "opencode-mem",
    "opencode-quota",
    "opencode-background-agents",
    "opencode-worktree",
    "opencode-dynamic-context-pruning",
    "opencode-smart-title"
  ],
  "agent": {
    "caveman": { ... },
    "security-auditor": { ... },
    "docs-writer": { ... },
    "refactor": { ... }
  },
  "skills": { "paths": ["~/.config/opencode/skills"] }
}
```

### config/skills.txt (UPDATE)
- Regenerate after adding any new skills

### config/AGENTS.md (UPDATE)
- Add openskills `<available_skills>` reference
- Add `npx openskills read <skill>` instructions

### README.md (REWRITE)
- New badges: npm downloads, version, tests
- Full plugin table with descriptions
- 130+ skills mention
- Memory, snip, worktree features
- Theme installation section

### .github/workflows/test.yml (NEW)
- GitHub Actions CI to test install.ps1 and install.sh
- Verify opencode.json schema
- Skills inventory validation

### CONTRIBUTING.md (NEW)
- How to add skills, plugins, themes
- PR template

---

## Execution Order

1. ✅ ~~Phase 1-2 already drafted in install.ps1~~ [REWRITE NEEDED]
2. Write config/opencode.json with all plugin entries
3. Write CONTRIBUTING.md
4. Write .github/workflows/test.yml
5. Rewrite install.ps1 (v3.0)
6. Rewrite install.sh (v3.0)
7. Rewrite README.md (v3.0)
8. Update config/AGENTS.md with openskills support
9. Test: opencode --version
10. git add, commit, push

---

## Plugin Details

| Plugin | npm package | Purpose |
|--------|-----------|---------|
| oh-my-openagent | oh-my-openagent | Agent orchestration, team mode, MCPs |
| opencode-snippets | opencode-snippets | #snippet text expansion |
| opencode-snip | opencode-snip | -60-90% tokens on shell output |
| opencode-notify | opencode-notify | OS notifications |
| opencode-mem | opencode-mem | Vector DB persistent memory |
| opencode-quota | opencode-quota | Token/cost tracking |
| opencode-background-agents | opencode-background-agents | Async agent delegation |
| opencode-worktree | opencode-worktree | Git worktrees |
| opencode-dynamic-context-pruning | opencode-dynamic-context-pruning | Auto-prune context |
| opencode-smart-title | opencode-smart-title | Auto session titles |

## openskills Integration
```powershell
npx openskills install anthropics/skills -y     # 30+ official skills
npx openskills sync -y -o AGENTS.md            # Regenerate XML manifest
npm install -g openskills                       # Global CLI for future use
```

## Themes (optional)
- opencode-ayu-theme
- lavi
- opencode-moonlight-theme
- opencode-ai-poimandres-theme
