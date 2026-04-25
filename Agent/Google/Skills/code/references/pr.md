# Legacy Lane: pr

Vendor: Google Antigravity
Router: `code`
Source archive: `.\Agent\Google\deprecated-Workflows\pr.md`
Consolidated: 2026-04-25

The content below is the former installable skill or workflow body, preserved as an on-demand lane reference.

```markdown
---
description: Create a pull request with proper description, tests verified, and ready for review
---

<workflow name="pr" thinking="Normal">
  <when_to_use>
    <trigger>When code is ready for review</trigger>
    <trigger>When a feature or fix is complete</trigger>
    <trigger>Before merging to main branch</trigger>
  </when_to_use>

  <recommended_mcp>
    <server>github</server>
    <reason>Pull request automation and management</reason>
  </recommended_mcp>

  <steps>
    <step number="1" name="Verify Tests Pass" turbo="true">
      <command>npm test</command>
    </step>

    <step number="2" name="Run Linter" turbo="true">
      <command>npm run lint</command>
    </step>

    <step number="3" name="Check What's Changed" turbo="true">
      <command>git diff main --stat</command>
    </step>

    <step number="4" name="Clean Up Commits" optional="true">
      <action>Combine "WIP" commits</action>
      <action>Write clear commit messages</action>
      <action>Each commit should be meaningful</action>
    </step>

    <step number="5" name="Run Quality Gate (Mandatory)">
      <instruction>Apply `/quality-gates` to the full PR diff before pushing.</instruction>
      <instruction>If `overall_status=BLOCK`, stop and remediate before PR creation.</instruction>
      <required_output>overall_status=PASS</required_output>
    </step>

    <step number="6" name="Push Branch" turbo="true">
      <command>git push -u origin HEAD</command>
    </step>

    <step number="7" name="Generate PR Description">
      <template><![CDATA[
## What
[Brief description of what this PR does]

## Why
[Why this change is needed - link to issue if applicable]

## How
[How the change works, key implementation details]

## Testing
- [ ] Unit tests added/updated
- [ ] Manual testing completed
- [ ] Edge cases covered
- [ ] Quality gates PASS

## Screenshots (if UI changes)
[Add screenshots here]
      ]]></template>
    </step>

    <step number="8" name="Create the PR">
      <action>Use the generated description</action>
      <action>Add appropriate labels</action>
      <action>Request reviewers</action>
    </step>

    <step number="9" name="Context Governance (Release Event)">
      <instruction>Apply `/context-governance` with `event_type=release` for release-traceability and archive checks.</instruction>
      <instruction>Include governance report status in PR notes when relevant.</instruction>
    </step>

    <step number="10" name="Self-Review">
      <skill ref="code-reviewer">Use for systematic self-review</skill>
      <skill ref="code-style-enforcer">Confirm style and maintainability compliance on final diff</skill>
      <action>Review the diff in the PR interface</action>
      <action>Check for accidental debug code</action>
      <action>Verify no secrets are exposed</action>
    </step>
  </steps>

  <success_criteria>
    <criterion>All tests pass</criterion>
    <criterion>Linter passes</criterion>
    <criterion>Quality gate result is PASS</criterion>
    <criterion>PR description explains what/why/how</criterion>
    <criterion>Reviewers assigned</criterion>
    <criterion>No debug code or secrets</criterion>
  </success_criteria>

  <related_workflows>
    <workflow>/quality-gates</workflow>
    <workflow>/context-governance</workflow>
    <workflow>/review</workflow>
  </related_workflows>
</workflow>
```
