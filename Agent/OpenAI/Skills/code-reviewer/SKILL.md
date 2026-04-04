---
name: code-reviewer
description: |
  Automated code review for pull requests and code changes. Identifies bugs,
  security vulnerabilities, performance issues, and style violations. Use when
  reviewing PRs, before merging code, or when requesting a second opinion on changes.
---
# Skill: code-reviewer
Attributes: name="code-reviewer", version="2.0.0"

## Metadata (`metadata`)

- `keywords`: code-review, pr, pull-request, security, bugs

## Spec Contract (`spec_contract`)

- `id`: code-reviewer

- `name`: code-reviewer

- `version`: 2.0.0

- `last_updated`: 2026-02-09

- `purpose`: Perform thorough code reviews that identify critical issues while providing actionable feedback.

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

- `goal`: Perform thorough code reviews that identify critical issues while providing actionable feedback.

## Core Principles (`core_principles`)

### Principle (`principle`)
Attributes: name="Priority Hierarchy"

- `priority` (level="P0", category="Security vulnerabilities", action="Block merge", icon="🔴")

- `priority` (level="P1", category="Bugs / Logic errors", action="Block merge", icon="🔴")

- `priority` (level="P2", category="Performance issues", action="Strongly recommend fix", icon="🟠")

- `priority` (level="P3", category="Code quality", action="Suggest improvement", icon="🟡")

- `priority` (level="P4", category="Style / Formatting", action="Optional nitpick", icon="🟢")

### Principle (`principle`)
Attributes: name="Constructive Feedback"

- `rule`: Explain WHY something is an issue

- `rule`: Provide HOW to fix it

- `rule`: Link to documentation when relevant

- `rule`: Be specific, not vague

## Recommended Mcp (`recommended_mcp`)

- `server`: snyk

- `server`: serena

- `reason`: Vulnerability scanning and semantic code context

## Workflow (`workflow`)

### Step (`step`)
Attributes: number="1", name="Understand Context"

- `question`: What is this PR trying to accomplish?

- `question`: What issue/ticket does it address?

### Step (`step`)
Attributes: number="2", name="High-Level Scan"

- `check`: Does the change make sense for the stated goal?

- `check`: Is the scope appropriate?

- `check`: Are there any obvious red flags?

### Step (`step`)
Attributes: number="3", name="Security Review"

- `skill` (ref="security-checker"): Use for detailed security analysis

- `vulnerability` (name="Injection"): Unsanitized user input in queries

- `vulnerability` (name="Auth Issues"): Missing auth/authz checks

- `vulnerability` (name="Secrets"): Hardcoded API keys, passwords

- `vulnerability` (name="XSS"): Unescaped user content in HTML

- `vulnerability` (name="Path Traversal"): User input in file paths

### Step (`step`)
Attributes: number="4", name="Bug Detection"

- `bug_type` (name="Null/Undefined"): Missing null checks

- `bug_type` (name="Off-by-One"): Loop boundaries, array indexing

- `bug_type` (name="Race Conditions"): Async without sync

- `bug_type` (name="Resource Leaks"): Unclosed connections

### Step (`step`)
Attributes: number="5", name="Performance Review"

- `issue` (name="N+1 Queries"): Database calls inside loops

- `issue` (name="Unnecessary Renders"): React re-rendering issues

- `issue` (name="Memory Leaks"): Event listeners not cleaned up

### Step (`step`)
Attributes: number="6", name="Code Quality"

- `check`: Functions are focused (single responsibility)

- `check`: Names are descriptive and clear

- `check`: Complex logic is documented

- `check`: DRY principle followed

### Step (`step`)
Attributes: number="7", name="Test Coverage"

- `check`: New code has corresponding tests

- `check`: Tests cover happy path and edge cases

## Feedback Templates (`feedback_templates`)

- `template` (priority="P0"):
```text
🔴 **Security: [Issue Type]**
**Problem:** [What the vulnerability is]
**Risk:** [What could happen]
**Fix:** [How to remediate]
```

- `template` (priority="P1"):
```text
🔴 **Bug: [Brief Description]**
**Problem:** [What the bug is]
**Scenario:** [When this would fail]
**Suggested Fix:** [Code example]
```

- `template` (priority="P2"):
```text
🟠 **Performance: [Issue Type]**
**Current:** [What's happening]
**Suggested:** [Better approach]
```

## Best Practices (`best_practices`)

- `do`: Start with security and correctness issues

- `do`: Provide specific, actionable feedback

- `do`: Explain the "why" behind suggestions

- `do`: Acknowledge good code when you see it

- `do`: Prioritize issues by severity

- `dont`: Focus only on style nitpicks

- `dont`: Be vague ("this looks wrong")

- `dont`: Block on minor issues

- `dont`: Be condescending or harsh

## Related Skills (`related_skills`)

- `skill` (ref="security-checker", auto-invoke="true"): Invoke for auth, input handling, or API changes

- `skill`: git-commit-generator

- `skill`: test-generator

- `skill`: architecture-planner
