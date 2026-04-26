# Legacy Lane: code

Vendor: OpenAI Codex
Router: `code`
Source archive: `.\Agent\OpenAI\deprecated-Skills\code\SKILL.md`
Consolidated: 2026-04-25

The content below is the former installable skill or workflow body, preserved as an on-demand lane reference.

```markdown
---
name: code
description: |
  OpenAI Codex orchestration skill converted from `code.md`.
  Use when After /architect workflow is complete and approved; User says "let's code" or "start implementing"; Ready to execute on an existing plan.
  Routes to specialized skills and preserves the original execution sequence.
---
# Skill: code
Attributes: name="code", version="1.0.0"

## Metadata (`metadata`)

- `keywords`: workflow, orchestration, code, openai, codex

- `source_workflow`: code.md

## Spec Contract (`spec_contract`)

- `id`: code

- `name`: code

- `version`: 1.0.0

- `last_updated`: 2026-02-09

- `purpose`: Code with Context - Execute implementation with focus on building, minimal discussion

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

- `goal`: Code with Context - Execute implementation with focus on building, minimal discussion

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
Attributes: number="1", name="Load Context"

- `instruction`: Use for API docs and implementation patterns Read checklist.md to understand current progress Read prd.md for requirements Check project_rules.md for conventions Route retrieval through archive-manager and prefer fresh archives before broad source scans

### Step (`step`)
Attributes: number="2", name="Execute Tasks"

- `instruction`: For each task in the checklist: Read before write — Always verify file contents before modifying Implement — Write the code Test — Verify it works Update checklist — Mark task as [x] complete

### Step (`step`)
Attributes: number="3", name="Code Quality Checks"

- `instruction`: Use for self-review of changes Edge cases handled? Error handling complete? No hardcoded secrets or paths? Types properly defined? Functions do ONE thing?

### Step (`step`)
Attributes: number="4", name="Minimize Discussion"

- `instruction`: Don't over-explain obvious changes Focus on non-obvious logic and decisions Keep responses concise Only pause for genuine blockers

### Step (`step`)
Attributes: number="5", name="Update Progress"

- `instruction`: Mark completed tasks in checklist.md. For substantial or durable code/docs/config changes, run archive-manager to sync relevant archive-code/archive-docs/archive-graph/archive-memory artifacts. Note any deferred items.

## Best Practices (`best_practices`)

- `do`: Summarize progress after each major phase when the task is long-running.

- `do`: Use specialized skills where referenced for domain-specific quality.

- `do`: Invoke related skill `code-reviewer` when that capability is required.

- `do`: Invoke related skill `research` when deeper validated research is required.

- `dont`: Skip validation or testing steps when the workflow defines them.

- `dont`: Expand scope beyond the workflow objective without explicit user direction.

## Related Skills (`related_skills`)

- `skill`: code-reviewer

- `skill`: research

- `skill`: archive-manager
```

## Modular Guidance

- Add or update tests for meaningful behavior changes when a test framework exists.
- For bugs, reproduce the failure before fixing when practical.
- For refactors, preserve behavior and verify affected paths before and after when practical.
- Run the narrowest relevant check available and report failed or skipped checks honestly.
- Update usage/setup docs when behavior, commands, environment variables, or setup flow changes.
- Keep implementation notes concise and avoid duplicating global policy here.
