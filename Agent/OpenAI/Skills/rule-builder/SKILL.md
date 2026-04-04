---
name: rule-builder
description: |
  Create or update reusable agent behavior rules with explicit constraints,
  activation modes, and install paths. Use when enforcing consistent
  guardrails (security, style, workflow) across a workspace or globally.
---
# Skill: rule-builder
Attributes: name="rule-builder", version="2.0.0"

## Metadata (`metadata`)

- `keywords`: rules, constraints, guardrails, GEMINI.md, agent behavior

## Spec Contract (`spec_contract`)

- `id`: rule-builder

- `name`: rule-builder

- `version`: 2.0.0

- `last_updated`: 2026-02-09

- `purpose`: Guide creation of Antigravity agent rules with proper structure, activation modes, and clear behavioral constraints.

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

- `goal`: Guide creation of Antigravity agent rules with proper structure, activation modes, and clear behavioral constraints.

## Core Principles (`core_principles`)

### Principle (`principle`)
Attributes: name="Constraint Clarity"

- `rule`: Rules must be unambiguous - no room for interpretation

- `rule`: Use explicit ALLOW/DENY lists where possible

- `rule`: Start with restrictive defaults, then whitelist

### Principle (`principle`)
Attributes: name="Size Limit"

- `rule`: Rule files MUST be under 12,000 characters to respect context limits

- `rule`: Keep rules focused on specific domains (Security, Testing, etc.)

### Principle (`principle`)
Attributes: name="Activation Specificity"

- `mode` (name="always_on"): Rule is always active

- `mode` (name="manual"): User must explicitly invoke

- `mode` (name="model_decision"): Agent decides based on context

- `mode` (name="glob"): Applies to files matching pattern (e.g., *.ts)

## Workflow (`workflow`)

### Step (`step`)
Attributes: number="1", name="Define the Rule Purpose"

- `question`: What behavior are you constraining or enforcing?

- `question`: Is this a MUST, MUST NOT, or PREFER rule?

- `question`: Should this apply globally (all projects) or per-workspace?

### Step (`step`)
Attributes: number="2", name="Write Rule File"

- `format`: Embedded XML in Markdown (YAML frontmatter + XML body)

- `template`:
```text
---

name: rule-name
description: |
  Brief description of what this rule enforces.
  Include WHY this rule exists.
activation: always_on  # or: manual, model_decision, glob
glob: "*.ts"  # only if activation is glob
---

&lt;rule name="rule-name" version="1.0.0"&gt;
  &lt;metadata&gt;
    &lt;category&gt;security|code-style|architecture|workflow&lt;/category&gt;
    &lt;severity&gt;error|warning|info&lt;/severity&gt;
  &lt;/metadata&gt;

  &lt;spec_contract&gt;
    &lt;id&gt;rule-builder&lt;/id&gt;
    &lt;name&gt;rule-builder&lt;/name&gt;
    &lt;version&gt;2.0.0&lt;/version&gt;
    &lt;last_updated&gt;2026-02-09&lt;/last_updated&gt;
    &lt;purpose&gt;Guide creation of Antigravity agent rules with proper structure, activation modes, and clear behavioral constraints.&lt;/purpose&gt;
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

  &lt;purpose&gt;One sentence explaining what this rule prevents or enforces.&lt;/purpose&gt;

  &lt;constraints&gt;
    &lt;must&gt;
      &lt;behavior id="unique-id"&gt;Specific mandated behavior&lt;/behavior&gt;
    &lt;/must&gt;
    &lt;must_not&gt;
      &lt;behavior id="unique-id"&gt;Specific prohibited behavior&lt;/behavior&gt;
    &lt;/must_not&gt;
    &lt;prefer&gt;
      &lt;behavior id="unique-id"&gt;Preferred approach&lt;/behavior&gt;
    &lt;/prefer&gt;
  &lt;/constraints&gt;

  &lt;examples&gt;
    &lt;example type="good" description="Correct approach"&gt;
      &lt;code&gt;...&lt;/code&gt;
    &lt;/example&gt;
    &lt;example type="bad" description="What to avoid"&gt;
      &lt;code&gt;...&lt;/code&gt;
    &lt;/example&gt;
  &lt;/examples&gt;
&lt;/rule&gt;
```

### Step (`step`)
Attributes: number="3", name="Validate Size"

- `instruction`: Ensure the file character count is under 12,000.

- `check`: Is the content focused purely on rules? (Move detailed how-to instructions to Skills)

### Step (`step`)
Attributes: number="4", name="Install Rule"

- `instruction`: Move the rule to the appropriate location using helper scripts.

#### Decision Tree (`decision_tree`)

##### Branch (`branch`)
Attributes: condition="Global Rule (Apply to ALL projects)"

- `action`: Run: scripts/move-global-rule.ps1 -Name "rule-name.md" -Vendor "anthropic|openai|google"

##### Branch (`branch`)
Attributes: condition="Workspace Rule (Apply to THIS project only)"

- `action`: Run: scripts/move-local-rule.ps1 -Name "rule-name.md" -Vendor "mine|anthropic|openai|google"

## Resource Folders (`resource_folders`)

### Folder (`folder`)
Attributes: name="scripts/", purpose="Installation utilities"

- `file`: move-global-rule.ps1

- `file`: move-local-rule.ps1

## Best Practices (`best_practices`)

- `do`: Write constraints in enforceable terms (must, must_not, prefer)

- `do`: Keep rule scope narrow and domain-specific

- `do`: Install rules using script parameters instead of manual path edits

- `dont`: Embed long tutorials or implementation guidance in rule files

- `dont`: Use ambiguous statements that cannot be validated in review
