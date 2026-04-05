# Coding Agent Setup Kit

This repository helps humans set up two AI coding environments on Windows:

1. OpenAI Codex
2. Google Antigravity

It includes:

- repo-owned instructions for both clients
- reusable skills and workflows
- hybrid MCP configuration
- a shared Serena MCP server
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
- an empty lazy-load registry for `MCP_DOCKER`
- a shared Serena server at `http://127.0.0.1:9121/mcp`
- local SearXNG support

## Human Notes

- You should have Docker Desktop installed and running.
- You should have `uv` available because the shared Serena startup uses it.
- The repo root `.env` should exist before setup scripts run.
- If Serena is expected to work, the shared Serena server process should be running.

## Useful Files

- Human/operator handoff target: [Agent-README.md](d:/Coding/Tools/mcp-docker-stack/Agent-README.md)
- Codex setup runbook: [codex-checklist.md](d:/Coding/Tools/mcp-docker-stack/codex-checklist.md)
- Antigravity setup runbook: [antigravity-checklist.md](d:/Coding/Tools/mcp-docker-stack/antigravity-checklist.md)
- Secrets reference: [secrets-acquisition-guide.md](d:/Coding/Tools/mcp-docker-stack/secrets-acquisition-guide.md)

## License

MIT
