# Legacy Lane: security-audit

Vendor: OpenAI Codex
Router: `quality-repair`
Source archive: `.\Agent\OpenAI\deprecated-Skills\security-audit\SKILL.md`
Consolidated: 2026-04-25

The content below is the former installable skill or workflow body, preserved as an on-demand lane reference.

```markdown
---
name: security-audit
description: |
  OpenAI Codex orchestration skill converted from `security-audit.md`.
  Use when Before releasing to production; After adding authentication or payment features; Regular monthly security check.
  Routes to specialized skills and preserves the original execution sequence.
---
# Skill: security-audit
Attributes: name="security-audit", version="1.0.0"

## Metadata (`metadata`)

- `keywords`: workflow, orchestration, security-audit, openai, codex, security

- `source_workflow`: security-audit.md

## Spec Contract (`spec_contract`)

- `id`: security-audit

- `name`: security-audit

- `version`: 1.0.0

- `last_updated`: 2026-02-09

- `purpose`: Scan codebase for security vulnerabilities, exposed secrets, and risky patterns

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

- `goal`: Scan codebase for security vulnerabilities, exposed secrets, and risky patterns

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
Attributes: number="1", name="Run Security Checker Skill"

- `instruction`: Invoke full security analysis The skill handles: secret scanning, injection checks, auth review, input validation. Review the skill's prioritized findings before proceeding.

### Step (`step`)
Attributes: number="2", name="Check Dependencies"

- `instruction`: npm audit pip-audit Run appropriate command based on project type.

- `command`: npm audit

- `command`: pip-audit

### Step (`step`)
Attributes: number="3", name="Generate Report"

- `instruction`: Compile findings from skill and dependency audit. Prioritize by severity (Critical → High → Medium → Low). Suggest fixes for each issue. Security audit report with prioritized issues and remediation steps.

## Best Practices (`best_practices`)

- `do`: Summarize progress after each major phase when the task is long-running.

- `do`: Use specialized skills where referenced for domain-specific quality.

- `do`: Invoke related skill `security-checker` when that capability is required.

- `dont`: Skip validation or testing steps when the workflow defines them.

- `dont`: Expand scope beyond the workflow objective without explicit user direction.

## Related Skills (`related_skills`)

- `skill`: security-checker
```
