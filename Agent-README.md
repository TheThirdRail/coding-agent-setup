# AI Agent Setup Kit

This repository is a Windows-first setup kit for two local AI clients:

1. OpenAI Codex
2. Google Antigravity

It gives you:

- vendor-specific global instructions
- reusable skills
- Antigravity workflows
- hybrid MCP configuration
- Docker lazy-load support for supplemental MCP servers
- a shared Serena MCP server in `streamable-http` mode
- local archive tools for code, docs, graph, git, and memory

This file is the detailed operator guide for agents and power users. If you are a human end user, start with [README.md](d:/Coding/Tools/mcp-docker-stack/README.md).

## What Gets Installed

### Codex

The Codex wrapper installs:

- `~/.codex/AGENTS.md`
- `~/.codex/skills/*`
- `~/.codex/config.toml`

Optional extra Codex artifacts can still be installed separately:

- `~/.codex/rules/default.rules`
- `~/.codex/automations/*.automation.md`

### Antigravity

The Antigravity wrapper installs:

- `~/.gemini/GEMINI.md`
- `~/.gemini/antigravity/skills/*`
- `~/.gemini/antigravity/global_workflows/*.md`
- `~/.gemini/antigravity/mcp_config.json`

## Important Behavior

- The remove scripts back up by default.
- They move existing files or folders to timestamped `.bak-*` paths.
- Use `-Purge` only if you want hard deletion instead of backup.
- The Codex skills cleanup preserves `~/.codex/skills/.system`.
- Codex and Antigravity now share one Serena server at `http://127.0.0.1:9121/mcp`.

## Prerequisites

Install these first:

1. Git
2. Docker Desktop
3. PowerShell
4. `uv`
5. OpenAI Codex and/or Google Antigravity

## One-Time Repo Preparation

Open PowerShell at the repo root and prepare `.env`:

```powershell
Copy-Item example.env .env
```

Then open `.env` and fill in what you actually use.

Start with:

- `SEARXNG_URL`
- `GITHUB_PERSONAL_ACCESS_TOKEN` if you plan to use GitHub MCP tools
- `FIRECRAWL_API_KEY` only if you plan to use Firecrawl
- `CONTEXT7_API_KEY` only if you decide to wire authenticated direct Context7 access later

## Shared MCP Prerequisites

Both Codex and Antigravity use the same local adapter image, the same local SearXNG container, and the same shared Serena HTTP server.

Run these once from the repo root:

```powershell
powershell -ExecutionPolicy Bypass -c "irm https://astral.sh/uv/install.ps1 | iex"
docker build -t mcp-local-adapters:latest -f .\MCP-Servers\local\adapters\Dockerfile .
docker compose -f .\MCP-Servers\local\searxng\docker-compose.yml up -d
.\MCP-Servers\scripts\setup_lazy_load.ps1
.\MCP-Servers\scripts\set-mcp-secrets.ps1
powershell -ExecutionPolicy Bypass -File .\MCP-Servers\scripts\start-serena-http.ps1
```

What this prepares:

- `uv` for direct `fetch` usage and the shared Serena launcher
- local adapter image for repo-owned MCP adapters
- self-hosted SearXNG for the `searxng` MCP server
- seeded per-user lazy-load registries for `MCP_DOCKER`
- Docker secrets for supplemental lazy-load servers
- one shared local Serena MCP endpoint at `http://127.0.0.1:9121/mcp`

## Codex Setup

### Recommended Reset and Reinstall Flow

Run these from the repo root:

```powershell
.\Agent\OpenAI\Scripts\remove-global-agents.ps1
.\Agent\OpenAI\Scripts\remove-global-skills.ps1
.\Agent\OpenAI\Scripts\remove-global-mcp-config.ps1
.\Agent\OpenAI\Scripts\install-codex-from-repo.ps1
```

What this does:

1. Backs up and removes the current global `~/.codex/AGENTS.md`
2. Backs up and removes installed Codex skills while preserving `.system`
3. Backs up and removes the current `~/.codex/config.toml`
4. Reinstalls the repo-owned Codex AGENTS, skills, and MCP config

### Dry Run First

If you want to preview before changing anything:

```powershell
.\Agent\OpenAI\Scripts\remove-global-agents.ps1 -DryRun
.\Agent\OpenAI\Scripts\remove-global-skills.ps1 -DryRun
.\Agent\OpenAI\Scripts\remove-global-mcp-config.ps1 -DryRun
.\Agent\OpenAI\Scripts\install-codex-from-repo.ps1 -DryRun
```

### Optional Codex Extras

If you also want the OpenAI rules and automations installed:

```powershell
.\Agent\OpenAI\Scripts\install-rules.ps1
```

That additional script installs:

- `~/.codex/rules/default.rules`
- `~/.codex/automations/*.automation.md`

### Restart and Verify

After install:

1. Restart Codex
2. Verify these exist:

```powershell
Test-Path "$HOME\.codex\AGENTS.md"
Test-Path "$HOME\.codex\config.toml"
Get-ChildItem "$HOME\.codex\skills" -Directory | Select-Object -ExpandProperty Name
```

## Antigravity Setup

### Recommended Reset and Reinstall Flow

Run these from the repo root:

