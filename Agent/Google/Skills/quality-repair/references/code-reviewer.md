# Legacy Lane: code-reviewer

Vendor: Google Antigravity
Router: `quality-repair`
Source archive: `.\Agent\Google\deprecated-Skills\code-reviewer\SKILL.md`
Consolidated: 2026-04-25

The content below is the former installable skill or workflow body, preserved as an on-demand lane reference.

```markdown
---
name: code-reviewer
description: |
  Automated code review for pull requests and code changes. Identifies bugs,
  security vulnerabilities, performance issues, and style violations. Use when
  reviewing PRs, before merging code, or when requesting a second opinion on changes.
---

<skill name="code-reviewer" version="2.0.0">
  <metadata>
    <keywords>code-review, pr, pull-request, security, bugs</keywords>
  </metadata>

  <goal>Perform thorough code reviews that identify critical issues while providing actionable feedback.</goal>

  <core_principles>
    <principle name="Priority Hierarchy">
      <priority level="P0" category="Security vulnerabilities" action="Block merge" icon="🔴"/>
      <priority level="P1" category="Bugs / Logic errors" action="Block merge" icon="🔴"/>
      <priority level="P2" category="Performance issues" action="Strongly recommend fix" icon="🟠"/>
      <priority level="P3" category="Code quality" action="Suggest improvement" icon="🟡"/>
      <priority level="P4" category="Style / Formatting" action="Optional nitpick" icon="🟢"/>
    </principle>

    <principle name="Constructive Feedback">
      <rule>Explain WHY something is an issue</rule>
      <rule>Provide HOW to fix it</rule>
      <rule>Link to documentation when relevant</rule>
      <rule>Be specific, not vague</rule>
    </principle>
  </core_principles>



  <recommended_mcp>
    <server>snyk</server>
    <server>serena</server>
    <reason>Vulnerability scanning and semantic code context</reason>
  </recommended_mcp>

  <workflow>
    <step number="1" name="Understand Context">
      <question>What is this PR trying to accomplish?</question>
      <question>What issue/ticket does it address?</question>
    </step>

    <step number="2" name="High-Level Scan">
      <check>Does the change make sense for the stated goal?</check>
      <check>Is the scope appropriate?</check>
      <check>Are there any obvious red flags?</check>
    </step>

    <step number="3" name="Security Review">
      <skill ref="security-checker">Use for detailed security analysis</skill>
      <vulnerability name="Injection">Unsanitized user input in queries</vulnerability>
      <vulnerability name="Auth Issues">Missing auth/authz checks</vulnerability>
      <vulnerability name="Secrets">Hardcoded API keys, passwords</vulnerability>
      <vulnerability name="XSS">Unescaped user content in HTML</vulnerability>
      <vulnerability name="Path Traversal">User input in file paths</vulnerability>
    </step>

    <step number="4" name="Bug Detection">
      <bug_type name="Null/Undefined">Missing null checks</bug_type>
      <bug_type name="Off-by-One">Loop boundaries, array indexing</bug_type>
      <bug_type name="Race Conditions">Async without sync</bug_type>
      <bug_type name="Resource Leaks">Unclosed connections</bug_type>
    </step>

    <step number="5" name="Performance Review">
      <issue name="N+1 Queries">Database calls inside loops</issue>
      <issue name="Unnecessary Renders">React re-rendering issues</issue>
      <issue name="Memory Leaks">Event listeners not cleaned up</issue>
    </step>

    <step number="6" name="Code Quality">
      <check>Functions are focused (single responsibility)</check>
      <check>Names are descriptive and clear</check>
      <check>Complex logic is documented</check>
      <check>DRY principle followed</check>
    </step>

    <step number="7" name="Test Coverage">
      <check>New code has corresponding tests</check>
      <check>Tests cover happy path and edge cases</check>
    </step>
  </workflow>

  <feedback_templates>
    <template priority="P0"><![CDATA[
🔴 **Security: [Issue Type]**
**Problem:** [What the vulnerability is]
**Risk:** [What could happen]
**Fix:** [How to remediate]
    ]]></template>

    <template priority="P1"><![CDATA[
🔴 **Bug: [Brief Description]**
**Problem:** [What the bug is]
**Scenario:** [When this would fail]
**Suggested Fix:** [Code example]
    ]]></template>

    <template priority="P2"><![CDATA[
🟠 **Performance: [Issue Type]**
**Current:** [What's happening]
**Suggested:** [Better approach]
    ]]></template>
  </feedback_templates>

  <best_practices>
    <do>Start with security and correctness issues</do>
    <do>Provide specific, actionable feedback</do>
    <do>Explain the "why" behind suggestions</do>
    <do>Acknowledge good code when you see it</do>
    <do>Prioritize issues by severity</do>
    <dont>Focus only on style nitpicks</dont>
    <dont>Be vague ("this looks wrong")</dont>
    <dont>Block on minor issues</dont>
    <dont>Be condescending or harsh</dont>
  </best_practices>

  <related_skills>
    <skill ref="security-checker" auto-invoke="true">Invoke for auth, input handling, or API changes</skill>
    <skill>git-commit-generator</skill>
    <skill>test-generator</skill>
    <skill>architecture-planner</skill>
  </related_skills>
</skill>
```
