### SKILL DETECTION (smart)
1. When user asks a question or assigns a task, first check available skills in ~/.config/opencode/skills/ or listed in <available_skills> XML in AGENTS.md.
2. If a matching skill exists, read it and follow its instructions.
3. If no matching skill found locally, use web search OR run `npx openskills read <skill-name>` to find and load a relevant skill from the ecosystem.
4. Only proceed without a skill if none exists after searching.
5. Do NOT list individual skills here - rely on directory scanning.
