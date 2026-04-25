---
name: research-docs
description: |
  Perform validated research, choose lookup tools, and generate accurate project documentation.
  Use when researching current technical facts, comparing approaches, choosing search/fetch tools, or creating/updating docs from source behavior.
---

<skill name="research-docs" version="3.0.0">
  <metadata>
    <keywords>
      <keyword>research</keyword>
      <keyword>docs</keyword>
      <keyword>documentation</keyword>
      <keyword>sources</keyword>
      <keyword>tools</keyword>
      <keyword>reference</keyword>
      <keyword>write</keyword>
    </keywords>
  </metadata>

  <goal>Perform validated research, choose lookup tools, and generate accurate project documentation.</goal>

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
    <route intent="Validated technical research" reference="references/research.md">Read when current docs, repos, or best practices are required.</route>
    <route intent="Antigravity research capability" reference="references/research-capability.md">Read when using the Antigravity research protocol.</route>
    <route intent="Documentation generation" reference="references/documentation-generator.md">Read when creating README, API docs, ADRs, or runbooks.</route>
    <route intent="Tool selection" reference="references/tool-selection-router.md">Read when selecting search/fetch/scrape/documentation tools.</route>
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
    <former_skill>research</former_skill>
    <former_skill>research-capability</former_skill>
    <former_skill>documentation-generator</former_skill>
    <former_skill>tool-selection-router</former_skill>
  </consolidated_skills>
  <related_skills>
    <skill>archive-manager</skill>
    <skill>architect</skill>
  </related_skills>
</skill>
