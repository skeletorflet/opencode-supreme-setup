#!/usr/bin/env bash
# OpenCode Supreme Setup v4.0
set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config/opencode"
CONFIG_URL="https://raw.githubusercontent.com/skeletorflet/opencode-supreme-setup/master/config"

# Colors & Styles
G='\033[0;32m'; C='\033[0;36m'; Y='\033[1;33m'; R='\033[0;31m'; M='\033[1;35m'; D='\033[2m'; W='\033[1;37m'; NC='\033[0m'
BOLD='\033[1m'; UNDERLINE='\033[4m'; CURSOR_OFF='\033[?25l'; CURSOR_ON='\033[?25h'; CLEAR_LINE='\033[2K\r'

# UI Helpers
step()  { echo -e "\n${BOLD}${C}── $1 ──${NC}"; }
ok()    { echo -e "${G}  ✓${NC} $1"; }
warn()  { echo -e "${Y}  ⚠${NC} $1"; }
info()  { echo -e "    ${D}$1${NC}"; }
sec()   { echo -e "\n${M}═══ $1 ═══${NC}"; }

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
  echo '  ║    SUPREME SETUP — v4.0                  ║'
  echo '  ╚══════════════════════════════════════════╝'
  echo -e "${NC}"
}

# Logging Setup
LOG_FILE="/tmp/opencode_setup_$(date +%Y%m%d_%H%M%S).log"
touch "$LOG_FILE"

# Live Progress Loader
run() {
  local name=$1; shift
  local pid
  local frames='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
  
  # Ensure the line is fresh
  printf "${CLEAR_LINE}  ${C}⠋${NC} ${name} ..."
  
  # Run command in background, redirecting output to a temporary file
  tmp_out=$(mktemp)
  "$@" > "$tmp_out" 2>&1 &
  pid=$!
  
  local i=0
  while kill -0 $pid 2>/dev/null; do
    printf "\r  ${C}${frames:i++%10:1}${NC} ${name} ..."
    sleep 0.1
  done
  
  wait $pid
  local exit_code=$?
  
  cat "$tmp_out" >> "$LOG_FILE"
  
  if [ $exit_code -eq 0 ]; then
    printf "${CLEAR_LINE}${G}  ✓${NC} ${name}\n"
    rm -f "$tmp_out"
    return 0
  else
    printf "${CLEAR_LINE}${R}  ✗${NC} ${name}\n"
    echo -e "${D}      Error: $(tail -n 1 "$tmp_out")${NC}"
    rm -f "$tmp_out"
    return 1
  fi
}

# ── MAIN ──
echo -e "${CURSOR_OFF}"
trap 'echo -e "${CURSOR_ON}"; exit' INT TERM EXIT

logo
echo -e "${W}  ${BOLD}Ultimate OpenCode Experience${NC}"
echo -e "${D}  150+ skills · 13 plugins · SDD · self-healing · dashboard · caveman-v4${NC}"

# Step 0: Prerequisites
step "Prerequisites"
run "Node.js 18+" bash -c "command -v node && node --version | grep -q 'v1[89]\|v[2-9]'"

# Step 1: OpenCode
step "OpenCode"
run "Check/install opencode" bash -c "
  if command -v opencode &>/dev/null; then true
  else curl -fsSL https://opencode.ai/install | bash &>/dev/null; command -v opencode; fi
"

# Step 2: Bun
step "Bun"
run "Check/install bun" bash -c "
  if command -v bun &>/dev/null; then true
  else curl -fsSL https://bun.sh/install | bash &>/dev/null; export PATH=\"\$HOME/.bun/bin:\$PATH\"; command -v bun; fi
"

