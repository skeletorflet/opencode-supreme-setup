# OpenCode Supreme Setup

> One-command setup for the ultimate OpenCode experience — oh-my-openagent, caveman mode, 50+ built-in skills, custom agents, MCPs, and deepseek-v4-flash.

[![OpenCode](https://img.shields.io/badge/OpenCode-powered-6366f1?style=flat-square)](https://opencode.ai)
[![oh-my-openagent](https://img.shields.io/badge/oh--my--openagent-0.6%2B-22c55e?style=flat-square)](https://github.com/code-yeongyu/oh-my-openagent)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=flat-square)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](https://github.com/skeletorflet/opencode-supreme-setup/pulls)
[![GitHub](https://img.shields.io/badge/GitHub-skeletorflet%2Fopencode--supreme--setup-181717?style=flat-square&logo=github)](https://github.com/skeletorflet/opencode-supreme-setup)

---

## What's Included

| Feature | Description |
|---------|-------------|
| **oh-my-openagent** | Sisyphus orchestrator, Team Mode (8 parallel agents), ultrawork (`ulw`) |
| **Caveman Mode** | Zero-fluff AGENTS.md — ultra low tokens, auto-translate any language to English |
| **Custom Agents** | `caveman`, `security-auditor`, `docs-writer`, `refactor` |
| **50+ Built-in Skills** | find, debug, test, perf, api, git, docker, regex, shell, security, db, a11y, i18n, ci, and more |
| **MCPs** | context7 (library docs), gh_grep (GitHub code search) |
| **Model** | 100% `opencode-go/deepseek-v4-flash` across all agents |
| **Optimizations** | Hashline edits, runtime fallback, dynamic context pruning, auto-resume, cross-platform |

## Prerequisites

- **Node.js** 18+ (for opencode)
- **Bun** 1.x (for oh-my-openagent) — auto-installed if missing
- **PowerShell 7+** (Windows) or **bash** (Linux/macOS)
- An **OpenCode Go** subscription ([$10/mo](https://opencode.ai/pricing)) or other provider key

The installer auto-detects your platform and handles everything:
- Windows: disables tmux, installs gh via winget
- Linux/macOS: keeps tmux enabled, installs gh via brew/apt

## Quick Install

### Windows (PowerShell 7+)

```powershell
irm https://raw.githubusercontent.com/skeletorflet/opencode-supreme-setup/master/install.ps1 | iex
```

Or clone and run locally:

```powershell
git clone https://github.com/skeletorflet/opencode-supreme-setup.git && cd opencode-supreme-setup
.\install.ps1
```

### Linux / macOS

```bash
curl -fsSL https://raw.githubusercontent.com/skeletorflet/opencode-supreme-setup/master/install.sh | bash
```

Or clone and run locally:

```bash
git clone https://github.com/skeletorflet/opencode-supreme-setup.git && cd opencode-supreme-setup
chmod +x install.sh && ./install.sh
```

## What Gets Installed

The installer runs these steps automatically:

1. Checks/installs **Node.js** and **Bun**
2. Installs **OpenCode** and **oh-my-openagent**
3. Registers the **oh-my-openagent** plugin in opencode.json
4. Copies/downloads **config files** (opencode.json, oh-my-openagent.json, AGENTS.md)
5. Downloads **50+ skills** to `~/.config/opencode/skills/`
6. Optimizes config for your platform (tmux on/off, model overrides)
7. Installs **comment-checker**, **GitHub CLI**, and optional plugins
8. Runs **doctor verification**

## Files

| File | Purpose |
|------|---------|
| `config/opencode.json` | Main OpenCode config — plugins, agents, skills path |
| `config/oh-my-openagent.json` | oh-my-openagent plugin config — models, team mode, fallbacks |
| `config/AGENTS.md` | Global caveman instructions — zero fluff, low tokens, multi-language |
| `config/skills/*/SKILL.md` | 50+ built-in skills for development workflows |
| `install.ps1` | Windows PowerShell installer (also works piped from irm) |
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
| *skill name in prompt* | Skills auto-trigger: find, debug, test, perf, git, docker, etc. |

All 50+ skills auto-register from `~/.config/opencode/skills/`. Just mention what you need and the appropriate skill activates.

## Troubleshooting

| Problem | Solution |
|---------|----------|
| `bunx oh-my-openagent` not found | Ensure Bun is installed: `bun --version`. Install with `npm install -g bun` |
| opencode not recognized | Install opencode: `npm install -g opencode-ai@latest` or see [opencode.ai/docs](https://opencode.ai/docs) |
| Auth errors | Run `opencode auth login` and select your provider |
| DeepSeek model fails | Check your OpenCode Go subscription and API key |
| Team Mode not working | Verify `team_mode.enabled: true` in `oh-my-openagent.json` |
| Skills not loading | Check `~/.config/opencode/skills/` exists with SKILL.md files |
| tmux error on Windows | Auto-disabled by the installer. Verify `tmux.enabled: false` |

## Post-Install

After running the installer, authenticate your providers:

```powershell
opencode auth login
```

Select your provider (OpenCode Go, Anthropic, OpenAI, etc.) and follow the prompts.

## Contributing

PRs are welcome! Feel free to open issues or submit improvements.

1. Fork the repo
2. Create a feature branch: `git checkout -b feat/amazing-idea`
3. Commit: `git commit -m "feat: add amazing idea"`
4. Push: `git push origin feat/amazing-idea`
5. Open a pull request

## License

MIT — do whatever you want.

---

<p align="center"><strong>Star the repo</strong> if you found this useful ⭐</p>
