# Legacy Lane: refactor

Vendor: Google Antigravity
Router: `code`
Source archive: `.\Agent\Google\deprecated-Workflows\refactor.md`
Consolidated: 2026-04-25

The content below is the former installable skill or workflow body, preserved as an on-demand lane reference.

```markdown
---
description: Refactor Mode - Refactor code with full database context to prevent breaking changes
---

<workflow name="refactor" thinking="Normal">
  <purpose>Safely refactor code while maintaining all relationships and updating databases.</purpose>

  <when_to_use>
    <trigger>File exceeds 300+ lines (suggest), 500+ (strong), 800+ (blocking)</trigger>
    <trigger>Function exceeds 50+ lines (suggest), 100+ (strong)</trigger>
    <trigger>Pattern repeated 3+ times (extract to utility)</trigger>
    <trigger>Code smell identified</trigger>
    <trigger>User requests cleanup</trigger>
  </when_to_use>

  <steps>
    <step number="1" name="Load Context from Databases">
      <instruction>Query all 3 databases BEFORE making changes:</instruction>
      <instruction>Route retrieval through archive-manager and prefer fresh archives before broad source scans.</instruction>
      <database name="mem0/memory">
        <query>What is this file's purpose?</query>
        <query>What patterns does this project use?</query>
        <query>Any documented decisions about this code?</query>
      </database>
      <database name="codegraph">
        <query>What files depend on this one?</query>
        <query>What functions call the ones I'm changing?</query>
        <query>What will break if I change this signature?</query>
      </database>
      <database name="ragdocs">
        <query>Any documentation about this code?</query>
        <query>Comments explaining non-obvious logic?</query>
      </database>
    </step>

    <step number="2" name="Identify All References">
      <action>Search for all usages across the codebase</action>
      <action>List all files that import/reference it</action>
      <action>Identify all call sites</action>
      <action>Note any external dependencies</action>
    </step>

    <step number="3" name="Plan the Refactor">
      <skill ref="code-reviewer">Use to identify code smells</skill>
      <skill ref="code-style-enforcer">Use to enforce naming/comment/DRY/type-safety standards during refactor planning</skill>
      <action>Identify the code smell (why refactor?)</action>
      <action>Propose strategy before executing</action>
      <action>Plan for backwards compatibility if needed</action>
      <action>Estimate risk level</action>
    </step>

    <step number="4" name="Execute Incrementally">
      <instruction>For each change:</instruction>
      <action>Make ONE logical change</action>
      <action>Update all call sites</action>
      <action>Run tests</action>
      <action>Verify nothing broke</action>
      <action>Commit or checkpoint</action>
    </step>

    <step number="5" name="Update Imports/References">
      <action>Fix all import statements</action>
      <action>Update any configuration files</action>
      <action>Modify any documentation</action>
    </step>

    <step number="6" name="Verify Functionality">
      <action>Run all tests</action>
      <action>Manual verification of affected features</action>
      <action>Check for regressions</action>
    </step>

    <step number="7" name="Update Databases">
      <instruction>After successful refactor, use archive-manager to refresh archive-code/archive-docs/archive-git/archive-graph/archive-memory for changed artifacts.</instruction>
    </step>

    <step number="8" name="Run Quality Gate (Mandatory)">
      <instruction>Apply the `/quality-gates` rubric before finalizing refactor completion.</instruction>
      <instruction>If any critical gate is BLOCK, continue remediation and rerun checks.</instruction>
    </step>
  </steps>

  <triggers>
    <trigger condition="File > 300 lines" severity="Suggest">Offer to refactor</trigger>
    <trigger condition="File > 500 lines" severity="Strong">Recommend refactoring</trigger>
    <trigger condition="File > 800 lines" severity="Blocking">Refuse to add more code</trigger>
    <trigger condition="Function > 50 lines" severity="Suggest">Offer to break up</trigger>
    <trigger condition="Function > 100 lines" severity="Strong">Recommend breaking up</trigger>
    <trigger condition="Pattern 3+ times" severity="Extract">Create utility function</trigger>
  </triggers>

  <exit_criteria>
    <criterion>Refactoring complete</criterion>
    <criterion>All tests passing</criterion>
    <criterion>All references updated</criterion>
    <criterion>All 3 databases updated</criterion>
    <criterion>Quality gate result is PASS</criterion>
    <criterion>No regressions</criterion>
  </exit_criteria>
</workflow>
```
