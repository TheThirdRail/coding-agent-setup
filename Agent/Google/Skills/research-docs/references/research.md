# Legacy Lane: research

Vendor: Google Antigravity
Router: `research-docs`
Source archive: `.\Agent\Google\deprecated-Workflows\research.md`
Consolidated: 2026-04-25

The content below is the former installable skill or workflow body, preserved as an on-demand lane reference.

```markdown
---
description: Research Mode - Deep research with maximum thinking using all search tools
---

<workflow name="research" thinking="MAX">
  <important>Use MAXIMUM thinking/reasoning depth. Prioritize the most up-to-date sources.</important>

  <when_to_use>
    <trigger>Researching best practices for a tech stack</trigger>
    <trigger>Finding current solutions to technical problems</trigger>
    <trigger>Comparing frameworks, libraries, or approaches</trigger>
    <trigger>Gathering information before /architect mode</trigger>
  </when_to_use>

  <recommended_mcp>
    <server>sequential-thinking</server>
    <server>brave-search</server>
    <server>tavily</server>
    <server>firecrawl</server>
    <reason>Deep reasoning and comprehensive web search/scraping</reason>
  </recommended_mcp>

  <constraints>
    <constraint>DO NOT write implementation code</constraint>
    <constraint>DO NOT edit source files</constraint>
    <constraint>Focus ONLY on information gathering and synthesis</constraint>
  </constraints>

  <output>
    <location>Agent-Context/Research/</location>
    <format>[topic]-research.md</format>
    <note>The Agent-Context/ folder should be in .gitignore</note>
  </output>

  <steps>
    <step number="1" name="Clarify the Research Topic">
      <parse>What specific topic to research?</parse>
      <parse>What decisions need to be made?</parse>
      <parse>Any constraints (free only, specific language, etc.)?</parse>
    </step>

    <step number="1.5" name="Verify Product Lifecycle & Status">
      <action>Search for "[Topic] release history [Current Year]" and "[Topic] status"</action>
      <action>Identify the "Newest Official Source" and "Newest Credible Third-Party Source"</action>
      <rule>Compare dates: If Official is significantly older than Credible, investigate discrepancies</rule>
      <rule>Judgement: If Official says "deprecated" but recent Credible sources show activity, verify if it's a relaunch</rule>
      <rule>Scour multiple sources to confirm status before proceeding to deep research</rule>
    </step>

    <step number="2" name="Use ALL Search Tools">
      <skill ref="research-capability">Use for documentation interpretation and synthesis</skill>
      <skill ref="tool-selection-router">Use to select the best search/fetch/scrape tool for each research task</skill>
      <tools category="Web Search">
        <tool name="searxng">Meta-search across multiple engines</tool>
        <tool name="brave-search">Web search with privacy</tool>
        <tool name="tavily">AI-optimized search</tool>
        <tool name="github">Code examples, popular repos</tool>
        <tool name="fetch">Read specific URLs for deep content</tool>
      </tools>
    </step>

    <step number="2b" name="Use Context MCPs for Code Research">
      <tools category="Code Context">
        <tool name="context7">Get up-to-date library documentation</tool>
        <tool name="gitmcp">Convert GitHub repos to markdown</tool>
        <tool name="augments">Access 90+ framework documentation sources</tool>
      </tools>
    </step>

    <step number="3" name="Prioritize Recent Sources">
      <rule>Prefer sources from 2024-2025</rule>
      <rule>Note the date of each source</rule>
      <rule>Flag any outdated information</rule>
      <rule>Look for "latest" or "current" versions</rule>
    </step>

    <step number="4" name="Research Areas to Cover">
      <category name="Tech Stack Research">Current best practices, popular libraries, performance, security, community support</category>
      <category name="Problem-Solving Research">Common solutions, edge cases, real-world examples</category>
    </step>

    <step number="5" name="Document Findings">
      <output_template><![CDATA[

# [Topic] Research

**Date:** [Today's date]
**Purpose:** [Why this research was needed]

## Executive Summary

[2-3 sentence summary]

## Key Findings

### Best Practices (2024-2025)

- [Finding 1] — Source: [URL]

### Recommended Approach

[Your synthesis and recommendation]

### Alternatives Considered

| Option | Pros | Cons |
|--------|------|------|
| [Option 1] | [Pros] | [Cons] |

### Sources

1. [Title](URL) — [Date] — [Brief note]
      ]]></output_template>
    </step>

    <step number="6" name="Synthesize and Recommend">
      <rule>Don't just list findings — synthesize them</rule>
      <rule>Provide a clear recommendation</rule>
      <rule>Explain WHY you recommend it</rule>
      <rule>Note any trade-offs</rule>
    </step>

    <step number="7" name="Context Governance (Research Event)">
      <instruction>Apply `/context-governance` with `event_type=research` to validate output location, format, and archive policy actions.</instruction>
      <instruction>Resolve sensitive-data violations before publishing research artifacts.</instruction>
    </step>

  </steps>

  <exit_criteria>
    <criterion>Research file created in Agent-Context/Research/ folder</criterion>
    <criterion>Clear synthesis and recommendation provided</criterion>
    <criterion>Sources documented with dates</criterion>
    <criterion>User understands the findings</criterion>
  </exit_criteria>
</workflow>
```
