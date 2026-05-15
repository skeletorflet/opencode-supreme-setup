---
name: actix-web
description: Actix-web Rust web framework. Use when building Rust HTTP services, Actor framework apps, extractors, WebSocket handlers, or performance-critical API servers on Actix RT.
---

## actix-web

High-performance Rust web framework built on the Actix actor system with zero-cost abstractions.

### Core Concepts
- Actor framework: typed actors with message passing, async handlers, and supervision trees
- Routing: `#[get("/users/{id}")]` attribute macros or `App::new().route()` for modular routing
- Extractors: type-safe request data extraction via trait impls (Json, Path, Query, Form, Data)
- Actix RT: multi-threaded async runtime optimized for HTTP throughput over Tokio

### Common Patterns
- Middleware: `wrap_fn` closures or `Transform` trait for logging, auth, and request modification
- Error handling: `actix_web::error::Error` with `ResponseError` trait for typed HTTP error responses
- WebSocket: `web::resource("/ws").route(web::get().to(ws_handler))` with actor-backed sessions
- Testing: `actix_web::test` utilities with `TestRequest`, `call_service`, and `read_body_json`

### Best Practices
- Use `web::Data<T>` for shared application state instead of global statics or lazy statics
- Implement `Responder` trait for custom response types to keep handler return types clean
- Configure worker count via `HttpServer::new().workers(n)` matching CPU cores for optimal throughput
- Compile with `--release` for production: Actix RT performance can exceed Go and Node.js equivalents

### Common Code Patterns
- `HttpResponse::Ok().json(response)` for typed JSON serialization via serde
- `web::block(move || heavy_calc()).await` for blocking CPU work off the async runtime
