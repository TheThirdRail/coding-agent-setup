# Legacy Lane: documentation-generator

Vendor: Google Antigravity
Router: `research-docs`
Source archive: `.\Agent\Google\deprecated-Skills\documentation-generator\SKILL.md`
Consolidated: 2026-04-25

The content below is the former installable skill or workflow body, preserved as an on-demand lane reference.

```markdown
---
name: documentation-generator
description: |
  Generate maintainable project documentation from source code, architecture,
  and runtime behavior. Use when creating or updating README, API references,
  ADRs, deployment guides, or troubleshooting docs that must stay accurate.
---

<skill name="documentation-generator" version="2.0.0">
  <metadata>
    <keywords>documentation, readme, api-docs, adr, deployment, troubleshooting</keywords>
  </metadata>

  <goal>Produce clear, accurate documentation artifacts that reduce onboarding and operational friction.</goal>

  <core_principles>
    <principle name="Audience-First Writing">
      <rule>Document for the intended reader (developer, operator, end user) with explicit assumptions.</rule>
      <rule>Match depth to audience skill level and use case urgency.</rule>
    </principle>

    <principle name="Source Traceability">
      <rule>Derive statements from code, configs, tests, and observed behavior whenever possible.</rule>
      <rule>Flag unknowns instead of inventing details.</rule>
    </principle>

    <principle name="Template Discipline">
      <rule>Use canonical templates from references/templates.md for consistency.</rule>
      <rule>Remove placeholders before output is finalized.</rule>
    </principle>
  </core_principles>

  <workflow>
    <step number="1" name="Identify Document Type">
      <option>README</option>
      <option>API Reference</option>
      <option>Architecture Decision Record (ADR)</option>
      <option>Deployment Guide</option>
      <option>Troubleshooting Guide</option>
      <option>Changelog Entry</option>
    </step>

    <step number="2" name="Lock Audience and Scope">
      <instruction>Define who will read the document and what decisions/tasks it must support.</instruction>
      <check>Audience is explicit (developers, ops, support, end users)</check>
      <check>Scope excludes speculative or unrelated sections</check>
    </step>

    <step number="3" name="Gather Ground Truth">
      <source>Source code and interfaces</source>
      <source>Configuration and environment files</source>
      <source>Tests and examples</source>
      <source>Existing docs and runbooks</source>
    </step>

    <step number="4" name="Draft Using Canonical Templates">
      <instruction>Load structure and examples from references/templates.md.</instruction>
      <quality_check>Code snippets are executable or clearly marked pseudocode</quality_check>
      <quality_check>No unresolved placeholders or TODO markers</quality_check>
      <quality_check>Version and dependency details are current</quality_check>
    </step>

    <step number="5" name="Finalize and Verify">
      <instruction>Run consistency pass for terminology, links, commands, and headings.</instruction>
      <output>Documentation artifact ready for review or commit</output>
    </step>
  </workflow>

  <resources>
    <reference file="references/templates.md">Canonical README, ADR, API endpoint, and changelog templates.</reference>
  </resources>

  <best_practices>
    <do>Prefer concise, actionable sections over narrative filler</do>
    <do>Include runnable examples with expected output where feasible</do>
    <do>Keep language consistent with code and config naming</do>
    <do>Record assumptions and constraints explicitly</do>
    <dont>Ship placeholders, stale versions, or unverified commands</dont>
    <dont>Duplicate large template payloads directly in SKILL.md</dont>
  </best_practices>

  <related_skills>
    <skill>api-builder</skill>
    <skill>architecture-planner</skill>
  </related_skills>

  <related_workflows>
    <workflow>/tutor</workflow>
    <workflow>/handoff</workflow>
  </related_workflows>
</skill>
```

## Operational Documentation Updates

- Update README, setup, or runbook docs when behavior, commands, environment variables, install paths, or setup flow changes.
- Document only what future users or agents need to operate or maintain the project.
- Keep implementation details concise and remove placeholders before completion.
