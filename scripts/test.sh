#!/usr/bin/env bash
# Comprehensive validation test suite for opencode-supreme-setup (bash/CI version).
# Usage: bash scripts/test.sh [--format text|json] [--strict] [--min-count N]
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Parse args
FORMAT="${FORMAT:-text}"
STRICT=false
MIN_COUNT=50
while [[ $# -gt 0 ]]; do
  case "$1" in
    --format) FORMAT="${2:-text}"; shift 2 ;;
    --format=*) FORMAT="${1#--format=}"; shift ;;
    --strict) STRICT=true; shift ;;
    --min-count) MIN_COUNT="${2:-50}"; shift 2 ;;
    --min-count=*) MIN_COUNT="${1#--min-count=}"; shift ;;
    *) shift ;;
  esac
done

PASSED=0
FAILED=0
RESULTS=()

# ── Helpers ──────────────────────────────────────────────────────────────

pass() { local cat="$1" test="$2"; ((PASSED++)); RESULTS+=("{\"category\":\"$cat\",\"test\":\"$test\",\"status\":\"pass\",\"detail\":\"\"}"); }
fail() { local cat="$1" test="$2" detail="${3:-}"; ((FAILED++)); RESULTS+=("{\"category\":\"$cat\",\"test\":\"$test\",\"status\":\"fail\",\"detail\":\"$detail\"}"); }

print_header() {
  [[ "$FORMAT" == "text" ]] || return 0
  echo ""
  echo "=== $1 ==="
}

# JSON parsing helpers (try node first, fall back to python3, then grep)
json_has_keys() {
  local file="$1" key
  shift
  if command -v node &>/dev/null; then
    for key in "$@"; do
      node -e "const c=require('$file'); if(!c['$key']) process.exit(1)" 2>/dev/null || return 1
    done
  elif command -v python3 &>/dev/null; then
    python3 -c "
import sys,json
c=json.load(open('$file'))
for k in ${@@Q}:
  if k not in c:
    sys.exit(1)
" 2>/dev/null || return 1
  else
    # grep-based fallback - check if key appears before next top-level key
    for key in "$@"; do
      grep -q "\"$key\":" "$file" || return 1
    done
  fi
  return 0
}

json_is_valid() {
  if command -v node &>/dev/null; then
    node -e "JSON.parse(require('fs').readFileSync('$1','utf8'))" 2>/dev/null
  elif command -v python3 &>/dev/null; then
    python3 -c "import json; json.load(open('$1'))" 2>/dev/null
  else
    return 0 # skip if no parser
  fi
}

