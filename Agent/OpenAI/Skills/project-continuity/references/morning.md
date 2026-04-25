# Legacy Lane: morning

Vendor: OpenAI Codex
Router: `project-continuity`
Source archive: `.\Agent\OpenAI\deprecated-Skills\morning\SKILL.md`
Consolidated: 2026-04-25

The content below is the former installable skill or workflow body, preserved as an on-demand lane reference.

```markdown
---
name: morning
description: |
  OpenAI Codex orchestration skill converted from `morning.md`.
  Use when Start of each work day; After being away from the project; When returning to a project after a break.
  Routes to specialized skills and preserves the original execution sequence.
---
# Skill: morning
Attributes: name="morning", version="1.0.0"

## Metadata (`metadata`)

- `keywords`: workflow, orchestration, morning, openai, codex

- `source_workflow`: morning.md

## Spec Contract (`spec_contract`)

- `id`: morning

- `name`: morning

- `version`: 1.0.0

- `last_updated`: 2026-02-09

- `purpose`: Daily startup routine - sync code, check status, prepare for work

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

- `goal`: Daily startup routine - sync code, check status, prepare for work

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
Attributes: number="1", name="Sync with Remote"

- `instruction`: git fetch --all git pull

- `command`: git fetch --all

- `command`: git pull

### Step (`step`)
Attributes: number="2", name="Check Branch Status"

- `instruction`: git status git branch -v

- `command`: git status

- `command`: git branch -v

### Step (`step`)
Attributes: number="3", name="Install Dependencies"

- `instruction`: npm install

- `command`: npm install

### Step (`step`)
Attributes: number="4", name="Run Tests"

- `instruction`: npm test

- `command`: npm test

### Step (`step`)
Attributes: number="5", name="Check for Stashed Work"

- `instruction`: git stash list

- `command`: git stash list

### Step (`step`)
Attributes: number="6", name="Review TODO/Handoff"

- `instruction`: Read HANDOFF.md if it exists Check issue tracker Review any notes from yesterday

### Step (`step`)
Attributes: number="7", name="Plan the Day"

- `instruction`: Pick 1-3 priorities Estimate time needed Identify any blockers

## Best Practices (`best_practices`)

- `do`: Summarize progress after each major phase when the task is long-running.

- `do`: Use specialized skills where referenced for domain-specific quality.

- `dont`: Skip validation or testing steps when the workflow defines them.

- `dont`: Expand scope beyond the workflow objective without explicit user direction.

- `related_skills`
```
