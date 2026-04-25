# Coding Agent Setup Kit

This repository helps humans set up two AI coding environments on Windows:

1. OpenAI Codex
2. Google Antigravity

It includes:

- repo-owned instructions for both clients
- reusable skills and workflows
- hybrid MCP configuration
- one native Serena MCP server per client
- setup and maintenance scripts

## Start Here

If you are a human using this repo, do not hand the root README to the agent as its full setup guide.

Instead:

1. Tell the agent to read [Agent-README.md](d:/Coding/Tools/mcp-docker-stack/Agent-README.md)
2. Tell it to follow the checklist that matches what you want to install:
   - [codex-checklist.md](d:/Coding/Tools/mcp-docker-stack/codex-checklist.md)
   - [antigravity-checklist.md](d:/Coding/Tools/mcp-docker-stack/antigravity-checklist.md)
3. If you use both clients, tell it to use both checklists

The agent/operator guide has the full setup detail. The checklist files are the step-by-step execution runbooks.

## What The Agent Should Do

Ask the agent to:

- use [Agent-README.md](d:/Coding/Tools/mcp-docker-stack/Agent-README.md) as the detailed repo guide
- use [codex-checklist.md](d:/Coding/Tools/mcp-docker-stack/codex-checklist.md) for Codex setup
- use [antigravity-checklist.md](d:/Coding/Tools/mcp-docker-stack/antigravity-checklist.md) for Antigravity setup
- back up your current settings before replacing anything

## Current Setup Model

The current stack includes:

- repo-owned Codex and Antigravity instructions
- install/remove wrapper scripts
- hybrid Docker MCP support
- separate native-only Dynamic MCP runtime registries for Codex and Antigravity
- native Serena stdio setup for Codex and Antigravity
- local SearXNG support

## Human Notes

- You should have Docker Desktop installed and running.
- You should have `uv` available because the native Serena setup uses `uvx`.
- The repo root `.env` should exist before setup scripts run.
- Serena is started by each client through its native MCP config; no shared Serena HTTP process is required.

## Useful Files

- Human/operator handoff target: [Agent-README.md](d:/Coding/Tools/mcp-docker-stack/Agent-README.md)
- Codex setup runbook: [codex-checklist.md](d:/Coding/Tools/mcp-docker-stack/codex-checklist.md)
- Antigravity setup runbook: [antigravity-checklist.md](d:/Coding/Tools/mcp-docker-stack/antigravity-checklist.md)
- Secrets reference: [secrets-acquisition-guide.md](d:/Coding/Tools/mcp-docker-stack/secrets-acquisition-guide.md)

## License

MIT
