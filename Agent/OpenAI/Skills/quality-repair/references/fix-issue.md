# Legacy Lane: fix-issue

Vendor: OpenAI Codex
Router: `quality-repair`
Source archive: `.\Agent\OpenAI\deprecated-Skills\fix-issue\SKILL.md`
Consolidated: 2026-04-25

The content below is the former installable skill or workflow body, preserved as an on-demand lane reference.

```markdown
---
name: fix-issue
description: |
  OpenAI Codex orchestration skill converted from `fix-issue.md`.
  Use when When assigned a GitHub issue; When picking up a bug report; Usage: /fix-issue 123 where 123 is the issue number.
  Routes to specialized skills and preserves the original execution sequence.
---
# Skill: fix-issue
Attributes: name="fix-issue", version="1.0.0"

## Metadata (`metadata`)

- `keywords`: workflow, orchestration, fix-issue, openai, codex

- `source_workflow`: fix-issue.md

## Spec Contract (`spec_contract`)

- `id`: fix-issue

- `name`: fix-issue

- `version`: 1.0.0

- `last_updated`: 2026-02-09

- `purpose`: Fix a GitHub issue - analyze, implement, test, and create PR

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

- `goal`: Fix a GitHub issue - analyze, implement, test, and create PR

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
Attributes: number="1", name="Fetch Issue Details"

- `instruction`: Read the issue description Check comments for additional context Look at any linked issues or PRs

### Step (`step`)
Attributes: number="2", name="Create a Branch"

- `instruction`: git checkout main git pull git checkout -b fix/issue-$ARGUMENTS

- `command`: git checkout main

- `command`: git pull

- `command`: git checkout -b fix/issue-$ARGUMENTS

### Step (`step`)
Attributes: number="3", name="Reproduce the Problem"

- `instruction`: Follow the reproduction steps Understand when it happens Note expected vs actual behavior

### Step (`step`)
Attributes: number="4", name="Find the Cause"

- `instruction`: Search for relevant files Add logging if needed Identify the root cause (not just symptoms)

### Step (`step`)
Attributes: number="5", name="Plan the Fix"

- `instruction`: What changes are needed? Any side effects to watch for? Keep the fix minimal and focused

### Step (`step`)
Attributes: number="6", name="Write a Test"

- `instruction`: Use for creating regression test Write a test that fails with the bug This prevents regression later

### Step (`step`)
Attributes: number="7", name="Implement the Fix"

- `instruction`: Follow existing code style Keep changes minimal Comment non-obvious decisions

### Step (`step`)
Attributes: number="8", name="Run Tests"

- `instruction`: npm test

- `command`: npm test

### Step (`step`)
Attributes: number="9", name="Update Archives"

- `instruction`: Route through archive-manager and refresh relevant archives for the changed code/docs before closing the issue workflow.

### Step (`step`)
Attributes: number="10", name="Commit with Reference"

- `instruction`: Use for conventional commit message git add . git commit -m "fix: [description] Fixes #$ARGUMENTS"

- `command`: git add .

- `command`: git commit -m "fix: [description] Fixes #$ARGUMENTS"

### Step (`step`)
Attributes: number="11", name="Create PR"

- `instruction`: Reference the issue in the PR Explain what was wrong and how it was fixed Use /pr workflow if needed

## Best Practices (`best_practices`)

- `do`: Summarize progress after each major phase when the task is long-running.

- `do`: Use specialized skills where referenced for domain-specific quality.

- `do`: Invoke related skill `git-commit-generator` when that capability is required.

- `do`: Invoke related skill `test-generator` when that capability is required.

- `dont`: Skip validation or testing steps when the workflow defines them.

- `dont`: Expand scope beyond the workflow objective without explicit user direction.

## Related Skills (`related_skills`)

- `skill`: git-commit-generator

- `skill`: test-generator

- `skill`: archive-manager
```
