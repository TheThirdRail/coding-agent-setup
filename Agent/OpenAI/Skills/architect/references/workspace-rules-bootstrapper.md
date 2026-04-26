# Legacy Lane: workspace-rules-bootstrapper

Vendor: OpenAI Codex
Router: `architect`
Source archive: `.\Agent\Google\deprecated-Skills\workspace-rules-bootstrapper\SKILL.md`
Consolidated: 2026-04-25

The content below is the former installable skill or workflow body, preserved as an on-demand lane reference.

```markdown
---
name: workspace-rules-bootstrapper
description: |
  Generate project-scoped workspace rules from a selected stack profile and baseline policy modules.
  Use when initializing a repository during project setup before implementation begins.
---

<skill name="workspace-rules-bootstrapper" version="1.0.0">
  <metadata>
    <keywords>workspace, rules, bootstrap, project-setup, policy</keywords>
  </metadata>

  <goal>Create a deterministic workspace rule file with stack-specific additions and global quality baselines.</goal>

  <core_principles>
    <principle name="Deterministic Baseline">
      <rule>Always include read-before-write, testing gate, docs gate, and dependency isolation constraints.</rule>
      <rule>Emit baseline modules in stable order: dependency-isolation, quality-gates, runtime-safety, documentation-updates.</rule>
    </principle>
    <principle name="Stack-Aware Additions">
      <rule>Add language and framework-specific constraints based on selected stack profile.</rule>
    </principle>
    <principle name="Size Safety">
      <rule>Keep generated workspace rule files below 12,000 characters.</rule>
    </principle>
  </core_principles>

  <references>
    <reference file="references/workspace-rule-template.md">Template and module composition instructions for generated workspace rules.</reference>
  </references>

  <workflow>
    <step number="1" name="Collect Inputs">
      <instruction>Capture stack profile, framework, testing stack, and deployment target.</instruction>
    </step>
    <step number="2" name="Assemble Baseline Modules">
      <instruction>Apply baseline modules: dependency isolation, quality gates, runtime safety, and documentation updates.</instruction>
    </step>
    <step number="3" name="Add Stack-Specific Rules">
      <instruction>Append stack-specific constraints from selected profile.</instruction>
    </step>
    <step number="4" name="Generate Workspace Rule File">
      <instruction>Emit `Agent-Context/Rules/project-rules.md` using the template structure.</instruction>
      <instruction>Include generation metadata fields: `stack_profile`, `baseline_modules`, and `char_count`.</instruction>
    </step>
    <step number="5" name="Validate Output">
      <instruction>Validate structure and character count; trim non-essential detail if over budget.</instruction>
    </step>
  </workflow>

  <output_contract>
    <output file="Agent-Context/Rules/project-rules.md">Workspace rule file with baseline + stack-specific policy.</output>
    <field>stack_profile</field>
    <field>baseline_modules</field>
    <field>char_count</field>
  </output_contract>

  <best_practices>
    <do>Generate concise constraints and keep procedural detail in workflows/skills.</do>
    <do>Reference canonical global policy modules instead of duplicating long content.</do>
    <dont>Create workspace rules without explicit stack inputs.</dont>
  </best_practices>

  <related_skills>
    <skill>rule-builder</skill>
    <skill>architecture-planner</skill>
  </related_skills>

  <related_workflows>
    <workflow>/project-setup</workflow>
    <workflow>/architect</workflow>
  </related_workflows>
</skill>
```
