---
name: architect
description: |
  Plan projects, architecture, APIs, frontend/backend boundaries, database design, and setup decisions.
  Use when planning, designing, scoping, setting up a project, creating architecture docs, designing APIs, or choosing frontend/backend/data patterns.
---

<skill name="architect" version="3.0.0">
  <metadata>
    <keywords>
      <keyword>plan</keyword>
      <keyword>architecture</keyword>
      <keyword>api</keyword>
      <keyword>frontend</keyword>
      <keyword>backend</keyword>
      <keyword>database</keyword>
      <keyword>setup</keyword>
      <keyword>design</keyword>
    </keywords>
  </metadata>

  <goal>Plan projects, architecture, APIs, frontend/backend boundaries, database design, and setup decisions.</goal>

  <core_principles>
    <principle name="Progressive Disclosure">
      <rule>Keep this skill as a compact router and load detailed lane references only on demand.</rule>
    </principle>
    <principle name="Intent Routing">
      <rule>Choose the narrowest matching route before reading references or using scripts.</rule>
    </principle>
    <principle name="Compatibility Preservation">
      <rule>Use consolidated lane references to preserve former skill and workflow behavior without reinstalling alias skills.</rule>
    </principle>
  </core_principles>
  <routing>
    <route intent="End-to-end architecture planning" reference="references/architect.md">Read when the user needs a full plan or ambiguous requirements clarified.</route>
    <route intent="Architecture docs and diagrams" reference="references/architecture-planner.md">Read when diagrams, ADRs, or system documentation are requested.</route>
    <route intent="Backend systems" reference="references/backend-architect.md">Read for API/service/data/security architecture tradeoffs.</route>
    <route intent="Frontend systems" reference="references/frontend-architect.md">Read for UI component boundaries, state, accessibility, or responsive design.</route>
    <route intent="API interface design" reference="references/api-builder.md">Read when designing REST, GraphQL, validation, auth, or OpenAPI surfaces.</route>
    <route intent="Database design and optimization" reference="references/database-optimizer.md">Read for schemas, indexes, query plans, or data modeling.</route>
    <route intent="Initial project setup" reference="references/project-setup.md">Read when turning an approved plan into repo structure/config/docs.</route>
    <route intent="Workspace rules bootstrap" reference="references/workspace-rules-bootstrapper.md">Read when initializing workspace rules or policy modules.</route>
  </routing>

  <workflow>
    <step number="1" name="Classify Intent">
      <instruction>Choose the narrowest matching route from this skill.</instruction>
    </step>
    <step number="2" name="Load One Lane">
      <instruction>Read only the selected reference file before executing specialized steps.</instruction>
    </step>
    <step number="3" name="Use Resources On Demand">
      <instruction>Load scripts, assets, or extra references only when the selected lane requires them.</instruction>
    </step>
    <step number="4" name="Report Route">
      <instruction>State the lane used when it affects auditability, handoff, or recovery.</instruction>
    </step>
  </workflow>

  <best_practices>
    <do>Read the selected lane reference before specialized work.</do>
    <do>Use bundled scripts, assets, or extra references only when the selected lane requires them.</do>
    <do>State the selected route when it affects auditability, handoff, or recovery.</do>
    <dont>Load multiple lane references unless the user request genuinely crosses responsibilities.</dont>
  </best_practices>
  <consolidated_skills>
    <former_skill>architect</former_skill>
    <former_skill>architecture-planner</former_skill>
    <former_skill>backend-architect</former_skill>
    <former_skill>frontend-architect</former_skill>
    <former_skill>api-builder</former_skill>
    <former_skill>database-optimizer</former_skill>
    <former_skill>project-setup</former_skill>
    <former_skill>workspace-rules-bootstrapper</former_skill>
  </consolidated_skills>
  <related_skills>
    <skill>research-docs</skill>
    <skill>code</skill>
    <skill>quality-repair</skill>
  </related_skills>
</skill>
