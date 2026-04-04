# Codex Installation Checklist

Use this checklist from the repo root in PowerShell.

## Goal

Install the repo-owned Codex setup by:

1. backing up and removing the current global Codex setup
2. preparing local MCP prerequisites
3. reinstalling Codex AGENTS, skills, and MCP config from this repo

## Steps

### 1. Confirm you are at the repo root

```powershell
Get-Location
```

Expected: the current directory should be this repository.

### 2. Create `.env` if it does not already exist

```powershell
if (-not (Test-Path .env)) { Copy-Item example.env .env }
```

Then open `.env` and fill in the values you actually need.

### 3. Start Docker Desktop

Make sure Docker Desktop is running before continuing.

### 4. Preview the cleanup and install steps

```powershell
.\Agent\OpenAI\Scripts\remove-global-agents.ps1 -DryRun
.\Agent\OpenAI\Scripts\remove-global-skills.ps1 -DryRun
.\Agent\OpenAI\Scripts\remove-global-mcp-config.ps1 -DryRun
.\Agent\OpenAI\Scripts\install-codex-from-repo.ps1 -DryRun
```

### 5. Back up and remove the current global Codex setup

```powershell
.\Agent\OpenAI\Scripts\remove-global-agents.ps1
.\Agent\OpenAI\Scripts\remove-global-skills.ps1
.\Agent\OpenAI\Scripts\remove-global-mcp-config.ps1
```

Notes:

- these scripts back up the existing files and folders by default
- the Codex skills cleanup preserves `~/.codex/skills/.system`

### 6. Build the local MCP adapter image

```powershell
docker build -t mcp-local-adapters:latest -f .\MCP-Servers\local\adapters\Dockerfile .
```

### 7. Start the local SearXNG container

```powershell
docker compose -f .\MCP-Servers\local\searxng\docker-compose.yml up -d
```

### 8. Sync Docker secrets from `.env`

```powershell
.\MCP-Servers\scripts\set-mcp-secrets.ps1
```

### 9. Install the repo-owned Codex setup

```powershell
.\Agent\OpenAI\Scripts\install-codex-from-repo.ps1
```

This installs:

- `~/.codex/AGENTS.md`
- `~/.codex/skills/*`
- `~/.codex/config.toml`

### 10. Optional: install Codex rules and automations too

```powershell
.\Agent\OpenAI\Scripts\install-rules.ps1
```

This additionally installs:

- `~/.codex/rules/default.rules`
- `~/.codex/automations/*.automation.md`

### 11. Restart Codex

Close and reopen Codex after the install finishes.

### 12. Verify the install

```powershell
Test-Path "$HOME\.codex\AGENTS.md"
Test-Path "$HOME\.codex\config.toml"
Get-ChildItem "$HOME\.codex\skills" -Directory | Select-Object -ExpandProperty Name
```

## Success Criteria

The setup is complete when:

- `~/.codex/AGENTS.md` exists
- `~/.codex/config.toml` exists
- the expected Codex skills are present
- Codex restarts without config errors

## If Something Fails

Run these checks:

```powershell
.\MCP-Servers\scripts\normalize-mcp-config-encoding.ps1 -Vendor openai
.\MCP-Servers\scripts\diagnose-mcp-background.ps1 -ObserveSeconds 30
```
