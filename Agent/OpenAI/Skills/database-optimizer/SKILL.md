---
name: database-optimizer
description: |
  Deep focus on database schema review, index optimization, and query analysis.
  Identifies N+1 queries, missing indexes, and schema anti-patterns.
  Use when optimizing database performance or reviewing schema design.
---
# Skill: database-optimizer
Attributes: name="database-optimizer", version="2.0.0"

## Metadata (`metadata`)

- `keywords`: database, sql, indexes, queries, schema, n+1, explain, optimization

## Spec Contract (`spec_contract`)

- `id`: database-optimizer

- `name`: database-optimizer

- `version`: 2.0.0

- `last_updated`: 2026-02-09

- `purpose`: Optimize database performance through schema review, index analysis, and query optimization.

### Inputs (`inputs`)

- `input`: User request and relevant project context.

### Outputs (`outputs`)

- `output`: Completed guidance, actions, or artifacts produced by this skill.

### Triggers (`triggers`)

- `trigger`: Use when the frontmatter description conditions are met.

- `procedure`: Follow the ordered steps in the workflow section.

### Edge Cases (`edge_cases`)

- `edge_case`: If required context is missing, gather or request it before continuing.

### Safety Constraints (`safety_constraints`)

- `constraint`: Avoid destructive operations without explicit user intent.

### Examples (`examples`)

- `example`: Activate this skill when the request matches its trigger conditions.

- `goal`: Optimize database performance through schema review, index analysis, and query optimization.

## Core Principles (`core_principles`)

### Principle (`principle`)
Attributes: name="Measure Before Optimizing"

- `rule`: Use EXPLAIN ANALYZE before and after changes to measure impact.

- `rule`: Profile actual slow queries, not theoretical bottlenecks.

### Principle (`principle`)
Attributes: name="Schema Design"

- `rule`: Start normalized (3NF); denormalize only for proven bottlenecks with measurements.

- `rule`: Enforce foreign keys at the database level.

- `rule`: Use appropriate data types (don't store UUIDs as VARCHAR(36)).

- `rule`: Avoid nullable columns where possible; use NOT NULL with defaults.

### Principle (`principle`)
Attributes: name="Index Strategy"

- `rule`: Index foreign keys (almost always needed for JOINs).

- `rule`: Index columns used in WHERE, ORDER BY, GROUP BY clauses.

- `rule`: Consider composite indexes for multi-column queries (leftmost prefix rule).

- `rule`: Avoid over-indexing; each index slows down writes.

## Workflow (`workflow`)

### Step (`step`)
Attributes: number="1", name="Gather Slow Queries"

- `action`: Identify slow queries from logs or APM tools.

- `action`: Use database slow query log if available.

- `output`: List of top 3-5 slowest queries by total time.

### Step (`step`)
Attributes: number="2", name="Analyze Query Plans"

- `action`: Run EXPLAIN ANALYZE on each slow query.

- `check`: Look for: Sequential scans on large tables.

- `check`: Look for: Nested loops with high row counts.

- `check`: Look for: Sort operations without index support.

### Step (`step`)
Attributes: number="3", name="Review Schema"

- `check`: Are foreign keys properly defined?

- `check`: Are common query columns indexed?

- `check`: Are data types appropriate (UUID, TIMESTAMP, etc.)?

- `check`: Are there "God Tables" with too many columns?

### Step (`step`)
Attributes: number="4", name="Recommend Optimizations"

- `action`: Suggest specific indexes with CREATE INDEX statements.

- `action`: Recommend query rewrites if needed.

- `action`: Flag N+1 patterns and suggest eager loading.

### Step (`step`)
Attributes: number="5", name="Verify Improvements"

- `action`: Re-run EXPLAIN ANALYZE after changes.

- `action`: Document before/after metrics.

## Best Practices (`best_practices`)

- `do`: Measure with EXPLAIN ANALYZE before and after every optimization

- `do`: Optimize top slow queries first instead of broad schema rewrites

- `do`: Add indexes based on observed filter, join, and sort patterns

- `do`: Document performance deltas with concrete baseline metrics

- `dont`: Add indexes speculatively without workload evidence

- `dont`: Ship query changes without regression checks on representative data

## Anti Patterns (`anti_patterns`)

### Pattern (`pattern`)
Attributes: name="N+1 Query Problem"

- `description`: Executing a query for each item in a list instead of one batch query.

- `detection`: Look for loops containing database queries.

- `fix`: Use eager loading (JOIN) or batch loading (WHERE id IN (...)).

### Pattern (`pattern`)
Attributes: name="Missing Index on Foreign Key"

- `description`: Foreign key columns without indexes cause slow JOINs.

- `detection`: Check all foreign key columns for indexes.

- `fix`: CREATE INDEX idx_tablename_fk ON table(foreign_key_column);

### Pattern (`pattern`)
Attributes: name="SELECT * in Production"

- `description`: Fetching all columns when only a few are needed.

- `detection`: Search for "SELECT *" in production queries.

- `fix`: Specify only needed columns: SELECT id, name, email FROM users;

### Pattern (`pattern`)
Attributes: name="Unbounded Queries"

- `description`: Queries without LIMIT that can return millions of rows.

- `detection`: Look for SELECT without LIMIT on large tables.

- `fix`: Always paginate: LIMIT 100 OFFSET 0;

### Pattern (`pattern`)
Attributes: name="Float for Currency"

- `description`: Using FLOAT/DOUBLE for monetary values causes rounding errors.

- `detection`: Check currency columns for floating-point types.

- `fix`: Use DECIMAL(19,4) or store as integer cents.

## Query Optimization Tips (`query_optimization_tips`)

- `tip`: Use covering indexes when query only needs indexed columns (avoids table lookup).

- `tip`: Avoid functions on indexed columns in WHERE (breaks index usage).

- `tip`: Use EXISTS instead of IN for subqueries with large result sets.

- `tip`: Consider query caching for frequently run, rarely changing queries.

## Related Skills (`related_skills`)

- `skill`: backend-architect

- `skill`: performance-analyzer

## Related Workflows (`related_workflows`)

- `workflow`: /performance-tune
