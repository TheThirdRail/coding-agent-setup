# Legacy Lane: architect

Vendor: Google Antigravity
Router: `architect`
Source archive: `.\Agent\Google\deprecated-Workflows\architect.md`
Consolidated: 2026-04-25

The content below is the former installable skill or workflow body, preserved as an on-demand lane reference.

```markdown
---
description: Architect Mode - Plan and design a new feature or project from scratch
---

<workflow name="architect" thinking="MAX">
  <important>Use MAXIMUM thinking/reasoning depth. Plan thoroughly before any implementation.</important>

  <when_to_use>
    <trigger>User says "I have an idea"</trigger>
    <trigger>User says "Help me plan"</trigger>
    <trigger>Ambiguous requirements needing clarification</trigger>
    <trigger>Starting a new project from scratch</trigger>
    <trigger>Planning a major new feature</trigger>
    <trigger>Designing system architecture</trigger>
  </when_to_use>

  <constraints>
    <constraint>DO NOT write implementation code (use /code workflow for that)</constraint>
    <constraint>DO NOT create source files (only config, docs, and scaffolding)</constraint>
    <constraint>Focus ONLY on planning, structure, and documentation</constraint>
  </constraints>

  <distinction>
    <versus workflow="/code">
      <difference>/architect is for PLANNING and DESIGN only</difference>
      <difference>/code is for IMPLEMENTATION and EXECUTION</difference>
    </versus>
  </distinction>

  <recommended_mcp>
    <server>sequential-thinking</server>
    <server>MCP_DOCKER</server>
    <server>mem0</server>
    <server>codegraph</server>
    <reason>Design reasoning, lazy-load task planning when needed, preference memory, and code visualization</reason>
  </recommended_mcp>

  <steps>
    <step number="0" name="Clarify Vision">
      <action>Ask open-ended questions to understand the "What" and "Why".</action>
      <action>Identify the user's ultimate goal and success criteria.</action>
      <example>"What problem are we solving?" "Who is this for?"</example>
      <action>Agree on the "MVP" (Minimum Viable Product) features.</action>
      <action>Determine technical constraints (Language, Platform, Budget).</action>
    </step>

    <step number="1" name="Clarify Requirements">
      <action>Ask questions about scope, requirements, and constraints</action>
      <action>DO NOT proceed until critical questions are answered</action>
      <action>Understand the user's vision completely</action>
    </step>

    <step number="2" name="Research Best Practices">
      <skill ref="research-capability">Use this skill for contextual information gathering</skill>
      <action>Research current best practices for the relevant tech stack</action>
      <action>Research project structure conventions</action>
      <action>Research security and performance best practices</action>
      <action>Document findings for reference</action>
    </step>

    <step number="3" name="Design Architecture">
      <skill ref="architecture-planner">Use this skill for diagrams and ADRs</skill>
      <skill ref="frontend-architect">Use this skill for UI/UX and component design</skill>
      <skill ref="backend-architect">Use this skill for API, database, and security design</skill>
      <action>Create high-level architecture including tech stack decisions</action>
      <action>Define file/folder structure</action>
      <action>Create data flow diagrams (using Mermaid via architecture-planner)</action>
      <action>Identify dependencies and integration points</action>
      <action>Document architectural decisions using ADR template</action>
      <warning>Do not start writing actual component code here</warning>
    </step>

    <step number="4" name="Generate Documentation">
      <output file="Agent-Context/PRD/prd.md">Goals, user stories, acceptance criteria, technical requirements, scope</output>
      <output file="Agent-Context/PRD/checklist.md">Phased implementation plan with atomic, checkable tasks</output>
      <output file="Agent-Context/Plan/project_rules.md">Tech stack, coding conventions, linting rules, naming conventions</output>
    </step>

    <step number="5" name="Index the Project">
      <tool name="mem0">Store architectural decisions</tool>
      <tool name="codegraph">Index code relationships</tool>
      <tool name="ragdocs">Vector search for docs</tool>
    </step>

    <step number="6" name="Track Tasks">
      <action>Register checklist items with task manager if available</action>
      <action>Otherwise, use checklist.md as the source of truth</action>
    </step>

    <step number="7" name="Context Governance (Planning Event)">
      <instruction>Apply `/context-governance` with `event_type=planning` to validate PRD/Plan folder placement, formats, and archive actions.</instruction>
      <instruction>Resolve schema or format violations before transitioning to `/project-setup` or `/code`.</instruction>
    </step>
  </steps>

  <behavior_rules>
    <rule>Stop before writing any implementation code</rule>
    <rule>Refuse requests to "just write the code" in this mode</rule>
    <rule>Refer user to /code workflow for implementation</rule>
  </behavior_rules>

  <exit_criteria>
    <criterion>All documentation files created</criterion>
    <criterion>User has reviewed and approved the plan</criterion>
    <criterion>Ready to transition to /code workflow</criterion>
  </exit_criteria>
</workflow>
```
