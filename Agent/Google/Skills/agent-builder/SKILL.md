---
name: agent-builder
description: |
  Create or maintain agent capabilities, skills, workflows, rules, automations, and custom MCP tools.
  Use when building, updating, validating, packaging, or installing agent skills, workflows, rules, automations, plugins, or custom MCP tools.
---

<skill name="agent-builder" version="3.0.0">
  <metadata>
    <keywords>
      <keyword>agent</keyword>
      <keyword>skill</keyword>
      <keyword>workflow</keyword>
      <keyword>rule</keyword>
      <keyword>automation</keyword>
      <keyword>mcp</keyword>
      <keyword>tool</keyword>
      <keyword>builder</keyword>
    </keywords>
  </metadata>

  <goal>Create or maintain agent capabilities, skills, workflows, rules, automations, and custom MCP tools.</goal>

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
    <route intent="Choose extension type" reference="references/agent-builder.md">Read when deciding between skill, workflow, rule, automation, plugin, or MCP tool.</route>
    <route intent="Skill creation and validation" reference="references/skill-builder.md">Read when creating, modernizing, packaging, or installing skills.</route>
    <route intent="Workflow creation" reference="references/workflow-builder.md">Read when defining reusable operational workflows.</route>
    <route intent="Rules and guardrails" reference="references/rule-builder.md">Read when creating or updating reusable behavior rules.</route>
    <route intent="Codex Starlark rules" reference="references/openai-rule-builder.md">Read when editing Codex-compatible default.rules policy.</route>
    <route intent="Automation templates" reference="references/automation-builder.md">Read when creating recurring Codex automation templates.</route>
    <route intent="Custom MCP tool build" reference="references/mcp-builder.md">Read when no existing MCP server provides the needed capability.</route>
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
    <former_skill>agent-builder</former_skill>
    <former_skill>skill-builder</former_skill>
    <former_skill>workflow-builder</former_skill>
    <former_skill>rule-builder</former_skill>
    <former_skill>openai-rule-builder</former_skill>
    <former_skill>automation-builder</former_skill>
    <former_skill>mcp-builder</former_skill>
  </consolidated_skills>
  <related_skills>
    <skill>mcp-ops</skill>
    <skill>research-docs</skill>
  </related_skills>
</skill>
