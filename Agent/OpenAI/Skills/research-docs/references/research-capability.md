# Legacy Lane: research-capability

Vendor: OpenAI Codex
Router: `research-docs`
Source archive: `.\Agent\Google\deprecated-Skills\research-capability\SKILL.md`
Consolidated: 2026-04-25

The content below is the former installable skill or workflow body, preserved as an on-demand lane reference.

```markdown
---
name: research-capability
description: |
  Perform validated technical research using documentation, repositories, and
  recent sources. Use when implementation decisions require current APIs,
  best practices, lifecycle status, or high-confidence code examples.
---

<skill name="research-capability" version="2.1.0">
  <metadata>
    <keywords>research, search, documentation, context7, web-search, examples, best-practices</keywords>
  </metadata>

  <goal>Gather accurate, current information and code examples from multiple sources to inform implementation decisions.</goal>

  <core_principles>
    <principle name="Source Hierarchy">
      <priority order="1">Official documentation (context7, gitmcp)</priority>
      <priority order="2">Framework/library guides (augments)</priority>
      <priority order="3">GitHub repos with high stars</priority>
      <priority order="4">Recent community discussions ([Current Year]-1 to [Current Year])</priority>
      <priority order="5">Technical blog posts</priority>
    </principle>

    <principle name="Recency Matters">
      <rule>Note the date of every source</rule>
      <rule>Flag outdated information explicitly</rule>
      <rule>Prefer "latest" or "current" versions</rule>
    </principle>

    <principle name="Lifecycle Awareness">
      <rule>Always verify if the tool is still active/supported in [Current Year]</rule>
      <rule>If Official Docs are old (>1 year), scour for newer credible sources (blogs, news)</rule>
      <rule>Judgement: Valid recent info > Outdated official info for status/lifecycle</rule>
    </principle>

    <principle name="Context Types">
      <type name="Implementation Examples">Working code showing how to do something</type>
      <type name="API Documentation">Function signatures, parameters, return types</type>
      <type name="Best Practices">Recommended patterns, conventions, idioms</type>
      <type name="Anti-Patterns">What NOT to do and why</type>
      <type name="Configuration">Setup, environment, dependencies</type>
    </principle>

    <principle name="Quality Signals">
      <signal good="true">Official docs, verified examples, high GitHub stars</signal>
      <signal good="true">Recent content ([Current Year]-1 to [Current Year]), active maintenance</signal>
      <signal good="false">Outdated posts, deprecated APIs, low engagement</signal>
    </principle>
  </core_principles>



  <recommended_mcp>
    <server>context7</server>
    <server>brave-search</server>
    <server>gitmcp</server>
    <server>augments</server>
    <server>github</server>
    <reason>Library docs, web search, repo context, framework docs, code examples</reason>
  </recommended_mcp>

  <tools>
    <category name="Documentation MCPs">
      <tool name="context7">
        <purpose>Get up-to-date library/framework documentation</purpose>
        <use_when>Need API details for a specific library</use_when>
        <example>Get React hooks documentation, Express.js middleware API</example>
      </tool>
      <tool name="gitmcp">
        <purpose>Convert GitHub repos to readable markdown</purpose>
        <use_when>Need to understand a library's source code</use_when>
        <example>Read implementation of a popular utility library</example>
      </tool>
      <tool name="augments">
        <purpose>Access 90+ framework documentation sources</purpose>
        <use_when>Need comprehensive framework guides</use_when>
        <example>Next.js routing, Django models, FastAPI dependencies</example>
      </tool>
    </category>

    <category name="Code Search">
      <tool name="github">
        <purpose>Find code examples, popular repos, issue discussions</purpose>
        <use_when>Looking for real-world implementations</use_when>
        <queries>
          <query type="examples">"[pattern] language:typescript stars:>100"</query>
          <query type="usage">"import [library]" filename:*.ts</query>
          <query type="config">"[tool].config" filename:*.json</query>
        </queries>
      </tool>
      <tool name="brave-search">
        <purpose>Private, fast web search for factual lookups</purpose>
        <use_when>General web search needed</use_when>
      </tool>
    </category>

    <category name="Deep Reading">
      <tool name="fetch">
        <purpose>Read specific URLs for full content</purpose>
        <use_when>Found a relevant page, need details</use_when>
      </tool>
      <tool name="sequential-thinking">
        <purpose>Reason through complex problems step by step</purpose>
        <use_when>Need to analyze gathered information</use_when>
      </tool>
    </category>
  </tools>

  <workflow>
    <step number="1" name="Identify Research Need">
      <question>What am I trying to implement?</question>
      <question>What library/framework am I using?</question>
      <question>What specific API or pattern do I need?</question>
    </step>

    <step number="2" name="Choose Tools">
      <tool name="context7" use="Library/framework documentation"/>
      <tool name="gitmcp" use="GitHub repository as markdown"/>
      <tool name="augments" use="90+ framework doc sources"/>
      <tool name="brave-search" use="General web search"/>
      <tool name="github" use="Code examples, issue discussions"/>
      <tool name="fetch" use="Deep-read specific URLs"/>
    </step>

    <step number="3" name="Search and Verify">
      <action>Use 2-3 sources for cross-verification</action>
      <action>Check dates on all sources</action>
      <action>Prefer official docs over blog posts</action>
      <action>Look for anti-patterns to avoid</action>
    </step>

    <step number="4" name="Return Findings">
      <format>Brief summary with source links</format>
      <format>Explicit recommendation if applicable</format>
      <note>Synthesize, don't just list</note>
    </step>
  </workflow>

  <query_patterns>
    <pattern name="API Usage">
      <context7>"[library] [function] usage"</context7>
      <github>"[function](" language:[lang] stars:>50</github>
    </pattern>
    <pattern name="Status Check">
      <search>"[topic] status [Current Year]"</search>
      <search>"[topic] release notes [Current Year]"</search>
    </pattern>
    <pattern name="Best Practices">
      <search>"[topic] best practices [Current Year]"</search>
      <github>"[pattern]" language:[lang] stars:>500</github>
    </pattern>
    <pattern name="Configuration">
      <github>"[tool].config" OR "[tool]rc" filename:*.json</github>
      <search>"[tool] configuration guide"</search>
    </pattern>
    <pattern name="Error Solutions">
      <search>"[error message]" site:stackoverflow.com</search>
      <github>issues: "[error message]"</github>
    </pattern>
  </query_patterns>

  <best_practices>
    <do>Start with official documentation before blogs</do>
    <do>Verify code examples actually run</do>
    <do>Check the date on all sources</do>
    <do>Look for multiple confirming sources</do>
    <do>Note library versions in examples</do>
    <do>Prefer TypeScript examples for JS projects</do>
    <do>Synthesize rather than dump raw results</do>
    <do>Link to sources for traceability</do>
    <dont>Trust single Stack Overflow answers blindly</dont>
    <dont>Use deprecated API examples</dont>
    <dont>Copy code without understanding it</dont>
    <dont>Ignore security implications</dont>
    <dont>Spend excessive time on tangential research</dont>
  </best_practices>

  <integration_points>
    <workflow ref="/architect" step="2">Research Best Practices phase</workflow>
    <workflow ref="/analyze" step="2">Research and Gather Context phase</workflow>
    <workflow ref="/code" step="1">Load Context phase</workflow>
    <workflow ref="/research">Full research workflow for comprehensive investigation</workflow>
    <skill ref="architecture-planner">For design documentation</skill>
    <skill ref="code-reviewer">For reviewing gathered patterns</skill>
    <skill ref="api-builder">For API documentation needs</skill>
  </integration_points>

  <related_skills>
    <skill>architecture-planner</skill>
    <skill>code-reviewer</skill>
    <skill>api-builder</skill>
  </related_skills>
</skill>
```
