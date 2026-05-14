---
name: db
description: Database design, queries, optimization, and schema management. Use when working with databases.
---

## db

Design and optimize databases.

### Design principles
- Normalize to reduce redundancy
- Appropriate data types
- Index WHERE, JOIN, ORDER BY columns
- Foreign keys for integrity
- Migration scripts

### Query optimization
- EXPLAIN ANALYZE to check plans
- Avoid SELECT *
- LIMIT results
- JOINs over subqueries
- Batch in transactions
