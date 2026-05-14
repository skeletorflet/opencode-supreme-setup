---
name: cli
description: Build command-line interfaces and tools. Use when creating CLI applications or scripts.
---

## cli

Build effective command-line tools.

### Design
- POSIX conventions (-v, --help)
- Subcommands: tool commit, tool push
- --version and --help everywhere
- Correct stdin/stdout/stderr usage
- Exit codes (0 success)

### Libraries
- Node: commander, yargs, meow
- Python: click, typer, argparse
- Go: cobra
- Rust: clap
