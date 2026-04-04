---
name: pr
description: |
  OpenAI Codex orchestration skill converted from `pr.md`.
  Use when When code is ready for review; When a feature or fix is complete; Before merging to main branch.
  Routes to specialized skills and preserves the original execution sequence.
---
# Skill: pr
Attributes: name="pr", version="1.0.0"

## Metadata (`metadata`)

- `keywords`: workflow, orchestration, pr, openai, codex

- `source_workflow`: pr.md

## Spec Contract (`spec_contract`)

- `id`: pr

- `name`: pr

- `version`: 1.0.0

- `last_updated`: 2026-02-09

- `purpose`: Create a pull request with proper description, tests verified, and ready for review

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

- `goal`: Create a pull request with proper description, tests verified, and ready for review

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
Attributes: number="1", name="Verify Tests Pass"

- `instruction`: npm test

- `command`: npm test

### Step (`step`)
Attributes: number="2", name="Run Linter"

- `instruction`: npm run lint

- `command`: npm run lint

### Step (`step`)
Attributes: number="3", name="Check What's Changed"

- `instruction`: git diff main --stat

- `command`: git diff main --stat

### Step (`step`)
Attributes: number="4", name="Clean Up Commits"

- `instruction`: Combine "WIP" commits Write clear commit messages Each commit should be meaningful

### Step (`step`)
Attributes: number="5", name="Push Branch"

- `instruction`: git push -u origin HEAD

- `command`: git push -u origin HEAD

### Step (`step`)
Attributes: number="6", name="Generate PR Description"

- `instruction`: ## What [Brief description of what this PR does] ## Why [Why this change is needed - link to issue if applicable] ## How [How the change works, key implementation details] ## Testing - [ ] Unit tests added/updated - [ ] Manual testing co...

### Step (`step`)
Attributes: number="7", name="Create the PR"

- `instruction`: Use the generated description Add appropriate labels Request reviewers

### Step (`step`)
Attributes: number="8", name="Self-Review"

- `instruction`: Use for systematic self-review Review the diff in the PR interface Check for accidental debug code Verify no secrets are exposed

## Best Practices (`best_practices`)

- `do`: Summarize progress after each major phase when the task is long-running.

- `do`: Use specialized skills where referenced for domain-specific quality.

- `do`: Invoke related skill `code-reviewer` when that capability is required.

- `dont`: Skip validation or testing steps when the workflow defines them.

- `dont`: Expand scope beyond the workflow objective without explicit user direction.

## Related Skills (`related_skills`)

- `skill`: code-reviewer
