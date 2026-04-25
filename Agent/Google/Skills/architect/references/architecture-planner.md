# Legacy Lane: architecture-planner

Vendor: Google Antigravity
Router: `architect`
Source archive: `.\Agent\Google\deprecated-Skills\architecture-planner\SKILL.md`
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

<skill name="architecture-planner" version="2.0.0">
  <metadata>
    <keywords>architecture, design, mermaid, diagrams, system-design</keywords>
  </metadata>

  <goal>Create clear, visual documentation of software architecture using Mermaid diagrams.</goal>

  <core_principles>
    <principle name="C4 Model Levels">
      <level name="Context" purpose="System in environment" audience="Everyone"/>
      <level name="Container" purpose="High-level tech choices" audience="Developers, DevOps"/>
      <level name="Component" purpose="Internal structure" audience="Developers"/>
      <level name="Code" purpose="Implementation details" audience="Developers"/>
    </principle>

    <principle name="Diagram Types">
      <type name="Flowchart" use="Process flows, decision logic"/>
      <type name="Sequence" use="Request/response, interactions"/>
      <type name="Class" use="Object relationships, data models"/>
      <type name="ER" use="Database schema"/>
      <type name="State" use="State machines, lifecycles"/>
    </principle>

    <principle name="Architecture Qualities">
      <quality>Scalability — Can it handle growth?</quality>
      <quality>Reliability — What happens when parts fail?</quality>
      <quality>Security — How is data protected?</quality>
      <quality>Maintainability — Is it easy to change?</quality>
      <quality>Performance — Is it fast enough?</quality>
    </principle>
  </core_principles>



  <recommended_mcp>
    <server>sequential-thinking</server>
    <server>codegraph</server>
    <reason>Structured reasoning and graph visualization of codebase</reason>
  </recommended_mcp>

  <workflow>
    <step number="1" name="Understand Requirements">
      <question>What problem does this solve?</question>
      <question>Who are the users/systems interacting with it?</question>
      <question>What are the data inputs and outputs?</question>
      <question>What are the constraints?</question>
    </step>

    <step number="2" name="Identify Components">
      <question>What are the main functional areas?</question>
      <question>What external systems does it integrate with?</question>
      <question>What data stores are needed?</question>
    </step>

    <step number="3" name="Choose Diagram Type">
      <decision condition="System boundaries">Context Diagram</decision>
      <decision condition="Tech stack">Container Diagram</decision>
      <decision condition="Request flow">Sequence Diagram</decision>
      <decision condition="Object relationships">Class Diagram</decision>
      <decision condition="Database structure">ER Diagram</decision>
    </step>

    <step number="4" name="Generate Diagram">
      <instruction>Use Mermaid syntax for diagrams</instruction>
    </step>

    <step number="5" name="Document Decisions">
      <instruction>For each major decision, document: Decision, Context, Options, Rationale, Consequences</instruction>
    </step>
  </workflow>

  <mermaid_templates>
    <template name="Context Diagram" syntax="graph TB with External and System subgraphs"/>
    <template name="Container Diagram" syntax="graph TB with Frontend, Backend, Data subgraphs"/>
    <template name="Sequence Diagram" syntax="sequenceDiagram with participants and arrows"/>
    <template name="Class Diagram" syntax="classDiagram with classes and relationships"/>
    <template name="ER Diagram" syntax="erDiagram with entities and relationships"/>
    <template name="State Diagram" syntax="stateDiagram-v2 with states and transitions"/>
  </mermaid_templates>

  <adr_template><![CDATA[
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
  ]]></adr_template>

  <best_practices>
    <do>Start with simple diagrams, add detail as needed</do>
    <do>Use consistent notation and styling</do>
    <do>Document the "why" not just the "what"</do>
    <do>Keep diagrams close to the code they describe</do>
    <do>Review diagrams with stakeholders</do>
    <dont>Create diagrams that never get updated</dont>
    <dont>Include too much detail in one diagram</dont>
    <dont>Skip documentation of trade-offs</dont>
    <dont>Design in isolation without feedback</dont>
  </best_practices>

  <resources>
    <reference name="mermaid-templates.md" purpose="Copy-paste diagram templates">
      <location>references/mermaid-templates.md</location>
      <description>Complete Mermaid templates: C4 Context/Container, Sequence, Class, ER, State, Gantt, Flowchart</description>
    </reference>
  </resources>

  <related_skills>
    <skill>code-reviewer</skill>
    <skill>test-generator</skill>
  </related_skills>
</skill>
```
