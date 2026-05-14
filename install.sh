#!/usr/bin/env bash
# OpenCode Supreme Setup v3.0
set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config/opencode"
CONFIG_URL="https://raw.githubusercontent.com/skeletorflet/opencode-supreme-setup/master/config"

G='\033[0;32m'; C='\033[0;36m'; Y='\033[1;33m'; R='\033[0;31m'; M='\033[1;35m'; D='\033[2m'; W='\033[1;37m'; NC='\033[0m'

step()  { echo -e "\n${C}  ── $1 ──${NC}"; }
ok()    { echo -e "  ${G}✓${NC} $1"; }
warn()  { echo -e "  ${Y}⚠${NC} $1"; }
info()  { echo -e "    ${D}$1${NC}"; }
sec()   { echo -e "\n  ${M}═══ $1 ═══${NC}"; }
yn()    { read -p "  ? $1 (y/n): " r; [ "$r" = "y" ] || [ "$r" = "yes" ]; }

logo() {
  clear
  echo -e "${C}"
  echo '  ╔══════════════════════════════════════════╗'
  echo '  ║      ███████╗██╗   ██╗██████╗ ██████╗   ║'
  echo '  ║      ██╔════╝██║   ██║██╔══██╗██╔══██╗  ║'
  echo '  ║      ███████╗██║   ██║██████╔╝██████╔╝  ║'
  echo '  ║      ╚════██║██║   ██║██╔═══╝ ██╔══██╗  ║'
  echo '  ║      ███████║╚██████╔╝██║     ██║  ██║  ║'
  echo '  ║      ╚══════╝ ╚═════╝ ╚═╝     ╚═╝  ╚═╝  ║'
  echo '  ║    SUPREME SETUP — v3.0                  ║'
  echo '  ╚══════════════════════════════════════════╝'
  echo -e "${NC}"
}

run() {
  local name=$1; shift
  printf "  ${D}→${NC} $name ... "
  if "$@" &>/dev/null; then echo -e "${G}✓${NC}"; else echo -e "${R}✗${NC}"; fi
}

# ── MAIN ──
logo
echo -e "${W}  One-command setup — the ULTIMATE OpenCode experience${NC}"
echo -e "${D}  130+ skills · 12 plugins · memory · snip · caveman · deepseek-v4-flash${NC}"

# Step 0: Prerequisites
step "Prerequisites"
run "Node.js 18+" bash -c "command -v node && node --version | grep -q 'v1[89]\|v[2-9]'"

# Step 1: OpenCode
step "OpenCode"
run "Check/install" bash -c "
  if command -v opencode &>/dev/null; then ok \"\$(opencode --version)\"; true
  else curl -fsSL https://opencode.ai/install | bash &>/dev/null; command -v opencode; fi
"

# Step 2: Bun
step "Bun"
run "Check/install" bash -c "
  if command -v bun &>/dev/null; then ok \"\$(bun --version)\"; true
  else curl -fsSL https://bun.sh/install | bash &>/dev/null; export PATH=\"\$HOME/.bun/bin:\$PATH\"; command -v bun; fi
"

# Step 3: Provider flags
step "Provider subscriptions"
read -p "  ? Claude Pro/Max? (y/n/max20): " r
case "$r" in y|yes) CLAUDE="--claude=yes" ;; max20) CLAUDE="--claude=max20" ;; *) CLAUDE="--claude=no" ;; esac
read -p "  ? ChatGPT Plus? (y/n): " r; [[ "$r" =~ ^(y|yes)$ ]] && OPENAI="--openai=yes" || OPENAI="--openai=no"
read -p "  ? Gemini? (y/n): " r;     [[ "$r" =~ ^(y|yes)$ ]] && GEMINI="--gemini=yes" || GEMINI="--gemini=no"
read -p "  ? Copilot? (y/n): " r;    [[ "$r" =~ ^(y|yes)$ ]] && COPILOT="--copilot=yes" || COPILOT="--copilot=no"
read -p "  ? OpenCode Go? (y/n): " r; [[ "$r" =~ ^(y|yes)$ ]] && OG="--opencode-go=yes" || OG="--opencode-go=no"
FLAGS="$CLAUDE $OPENAI $GEMINI $COPILOT $OG"
info "Flags: $FLAGS"

