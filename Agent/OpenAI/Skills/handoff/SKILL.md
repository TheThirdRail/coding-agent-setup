---
name: handoff
description: |
  OpenAI Codex orchestration skill converted from `handoff.md`.
  Use when End of work session; Before going on vacation; Passing work to a teammate.
  Routes to specialized skills and preserves the original execution sequence.
---
# Skill: handoff
Attributes: name="handoff", version="1.0.0"

## Metadata (`metadata`)

- `keywords`: workflow, orchestration, handoff, openai, codex

- `source_workflow`: handoff.md

## Spec Contract (`spec_contract`)

- `id`: handoff

- `name`: handoff

- `version`: 1.0.0

- `last_updated`: 2026-02-09

- `purpose`: End-of-session summary for handing off work to yourself tomorrow or a teammate

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

- `goal`: End-of-session summary for handing off work to yourself tomorrow or a teammate

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

### Principle (`principle`)
Attributes: name="Source Constraints"

- `rule`: DO NOT write implementation code

- `rule`: DO NOT modify source files

- `rule`: Focus ONLY on updating status and creating handoff notes in Agent-Context/Communications/Agent-Notes/

## Workflow (`workflow`)

### Step (`step`)
Attributes: number="1", name="Summarize What Was Done"

- `instruction`: What features were added? What bugs were fixed? What was changed?

### Step (`step`)
Attributes: number="2", name="Identify What's In Progress"

- `instruction`: What's partially complete? What was the approach being taken?

### Step (`step`)
Attributes: number="3", name="Document Dead Ends & Failed Attempts"

- `instruction`: What approaches were tried and failed? Why did they fail? (Technical limitation, complexity, etc.) What shouldn't be tried again?

### Step (`step`)
Attributes: number="4", name="List Blockers"

- `instruction`: Waiting on someone else? Need more information? Technical obstacle?

### Step (`step`)
Attributes: number="5", name="Note Next Steps"

- `instruction`: Numbered list of next actions in priority order

### Step (`step`)
Attributes: number="6", name="Flag Any Gotchas"

- `instruction`: "Don't run X without doing Y first" "This file is temporarily broken" "That approach didn't work because..."

### Step (`step`)
Attributes: number="7", name="Check Branch State"

- `instruction`: git status git log --oneline -5

- `command`: git status

- `command`: git log --oneline -5

### Step (`step`)
Attributes: number="8", name="Create Handoff Document"

- `instruction`: Write summary to Agent-Context/Communications/Agent-Notes/HANDOFF.yaml (YAML format for agent consumption) Include date/time Commit if appropriate

## Best Practices (`best_practices`)

- `do`: Summarize progress after each major phase when the task is long-running.

- `do`: Use specialized skills where referenced for domain-specific quality.

- `dont`: Skip validation or testing steps when the workflow defines them.

- `dont`: Expand scope beyond the workflow objective without explicit user direction.

- `related_skills`
