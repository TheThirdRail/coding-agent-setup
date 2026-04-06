# MCP Server Script Commands

Quick reference for the shared MCP setup scripts in `MCP-Servers/scripts`.

## Prerequisites

1. Open PowerShell in `MCP-Servers/scripts`.
2. Ensure Docker Desktop is running.
3. Ensure project root `.env` exists for secret setup.
4. Build the local adapter image once:

```powershell
docker build -t mcp-local-adapters:latest -f ..\local\adapters\Dockerfile ..\..
```

5. Start local SearXNG once:

```powershell
docker compose -f ..\local\searxng\docker-compose.yml up -d
```

6. Start the shared Serena HTTP server in a separate PowerShell window when you want Antigravity and Codex to share one Serena instance:

```powershell
powershell -ExecutionPolicy Bypass -File .\start-serena-http.ps1
```

## 1) Install Hybrid Client Configs

This installs the repo-owned hybrid config templates:
- direct always-on MCP servers in each client config
- one `MCP_DOCKER` entry pointing at the per-user lazy-load registry
- one shared local `serena` MCP URL at `http://127.0.0.1:9121/mcp`

```powershell
.\setup_lazy_load.ps1
.\install-mcp-servers.ps1 -Vendor openai
.\install-mcp-servers.ps1 -Vendor google
.\install-mcp-servers.ps1 -Vendor all
```

Targets:
- `openai` -> `~/.codex/config.toml`
- `google` -> `~/.gemini/antigravity/mcp_config.json`

Dry run:

```powershell
.\install-mcp-servers.ps1 -Vendor all -DryRun
```

## 2) Set Docker MCP Secrets from `.env`

```powershell
.\set-mcp-secrets.ps1
.\set-mcp-secrets.ps1 -EnvFilePath "..\..\.env"
```

Important:
- this script only writes Docker-managed secrets needed by the current hybrid stack
- direct-client values such as `SEARXNG_URL` and optional `CONTEXT7_API_KEY` are not written into Docker secrets

## 3) Refresh the Seeded Hybrid Lazy-Load Registry

This refreshes the runtime registry used by `MCP_DOCKER` from the repo-owned supplemental seed list.

```powershell
.\setup_lazy_load.ps1
.\setup_lazy_load.ps1 -DryRun
```

Target:
- `~\.docker\mcp\registry.hybrid-supplementals.yaml`

## 4) Start the Shared Serena HTTP Server

This runs Serena once in `streamable-http` mode with `ide` context so both Antigravity and Codex can connect to the same MCP server instance.

```powershell
powershell -ExecutionPolicy Bypass -File .\start-serena-http.ps1
powershell -ExecutionPolicy Bypass -File .\start-serena-http.ps1 -Port 9122
powershell -ExecutionPolicy Bypass -File .\start-serena-http.ps1 -ProjectPath "D:\Coding\SomeOtherRepo"
```

Default endpoint:
- `http://127.0.0.1:9121/mcp`

## 5) Manual Gateway Run (for debugging)

```powershell
docker mcp gateway run --transport stdio `
  --registry "$HOME\.docker\mcp\registry.hybrid-supplementals.yaml" `
  --additional-catalog "D:\Coding\Tools\mcp-docker-stack\MCP-Servers\mcp-docker-stack\docker-mcp-catalog.runtime.yaml"
```

At startup this should expose the Dynamic MCP management tools plus the seeded supplemental tool set.

## 6) Spot-check a Single Supplemental Server

```powershell
docker mcp tools count `
  --gateway-arg="--registry=$HOME\.docker\mcp\registry.hybrid-supplementals.yaml" `
  --gateway-arg="--additional-catalog=D:\Coding\Tools\mcp-docker-stack\MCP-Servers\mcp-docker-stack\docker-mcp-catalog.runtime.yaml" `
  --gateway-arg="--servers=playwright"
```

## 7) Deprecated Gateway-First Bootstrap

The old gateway-first bootstrap script was moved to:

- `deprecated-Scripts/setup_lazy_load.ps1`

That script is intentionally deprecated because it assumed the Docker gateway owned both the base servers and the supplemental servers. The current stack is hybrid instead.

## 8) Diagnose Random Background Container Activity

This watches short-lived container lifecycle events and checks your client MCP config wiring.

```powershell
.\diagnose-mcp-background.ps1 -ObserveSeconds 30
.\diagnose-mcp-background.ps1 -ObserveSeconds 45 -ReportPath "..\reports\mcp-background.json"
```

Tip:
- Add `-SkipEventWatch` for a fast config/process-only check.

## 9) Normalize Client Config Encoding (Fix BOM/UTF-16 Issues)

This rewrites client config files as UTF-8 without BOM. It creates backups by default.

```powershell
.\normalize-mcp-config-encoding.ps1 -Vendor all
.\normalize-mcp-config-encoding.ps1 -Vendor google
```

Dry run:

```powershell
.\normalize-mcp-config-encoding.ps1 -Vendor all -WhatIf
```

## 10) Check for Stale Agent Host Processes

This finds duplicate long-running host processes (for example duplicate `app-server` hosts) that can keep polling MCP in the background.

```powershell
.\check-agent-host-processes.ps1
.\check-agent-host-processes.ps1 -StaleMinutes 60 -IncludeCommandLine
```

## 11) Diagnose Codex Extension + Standalone MCP Client Behavior

This captures a control baseline, current Codex config state, latest standalone/extension logs, and a short process observation window. It writes both JSON and Markdown reports to `MCP-Servers/reports`.

```powershell
.\diagnose-codex-mcp-clients.ps1
.\diagnose-codex-mcp-clients.ps1 -ObserveSeconds 40
```
