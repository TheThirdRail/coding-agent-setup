---
name: serena-trigger
description: |
  Confirm that Serena is available through the client-native stdio MCP setup.
  Use when Serena-backed navigation is expected but unavailable, or when a
  client needs project activation guidance.
---
# Skill: serena-trigger
Attributes: name="serena-trigger", version="1.1.0"

## Metadata (`metadata`)

- `keywords`: serena, mcp, stdio, project-activation, archive-code

- `goal`: Keep Serena aligned with the documented per-client native MCP setup.

## Core Principles (`core_principles`)

### Principle (`principle`)
Attributes: name="Native Serena"

- `rule`: Do not start or retarget a shared Serena HTTP server for Codex or Antigravity.

- `rule`: Codex starts Serena with `--project-from-cwd --context codex`.

- `rule`: Antigravity starts Serena with `--context antigravity`; activate the project from Serena if the client does not pass it automatically.

- `rule`: If Serena is unavailable after config changes, restart the client so it starts a fresh stdio MCP process.

## Workflow (`workflow`)

### Step (`step`)
Attributes: number="0", name="Check Native Serena"

- `command`: uvx -p 3.13 --from git+https://github.com/oraios/serena serena start-mcp-server --help

- `instruction`: Verify the client config has a `serena` entry using `uvx`.

- `instruction`: Use Serena project activation from the MCP tools when Antigravity needs a project selected.

## Best Practices (`best_practices`)

- `do`: Keep Serena as the only non-Docker native MCP server in client configs.

- `do`: Restart the client after changing Serena MCP config.

- `dont`: Use the deprecated shared HTTP launcher for normal Codex or Antigravity work.

## Related Skills (`related_skills`)

- `skill`: archive-code

- `skill`: archive-manager
