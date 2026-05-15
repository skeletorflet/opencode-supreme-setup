# Contributing

Thanks for wanting to improve OpenCode Supreme Setup!

## Adding a Skill

1. Create `config/skills/<name>/SKILL.md` with frontmatter:
   ```markdown
   ---
   name: <name>
   description: What it does AND when to trigger it
   ---
   # <Skill Name>
   Instructions...
   ```
2. Add to `config/skills.txt`: `echo <name> >> config/skills.txt`
3. Validate: `npx opencode-skill-audit` — checks frontmatter, description length, directory match
4. Rebuild skills index: `ls -d config/skills/*/ | xargs -I{} basename {} > config/skills.txt`
5. Submit PR

### Skill requirements
- `name` lowercase hyphen-separated, matches directory name
- `description` 20+ chars, front-load trigger keywords
- Body is markdown with practical instructions

### Skill Audit
Skills are validated by `opencode-skill-audit` (runs automatically in CI):
- Frontmatter `name` matches directory name
- `description` ≥ 20 characters with trigger keywords front-loaded
- Body is valid markdown with practical instructions
- No duplicate names across built-in and marketplace skills

Run locally: `npx opencode-skill-audit`

### Batch Adding Skills
For bulk additions (e.g., importing from a skill registry):

1. Add skill directories under `config/skills/<name>/` each with `SKILL.md`
2. Regenerate index: `ls -d config/skills/*/ | xargs -I{} basename {} > config/skills.txt`
3. Run audit: `npx opencode-skill-audit`
4. Update the categorized table in `README.md` under **135 Built-in Skills**
5. Commit all new skills and the updated `skills.txt`
## Adding a Plugin

1. Add the npm package name to `plugin` array in `config/opencode.json`
2. Add to `$plugins` array in both `install.ps1` and `install.sh`
3. Add description PR summary

## Adding a Theme

1. Add npm package name to theme install section in installers
2. Add to README theme table

## Code style
- install.ps1: PowerShell 7+, functions for reuse, Invoke-Progress pattern
- install.sh: bash 4+, color constants, run() pattern
- No hardcoded paths, use $ConfigDir / $CONFIG_DIR

## PR process
1. Fork + branch: `feat/my-thing`
2. Test: `opencode --version` starts clean
3. Commit conventional: `feat:`, `fix:`, `chore:`
4. PR against master
