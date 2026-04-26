# Script Commands (Google)

Quick reference for `Agent/Google/Scripts`.

## Prerequisites

1. Open PowerShell in `Agent/Google/Scripts`.
2. Ensure project root `.env` is configured.
3. Ensure Docker Desktop is running for MCP scripts.

## Install and Sync

```powershell
.\deprecation-checker.ps1
.\install-rules.ps1
.\install-skills.ps1
.\install-workflows.ps1
```

Targets:
- Global instructions: `Agent\Google\GEMINI.md` -> `~\.gemini\GEMINI.md`
- Specialized rule docs: `Agent\Google\Rules\*.md`
- Skills: `~\.gemini\antigravity\skills`
- Workflows: `~\.gemini\antigravity\global_workflows`

The specialized rule docs are repository artifacts. The current installer keeps the installed always-on layer lean and copies only `Agent\Google\GEMINI.md` to the global Gemini context file.

Workspace-local Antigravity installs are intentionally disabled because Antigravity reads local agent context locations as active instructions. Use the global installer above instead of creating a project backup under local agent folders.

## MCP Setup

```powershell
docker build -t mcp-local-adapters:latest -f ..\..\..\MCP-Servers\local\adapters\Dockerfile ..\..\..
docker compose -f ..\..\..\MCP-Servers\local\searxng\docker-compose.yml up -d
..\..\..\MCP-Servers\scripts\setup_lazy_load.ps1 -Vendor google
..\..\..\MCP-Servers\scripts\install-mcp-servers.ps1 -Vendor google
..\..\..\MCP-Servers\scripts\set-mcp-secrets.ps1
```

Targets:
- MCP config: `~\.gemini\antigravity\mcp_config.json`
- Runtime catalog: `MCP-Servers\mcp-docker-stack\docker-mcp-catalog.runtime.yaml`
- Native-only Dynamic MCP runtime registry: `~\.docker\mcp\registry.hybrid-supplementals-antigravity.yaml`

At startup Antigravity should have native Serena plus `MCP_DOCKER`; `MCP_DOCKER` should expose only Docker gateway management tools. Use `mcp-find`/`mcp-add` for temporary supplemental servers, then `mcp-remove` when the task is complete.

## MCP Runtime Cleanup (After Use)

Terminate stale MCP runtime processes after MCP-heavy sessions:

```powershell
..\..\..\MCP-Servers\scripts\cleanup-stale-mcp-runtime.ps1
```

Optional verification:

```powershell
..\..\..\MCP-Servers\scripts\check-agent-host-processes.ps1 -StaleMinutes 30 -IncludeCommandLine
```

## Dry Run

```powershell
.\deprecation-checker.ps1 -DryRun
.\install-rules.ps1 -DryRun
.\install-skills.ps1 -DryRun
.\install-workflows.ps1 -DryRun
```
