---
description: On-demand Antigravity workflow for selecting the right consolidated router skill.
---

<workflow name="task-router" thinking="Normal">
  <metadata>
    <description>Choose a single best-fit router skill for a request when the user explicitly asks for routing or workflow selection.</description>
  </metadata>

  <purpose>
    Recommend the smallest useful Antigravity capability for the current request without treating routing as hidden always-on behavior.
  </purpose>

  <when_to_use>
    <trigger>User explicitly invokes or asks for task routing.</trigger>
    <trigger>User asks which skill, workflow, or capability should handle a request.</trigger>
    <trigger>The request spans multiple possible capability domains and a route decision would reduce confusion.</trigger>
  </when_to_use>

  <when_not_to_use>
    <condition>The request is straightforward and can be handled directly.</condition>
    <condition>The user already named the skill or workflow to use.</condition>
    <condition>Routing would add ceremony without improving accuracy, context efficiency, execution quality, or verification.</condition>
  </when_not_to_use>

  <inputs_needed>
    <input>User request or task description.</input>
    <input>Any explicit vendor, tool, workflow, or skill preference from the user.</input>
    <input>Known constraints such as read-only review, implementation, security sensitivity, or documentation focus.</input>
  </inputs_needed>

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
      <instruction>Identify the primary outcome the user wants.</instruction>
      <instruction>Use project-continuity for teaching only when the user explicitly asks for learning or explanation support.</instruction>
    </step>
    <step number="2" name="Choose Smallest Capability">
      <instruction>Select one primary router skill from the routing table.</instruction>
      <instruction>Choose multiple skills only when the request genuinely crosses responsibilities.</instruction>
    </step>
    <step number="3" name="Return Route Decision">
      <instruction>Return the recommended skill, confidence, rationale, and immediate next action.</instruction>
    </step>
  </steps>

  <verification_output>
    <field>recommended_skill</field>
    <field>confidence</field>
    <field>reason</field>
    <field>next_step_instruction</field>
  </verification_output>
</workflow>
