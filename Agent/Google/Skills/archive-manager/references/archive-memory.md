# Legacy Lane: archive-memory

Vendor: Google Antigravity
Router: `archive-manager`
Source archive: `.\Agent\Google\deprecated-Skills\archive-memory\SKILL.md`
Consolidated: 2026-04-25

The content below is the former installable skill or workflow body, preserved as an on-demand lane reference.

```markdown
---
name: archive-memory
description: |
  Persist structured project context, preferring the Memory MCP server for
  day-to-day recall and falling back to the local SQLite archive for explicit
  project-scoped storage. Use when recording decisions, patterns, and durable
  notes that should survive across sessions and remain queryable.
---

<skill name="archive-memory" version="2.0.0">
  <metadata>
    <keywords>archive, memory, sqlite, context, decisions, persistence</keywords>
  </metadata>

  <goal>Maintain durable project memory with Memory MCP as the default path and the local SQLite archive as the deterministic fallback.</goal>

  <core_principles>
    <principle name="Python as Canonical Implementation">
      <rule>Python scripts are the source of truth for archive-memory behavior.</rule>
      <rule>PowerShell scripts are wrappers that delegate to Python scripts.</rule>
    </principle>

    <principle name="Safe Persistence">
      <rule>Use parameterized SQL paths only; avoid raw SQL interpolation in wrappers.</rule>
      <rule>Store memory at [PROJECT_PATH]/Agent-Context/Archives/memory.db.</rule>
    </principle>

    <principle name="Structured Retrieval">
      <rule>Support targeted reads by category/key plus broad keyword search.</rule>
    </principle>

    <principle name="Prefer Memory MCP When Available">
      <rule>Use the Memory MCP server first for routine remember and recall operations when it is available.</rule>
      <rule>Fall back to the local archive-memory scripts when you need deterministic category/key behavior, explicit project-local files, or MCP is unavailable.</rule>
    </principle>
  </core_principles>

  <workflow>
    <step number="0" name="Choose Memory Mode">
      <instruction>Use the Memory MCP server first for normal conversational memory and recall.</instruction>
      <instruction>Use the local SQLite scripts when you need strict category and key control or explicit project-local archive files.</instruction>
    </step>

    <step number="1" name="Write Memory Entry">
      <command>python Agent\Google\Skills\archive-memory\scripts\write.py --category "decisions" --key "auth-strategy" --value "JWT with refresh tokens" --project-path "[PROJECT_PATH]"</command>
      <note>Valid categories: decisions, patterns, files, context, custom.</note>
    </step>

    <step number="2" name="Read Memory">
      <command>python Agent\Google\Skills\archive-memory\scripts\read.py --category "decisions" --key "auth-strategy" --project-path "[PROJECT_PATH]"</command>
      <command>python Agent\Google\Skills\archive-memory\scripts\read.py --search "auth" --project-path "[PROJECT_PATH]"</command>
    </step>

    <step number="3" name="Delete Memory Entry">
      <command>python Agent\Google\Skills\archive-memory\scripts\delete.py --category "decisions" --key "auth-strategy" --project-path "[PROJECT_PATH]"</command>
    </step>

    <step number="4" name="Use Wrapper Commands When Needed">
      <command>.\Agent\Google\Skills\archive-memory\scripts\write.ps1 -Category decisions -Key "auth-strategy" -Value "JWT with refresh tokens" -ProjectPath "[PROJECT_PATH]"</command>
      <instruction>Wrappers delegate to Python for consistent behavior and safety.</instruction>
    </step>
  </workflow>

  <resources>
    <script file="scripts/write.py">Canonical write/upsert operation.</script>
    <script file="scripts/read.py">Canonical read/search operation.</script>
    <script file="scripts/delete.py">Canonical delete operation.</script>
    <script file="scripts/write.ps1">PowerShell wrapper for write.py.</script>
    <script file="scripts/read.ps1">PowerShell wrapper for read.py.</script>
    <script file="scripts/delete.ps1">PowerShell wrapper for delete.py.</script>
  </resources>

  <best_practices>
    <do>Store concise keys and meaningful values with stable category usage</do>
    <do>Use Memory MCP for everyday recall, then use the local archive scripts when you need deterministic project-scoped persistence</do>
    <do>Use project-path explicitly when operating outside project root</do>
    <do>Capture decisions with rationale, not only conclusions</do>
    <dont>Store credentials or sensitive secrets in memory archives</dont>
    <dont>Use wrappers to execute raw SQL directly</dont>
  </best_practices>

  <related_skills>
    <skill>archive-manager</skill>
    <skill>research-capability</skill>
    <skill>documentation-generator</skill>
  </related_skills>
</skill>
```
