---
description: Test-Driven Development workflow - write tests first, then implement code to pass them
---

<workflow name="test-developer" thinking="Normal">
  <when_to_use>
    <trigger>Building new features that need to be reliable</trigger>
    <trigger>Fixing bugs (reproduce with test first)</trigger>
    <trigger>When you want confidence the code works</trigger>
  </when_to_use>

  <recommended_mcp>
    <server>MCP_DOCKER</server>
    <reason>Lazy-load `playwright` only when browser or end-to-end testing is actually needed</reason>
  </recommended_mcp>

  <concept><![CDATA[
Write Test → Run (Fails) → Write Code → Run (Passes) → Refactor → Repeat
  ]]></concept>

  <steps>
    <step number="1" name="Understand the Requirement">
      <action>Define expected inputs and outputs</action>
      <action>Identify edge cases</action>
    </step>

    <step number="2" name="Write a Failing Test">
      <skill ref="test-generator">Use for test structure and patterns</skill>
      <action>Test the simplest case first</action>
      <action>Use descriptive test names</action>
    </step>

    <step number="3" name="Confirm Test Fails" turbo="true">
      <command>npm test -- --watch</command>
    </step>

    <step number="4" name="Write Minimum Code">
      <action>Implement just enough to pass the test</action>
      <action>Don't over-engineer</action>
      <action>Focus only on making the test pass</action>
    </step>

    <step number="5" name="Confirm Test Passes" turbo="true">
      <command>npm test</command>
    </step>

    <step number="6" name="Refactor" optional="true">
      <action>Improve readability</action>
      <action>Remove duplication</action>
      <action>Keep tests passing!</action>
    </step>

    <step number="7" name="Repeat">
      <action>Go back to step 2 for the next test case</action>
      <action>Add edge cases</action>
      <action>Add error handling</action>
      <action>Build up coverage</action>
    </step>
  </steps>

  <success_criteria>
    <criterion>All tests pass</criterion>
    <criterion>Tests cover happy path</criterion>
    <criterion>Tests cover edge cases</criterion>
    <criterion>Tests cover error scenarios</criterion>
    <criterion>Code is clean and readable</criterion>
  </success_criteria>
</workflow>
