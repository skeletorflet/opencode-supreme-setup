#!/usr/bin/env bash
# OpenCode Supreme Setup - Linux/macOS Bash Installer
set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config/opencode"
CONFIG_URL="https://raw.githubusercontent.com/skeletorflet/opencode-supreme-setup/master/config"

GREEN='\033[0;32m'; CYAN='\033[0;36m'; YELLOW='\033[1;33m'; WHITE='\033[1;37m'; NC='\033[0m'
step()  { echo -e "\n${CYAN}[STEP]${NC} $1"; }
ok()    { echo -e "  ${GREEN}[OK]${NC} $1"; }
warn()  { echo -e "  ${YELLOW}[!]${NC} $1"; }
info()  { echo -e "  [i] $1"; }
yn()    { read -p "$1 (y/n): " r; [ "$r" = "y" ] || [ "$r" = "yes" ]; }

clear
echo -e "${CYAN}======================================"
echo -e "  OpenCode Supreme Setup"
echo -e "  oh-my-openagent + Caveman + DeepSeek"
echo -e "======================================${NC}"

# Step 0: Check Node.js
step "Checking Node.js..."
if command -v node &>/dev/null; then
  ok "Node.js $(node --version)"
else
  warn "Node.js not found. Install 18+ LTS from https://nodejs.org"
  exit 1
fi

# Step 1: Install OpenCode
step "Checking OpenCode..."
if command -v opencode &>/dev/null; then
  ok "OpenCode $(opencode --version)"
else
  warn "Installing OpenCode..."
  curl -fsSL https://opencode.ai/install | bash
  command -v opencode &>/dev/null && ok "OpenCode installed" || warn "Install failed: https://opencode.ai/docs"
fi

# Step 2: Install Bun
step "Checking Bun..."
if command -v bun &>/dev/null; then
  ok "Bun $(bun --version)"
else
  warn "Installing Bun..."
  curl -fsSL https://bun.sh/install | bash
  export PATH="$HOME/.bun/bin:$PATH"
  command -v bun &>/dev/null && ok "Bun installed" || warn "Bun install failed"
fi

# Step 3: Subscription questions
step "Subscription configuration"
read -p "Do you have Claude Pro/Max? (y/n/max20): " r
case "$r" in y|yes) CLAUDE="--claude=yes" ;; max20) CLAUDE="--claude=max20" ;; *) CLAUDE="--claude=no" ;; esac
read -p "ChatGPT Plus? (y/n): " r; [[ "$r" =~ ^(y|yes)$ ]] && OPENAI="--openai=yes" || OPENAI="--openai=no"
read -p "Integrate Gemini? (y/n): " r; [[ "$r" =~ ^(y|yes)$ ]] && GEMINI="--gemini=yes" || GEMINI="--gemini=no"
read -p "GitHub Copilot? (y/n): " r; [[ "$r" =~ ^(y|yes)$ ]] && COPILOT="--copilot=yes" || COPILOT="--copilot=no"
read -p "OpenCode Go (\$10/mo)? (y/n): " r; [[ "$r" =~ ^(y|yes)$ ]] && OPENCODE_GO="--opencode-go=yes" || OPENCODE_GO="--opencode-go=no"
info "Flags: $CLAUDE $OPENAI $GEMINI $COPILOT $OPENCODE_GO"

# Step 4: Install oh-my-openagent
step "Installing oh-my-openagent..."
bunx oh-my-openagent install --no-tui $CLAUDE $OPENAI $GEMINI $COPILOT $OPENCODE_GO --skip-auth 2>&1 || {
  warn "First attempt failed, retrying fallback..."
  bunx oh-my-openagent install --no-tui --claude=no --openai=no --gemini=no --copilot=no --opencode-go=yes --skip-auth 2>&1
}
ok "oh-my-openagent installed"

# Step 5: Register plugin in opencode.json
step "Registering plugin..."
OC_CONFIG="$CONFIG_DIR/opencode.json"
if [ -f "$OC_CONFIG" ]; then
  if ! grep -q '"oh-my-openagent"' "$OC_CONFIG" 2>/dev/null; then
    python3 -c "
import json
with open('$OC_CONFIG') as f: c = json.load(f)
if 'oh-my-openagent' not in c.get('plugin', []):
  c.setdefault('plugin', []).append('oh-my-openagent')
with open('$OC_CONFIG', 'w') as f: json.dump(c, f, indent=2)
" 2>/dev/null && ok "Plugin registered" || warn "Could not auto-register plugin"
  else
    ok "Already registered"
  fi
fi

# Step 6: Copy config files
step "Copying configuration files..."
mkdir -p "$CONFIG_DIR"
if [ -d "$REPO_DIR/config" ]; then
  cp -r "$REPO_DIR/config/"* "$CONFIG_DIR/"
  ok "Config files copied from local repo"
