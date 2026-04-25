# Legacy Lane: workflow-builder

Vendor: OpenAI Codex
Router: `agent-builder`
Source archive: `.\Agent\OpenAI\deprecated-Skills\workflow-builder\SKILL.md`
Consolidated: 2026-04-25

The content below is the former installable skill or workflow body, preserved as an on-demand lane reference.

```markdown
---
name: workflow-builder
description: |
  Create reusable agent workflows with clear numbered steps, turbo-safe
  automation, and portable install targets. Use when defining repeatable
  operational or engineering procedures that should run consistently.
---
# Skill: workflow-builder
Attributes: name="workflow-builder", version="2.0.0"

## Metadata (`metadata`)

- `keywords`: workflows, meta, template, builder, automation

## Spec Contract (`spec_contract`)

- `id`: workflow-builder

- `name`: workflow-builder

- `version`: 2.0.0

- `last_updated`: 2026-02-09

- `purpose`: Guide creation of AI agent workflows with clear numbered steps, turbo annotations, and placeholders.

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

- `goal`: Guide creation of AI agent workflows with clear numbered steps, turbo annotations, and placeholders.

## Core Principles (`core_principles`)

### Principle (`principle`)
Attributes: name="Clarity First"

- `rule`: Each step should be a single, clear action

- `rule`: Use numbered steps for sequencing

- `rule`: Keep workflows under 10 steps

### Principle (`principle`)
Attributes: name="Safe Automation"

- `rule`: Use // turbo only for safe, reversible commands

- `rule`: Never auto-execute destructive operations

- `rule`: Always allow manual override

### Principle (`principle`)
Attributes: name="Reusability"

- `rule`: Use placeholders like [ComponentName] or $ARGUMENTS

- `rule`: Document prerequisites clearly

- `rule`: Include success criteria

## Workflow (`workflow`)

### Step (`step`)
Attributes: number="1", name="Define the Workflow"

- `question`: What task does this workflow accomplish?

- `question`: What triggers its use?

- `question`: What inputs does it need?

- `question`: What is the expected outcome?

- `question`: What could go wrong?

### Step (`step`)
Attributes: number="2", name="Choose Location"

#### Platform (`platform`)
Attributes: name="Antigravity"

- `workspace`: .agent/workflows/

- `global`: ~/.gemini/antigravity/global_workflows/

- `naming`: kebab-case, match slash command: arch.md → /arch

### Step (`step`)
Attributes: number="3", name="Write Workflow File"

- `format`: Embedded XML in Markdown (YAML frontmatter + XML body)

- `template`:
```text
---
description: Brief description of what this workflow does
---

&lt;workflow name="workflow-name" thinking="MAX"&gt;
  &lt;metadata&gt;
    &lt;description&gt;Full description of the workflow&lt;/description&gt;
  &lt;/metadata&gt;

  &lt;spec_contract&gt;
    &lt;id&gt;workflow-builder&lt;/id&gt;
    &lt;name&gt;workflow-builder&lt;/name&gt;
    &lt;version&gt;2.0.0&lt;/version&gt;
    &lt;last_updated&gt;2026-02-09&lt;/last_updated&gt;
    &lt;purpose&gt;Guide creation of AI agent workflows with clear numbered steps, turbo annotations, and placeholders.&lt;/purpose&gt;
    &lt;inputs&gt;
      &lt;input&gt;User request and relevant project context.&lt;/input&gt;
    &lt;/inputs&gt;
    &lt;outputs&gt;
      &lt;output&gt;Completed guidance, actions, or artifacts produced by this skill.&lt;/output&gt;
    &lt;/outputs&gt;
    &lt;triggers&gt;
      &lt;trigger&gt;Use when the frontmatter description conditions are met.&lt;/trigger&gt;
    &lt;/triggers&gt;
    &lt;procedure&gt;Follow the ordered steps in the workflow section.&lt;/procedure&gt;
    &lt;edge_cases&gt;
      &lt;edge_case&gt;If required context is missing, gather or request it before continuing.&lt;/edge_case&gt;
    &lt;/edge_cases&gt;
    &lt;safety_constraints&gt;
      &lt;constraint&gt;Avoid destructive operations without explicit user intent.&lt;/constraint&gt;
    &lt;/safety_constraints&gt;
    &lt;examples&gt;
      &lt;example&gt;Activate this skill when the request matches its trigger conditions.&lt;/example&gt;
    &lt;/examples&gt;
  &lt;/spec_contract&gt;

  &lt;important&gt;Key instruction the agent must follow&lt;/important&gt;

  &lt;steps&gt;
    &lt;step number="1" name="Step Name"&gt;
      &lt;instruction&gt;What to do in this step&lt;/instruction&gt;
    &lt;/step&gt;

    &lt;!-- turbo annotation for auto-run --&gt;
    &lt;step number="2" name="Safe Command" turbo="true"&gt;
      &lt;command&gt;npm test&lt;/command&gt;
    &lt;/step&gt;

    &lt;step number="3" name="Decision Point"&gt;
      &lt;condition type="if"&gt;If [condition A], proceed&lt;/condition&gt;
      &lt;condition type="else"&gt;Otherwise, return&lt;/condition&gt;
    &lt;/step&gt;
  &lt;/steps&gt;

  &lt;exit_criteria&gt;
    &lt;criterion&gt;What must be true for workflow to complete&lt;/criterion&gt;
  &lt;/exit_criteria&gt;
