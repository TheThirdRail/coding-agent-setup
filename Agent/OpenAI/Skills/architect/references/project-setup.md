# Legacy Lane: project-setup

Vendor: OpenAI Codex
Router: `architect`
Source archive: `.\Agent\OpenAI\deprecated-Skills\project-setup\SKILL.md`
Consolidated: 2026-04-25

The content below is the former installable skill or workflow body, preserved as an on-demand lane reference.

```markdown
---
name: project-setup
description: |
  OpenAI Codex orchestration skill converted from `project-setup.md`.
  Use when After /architect has created prd.md, checklist.md; Before starting /code implementation; To set up file structure and configuration.
  Routes to specialized skills and preserves the original execution sequence.
---
# Skill: project-setup
Attributes: name="project-setup", version="1.0.0"

## Metadata (`metadata`)

- `keywords`: workflow, orchestration, project-setup, openai, codex

- `source_workflow`: project-setup.md

## Spec Contract (`spec_contract`)

- `id`: project-setup

- `name`: project-setup

- `version`: 1.0.0

- `last_updated`: 2026-02-09

- `purpose`: Project Setup - Initialize project structure after Architect Mode planning

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

- `goal`: Project Setup - Initialize project structure after Architect Mode planning

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
Attributes: number="1", name="Create .gitignore"

- `instruction`: # Dependencies node_modules/ vendor/ .venv/ __pycache__/ # Build outputs dist/ build/ .next/ # Environment .env .env.local .env.*.local # IDE .idea/ .vscode/settings.json # AI/Agent Generated (DO NOT COMMIT) Agent-Context/ # Archive Data (DO NOT COMMIT) Agent-Context/Archives/ Archive/ # Testing coverage/ # Temporary tmp/ temp/

### Step (`step`)
Attributes: number="2", name="Create Agent-Context Folder Structure"

- `instruction`: Create the Agent-Context directory tree for all agent-generated files. Agent-Context/Research Agent-Context/Lessons Agent-Context/PRD Agent-Context/Plan Agent-Context/Tasks Agent-Context/Communications/Agent-Notes Agent-Context/Communica...

### Step (`step`)
Attributes: number="3", name="Create Project Structure"

- `instruction`: Use for structure decisions Based on the tech stack from /architect, create appropriate folders src/components/, src/pages/, src/utils/, public/, tests/, docs/ src/, tests/, docs/, scripts/

### Step (`step`)
Attributes: number="4", name="Generate Workspace Rules"

- `instruction`: Use to create project-specific rules Create `Agent-Context/Rules/project-rules.md` using the rule-builder format --- name: project-rules description: | Workspace-specific rules for this project. Includes stack conventions and testing requiremen...

### Step (`step`)
Attributes: number="5", name="Initialize Git"

- `instruction`: git init git add . git commit -m "Initial project setup"

- `command`: git init

- `command`: git add .

- `command`: git commit -m "Initial project setup"

### Step (`step`)
Attributes: number="6", name="Create README.md"

- `instruction`: Project name and description (from prd.md) Installation instructions Usage examples Contributing guidelines

### Step (`step`)
Attributes: number="7", name="Prepare for Implementation"

- `instruction`: Inform user that project is ready Suggest proceeding with /code workflow

## Best Practices (`best_practices`)

- `do`: Summarize progress after each major phase when the task is long-running.

- `do`: Use specialized skills where referenced for domain-specific quality.

- `do`: Invoke related skill `architecture-planner` when that capability is required.

- `do`: Invoke related skill `rule-builder` when that capability is required.

- `dont`: Skip validation or testing steps when the workflow defines them.

- `dont`: Expand scope beyond the workflow objective without explicit user direction.

## Related Skills (`related_skills`)

- `skill`: architecture-planner

- `skill`: rule-builder
```
