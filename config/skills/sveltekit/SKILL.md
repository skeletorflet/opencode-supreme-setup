---
name: sveltekit
description: SvelteKit file-based routing (+page, +layout, +server, +error), load functions, form actions, hooks, auth patterns, adapters, endpoints, and progressive enhancement with use:enhance. Use when building SvelteKit full-stack applications.
---

## sveltekit

SvelteKit is the full-stack framework built on Svelte.

### Core Concepts
- File-based routing: +page.svelte, +layout.svelte, +server.ts, +error.svelte
- Load functions: +page.server.ts for server data, +page.ts for universal data
- Form actions: default action, named actions, validation patterns

### Common Patterns
- use:enhance for progressive enhancement on form submissions
- Hooks: handle, handleError, handleFetch for request interception
- Cookies and session management via the SvelteKit API

### Best Practices
- Co-locate data loading with pages using load functions
- Use form actions over API routes for mutations
- Choose the right adapter for your deployment target

### Common Code Patterns
- +page.server.ts export const load for server-side data fetching
- export const actions in +page.server.ts for form handling
- hooks.server.ts for global auth and request transformation
