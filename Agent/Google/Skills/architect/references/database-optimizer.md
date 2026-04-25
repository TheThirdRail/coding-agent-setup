# Legacy Lane: database-optimizer

Vendor: Google Antigravity
Router: `architect`
Source archive: `.\Agent\Google\deprecated-Skills\database-optimizer\SKILL.md`
Consolidated: 2026-04-25

The content below is the former installable skill or workflow body, preserved as an on-demand lane reference.

```markdown
---
name: database-optimizer
description: |
  Deep focus on database schema review, index optimization, and query analysis.
  Identifies N+1 queries, missing indexes, and schema anti-patterns.
  Use when optimizing database performance or reviewing schema design.
---

<skill name="database-optimizer" version="2.0.0">
  <metadata>
    <keywords>database, sql, indexes, queries, schema, n+1, explain, optimization</keywords>
  </metadata>

  <goal>Optimize database performance through schema review, index analysis, and query optimization.</goal>

  <core_principles>
    <principle name="Measure Before Optimizing">
      <rule>Use EXPLAIN ANALYZE before and after changes to measure impact.</rule>
      <rule>Profile actual slow queries, not theoretical bottlenecks.</rule>
    </principle>

    <principle name="Schema Design">
      <rule>Start normalized (3NF); denormalize only for proven bottlenecks with measurements.</rule>
      <rule>Enforce foreign keys at the database level.</rule>
      <rule>Use appropriate data types (don't store UUIDs as VARCHAR(36)).</rule>
      <rule>Avoid nullable columns where possible; use NOT NULL with defaults.</rule>
    </principle>

    <principle name="Index Strategy">
      <rule>Index foreign keys (almost always needed for JOINs).</rule>
      <rule>Index columns used in WHERE, ORDER BY, GROUP BY clauses.</rule>
      <rule>Consider composite indexes for multi-column queries (leftmost prefix rule).</rule>
      <rule>Avoid over-indexing; each index slows down writes.</rule>
    </principle>
  </core_principles>



  <workflow>
    <step number="1" name="Gather Slow Queries">
      <action>Identify slow queries from logs or APM tools.</action>
      <action>Use database slow query log if available.</action>
      <output>List of top 3-5 slowest queries by total time.</output>
    </step>

    <step number="2" name="Analyze Query Plans">
      <action>Run EXPLAIN ANALYZE on each slow query.</action>
      <check>Look for: Sequential scans on large tables.</check>
      <check>Look for: Nested loops with high row counts.</check>
      <check>Look for: Sort operations without index support.</check>
    </step>

    <step number="3" name="Review Schema">
      <check>Are foreign keys properly defined?</check>
      <check>Are common query columns indexed?</check>
      <check>Are data types appropriate (UUID, TIMESTAMP, etc.)?</check>
      <check>Are there "God Tables" with too many columns?</check>
    </step>

    <step number="4" name="Recommend Optimizations">
      <action>Suggest specific indexes with CREATE INDEX statements.</action>
      <action>Recommend query rewrites if needed.</action>
      <action>Flag N+1 patterns and suggest eager loading.</action>
    </step>

    <step number="5" name="Verify Improvements">
      <action>Re-run EXPLAIN ANALYZE after changes.</action>
      <action>Document before/after metrics.</action>
    </step>
  </workflow>

  <best_practices>
    <do>Measure with EXPLAIN ANALYZE before and after every optimization</do>
    <do>Optimize top slow queries first instead of broad schema rewrites</do>
    <do>Add indexes based on observed filter, join, and sort patterns</do>
    <do>Document performance deltas with concrete baseline metrics</do>
    <dont>Add indexes speculatively without workload evidence</dont>
    <dont>Ship query changes without regression checks on representative data</dont>
  </best_practices>

  <anti_patterns>
    <pattern name="N+1 Query Problem">
      <description>Executing a query for each item in a list instead of one batch query.</description>
      <detection>Look for loops containing database queries.</detection>
      <fix>Use eager loading (JOIN) or batch loading (WHERE id IN (...)).</fix>
    </pattern>

    <pattern name="Missing Index on Foreign Key">
      <description>Foreign key columns without indexes cause slow JOINs.</description>
      <detection>Check all foreign key columns for indexes.</detection>
      <fix>CREATE INDEX idx_tablename_fk ON table(foreign_key_column);</fix>
    </pattern>

    <pattern name="SELECT * in Production">
      <description>Fetching all columns when only a few are needed.</description>
      <detection>Search for "SELECT *" in production queries.</detection>
      <fix>Specify only needed columns: SELECT id, name, email FROM users;</fix>
    </pattern>

    <pattern name="Unbounded Queries">
      <description>Queries without LIMIT that can return millions of rows.</description>
      <detection>Look for SELECT without LIMIT on large tables.</detection>
      <fix>Always paginate: LIMIT 100 OFFSET 0;</fix>
    </pattern>

    <pattern name="Float for Currency">
      <description>Using FLOAT/DOUBLE for monetary values causes rounding errors.</description>
      <detection>Check currency columns for floating-point types.</detection>
      <fix>Use DECIMAL(19,4) or store as integer cents.</fix>
    </pattern>
  </anti_patterns>

  <query_optimization_tips>
    <tip>Use covering indexes when query only needs indexed columns (avoids table lookup).</tip>
    <tip>Avoid functions on indexed columns in WHERE (breaks index usage).</tip>
    <tip>Use EXISTS instead of IN for subqueries with large result sets.</tip>
    <tip>Consider query caching for frequently run, rarely changing queries.</tip>
  </query_optimization_tips>

  <related_skills>
    <skill>backend-architect</skill>
    <skill>performance-analyzer</skill>
  </related_skills>

  <related_workflows>
    <workflow>/performance-tune</workflow>
  </related_workflows>
</skill>
```
