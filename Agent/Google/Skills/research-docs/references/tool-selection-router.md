# Legacy Lane: tool-selection-router

Vendor: Google Antigravity
Router: `research-docs`
Source archive: `.\Agent\Google\deprecated-Skills\tool-selection-router\SKILL.md`
Consolidated: 2026-04-25

The content below is the former installable skill or workflow body, preserved as an on-demand lane reference.

```markdown
---
name: tool-selection-router
description: |
  Select the best search, fetch, or scraping tool by request intent with explicit fallback behavior.
  Use when choosing tooling for fact checks, QA, documentation reads, exploration, or complex scraping.
---

<skill name="tool-selection-router" version="1.0.0">
  <metadata>
    <keywords>tooling, routing, search, fetch, scraping, research</keywords>
  </metadata>

  <goal>Choose the highest-confidence tool path with deterministic fallback and escalation rules.</goal>

  <core_principles>
    <principle name="Intent First">
      <rule>Classify request intent before selecting tools.</rule>
      <rule>Use one primary intent: Fact, Answer, Read, Explore, or Scrape.</rule>
    </principle>
    <principle name="Fallback Discipline">
      <rule>If preferred tool fails, log the deviation reason and move to the defined fallback or escalation.</rule>
    </principle>
    <principle name="Source Quality">
      <rule>Prefer official and primary sources for technical claims.</rule>
    </principle>
  </core_principles>

  <decision_matrix>
    <use_case type="sanity_check">
      <trigger>Simple fact, weather, date, or quick confirmation.</trigger>
      <preferred_tool>search_web</preferred_tool>
      <fallback>searxng</fallback>
    </use_case>
    <use_case type="question_answering">
      <trigger>How-to, what is, fix this error.</trigger>
      <preferred_tool>tavily</preferred_tool>
      <fallback>exa</fallback>
    </use_case>
    <use_case type="documentation_ingestion">
      <trigger>Read this URL, learn docs, scrape a page.</trigger>
      <preferred_tool>fetch</preferred_tool>
      <escalation>firecrawl</escalation>
    </use_case>
    <use_case type="broad_discovery">
      <trigger>Find alternatives, similar projects, or papers.</trigger>
      <preferred_tool>exa</preferred_tool>
      <fallback>searxng</fallback>
    </use_case>
    <use_case type="complex_scraping">
      <trigger>Auth-walled targets, social media, maps, complex UIs.</trigger>
      <preferred_tool>apify</preferred_tool>
      <fallback>browser_subagent</fallback>
    </use_case>
  </decision_matrix>

  <workflow>
    <step number="1" name="Classify Request">
      <instruction>Parse the request and choose one primary intent category.</instruction>
    </step>
    <step number="2" name="Apply Decision Matrix">
      <instruction>Select preferred tool from the matrix for the intent category.</instruction>
    </step>
    <step number="3" name="Execute or Escalate">
      <instruction>Execute preferred tool; on failure, apply fallback and log why.</instruction>
    </step>
    <step number="4" name="Return Decision Trace">
      <instruction>Return chosen tool, confidence, and any fallback/escalation taken.</instruction>
    </step>
  </workflow>

  <output_format>
    <field>intent</field>
    <field>preferred_tool</field>
    <field>fallback_or_escalation</field>
    <field>deviation_reason</field>
    <field>confidence</field>
  </output_format>

  <best_practices>
    <do>Default to deterministic lower-cost tools when confidence is high.</do>
    <do>Escalate only when coverage, freshness, or reliability is insufficient.</do>
    <dont>Select tooling before intent classification.</dont>
  </best_practices>

  <related_skills>
    <skill>research-capability</skill>
    <skill>mcp-manager</skill>
  </related_skills>

  <related_workflows>
    <workflow>/research</workflow>
    <workflow>/analyze</workflow>
  </related_workflows>
</skill>
```
