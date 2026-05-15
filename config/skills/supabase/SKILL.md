---
name: supabase
description: Supabase — database, auth, storage, realtime, Edge Functions, client SDK.
---

## supabase

### Database / RLS Policies
- Postgres under the hood — tables, views, functions, triggers.
- Row-Level Security: `CREATE POLICY "users can read own" ON public.profiles FOR SELECT USING (auth.uid() = id)`.
- Enable RLS on every table by default; policies written as SQL in Supabase Dashboard.
- Use `supabase/supabase-js` for type-safe queries from client.

### Auth
- Built-in auth: email/password, magic link, OAuth (Google, GitHub, Discord).
- `supabase.auth.signUp()`, `supabase.auth.signIn()`, `supabase.auth.signOut()`.
- Row-level auth via `auth.uid()` and `auth.email()` in RLS policies.
- Session management, MFA, user impersonation in dashboard.

### Storage
- Buckets: `supabase.storage.createBucket('avatars')`, upload: `.upload('path/file.png', file)`.
- Public/private buckets with RLS policies on `storage.objects`.
- Signed URLs for temporary access; image transformations via URL params.

### Realtime
- `supabase.channel('room').on('postgres_changes', { event: '*', schema: 'public' }, callback)`.
- Broadcast, presence, and Postgres change data capture.
- WebSocket-based — use `@supabase/realtime-js` for custom clients.

### Edge Functions
- Deno-based serverless functions: `supabase functions deploy my-func`.
- `supabase functions serve` for local dev with hot reload.
- Auth context injected via `req.headers.get('x-supabase-auth')`.

### Local Dev
- `supabase init`, `supabase start` — Docker-based local Supabase stack.
- `supabase db diff`, `supabase db push` — schema migration management.
