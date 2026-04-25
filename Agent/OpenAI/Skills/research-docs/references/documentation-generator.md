# Legacy Lane: documentation-generator

Vendor: OpenAI Codex
Router: `research-docs`
Source archive: `.\Agent\OpenAI\deprecated-Skills\documentation-generator\SKILL.md`
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
# Skill: documentation-generator
Attributes: name="documentation-generator", version="2.0.0"

## Metadata (`metadata`)

- `keywords`: documentation, readme, api-docs, adr, deployment, troubleshooting

## Spec Contract (`spec_contract`)

- `id`: documentation-generator

- `name`: documentation-generator

- `version`: 2.0.0

- `last_updated`: 2026-02-09

- `purpose`: Produce clear, accurate documentation artifacts that reduce onboarding and operational friction.

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

- `goal`: Produce clear, accurate documentation artifacts that reduce onboarding and operational friction.

## Core Principles (`core_principles`)

### Principle (`principle`)
Attributes: name="Audience-First Writing"

- `rule`: Document for the intended reader (developer, operator, end user) with explicit assumptions.

- `rule`: Match depth to audience skill level and use case urgency.

### Principle (`principle`)
Attributes: name="Source Traceability"

- `rule`: Derive statements from code, configs, tests, and observed behavior whenever possible.

- `rule`: Flag unknowns instead of inventing details.

### Principle (`principle`)
Attributes: name="Template Discipline"

- `rule`: Use canonical templates from references/templates.md for consistency.

- `rule`: Remove placeholders before output is finalized.

## Workflow (`workflow`)

### Step (`step`)
Attributes: number="1", name="Identify Document Type"

- `option`: README

- `option`: API Reference

- `option`: Architecture Decision Record (ADR)

- `option`: Deployment Guide

- `option`: Troubleshooting Guide

- `option`: Changelog Entry

### Step (`step`)
Attributes: number="2", name="Lock Audience and Scope"

- `instruction`: Define who will read the document and what decisions/tasks it must support.

- `check`: Audience is explicit (developers, ops, support, end users)

- `check`: Scope excludes speculative or unrelated sections

### Step (`step`)
Attributes: number="3", name="Gather Ground Truth"

- `source`: Source code and interfaces

- `source`: Configuration and environment files

- `source`: Tests and examples

- `source`: Existing docs and runbooks

### Step (`step`)
Attributes: number="4", name="Draft Using Canonical Templates"

- `instruction`: Load structure and examples from references/templates.md.

- `quality_check`: Code snippets are executable or clearly marked pseudocode

- `quality_check`: No unresolved placeholders or TODO markers

- `quality_check`: Version and dependency details are current

### Step (`step`)
Attributes: number="5", name="Finalize and Verify"

- `instruction`: Run consistency pass for terminology, links, commands, and headings.

- `output`: Documentation artifact ready for review or commit

## Resources (`resources`)

- `reference` (file="references/templates.md"): Canonical README, ADR, API endpoint, and changelog templates.

## Best Practices (`best_practices`)

- `do`: Prefer concise, actionable sections over narrative filler

- `do`: Include runnable examples with expected output where feasible

- `do`: Keep language consistent with code and config naming

- `do`: Record assumptions and constraints explicitly

- `dont`: Ship placeholders, stale versions, or unverified commands

- `dont`: Duplicate large template payloads directly in SKILL.md

## Related Skills (`related_skills`)

- `skill`: api-builder

- `skill`: architecture-planner

## Related Workflows (`related_workflows`)

- `workflow`: /tutor

- `workflow`: /handoff
```
