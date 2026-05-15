## 2026-05-14: skill-audit scripts created

- scripts/skill-audit.ps1 — PowerShell 7 (114 lines) with --format md|json|check
- scripts/skill-audit.sh — Bash (88 lines) with same flags
- Both skip _template directory, count 135 skills (all valid)
- Key gotchas:
  - Some SKILL.md files have UTF-8 BOM on first line
  - CRLF line endings on Windows require tr -d or sed BOM stripping
  - PowerShell 5.1 has issues with complex string interpolation; must use pwsh
  - wc -l counts differ from PS1 split count (wc = newline count, split = array count)
