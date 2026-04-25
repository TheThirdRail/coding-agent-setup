# Workspace Rule Template

Use this template when generating `.agent/rules/project-rules.md`.

```md
---
name: project-rules
description: |
  Workspace-specific rules for this project.
  Includes stack conventions and testing requirements.
activation: always_on
---

<rule name="project-rules" version="1.0.0">
  <metadata>
    <category>project-specific</category>
    <severity>error</severity>
  </metadata>

  <stack_profile>[stack profile]</stack_profile>

  <baseline_modules>
    <module>dependency-isolation</module>
    <module>quality-gates</module>
    <module>runtime-safety</module>
    <module>documentation-updates</module>
  </baseline_modules>

  <constraints>
    <must>Read before write for all source edits.</must>
    <must>Run tests before merge/completion.</must>
    <must>Use project-scoped dependency management for active ecosystems.</must>
    <must>Update docs when interfaces or behavior change.</must>
  </constraints>

  <stack_specific_constraints>
    [stack-specific rules inserted here]
  </stack_specific_constraints>

  <generation_metadata>
    <field name="stack_profile">[stack profile]</field>
    <field name="baseline_modules">dependency-isolation, quality-gates, runtime-safety, documentation-updates</field>
    <field name="char_count">[computed character count]</field>
  </generation_metadata>
</rule>
```

## Size rule
- Keep generated files under 12,000 characters.
- Move long procedural guidance to skills/workflows.
