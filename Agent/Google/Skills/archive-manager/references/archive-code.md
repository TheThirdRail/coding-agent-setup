# Legacy Lane: archive-code

Vendor: Google Antigravity
Router: `archive-manager`
Source archive: `.\Agent\Google\deprecated-Skills\archive-code\SKILL.md`
Consolidated: 2026-04-25

The content below is the former installable skill or workflow body, preserved as an on-demand lane reference.

```markdown
---
name: archive-code
description: |
  Search and navigate code using Serena MCP when available, with ripgrep as the
  fallback. Use when you need to find definitions, references, symbols, or text
  patterns in the codebase without maintaining a custom archive index.
---

<skill name="archive-code" version="2.1.0">
  <metadata>
    <keywords>archive, code-search, grep, ripgrep, symbols, navigation</keywords>
  </metadata>

  <goal>Prefer Serena for symbol-aware code navigation, with ripgrep as the exact-text fallback.</goal>

  <core_principles>
    <principle name="Live Search Over Indexing">
      <rule>Do not generate static index files; query the current codebase state directly.</rule>
      <rule>Use ripgrep (rg) for maximum speed and gitignore respect.</rule>
    </principle>

    <principle name="Prefer Serena Before Raw Grep">
      <rule>Serena is started by each client as a native stdio MCP server; do not start or retarget a shared HTTP Serena process.</rule>
      <rule>If Serena MCP is available, use it first for symbol-aware definitions, references, and code navigation.</rule>
      <rule>Fall back to ripgrep when Serena is unavailable or when exact text matching is more important than symbol awareness.</rule>
      <rule>If Serena is unavailable or not activated for the current project, use ripgrep for the current turn and tell the user to restart the client or activate the project in Serena.</rule>
    </principle>

    <principle name="Definition vs Reference">
      <rule>Use --type logic or regex patterns to distinguish definitions from references.</rule>
      <rule>Present results with line numbers and context.</rule>
    </principle>
  </core_principles>

  <workflow>
    <step number="0" name="Choose Retrieval Mode">
      <instruction>Use Serena MCP first when you need symbol-aware navigation, references, or structural code understanding.</instruction>
      <instruction>Use ripgrep when you need exact string matching, shell-friendly batch search, or Serena is not available.</instruction>
    </step>

    <step number="1" name="Search Code">
      <command>.\Agent\Google\Skills\archive-code\scripts\search.ps1 -Pattern "class User" -Path "[PROJECT_PATH]"</command>
      <command>.\Agent\Google\Skills\archive-code\scripts\search.ps1 -Pattern "def login" -Path "[PROJECT_PATH]" -Type "definition"</command>
      <command>.\Agent\Google\Skills\archive-code\scripts\search.ps1 -Pattern "auth_service" -Path "[PROJECT_PATH]" -Context 2</command>
    </step>
  </workflow>

  <resources>
    <script file="scripts/search.ps1">PowerShell wrapper for ripgrep searching.</script>
  </resources>

  <best_practices>
    <do>Use specific patterns to narrow down results (e.g. "class Name" vs "Name")</do>
    <do>Use context flags to see surrounding code</do>
    <do>Use Serena first for definitions, references, and symbol-level navigation, then use ripgrep to confirm exact text matches when needed</do>
    <dont>Search for extremely common tokens (like "id" or "name") without context</dont>
  </best_practices>

  <related_skills>
    <skill>archive-manager</skill>
    <skill>archive-graph</skill>
  </related_skills>
</skill>
```
