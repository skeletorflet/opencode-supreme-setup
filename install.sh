#!/usr/bin/env bash
# OpenCode Supreme Setup v4.0
# shellcheck disable=SC2034,SC2059,SC2016

# ── Monokai Pastel Dark Palette (256-color ANSI) ───────────────────────────
R='\033[0m';  B='\033[1m';  DIM='\033[2m'
PURPLE='\033[38;5;141m'   # AB9DF2 – lavender
PINK='\033[38;5;211m'     # FF6188 – rose
GREEN='\033[38;5;114m'    # A9DC76 – sage
YELLOW='\033[38;5;222m'   # FFD866 – honey
CYAN='\033[38;5;117m'     # 78DCE8 – sky
ORANGE='\033[38;5;215m'   # FC9867 – peach
WHITE='\033[38;5;253m'    # F8F8F2 – soft white
GRAY='\033[38;5;242m'     # 75715E – muted
RED='\033[38;5;203m'      # FF5555 – pastel red

# ── Terminal ───────────────────────────────────────────────────────────────
CLR='\033[2K\r'
hide_cursor(){ printf '\033[?25l'; }
show_cursor(){ printf '\033[?25h'; }
trap 'show_cursor; echo' EXIT INT TERM

# ── Logging ────────────────────────────────────────────────────────────────
LOG="/tmp/oc_setup_$(date +%Y%m%d_%H%M%S).log"
: > "$LOG"

# ── State ──────────────────────────────────────────────────────────────────
PHASE=0; TOTAL=10

# ── Header ─────────────────────────────────────────────────────────────────
_header(){
  clear
  printf "${PURPLE}${B}"
  printf "  ╭──────────────────────────────────────────────────────╮\n"
  printf "  │  ✦  OpenCode Supreme Setup                   v4.0  │\n"
  printf "  │     150+ skills · 13 plugins · SDD · caveman-v4     │\n"
  printf "  ╰──────────────────────────────────────────────────────╯${R}\n"
}

# ── Progress bar ───────────────────────────────────────────────────────────
_bar(){
  local pct=$(( PHASE * 100 / TOTAL ))
  local fill=$(( pct * 22 / 100 )); local empty=$(( 22 - fill ))
  local bar=""
  for ((i=0;i<fill;i++));  do bar+="█"; done
  for ((i=0;i<empty;i++)); do bar+="░"; done
  printf "${PURPLE}${bar}${R} ${GRAY}%3d%%${R}" "$pct"
}

# ── Section header ─────────────────────────────────────────────────────────
section(){
  (( PHASE++ )) || true
  printf "\n${PURPLE}${B}  ╌╌  %-36s${R}${GRAY} [%02d/%02d]${R}  $(_bar)\n" \
    "$1" "$PHASE" "$TOTAL"
}

# ── Spinner task runner ────────────────────────────────────────────────────
SP='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'

task(){
  local label="$1"; shift
  local w=38; local tmp; tmp=$(mktemp)
  hide_cursor
  printf "    ${CYAN}⠋${R}  %-${w}s" "$label"
  "$@" >"$tmp" 2>&1 & local pid=$! i=0
  while kill -0 "$pid" 2>/dev/null; do
    printf "\r    ${CYAN}${SP:$(( i % 10 )):1}${R}  %-${w}s" "$label"
    sleep 0.07; (( i++ )) || true
  done
  wait "$pid"; local rc=$?
  cat "$tmp" >> "$LOG"; rm -f "$tmp"
  if (( rc == 0 )); then
    printf "\r    ${GREEN}✓${R}  ${WHITE}%-${w}s${R}\n" "$label"
  else
    printf "\r    ${RED}✗${R}  ${RED}%-${w}s${R}  ${GRAY}↳ %s${R}\n" "$label" "$LOG"
  fi
  show_cursor; return $rc
}
task_s(){ task "$@" || true; }  # soft: never fails script

