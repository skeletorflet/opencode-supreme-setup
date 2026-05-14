---
name: caching
description: Caching strategies for backend and frontend applications. Use when implementing or reviewing caching.
---

## caching

Implement effective caching strategies.

### Cache levels
- Browser cache: static assets
- CDN cache: edge caching
- Server cache: Redis, query cache
- Application cache: memoization

### Strategies
- Cache-first: serve cache, update background
- Network-first: try network, fallback cache
- Stale-while-revalidate: serve stale, refresh async
- Write-through: update cache on write
- TTL-based invalidation
