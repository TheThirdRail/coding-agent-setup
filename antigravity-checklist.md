# Antigravity Installation Checklist

Use this checklist from the repo root in PowerShell.

## Goal

Install the repo-owned Antigravity setup by:

1. backing up and removing the current global Antigravity setup
2. preparing local MCP prerequisites
3. reinstalling GEMINI, skills, workflows, and MCP config from this repo

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
.\Agent\Google\Scripts\remove-global-gemini.ps1 -DryRun
.\Agent\Google\Scripts\remove-global-skills.ps1 -DryRun
.\Agent\Google\Scripts\remove-global-workflows.ps1 -DryRun
.\Agent\Google\Scripts\remove-global-mcp-config.ps1 -DryRun
.\Agent\Google\Scripts\install-antigravity-from-repo.ps1 -DryRun
```

### 5. Back up and remove the current global Antigravity setup

```powershell
.\Agent\Google\Scripts\remove-global-gemini.ps1
.\Agent\Google\Scripts\remove-global-skills.ps1
.\Agent\Google\Scripts\remove-global-workflows.ps1
.\Agent\Google\Scripts\remove-global-mcp-config.ps1
```

Notes:

- these scripts back up the existing files and folders by default
- use `-Purge` only if you want hard deletion instead of backup

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

### 9. Install the repo-owned Antigravity setup

```powershell
.\Agent\Google\Scripts\install-antigravity-from-repo.ps1
```

This installs:

- `~/.gemini/GEMINI.md`
- `~/.gemini/antigravity/skills/*`
- `~/.gemini/antigravity/global_workflows/*.md`
- `~/.gemini/antigravity/mcp_config.json`

### 10. Restart Antigravity

Close and reopen Antigravity after the install finishes.

### 11. Verify the install

```powershell
Test-Path "$HOME\.gemini\GEMINI.md"
Test-Path "$HOME\.gemini\antigravity\mcp_config.json"
Get-ChildItem "$HOME\.gemini\antigravity\skills" -Directory | Select-Object -ExpandProperty Name
Get-ChildItem "$HOME\.gemini\antigravity\global_workflows" -File | Select-Object -ExpandProperty Name
```

## Success Criteria

The setup is complete when:

- `~/.gemini/GEMINI.md` exists
- `~/.gemini/antigravity/mcp_config.json` exists
- the expected skills and workflows are present
- Antigravity restarts without config errors

## If Something Fails

Run these checks:

```powershell
.\MCP-Servers\scripts\normalize-mcp-config-encoding.ps1 -Vendor google
.\MCP-Servers\scripts\diagnose-mcp-background.ps1 -ObserveSeconds 30
```