# ── Smart prompt  [Y/n] → Enter = Y ───────────────────────────────────────
ask(){
  local q="$1" default="${2:-y}"
  local hint
  [[ "$default" == y ]] \
    && hint="${GREEN}${B}Y${R}${GRAY}/n${R}" \
    || hint="${GRAY}y/${R}${RED}${B}N${R}"
  printf "\n    ${YELLOW}?${R}  ${WHITE}%-40s${R}  ${GRAY}[${R}%b${GRAY}]${R}  " "$q" "$hint"
  local ans; IFS= read -r ans
  [[ -z "$ans" ]] && ans="$default"
  [[ "$ans" =~ ^[Yy] ]]
}

# ── SETUP ──────────────────────────────────────────────────────────────────
CONF="$HOME/.config/opencode"
CONF_URL="https://raw.githubusercontent.com/skeletorflet/opencode-supreme-setup/master/config"
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd || echo "")"

_header
printf "  ${GRAY}log → %s${R}\n" "$LOG"

# ─────────────────────────────────────────────────────── [1] Prerequisites ──
section "Prerequisites"
task_s "Node.js 18+" \
  bash -c "command -v node && node --version | grep -qE 'v(1[89]|[2-9][0-9])'"
task_s "bash 4+" \
  bash -c "[[ \${BASH_VERSINFO[0]} -ge 4 ]]"

# ─────────────────────────────────────────────────────── [2] Core tools ─────
section "Core Tools"
task "opencode-ai" \
  bash -c "command -v opencode || npm install -g opencode-ai@latest"
task "bun runtime" \
  bash -c "command -v bun || { curl -fsSL https://bun.sh/install | bash && export PATH=\"\$HOME/.bun/bin:\$PATH\"; }"

# ─────────────────────────────────────────────────── [3] Provider config ────
section "Provider Subscriptions"
printf "\n    ${GRAY}Select active subscriptions  (Enter = default shown)${R}\n"
CLAUDE_F=no; OPENAI_F=no; GEMINI_F=no; COPILOT_F=no; OG_F=yes

ask "Claude Pro / Max?" n && CLAUDE_F=yes || CLAUDE_F=no
ask "ChatGPT Plus?"     n && OPENAI_F=yes || OPENAI_F=no
ask "Gemini?"           n && GEMINI_F=yes || GEMINI_F=no
ask "Copilot?"         n && COPILOT_F=yes || COPILOT_F=no
ask "OpenCode Go?"      y && OG_F=yes     || OG_F=no
FLAGS="--claude=$CLAUDE_F --openai=$OPENAI_F --gemini=$GEMINI_F --copilot=$COPILOT_F --opencode-go=$OG_F"
printf "\n    ${GRAY}%s${R}\n" "$FLAGS"

# ──────────────────────────────────────────────── [4] oh-my-openagent ───────
section "oh-my-openagent"
# shellcheck disable=SC2086
task "install orchestrator" \
  bash -c "bunx oh-my-openagent install --no-tui $FLAGS --skip-auth" || \
task_s "install (fallback)" \
  bash -c "bunx oh-my-openagent install --no-tui --claude=no --gemini=no --copilot=no --opencode-go=yes --skip-auth"

# ─────────────────────────────────────────────────── [5] Config & 135 skills ──
section "Config + 135 Skills"
task "cleanup legacy jsonc" \
  bash -c "rm -f \"$CONF/opencode.jsonc\" \"$CONF/opencode.jsonc.backup-\"* && mkdir -p \"$CONF\""

if [[ -d "$REPO_DIR/config" ]]; then
  task "sync local config" bash -c "cp -r \"$REPO_DIR/config/\"* \"$CONF/\""
