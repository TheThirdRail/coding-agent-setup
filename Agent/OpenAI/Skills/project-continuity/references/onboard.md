# Legacy Lane: onboard

Vendor: OpenAI Codex
Router: `project-continuity`
Source archive: `.\Agent\OpenAI\deprecated-Skills\onboard\SKILL.md`
Consolidated: 2026-04-25

The content below is the former installable skill or workflow body, preserved as an on-demand lane reference.

```markdown
---
name: onboard
description: |
  OpenAI Codex orchestration skill converted from `onboard.md`.
  Use when Joining a new project; Inheriting a codebase from another developer; First time working with an unfamiliar repository.
  Routes to specialized skills and preserves the original execution sequence.
---
# Skill: onboard
Attributes: name="onboard", version="1.0.0"

## Metadata (`metadata`)

- `keywords`: workflow, orchestration, onboard, openai, codex

- `source_workflow`: onboard.md

## Spec Contract (`spec_contract`)

- `id`: onboard

- `name`: onboard

- `version`: 1.0.0

- `last_updated`: 2026-02-09

- `purpose`: Systematic onboarding for new or inherited codebases

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

- `goal`: Systematic onboarding for new or inherited codebases

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

- `rule`: DO NOT modify source files (read-only for understanding)

- `rule`: Configuration/scaffolding (e.g. .env) is permitted

## Workflow (`workflow`)

### Step (`step`)
Attributes: number="1", name="Map the Repository"

- `instruction`: Explore directory structure and identify key files Read README.md thoroughly Identify tech stack from package.json, requirements.txt, go.mod, etc. Map high-level architecture (src/, lib/, tests/, docs/) Find configuration files (.env.exa...

### Step (`step`)
Attributes: number="2", name="Understand the Domain"

- `instruction`: Use to look up unfamiliar concepts/patterns Gather business context and domain knowledge Read any documentation in docs/ folder Identify core entities and their relationships Understand user workflows and use cases Map external integrati...

### Step (`step`)
Attributes: number="3", name="Set Up Local Environment"

- `instruction`: Prepare development environment following project conventions Check prerequisites (Node version, Python version, etc.) Install dependencies (npm install, pip install, etc.) Copy .env.example to .env and configure Set up databases if need...

### Step (`step`)
Attributes: number="4", name="Verify Everything Works"

- `instruction`: Run tests and start the application Run test suite: npm test, pytest, go test, etc. Start development server Verify database connections Test 2-3 key user flows manually Tests pass (or you understand why they fail) Application starts wit...

### Step (`step`)
Attributes: number="5", name="Trace Key Code Paths"

- `instruction`: Follow execution from entry point through core functionality Trace a request from entry point to response Understand the data flow (input → processing → output) Identify key abstractions and patterns used Note any complexity or areas nee...

### Step (`step`)
Attributes: number="6", name="Document Findings"

- `instruction`: Create onboarding notes for future reference High-level system description Important files and their purposes Frequently used commands Non-obvious quirks or warnings Things still unclear

### Step (`step`)
Attributes: number="7", name="Identify First Contribution"

- `instruction`: Find a small, low-risk task to start contributing Fix a typo or documentation gap Add a missing test Address a small linting issue Complete a "good first issue" if labeled Build confidence and verify understanding through actual contribu...

## Best Practices (`best_practices`)

- `do`: Summarize progress after each major phase when the task is long-running.

- `do`: Use specialized skills where referenced for domain-specific quality.

- `do`: Invoke related skill `research` when deeper validated research is required.

- `dont`: Skip validation or testing steps when the workflow defines them.

- `dont`: Expand scope beyond the workflow objective without explicit user direction.

## Related Skills (`related_skills`)

- `skill`: research
```
