# Legacy Lane: review

Vendor: Google Antigravity
Router: `quality-repair`
Source archive: `.\Agent\Google\deprecated-Workflows\review.md`
Consolidated: 2026-04-25

The content below is the former installable skill or workflow body, preserved as an on-demand lane reference.

```markdown
---
description: Standalone code review for specific files or changes
---

<workflow name="review" thinking="Normal">
  <when_to_use>
    <trigger>Request a code review on specific files</trigger>
    <trigger>Review changes before committing</trigger>
    <trigger>Get a second opinion on implementation</trigger>
    <trigger>Pre-merge quality check without full PR workflow</trigger>
  </when_to_use>

  <constraints>
    <constraint>Focus on code quality, not deployment</constraint>
    <constraint>Use for targeted review, not full project audits</constraint>
  </constraints>

  <steps>
    <step number="1" name="Identify Scope">
      <action>Ask user which files or folders to review.</action>
      <action>Clarify review focus (security, performance, style, all).</action>
      <output>List of files to review.</output>
    </step>

    <step number="2" name="Run Code Review">
      <skill ref="code-reviewer">Invoke full code review analysis</skill>
      <skill ref="security-checker">Include if security focus requested</skill>
      <skill ref="code-style-enforcer">Evaluate naming, comments, DRY, and type-safety findings</skill>
      <instruction>Review for: bugs, style, complexity, maintainability.</instruction>
    </step>

    <step number="3" name="Communication Protocol">
      <skill ref="communication-protocol-enforcer">Use structured progress and blocker messaging during review</skill>
      <rule>Use concise findings-first format with explicit remediation steps.</rule>
    </step>

    <step number="4" name="Run Quality Gate (Mandatory)">
      <instruction>Apply the `/quality-gates` rubric to reviewed changes.</instruction>
      <instruction>Return explicit gate outputs: refactor_gate, testing_gate, documentation_gate, overall_status.</instruction>
      <instruction>If `overall_status=BLOCK`, include remediation checklist and do not recommend merge.</instruction>
    </step>

    <step number="5" name="Context Governance (Release Event)">
      <instruction>Apply `/context-governance` with `event_type=release` when reviewed changes are release candidates.</instruction>
      <instruction>Validate archive actions and policy violations before merge recommendation.</instruction>
    </step>

    <step number="6" name="Report Findings">
      <action>Present prioritized list of issues.</action>
      <format>
        🔴 Critical / 🟠 High / 🟡 Medium / 🟢 Low
        File: Issue description → Suggested fix
      </format>
      <action>Include quality gate summary and release-governance status.</action>
      <action>Offer to fix issues if user approves.</action>
    </step>
  </steps>

  <success_criteria>
    <criterion>All specified files reviewed</criterion>
    <criterion>Issues prioritized by severity</criterion>
    <criterion>Quality gate report included</criterion>
    <criterion>Actionable suggestions provided</criterion>
  </success_criteria>

  <related_skills>
    <skill>code-reviewer</skill>
    <skill>security-checker</skill>
    <skill>code-style-enforcer</skill>
    <skill>communication-protocol-enforcer</skill>
  </related_skills>

  <related_workflows>
    <workflow>/quality-gates</workflow>
    <workflow>/context-governance</workflow>
  </related_workflows>
</workflow>
```
