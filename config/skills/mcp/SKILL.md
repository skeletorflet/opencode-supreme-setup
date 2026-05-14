---
name: mcp
description: Build MCP (Model Context Protocol) servers and tools. Use when creating or modifying MCP implementations.
---

## mcp

Build MCP servers and tools.

### Server types
- Local: subprocess via stdio
- Remote: HTTP server via SSE

### Implementation
- Tool schemas with JSON Schema
- Async request handling
- Input validation
- Structured error responses
- Document tools with descriptions

### Best practices
- Focused tools (one purpose)
- Type-safe schemas
- Resource limits (timeout, memory)
- Debug logging
