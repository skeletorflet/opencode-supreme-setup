---
name: shell
description: Shell scripting, command-line operations, and automation. Use when writing bash/pwsh scripts or complex shell commands.
---

## shell

Write effective shell scripts.

### Bash
- Use [[ ]] over [ ] for conditionals
- Quote variables
- set -euo pipefail for safety
- Use functions for reusable logic
- trap for cleanup on exit

### PowerShell
- Use named parameters
- Prefer cmdlets over aliases
- try/catch for errors
- Splatting for complex commands

### Cross-platform
- Check OS before platform-specific commands
- Use portable tools where possible
