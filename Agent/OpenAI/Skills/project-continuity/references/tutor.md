# Legacy Lane: tutor

Vendor: OpenAI Codex
Router: `project-continuity`
Source archive: `.\Agent\OpenAI\deprecated-Skills\tutor\SKILL.md`
Consolidated: 2026-04-25

The content below is the former installable skill or workflow body, preserved as an on-demand lane reference.

```markdown
---
name: tutor
description: |
  OpenAI Codex orchestration skill converted from `tutor.md`.
  Use when Learning a new codebase; Wanting to understand how files connect; Teaching someone else the project.
  Routes to specialized skills and preserves the original execution sequence.
---
# Skill: tutor
Attributes: name="tutor", version="1.0.0"

## Metadata (`metadata`)

- `keywords`: workflow, orchestration, tutor, openai, codex

- `source_workflow`: tutor.md

## Spec Contract (`spec_contract`)

- `id`: tutor

- `name`: tutor

- `version`: 1.0.0

- `last_updated`: 2026-02-09

- `purpose`: Tutor Mode - Generate educational documentation for learning the codebase

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

- `goal`: Tutor Mode - Generate educational documentation for learning the codebase

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

- `rule`: Focus ONLY on generating documentation in Agent-Context/Lessons/ folder

## Workflow (`workflow`)

### Step (`step`)
Attributes: number="1", name="Parse Request Type"

- `instruction`: Determine output mode: project overview, single-file explainer, or full-project documentation.

### Step (`step`)
Attributes: number="2", name="Prepare Lesson Workspace"

- `instruction`: Create Agent-Context/Lessons if missing and ensure generated lesson files are not committed unintentionally.

### Step (`step`)
Attributes: number="3", name="Collect Codebase Context"

- `instruction`: Map project structure, entry points, and cross-file dependencies before writing explanations.

### Step (`step`)
Attributes: number="4", name="Generate Project Overview"

- `instruction`: If requested, write PROJECT_OVERVIEW.md with tree view, file purposes, and high-level flow connections.

### Step (`step`)
Attributes: number="5", name="Generate File Explainers"

- `instruction`: If requested, create [filename]_explained.md files with section-by-section explanations and practical modification guidance.

### Step (`step`)
Attributes: number="6", name="Apply Teaching Style Rules"

- `instruction`: Use plain language, define technical terms, include short code snippets, and add "why it matters" context.

### Step (`step`)
Attributes: number="7", name="Validate Outputs"

- `instruction`: Confirm files exist in Agent-Context/Lessons, requested scope is complete, and explanations are understandable.

### Step (`step`)
Attributes: number="8", name="Close with Learning Next Steps"

- `instruction`: Summarize what was documented and suggest next files or topics to study.

## Best Practices (`best_practices`)

- `do`: Summarize progress after each major phase when the task is long-running.

- `do`: Use specialized skills where referenced for domain-specific quality.

- `dont`: Skip validation or testing steps when the workflow defines them.

- `dont`: Expand scope beyond the workflow objective without explicit user direction.

## Related Skills (`related_skills`)

- `skill`: documentation-generator
```
