# OpenCode Supreme Setup

> One-command setup for the ultimate OpenCode experience — oh-my-openagent, caveman mode, custom agents, MCPs, and deepseek-v4-flash.

[![OpenCode](https://img.shields.io/badge/OpenCode-powered-6366f1?style=flat-square)](https://opencode.ai)
[![oh-my-openagent](https://img.shields.io/badge/oh--my--openagent-0.6%2B-22c55e?style=flat-square)](https://github.com/code-yeongyu/oh-my-openagent)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=flat-square)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](https://github.com/skeletorflet/opencode-supreme-setup/pulls)
[![GitHub Repo](https://img.shields.io/badge/GitHub-skeletorflet%2Fopencode--supreme--setup-181717?style=flat-square&logo=github)](https://github.com/skeletorflet/opencode-supreme-setup)

---

## What's Included

| Feature | Description |
|---------|-------------|
| **oh-my-openagent** | Sisyphus orchestrator, Team Mode (8 parallel agents), ultrawork (`ulw`) |
| **Caveman Mode** | Zero-fluff AGENTS.md — ultra low tokens, English-only, auto-translate Spanish |
| **Custom Agents** | `caveman`, `security-auditor`, `docs-writer`, `refactor` |
| **MCPs** | `context7` (library docs), `gh_grep` (GitHub code search) |
| **Model** | 100% `opencode-go/deepseek-v4-flash` across all agents |
| **Optimizations** | Hashline edits, runtime fallback, dynamic context pruning, auto-resume |

## Prerequisites

- **Node.js** 18+ (for opencode)
- **Bun** 1.x (for oh-my-openagent) — auto-installed if missing
- **PowerShell 7+** (Windows) or **bash** (Linux/macOS)
- An **OpenCode Go** subscription ([$10/mo](https://opencode.ai/pricing)) — or any other supported provider key

## Quick Install

### Windows (PowerShell 7+)

```powershell
irm https://raw.githubusercontent.com/skeletorflet/opencode-supreme-setup/main/install.ps1 | iex
```

Or clone and run locally:

```powershell
git clone https://github.com/skeletorflet/opencode-supreme-setup.git && cd opencode-supreme-setup
.\install.ps1
```

### Linux / macOS

```bash
curl -fsSL https://raw.githubusercontent.com/skeletorflet/opencode-supreme-setup/main/install.sh | bash
```

Or clone and run locally:

```bash
git clone https://github.com/skeletorflet/opencode-supreme-setup.git && cd opencode-supreme-setup
chmod +x install.sh && ./install.sh
```

## Manual Install

1. Copy config files to `~/.config/opencode/`:

```powershell
cp config\* ~\.config\opencode\
```

2. Install oh-my-openagent plugin:

```powershell
bunx oh-my-openagent install --no-tui --claude=no --openai=no --gemini=no --copilot=no --opencode-go=yes
```

3. Authenticate with your provider:

```powershell
opencode auth login
```

4. (Optional) Install supermemory for persistent memory:

```powershell
bunx opencode-supermemory@latest install --no-tui
export SUPERMEMORY_API_KEY="sm_..."
```

5. (Optional) Install firecrawl for web scraping:

```powershell
npm install -g firecrawl-cli
firecrawl login --browser
```

## Files

| File | Purpose |
|------|---------|
| `config/opencode.jsonc` | Main OpenCode config — plugins, MCPs, agents, permissions |
| `config/oh-my-openagent.json` | oh-my-openagent plugin config — models, team mode, fallbacks |
| `config/AGENTS.md` | Global caveman instructions — zero fluff, low tokens |
| `install.ps1` | Windows PowerShell installer |
| `install.sh` | Linux/macOS bash installer |

## Usage

After installation, launch opencode and use these commands:

| Command | Action |
|---------|--------|
| `ulw` / `ultrawork` | Activate ALL agents in parallel |
| `Tab` | Cycle agents: build → plan → caveman |
| `@security-auditor` | Run security audit on code |
| `@docs-writer` | Generate documentation |
| `@refactor <files>` | Refactor specific files |
| `context7 <query>` | Search library documentation |
| `gh_grep <pattern>` | Search GitHub code examples |

## Troubleshooting

| Problem | Solution |
|---------|----------|
| `bunx oh-my-openagent` not found | Ensure Bun is installed: `bun --version`. Install with `npm install -g bun` |
| opencode not recognized | Install opencode: `npm install -g opencode-ai@latest` or see [opencode.ai/docs](https://opencode.ai/docs) |
| Auth errors | Run `opencode auth login` and select your provider |
| DeepSeek model fails | Check your OpenCode Go subscription is active and API key is set |
| Team Mode not working | Ensure `team_mode.enabled: true` in `oh-my-openagent.json` |

## Post-Install

After running the installer, authenticate your providers:

1. **OpenCode Go**: `opencode auth login` → select OpenCode Go → paste API key
2. **Supermemory** (optional): `bunx opencode-supermemory@latest login`
3. **Firecrawl** (optional): `firecrawl login --browser`

## Contributing

PRs are welcome! Feel free to open issues or submit improvements.

1. Fork the repo
2. Create a feature branch: `git checkout -b feat/amazing-idea`
3. Commit: `git commit -m "feat: add amazing idea"`
4. Push: `git push origin feat/amazing-idea`
5. Open a pull request

## License

MIT — do whatever you want with it.

---

<p align="center"><strong>Star the repo</strong> if you found this useful ⭐</p>
