# Legacy Lane: architect

Vendor: OpenAI Codex
Router: `architect`
Source archive: `.\Agent\OpenAI\deprecated-Skills\architect\SKILL.md`
Consolidated: 2026-04-25

The content below is the former installable skill or workflow body, preserved as an on-demand lane reference.

```markdown
---
name: architect
description: |
  OpenAI Codex orchestration skill converted from `architect.md`.
  Use when User says "I have an idea"; User says "Help me plan"; Ambiguous requirements needing clarification.
  Routes to specialized skills and preserves the original execution sequence.
---
# Skill: architect
Attributes: name="architect", version="1.0.0"

## Metadata (`metadata`)

- `keywords`: workflow, orchestration, architect, openai, codex

- `source_workflow`: architect.md

## Spec Contract (`spec_contract`)

- `id`: architect

- `name`: architect

- `version`: 1.0.0

- `last_updated`: 2026-02-09

- `purpose`: Architect Mode - Plan and design a new feature or project from scratch

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

- `goal`: Architect Mode - Plan and design a new feature or project from scratch

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

- `rule`: DO NOT write implementation code (use /code workflow for that)

- `rule`: DO NOT create source files (only config, docs, and scaffolding)

- `rule`: Focus ONLY on planning, structure, and documentation

## Workflow (`workflow`)

### Step (`step`)
Attributes: number="1", name="Clarify Vision"

- `instruction`: Ask open-ended questions to understand the "What" and "Why". Identify the user's ultimate goal and success criteria. "What problem are we solving?" "Who is this for?" Agree on the "MVP" (Minimum Viable Product) features. Determine techni...

### Step (`step`)
Attributes: number="2", name="Clarify Requirements"

- `instruction`: Ask questions about scope, requirements, and constraints DO NOT proceed until critical questions are answered Understand the user's vision completely

### Step (`step`)
Attributes: number="3", name="Research Best Practices"

- `instruction`: Use this skill for contextual information gathering Research current best practices for the relevant tech stack Research project structure conventions Research security and performance best practices Document findings for reference

### Step (`step`)
Attributes: number="4", name="Design Architecture"

- `instruction`: Use this skill for diagrams and ADRs Use this skill for UI/UX and component design Use this skill for API, database, and security design Create high-level architecture including tech stack decisions Define file/folder structure Create da...

### Step (`step`)
Attributes: number="5", name="Generate Documentation"

- `instruction`: Goals, user stories, acceptance criteria, technical requirements, scope Phased implementation plan with atomic, checkable tasks Tech stack, coding conventions, linting rules, naming conventions

### Step (`step`)
Attributes: number="6", name="Index the Project"

- `instruction`: Store architectural decisions Index code relationships Vector search for docs

### Step (`step`)
Attributes: number="7", name="Track Tasks"

- `instruction`: Register checklist items with task manager if available Otherwise, use checklist.md as the source of truth

## Best Practices (`best_practices`)

- `do`: Summarize progress after each major phase when the task is long-running.

- `do`: Use specialized skills where referenced for domain-specific quality.

- `do`: Invoke related skill `architecture-planner` when that capability is required.

- `do`: Invoke related skill `backend-architect` when that capability is required.

- `do`: Invoke related skill `frontend-architect` when that capability is required.

- `do`: Invoke related skill `research` when deeper validated research is required.

- `dont`: Skip validation or testing steps when the workflow defines them.

- `dont`: Expand scope beyond the workflow objective without explicit user direction.

## Related Skills (`related_skills`)

- `skill`: architecture-planner

- `skill`: backend-architect

- `skill`: frontend-architect

- `skill`: research
```
