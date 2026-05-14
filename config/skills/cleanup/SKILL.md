---
name: cleanup
description: Code cleanup, technical debt reduction, and code quality improvement. Use when cleaning up messy code.
---

## cleanup

Reduce technical debt systematically.

### What to clean
- Dead code (unused imports, functions, files)
- Duplicated logic
- Magic numbers/strings
- Overly long functions
- Deeply nested conditionals
- Outdated comments

### Approach
1. Identify most impactful areas
2. Ensure tests exist
3. One concern at a time
4. Run linter + tests after each change
