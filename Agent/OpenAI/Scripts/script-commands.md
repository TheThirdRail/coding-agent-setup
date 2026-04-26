# Script Commands (OpenAI Codex)

Quick reference for `Agent/OpenAI/Scripts`.

## Core Runtime Model

- Lean canonical instructions source: `Agent/OpenAI/AGENTS.md`
- Repo runtime instructions mirror: `AGENTS.md`
- Consolidated command rules source: `Agent/OpenAI/default.rules`
- Automation templates source: `Agent/OpenAI/Automations/*.automation.md`
- Installed Codex targets:
  - `~/.codex/AGENTS.md`
  - `~/.codex/rules/default.rules`
  - `~/.codex/skills/<skill>/`
  - `~/.codex/automations/*.automation.md`
- Optional compatibility mirror: `~/.agents/*` via `-Target agents|both` or `-MirrorAgents`

## Validate

```powershell
.\validate-codex-openai.ps1
```

## Full Install (Recommended)

```powershell
.\install-rules.ps1
```

Options:

```powershell
.\install-rules.ps1 -Target codex|agents|both -Scope global|project|both -DryRun
.\install-rules.ps1 -MirrorAgents -DryRun
.\install-rules.ps1 -SkipSkills -SkipAutomations -DryRun
```

## Individual Installers

```powershell
.\install-agents.ps1 -Target codex|agents|both -Scope global|project|both -DryRun
.\install-codex-rules.ps1 -Target codex|agents|both -DryRun
.\install-skills.ps1 -Target codex|agents|both -DryRun
.\install-automations.ps1 -Target codex|agents|both -DryRun
```

## Deprecation Cleanup

```powershell
.\deprecation-checker.ps1 -DryRun
```

## MCP Setup

```powershell
docker build -t mcp-local-adapters:latest -f ..\..\..\MCP-Servers\local\adapters\Dockerfile ..\..\..
docker compose -f ..\..\..\MCP-Servers\local\searxng\docker-compose.yml up -d
..\..\..\MCP-Servers\scripts\setup_lazy_load.ps1 -Vendor openai
..\..\..\MCP-Servers\scripts\install-mcp-servers.ps1 -Vendor openai
..\..\..\MCP-Servers\scripts\set-mcp-secrets.ps1
```

This installs the hybrid MCP layout:
- native Serena plus `MCP_DOCKER` in `~\.codex\config.toml`
- a native-only Dynamic MCP registry at `~\.docker\mcp\registry.hybrid-supplementals.yaml`
- supplemental servers discoverable through `MCP_DOCKER` with `mcp-find`/`mcp-add`
- loaded supplemental servers must be removed with `mcp-remove` when the task is complete

## MCP Runtime Cleanup (After Use)

Terminate stale MCP runtime processes after MCP-heavy sessions:

```powershell
..\..\..\MCP-Servers\scripts\cleanup-stale-mcp-runtime.ps1
```

Optional verification:

```powershell
..\..\..\MCP-Servers\scripts\check-agent-host-processes.ps1 -StaleMinutes 30 -IncludeCommandLine
```

## Deprecated Scripts

Deprecated scripts are archived in:

- `Agent/OpenAI/Scripts/deprecated-Scripts/build-agents.ps1`
