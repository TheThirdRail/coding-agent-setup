---
name: project-continuity
description: |
  Handle onboarding, daily startup, handoff, and explicit teaching/documentation support.
  Use when joining or returning to a project, creating handoff notes, running a morning routine, or when the user explicitly asks to learn or be taught.
---

<skill name="project-continuity" version="3.0.0">
  <metadata>
    <keywords>
      <keyword>onboard</keyword>
      <keyword>handoff</keyword>
      <keyword>morning</keyword>
      <keyword>tutor</keyword>
      <keyword>learn</keyword>
      <keyword>continuity</keyword>
      <keyword>session</keyword>
    </keywords>
  </metadata>

  <goal>Handle onboarding, daily startup, handoff, and explicit teaching/documentation support.</goal>

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
    <route intent="New codebase onboarding" reference="references/onboard.md">Read when joining, inheriting, or learning an unfamiliar repository.</route>
    <route intent="End-of-session handoff" reference="references/handoff.md">Read when preparing transition notes or stopping work.</route>
    <route intent="Daily startup" reference="references/morning.md">Read when returning to a project or starting a work day.</route>
    <route intent="Teaching mode" reference="references/tutor.md">Read only when the user explicitly asks for learning, explanation, or teaching.</route>
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
    <former_skill>onboard</former_skill>
    <former_skill>handoff</former_skill>
    <former_skill>morning</former_skill>
    <former_skill>tutor</former_skill>
  </consolidated_skills>
  <related_skills>
    <skill>archive-manager</skill>
    <skill>research-docs</skill>
  </related_skills>
</skill>
