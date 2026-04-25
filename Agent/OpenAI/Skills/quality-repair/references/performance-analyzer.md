# Legacy Lane: performance-analyzer

Vendor: OpenAI Codex
Router: `quality-repair`
Source archive: `.\Agent\OpenAI\deprecated-Skills\performance-analyzer\SKILL.md`
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
# Skill: performance-analyzer
Attributes: name="performance-analyzer", version="2.0.0"

## Metadata (`metadata`)

- `keywords`: performance, profiling, benchmarking, optimization, latency, throughput

## Spec Contract (`spec_contract`)

- `id`: performance-analyzer

- `name`: performance-analyzer

- `version`: 2.0.0

- `last_updated`: 2026-02-09

- `purpose`: Identify the highest-impact bottlenecks and apply measured optimizations with verifiable improvements.

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

- `goal`: Identify the highest-impact bottlenecks and apply measured optimizations with verifiable improvements.

## Core Principles (`core_principles`)

### Principle (`principle`)
Attributes: name="Measure Before Change"

- `rule`: Capture baseline metrics (p50/p95/p99 latency, throughput, resource utilization) before optimization.

- `rule`: Do not accept optimizations without measurable deltas.

### Principle (`principle`)
Attributes: name="Impact-First Prioritization"

- `rule`: Rank bottlenecks by user impact and system cost, then fix top offenders first.

- `rule`: Prefer 80/20 changes that reduce dominant latency contributors.

### Principle (`principle`)
Attributes: name="One Change at a Time"

- `rule`: Apply optimizations incrementally and re-measure after each change.

- `rule`: Document regressions and rollback if improvements are not sustained.

## Workflow (`workflow`)

### Step (`step`)
Attributes: number="1", name="Establish Baseline"

- `metric`: Response time distribution (p50, p95, p99)

- `metric`: Throughput and error rate

- `metric`: CPU, memory, disk I/O, and database timings

### Step (`step`)
Attributes: number="2", name="Profile and Localize Bottlenecks"

- `instruction`: Use profilers and traces to determine where time and resources are spent.

- `category`: CPU-bound

- `category`: I/O-bound

- `category`: Memory-bound

- `category`: Network-bound

### Step (`step`)
Attributes: number="3", name="Apply Targeted Optimizations"

- `instruction`: Select one optimization from references/optimization-patterns.md and implement it.

- `focus`: Database, API calls, algorithmic complexity, caching, rendering, payload size

### Step (`step`)
Attributes: number="4", name="Re-Measure and Compare"

- `instruction`: Re-run benchmark/profile suite and compare against baseline.

- `output`: Before/after table with quantifiable deltas

### Step (`step`)
Attributes: number="5", name="Document Outcome"

- `instruction`: Record what changed, why it helped, and remaining risks or next bottlenecks.

## Resources (`resources`)

- `reference` (file="references/optimization-patterns.md"): Optimization tactics and quick-win catalog.

## Best Practices (`best_practices`)

- `do`: Use representative workloads for benchmarks

- `do`: Keep performance budgets explicit for critical paths

- `do`: Validate database query plans after schema/index changes

- `do`: Track improvements and regressions in repeatable reports

- `dont`: Optimize based on intuition alone

- `dont`: Ship optimizations that increase complexity without clear gain

- `dont`: Ignore memory pressure when improving pure latency

## Related Skills (`related_skills`)

- `skill`: api-builder

- `skill`: architecture-planner

- `skill`: database-optimizer

## Related Workflows (`related_workflows`)

- `workflow`: /performance-tune

- `workflow`: /analyze
```