&lt;/workflow&gt;
```

- `note`: The YAML frontmatter is for discovery; the XML body contains structured steps

### Step (`step`)
Attributes: number="4", name="Use Turbo Annotations"

- `annotation` (name="// turbo", purpose="Auto-run ONE step", placement="Line before step")

- `annotation` (name="// turbo-all", purpose="Auto-run ALL steps", placement="Anywhere in file")

### Step (`step`)
Attributes: number="5", name="Add Placeholders"

- `placeholder` (syntax="[Name]", use="Visual prompt for user", example="Create [ComponentName]")

- `placeholder` (syntax="$ARGUMENTS", use="All text after command", example="/fix-issue $ARGUMENTS")

- `placeholder` (syntax="$1, $2", use="Positional arguments", example="git checkout $1")

### Step (`step`)
Attributes: number="6", name="Validate"

#### Checklist (`checklist`)

- `item`: Description explains what AND when to use

- `item`: Steps are numbered and clear

- `item`: Turbo annotations only on safe commands

- `item`: Placeholders documented

- `item`: Success criteria defined

- `item`: Error handling/rollback included

### Step (`step`)
Attributes: number="7", name="Install Workflow"

- `instruction`: Move the workflow to the appropriate location.

#### Decision Tree (`decision_tree`)

##### Branch (`branch`)
Attributes: condition="Global Workflow (Apply to ALL projects)"

- `action`: Run: scripts/move-global-workflow.ps1 -Name "workflow-name.md" -Vendor "anthropic|openai|google"

##### Branch (`branch`)
Attributes: condition="Workspace Workflow (Apply to THIS project only)"

- `action`: Run: scripts/move-local-workflow.ps1 -Name "workflow-name.md" -Vendor "mine|anthropic|openai|google"

## Patterns (`patterns`)

### Pattern (`pattern`)
Attributes: name="RIPER"

- `step`: RESEARCH: Gather information

- `step`: INNOVATE: Brainstorm solutions

- `step`: PLAN: Document approach

- `step`: EXECUTE: Implement exactly as planned

- `step`: REVIEW: Validate and reflect

### Pattern (`pattern`)
Attributes: name="TDD"

- `step`: Write failing test

- `step` (turbo="true"): Run test (confirm failure)

- `step`: Implement minimum code

- `step` (turbo="true"): Run test (confirm success)

- `step`: Refactor if needed

## Best Practices (`best_practices`)

- `do`: Keep steps numbered and sequential

- `do`: Use // turbo only for safe commands

- `do`: Include success criteria

- `do`: Document prerequisites

- `do`: Add rollback instructions for risky workflows

- `do`: Version control workflow files

- `dont`: Auto-run destructive commands

- `dont`: Create mega-workflows (split into smaller ones)

- `dont`: Hardcode paths or credentials

- `dont`: Skip error handling

- `dont`: Use vague steps

## Troubleshooting (`troubleshooting`)

- `issue` (problem="Workflow not discovered"): Check file location and extension (.md)

- `issue` (problem="Turbo annotation ignored"): Ensure it's on line BEFORE the step

- `issue` (problem="Arguments not working"): Use $ARGUMENTS or $1 format

- `issue` (problem="Steps skipped"): Add explicit numbering

## Related Skills (`related_skills`)

- `skill`: skill-builder

- `skill`: mcp-manager

- `skill`: docker-ops
```
