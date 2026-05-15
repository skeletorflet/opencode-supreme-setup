#!/usr/bin/env bash
# OpenCode Supreme Setup — Uninstaller v1
# Compatible with: curl -fsSL https://raw.githubusercontent.com/skeletorflet/opencode-supreme-setup/master/uninstall.sh | bash
# shellcheck disable=SC2034,SC2317
set -o pipefail

# ── Colors ────────────────────────────────────────────────────────────────────
NeonPink='\033[38;5;198m'
NeonCyan='\033[38;5;51m'
NeonGreen='\033[38;5;46m'
NeonRed='\033[38;5;196m'
DarkGray='\033[38;5;238m'
MedGray='\033[38;5;244m'
White='\033[38;5;231m'
Yellow='\033[38;5;226m'
Reset='\033[0m'
Bold='\033[1m'

CONF="$HOME/.config/opencode"

# ── Helpers ────────────────────────────────────────────────────────────────────
step_ok()   { printf "  ${NeonGreen}✔${Reset} ${White}%-40s${Reset}${DarkGray}%s${Reset}\n" "$1" "$2"; }
step_fail() { printf "  ${NeonRed}✖${Reset} ${White}%-40s${Reset}${NeonRed}%s${Reset}\n" "$1" "$2"; }
step_skip() { printf "  ${DarkGray}·${Reset} ${White}%-40s${Reset}${DarkGray}%s${Reset}\n" "$1" "$2"; }

remove_npm() {
  local pkg="$1"
  if npm uninstall -g "$pkg" >/dev/null 2>&1; then
    step_ok "$pkg" "removed"
  else
    step_skip "$pkg" "not found / skipped"
  fi
}

ask() {
  local q="$1" default="${2:-n}"
  local yn
  [[ "$default" == y ]] && yn="${NeonGreen}Y${Reset}${DarkGray}/n${Reset}" || yn="${DarkGray}y/${Reset}${NeonGreen}N${Reset}"
  printf "  ${NeonPink}?${Reset} %-28s ${DarkGray}[${Reset}%b${DarkGray}]${Reset} > " "$q" "$yn"
  local ans
  IFS= read -r ans
  [[ -z "$ans" ]] && ans="$default"
  [[ "$ans" =~ ^[Yy] ]]
}

# ── All packages installed by the setup ───────────────────────────────────────
NPM_PACKAGES=(
  "opencode-ai"
  "bun"
  "opencode-snippets"
  "opencode-snip"
  "opencode-notify"
  "opencode-mem"
  "opencode-quota"
  "opencode-background-agents"
  "opencode-worktree"
  "opencode-dynamic-context-pruning"
  "opencode-smart-title"
  "ocwatch"
  "openskills"
  "@code-yeongyu/comment-checker"
  "@ast-grep/cli"
  "agentsys"
  "firecrawl-cli"
  "opencode-wakatime"
  "opencode-ayu-theme"
  "lavi"
  "opencode-moonlight-theme"
  "opencode-ai-poimandres-theme"
  "agentation-mcp"
)

# ── Header ────────────────────────────────────────────────────────────────────
clear
printf "\n"
W=$(tput cols 2>/dev/null || echo 70)
BORDER=$(printf '═%.0s' $(seq 1 $(( W - 4 ))))
printf "  ${NeonPink}╔%s╗${Reset}\n" "$BORDER"
printf "  ${NeonPink}║${Reset} ${Bold}${NeonPink}◈ OPENCODE SUPREME SETUP${Reset}  ${DarkGray}│${Reset}  ${NeonRed}${Bold}UNINSTALLER${Reset}%*s${NeonPink}║${Reset}\n" \
  "$(( W - 4 - 48 ))" ""
printf "  ${NeonPink}╚%s╝${Reset}\n" "$BORDER"
printf "\n"
printf "  ${NeonRed}This will remove ALL packages and config installed by the setup.${Reset}\n"
printf "  ${DarkGray}Config dir: %s${Reset}\n\n" "$CONF"

