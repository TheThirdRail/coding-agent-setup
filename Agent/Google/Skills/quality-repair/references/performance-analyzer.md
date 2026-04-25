# Legacy Lane: performance-analyzer

Vendor: Google Antigravity
Router: `quality-repair`
Source archive: `.\Agent\Google\deprecated-Skills\performance-analyzer\SKILL.md`
Consolidated: 2026-04-25

The content below is the former installable skill or workflow body, preserved as an on-demand lane reference.

```markdown
---
name: performance-analyzer
description: |
  Profile, benchmark, and optimize application performance using measurable
  baselines and incremental changes. Use when diagnosing latency, throughput,
  memory, database, or frontend performance bottlenecks.
---

<skill name="performance-analyzer" version="2.0.0">
  <metadata>
    <keywords>performance, profiling, benchmarking, optimization, latency, throughput</keywords>
  </metadata>

  <goal>Identify the highest-impact bottlenecks and apply measured optimizations with verifiable improvements.</goal>

  <core_principles>
    <principle name="Measure Before Change">
      <rule>Capture baseline metrics (p50/p95/p99 latency, throughput, resource utilization) before optimization.</rule>
      <rule>Do not accept optimizations without measurable deltas.</rule>
    </principle>

    <principle name="Impact-First Prioritization">
      <rule>Rank bottlenecks by user impact and system cost, then fix top offenders first.</rule>
      <rule>Prefer 80/20 changes that reduce dominant latency contributors.</rule>
    </principle>

    <principle name="One Change at a Time">
      <rule>Apply optimizations incrementally and re-measure after each change.</rule>
      <rule>Document regressions and rollback if improvements are not sustained.</rule>
    </principle>
  </core_principles>

  <workflow>
    <step number="1" name="Establish Baseline">
      <metric>Response time distribution (p50, p95, p99)</metric>
      <metric>Throughput and error rate</metric>
      <metric>CPU, memory, disk I/O, and database timings</metric>
    </step>

    <step number="2" name="Profile and Localize Bottlenecks">
      <instruction>Use profilers and traces to determine where time and resources are spent.</instruction>
      <category>CPU-bound</category>
      <category>I/O-bound</category>
      <category>Memory-bound</category>
      <category>Network-bound</category>
    </step>

    <step number="3" name="Apply Targeted Optimizations">
      <instruction>Select one optimization from references/optimization-patterns.md and implement it.</instruction>
      <focus>Database, API calls, algorithmic complexity, caching, rendering, payload size</focus>
    </step>

    <step number="4" name="Re-Measure and Compare">
      <instruction>Re-run benchmark/profile suite and compare against baseline.</instruction>
      <output>Before/after table with quantifiable deltas</output>
    </step>

    <step number="5" name="Document Outcome">
      <instruction>Record what changed, why it helped, and remaining risks or next bottlenecks.</instruction>
    </step>
  </workflow>

  <resources>
    <reference file="references/optimization-patterns.md">Optimization tactics and quick-win catalog.</reference>
  </resources>

  <best_practices>
    <do>Use representative workloads for benchmarks</do>
    <do>Keep performance budgets explicit for critical paths</do>
    <do>Validate database query plans after schema/index changes</do>
    <do>Track improvements and regressions in repeatable reports</do>
    <dont>Optimize based on intuition alone</dont>
    <dont>Ship optimizations that increase complexity without clear gain</dont>
    <dont>Ignore memory pressure when improving pure latency</dont>
  </best_practices>

  <related_skills>
    <skill>api-builder</skill>
    <skill>architecture-planner</skill>
    <skill>database-optimizer</skill>
  </related_skills>

  <related_workflows>
    <workflow>/performance-tune</workflow>
    <workflow>/analyze</workflow>
  </related_workflows>
</skill>
```