# Step 3: Provider flags
step "Provider subscriptions"
echo -e "${CURSOR_ON}"
read -p "  ? Claude Pro/Max? (y/n/max20): " r
case "$r" in y|yes) CLAUDE="--claude=yes" ;; max20) CLAUDE="--claude=max20" ;; *) CLAUDE="--claude=no" ;; esac
read -p "  ? ChatGPT Plus? (y/n): " r; [[ "$r" =~ ^(y|yes)$ ]] && OPENAI="--openai=yes" || OPENAI="--openai=no"
read -p "  ? Gemini? (y/n): " r;     [[ "$r" =~ ^(y|yes)$ ]] && GEMINI="--gemini=yes" || GEMINI="--gemini=no"
read -p "  ? Copilot? (y/n): " r;    [[ "$r" =~ ^(y|yes)$ ]] && COPILOT="--copilot=yes" || COPILOT="--copilot=no"
read -p "  ? OpenCode Go? (y/n): " r; [[ "$r" =~ ^(y|yes)$ ]] && OG="--opencode-go=yes" || OG="--opencode-go=no"
FLAGS="$CLAUDE $OPENAI $GEMINI $COPILOT $OG"
echo -e "${CURSOR_OFF}"
info "Flags: $FLAGS"

# Step 4: oh-my-openagent
step "oh-my-openagent"
run "Install plugin" bunx oh-my-openagent install --no-tui $FLAGS --skip-auth || \
  run "Fallback install" bunx oh-my-openagent install --no-tui --claude=no --gemini=no --copilot=no --opencode-go=yes --skip-auth

# Step 5: Config files
step "Configuration"
run "Cleanup old configs" rm -f "$CONFIG_DIR/opencode.jsonc" "$CONFIG_DIR/opencode.jsonc.backup-"*
mkdir -p "$CONFIG_DIR"

if [ -d "$REPO_DIR/config" ]; then
  run "Sync local config" cp -r "$REPO_DIR/config/"* "$CONFIG_DIR/"
else
  run "Download opencode.json" curl -fsSL "$CONFIG_URL/opencode.json" -o "$CONFIG_DIR/opencode.json"
  run "Download oh-my-openagent.json" curl -fsSL "$CONFIG_URL/oh-my-openagent.json" -o "$CONFIG_DIR/oh-my-openagent.json"
  run "Download AGENTS.md" curl -fsSL "$CONFIG_URL/AGENTS.md" -o "$CONFIG_DIR/AGENTS.md"
  run "Install 53 skills" bash -c "
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
" 2>/dev/null && ok "Plugin registered in config" || true
fi

# Step 6: Model selection + platform config
step "Model configuration"
MODEL=""
if [ -f "$CONFIG_DIR/oh-my-openagent.json" ]; then
  echo -e "${CURSOR_ON}"
  echo "    1) Keep oh-my-openagent defaults"
  echo "    2) DeepSeek V4 Flash on ALL agents"
  echo "    3) Custom model"
  read -p "  ? Choose (1-3): " mc
  case "$mc" in
    1) MODEL="" ;;
    2) MODEL="opencode-go/deepseek-v4-flash" ;;
    3) read -p "  Enter full model: " MODEL ;;
    *) MODEL="" ;;
  esac
  echo -e "${CURSOR_OFF}"
  [ -n "$MODEL" ] && info "Model: $MODEL" || info "Keeping default models"
fi

step "Platform optimizations"
if [ -f "$CONFIG_DIR/oh-my-openagent.json" ]; then
  run "Check tmux compatibility" python3 -c "
import json, shutil
with open('$CONFIG_DIR/oh-my-openagent.json') as f: c = json.load(f)
if not shutil.which('tmux'): c.get('tmux', {})['enabled'] = False
with open('$CONFIG_DIR/oh-my-openagent.json', 'w') as f: json.dump(c, f, indent=2)
"
  if [ -n "$MODEL" ]; then
    run "Apply model overrides" python3 -c "
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
run "Comment checker" npm install -g @code-yeongyu/comment-checker
run "AST-grep" npm install -g @ast-grep/cli
run "GitHub CLI" bash -c "
  if command -v gh &>/dev/null; then true
  elif command -v brew &>/dev/null; then brew install gh 2>/dev/null
  elif command -v apt &>/dev/null; then sudo apt install -y gh 2>/dev/null; else false; fi
"

