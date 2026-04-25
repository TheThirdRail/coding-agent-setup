# Legacy Lane: test-generator

Vendor: Google Antigravity
Router: `code`
Source archive: `.\Agent\Google\deprecated-Skills\test-generator\SKILL.md`
Consolidated: 2026-04-25

The content below is the former installable skill or workflow body, preserved as an on-demand lane reference.

```markdown
---
name: test-generator
description: |
  Generate unit tests following TDD principles. Creates comprehensive test suites
  with happy path, edge cases, and error scenarios. Use when adding new features,
  fixing bugs, or improving test coverage on existing code.
---

<skill name="test-generator" version="2.0.0">
  <metadata>
    <keywords>testing, tdd, unit-tests, coverage, jest, pytest</keywords>
  </metadata>

  <goal>Generate comprehensive test suites validating code across normal, edge, and error scenarios.</goal>

  <core_principles>
    <principle name="Test Pyramid">
      <level name="Unit Tests" count="many" position="bottom"/>
      <level name="Integration Tests" count="some" position="middle"/>
      <level name="E2E Tests" count="few" position="top"/>
    </principle>

    <principle name="AAA Pattern">
      <step name="Arrange">Set up test data and mocks</step>
      <step name="Act">Call the function under test</step>
      <step name="Assert">Verify the expected outcome</step>
    </principle>

    <principle name="Test Categories">
      <category name="Happy Path" purpose="Normal operation" required="true"/>
      <category name="Edge Cases" purpose="Boundary conditions" required="true"/>
      <category name="Error Handling" purpose="Failure scenarios" required="true"/>
      <category name="Integration" purpose="Component interaction" required="important"/>
    </principle>
  </core_principles>



  <workflow>
    <step number="1" name="Analyze the Code">
      <question>What is the function supposed to do?</question>
      <question>What are the inputs and outputs?</question>
      <question>What are the edge cases?</question>
      <question>What errors can occur?</question>
      <question>What dependencies does it have?</question>
    </step>

    <step number="2" name="List Test Cases">
      <template>
        <case scenario="Normal use" input="valid input" expected="expected result" category="Happy Path"/>
        <case scenario="Empty input" input="null/undefined" expected="handle gracefully" category="Edge Case"/>
        <case scenario="Invalid input" input="wrong type" expected="throw error" category="Error"/>
        <case scenario="Boundary" input="min/max values" expected="correct behavior" category="Edge Case"/>
      </template>
    </step>

    <step number="3" name="Write Test Structure">
      <template language="javascript"><![CDATA[
describe('FunctionName', () => {
  describe('when [condition]', () => {
    it('should [expected behavior]', () => {
      // Arrange - Act - Assert
    });
  });

  describe('edge cases', () => {
    it('should handle empty input', () => {});
    it('should handle null', () => {});
  });

  describe('error handling', () => {
    it('should throw on invalid input', () => {});
  });
});
      ]]></template>
    </step>

    <step number="4" name="Implement Tests">
      <instruction>Follow AAA pattern for each test</instruction>
    </step>

    <step number="5" name="Verify Coverage">
      <command language="JavaScript">npm test -- --coverage</command>
      <command language="Python">pytest --cov=src</command>
      <command language="Go">go test -cover ./...</command>
    </step>
  </workflow>

  <test_case_templates>
    <template name="Happy Path">
      <format>Test: [function] should [expected] when [condition]</format>
      <format>Given: [preconditions] When: [action] Then: [result]</format>
    </template>

    <template name="Edge Case">
      <cases>Empty string/array/object, Null/undefined, Zero, Negative numbers, Max/min values, Special characters, Unicode/emoji</cases>
    </template>

    <template name="Error Case">
      <cases>Wrong type, Missing required fields, Out of range, Malformed data, Network failures, Timeouts</cases>
    </template>
  </test_case_templates>

  <best_practices>
    <do>Write tests before or with implementation (TDD)</do>
    <do>Use descriptive test names that explain the scenario</do>
    <do>Follow AAA pattern</do>
    <do>Test one thing per test case</do>
    <do>Mock external dependencies</do>
    <do>Include edge cases and error handling</do>
    <do>Keep tests fast</do>
    <dont>Test implementation details (test behavior)</dont>
    <dont>Share state between tests</dont>
    <dont>Write flaky tests</dont>
    <dont>Skip error case testing</dont>
    <dont>Write tests just for coverage numbers</dont>
  </best_practices>

  <commands>
    <category language="JavaScript">
      <command purpose="Run all tests">npm test</command>
      <command purpose="Watch mode">npm test -- --watch</command>
      <command purpose="Coverage">npm test -- --coverage</command>
    </category>

    <category language="Python">
      <command purpose="Run all tests">pytest</command>
      <command purpose="Verbose">pytest -v</command>
      <command purpose="Coverage">pytest --cov=src</command>
    </category>
  </commands>

  <resources>
    <script name="scaffold_tests.ps1" purpose="Automates test file scaffolding">
      <usage>.\scripts\scaffold_tests.ps1 -SourceFile "src/utils.ts"</usage>
      <description>Analyzes source file, extracts functions/classes, generates test boilerplate for Jest/pytest/Go</description>
    </script>
  </resources>

  <related_skills>
    <skill>code-reviewer</skill>
    <skill>ci-cd-debugger</skill>
  </related_skills>
</skill>
```