```powershell
.\Agent\Google\Scripts\remove-global-gemini.ps1
.\Agent\Google\Scripts\remove-global-skills.ps1
.\Agent\Google\Scripts\remove-global-workflows.ps1
.\Agent\Google\Scripts\remove-global-mcp-config.ps1
.\Agent\Google\Scripts\install-antigravity-from-repo.ps1
```

What this does:

1. Backs up and removes the current global `~/.gemini/GEMINI.md`
2. Backs up and removes installed Antigravity skills
3. Backs up and removes installed global workflows
4. Backs up and removes the current `~/.gemini/antigravity/mcp_config.json`
5. Reinstalls the repo-owned GEMINI file, skills, workflows, and MCP config

### Dry Run First

If you want to preview before changing anything:

```powershell
.\Agent\Google\Scripts\remove-global-gemini.ps1 -DryRun
.\Agent\Google\Scripts\remove-global-skills.ps1 -DryRun
.\Agent\Google\Scripts\remove-global-workflows.ps1 -DryRun
.\Agent\Google\Scripts\remove-global-mcp-config.ps1 -DryRun
.\Agent\Google\Scripts\install-antigravity-from-repo.ps1 -DryRun
```

### Restart and Verify

After install:

1. Restart Antigravity
2. Verify these exist:

```powershell
Test-Path "$HOME\.gemini\GEMINI.md"
Test-Path "$HOME\.gemini\antigravity\mcp_config.json"
Get-ChildItem "$HOME\.gemini\antigravity\skills" -Directory | Select-Object -ExpandProperty Name
Get-ChildItem "$HOME\.gemini\antigravity\global_workflows" -File | Select-Object -ExpandProperty Name
```

## Recommended Order If You Use Both

From the repo root:

1. Prepare `.env`
2. Install `uv`
3. Build the local adapter image
4. Start SearXNG
5. Run `.\MCP-Servers\scripts\setup_lazy_load.ps1`
6. Run `.\MCP-Servers\scripts\set-mcp-secrets.ps1`
7. Start `powershell -ExecutionPolicy Bypass -File .\MCP-Servers\scripts\start-serena-http.ps1`
8. Reset and reinstall Codex
9. Reset and reinstall Antigravity
10. Restart both clients

## Root Checklists

If you want a short runbook for an agent to follow, use:

- [codex-checklist.md](d:/Coding/Tools/mcp-docker-stack/codex-checklist.md)
- [antigravity-checklist.md](d:/Coding/Tools/mcp-docker-stack/antigravity-checklist.md)

## Useful Paths

- OpenAI policy source: `Agent/OpenAI/AGENTS.md`
- Google policy source: `Agent/Google/Rules/GEMINI.md`
- Codex MCP template: `Agent/OpenAI/Codex/mcp/config.toml`
- Antigravity MCP template: `Agent/Google/Antigravity/mcp/mcp_config.json`
- Codex supplemental registry seed: `MCP-Servers/mcp-docker-stack/registry.supplementals.yaml`
- Antigravity supplemental registry seed: `MCP-Servers/mcp-docker-stack/registry.supplementals.antigravity.yaml`
- Runtime catalog: `MCP-Servers/mcp-docker-stack/docker-mcp-catalog.runtime.yaml`
- Codex runtime registry: `~/.docker/mcp/registry.hybrid-supplementals.yaml`
- Antigravity runtime registry: `~/.docker/mcp/registry.hybrid-supplementals-antigravity.yaml`
- Shared Serena launcher: `MCP-Servers/scripts/start-serena-http.ps1`

## Maintenance

Useful maintenance commands:

```powershell
.\Agent\OpenAI\Scripts\deprecation-checker.ps1 -Target codex
.\Agent\Google\Scripts\deprecation-checker.ps1
.\MCP-Servers\scripts\normalize-mcp-config-encoding.ps1 -Vendor all
```

## Common Problems

### PowerShell says a script cannot run

Use:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### MCP commands fail

Check these in order:

1. Docker Desktop is running
2. `.env` exists at the repo root
3. `uv` is installed
4. `docker build -t mcp-local-adapters:latest -f .\MCP-Servers\local\adapters\Dockerfile .` completed successfully
5. `docker compose -f .\MCP-Servers\local\searxng\docker-compose.yml up -d` completed successfully
6. `.\MCP-Servers\scripts\setup_lazy_load.ps1` completed successfully
7. `.\MCP-Servers\scripts\set-mcp-secrets.ps1` completed successfully
8. `powershell -ExecutionPolicy Bypass -File .\MCP-Servers\scripts\start-serena-http.ps1` is still running if you expect Serena to be available

### Config changes do not appear in the client

Restart the client after installation.

### Docker MCP keeps starting and stopping short-lived containers

That is usually normal. To diagnose background activity:

```powershell
.\MCP-Servers\scripts\diagnose-mcp-background.ps1 -ObserveSeconds 30
```

### Config encoding issues on Windows

If you see BOM or UTF-16 related problems:

```powershell
.\MCP-Servers\scripts\normalize-mcp-config-encoding.ps1 -Vendor all
```

## Archive and Local Memory

This repo includes local archive tooling under `Agent-Context/Archives/` for:

- document memory
- graph snapshots
- code search
- git history lookup
- durable project memory

Do not store credentials or secrets in archive data.

## License

MIT
