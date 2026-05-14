---
name: async
description: Async programming patterns for JavaScript/TypeScript, Python, and other languages.
---

## async

Write correct async code.

### JS/TS patterns
- async/await over raw .then()
- Promise.all for parallel tasks
- Promise.allSettled for all results
- AbortController for cancellation
- Avoid promise nesting

### Common issues
- Unhandled rejections
- Race conditions
- Deadlocks
- Fire-and-forget without error handling
- Sequential when parallel is possible