else
  info "Downloading config files from GitHub..."
  for f in opencode.json oh-my-openagent.json AGENTS.md; do
    curl -fsSL "$CONFIG_URL/$f" -o "$CONFIG_DIR/$f" && ok "Downloaded $f" || warn "Failed $f"
  done
  info "Downloading skills..."
  SKILLS=$(curl -fsSL "$CONFIG_URL/skills.txt" 2>/dev/null || echo "")
  for s in $SKILLS; do
    mkdir -p "$CONFIG_DIR/skills/$s"
    curl -fsSL "$CONFIG_URL/skills/$s/SKILL.md" -o "$CONFIG_DIR/skills/$s/SKILL.md" 2>/dev/null && ok "  skill: $s"
  done
fi

# Step 7: Fix oh-my-openagent.json
step "Optimizing config..."
OMO_CONFIG="$CONFIG_DIR/oh-my-openagent.json"
if [ -f "$OMO_CONFIG" ]; then
  python3 -c "
import json, sys, platform
with open('$OMO_CONFIG') as f: c = json.load(f)
# Disable tmux on non-macOS/Linux or if tmux not found
if platform.system() == 'Windows' or not __import__('shutil').which('tmux'):
  c.get('tmux', {})['enabled'] = False
# Deepset model on all agents and categories
for k, v in c.get('agents', {}).items():
  v['model'] = 'opencode-go/deepseek-v4-flash'
  v.pop('fallback_models', None)
for k, v in c.get('categories', {}).items():
  v['model'] = 'opencode-go/deepseek-v4-flash'
  v.pop('fallback_models', None)
with open('$OMO_CONFIG', 'w') as f: json.dump(c, f, indent=2)
" 2>/dev/null && ok "Config optimized" || warn "Config optimization skipped"
fi

# Step 8: Install comment-checker
step "Installing comment-checker..."
bunx @code-yeongyu/comment-checker --version 2>/dev/null && ok "Comment checker available" || {
  npm install -g @code-yeongyu/comment-checker 2>/dev/null && ok "Comment checker installed" || warn "Comment checker skipped"
}

# Step 9: Install GitHub CLI
step "Checking GitHub CLI..."
if command -v gh &>/dev/null; then
  ok "gh $(gh --version | head -1)"
elif command -v brew &>/dev/null; then
  brew install gh 2>/dev/null && ok "gh installed via brew" || warn "gh install failed"
elif command -v apt &>/dev/null; then
  sudo apt install -y gh 2>/dev/null && ok "gh installed" || warn "gh install failed"
else
  warn "Install gh manually: https://cli.github.com/"
fi

# Step 10: Optional plugins
step "Optional plugins"
yn "Install opencode-supermemory (persistent memory)?" && {
  bunx opencode-supermemory@latest install --no-tui 2>&1 && ok "Supermemory installed" || warn "Supermemory failed"
}
yn "Install firecrawl (web scraping)?" && {
  npm install -g firecrawl-cli 2>&1 && ok "Firecrawl installed" || {
    npm install -g @firecrawl/firecrawl-cli 2>&1 && ok "Firecrawl installed (@firecrawl)" || warn "Firecrawl failed"
  }
}

# Step 11: Verify
step "Verifying setup..."
bunx oh-my-openagent doctor 2>&1 || true

# Step 12: Auth guidance
step "Authentication"
echo -e "\n${YELLOW}Authenticate your providers when ready:${NC}\n"
[ "$OPENCODE_GO" != "--opencode-go=no" ] && echo -e "  ${WHITE}opencode auth login${NC}"
[ "$CLAUDE" != "--claude=no" ] && echo -e "  ${WHITE}opencode auth login${NC}"
[ "$OPENAI" != "--openai=no" ] && echo -e "  ${WHITE}opencode auth login${NC}"

echo -e "\n${CYAN}======================================"
echo -e "  ${GREEN}Setup complete!${NC}"
echo -e "${CYAN}======================================${NC}"
echo -e "\n${CYAN}Quick start:${NC}"
echo -e "  ${WHITE}1. opencode              # Launch${NC}"
echo -e "  ${WHITE}2. ulw your task         # Ultrawork mode${NC}"
echo -e "  ${WHITE}3. Tab to cycle agents${NC}"
echo -e "  ${WHITE}4. @security-auditor     # Security audit${NC}"
echo -e "  ${WHITE}5. @refactor <files>     # Refactor${NC}"
echo -e "  ${WHITE}6. @docs-writer          # Docs${NC}"
echo -e "  ${YELLOW}Star if helpful!${NC}"
