#!/usr/bin/env bash
# OpenCode Supreme Setup - Linux/macOS Bash Installer
set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config/opencode"

GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
WHITE='\033[1;37m'
NC='\033[0m'

step()  { echo -e "\n${CYAN}[STEP]${NC} $1"; }
ok()    { echo -e "  ${GREEN}[OK]${NC} $1"; }
warn()  { echo -e "  ${YELLOW}[!]${NC} $1"; }
info()  { echo -e "  [i] $1"; }

clear
echo -e "${CYAN}======================================"
echo -e "  OpenCode Supreme Setup"
echo -e "  oh-my-openagent + Caveman + DeepSeek"
echo -e "======================================${NC}"

# Step 0: Check OpenCode
step "Checking OpenCode installation..."
if command -v opencode &>/dev/null; then
    ok "OpenCode $(opencode --version) is installed"
else
    warn "OpenCode not found. Installing..."
    curl -fsSL https://opencode.ai/install | bash
    ok "OpenCode installed (restart shell if needed)"
fi

# Step 1: Check Bun
step "Checking Bun..."
if command -v bun &>/dev/null; then
    ok "Bun $(bun --version) is installed"
else
    warn "Bun not found. Installing..."
    curl -fsSL https://bun.sh/install | bash
    export PATH="$HOME/.bun/bin:$PATH"
    ok "Bun installed"
fi

# Step 2: Ask subscription questions
step "Subscription configuration"

read -p "Do you have Claude Pro/Max? (y/n/max20): " input
case "$input" in
    y|yes) CLAUDE="--claude=yes" ;;
    max20) CLAUDE="--claude=max20" ;;
    *)     CLAUDE="--claude=no" ;;
esac

read -p "ChatGPT Plus subscription? (y/n): " input
case "$input" in y|yes) OPENAI="--openai=yes" ;; *) OPENAI="--openai=no" ;; esac

read -p "Integrate Gemini models? (y/n): " input
case "$input" in y|yes) GEMINI="--gemini=yes" ;; *) GEMINI="--gemini=no" ;; esac

read -p "GitHub Copilot subscription? (y/n): " input
case "$input" in y|yes) COPILOT="--copilot=yes" ;; *) COPILOT="--copilot=no" ;; esac

read -p "OpenCode Go subscription (\$10/mo)? (y/n): " input
case "$input" in y|yes) OPENCODE_GO="--opencode-go=yes" ;; *) OPENCODE_GO="--opencode-go=no" ;; esac

info "Flags: $CLAUDE $OPENAI $GEMINI $COPILOT $OPENCODE_GO"

# Step 3: Install oh-my-openagent
step "Installing oh-my-openagent..."
bunx oh-my-openagent install --no-tui $CLAUDE $OPENAI $GEMINI $COPILOT $OPENCODE_GO --skip-auth 2>&1 || {
    warn "First attempt failed, retrying with fallback..."
    bunx oh-my-openagent install --no-tui --claude=no --openai=no --gemini=no --copilot=no --opencode-go=yes --skip-auth 2>&1
}
ok "oh-my-openagent installed"

# Step 4: Copy config files
step "Copying configuration files..."
mkdir -p "$CONFIG_DIR"
if [ -d "$REPO_DIR/config" ]; then
    cp -r "$REPO_DIR/config/"* "$CONFIG_DIR/"
    ok "Config files copied to $CONFIG_DIR"
else
    warn "No config/ directory found"
fi

# Step 5: Set deepseek-v4-flash on ALL agents
step "Setting all agents to deepseek-v4-flash..."
OMO_CONFIG="$CONFIG_DIR/oh-my-openagent.json"
if [ -f "$OMO_CONFIG" ]; then
    # Remove all fallback_models from agents and categories
    python3 -c "
import json
with open('$OMO_CONFIG', 'r') as f:
    c = json.load(f)
for k, v in c.get('agents', {}).items():
    v['model'] = 'opencode-go/deepseek-v4-flash'
    v.pop('fallback_models', None)
for k, v in c.get('categories', {}).items():
    v['model'] = 'opencode-go/deepseek-v4-flash'
    v.pop('fallback_models', None)
with open('$OMO_CONFIG', 'w') as f:
    json.dump(c, f, indent=2)
" 2>/dev/null || {
    # Fallback: use sed
    warn "python3 not available, manual config edit may be needed"
}
    ok "All agents set to opencode-go/deepseek-v4-flash"
fi

# Step 6: Optional plugins
step "Optional plugins"
read -p "Install opencode-supermemory (persistent memory)? (y/n): " input
if [ "$input" = "y" ] || [ "$input" = "yes" ]; then
    bunx opencode-supermemory@latest install --no-tui 2>&1 && ok "Supermemory installed" || warn "Supermemory failed"
fi

read -p "Install firecrawl (web scraping)? (y/n): " input
if [ "$input" = "y" ] || [ "$input" = "yes" ]; then
    npm install -g firecrawl-cli 2>&1 && ok "Firecrawl CLI installed" || warn "Firecrawl failed"
fi

# Step 7: Verify
step "Verifying setup..."
bunx oh-my-openagent doctor 2>&1 || true

# Step 8: Auth guidance
step "Authentication"
echo -e "\n${YELLOW}Authenticate your providers when ready:${NC}\n"
[ "$CLAUDE" != "--claude=no" ] && echo -e "  ${WHITE}opencode auth login  -> Select Anthropic -> OAuth${NC}"
[ "$OPENAI" != "--openai=no" ] && echo -e "  ${WHITE}opencode auth login  -> Select OpenAI -> Paste API key${NC}"
[ "$GEMINI" != "--gemini=no" ] && echo -e "  ${WHITE}opencode auth login  -> Select Google -> OAuth${NC}"
[ "$OPENCODE_GO" != "--opencode-go=no" ] && echo -e "  ${WHITE}opencode auth login  -> Select OpenCode Go -> Paste API key${NC}"

echo -e "\n${CYAN}======================================"
echo -e "  ${GREEN}Setup complete!${NC}"
echo -e "${CYAN}======================================${NC}"
echo -e "\n${CYAN}Quick start:${NC}"
echo -e "  ${WHITE}1. opencode                  # Launch${NC}"
echo -e "  ${WHITE}2. ulw <your task>           # Ultrawork mode${NC}"
echo -e "  ${WHITE}3. Tab to cycle agents${NC}"
echo -e "  ${WHITE}4. @security-auditor         # Security audit${NC}"
echo -e "  ${WHITE}5. @refactor <files>         # Refactor${NC}"
echo -e "  ${YELLOW}If helpful, star the repo!${NC}"
