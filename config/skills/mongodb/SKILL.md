---
name: mongodb
description: MongoDB — aggregation pipeline, indexes, schema design, Atlas Search, Mongoose ODM.
---

## mongodb

### Aggregation Pipeline
- Stages: `$match` (filter), `$group` (group by field), `$sort`, `$project` (shape docs).
- `$lookup` — join collections (left outer join with pipeline syntax).
- `$unwind` — deconstruct arrays; `$addFields` — computed fields.
- `$facet` — multi-faceted aggregation within a single pipeline.

### Indexes
- Compound: `db.collection.createIndex({ field1: 1, field2: -1 })`.
- Text: `createIndex({ content: "text" })` with `$text` search operator.
- Geospatial: `2dsphere` indexes for GeoJSON queries.
- TTL indexes, sparse indexes, partial indexes for targeted workloads.

### Schema Design
- Embedding for read-heavy, one-to-few relationships.
- Referencing for one-to-many/many-to-many with `$lookup`.
- Bucket pattern for time-series data; polymorphic pattern with discriminator fields.

### Atlas Search / Vector
- `$search` aggregation stage — Lucene-based full-text search.
- Atlas Vector Search — `$vectorSearch` for semantic/kNN queries.
- Index configuration via Atlas UI or `searchIndexes` collection.

### Mongoose ODM
- `new Schema({ field: { type: String, required: true, index: true } })`.
- `Model.find()`, `.create()`, `.findByIdAndUpdate()`, hooks (pre/post save).
- Virtuals, plugins, discriminators, custom validation.

### Change Streams
- `collection.watch()` — real-time notifications on inserts, updates, deletes.
- Resume via `resumeAfter` token; use with `$match` filter for specific collections.

### Transactions
- `session.startTransaction()` for multi-document ACID transactions.
- Retry logic on `TransientTransactionError`.
