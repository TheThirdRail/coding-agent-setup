---
name: archive-manager
description: |
  Route code, docs, git, graph, and memory archive retrieval or indexing through one on-demand context skill.
  Use when preserving, searching, indexing, or retrieving project context, history, docs, code structure, graph data, or durable memory.
---

<skill name="archive-manager" version="3.0.0">
  <metadata>
    <keywords>
      <keyword>archive</keyword>
      <keyword>context</keyword>
      <keyword>memory</keyword>
      <keyword>history</keyword>
      <keyword>index</keyword>
      <keyword>retrieval</keyword>
      <keyword>docs</keyword>
      <keyword>graph</keyword>
    </keywords>
  </metadata>

  <goal>Route code, docs, git, graph, and memory archive retrieval or indexing through one on-demand context skill.</goal>

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
    <route intent="Code symbols and text search" reference="references/archive-code.md">Read when finding definitions, references, or text patterns.</route>
    <route intent="Document semantic memory" reference="references/archive-docs.md">Read when storing or searching long-form docs and research.</route>
    <route intent="Git history and change tracing" reference="references/archive-git.md">Read when asking when or why repository behavior changed.</route>
    <route intent="Structural code graph" reference="references/archive-graph.md">Read when relationships among files, functions, or classes matter.</route>
    <route intent="Durable project memory" reference="references/archive-memory.md">Read when recording or retrieving decisions and durable notes.</route>
    <route intent="Archive routing policy" reference="references/archive-manager.md">Read when the correct archive lane is unclear or multiple lanes may compose.</route>
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
    <former_skill>archive-manager</former_skill>
    <former_skill>archive-code</former_skill>
    <former_skill>archive-docs</former_skill>
    <former_skill>archive-git</former_skill>
    <former_skill>archive-graph</former_skill>
    <former_skill>archive-memory</former_skill>
  </consolidated_skills>
  <related_skills>
    <skill>research-docs</skill>
    <skill>mcp-ops</skill>
  </related_skills>
</skill>
