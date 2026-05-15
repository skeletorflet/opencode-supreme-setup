---
name: drizzle
description: Drizzle ORM — schema definitions, queries, relations, drizzle-kit, edge support.
---

## drizzle

### Schema Definition
- Define schemas in TS/JS: `export const users = pgTable('users', { id: serial('id').primaryKey(), name: text('name') })`.
- Column types: `serial`, `text`, `varchar`, `integer`, `timestamp`, `boolean`, `jsonb`.
- Constraints: `.notNull()`, `.default(...)`, `.unique()`, `.references(() => posts.id)`.

### Queries
- `db.select().from(users)` — SQL-like API with full type safety.
- `db.insert(users).values({ name: 'Alice' }).returning()`.
- `db.update(users).set({ name: 'Bob' }).where(eq(users.id, 1))`.
- `db.delete(users).where(eq(users.id, 1))`.
- Filtering: `eq`, `ne`, `gt`, `lt`, `like`, `inArray`, `and`, `or`.
- Relations: `relations(users, ({ many }) => ({ posts: many(posts) }))`.

### Migrations
- `drizzle-kit generate:pg` — generate SQL from schema; `drizzle-kit push:pg` — push to DB.
- `drizzle-kit migrate` — apply; `drizzle-kit studio` — GUI.
- `drizzle-kit introspect:pg` — pull schema from existing DB.

### Edge / Neon Support
- Works with `@neondatabase/serverless`, `@vercel/postgres`, `@planetscale/database`.
- `drizzle-orm/neon` — HTTP and WebSocket drivers.
- No heavy client — minimal bundle for edge functions.

### Drizzle Studio
- `npx drizzle-kit studio` — real-time schema inspector and data editor.
