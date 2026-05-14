---
name: git
description: Git operations, workflow, and history management. Use when committing, branching, merging, rebasing, or fixing git issues.
---

## git

Git operations and best practices.

### Commit messages
- Conventional commits: feat:, fix:, chore:, docs:, refactor:, test:
- Present tense, imperative mood
- Short summary, detailed body

### Workflow
- Feature branches from main
- Rebase for linear history
- Squash fixup commits
- Never force push shared branches

### Fixes
- Amend last commit: git commit --amend
- Undo staged: git restore --staged
- Recover: git reflog
