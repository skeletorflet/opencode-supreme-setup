---
name: data
description: Data processing, ETL, and data pipeline patterns. Use when working with data transformation and analysis.
---

## data

Process and transform data effectively.

### ETL patterns
- Extract: read from source (DB, API, file)
- Transform: clean, validate, enrich
- Load: write to destination

### Best practices
- Validate at each stage
- Handle missing data gracefully
- Log processing stats
- Idempotent operations for retry
- Partition large datasets
- Monitor pipeline health
