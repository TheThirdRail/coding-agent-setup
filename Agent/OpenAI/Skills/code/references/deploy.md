# Legacy Lane: deploy

Vendor: OpenAI Codex
Router: `code`
Source archive: `.\Agent\OpenAI\deprecated-Skills\deploy\SKILL.md`
Consolidated: 2026-04-25

The content below is the former installable skill or workflow body, preserved as an on-demand lane reference.

```markdown
---
name: deploy
description: |
  OpenAI Codex orchestration skill converted from `deploy.md`.
  Use when Deploying to staging or production; Releasing a new version; Rolling out critical fixes.
  Routes to specialized skills and preserves the original execution sequence.
---
# Skill: deploy
Attributes: name="deploy", version="1.0.0"

## Metadata (`metadata`)

- `keywords`: workflow, orchestration, deploy, openai, codex

- `source_workflow`: deploy.md

## Spec Contract (`spec_contract`)

- `id`: deploy

- `name`: deploy

- `version`: 1.0.0

- `last_updated`: 2026-02-09

- `purpose`: Safe deployment workflow with verification and rollback

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

- `goal`: Safe deployment workflow with verification and rollback

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
Attributes: number="1", name="Pre-Deployment Checklist"

- `instruction`: Verify all prerequisites before deployment All tests passing Security audit clear (/security-audit) Dependencies up to date (/dependency-check) Database migrations prepared and tested Environment variables configured Feature flags set ap...

### Step (`step`)
Attributes: number="2", name="Prepare Deployment Artifacts"

- `instruction`: Build and validate deployment package Build production artifacts Verify build output (no warnings, correct size) Run smoke tests against build

### Step (`step`)
Attributes: number="3", name="Create Backup Point"

- `instruction`: Ensure rollback capability Tag current production state (git tag) Backup database if schema changes Document rollback procedure

### Step (`step`)
Attributes: number="4", name="Choose Deployment Strategy"

- `instruction`: Select appropriate deployment method Low-traffic application, non-critical updates Brief Zero-downtime required, two environments available None (instant switch) Risky changes, need gradual rollout None (gradual switch) Multiple instance...

### Step (`step`)
Attributes: number="5", name="Execute Deployment"

- `instruction`: Deploy to target environment Run deployment command Watch for deployment errors Verify deployment completes successfully Schedule during low-traffic window if possible

### Step (`step`)
Attributes: number="6", name="Post-Deployment Verification"

- `instruction`: Verify deployment success Health endpoints responding Smoke tests passing Key user flows working No new errors in logs Performance metrics normal

### Step (`step`)
Attributes: number="7", name="Monitor"

- `instruction`: Watch for issues after deployment Monitor closely for 30-60 minutes Error rate spikes Response time increases Memory leaks User-reported issues

### Step (`step`)
Attributes: number="8", name="Document Deployment"

- `instruction`: Record deployment details What was deployed (version, commit) When and by whom Any issues encountered Rollback procedure if needed

## Best Practices (`best_practices`)

- `do`: Summarize progress after each major phase when the task is long-running.

- `do`: Use specialized skills where referenced for domain-specific quality.

- `dont`: Skip validation or testing steps when the workflow defines them.

- `dont`: Expand scope beyond the workflow objective without explicit user direction.

- `related_skills`
```
