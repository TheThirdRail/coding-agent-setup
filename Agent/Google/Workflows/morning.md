---
description: Daily startup routine - sync code, check status, prepare for work
---

<workflow name="morning" thinking="Normal">
  <when_to_use>
    <trigger>Start of each work day</trigger>
    <trigger>After being away from the project</trigger>
    <trigger>When returning to a project after a break</trigger>
  </when_to_use>

  <recommended_mcp>
    <server>MCP_DOCKER</server>
    <reason>Lazy-load `shrimp-task-manager` only if daily task planning needs it</reason>
  </recommended_mcp>

  <steps>
    <step number="1" name="Sync with Remote" turbo="true">
      <command>git fetch --all</command>
      <command>git pull</command>
    </step>

    <step number="2" name="Check Branch Status" turbo="true">
      <command>git status</command>
      <command>git branch -v</command>
    </step>

    <step number="3" name="Install Dependencies" turbo="true">
      <command>npm install</command>
    </step>

    <step number="4" name="Run Tests" turbo="true">
      <command>npm test</command>
    </step>

    <step number="5" name="Check for Stashed Work" turbo="true">
      <command>git stash list</command>
    </step>

    <step number="6" name="Review TODO/Handoff">
      <action>Read HANDOFF.md if it exists</action>
      <action>Check issue tracker</action>
      <action>Review any notes from yesterday</action>
    </step>

    <step number="7" name="Plan the Day">
      <action>Pick 1-3 priorities</action>
      <action>Estimate time needed</action>
      <action>Identify any blockers</action>
    </step>
  </steps>

  <success_criteria>
    <criterion>Code is up to date</criterion>
    <criterion>Tests are passing</criterion>
    <criterion>Today's priorities are clear</criterion>
  </success_criteria>
</workflow>
