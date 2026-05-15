---
name: tanstack-query
description: TanStack Query — server state management with queries, mutations, caching, infinite queries, SSR.
---

## tanstack-query

### Queries
- `useQuery({ queryKey: ['todos'], queryFn: fetchTodos })` — fetch + cache + auto-refetch.
- Query keys: unique key arrays for cache identity and invalidation.
- `enabled: false` — conditional/disable; `staleTime` — freshness window; `gcTime` — garbage collection.
- `placeholderData: keepPreviousData` — smooth pagination transitions.

### Mutations
- `useMutation({ mutationFn: addTodo, onSuccess: () => queryClient.invalidateQueries({ queryKey: ['todos'] }) })`.
- Optimistic updates: `onMutate` — set cache before server; `onError` — rollback; `onSettled` — refetch.
- `mutate(data)` vs `mutateAsync(data)` — fire-and-forget vs promise.

### QueryClient
- `new QueryClient({ defaultOptions: { queries: { staleTime: 5 * 60 * 1000 } } })` — global config.
- `queryClient.invalidateQueries({ queryKey: ['todos'] })` — refetch stale queries.
- `queryClient.setQueryData(['todos'], newData)` — direct cache writes.
- `queryClient.prefetchQuery({ queryKey, queryFn })` — warm cache before render.

### Infinite Queries
- `useInfiniteQuery({ queryKey, queryFn: ({ pageParam }) => fetchPage(pageParam), initialPageParam: 0, getNextPageParam: (last) => last.next })`.
- `fetchNextPage`, `hasNextPage`, `isFetchingNextPage` — pagination UI.
- `useInfiniteQuery` works with `IntersectionObserver` for scroll loading.

### SSR & Devtools
- Hydration: `dehydrate(queryClient)` / `HydrationBoundary` — serialize cache to HTML.
- `<QueryClientProvider>` — required wrapper around app.
- `{ ReactQueryDevtools }` — dev panel for cache inspection.
