# Legacy Lane: performance-tune

Vendor: Google Antigravity
Router: `quality-repair`
Source archive: `.\Agent\Google\deprecated-Workflows\performance-tune.md`
Consolidated: 2026-04-25

The content below is the former installable skill or workflow body, preserved as an on-demand lane reference.

```markdown
---
description: Systematic performance optimization workflow with benchmarking
---

<workflow name="performance-tune" thinking="MAX">
  <metadata>
    <description>Data-driven performance optimization with measurement before and after</description>
  </metadata>

  <important>Use MAXIMUM thinking/reasoning depth. Profile before optimizing.</important>

  <when_to_use>
    <trigger>Application is slow and needs optimization</trigger>
    <trigger>Preparing for expected traffic increase</trigger>
    <trigger>Performance budget exceeded</trigger>
    <trigger>User complaints about speed</trigger>
  </when_to_use>

  <prerequisite>
    Load the performance-analyzer skill for patterns and techniques.
  </prerequisite>

  <steps>
    <step number="1" name="Define Performance Goals">
      <instruction>Establish concrete, measurable targets</instruction>
      <examples>
        <example>API response time under 200ms (p95)</example>
        <example>Page load time under 3 seconds</example>
        <example>Support 1000 concurrent users</example>
      </examples>
      <question>What specific metric needs to improve?</question>
    </step>

    <step number="2" name="Establish Baseline">
      <instruction>Measure current performance before any changes</instruction>
      <actions>
        <action>Run performance tests or load tests</action>
        <action>Capture metrics (response time, throughput, resource usage)</action>
        <action>Document baseline numbers</action>
      </actions>
      <output>
        | Metric | Current | Target |
        |--------|---------|--------|
        | p95 latency | X ms | Y ms |
        | Throughput | X req/s | Y req/s |
      </output>
    </step>

    <step number="3" name="Profile and Identify Bottlenecks">
      <instruction>Use profiling tools to find where time is spent</instruction>
      <actions>
        <action>Run profiler on slow paths</action>
        <action>Analyze database query times</action>
        <action>Check for N+1 queries</action>
        <action>Review external API call latency</action>
      </actions>
      <output>Ranked list of top 3 bottlenecks</output>
    </step>

    <step number="4" name="Optimize Bottleneck #1">
      <instruction>Address the highest-impact issue</instruction>
      <approaches>
        <approach>Add database indexes</approach>
        <approach>Implement caching</approach>
        <approach>Optimize algorithm</approach>
        <approach>Parallelize I/O operations</approach>
        <approach>Reduce payload size</approach>
      </approaches>
    </step>

    <step number="5" name="Benchmark After Change">
      <instruction>Re-run performance tests and measure improvement</instruction>
      <validation>Ensure no functionality regressions</validation>
      <output>
        | Metric | Before | After | Improvement |
        |--------|--------|-------|-------------|
        | Target metric | X | Y | Z% |
      </output>
    </step>

    <step number="6" name="Repeat for Remaining Bottlenecks">
      <instruction>Apply same process for bottlenecks #2 and #3</instruction>
      <note>Stop when performance goal is reached</note>
    </step>

    <step number="7" name="Final Benchmark">
      <instruction>Run comprehensive performance test suite</instruction>
      <output>
        ## Performance Optimization Report

        **Before:** [baseline metrics]
        **After:** [final metrics]
        **Improvement:** [percentage gains]

        ### Optimizations Applied
        1. [What was done] → [Impact]
        2. [What was done] → [Impact]

        ### Trade-offs Made
        - [Any downsides or considerations]
      </output>
    </step>

    <step number="8" name="Document and Monitor">
      <instruction>Record optimizations for future reference</instruction>
      <actions>
        <action>Document what was optimized and why</action>
        <action>Set up performance monitoring/alerts</action>
        <action>Schedule periodic performance reviews</action>
      </actions>
    </step>
  </steps>

  <success_criteria>
    <criterion>Performance goals met or exceeded</criterion>
    <criterion>No functionality regressions</criterion>
    <criterion>Optimizations documented</criterion>
    <criterion>Monitoring in place</criterion>
  </success_criteria>

  <related_skills>
    <skill>performance-analyzer</skill>
  </related_skills>

  <related_workflows>
    <workflow>/analyze</workflow>
    <workflow>/deploy</workflow>
  </related_workflows>
</workflow>
```
