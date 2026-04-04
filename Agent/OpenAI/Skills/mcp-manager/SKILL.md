---
name: mcp-manager
description: |
  Orchestrate MCP servers: load, unload, and optimize context usage.
  For container troubleshooting (logs, health), use docker-ops instead.
  Use when you need to discover, enable, optimize, or disable MCP server usage for a task.
---
# Skill: mcp-manager
Attributes: name="mcp-manager", version="2.0.0"

## Metadata (`metadata`)

- `keywords`: mcp, docker, context, lazy-load, optimization

## Spec Contract (`spec_contract`)

- `id`: mcp-manager

- `name`: mcp-manager

- `version`: 2.0.0

- `last_updated`: 2026-02-09

- `purpose`: Maintain optimal Antigravity context by managing MCP servers with lazy-loading.

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

- `goal`: Maintain optimal Antigravity context by managing MCP servers with lazy-loading.

## Core Principles (`core_principles`)

### Principle (`principle`)
Attributes: name="Pure Lazy-Load Default"

- `rule`: Default state: Zero enabled servers

- `rule`: Load on demand: Use mcp-find to discover, mcp-add to load

- `rule`: Clean up: Use mcp-remove when task is complete

### Principle (`principle`)
Attributes: name="Tool Budget"

- `threshold` (name="Target", count="20-30"): Comfortable working range

- `threshold` (name="Recommended Max", count="50"): Antigravity recommendation

- `threshold` (name="Hard Limit", count="100"): Antigravity maximum

### Principle (`principle`)
Attributes: name="Code-Mode First"

- `rule`: For multi-tool tasks, create ONE composite tool using code-mode

- `rule`: Result: ~90% context savings (~750 tokens saved)

## Workflow (`workflow`)

### Step (`step`)
Attributes: number="1", name="Assess Need"

- `instruction`: Determine if capability is needed

### Step (`step`)
Attributes: number="2", name="Find Server"

- `action`: mcp-find(query: "github")

### Step (`step`)
Attributes: number="3", name="Check Budget"

- `instruction`: Current tools + new server tools &lt; 50?

### Step (`step`)
Attributes: number="4", name="Load Temporarily"

- `action`: mcp-add(name: "github", activate: false)

### Step (`step`)
Attributes: number="5", name="Perform Work"

- `instruction`: Use mcp-exec for single calls, code-mode for multiple

### Step (`step`)
Attributes: number="6", name="Cleanup"

- `action`: mcp-remove(name: "github")

- `decision_tree`:
```text
Need capability?
    ↓
Can Antigravity do it natively?
    YES → Use built-in, don't load server
    NO  ↓
Is server currently loaded?
    YES → Use it directly
    NO  ↓
Check tool budget (current + new &lt; 50?)
    NO  → Remove unused servers first
    YES → Safe to add
    ↓
Multiple operations needed?
    YES → Use code-mode to combine
    NO  → Use mcp-exec directly
    ↓
Task complete? → mcp-remove server
```

## Server Categories (`server_categories`)

### Category (`category`)
Attributes: name="Always Consider First"

- `server` (name="memory", tools="9", purpose="Knowledge graph storage")

- `server` (name="sequential-thinking", tools="1", purpose="Reasoning framework")

### Category (`category`)
Attributes: name="Load On-Demand"

- `server` (name="github", tools="26", purpose="GitHub API")

- `server` (name="brave-search", tools="2", purpose="Web search")

- `server` (name="playwright", tools="22", purpose="Browser automation")

### Category (`category`)
Attributes: name="Specialized (Use Rarely)"

- `server` (name="lsmcp, pylance, rust-analyzer", purpose="Language servers")

- `server` (name="cloudflare, supabase, neon", purpose="Cloud services")

- `code_mode_pattern`:
```text
Instead of:
  mcp-add github + mcp-add memory
  Call github.search_repos
  Call memory.create_entities (5 times)
  mcp-remove both

Do this:
  mcp-add github + memory
  Use code-mode to create ONE custom tool
  Call that ONE tool
  mcp-remove both

Context savings: ~750 tokens per operation
```

## Best Practices (`best_practices`)

- `do`: Always check tool count before adding servers

- `do`: Use mcp-find to discover capabilities

- `do`: Prefer code-mode for multi-step operations

- `do`: Unload servers immediately after task completion

- `do`: Use Antigravity's built-in features when available

- `dont`: Leave servers loaded "just in case"

- `dont`: Add servers without checking budget

- `dont`: Use multiple separate tool calls when code-mode can combine

- `dont`: Load language servers unless actively coding in that language

## Troubleshooting (`troubleshooting`)

- `issue` (problem="Too many tools error"): Reset: docker mcp server reset

- `issue` (problem="Server won't load"): Check secrets: docker mcp secret ls

- `issue` (problem="Context still bloated"): Verify 0 permanently enabled servers

## Related Skills (`related_skills`)

- `skill`: docker-ops

- `skill`: mcp-builder
