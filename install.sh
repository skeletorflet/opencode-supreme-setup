#!/usr/bin/env bash
# OpenCode Supreme Setup v2.0
set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config/opencode"
CONFIG_URL="https://raw.githubusercontent.com/skeletorflet/opencode-supreme-setup/master/config"

# ── UI ──
G='\033[0;32m'; C='\033[0;36m'; Y='\033[1;33m'; R='\033[0;31m'; M='\033[1;35m'; D='\033[2m'; W='\033[1;37m'; NC='\033[0m'

step()  { echo -e "\n${C}  ── $1 ──${NC}"; }
ok()    { echo -e "  ${G}✓${NC} $1"; }
warn()  { echo -e "  ${Y}⚠${NC} $1"; }
info()  { echo -e "    ${D}$1${NC}"; }
sec()   { echo -e "\n  ${M}═══ $1 ═══${NC}"; }
yn()    { read -p "  ? $1 (y/n): " r; [ "$r" = "y" ] || [ "$r" = "yes" ]; }
sp()    { printf "  ${D}→${NC} $1 ... "; }

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
  echo '  ║    SUPREME SETUP — v2.0                  ║'
  echo '  ╚══════════════════════════════════════════╝'
  echo -e "${NC}"
}

run() {
  local name=$1; shift
  printf "  ${D}→${NC} $name ... "
  if "$@" &>/dev/null; then
    echo -e "${G}✓${NC}"
  else
    echo -e "${R}✗${NC}"
  fi
}

# ── MAIN ──
logo
echo -e "${W}  One-command setup for the ultimate OpenCode experience${NC}"
echo -e "${D}  oh-my-openagent · 50+ skills · caveman mode · deepseek-v4-flash${NC}"

# Step 0: Prerequisites
step "Prerequisites"
run "Node.js"   bash -c "command -v node && info \$(node --version)"
run "Bash 4+"   bash -c "((BASH_VERSINFO >= 4))"

# Step 1: OpenCode
step "OpenCode"
sp "Check/install"
if command -v opencode &>/dev/null; then
  ok "$(opencode --version)"
else
  curl -fsSL https://opencode.ai/install | bash &>/dev/null && ok "Installed" || warn "Install failed"
fi

# Step 2: Bun
step "Bun"
sp "Check/install"
if command -v bun &>/dev/null; then
  ok "$(bun --version)"
else
  curl -fsSL https://bun.sh/install | bash &>/dev/null
  export PATH="$HOME/.bun/bin:$PATH"
  command -v bun &>/dev/null && ok "Installed" || warn "Install failed"
fi

# Step 3: Subscription flags
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
run "Install plugin" bunx oh-my-openagent install --no-tui $FLAGS --skip-auth 2>&1 || \
  run "Fallback install" bunx oh-my-openagent install --no-tui --claude=no --openai=no --gemini=no --copilot=no --opencode-go=yes --skip-auth 2>&1

# Step 5: Config files
step "Configuration"
mkdir -p "$CONFIG_DIR"
# Clean old config files that could cause conflicts
rm -f "$CONFIG_DIR/opencode.jsonc" "$CONFIG_DIR/opencode.jsonc.backup-"*

if [ -d "$REPO_DIR/config" ]; then
  run "Copy config" cp -r "$REPO_DIR/config/"* "$CONFIG_DIR/"
