---
name: git-master
description: Git workflow mastery — atomic commits, branch management, rebase, merge, and history cleanup. Use when committing, reviewing history, or fixing git issues.
---

## git-master

Master git workflows for clean, atomic history.

### Atomic commits
- One logical change per commit
- Commit messages: type(scope): description
  - feat: new feature
  - fix: bug fix
  - chore: maintenance
  - docs: documentation
  - refactor: code change without fix/feat
  - test: adding tests
  - style: formatting

### Branch workflow
- main — production-ready
- feat/name — new features
- fix/name — bug fixes
- chore/name — maintenance

### Interactive rebase
- git rebase -i HEAD~n — squash, reorder, fixup
- git rebase main — replay commits on main
- git commit --fixup <hash> — mark as fixup
- git rebase -i --autosquash — auto squash fixups

### Best practices
- Rebase before merge for linear history
- Never rebase shared branches
- Use git stash for WIP
- git bisect to find the commit that introduced a bug
- git blame to understand why code exists
