---
description: End-of-session summary for handing off work to yourself tomorrow or a teammate
---

<workflow name="handoff" thinking="Normal">
  <when_to_use>
    <trigger>End of work session</trigger>
    <trigger>Before going on vacation</trigger>
    <trigger>Passing work to a teammate</trigger>
    <trigger>Any time you need to "save your mental state"</trigger>
  </when_to_use>

  <recommended_mcp>
    <server>MCP_DOCKER</server>
    <reason>Lazy-load `shrimp-task-manager` only when structured session tracking is helpful</reason>
  </recommended_mcp>

  <constraints>
    <constraint>DO NOT write implementation code</constraint>
    <constraint>DO NOT modify source files</constraint>
    <constraint>Focus ONLY on updating status and creating handoff notes in Agent-Context/Communications/Agent-Notes/</constraint>
  </constraints>

  <steps>
    <step number="1" name="Summarize What Was Done">
      <question>What features were added?</question>
      <question>What bugs were fixed?</question>
      <question>What was changed?</question>
    </step>

    <step number="2" name="Identify What's In Progress">
      <question>What's partially complete?</question>
      <question>What was the approach being taken?</question>
    </step>

    <step number="3" name="Document Dead Ends & Failed Attempts">
      <question>What approaches were tried and failed?</question>
      <question>Why did they fail? (Technical limitation, complexity, etc.)</question>
      <question>What shouldn't be tried again?</question>
    </step>

    <step number="4" name="List Blockers">
      <question>Waiting on someone else?</question>
      <question>Need more information?</question>
      <question>Technical obstacle?</question>
    </step>

    <step number="5" name="Note Next Steps">
      <instruction>Numbered list of next actions in priority order</instruction>
    </step>

    <step number="6" name="Flag Any Gotchas">
      <example>"Don't run X without doing Y first"</example>
      <example>"This file is temporarily broken"</example>
      <example>"That approach didn't work because..."</example>
    </step>

    <step number="7" name="Check Branch State" turbo="true">
      <command>git status</command>
      <command>git log --oneline -5</command>
    </step>

    <step number="8" name="Create Handoff Document">
      <instruction>Write summary to Agent-Context/Communications/Agent-Notes/HANDOFF.yaml (YAML format for agent consumption)</instruction>
      <instruction>Include date/time</instruction>
      <instruction>Commit if appropriate</instruction>
    </step>

    <step number="9" name="Context Governance (Handoff Event)">
      <instruction>Apply `/context-governance` with `event_type=handoff` to validate Agent-Notes YAML format and archive policy handling.</instruction>
      <instruction>Fix format/schema issues before finalizing handoff.</instruction>
    </step>
  </steps>

  <handoff_template><![CDATA[

# Handoff - [Date]

## Completed

- [x] Task 1
- [x] Task 2

## In Progress

- [ ] Task 3 (about 60% done)
  - Current approach: ...
  - Next step: ...

## Dead Ends & Failed Attempts

- [ ] Tried Library X: Failed because it doesn't support Windows.
- [ ] Tried Approach Y: Too complex, resulted in spaghetti code.
- [ ] **Do NOT try Z**: It causes a circular dependency.

## Blockers

- Waiting on [person] for [thing]

## Next Steps

1. Finish task 3
2. Start task 4
3. Review PR #123

## Gotchas

- ⚠️ Don't merge PR #456 until #123 is done
- ⚠️ Tests in `auth.test.ts` are temporarily skipped
  ]]></handoff_template>

  <success_criteria>
    <criterion>All progress documented</criterion>
    <criterion>Next steps are clear</criterion>
    <criterion>Blockers are noted</criterion>
    <criterion>Agent-Notes YAML passes context governance validation</criterion>
    <criterion>Someone else (or future you) can continue</criterion>
  </success_criteria>
</workflow>