# Step 4: oh-my-openagent
step "oh-my-openagent"
run "Install plugin" bash -c "bunx oh-my-openagent install --no-tui \$FLAGS --skip-auth 2>&1" || \
  run "Fallback" bash -c "bunx oh-my-openagent install --no-tui --claude=no --openai=no --gemini=no --copilot=no --opencode-go=yes --skip-auth 2>&1"

# Step 5: Config files
step "Configuration"
rm -f "$CONFIG_DIR/opencode.jsonc" "$CONFIG_DIR/opencode.jsonc.backup-"*
mkdir -p "$CONFIG_DIR"

if [ -d "$REPO_DIR/config" ]; then
  run "Copy config" cp -r "$REPO_DIR/config/"* "$CONFIG_DIR/"
else
  run "opencode.json"         curl -fsSL "$CONFIG_URL/opencode.json" -o "$CONFIG_DIR/opencode.json"
  run "oh-my-openagent.json"  curl -fsSL "$CONFIG_URL/oh-my-openagent.json" -o "$CONFIG_DIR/oh-my-openagent.json"
  run "AGENTS.md"             curl -fsSL "$CONFIG_URL/AGENTS.md" -o "$CONFIG_DIR/AGENTS.md"
  run "Download 51 skills" bash -c "
    mkdir -p \"$CONFIG_DIR/skills\"
    for s in \$(curl -fsSL \"$CONFIG_URL/skills.txt\"); do
      mkdir -p \"$CONFIG_DIR/skills/\$s\" 2>/dev/null
      curl -fsSL \"$CONFIG_URL/skills/\$s/SKILL.md\" -o \"$CONFIG_DIR/skills/\$s/SKILL.md\" 2>/dev/null
    done
  "
fi

# Register oh-my-openagent in opencode.json
if [ -f "$CONFIG_DIR/opencode.json" ]; then
  python3 -c "
import json
with open('$CONFIG_DIR/opencode.json') as f: c = json.load(f)
if 'oh-my-openagent' not in c.get('plugin', []):
  c.setdefault('plugin', []).insert(0, 'oh-my-openagent')
  with open('$CONFIG_DIR/opencode.json', 'w') as f: json.dump(c, f, indent=2)
" 2>/dev/null && ok "Plugin registered" || true
fi

# Step 6: Model selection + platform config
step "Model configuration"
MODEL=""
if [ -f "$CONFIG_DIR/oh-my-openagent.json" ]; then
  echo "    1) Keep oh-my-openagent default models"
  echo "    2) DeepSeek V4 Flash on ALL agents (opencode-go sub)"
  echo "    3) Custom model — you type any model name"
  read -p "  ? Choose (1-3): " mc
  case "$mc" in
    1) MODEL="" ;;
    2) MODEL="opencode-go/deepseek-v4-flash" ;;
    3) read -p "  Enter full model (e.g. opencode-go/deepseek-v4-flash): " MODEL ;;
    *) MODEL="" ;;
  esac
  [ -n "$MODEL" ] && info "Model: $MODEL" || info "Keeping default models"
fi

step "Platform optimizations"
if [ -f "$CONFIG_DIR/oh-my-openagent.json" ]; then
  run "Disable tmux if unavailable" python3 -c "
import json, shutil
with open('$CONFIG_DIR/oh-my-openagent.json') as f: c = json.load(f)
if not shutil.which('tmux'): c.get('tmux', {})['enabled'] = False
with open('$CONFIG_DIR/oh-my-openagent.json', 'w') as f: json.dump(c, f, indent=2)
"
  if [ -n "$MODEL" ]; then
    run "Set all agents to $MODEL" python3 -c "
import json
with open('$CONFIG_DIR/oh-my-openagent.json') as f: c = json.load(f)
for k, v in c.get('agents', {}).items():
  v['model'] = '$MODEL'; v.pop('fallback_models', None)
for k, v in c.get('categories', {}).items():
  v['model'] = '$MODEL'; v.pop('fallback_models', None)
