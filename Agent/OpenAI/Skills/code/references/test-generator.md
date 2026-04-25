# Legacy Lane: test-generator

Vendor: OpenAI Codex
Router: `code`
Source archive: `.\Agent\OpenAI\deprecated-Skills\test-generator\SKILL.md`
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
# Skill: test-generator
Attributes: name="test-generator", version="2.0.0"

## Metadata (`metadata`)

- `keywords`: testing, tdd, unit-tests, coverage, jest, pytest

## Spec Contract (`spec_contract`)

- `id`: test-generator

- `name`: test-generator

- `version`: 2.0.0

- `last_updated`: 2026-02-09

- `purpose`: Generate comprehensive test suites validating code across normal, edge, and error scenarios.

### Inputs (`inputs`)

- `input`: User request and relevant project context.

### Outputs (`outputs`)

- `output`: Completed guidance, actions, or artifacts produced by this skill.

### Triggers (`triggers`)

- `trigger`: Use when the frontmatter description conditions are met.

- `procedure`: Follow the ordered steps in the workflow section.

### Edge Cases (`edge_cases`)

- `edge_case`: If required context is missing, gather or request it before continuing.

### Safety Constraints (`safety_constraints`)

- `constraint`: Avoid destructive operations without explicit user intent.

### Examples (`examples`)

- `example`: Activate this skill when the request matches its trigger conditions.

- `goal`: Generate comprehensive test suites validating code across normal, edge, and error scenarios.

## Core Principles (`core_principles`)

### Principle (`principle`)
Attributes: name="Test Pyramid"

- `level` (name="Unit Tests", count="many", position="bottom")

- `level` (name="Integration Tests", count="some", position="middle")

- `level` (name="E2E Tests", count="few", position="top")

### Principle (`principle`)
Attributes: name="AAA Pattern"

- `step` (name="Arrange"): Set up test data and mocks

- `step` (name="Act"): Call the function under test

- `step` (name="Assert"): Verify the expected outcome

### Principle (`principle`)
Attributes: name="Test Categories"

- `category` (name="Happy Path", purpose="Normal operation", required="true")

- `category` (name="Edge Cases", purpose="Boundary conditions", required="true")

- `category` (name="Error Handling", purpose="Failure scenarios", required="true")

- `category` (name="Integration", purpose="Component interaction", required="important")

## Workflow (`workflow`)

### Step (`step`)
Attributes: number="1", name="Analyze the Code"

- `question`: What is the function supposed to do?

- `question`: What are the inputs and outputs?

- `question`: What are the edge cases?

- `question`: What errors can occur?

- `question`: What dependencies does it have?

### Step (`step`)
Attributes: number="2", name="List Test Cases"

#### Template (`template`)

- `case` (scenario="Normal use", input="valid input", expected="expected result", category="Happy Path")

- `case` (scenario="Empty input", input="null/undefined", expected="handle gracefully", category="Edge Case")

- `case` (scenario="Invalid input", input="wrong type", expected="throw error", category="Error")

- `case` (scenario="Boundary", input="min/max values", expected="correct behavior", category="Edge Case")

### Step (`step`)
Attributes: number="3", name="Write Test Structure"

- `template` (language="javascript"):
```text
describe('FunctionName', () =&gt; {
  describe('when [condition]', () =&gt; {
    it('should [expected behavior]', () =&gt; {
      // Arrange - Act - Assert
    });
  });

  describe('edge cases', () =&gt; {
    it('should handle empty input', () =&gt; {});
    it('should handle null', () =&gt; {});
  });

  describe('error handling', () =&gt; {
    it('should throw on invalid input', () =&gt; {});
  });
});
```

### Step (`step`)
Attributes: number="4", name="Implement Tests"

- `instruction`: Follow AAA pattern for each test

### Step (`step`)
Attributes: number="5", name="Verify Coverage"

- `command` (language="JavaScript"): npm test -- --coverage

- `command` (language="Python"): pytest --cov=src

- `command` (language="Go"): go test -cover ./...

## Test Case Templates (`test_case_templates`)

### Template (`template`)
Attributes: name="Happy Path"

- `format`: Test: [function] should [expected] when [condition]

- `format`: Given: [preconditions] When: [action] Then: [result]

### Template (`template`)
Attributes: name="Edge Case"

- `cases`: Empty string/array/object, Null/undefined, Zero, Negative numbers, Max/min values, Special characters, Unicode/emoji

### Template (`template`)
Attributes: name="Error Case"

- `cases`: Wrong type, Missing required fields, Out of range, Malformed data, Network failures, Timeouts

## Best Practices (`best_practices`)

- `do`: Write tests before or with implementation (TDD)

- `do`: Use descriptive test names that explain the scenario

- `do`: Follow AAA pattern

- `do`: Test one thing per test case

- `do`: Mock external dependencies

- `do`: Include edge cases and error handling

- `do`: Keep tests fast

- `dont`: Test implementation details (test behavior)

- `dont`: Share state between tests

- `dont`: Write flaky tests

- `dont`: Skip error case testing

- `dont`: Write tests just for coverage numbers

## Commands (`commands`)

### Category (`category`)
Attributes: language="JavaScript"

- `command` (purpose="Run all tests"): npm test

- `command` (purpose="Watch mode"): npm test -- --watch

- `command` (purpose="Coverage"): npm test -- --coverage

### Category (`category`)
Attributes: language="Python"

- `command` (purpose="Run all tests"): pytest

- `command` (purpose="Verbose"): pytest -v

- `command` (purpose="Coverage"): pytest --cov=src

## Resources (`resources`)

### Script (`script`)
Attributes: name="scaffold_tests.ps1", purpose="Automates test file scaffolding"

- `usage`: .\scripts\scaffold_tests.ps1 -SourceFile "src/utils.ts"

- `description`: Analyzes source file, extracts functions/classes, generates test boilerplate for Jest/pytest/Go

## Related Skills (`related_skills`)

- `skill`: code-reviewer

- `skill`: ci-cd-debugger
```
