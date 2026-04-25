# Legacy Lane: automation-builder

Vendor: Google Antigravity
Router: `agent-builder`
Source archive: `.\Agent\OpenAI\deprecated-Skills\automation-builder\SKILL.md`
Consolidated: 2026-04-25

The content below is the former installable skill or workflow body, preserved as an on-demand lane reference.

```markdown
---
name: automation-builder
description: |
  Build and maintain OpenAI Codex automation templates with clear schedule metadata
  and explicit skill invocation. Use when creating recurring automations, converting
  repeated workflows into automation templates, or updating existing automation files.
---
# Skill: automation-builder
Attributes: name="automation-builder", version="1.0.0"

## Metadata (`metadata`)

- `keywords`: automation, codex, schedules, templates, openai, recurring

## Spec Contract (`spec_contract`)

- `id`: automation-builder

- `name`: automation-builder

- `version`: 1.0.0

- `last_updated`: 2026-02-09

- `purpose`: Create and update OpenAI-compatible automation templates that call skills deterministically.

### Inputs (`inputs`)

- `input`: Recurring task objective, frequency, trigger conditions, and target skills.

### Outputs (`outputs`)

- `output`: Automation template markdown files and updated usage notes.

### Triggers (`triggers`)

- `trigger`: Use when recurring tasks should be captured as Codex automation templates.

- `procedure`: Define the recurring intent, map to skills, generate template, and validate schedule metadata.

### Edge Cases (`edge_cases`)

- `edge_case`: If recurrence is unclear, default to manual trigger and document assumptions.

### Safety Constraints (`safety_constraints`)

- `constraint`: Avoid automations that imply destructive actions without explicit confirmation steps.

### Examples (`examples`)

- `example`: Create weekly dependency-check and security-audit automation templates that invoke named skills.

- `goal`: Create reliable Codex automation templates for recurring tasks using explicit skill routing and schedule hints.

## Core Principles (`core_principles`)

### Principle (`principle`)
Attributes: name="Skill-First Automation"

- `rule`: Automation templates should invoke skills (`$skill-name`) rather than duplicating full procedures.

### Principle (`principle`)
Attributes: name="Deterministic Template Layout"

- `rule`: Use consistent field order and wording so template diffs remain small and reviewable.

### Principle (`principle`)
Attributes: name="Safe Recurrence Defaults"

- `rule`: Prefer conservative schedules when confidence is low (manual or weekly over aggressive cadence).

## Workflow (`workflow`)

### Step (`step`)
Attributes: number="1", name="Capture Automation Intent"

- `instruction`: Define objective, expected output, trigger cadence, and owner expectations.

### Step (`step`)
Attributes: number="2", name="Map Task To Skills"

- `instruction`: Select one primary skill and optional supporting skills for each automation template.

### Step (`step`)
Attributes: number="3", name="Draft Template Content"

- `instruction`: Write markdown template that includes prompt context, explicit skill call, and completion criteria.

### Step (`step`)
Attributes: number="4", name="Attach Schedule Metadata"

- `instruction`: Set clear schedule hints (daily, weekly, monthly, event-based, manual) in deterministic format.

### Step (`step`)
Attributes: number="5", name="Place Output"

- `instruction`: Write templates under `Agent/OpenAI/Automations/` using stable names.

### Step (`step`)
Attributes: number="6", name="Validate Consistency"

- `instruction`: Ensure referenced skills exist and template scope matches intended recurrence.

### Step (`step`)
Attributes: number="7", name="Install Automation"

- `instruction`: Move the automation template to the appropriate location.

#### Decision Tree (`decision_tree`)

##### Branch (`branch`)
Attributes: condition="Global Automation (apply across projects)"

- `action`: Run: scripts/move-global-automation.ps1 -Name "automation-name.automation.md" -Vendor "openai|anthropic|google"

##### Branch (`branch`)
Attributes: condition="Workspace Automation (apply to current project)"

- `action`: Run: scripts/move-local-automation.ps1 -Name "automation-name.automation.md" -Vendor "mine|openai|anthropic|google"

## Resource Folders (`resource_folders`)

### Folder (`folder`)
Attributes: name="scripts/", purpose="Automation installation utilities"

- `file`: move-global-automation.ps1

- `file`: move-local-automation.ps1

## Best Practices (`best_practices`)

- `do`: Keep each automation template focused on one recurring job.

- `do`: Use explicit `$skill-name` calls in template instructions.

- `do`: Document manual fallback for tasks with uncertain cadence.

- `dont`: Embed large workflow logic directly in automation files.

- `dont`: Create schedules that trigger expensive tasks unnecessarily often.

## Related Skills (`related_skills`)

- `skill`: workflow-builder

- `skill`: skill-builder

- `skill`: openai-rule-builder
```
