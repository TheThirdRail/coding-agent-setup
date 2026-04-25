# Legacy Lane: performance-tune

Vendor: OpenAI Codex
Router: `quality-repair`
Source archive: `.\Agent\OpenAI\deprecated-Skills\performance-tune\SKILL.md`
Consolidated: 2026-04-25

The content below is the former installable skill or workflow body, preserved as an on-demand lane reference.

```markdown
---
name: performance-tune
description: |
  OpenAI Codex orchestration skill converted from `performance-tune.md`.
  Use when Application is slow and needs optimization; Preparing for expected traffic increase; Performance budget exceeded.
  Routes to specialized skills and preserves the original execution sequence.
---
# Skill: performance-tune
Attributes: name="performance-tune", version="1.0.0"

## Metadata (`metadata`)

- `keywords`: workflow, orchestration, performance-tune, openai, codex

- `source_workflow`: performance-tune.md

## Spec Contract (`spec_contract`)

- `id`: performance-tune

- `name`: performance-tune

- `version`: 1.0.0

- `last_updated`: 2026-02-09

- `purpose`: Systematic performance optimization workflow with benchmarking

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

- `goal`: Systematic performance optimization workflow with benchmarking

## Core Principles (`core_principles`)

### Principle (`principle`)
Attributes: name="Orchestrate First"

- `rule`: Act as an orchestration skill: sequence actions, call specialized skills, and keep task focus.

### Principle (`principle`)
Attributes: name="Deterministic Flow"

- `rule`: Follow the ordered step flow from the source workflow unless constraints require adaptation.

### Principle (`principle`)
Attributes: name="Validation Before Completion"

- `rule`: Require verification checks before marking the workflow complete.

## Workflow (`workflow`)

### Step (`step`)
Attributes: number="1", name="Define Performance Goals"

- `instruction`: Establish concrete, measurable targets API response time under 200ms (p95) Page load time under 3 seconds Support 1000 concurrent users What specific metric needs to improve?

### Step (`step`)
Attributes: number="2", name="Establish Baseline"

- `instruction`: Measure current performance before any changes Run performance tests or load tests Capture metrics (response time, throughput, resource usage) Document baseline numbers | Metric | Current | Target | |--------|---------|--------| | p95 la...

### Step (`step`)
Attributes: number="3", name="Profile and Identify Bottlenecks"

- `instruction`: Use profiling tools to find where time is spent Run profiler on slow paths Analyze database query times Check for N+1 queries Review external API call latency Ranked list of top 3 bottlenecks

### Step (`step`)
Attributes: number="4", name="Optimize Bottleneck #1"

- `instruction`: Address the highest-impact issue Add database indexes Implement caching Optimize algorithm Parallelize I/O operations Reduce payload size

### Step (`step`)
Attributes: number="5", name="Benchmark After Change"

- `instruction`: Re-run performance tests and measure improvement Ensure no functionality regressions | Metric | Before | After | Improvement | |--------|--------|-------|-------------| | Target metric | X | Y | Z% |

### Step (`step`)
Attributes: number="6", name="Repeat for Remaining Bottlenecks"

- `instruction`: Apply same process for bottlenecks #2 and #3 Stop when performance goal is reached

### Step (`step`)
Attributes: number="7", name="Final Benchmark"

- `instruction`: Run comprehensive performance test suite ## Performance Optimization Report **Before:** [baseline metrics] **After:** [final metrics] **Improvement:** [percentage gains] ### Optimizations Applied 1. [What was done] → [Impact] 2. [What wa...

### Step (`step`)
Attributes: number="8", name="Document and Monitor"

- `instruction`: Record optimizations for future reference Document what was optimized and why Set up performance monitoring/alerts Schedule periodic performance reviews

## Best Practices (`best_practices`)

- `do`: Summarize progress after each major phase when the task is long-running.

- `do`: Use specialized skills where referenced for domain-specific quality.

- `dont`: Skip validation or testing steps when the workflow defines them.

- `dont`: Expand scope beyond the workflow objective without explicit user direction.

- `related_skills`
```
