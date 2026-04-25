# Legacy Lane: dependency-check

Vendor: OpenAI Codex
Router: `quality-repair`
Source archive: `.\Agent\OpenAI\deprecated-Skills\dependency-check\SKILL.md`
Consolidated: 2026-04-25

The content below is the former installable skill or workflow body, preserved as an on-demand lane reference.

```markdown
---
name: dependency-check
description: |
  OpenAI Codex orchestration skill converted from `dependency-check.md`.
  Use when Monthly maintenance; Before major releases; After security advisories.
  Routes to specialized skills and preserves the original execution sequence.
---
# Skill: dependency-check
Attributes: name="dependency-check", version="1.0.0"

## Metadata (`metadata`)

- `keywords`: workflow, orchestration, dependency-check, openai, codex

- `source_workflow`: dependency-check.md

## Spec Contract (`spec_contract`)

- `id`: dependency-check

- `name`: dependency-check

- `version`: 1.0.0

- `last_updated`: 2026-02-09

- `purpose`: Check for outdated or vulnerable dependencies and update them safely

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

- `goal`: Check for outdated or vulnerable dependencies and update them safely

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
Attributes: number="1", name="Check for Vulnerabilities"

- `instruction`: npm audit

- `command`: npm audit

### Step (`step`)
Attributes: number="2", name="Check for Outdated Packages"

- `instruction`: npm outdated

- `command`: npm outdated

### Step (`step`)
Attributes: number="3", name="Review the Results"

- `instruction`: Update immediately Update soon Update when convenient Review changelog first!

### Step (`step`)
Attributes: number="4", name="Update Safe Packages First"

- `instruction`: Patch and minor versions npm update

- `command`: npm update

### Step (`step`)
Attributes: number="5", name="Handle Major Updates Carefully"

- `instruction`: Read the changelog/migration guide Update one package Run tests Commit if passing

### Step (`step`)
Attributes: number="6", name="Run Full Test Suite"

- `instruction`: npm test

- `command`: npm test

### Step (`step`)
Attributes: number="7", name="Document Changes"

- `instruction`: List updated packages Note any breaking changes handled Commit with clear message

## Best Practices (`best_practices`)

- `do`: Summarize progress after each major phase when the task is long-running.

- `do`: Use specialized skills where referenced for domain-specific quality.

- `dont`: Skip validation or testing steps when the workflow defines them.

- `dont`: Expand scope beyond the workflow objective without explicit user direction.

- `related_skills`
```
