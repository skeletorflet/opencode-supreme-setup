---
name: postgresql
description: PostgreSQL — advanced SQL, indexing, extensions, partitioning, EXPLAIN ANALYZE.
---

## postgresql

### Advanced SQL
- CTEs: `WITH cte AS (SELECT ...) SELECT * FROM cte` for readable queries.
- Window functions: `ROW_NUMBER() OVER (PARTITION BY dept ORDER BY salary DESC)`.
- Recursive CTEs: `WITH RECURSIVE` for tree/graph traversal queries.
- `LATERAL` subqueries, `GROUPING SETS`, `FILTER` clause for conditional aggregates.

### Indexing
- B-tree (default) for equality/range; GiST for full-text/geometric; GIN for array/JSON/tsvector; BRIN for large sequential data.
- Partial indexes: `CREATE INDEX active_users ON users(created_at) WHERE status = 'active'`.
- Covering indexes with `INCLUDE (col1, col2)` for index-only scans.

### Extensions
- PostGIS: spatial queries — `ST_Distance`, `ST_Within`, `ST_AsGeoJSON`.
- pgvector: `CREATE INDEX ON items USING ivfflat (embedding vector_cosine_ops)` for ANN.
- pg_cron: schedule SQL jobs via cron syntax.
- `uuid-ossp`, `pg_trgm`, `citext`, `hstore` for common utilities.

### Partitioning
- Range/list/hash partitioning via `PARTITION BY RANGE (created_at)`.
- Detach/attach partitions for zero-downtime data movement.
- Partition pruning for query performance on large tables.

### EXPLAIN ANALYZE
- `EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)` for execution plan analysis.
- Focus on sequential scans, nested loop joins, high row estimates.

### Tools
- psql: `\dt`, `\d table`, `\l`, `\di`, `\x auto` for expanded display.
- pgAdmin: GUI with query planner visualizer and dashboard.