else
  task "opencode.json"        bash -c "curl -fsSL \"$CONF_URL/opencode.json\" -o \"$CONF/opencode.json\""
  task "oh-my-openagent.json" bash -c "curl -fsSL \"$CONF_URL/oh-my-openagent.json\" -o \"$CONF/oh-my-openagent.json\""
  task "AGENTS.md"            bash -c "curl -fsSL \"$CONF_URL/AGENTS.md\" -o \"$CONF/AGENTS.md\""
  task "135 skills (bundle)" bash -c "
    mkdir -p \"$CONF/skills\"
    curl -fsSL \"$CONF_URL/skills.tar.gz\" -o /tmp/skills.tar.gz
    tar -xzf /tmp/skills.tar.gz -C \"$CONF/skills\"
    rm -f /tmp/skills.tar.gz
  "
fi

# register oh-my-openagent in opencode.json
[[ -f "$CONF/opencode.json" ]] && python3 -c "
import json, os
p = os.path.expanduser('~/.config/opencode/opencode.json')
try:
    with open(p) as f: c = json.load(f)
    if 'oh-my-openagent' not in c.get('plugin', []):
        c.setdefault('plugin', []).insert(0, 'oh-my-openagent')
        with open(p, 'w') as f: json.dump(c, f, indent=2)
except: pass
" 2>/dev/null || true

# ────────────────────────────────────────────── [6] Model configuration ─────
section "Model Configuration"
MODEL=""; OMO="$CONF/oh-my-openagent.json"
if [[ -f "$OMO" ]]; then
  printf "\n"
  printf "    ${GRAY}1${R}  Keep defaults\n"
  printf "    ${GRAY}2${R}  DeepSeek V4 Flash  ${GRAY}(recommended)${R}\n"
  printf "    ${GRAY}3${R}  Custom model\n"
  printf "\n    ${YELLOW}?${R}  ${WHITE}Choose${R}  ${GRAY}[${R}${GREEN}${B}1${R}${GRAY}/2/3]${R}  "
  read -r mc; [[ -z "$mc" ]] && mc=1
  case "$mc" in
    2) MODEL="opencode-go/deepseek-v4-flash" ;;
    3) printf "    ${WHITE}Model ID:${R} "; read -r MODEL ;;
  esac
  [[ -n "$MODEL" ]] && printf "    ${GRAY}→ %s${R}\n" "$MODEL"

  task_s "tmux compatibility" bash -c "
    python3 -c \"
import json, shutil
p = '$OMO'
with open(p) as f: c=json.load(f)
if not shutil.which('tmux'): c.setdefault('tmux',{})['enabled']=False
with open(p,'w') as f: json.dump(c,f,indent=2)
\"
  "
  if [[ -n "$MODEL" ]]; then
    task_s "apply model overrides" bash -c "
      python3 -c \"
import json
p = '$OMO'
with open(p) as f: c=json.load(f)
merged = {**c.get('agents',{}), **c.get('categories',{})}
for k in merged:
    for sect in ('agents','categories'):
        if k in c.get(sect,{}):
            c[sect][k]['model'] = '$MODEL'
            c[sect][k].pop('fallback_models', None)
with open(p,'w') as f: json.dump(c,f,indent=2)
\"
    "
  fi
fi

# ─────────────────────────────────────────────────── [7] Developer tools ────
section "Developer Tools"
task_s "comment-checker" npm install -g @code-yeongyu/comment-checker
task_s "ast-grep"        npm install -g @ast-grep/cli
task_s "GitHub CLI"      bash -c "
  command -v gh && true ||
  { command -v brew && brew install gh; } ||
  { command -v apt  && sudo apt install -y gh 2>/dev/null; } || true"

# ────────────────────────────────────────────── [8] Plugins  (10 total) ─────
section "Plugins  (10)"
PKGS=(
  "opencode-snippets|#snippet text expansion"
  "opencode-snip|snip  60–90% token savings"
  "opencode-notify|OS notifications"
  "opencode-mem|persistent vector memory"
  "opencode-quota|token + cost tracking"
  "opencode-background-agents|async agent delegation"
  "opencode-worktree|isolated git worktrees"
  "opencode-dynamic-context-pruning|auto context pruning"
  "opencode-smart-title|smart session titles"
  "ocwatch|visual dashboard  :3000"
)
for entry in "${PKGS[@]}"; do
  pkg="${entry%%|*}"; label="${entry##*|}"
  task_s "$label" npm install -g "$pkg"