with open('$CONFIG_DIR/oh-my-openagent.json', 'w') as f: json.dump(c, f, indent=2)
"
  fi
fi

# Step 7: Dev tools
step "Developer tools"
run "Comment checker" bash -c "npm install -g @code-yeongyu/comment-checker 2>/dev/null"
run "GitHub CLI" bash -c "
  if command -v gh &>/dev/null; then true
  elif command -v brew &>/dev/null; then brew install gh 2>/dev/null
  elif command -v apt &>/dev/null; then sudo apt install -y gh 2>/dev/null; else false; fi
"

# Step 8: Essential plugins
step "Essential plugins (9 total)"
for plugin in \
  "opencode-snippets|#snippet text expansion" \
  "opencode-snip|Snip -60-90% tokens" \
  "opencode-notify|OS notifications" \
  "opencode-mem|Persistent memory" \
  "opencode-quota|Token tracking" \
  "opencode-background-agents|Async agents" \
  "opencode-worktree|Git worktrees" \
  "opencode-dynamic-context-pruning|Context pruning" \
  "opencode-smart-title|Session titles"; do
  pkg="${plugin%%|*}"; desc="${plugin##*|}"
  run "$desc" bash -c "npm install -g $pkg 2>/dev/null"
done

# Step 9: OpenSkills
step "OpenSkills (100+ skills from marketplace)"
run "Install anthropics/skills" bash -c "npx openskills install anthropics/skills -y 2>/dev/null"
run "Install openskills CLI" bash -c "npm install -g openskills 2>/dev/null"
run "Sync to AGENTS.md" bash -c "npx openskills sync -y -o \"$CONFIG_DIR/AGENTS.md\" 2>/dev/null"

# Step 10: Optional agentsys
yn "Install agentsys (20 plugins, 49 agents, 41 skills)?" && \
  run "agentsys" npm install -g agentsys 2>/dev/null

# Step 11: Optional extras
step "Optional extras"
yn "Install supermemory?" && run "Supermemory" bash -c "bunx opencode-supermemory@latest install --no-tui 2>&1"
yn "Install firecrawl?" && run "Firecrawl" bash -c "npm install -g firecrawl-cli 2>/dev/null || npm install -g @firecrawl/firecrawl-cli 2>/dev/null"
yn "Install WakaTime?" && run "WakaTime" npm install -g opencode-wakatime 2>/dev/null
yn "Install themes (Ayu, Lavi, Moonlight, Poimandres)?" && {
  for t in opencode-ayu-theme lavi opencode-moonlight-theme opencode-ai-poimandres-theme; do
    run "Theme: $t" npm install -g "$t" 2>/dev/null
  done
}

# Step 12: Verify
step "Verification"
run "Doctor" bash -c "bunx oh-my-openagent doctor 2>&1 || true"

# Step 13: Summary
sec "Setup Complete!"
echo -e "${C}"
echo '  ╔══════════════════════════════════════════════════════╗'
echo '  ║  🚀  opencode                  launch                ║'
echo '  ║  🔥  ulw <task>               ultrawork mode         ║'
echo '  ║  ↹  Tab                       cycle agents           ║'
echo '  ║  🛡  @security-auditor        security audit         ║'
echo '  ║  🔧  @refactor <files>        refactor code          ║'
echo '  ║  📝  @docs-writer             write docs             ║'
echo '  ║  🎯  150+ skills              auto-triggered         ║'
echo '  ║  📋  #snippet                 text expansion         ║'
echo '  ║  🔔  Notifications            task done alerts       ║'
echo '  ║  🧠  Persistent memory        cross-session context  ║'
echo '  ║  ✂️  snip                     -60-90% token savings  ║'
echo '  ║  📊  quota                    token cost tracking    ║'
echo '  ║  🌳  worktree                 isolated git branches  ║'
echo '  ╚══════════════════════════════════════════════════════╝'
echo -e "${NC}"
echo -e "  ${Y}Auth: opencode auth login${NC}"
echo -e "  ${D}Star: https://github.com/skeletorflet/opencode-supreme-setup${NC}"
echo