else
  run "opencode.json"     curl -fsSL "$CONFIG_URL/opencode.json" -o "$CONFIG_DIR/opencode.json"
  run "oh-my-openagent.json" curl -fsSL "$CONFIG_URL/oh-my-openagent.json" -o "$CONFIG_DIR/oh-my-openagent.json"
  run "AGENTS.md"         curl -fsSL "$CONFIG_URL/AGENTS.md" -o "$CONFIG_DIR/AGENTS.md"
  run "Download skills"   bash -c "
    mkdir -p \"$CONFIG_DIR/skills\"
    for s in \$(curl -fsSL \"$CONFIG_URL/skills.txt\"); do
      mkdir -p \"$CONFIG_DIR/skills/\$s\"
      curl -fsSL \"$CONFIG_URL/skills/\$s/SKILL.md\" -o \"$CONFIG_DIR/skills/\$s/SKILL.md\" 2>/dev/null
    done
  "
fi

# Register plugin
OC="$CONFIG_DIR/opencode.json"
if [ -f "$OC" ]; then
  python3 -c "
import json
with open('$OC') as f: c = json.load(f)
if 'oh-my-openagent' not in c.get('plugin', []):
  c.setdefault('plugin', []).insert(0, 'oh-my-openagent')
  with open('$OC', 'w') as f: json.dump(c, f, indent=2)
  print('registered')
" 2>/dev/null && ok "Plugin registered" || true
fi

# Step 6: Platform optimizations
step "Platform optimizations"
OMO="$CONFIG_DIR/oh-my-openagent.json"
if [ -f "$OMO" ]; then
  run "Optimize config" python3 -c "
import json, sys, shutil
with open('$OMO') as f: c = json.load(f)
if not shutil.which('tmux'): c.get('tmux', {})['enabled'] = False
for k, v in c.get('agents', {}).items():
  v['model'] = 'opencode-go/deepseek-v4-flash'
  v.pop('fallback_models', None)
for k, v in c.get('categories', {}).items():
  v['model'] = 'opencode-go/deepseek-v4-flash'
  v.pop('fallback_models', None)
with open('$OMO', 'w') as f: json.dump(c, f, indent=2)
"
fi

# Step 7: Developer tools
step "Developer tools"
run "Comment checker" bash -c "npm install -g @code-yeongyu/comment-checker 2>/dev/null"

run "GitHub CLI" bash -c "
  if command -v gh &>/dev/null; then true
  elif command -v brew &>/dev/null; then brew install gh 2>/dev/null
  elif command -v apt &>/dev/null; then sudo apt install -y gh 2>/dev/null
  else false; fi
"

# Step 8: Plugins
step "Essential plugins"
run "opencode-snippets" npm install -g opencode-snippets 2>/dev/null
run "opencode-notify"   npm install -g opencode-notify 2>/dev/null

yn "Install agentsys (20 plugins, 49 agents, 41 skills)?" && \
  run "agentsys" npm install -g agentsys 2>/dev/null

# Step 9: Optional extras
step "Optional extras"
yn "Install supermemory?" && run "Supermemory" bash -c "bunx opencode-supermemory@latest install --no-tui 2>&1"
yn "Install firecrawl?" && run "Firecrawl" bash -c "npm install -g firecrawl-cli 2>/dev/null || npm install -g @firecrawl/firecrawl-cli 2>/dev/null"
yn "Install wakatime?" && run "WakaTime" npm install -g opencode-wakatime 2>/dev/null

# Step 10: Verify
step "Verification"
run "Doctor" bunx oh-my-openagent doctor 2>&1 || true

# Step 11: Summary
sec "Setup Complete!"
echo -e "${C}"
echo '  ╔══════════════════════════════════════════╗'
echo '  ║  🚀  opencode          — launch          ║'
echo '  ║  🔥  ulw <task>        — ultrawork       ║'
echo '  ║  ↹  Tab                — cycle agents    ║'
echo '  ║  🛡  @security-auditor — security        ║'
echo '  ║  🔧  @refactor <files> — refactor        ║'
echo '  ║  📝  @docs-writer      — docs            ║'
echo '  ║  🎯  51 skills         — auto-triggered   ║'
echo '  ║  📋  #snippet          — text expansion   ║'
echo '  ║  🔔  Notifications     — task alerts      ║'
echo '  ╚══════════════════════════════════════════╝'
echo -e "${NC}"
echo -e "  ${Y}Auth: opencode auth login${NC}"
echo -e "  ${D}Star: https://github.com/skeletorflet/opencode-supreme-setup${NC}"
echo
