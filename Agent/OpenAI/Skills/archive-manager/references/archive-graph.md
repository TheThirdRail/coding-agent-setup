# Legacy Lane: archive-graph

Vendor: OpenAI Codex
Router: `archive-manager`
Source archive: `.\Agent\OpenAI\deprecated-Skills\archive-graph\SKILL.md`
Consolidated: 2026-04-25

The content below is the former installable skill or workflow body, preserved as an on-demand lane reference.

```markdown
---
name: archive-graph
description: |
  Build and query a structural code graph, preferring CodeGraph MCP for quick
  snapshots and falling back to the local Tree-sitter and SQLite archive tools
  for repeatable local graph analysis. Use when you need file, function, or
  class structure context and lightweight relationship exploration.
---
# Skill: archive-graph
Attributes: name="archive-graph", version="2.0.0"

## Metadata (`metadata`)

- `keywords`: archive, graph, tree-sitter, sqlite, structure, impact-analysis

## Spec Contract (`spec_contract`)

- `id`: archive-graph

- `name`: archive-graph

- `version`: 2.0.0

- `last_updated`: 2026-02-09

- `purpose`: Create and query structural code relationships, using CodeGraph first and the local graph archive as the fallback.

### Inputs (`inputs`)

- `input`: User request and relevant project context.

### Outputs (`outputs`)

- `output`: Completed guidance, actions, or artifacts produced by this skill.

### Triggers (`triggers`)

- `trigger`: Use when the frontmatter description conditions are met.

- `procedure`: Follow the ordered steps in the workflow section.

### Edge Cases (`edge_cases`)

- `edge_case`: If required context is missing, gather or request it before continuing.

### Safety Constraints (`safety_constraints`)

- `constraint`: Avoid destructive operations without explicit user intent.

### Examples (`examples`)

- `example`: Activate this skill when the request matches its trigger conditions.

- `goal`: Create and query a project-local structural graph of files and code symbols.

## Core Principles (`core_principles`)

### Principle (`principle`)
Attributes: name="Build Before Query"

- `rule`: Run graph build after significant code changes or before deep structural analysis.

- `rule`: Treat graph output as a snapshot of repository state at build time.

### Principle (`principle`)
Attributes: name="Use Supported Query Modes"

- `rule`: Supported query modes are --files, --structure, and --query.

- `rule`: Do not assume unsupported traversal flags unless implemented in scripts/query.py.

### Principle (`principle`)
Attributes: name="Project-Scoped Persistence"

- `rule`: Store graph database at [PROJECT_PATH]/Agent-Context/Archives/graph.db.

### Principle (`principle`)
Attributes: name="Prefer CodeGraph MCP For Fast Snapshots"

- `rule`: CodeGraph is a Docker lazy-load server. Add it through `MCP_DOCKER` only when needed, then remove it with `mcp-remove` after use.

- `rule`: Use CodeGraph MCP first when you need a quick structural snapshot or impact-analysis overview.

- `rule`: Fall back to the local build and query scripts when you need a repeatable project-local graph database and supported query modes.

- `rule`: If CodeGraph is not loaded or cannot see the intended project root, use the local archive-graph scripts for the current turn.

## Workflow (`workflow`)

### Step (`step`)
Attributes: number="0", name="Choose Graph Mode"

- `instruction`: Use CodeGraph MCP first for quick structure and relationship snapshots.

- `instruction`: Use the local archive-graph scripts when you need the persistent SQLite graph database or supported local query flows.

### Step (`step`)
Attributes: number="1", name="Install Prerequisites"

- `command`: pip install tree-sitter tree-sitter-languages

### Step (`step`)
Attributes: number="2", name="Build Graph Snapshot"

- `command`: python Agent\OpenAI\Skills\archive-graph\scripts\build.py --path "[PROJECT_PATH]"

- `output`: [PROJECT_PATH]\Agent-Context\Archives\graph.db

### Step (`step`)
Attributes: number="3", name="Query Available Files"

- `command`: python Agent\OpenAI\Skills\archive-graph\scripts\query.py --files --project-path "[PROJECT_PATH]"

### Step (`step`)
Attributes: number="4", name="Inspect File Structure"

- `command`: python Agent\OpenAI\Skills\archive-graph\scripts\query.py --structure "auth" --project-path "[PROJECT_PATH]"

### Step (`step`)
Attributes: number="5", name="Search Symbol Names"

- `command`: python Agent\OpenAI\Skills\archive-graph\scripts\query.py --query "login" --project-path "[PROJECT_PATH]"

## Resources (`resources`)

- `script` (file="scripts/build.py"): Parse codebase and materialize graph nodes/edges.

- `script` (file="scripts/query.py"): Run supported graph queries (files, structure, symbol search).

## Best Practices (`best_practices`)

- `do`: Rebuild graph after refactors to avoid stale symbol locations

- `do`: Use symbol search first, then narrow with structure queries

- `do`: Pair graph results with archive-git when validating change history

- `do`: Use CodeGraph MCP for fast orientation, then fall back to the local graph database when you need stable repeatable queries

- `dont`: Assume unsupported query flags or Cypher-style syntax

- `dont`: Treat graph output as runtime call graph truth

## Related Skills (`related_skills`)

- `skill`: archive-manager

- `skill`: archive-code

- `skill`: archive-git
```
