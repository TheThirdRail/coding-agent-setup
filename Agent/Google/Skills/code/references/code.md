# Legacy Lane: code

Vendor: Google Antigravity
Router: `code`
Source archive: `.\Agent\Google\deprecated-Workflows\code.md`
Consolidated: 2026-04-25

The content below is the former installable skill or workflow body, preserved as an on-demand lane reference.

```markdown
---
description: Code with Context - Execute implementation with focus on building, minimal discussion
---

<workflow name="code" thinking="Normal">
  <important>Planning is complete. Focus 100% on implementation. Minimal discussion, maximum execution.</important>

  <when_to_use>
    <trigger>After /architect workflow is complete and approved</trigger>
    <trigger>User says "let's code" or "start implementing"</trigger>
    <trigger>Ready to execute on an existing plan</trigger>
  </when_to_use>

  <recommended_mcp>
    <server>MCP_DOCKER</server>
    <server>serena</server>
    <server>mem0</server>
    <reason>Lazy-load task tracking when needed, codebase context, and user preferences</reason>
  </recommended_mcp>

  <prerequisites>
    <prerequisite>prd.md exists (or clear requirements understood)</prerequisite>
    <prerequisite>checklist.md exists (or clear task list)</prerequisite>
    <prerequisite>Architecture decisions are made</prerequisite>
  </prerequisites>

  <steps>
    <step number="1" name="Load Context">
      <skill ref="research-capability">Use for API docs and implementation patterns</skill>
      <skill ref="tool-selection-router">Use to choose the correct lookup/search tool for context gathering</skill>
      <skill ref="archive-manager">Route archive retrieval and prefer fresh archives before broad source scans</skill>
      <action>Read checklist.md to understand current progress</action>
      <action>Read prd.md for requirements</action>
      <action>Check project_rules.md for conventions</action>
      <action>Query archives for existing patterns; fall back to direct file reads only when archives are stale or incomplete</action>
    </step>

    <step number="2" name="Execute Tasks">
      <instruction>For each task in the checklist:</instruction>
      <action>Read before write — Always verify file contents before modifying</action>
      <action>Implement — Write the code</action>
      <action>Test — Verify it works</action>
      <action>Update checklist — Mark task as [x] complete</action>
    </step>

    <step number="3" name="Code Quality Checks">
      <skill ref="code-reviewer">Use for self-review of changes</skill>
      <skill ref="code-style-enforcer">Apply naming, comment, DRY, and type-safety checks</skill>
      <check>Edge cases handled?</check>
      <check>Error handling complete?</check>
      <check>No hardcoded secrets or paths?</check>
      <check>Types properly defined?</check>
      <check>Functions do ONE thing?</check>
    </step>

    <step number="4" name="Communication Protocol">
      <skill ref="communication-protocol-enforcer">Use for progress updates, blockers, and error recovery messages</skill>
      <rule>For blockers, provide status, blocker, and next action.</rule>
      <rule>For long tasks, emit concise progress updates.</rule>
    </step>

    <step number="5" name="Quality Gate (Mandatory)">
      <instruction>Run the `/quality-gates` rubric before marking implementation complete.</instruction>
      <instruction>Block completion if any critical gate returns BLOCK.</instruction>
      <required_output>overall_status=PASS</required_output>
    </step>

    <step number="6" name="Minimize Discussion">
      <rule>Don't over-explain obvious changes</rule>
      <rule>Focus on non-obvious logic and decisions</rule>
      <rule>Keep responses concise</rule>
      <rule>Only pause for genuine blockers</rule>
    </step>

    <step number="7" name="Update Progress">
      <action>Mark completed tasks in checklist.md</action>
      <action>Update memory/codegraph with new functions</action>
      <action>For substantial or durable code/docs/config changes, run archive-manager to refresh relevant archive-code/archive-docs/archive-graph/archive-memory artifacts</action>
      <action>Note any deferred items</action>
    </step>
  </steps>

  <behavior_rules>
    <rule>Execute step-by-step from the checklist</rule>
    <rule>Write code efficiently with minimal preamble</rule>
    <rule>Test each change before moving on</rule>
    <rule>Only pause for genuine blockers</rule>
    <rule>Stay in implementation mode until checklist complete</rule>
  </behavior_rules>

  <exit_criteria>
    <criterion>All checklist items marked [x]</criterion>
    <criterion>All tests passing</criterion>
    <criterion>Code quality checks complete</criterion>
    <criterion>Quality gate result is PASS (no critical BLOCK)</criterion>
    <criterion>Ready for user review</criterion>
  </exit_criteria>

  <related_workflows>
    <workflow>/quality-gates</workflow>
    <workflow>/review</workflow>
  </related_workflows>
</workflow>
```

## Modular Guidance

- Add or update tests for meaningful behavior changes when a test framework exists.
- For bugs, reproduce the failure before fixing when practical.
- For refactors, preserve behavior and verify affected paths before and after when practical.
- Run the narrowest relevant check available and report failed or skipped checks honestly.
- Update usage/setup docs when behavior, commands, environment variables, or setup flow changes.
- Keep implementation notes concise and avoid duplicating global policy here.
