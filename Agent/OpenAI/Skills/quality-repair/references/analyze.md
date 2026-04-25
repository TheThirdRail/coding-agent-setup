# Legacy Lane: analyze

Vendor: OpenAI Codex
Router: `quality-repair`
Source archive: `.\Agent\OpenAI\deprecated-Skills\analyze\SKILL.md`
Consolidated: 2026-04-25

The content below is the former installable skill or workflow body, preserved as an on-demand lane reference.

```markdown
---
name: analyze
description: |
  OpenAI Codex orchestration skill converted from `analyze.md`.
  Use when Encountering a bug or error; Something isn't working as expected; Need to diagnose a problem before fixing.
  Routes to specialized skills and preserves the original execution sequence.
---
# Skill: analyze
Attributes: name="analyze", version="1.0.0"

## Metadata (`metadata`)

- `keywords`: workflow, orchestration, analyze, openai, codex

- `source_workflow`: analyze.md

## Spec Contract (`spec_contract`)

- `id`: analyze

- `name`: analyze

- `version`: 1.0.0

- `last_updated`: 2026-02-09

- `purpose`: Analyze Mode - Debug issues and diagnose problems with maximum reasoning depth

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

- `goal`: Analyze Mode - Debug issues and diagnose problems with maximum reasoning depth

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

- `rule`: DO NOT write implementation code in this workflow

- `rule`: DO NOT modify source files (read-only diagnosis)

- `rule`: Focus ONLY on diagnosing the root cause

- `rule`: Switch to /fix-issue to apply fixes

## Workflow (`workflow`)

### Step (`step`)
Attributes: number="1", name="Assess the Issue"

- `instruction`: Proceed directly to research Restate the issue and ask "Is this correct?" before proceeding

### Step (`step`)
Attributes: number="2", name="Research and Gather Context"

- `instruction`: Use for documentation and code examples Use if diagnosing performance issues File search and code inspection Web search for similar issues Log analysis Error message research Check relevant documentation

### Step (`step`)
Attributes: number="3", name="Hypothesize Causes"

- `instruction`: Generate a ranked list of possible causes from most to least likely ## Analysis Report **Issue:** [One-sentence summary] ### Possible Causes (Ranked) 1. **[Most Likely]** — [Why] — [How to verify] — [Suggested fix] 2. **[Next Most Likely...

### Step (`step`)
Attributes: number="4", name="Recommend Next Steps"

- `instruction`: Provide a clear diagnostic plan Recommend switching to /fix-issue to implement the fix If multiple approaches exist, ask user preference

### Step (`step`)
Attributes: number="5", name="Prepare for Verification"

- `instruction`: Define how the fix should be verified Suggest test cases to run Confirm readiness to switch workflows

## Best Practices (`best_practices`)

- `do`: Summarize progress after each major phase when the task is long-running.

- `do`: Use specialized skills where referenced for domain-specific quality.

- `do`: Invoke related skill `performance-analyzer` when that capability is required.

- `do`: Invoke related skill `research` when deeper validated research is required.

- `dont`: Skip validation or testing steps when the workflow defines them.

- `dont`: Expand scope beyond the workflow objective without explicit user direction.

## Related Skills (`related_skills`)

- `skill`: performance-analyzer

- `skill`: research
```
