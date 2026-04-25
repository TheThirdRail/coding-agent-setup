---
name: archive-graph
description: |
  Build and query a structural code graph, preferring CodeGraph MCP for quick
  snapshots and falling back to the local Tree-sitter and SQLite archive tools
  for repeatable local graph analysis. Use when you need file, function, or
  class structure context and lightweight relationship exploration.
---

<skill name="archive-graph" version="2.0.0">
  <metadata>
    <keywords>archive, graph, tree-sitter, sqlite, structure, impact-analysis</keywords>
  </metadata>

  <goal>Create and query structural code relationships, using CodeGraph first and the local graph archive as the fallback.</goal>

  <core_principles>
    <principle name="Build Before Query">
      <rule>Run graph build after significant code changes or before deep structural analysis.</rule>
      <rule>Treat graph output as a snapshot of repository state at build time.</rule>
    </principle>

    <principle name="Use Supported Query Modes">
      <rule>Supported query modes are --files, --structure, and --query.</rule>
      <rule>Do not assume unsupported traversal flags unless implemented in scripts/query.py.</rule>
    </principle>

    <principle name="Project-Scoped Persistence">
      <rule>Store graph database at [PROJECT_PATH]/Agent-Context/Archives/graph.db.</rule>
    </principle>

    <principle name="Prefer CodeGraph MCP For Fast Snapshots">
      <rule>CodeGraph is a Docker lazy-load server. Add it through MCP_DOCKER only when needed, then remove it with mcp-remove after use.</rule>
      <rule>Use CodeGraph MCP first when you need a quick structural snapshot or impact-analysis overview.</rule>
      <rule>Fall back to the local build and query scripts when you need a repeatable project-local graph database and supported query modes.</rule>
      <rule>If CodeGraph is not loaded or cannot see the intended project root, use the local archive-graph scripts for the current turn.</rule>
    </principle>
  </core_principles>

  <workflow>
    <step number="0" name="Choose Graph Mode">
      <instruction>Use CodeGraph MCP first for quick structure and relationship snapshots.</instruction>
      <instruction>Use the local archive-graph scripts when you need the persistent SQLite graph database or supported local query flows.</instruction>
    </step>

    <step number="1" name="Install Prerequisites">
      <command>pip install tree-sitter tree-sitter-languages</command>
    </step>

    <step number="2" name="Build Graph Snapshot">
      <command>python Agent\Google\Skills\archive-graph\scripts\build.py --path "[PROJECT_PATH]"</command>
      <output>[PROJECT_PATH]\Agent-Context\Archives\graph.db</output>
    </step>

    <step number="3" name="Query Available Files">
      <command>python Agent\Google\Skills\archive-graph\scripts\query.py --files --project-path "[PROJECT_PATH]"</command>
    </step>

    <step number="4" name="Inspect File Structure">
      <command>python Agent\Google\Skills\archive-graph\scripts\query.py --structure "auth" --project-path "[PROJECT_PATH]"</command>
    </step>

    <step number="5" name="Search Symbol Names">
      <command>python Agent\Google\Skills\archive-graph\scripts\query.py --query "login" --project-path "[PROJECT_PATH]"</command>
    </step>
  </workflow>

  <resources>
    <script file="scripts/build.py">Parse codebase and materialize graph nodes/edges.</script>
    <script file="scripts/query.py">Run supported graph queries (files, structure, symbol search).</script>
  </resources>

  <best_practices>
    <do>Rebuild graph after refactors to avoid stale symbol locations</do>
    <do>Use symbol search first, then narrow with structure queries</do>
    <do>Pair graph results with archive-git when validating change history</do>
    <do>Use CodeGraph MCP for fast orientation, then fall back to the local graph database when you need stable repeatable queries</do>
    <dont>Assume unsupported query flags or Cypher-style syntax</dont>
    <dont>Treat graph output as runtime call graph truth</dont>
  </best_practices>

  <related_skills>
    <skill>archive-manager</skill>
    <skill>archive-code</skill>
    <skill>archive-git</skill>
  </related_skills>
</skill>
