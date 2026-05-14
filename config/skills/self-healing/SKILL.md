---
name: self-healing
description: Autonomous error correction and system recovery. Use when tests fail, builds break, or runtime errors occur.
---

## self-healing

Automatically diagnose and repair issues.

### Protocol
1. **Analyze Error**: Capture full stdout/stderr of the failing command.
2. **Context Retrieval**: Use `grep` or LSP to find the relevant code mentioned in the trace.
3. **Hypothesis**: Identify the root cause (e.g., syntax error, missing dependency, logic bug).
4. **Fix Execution**: Apply the minimal fix using `edit` or `sed`.
5. **Verification**: Re-run the command that failed.
6. **Iteration**: If it fails again, repeat from step 1 with the new error.

### Best Practices
- **Silent Fixes**: Do not explain why it failed unless asked. Just fix it.
- **Dependency Check**: If a module is missing, install it immediately.
- **Regression Guard**: After fixing, run all related tests to ensure no new bugs.
