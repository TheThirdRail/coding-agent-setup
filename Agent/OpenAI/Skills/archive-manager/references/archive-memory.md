# Legacy Lane: archive-memory

Vendor: OpenAI Codex
Router: `archive-manager`
Source archive: `.\Agent\OpenAI\deprecated-Skills\archive-memory\SKILL.md`
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
# Skill: archive-memory
Attributes: name="archive-memory", version="2.0.0"

## Metadata (`metadata`)

- `keywords`: archive, memory, sqlite, context, decisions, persistence

## Spec Contract (`spec_contract`)

- `id`: archive-memory

- `name`: archive-memory

- `version`: 2.0.0

- `last_updated`: 2026-02-09

- `purpose`: Maintain durable project memory with Memory MCP as the default path and the local SQLite archive as the deterministic fallback.

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

- `goal`: Maintain durable project memory with safe, parameterized read/write/delete operations.

## Core Principles (`core_principles`)

### Principle (`principle`)
Attributes: name="Python as Canonical Implementation"

- `rule`: Python scripts are the source of truth for archive-memory behavior.

- `rule`: PowerShell scripts are wrappers that delegate to Python scripts.

### Principle (`principle`)
Attributes: name="Safe Persistence"

- `rule`: Use parameterized SQL paths only; avoid raw SQL interpolation in wrappers.

- `rule`: Store memory at [PROJECT_PATH]/Agent-Context/Archives/memory.db.

### Principle (`principle`)
Attributes: name="Structured Retrieval"

- `rule`: Support targeted reads by category/key plus broad keyword search.

### Principle (`principle`)
Attributes: name="Prefer Memory MCP When Available"

- `rule`: Use the Memory MCP server first for routine remember and recall operations when it is available.

- `rule`: Fall back to the local archive-memory scripts when you need deterministic category/key behavior, explicit project-local files, or MCP is unavailable.

## Workflow (`workflow`)

### Step (`step`)
Attributes: number="0", name="Choose Memory Mode"

- `instruction`: Use the Memory MCP server first for normal conversational memory and recall.

- `instruction`: Use the local SQLite scripts when you need strict category and key control or explicit project-local archive files.

### Step (`step`)
Attributes: number="1", name="Write Memory Entry"

- `command`: python Agent\OpenAI\Skills\archive-memory\scripts\write.py --category "decisions" --key "auth-strategy" --value "JWT with refresh tokens" --project-path "[PROJECT_PATH]"

- `note`: Valid categories: decisions, patterns, files, context, custom.

### Step (`step`)
Attributes: number="2", name="Read Memory"

- `command`: python Agent\OpenAI\Skills\archive-memory\scripts\read.py --category "decisions" --key "auth-strategy" --project-path "[PROJECT_PATH]"

- `command`: python Agent\OpenAI\Skills\archive-memory\scripts\read.py --search "auth" --project-path "[PROJECT_PATH]"

### Step (`step`)
Attributes: number="3", name="Delete Memory Entry"

- `command`: python Agent\OpenAI\Skills\archive-memory\scripts\delete.py --category "decisions" --key "auth-strategy" --project-path "[PROJECT_PATH]"

### Step (`step`)
Attributes: number="4", name="Use Wrapper Commands When Needed"

- `command`: .\Agent\OpenAI\Skills\archive-memory\scripts\write.ps1 -Category decisions -Key "auth-strategy" -Value "JWT with refresh tokens" -ProjectPath "[PROJECT_PATH]"

- `instruction`: Wrappers delegate to Python for consistent behavior and safety.

## Resources (`resources`)

- `script` (file="scripts/write.py"): Canonical write/upsert operation.

- `script` (file="scripts/read.py"): Canonical read/search operation.

- `script` (file="scripts/delete.py"): Canonical delete operation.

- `script` (file="scripts/write.ps1"): PowerShell wrapper for write.py.

- `script` (file="scripts/read.ps1"): PowerShell wrapper for read.py.

- `script` (file="scripts/delete.ps1"): PowerShell wrapper for delete.py.

## Best Practices (`best_practices`)

- `do`: Store concise keys and meaningful values with stable category usage

- `do`: Use Memory MCP for everyday recall, then use the local archive scripts when you need deterministic project-scoped persistence

- `do`: Use project-path explicitly when operating outside project root

- `do`: Capture decisions with rationale, not only conclusions

- `dont`: Store credentials or sensitive secrets in memory archives

- `dont`: Use wrappers to execute raw SQL directly

## Related Skills (`related_skills`)

- `skill`: archive-manager

- `skill`: research

- `skill`: documentation-generator
```
