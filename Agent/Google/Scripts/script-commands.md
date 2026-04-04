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
- Rules: `~\.gemini\GEMINI.md`
- Skills: `~\.gemini\antigravity\skills`
- Workflows: `~\.gemini\antigravity\global_workflows`

Workspace-local install targets (via `move-local-*` scripts):
- Rules: `.agent\rules`
- Skills: `.agent\skills`
- Workflows: `.agent\workflows`

## MCP Setup

```powershell
docker build -t mcp-local-adapters:latest -f ..\..\..\MCP-Servers\local\adapters\Dockerfile ..\..\..
docker compose -f ..\..\..\MCP-Servers\local\searxng\docker-compose.yml up -d
..\..\..\MCP-Servers\scripts\install-mcp-servers.ps1 -Vendor google
..\..\..\MCP-Servers\scripts\set-mcp-secrets.ps1
```

Targets:
- MCP config: `~\.gemini\antigravity\mcp_config.json`
- Runtime catalog: `MCP-Servers\mcp-docker-stack\docker-mcp-catalog.runtime.yaml`
- Registry: `MCP-Servers\mcp-docker-stack\registry.supplementals.yaml`

## MCP Runtime Cleanup (After Use)

Terminate stale MCP runtime processes after MCP-heavy sessions:

```powershell
Get-Process -Name "docker-mcp" -ErrorAction SilentlyContinue | Stop-Process -Force
```

Optional verification:

```powershell
Get-Process -Name "docker-mcp" -ErrorAction SilentlyContinue
```

## Dry Run

```powershell
.\deprecation-checker.ps1 -DryRun
.\install-rules.ps1 -DryRun
.\install-skills.ps1 -DryRun
.\install-workflows.ps1 -DryRun
```
