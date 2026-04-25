---
name: mcp-ops
description: |
  Operate MCP servers, Docker-backed MCP tools, and Serena availability checks.
  Use when discovering, enabling, disabling, troubleshooting, or cleaning up MCP servers, Docker containers, or Serena project activation.
---

<skill name="mcp-ops" version="3.0.0">
  <metadata>
    <keywords>
      <keyword>mcp</keyword>
      <keyword>docker</keyword>
      <keyword>serena</keyword>
      <keyword>tools</keyword>
      <keyword>containers</keyword>
      <keyword>runtime</keyword>
      <keyword>ops</keyword>
    </keywords>
  </metadata>

  <goal>Operate MCP servers, Docker-backed MCP tools, and Serena availability checks.</goal>

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
    <route intent="MCP server orchestration" reference="references/mcp-manager.md">Read when loading, unloading, or optimizing MCP servers.</route>
    <route intent="Docker container troubleshooting" reference="references/docker-ops.md">Read when MCP containers fail, need logs, or need health checks.</route>
    <route intent="Serena activation" reference="references/serena-trigger.md">Read when Serena-backed navigation is expected but unavailable.</route>
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
    <former_skill>mcp-manager</former_skill>
    <former_skill>docker-ops</former_skill>
    <former_skill>serena-trigger</former_skill>
  </consolidated_skills>
  <related_skills>
    <skill>archive-manager</skill>
    <skill>agent-builder</skill>
  </related_skills>
</skill>