# ── Confirmation ──────────────────────────────────────────────────────────────
if ! ask "Are you sure" n; then
  printf "\n  ${DarkGray}Aborted. Nothing was changed.${Reset}\n\n"
  exit 0
fi
printf "\n"

# ── Step 1: npm packages ──────────────────────────────────────────────────────
printf "  ${NeonCyan}── npm packages %s${Reset}\n" "$(printf '─%.0s' {1..41})"
for pkg in "${NPM_PACKAGES[@]}"; do
  remove_npm "$pkg"
done

# ── Step 2: bun runtime (native installer) ────────────────────────────────────
printf "\n  ${NeonCyan}── bun runtime %s${Reset}\n" "$(printf '─%.0s' {1..42})"
BUN_DIR="$HOME/.bun"
if [[ -d "$BUN_DIR" ]]; then
  if rm -rf "$BUN_DIR" 2>/dev/null; then
    step_ok "~/.bun directory" "removed"
  else
    step_fail "~/.bun directory" "permission error"
  fi
else
  step_skip "~/.bun directory" "not found"
fi

# Remove bun PATH lines from shell profiles
for profile in "$HOME/.bashrc" "$HOME/.zshrc" "$HOME/.bash_profile" "$HOME/.profile"; do
  if [[ -f "$profile" ]] && grep -q '\.bun' "$profile" 2>/dev/null; then
    sed -i '/\.bun/d' "$profile" 2>/dev/null && step_ok "Removed bun from $profile" ""
  fi
done

# ── Step 3: oh-my-openagent ───────────────────────────────────────────────────
printf "\n  ${NeonCyan}── oh-my-openagent %s${Reset}\n" "$(printf '─%.0s' {1..38})"
if command -v bunx &>/dev/null; then
  if bunx oh-my-openagent uninstall --force >/dev/null 2>&1; then
    step_ok "oh-my-openagent" "uninstalled via bunx"
  else
    remove_npm "oh-my-openagent"
  fi
else
  remove_npm "oh-my-openagent"
fi

# ── Step 4: Config directory ──────────────────────────────────────────────────
printf "\n  ${NeonCyan}── config & skills %s${Reset}\n" "$(printf '─%.0s' {1..38})"
if ask "Remove ~/.config/opencode" y; then
  if [[ -d "$CONF" ]]; then
    if rm -rf "$CONF" 2>/dev/null; then
      step_ok "$CONF" "removed"
    else
      step_fail "$CONF" "permission error — try: sudo rm -rf $CONF"
    fi
  else
    step_skip "$CONF" "not found"
  fi
else
  step_skip "Config dir kept" "skipped by user"
fi

# ── Step 5: XDG / local state (opencode may write here) ─────────────────────
for extra in \
  "$HOME/.local/share/opencode" \
  "$HOME/.local/state/opencode" \
  "$HOME/.cache/opencode"; do
  if [[ -d "$extra" ]]; then
    rm -rf "$extra" 2>/dev/null && step_ok "$extra" "removed"
  fi
done

# ── Step 6: log files ─────────────────────────────────────────────────────────
printf "\n  ${NeonCyan}── cleanup logs %s${Reset}\n" "$(printf '─%.0s' {1..41})"
LOG_COUNT=$(find /tmp -maxdepth 1 -name 'oc_setup_*.log' 2>/dev/null | wc -l)
if [[ "$LOG_COUNT" -gt 0 ]]; then
  find /tmp -maxdepth 1 -name 'oc_setup_*.log' -delete 2>/dev/null
  step_ok "$LOG_COUNT install log(s)" "removed from /tmp"
else
  step_skip "install logs" "none found"
fi

# ── Done ──────────────────────────────────────────────────────────────────────
printf "\n  ${NeonGreen}${Bold}UNINSTALL COMPLETE${Reset}\n"
printf "  ${DarkGray}%s${Reset}\n" "$(printf '─%.0s' {1..50})"
printf "  ${DarkGray}opencode and all supreme setup components have been removed.${Reset}\n"
printf "  ${DarkGray}Restart your terminal to clear any stale PATH entries.${Reset}\n\n"
