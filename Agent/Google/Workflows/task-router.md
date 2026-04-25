---
description: Route Antigravity requests to one of the consolidated super-skills.
---

<workflow name="task-router" thinking="Normal">
  <metadata>
    <description>Compact router for the consolidated Antigravity skill set.</description>
  </metadata>

  <important>This workflow recommends a super-skill. It does not auto-dispatch or chain-execute other workflows.</important>

  <routing_table>
    <route trigger="Archive, memory, code search, docs index, git history, graph" skill="archive-manager" />
    <route trigger="Planning, architecture, API design, frontend/backend/database design, project setup" skill="architect" />
    <route trigger="Build or update skills, workflows, rules, automations, custom MCP tools" skill="agent-builder" />
    <route trigger="Implementation, refactor, tests, commits, PRs, deployment" skill="code" />
    <route trigger="Debugging, fixes, reviews, CI/CD, dependencies, security, performance" skill="quality-repair" />
    <route trigger="Onboarding, morning routine, handoff, explicit teaching mode" skill="project-continuity" />
    <route trigger="Validated research, documentation, tool selection" skill="research-docs" />
    <route trigger="MCP operations, Docker MCP troubleshooting, Serena activation" skill="mcp-ops" />
  </routing_table>

  <steps>
    <step number="1" name="Classify Request">
      <instruction>Map the request to the highest-confidence super-skill.</instruction>
      <instruction>Use project-continuity for teaching only when the user explicitly asks for learning or explanation support.</instruction>
    </step>
    <step number="2" name="Return Route Decision">
      <instruction>Return skill, confidence, rationale, and immediate next action.</instruction>
    </step>
  </steps>

  <output_format>
    <field>recommended_skill</field>
    <field>confidence</field>
    <field>reason</field>
    <field>next_step_instruction</field>
  </output_format>
</workflow>
