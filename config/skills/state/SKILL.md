---
name: state
description: State management patterns for frontend applications. Use when managing application state.
---

## state

Manage application state effectively.

### State types
- Server state: API data
- Client state: UI, forms, preferences
- URL state: route params
- Global state: shared across components

### Pattern selection
- Local (useState): component-specific
- Context: low-frequency global (theme, auth)
- Zustand/Jotai: medium complexity
- Redux: complex with middleware
