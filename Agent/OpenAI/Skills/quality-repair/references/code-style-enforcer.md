# Legacy Lane: code-style-enforcer

Vendor: OpenAI Codex
Router: `quality-repair`
Source archive: `.\Agent\Google\deprecated-Skills\code-style-enforcer\SKILL.md`
Consolidated: 2026-04-25

The content below is the former installable skill or workflow body, preserved as an on-demand lane reference.

```markdown
---
name: code-style-enforcer
description: |
  Enforce naming, commenting, DRY, and type-safety style conventions.
  Use when implementing, reviewing, or refactoring code changes.
---

<skill name="code-style-enforcer" version="1.0.0">
  <metadata>
    <keywords>style, naming, comments, dry, types</keywords>
  </metadata>

  <goal>Prevent style drift and preserve readability and maintainability across changes.</goal>

  <core_principles>
    <principle name="Descriptive Naming">
      <rule>Use clear, descriptive names and avoid opaque abbreviations.</rule>
      <rule>Function names should start with verbs.</rule>
      <rule>Boolean names should read as yes/no questions.</rule>
    </principle>
    <principle name="Comment Quality">
      <rule>Explain why, not what.</rule>
      <rule>Document non-obvious decisions and tradeoffs.</rule>
      <rule>Keep comments synchronized with behavior.</rule>
    </principle>
    <principle name="Duplication Control">
      <rule>If a pattern appears three or more times, recommend extraction.</rule>
      <rule>Extract magic numbers and strings into named constants.</rule>
    </principle>
    <principle name="Type Precision">
      <rule>Prefer explicit types or generics over broad fallback types.</rule>
      <rule>Avoid untyped escape hatches unless explicitly justified.</rule>
    </principle>
  </core_principles>

  <workflow>
    <step number="1" name="Inspect Changed Code">
      <instruction>Evaluate naming, comments, magic values, duplication, and type specificity.</instruction>
    </step>
    <step number="2" name="Classify Findings">
      <instruction>Tag findings by severity: error, warning, suggestion.</instruction>
    </step>
    <step number="3" name="Produce Guidance">
      <instruction>Provide concrete before/after recommendations.</instruction>
    </step>
  </workflow>

  <best_practices>
    <do>Apply style guidance uniformly to new and refactored code.</do>
    <do>Prioritize readability over cleverness.</do>
    <dont>Accept unresolved any-type pathways without rationale.</dont>
  </best_practices>

  <related_skills>
    <skill>code-reviewer</skill>
    <skill>test-generator</skill>
  </related_skills>

  <related_workflows>
    <workflow>/code</workflow>
    <workflow>/review</workflow>
    <workflow>/refactor</workflow>
  </related_workflows>
</skill>
```
