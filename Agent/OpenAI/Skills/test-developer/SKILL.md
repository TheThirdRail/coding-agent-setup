---
name: test-developer
description: |
  OpenAI Codex orchestration skill converted from `test-developer.md`.
  Use when Building new features that need to be reliable; Fixing bugs (reproduce with test first); When you want confidence the code works.
  Routes to specialized skills and preserves the original execution sequence.
---
# Skill: test-developer
Attributes: name="test-developer", version="1.0.0"

## Metadata (`metadata`)

- `keywords`: workflow, orchestration, test-developer, openai, codex, testing

- `source_workflow`: test-developer.md

## Spec Contract (`spec_contract`)

- `id`: test-developer

- `name`: test-developer

- `version`: 1.0.0

- `last_updated`: 2026-02-09

- `purpose`: Test-Driven Development workflow - write tests first, then implement code to pass them

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

- `goal`: Test-Driven Development workflow - write tests first, then implement code to pass them

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
Attributes: number="1", name="Understand the Requirement"

- `instruction`: Define expected inputs and outputs Identify edge cases

### Step (`step`)
Attributes: number="2", name="Write a Failing Test"

- `instruction`: Use for test structure and patterns Test the simplest case first Use descriptive test names

### Step (`step`)
Attributes: number="3", name="Confirm Test Fails"

- `instruction`: npm test -- --watch

- `command`: npm test -- --watch

### Step (`step`)
Attributes: number="4", name="Write Minimum Code"

- `instruction`: Implement just enough to pass the test Don't over-engineer Focus only on making the test pass

### Step (`step`)
Attributes: number="5", name="Confirm Test Passes"

- `instruction`: npm test

- `command`: npm test

### Step (`step`)
Attributes: number="6", name="Refactor"

- `instruction`: Improve readability Remove duplication Keep tests passing!

### Step (`step`)
Attributes: number="7", name="Repeat"

- `instruction`: Go back to step 2 for the next test case Add edge cases Add error handling Build up coverage

## Best Practices (`best_practices`)

- `do`: Summarize progress after each major phase when the task is long-running.

- `do`: Use specialized skills where referenced for domain-specific quality.

- `do`: Invoke related skill `test-generator` when that capability is required.

- `dont`: Skip validation or testing steps when the workflow defines them.

- `dont`: Expand scope beyond the workflow objective without explicit user direction.

## Related Skills (`related_skills`)

- `skill`: test-generator