done

[[ -f "$CONF/opencode.json" ]] && python3 -c "
import json, os
p = os.path.expanduser('~/.config/opencode/opencode.json')
pkgs = ['opencode-snippets','opencode-snip','opencode-notify','opencode-mem',
        'opencode-quota','opencode-background-agents','opencode-worktree',
        'opencode-dynamic-context-pruning','opencode-smart-title','ocwatch']
try:
    with open(p) as f: c = json.load(f)
    existing = set(c.get('plugin', []))
    for pkg in pkgs:
        if pkg not in existing: c.setdefault('plugin',[]).append(pkg)
    with open(p,'w') as f: json.dump(c, f, indent=2)
except: pass
" 2>/dev/null || true

# ──────────────────────────────────────── [9] OpenSkills  (100+ skills) ─────
section "OpenSkills  (100+)"
task_s "anthropics/skills"  npx openskills install anthropics/skills -y
task_s "mattpocock/skills"           npx openskills install mattpocock/skills -y
task_s "JuliusBrussee/caveman"       npx openskills install JuliusBrussee/caveman -y
task_s "safishamsi/graphify"         npx openskills install safishamsi/graphify -y
task_s "nexu-io/open-design"         npx openskills install nexu-io/open-design -y
task_s "nextlevelbuilder/ui-ux-pro-max-skill" npx openskills install nextlevelbuilder/ui-ux-pro-max-skill -y
task_s "openskills CLI"     npm install -g openskills
task_s "sync to AGENTS.md"  bash -c "npx openskills sync -y -o \"$CONF/AGENTS.md\""

# ──────────────────────────────────────────────── [10] Optional extras ───────
section "Optional Extras"
if ask "agentsys  (49 agents, 20 plugins)"; then
  task_s "agentsys" npm install -g agentsys
fi
if ask "supermemory"; then
  task_s "supermemory" bash -c "bunx opencode-supermemory@latest install --no-tui"
fi
if ask "firecrawl"; then
  task_s "firecrawl" bash -c \
    "npm install -g firecrawl-cli 2>/dev/null || npm install -g @firecrawl/firecrawl-cli"
fi
if ask "WakaTime"; then
  task_s "wakatime" npm install -g opencode-wakatime
fi
if ask "Themes  (ayu · lavi · moonlight · poimandres)"; then
  for t in opencode-ayu-theme lavi opencode-moonlight-theme opencode-ai-poimandres-theme; do
    task_s "$t" npm install -g "$t"
  done
fi

# ── Verify ─────────────────────────────────────────────────────────────────
printf "\n    ${DIM}verifying…${R}\n"
task_s "oh-my-openagent doctor" bunx oh-my-openagent doctor

# ── Summary ────────────────────────────────────────────────────────────────
printf "\n"
printf "${GREEN}${B}"
printf "  ╭──────────────────────────────────────────────────────╮\n"
printf "  │  ✦  Setup Complete!                                  │\n"
printf "  ╰──────────────────────────────────────────────────────╯${R}\n"
printf "\n"
printf "  ${CYAN}%-22s${R}${GRAY}→${R}  %s\n" \
  "opencode"         "launch" \
  "ocwatch"          "visual dashboard  :3000" \
  "ulw <task>"       "ultrawork (parallel agents)" \
  "@spec-architect"  "spec-driven development" \
  "@self-healer"     "autonomous debugging" \
  "@refactor"        "clean code"
printf "\n"
printf "  ${YELLOW}${B}opencode auth login${R}  ${GRAY}← run this first${R}\n"
printf "  ${GRAY}log → %s${R}\n" "$LOG"
printf "  ${GRAY}★   https://github.com/skeletorflet/opencode-supreme-setup${R}\n\n"