count_skills() {
  local d="$PROJECT_ROOT/config/skills"
  [[ -d "$d" ]] || { echo 0; return; }
  local count=0
  for dir in "$d"/*/; do
    local name
    name=$(basename "$dir")
    [[ "$name" == _* ]] && continue
    [[ -f "$dir/SKILL.md" ]] || continue
    ((count++))
  done
  echo "$count"
}

# ═══════════════════════════════════════════════════════════════════════
# Category 1: Config Validates
# ═══════════════════════════════════════════════════════════════════════
print_header "Config Validates"
CAT="Config Validates"

# 1.1 opencode.json
OC="$PROJECT_ROOT/config/opencode.json"
if [[ -f "$OC" ]]; then
  pass "$CAT" "opencode.json exists"
  if json_is_valid "$OC"; then
    pass "$CAT" "opencode.json is valid JSON"
    if json_has_keys "$OC" model default_agent plugin agent skills; then
      pass "$CAT" "opencode.json has required keys"
    else
      fail "$CAT" "opencode.json has required keys" "missing one or more: model, default_agent, plugin, agent, skills"
    fi
  else
    fail "$CAT" "opencode.json is valid JSON"
    fail "$CAT" "opencode.json has required keys" "not valid JSON"
  fi
else
  fail "$CAT" "opencode.json exists" "file not found"
  fail "$CAT" "opencode.json is valid JSON" "file not found"
  fail "$CAT" "opencode.json has required keys" "file not found"
fi

# 1.2 oh-my-openagent.json
OH="$PROJECT_ROOT/config/oh-my-openagent.json"
if [[ -f "$OH" ]]; then
  pass "$CAT" "oh-my-openagent.json exists"
  if json_is_valid "$OH"; then
    pass "$CAT" "oh-my-openagent.json is valid JSON"
    if json_has_keys "$OH" agents categories team_mode background_task; then
      pass "$CAT" "oh-my-openagent.json has required keys"
    else
      fail "$CAT" "oh-my-openagent.json has required keys" "missing one or more: agents, categories, team_mode, background_task"
    fi
  else
    fail "$CAT" "oh-my-openagent.json is valid JSON"
    fail "$CAT" "oh-my-openagent.json has required keys" "not valid JSON"
  fi
else
  fail "$CAT" "oh-my-openagent.json exists" "file not found"
  fail "$CAT" "oh-my-openagent.json is valid JSON" "file not found"
  fail "$CAT" "oh-my-openagent.json has required keys" "file not found"
fi

# 1.3 AGENTS.md
AGENTS="$PROJECT_ROOT/config/AGENTS.md"
if [[ -f "$AGENTS" ]] && [[ $(wc -l < "$AGENTS" | tr -d ' ') -gt 10 ]]; then
  pass "$CAT" "config/AGENTS.md exists and non-empty"
else
  fail "$CAT" "config/AGENTS.md exists and non-empty"
fi

# ═══════════════════════════════════════════════════════════════════════
# Category 2: Cross-Reference Consistency
# ═══════════════════════════════════════════════════════════════════════
print_header "Cross-Reference Consistency"
CAT="Cross-Reference Consistency"

if [[ -f "$OC" ]]; then
  # Plugin duplicates (using node/python for array parsing)
  if command -v node &>/dev/null; then
    dup_plugins=$(node -e "
      const c = require('$OC');
      const p = c.plugin || [];
      const seen = new Set(); const dups = new Set();
      p.forEach(x => seen.has(x) ? dups.add(x) : seen.add(x));
      console.log(JSON.stringify([...dups]));
    " 2>/dev/null)
    if [[ "$dup_plugins" == "[]" ]] || [[ -z "$dup_plugins" ]]; then
      pass "$CAT" "No duplicate plugin entries"
    else
      fail "$CAT" "No duplicate plugin entries" "duplicates: $dup_plugins"
    fi

    # Agent completeness
    bad_agents=$(node -e "
      const c = require('$OC');
      const a = c.agent || {};
      const bad = Object.keys(a).filter(k => !a[k].mode || !a[k].description || !a[k].model || !a[k].prompt);
      console.log(JSON.stringify(bad));
    " 2>/dev/null)
    if [[ "$bad_agents" == "[]" ]] || [[ -z "$bad_agents" ]]; then
      pass "$CAT" "All agents have mode/description/model/prompt"
    else
      fail "$CAT" "All agents have mode/description/model/prompt" "incomplete: $bad_agents"
    fi
  else
    # Skip if no node available
    :
  fi
fi

if [[ -f "$OH" ]] && command -v node &>/dev/null; then
  no_model=$(node -e "
    const c = require('$OH');
    const a = c.agents || {};
    const bad = Object.keys(a).filter(k => !a[k].model);
    console.log(JSON.stringify(bad));
  " 2>/dev/null)
  if [[ "$no_model" == "[]" ]] || [[ -z "$no_model" ]]; then
    pass "$CAT" "All oh-my-openagent agents have model"
  else
    fail "$CAT" "All oh-my-openagent agents have model" "no model: $no_model"
  fi
fi

# ═══════════════════════════════════════════════════════════════════════
# Category 3: Skills Ecosystem
# ═══════════════════════════════════════════════════════════════════════
print_header "Skills Ecosystem"
CAT="Skills Ecosystem"

SD="$PROJECT_ROOT/config/skills"
if [[ -d "$SD" ]]; then
  pass "$CAT" "config/skills/ directory exists"

  SKILL_COUNT=$(count_skills)
  if [[ "$SKILL_COUNT" -ge "$MIN_COUNT" ]]; then
    pass "$CAT" "Skills count: $SKILL_COUNT" "minimum: $MIN_COUNT"
  else
    fail "$CAT" "Skills count: $SKILL_COUNT" "minimum: $MIN_COUNT"
  fi

  MISSING_MD=()
  BAD_FM=()
  BAD_DESC=()

  for dir in "$SD"/*/; do
    name=$(basename "$dir")
    [[ "$name" == _* ]] && continue
    local_md="$dir/SKILL.md"

    if [[ ! -f "$local_md" ]]; then
      MISSING_MD+=("$name")
      continue
    fi

    first_line=$(head -1 "$local_md" | LC_ALL=C sed 's/^\xEF\xBB\xBF//' | tr -d '\r')
    [[ "$first_line" != "---" ]] && BAD_FM+=("$name")

    grep -Eq '^description:\s*.+' "$local_md" 2>/dev/null || BAD_DESC+=("$name")

    if $STRICT; then
      # body length
      body=$(sed -n '/^---/,/^---/!p' "$local_md" | sed '/^\s*$/d' | wc -l | tr -d ' ')
      [[ "$body" -lt 10 ]] && SHORT_BODY+=("$name ($body lines)")
      # description quality
      desc=$(grep -E '^description:' "$local_md" 2>/dev/null | head -1 | sed 's/^description:\s*//')
      [[ ${#desc} -lt 20 ]] && SHORT_DESC+=("$name (${#desc} chars)")
    fi
  done

  [[ ${#MISSING_MD[@]} -eq 0 ]] && pass "$CAT" "All skill dirs have SKILL.md" \
    || fail "$CAT" "All skill dirs have SKILL.md" "missing: ${MISSING_MD[*]}"
  [[ ${#BAD_FM[@]} -eq 0 ]] && pass "$CAT" "All SKILL.md have frontmatter (---)" \
    || fail "$CAT" "All SKILL.md have frontmatter (---)" "bad: ${BAD_FM[*]}"
  [[ ${#BAD_DESC[@]} -eq 0 ]] && pass "$CAT" "All SKILL.md have description field" \
    || fail "$CAT" "All SKILL.md have description field" "missing: ${BAD_DESC[*]}"

  if $STRICT; then
    [[ ${#SHORT_BODY[@]} -eq 0 ]] && pass "$CAT" "SKILL.md body >= 10 lines (strict)" \
      || fail "$CAT" "SKILL.md body >= 10 lines (strict)" "short: ${SHORT_BODY[*]}"
    [[ ${#SHORT_DESC[@]} -eq 0 ]] && pass "$CAT" "Description >= 20 chars (strict)" \
      || fail "$CAT" "Description >= 20 chars (strict)" "short: ${SHORT_DESC[*]}"
  fi

  # skills.txt cross-ref
  TXT="$PROJECT_ROOT/config/skills.txt"
  if [[ -f "$TXT" ]]; then
    pass "$CAT" "skills.txt exists"
    FS_SKILLS=()
    for dir in "$SD"/*/; do
      name=$(basename "$dir")
      [[ "$name" == _* ]] && continue
      FS_SKILLS+=("$name")
    done

    TXT_SKILLS=()
    while IFS= read -r line; do
      line=$(echo "$line" | tr -d '\r')
      [[ -z "$line" ]] && continue
      # Extract name after hashline: "1#QR|skillname" -> "skillname"
      if echo "$line" | grep -q '|'; then
        name=$(echo "$line" | cut -d'|' -f2)
      else
        name=$(echo "$line" | xargs)
      fi
      TXT_SKILLS+=("$name")
    done < "$TXT"

    MISSING_FROM_TXT=()
    for s in "${FS_SKILLS[@]}"; do
      found=false
      for t in "${TXT_SKILLS[@]}"; do [[ "$t" == "$s" ]] && { found=true; break; } done
      $found || MISSING_FROM_TXT+=("$s")
    done

    MISSING_FROM_FS=()
    for t in "${TXT_SKILLS[@]}"; do
      found=false
      for s in "${FS_SKILLS[@]}"; do [[ "$s" == "$t" ]] && { found=true; break; } done
      $found || MISSING_FROM_FS+=("$t")
    done

    if [[ ${#MISSING_FROM_TXT[@]} -eq 0 && ${#MISSING_FROM_FS[@]} -eq 0 ]]; then
      pass "$CAT" "skills.txt matches filesystem"
    else
      detail=""
      [[ ${#MISSING_FROM_TXT[@]} -gt 0 ]] && detail+="fs->txt: ${MISSING_FROM_TXT[*]}; "
      [[ ${#MISSING_FROM_FS[@]} -gt 0 ]] && detail+="txt->fs: ${MISSING_FROM_FS[*]}"
      fail "$CAT" "skills.txt matches filesystem" "$detail"
    fi
  else
    fail "$CAT" "skills.txt exists" "file not found"
  fi
else
  fail "$CAT" "config/skills/ directory exists"
fi

# ═══════════════════════════════════════════════════════════════════════
# Category 4: Installer Structure
# ═══════════════════════════════════════════════════════════════════════
print_header "Installer Structure"
CAT="Installer Structure"

IPS1="$PROJECT_ROOT/install.ps1"
ISH="$PROJECT_ROOT/install.sh"
UPS1="$PROJECT_ROOT/uninstall.ps1"
USH="$PROJECT_ROOT/uninstall.sh"

[[ -f "$IPS1" ]] && head -1 "$IPS1" | grep -q 'pwsh' && pass "$CAT" "install.ps1 has pwsh shebang" \
  || fail "$CAT" "install.ps1 has pwsh shebang"
[[ -f "$ISH" ]] && head -1 "$ISH" | grep -q 'bash' && pass "$CAT" "install.sh has bash shebang" \
  || fail "$CAT" "install.sh has bash shebang"
[[ -f "$UPS1" ]] && pass "$CAT" "uninstall.ps1 exists" \
  || fail "$CAT" "uninstall.ps1 exists"
[[ -f "$USH" ]] && pass "$CAT" "uninstall.sh exists" \
  || fail "$CAT" "uninstall.sh exists"

README="$PROJECT_ROOT/README.md"
if [[ -f "$README" ]]; then
  grep -q 'What You Get' "$README" && pass "$CAT" "README.md has 'What You Get' section" \
    || fail "$CAT" "README.md has 'What You Get' section"
  grep -q 'Quick Install' "$README" && pass "$CAT" "README.md has 'Quick Install' section" \
    || fail "$CAT" "README.md has 'Quick Install' section"
else
  fail "$CAT" "README.md exists" "file not found"
fi

# ═══════════════════════════════════════════════════════════════════════
# Category 5: Git Hygiene
# ═══════════════════════════════════════════════════════════════════════
print_header "Git Hygiene"
CAT="Git Hygiene"

[[ -f "$PROJECT_ROOT/.gitignore" ]] && pass "$CAT" ".gitignore exists" \
  || fail "$CAT" ".gitignore exists"
[[ -f "$PROJECT_ROOT/.gitattributes" ]] && pass "$CAT" ".gitattributes exists" \
  || fail "$CAT" ".gitattributes exists"
[[ -f "$PROJECT_ROOT/LICENSE" || -f "$PROJECT_ROOT/LICENSE.md" ]] && pass "$CAT" "LICENSE exists" \
  || fail "$CAT" "LICENSE exists"
[[ -f "$PROJECT_ROOT/CONTRIBUTING.md" ]] && pass "$CAT" "CONTRIBUTING.md exists" \
  || fail "$CAT" "CONTRIBUTING.md exists"

# ═══════════════════════════════════════════════════════════════════════
# Output
# ═══════════════════════════════════════════════════════════════════════
TOTAL=$((PASSED + FAILED))
ALL_PASS=$((FAILED == 0 ? 1 : 0))

if [[ "$FORMAT" == "json" ]]; then
  echo -n '{"passed":'$PASSED',"failed":'$FAILED',"total":'$TOTAL',"results":['
  first=true
  for r in "${RESULTS[@]}"; do
    $first || echo -n ','
    first=false
    echo -n "$r"
  done
  echo ']}'
else
  echo ""
  echo "Results: $PASSED passed, $FAILED failed, $TOTAL total"
fi

exit $((ALL_PASS ? 0 : 1))
