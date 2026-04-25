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

6. Serena is started by each client through its native MCP config; no shared Serena HTTP server is required.

## 1) Install Hybrid Client Configs

This installs the repo-owned hybrid config templates:
- direct always-on MCP servers in each client config
- one `MCP_DOCKER` entry pointing at the per-user native-only Dynamic MCP registry
- one native Serena stdio entry per client

```powershell
.\setup_lazy_load.ps1 -Vendor all
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

## 3) Initialize Native-Only Dynamic MCP Runtime Registries

This initializes the runtime registries used by `MCP_DOCKER` as empty session state files. Startup exposes only Docker gateway native management tools; supplemental servers remain discoverable through the repo-owned catalog and are loaded with `mcp-find`/`mcp-add`.

```powershell
.\setup_lazy_load.ps1
.\setup_lazy_load.ps1 -Vendor openai
.\setup_lazy_load.ps1 -Vendor google
.\setup_lazy_load.ps1 -DryRun
```

Targets:
- `~\.docker\mcp\registry.hybrid-supplementals.yaml`
- `~\.docker\mcp\registry.hybrid-supplementals-antigravity.yaml`

## 4) Serena Native Client Setup

Serena is configured directly in each client. Codex starts Serena with `--project-from-cwd --context codex`; Antigravity starts Serena with `--context antigravity` and may need project activation from Serena after startup.

```powershell
uvx -p 3.13 --from git+https://github.com/oraios/serena serena start-mcp-server --help
```

The old `start-serena-http.ps1` script is retained only for manual experiments with Serena HTTP transport.

## 4b) CodeGraph Is Lazy-Loaded Through Docker MCP

CodeGraph is no longer a direct MCP entry. Load it only when needed:

```powershell
docker mcp tools count `
  --gateway-arg="--additional-catalog=D:\Coding\Tools\mcp-docker-stack\MCP-Servers\mcp-docker-stack\docker-mcp-catalog.runtime.yaml" `
  --gateway-arg="--servers=codegraph"
```

In clients, use `mcp-find`/`mcp-add` to add `codegraph`, then `mcp-remove` when finished.

## 5) Manual Gateway Run (for debugging)

```powershell
docker mcp gateway run --transport stdio `
  --registry "$HOME\.docker\mcp\registry.hybrid-supplementals.yaml" `
  --additional-catalog "D:\Coding\Tools\mcp-docker-stack\MCP-Servers\mcp-docker-stack\docker-mcp-catalog.runtime.yaml"
```

At startup this should expose only the Docker gateway native Dynamic MCP management tools.

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