# Step 8: Essential plugins
step "Supreme Plugins (10 total)"
for plugin in \
  "opencode-snippets|#snippet expansion" \
  "opencode-snip|Snip (-60-90% tokens)" \
  "opencode-notify|OS notifications" \
  "opencode-mem|Persistent memory" \
  "opencode-quota|Token tracking" \
  "opencode-background-agents|Async agents" \
  "opencode-worktree|Git worktrees" \
  "opencode-dynamic-context-pruning|Context pruning" \
  "opencode-smart-title|Smart titles" \
  "ocwatch|Visual dashboard"; do
  pkg="${plugin%%|*}"; desc="${plugin##*|}"
  run "$desc" npm install -g $pkg
done

# Step 9: OpenSkills
step "OpenSkills (100+ marketplace skills)"
run "Install anthropics/skills" npx openskills install anthropics/skills -y
run "Install openskills CLI" npm install -g openskills
run "Sync to AGENTS.md" npx openskills sync -y -o "$CONFIG_DIR/AGENTS.md"

# Step 10: Optional agentsys
echo -e "${CURSOR_ON}"
if ( read -p "  ? Install agentsys (49 agents)? (y/n): "; [[ "$REPLY" =~ ^(y|yes)$ ]] ); then
  echo -e "${CURSOR_OFF}"
  run "agentsys" npm install -g agentsys
fi

# Step 11: Optional extras
step "Optional extras"
echo -e "${CURSOR_ON}"
if ( read -p "  ? Install supermemory? (y/n): "; [[ "$REPLY" =~ ^(y|yes)$ ]] ); then
  echo -e "${CURSOR_OFF}"
  run "Supermemory" bunx opencode-supermemory@latest install --no-tui
fi

echo -e "${CURSOR_ON}"
if ( read -p "  ? Install firecrawl? (y/n): "; [[ "$REPLY" =~ ^(y|yes)$ ]] ); then
  echo -e "${CURSOR_OFF}"
  run "Firecrawl" bash -c "npm install -g firecrawl-cli 2>/dev/null || npm install -g @firecrawl/firecrawl-cli 2>/dev/null"
fi

echo -e "${CURSOR_ON}"
if ( read -p "  ? Install WakaTime? (y/n): "; [[ "$REPLY" =~ ^(y|yes)$ ]] ); then
  echo -e "${CURSOR_OFF}"
  run "WakaTime" npm install -g opencode-wakatime
fi

echo -e "${CURSOR_ON}"
if ( read -p "  ? Install themes? (y/n): "; [[ "$REPLY" =~ ^(y|yes)$ ]] ); then
  echo -e "${CURSOR_OFF}"
  for t in opencode-ayu-theme lavi opencode-moonlight-theme opencode-ai-poimandres-theme; do
    run "Theme: $t" npm install -g "$t"
  done
fi
echo -e "${CURSOR_OFF}"

# Step 12: Verify
step "Verification"
run "oh-my-openagent doctor" bunx oh-my-openagent doctor

# Step 13: Summary
sec "Setup Complete!"
echo -e "${BOLD}${C}"
echo '  ╔══════════════════════════════════════════════════════╗'
echo '  ║  🚀  opencode                  launch                ║'
echo '  ║  📊  ocwatch                  visual dashboard       ║'
echo '  ║  🔥  ulw <task>               ultrawork mode         ║'
echo '  ║  🛡  @spec-architect          SDD planning           ║'
echo '  ║  🩹  @self-healer            auto debugging         ║'
echo '  ║  🔧  @refactor               clean code             ║'
echo '  ║  🎯  150+ skills              auto-triggered         ║'
echo '  ║  🧠  Persistent memory        cross-session context  ║'
echo '  ║  ✂️  snip                     -60-90% token savings  ║'
echo '  ╚══════════════════════════════════════════════════════╝'
echo -e "${NC}"
echo -e "  ${BOLD}${Y}Auth: opencode auth login${NC}"
echo -e "  ${D}Star: https://github.com/skeletorflet/opencode-supreme-setup${NC}"
echo -e "  ${D}Log:  $LOG_FILE${NC}"
echo -e "${CURSOR_ON}"
