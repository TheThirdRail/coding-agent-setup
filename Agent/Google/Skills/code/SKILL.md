---
name: code
description: |
  Implement approved plans, refactor, test, prepare commits or PRs, and handle deployment execution.
  Use when implementing a plan, coding a feature, refactoring, creating tests, preparing commits/PRs, or executing deploy/release steps.
---

<skill name="code" version="3.0.0">
  <metadata>
    <keywords>
      <keyword>code</keyword>
      <keyword>implement</keyword>
      <keyword>refactor</keyword>
      <keyword>test</keyword>
      <keyword>commit</keyword>
      <keyword>pr</keyword>
      <keyword>deploy</keyword>
      <keyword>release</keyword>
    </keywords>
  </metadata>

  <goal>Implement approved plans, refactor, test, prepare commits or PRs, and handle deployment execution.</goal>

  <core_principles>
    <principle name="Progressive Disclosure">
      <rule>Keep this skill as a compact router and load detailed lane references only on demand.</rule>
    </principle>
    <principle name="Intent Routing">
      <rule>Choose the narrowest matching route before reading references or using scripts.</rule>
    </principle>
    <principle name="Compatibility Preservation">
      <rule>Use consolidated lane references to preserve former skill and workflow behavior without reinstalling alias skills.</rule>
    </principle>
  </core_principles>
  <routing>
    <route intent="Implementation from plan" reference="references/code.md">Read when executing an approved plan or checklist.</route>
    <route intent="Refactoring" reference="references/refactor.md">Read when reducing complexity, large files/functions, or duplication.</route>
    <route intent="TDD workflow" reference="references/test-developer.md">Read when tests should drive feature or bug work.</route>
    <route intent="Test generation" reference="references/test-generator.md">Read when scaffolding or expanding unit/regression tests.</route>
    <route intent="Commit message" reference="references/git-commit-generator.md">Read when generating a conventional commit message from staged changes.</route>
    <route intent="Pull request preparation" reference="references/pr.md">Read when preparing PR summary, labels, review state, or merge readiness.</route>
    <route intent="Deployment/release" reference="references/deploy.md">Read when rolling out to staging/production or creating release steps.</route>
  </routing>

  <workflow>
    <step number="1" name="Classify Intent">
      <instruction>Choose the narrowest matching route from this skill.</instruction>
    </step>
    <step number="2" name="Load One Lane">
      <instruction>Read only the selected reference file before executing specialized steps.</instruction>
    </step>
    <step number="3" name="Use Resources On Demand">
      <instruction>Load scripts, assets, or extra references only when the selected lane requires them.</instruction>
    </step>
    <step number="4" name="Report Route">
      <instruction>State the lane used when it affects auditability, handoff, or recovery.</instruction>
    </step>
  </workflow>

  <best_practices>
    <do>Read the selected lane reference before specialized work.</do>
    <do>Use bundled scripts, assets, or extra references only when the selected lane requires them.</do>
    <do>State the selected route when it affects auditability, handoff, or recovery.</do>
    <dont>Load multiple lane references unless the user request genuinely crosses responsibilities.</dont>
  </best_practices>
  <consolidated_skills>
    <former_skill>code</former_skill>
    <former_skill>refactor</former_skill>
    <former_skill>test-developer</former_skill>
    <former_skill>test-generator</former_skill>
    <former_skill>git-commit-generator</former_skill>
    <former_skill>pr</former_skill>
    <former_skill>deploy</former_skill>
  </consolidated_skills>
  <related_skills>
    <skill>quality-repair</skill>
    <skill>archive-manager</skill>
    <skill>research-docs</skill>
  </related_skills>
</skill>
