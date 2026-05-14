# OpenCode Supreme Setup

One-command setup for the ultimate OpenCode experience with oh-my-openagent, caveman mode, custom agents, MCPs, and deepseek-v4-flash.

## What's Included

- **oh-my-openagent** — Sisyphus orchestrator, Team Mode (8 agents), ultrawork
- **Caveman Mode AGENTS.md** — zero fluff, ultra low tokens, English-only, auto-translate
- **Custom Agents** — `caveman`, `security-auditor`, `docs-writer`, `refactor`
- **MCPs** — context7 (library docs), gh_grep (GitHub code search)
- **Model** — 100% opencode-go/deepseek-v4-flash on all agents
- **Optimizations** — hashline edits, runtime fallback, dynamic context pruning, auto-resume

## Quick Install

### Windows (PowerShell 7+)

```powershell
irm https://raw.githubusercontent.com/YOUR_USER/opencode-supreme-setup/main/install.ps1 | iex
```

Or clone and run:

```powershell
git clone <repo-url> && cd opencode-supreme-setup
.\install.ps1
```

### Linux / macOS

```bash
curl -fsSL https://raw.githubusercontent.com/YOUR_USER/opencode-supreme-setup/main/install.sh | bash
```

Or clone and run:

```bash
git clone <repo-url> && cd opencode-supreme-setup
chmod +x install.sh && ./install.sh
```

## Manual Install

1. Copy config files:
```powershell
cp config\* ~\.config\opencode\
```

2. Install plugin:
```powershell
bunx oh-my-openagent install --no-tui --claude=no --openai=no --gemini=no --copilot=no --opencode-go=yes
```

3. Authenticate providers:
```powershell
opencode auth login
```

4. (Optional) Install supermemory:
```powershell
bunx opencode-supermemory@latest install --no-tui
export SUPERMEMORY_API_KEY="sm_..."
```

5. (Optional) Install firecrawl:
```powershell
npm install -g firecrawl-cli
firecrawl login --browser
```

## Files

| File | Purpose |
|------|---------|
| `config/opencode.jsonc` | Main OpenCode config (plugins, MCPs, agents, permissions) |
| `config/oh-my-openagent.json` | oh-my-openagent plugin config (models, team mode, fallbacks) |
| `config/AGENTS.md` | Global caveman instructions (zero fluff, low tokens) |
| `install.ps1` | Windows PowerShell installer |
| `install.sh` | Linux/macOS bash installer |

## Post-Install

After running, you'll need to optionally authenticate providers:

1. **OpenCode Go**: `opencode auth login` → select OpenCode Go → paste API key
2. **Supermemory** (optional): `bunx opencode-supermemory@latest login`
3. **Firecrawl** (optional): `firecrawl login --browser`

Then run `opencode` and use:
- `ulw` or `ultrawork` — activate all agents in parallel
- Press **Tab** to cycle agents: build → plan → caveman
- `@security-auditor`, `@docs-writer`, `@refactor` — invoke subagents
- `context7` — search library docs
- `gh_grep` — search GitHub code examples
