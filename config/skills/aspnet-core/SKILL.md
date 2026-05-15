---
name: aspnet-core
description: ASP.NET Core web framework. Use when building .NET web APIs, Minimal APIs, MVC apps, Blazor components, Entity Framework Core, Identity/JWT auth, or middleware pipelines.
---

## aspnet-core

Cross-platform, high-performance framework for modern web applications on .NET.

### Core Concepts
- Minimal APIs: lightweight HTTP endpoints with top-level statements, minimal ceremony for microservices
- MVC pattern: controllers with attribute routing, model binding, and view rendering (Razor)
- Middleware pipeline: request/response components in configurable order (auth, logging, CORS, static files)
- DI Container: built-in dependency injection with scoped, transient, and singleton lifetimes

### Common Patterns
- Entity Framework Core: code-first migrations, LINQ queries, eager loading, change tracking
- Blazor WASM/Server: client-side WebAssembly or server-rendered interactive components via SignalR
- Identity/JWT auth: ASP.NET Core Identity for user management, JWT bearer tokens for API auth
- Background services: `IHostedService` / `BackgroundService` for scheduled tasks and queue processing

### Best Practices
- Program.cs as single startup entry point with clean separation of service registration and middleware config
- Action filters for cross-cutting concerns like validation, logging, and caching
- `IOptions<T>` pattern for strongly-typed configuration with reload-on-change support
- Integration tests with `WebApplicationFactory` over the full HTTP pipeline

### Common Code Patterns
- `app.MapGet("/api/products", handler)` for Minimal API endpoints
- `services.AddDbContext<AppDbContext>(o => o.UseSqlServer(connStr))` for DI registration
