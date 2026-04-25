# Legacy Lane: analyze

Vendor: Google Antigravity
Router: `quality-repair`
Source archive: `.\Agent\Google\deprecated-Workflows\analyze.md`
Consolidated: 2026-04-25

The content below is the former installable skill or workflow body, preserved as an on-demand lane reference.

```markdown
---
description: Analyze Mode - Debug issues and diagnose problems with maximum reasoning depth
---

<workflow name="analyze" thinking="MAX">
  <important>Use MAXIMUM thinking/reasoning depth. Exhaust all diagnostic paths.</important>

  <when_to_use>
    <trigger>Encountering a bug or error</trigger>
    <trigger>Something isn't working as expected</trigger>
    <trigger>Need to diagnose a problem before fixing</trigger>
  </when_to_use>

  <recommended_mcp>
    <server>sequential-thinking</server>
    <server>serena</server>
    <reason>Deep root cause analysis and experimentation</reason>
  </recommended_mcp>

  <constraints>
    <constraint>DO NOT write implementation code in this workflow</constraint>
    <constraint>DO NOT modify source files (read-only diagnosis)</constraint>
    <constraint>Focus ONLY on diagnosing the root cause</constraint>
    <constraint>Switch to /fix-issue or /debug-step to apply fixes</constraint>
  </constraints>

  <steps>
    <step number="1" name="Assess the Issue">
      <condition type="obvious">Proceed directly to research</condition>
      <condition type="unclear">Restate the issue and ask "Is this correct?" before proceeding</condition>
    </step>

    <step number="2" name="Research and Gather Context">
      <skill ref="research-capability">Use for documentation and code examples</skill>
      <skill ref="performance-analyzer">Use if diagnosing performance issues</skill>
      <skill ref="communication-protocol-enforcer">Use for structured blocker and progress communication while investigating</skill>
      <tool>File search and code inspection</tool>
      <tool>Web search for similar issues</tool>
      <tool>Log analysis</tool>
      <tool>Error message research</tool>
      <tool>Check relevant documentation</tool>
    </step>

    <step number="3" name="Hypothesize Causes">
      <instruction>Generate a ranked list of possible causes from most to least likely</instruction>
      <format><![CDATA[

## Analysis Report

**Issue:** [One-sentence summary]

### Possible Causes (Ranked)

1. **[Most Likely]** — [Why] — [How to verify] — [Suggested fix]
2. **[Next Most Likely]** — [Why] — [Verify] — [Fix]
3. **[Less Likely]** — [Why] — [Verify] — [Fix]
      ]]></format>
    </step>

    <step number="4" name="Recommend Next Steps">
      <action>Provide a clear diagnostic plan</action>
      <action>Recommend switching to /fix-issue or /debug-step to implement the fix</action>
      <action>If multiple approaches exist, ask user preference</action>
    </step>

    <step number="5" name="Prepare for Verification">
      <action>Define how the fix should be verified</action>
      <action>Suggest test cases to run</action>
      <action>Confirm readiness to switch workflows</action>
    </step>

  </steps>

  <exit_criteria>
    <criterion>Root cause identified</criterion>
    <criterion>Fix strategy defined</criterion>
    <criterion>User confirms issue is resolved</criterion>
  </exit_criteria>
</workflow>
```
