---
name: archive-code
description: |
  Search and navigate code using Serena MCP when available, with ripgrep as the
  fallback. Use when you need to find definitions, references, symbols, or text
  patterns in the codebase without maintaining a custom archive index.
---
# Skill: archive-code
Attributes: name="archive-code", version="2.1.0"

## Metadata (`metadata`)

- `keywords`: archive, code-search, grep, ripgrep, symbols, navigation

- `goal`: Prefer Serena for symbol-aware code navigation, with ripgrep as the exact-text fallback.

## Core Principles (`core_principles`)

### Principle (`principle`)
Attributes: name="Live Search Over Indexing"

- `rule`: Do not generate static index files; query the current codebase state directly.

- `rule`: Use ripgrep (rg) for maximum speed and gitignore respect.

### Principle (`principle`)
Attributes: name="Prefer Serena Before Raw Grep"

- `rule`: If Serena MCP is available, use it first for symbol-aware definitions, references, and code navigation.

- `rule`: Fall back to ripgrep when Serena is unavailable or when exact text matching is more important than symbol awareness.

### Principle (`principle`)
Attributes: name="Definition vs Reference"

- `rule`: Use --type logic or regex patterns to distinguish definitions from references.

- `rule`: Present results with line numbers and context.

## Workflow (`workflow`)

### Step (`step`)
Attributes: number="0", name="Choose Retrieval Mode"

- `instruction`: Use Serena MCP first when you need symbol-aware navigation, references, or structural code understanding.

- `instruction`: Use ripgrep when you need exact string matching, shell-friendly batch search, or Serena is not available.

### Step (`step`)
Attributes: number="1", name="Search Code"

- `command`: .\Agent\OpenAI\Skills\archive-code\scripts\search.ps1 -Pattern "class User" -Path "[PROJECT_PATH]"

- `command`: .\Agent\OpenAI\Skills\archive-code\scripts\search.ps1 -Pattern "def login" -Path "[PROJECT_PATH]" -Type "definition"

- `command`: .\Agent\OpenAI\Skills\archive-code\scripts\search.ps1 -Pattern "auth_service" -Path "[PROJECT_PATH]" -Context 2

## Resources (`resources`)

- `script` (file="scripts/search.ps1"): PowerShell wrapper for ripgrep searching.

## Best Practices (`best_practices`)

- `do`: Use specific patterns to narrow down results (e.g. "class Name" vs "Name")

- `do`: Use context flags to see surrounding code

- `do`: Use Serena first for definitions, references, and symbol-level navigation, then use ripgrep to confirm exact text matches when needed

- `dont`: Search for extremely common tokens (like "id" or "name") without context

## Related Skills (`related_skills`)

- `skill`: archive-manager

- `skill`: archive-graph

- `skill`: archive-git
