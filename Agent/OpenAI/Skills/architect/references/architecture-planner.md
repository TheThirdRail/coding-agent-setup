# Legacy Lane: architecture-planner

Vendor: OpenAI Codex
Router: `architect`
Source archive: `.\Agent\OpenAI\deprecated-Skills\architecture-planner\SKILL.md`
Consolidated: 2026-04-25

The content below is the former installable skill or workflow body, preserved as an on-demand lane reference.

```markdown
---
name: architecture-planner
description: |
  Design and document software architecture with diagrams and specifications.
  Generates Mermaid diagrams for system design, data flow, and component relationships.
  Use when planning new features, documenting existing systems, or reviewing architecture.
---
# Skill: architecture-planner
Attributes: name="architecture-planner", version="2.0.0"

## Metadata (`metadata`)

- `keywords`: architecture, design, mermaid, diagrams, system-design

## Spec Contract (`spec_contract`)

- `id`: architecture-planner

- `name`: architecture-planner

- `version`: 2.0.0

- `last_updated`: 2026-02-09

- `purpose`: Create clear, visual documentation of software architecture using Mermaid diagrams.

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

- `goal`: Create clear, visual documentation of software architecture using Mermaid diagrams.

## Core Principles (`core_principles`)

### Principle (`principle`)
Attributes: name="C4 Model Levels"

- `level` (name="Context", purpose="System in environment", audience="Everyone")

- `level` (name="Container", purpose="High-level tech choices", audience="Developers, DevOps")

- `level` (name="Component", purpose="Internal structure", audience="Developers")

- `level` (name="Code", purpose="Implementation details", audience="Developers")

### Principle (`principle`)
Attributes: name="Diagram Types"

- `type` (name="Flowchart", use="Process flows, decision logic")

- `type` (name="Sequence", use="Request/response, interactions")

- `type` (name="Class", use="Object relationships, data models")

- `type` (name="ER", use="Database schema")

- `type` (name="State", use="State machines, lifecycles")

### Principle (`principle`)
Attributes: name="Architecture Qualities"

- `quality`: Scalability — Can it handle growth?

- `quality`: Reliability — What happens when parts fail?

- `quality`: Security — How is data protected?

- `quality`: Maintainability — Is it easy to change?

- `quality`: Performance — Is it fast enough?

## Recommended Mcp (`recommended_mcp`)

- `server`: sequential-thinking

- `server`: codegraph

- `reason`: Structured reasoning and graph visualization of codebase

## Workflow (`workflow`)

### Step (`step`)
Attributes: number="1", name="Understand Requirements"

- `question`: What problem does this solve?

- `question`: Who are the users/systems interacting with it?

- `question`: What are the data inputs and outputs?

- `question`: What are the constraints?

### Step (`step`)
Attributes: number="2", name="Identify Components"

- `question`: What are the main functional areas?

- `question`: What external systems does it integrate with?

- `question`: What data stores are needed?

### Step (`step`)
Attributes: number="3", name="Choose Diagram Type"

- `decision` (condition="System boundaries"): Context Diagram

- `decision` (condition="Tech stack"): Container Diagram

- `decision` (condition="Request flow"): Sequence Diagram

- `decision` (condition="Object relationships"): Class Diagram

- `decision` (condition="Database structure"): ER Diagram

### Step (`step`)
Attributes: number="4", name="Generate Diagram"

- `instruction`: Use Mermaid syntax for diagrams

### Step (`step`)
Attributes: number="5", name="Document Decisions"

- `instruction`: For each major decision, document: Decision, Context, Options, Rationale, Consequences

## Mermaid Templates (`mermaid_templates`)

- `template` (name="Context Diagram", syntax="graph TB with External and System subgraphs")

- `template` (name="Container Diagram", syntax="graph TB with Frontend, Backend, Data subgraphs")

- `template` (name="Sequence Diagram", syntax="sequenceDiagram with participants and arrows")

- `template` (name="Class Diagram", syntax="classDiagram with classes and relationships")

- `template` (name="ER Diagram", syntax="erDiagram with entities and relationships")

- `template` (name="State Diagram", syntax="stateDiagram-v2 with states and transitions")

- `adr_template`:
```text
# ADR-001: [Decision Title]

## Status
Proposed | Accepted | Deprecated | Superseded

## Context
What is the issue we're trying to solve?

## Decision
What is the change we're making?

## Consequences
### Positive
- Benefit 1

### Negative
- Drawback 1
```

## Best Practices (`best_practices`)

- `do`: Start with simple diagrams, add detail as needed

- `do`: Use consistent notation and styling

- `do`: Document the "why" not just the "what"

- `do`: Keep diagrams close to the code they describe

- `do`: Review diagrams with stakeholders

- `dont`: Create diagrams that never get updated

- `dont`: Include too much detail in one diagram

- `dont`: Skip documentation of trade-offs

- `dont`: Design in isolation without feedback

## Resources (`resources`)

### Reference (`reference`)
Attributes: name="mermaid-templates.md", purpose="Copy-paste diagram templates"

- `location`: references/mermaid-templates.md

- `description`: Complete Mermaid templates: C4 Context/Container, Sequence, Class, ER, State, Gantt, Flowchart

## Related Skills (`related_skills`)

- `skill`: code-reviewer

- `skill`: test-generator
```
