#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_DIR="$(cd "$SCRIPT_DIR/../config/skills" && pwd)"
FORMAT="${1:-md}"

case "$FORMAT" in
  --format) FORMAT="${2:-md}" ;;
  --format=*) FORMAT="${1#--format=}" ;;
esac

[ -d "$SKILLS_DIR" ] || { echo "ERROR: Skills directory not found: $SKILLS_DIR" >&2; exit 1; }

ALL_VALID=true
RESULTS=()
COUNT=0

for dir in "$SKILLS_DIR"/*/; do
  name=$(basename "$dir")
  [[ "$name" == _* ]] && continue

  md="$dir/SKILL.md"
  [ -f "$md" ] || continue

  total_lines=$(wc -l < "$md" | tr -d ' \r')
  first_line=$(head -1 "$md" | LC_ALL=C sed 's/^\xEF\xBB\xBF//' | tr -d '\r')
  has_frontmatter=false
  has_description=false

  [ "$first_line" = "---" ] && has_frontmatter=true
  grep -Eq '^description:\s*.+' "$md" 2>/dev/null && has_description=true

  if $has_frontmatter && $has_description; then
    valid=true
  else
    valid=false
  fi
  $valid || ALL_VALID=false

  RESULTS+=("$name|$total_lines|$has_frontmatter|$has_description|$valid")
  COUNT=$((COUNT + 1))
done

TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

case "$FORMAT" in
  md)
    echo "| Skill | Lines | Frontmatter | Description | Status |"
    echo "|-------|-------|-------------|-------------|--------|"
    IFS=$'\n' sorted=($(sort <<< "${RESULTS[*]}")); unset IFS
    for row in "${sorted[@]}"; do
      IFS='|' read -r name lines fm desc valid <<< "$row"
      if $fm; then fm_char='✅'; else fm_char='❌'; fi
      if $desc; then desc_char='✅'; else desc_char='❌'; fi
      if $valid; then status_char='✅'; else status_char='❌'; fi
      printf "| %s | %s | %s | %s | %s |\n" "$name" "$lines" "$fm_char" "$desc_char" "$status_char"
    done
    echo ""
    $ALL_VALID && echo "**$COUNT skills audited - all valid**" || echo "**$COUNT skills audited - issues found**"
    ;;
  json)
    echo -n '{"count":'$COUNT',"skills":['
    first=true
    for row in "${RESULTS[@]}"; do
      $first || echo -n ','
      first=false
      IFS='|' read -r name lines fm desc valid <<< "$row"
      printf '{"name":"%s","lines":%s,"has_frontmatter":%s,"has_description":%s,"valid":%s}' \
        "$name" "$lines" "$fm" "$desc" "$valid"
    done
    echo '],"timestamp":"'$TIMESTAMP'","all_valid":'$ALL_VALID'}'
    ;;
  check)
    if $ALL_VALID; then
      echo "OK: $COUNT skills all valid"
      exit 0
    fi
    echo "FAIL: $COUNT skills audited, some have issues"
    for row in "${RESULTS[@]}"; do
      IFS='|' read -r name lines fm desc valid <<< "$row"
      $valid && continue
      issues=""
      $fm || issues="missing frontmatter"
      $desc || issues="${issues:+$issues, }missing description"
      echo "  $name: $issues"
    done
    exit 1
    ;;
esac
