# Antigravity Installation Checklist

Use this file as a step-by-step runbook for an AI agent helping an end user install the Antigravity setup from this repository.

This checklist is written in the order the work should happen:

1. the end user installs and starts prerequisites
2. the end user prepares `.env`
3. the agent backs up the end user's current Antigravity settings into `old-settings`
4. the agent runs the cleanup and install scripts from this repo
5. the agent verifies the install
6. the agent offers to restore useful old settings selectively

## Goal

Install the repo-owned Antigravity stack so that:

- Antigravity uses this repo's `GEMINI.md`
- Antigravity uses this repo's MCP config
- Antigravity uses this repo's skills
- Antigravity uses this repo's workflows
- Docker is running for the lazy-load MCP gateway and local services
- the shared Serena server is available at `http://127.0.0.1:9121/mcp`
- the end user's old Antigravity settings are preserved under `old-settings`

## Step 1: Instruct the End User to Install Docker Desktop and `uv`

The agent should ask the end user to install Docker Desktop first if it is not already installed.

Official download link:

- <https://www.docker.com/products/docker-desktop/>

Tell the end user:

- download Docker Desktop
- install it
- launch Docker Desktop
- wait until Docker reports that it is running

Optional verification command:

```powershell
docker version
docker info
```

The agent should not continue until Docker Desktop is installed and running.

The agent should also ensure `uv` is installed because the current setup uses `uvx` for direct MCP tools and the shared Serena launcher.

Install command:

```powershell
powershell -ExecutionPolicy Bypass -c "irm https://astral.sh/uv/install.ps1 | iex"
```

## Step 2: Instruct the End User to Create `.env`

The agent should tell the end user to create `.env` from `example.env`.

Command:

```powershell
Copy-Item .\example.env .\.env
```

If `.env` already exists, the agent should tell the end user to review it instead of overwriting it blindly.

## Step 3: Instruct the End User to Fill in Secrets

The agent should direct the end user to:

- open [secrets-acquisition-guide.md](d:/Coding/Tools/mcp-docker-stack/secrets-acquisition-guide.md)
- collect the needed values
- paste them into `.env`

At minimum, the current stack expects:

- `SEARXNG_URL`

Optional values depend on whether those MCP servers will be used:

- `GITHUB_PERSONAL_ACCESS_TOKEN`
- `FIRECRAWL_API_KEY`
- `CONTEXT7_API_KEY`

The agent should remind the end user:

- do not commit `.env`
- leave unused secrets blank

## Step 4: Confirm Repo Root

The agent should confirm it is running from the repo root.

Command:

```powershell
Get-Location
```

Expected path:

```text
d:\Coding\Tools\mcp-docker-stack
```

## Step 5: Back Up the End User's Current Antigravity Settings into `old-settings`

Before removing anything, the agent should copy the end user's existing Antigravity settings into this repo under `old-settings`.

The agent should create these folders if they do not exist:

```text
old-settings/antigravity/instructions
old-settings/antigravity/mcp
old-settings/antigravity/skills
old-settings/antigravity/workflows
```

The agent should then copy these live Antigravity paths if they exist:

- `C:\Users\jerem\.gemini\GEMINI.md` -> `old-settings/antigravity/instructions/`
- `C:\Users\jerem\.gemini\antigravity\mcp_config.json` -> `old-settings/antigravity/mcp/`
- `C:\Users\jerem\.gemini\antigravity\skills\` -> `old-settings/antigravity/skills/`
- `C:\Users\jerem\.gemini\antigravity\global_workflows\` -> `old-settings/antigravity/workflows/`

Recommended commands:

```powershell
New-Item -ItemType Directory -Force -Path .\old-settings\antigravity\instructions, .\old-settings\antigravity\mcp, .\old-settings\antigravity\skills, .\old-settings\antigravity\workflows | Out-Null

if (Test-Path "$HOME\.gemini\GEMINI.md") { Copy-Item "$HOME\.gemini\GEMINI.md" .\old-settings\antigravity\instructions\ -Force }
if (Test-Path "$HOME\.gemini\antigravity\mcp_config.json") { Copy-Item "$HOME\.gemini\antigravity\mcp_config.json" .\old-settings\antigravity\mcp\ -Force }
if (Test-Path "$HOME\.gemini\antigravity\skills") { Copy-Item "$HOME\.gemini\antigravity\skills" .\old-settings\antigravity\skills\ -Recurse -Force }
if (Test-Path "$HOME\.gemini\antigravity\global_workflows") { Copy-Item "$HOME\.gemini\antigravity\global_workflows" .\old-settings\antigravity\workflows\ -Recurse -Force }
```

The goal here is simple: preserve the old state in a human-readable place inside the repo before the repo-owned setup replaces it.

## Step 6: Preview the Cleanup and Install Scripts

The agent should dry-run the main scripts first.

```powershell
.\Agent\Google\Scripts\remove-global-gemini.ps1 -DryRun
.\Agent\Google\Scripts\remove-global-skills.ps1 -DryRun
.\Agent\Google\Scripts\remove-global-workflows.ps1 -DryRun
.\Agent\Google\Scripts\remove-global-mcp-config.ps1 -DryRun
.\Agent\Google\Scripts\install-antigravity-from-repo.ps1 -DryRun
```

If anything looks wrong, stop and explain the issue before continuing.

## Step 7: Remove the Current Global Antigravity Setup

The agent should run the cleanup scripts.

```powershell
.\Agent\Google\Scripts\remove-global-gemini.ps1
.\Agent\Google\Scripts\remove-global-skills.ps1
.\Agent\Google\Scripts\remove-global-workflows.ps1
.\Agent\Google\Scripts\remove-global-mcp-config.ps1
```

Notes:

- these scripts already back up live settings by default
- the explicit `old-settings` copy from Step 5 is still important because it keeps a repo-local snapshot

## Step 8: Build the Local MCP Adapter Image

The agent should build the local adapter image used by the Docker-side MCP setup.

```powershell
docker build -t mcp-local-adapters:latest -f .\MCP-Servers\local\adapters\Dockerfile .
```

## Step 9: Start Local Docker Services

The agent should start the local SearXNG stack.

```powershell
docker compose -f .\MCP-Servers\local\searxng\docker-compose.yml up -d
```

Optional verification:

```powershell
docker compose -f .\MCP-Servers\local\searxng\docker-compose.yml ps
Invoke-WebRequest -Uri http://127.0.0.1:8080 -UseBasicParsing
```

## Step 10: Initialize the Empty Lazy-Load Registry

The agent should refresh the per-user Docker MCP registry used by `MCP_DOCKER`.

```powershell
.\MCP-Servers\scripts\setup_lazy_load.ps1
```

This should create or refresh:

- `C:\Users\jerem\.docker\mcp\registry.hybrid-supplementals-antigravity.yaml`

The expected startup behavior after this step is the Dynamic MCP management surface plus the seeded supplemental server set.

## Step 11: Sync Docker Secrets from `.env`

The agent should load the MCP-related secrets from `.env`.

```powershell
.\MCP-Servers\scripts\set-mcp-secrets.ps1
```

## Step 12: Start the Shared Serena HTTP Server

The agent should start the shared Serena server before asking the end user to use Antigravity.

Command:

```powershell
powershell -ExecutionPolicy Bypass -File .\MCP-Servers\scripts\start-serena-http.ps1
```

Expected endpoint:

- `http://127.0.0.1:9121/mcp`

This process should stay running while Codex and Antigravity are using Serena.

## Step 13: Install the Repo-Owned Antigravity Setup

The agent should install the Antigravity files from this repo.

```powershell
.\Agent\Google\Scripts\install-antigravity-from-repo.ps1
```

This should install:

- `~/.gemini/GEMINI.md`
- `~/.gemini/antigravity/mcp_config.json`
- `~/.gemini/antigravity/skills/*`
- `~/.gemini/antigravity/global_workflows/*.md`

## Step 14: Restart Antigravity

The agent should tell the end user to fully close and reopen Antigravity.

## Step 15: Verify the Install

The agent should run:

```powershell
Test-Path "$HOME\.gemini\GEMINI.md"
Test-Path "$HOME\.gemini\antigravity\mcp_config.json"
Get-ChildItem "$HOME\.gemini\antigravity\skills" -Directory | Select-Object -ExpandProperty Name
Get-ChildItem "$HOME\.gemini\antigravity\global_workflows" -File | Select-Object -ExpandProperty Name
```

Success means:

- `GEMINI.md` exists
- `mcp_config.json` exists
- skills are installed
- workflows are installed
- `mcp_config.json` no longer contains direct `playwright` or `shrimp_task_manager` entries
- `MCP_DOCKER` points at `C:\Users\jerem\.docker\mcp\registry.hybrid-supplementals-antigravity.yaml`
- the `serena` entry points at `http://127.0.0.1:9121/mcp`

## Step 16: Ask Whether to Restore Any Old Settings

Once the new setup is working, the agent should ask the end user whether they want to bring back any old:

- skills
- workflows
- MCP servers
- instruction files

The agent should not restore everything blindly.

## Step 17: Review Old MCP Servers Before Re-Adding Them

If the end user wants old MCP servers back, the agent should inspect the saved old config in:

- `old-settings/antigravity/mcp/`

Then the agent should classify each old MCP server:

1. `Clearly redundant`
   - already replaced by the current base stack
   - already handled well by Antigravity itself
   - example: filesystem-style servers that overlap with built-in shell/file access

2. `Useful but supplemental`
   - not needed as always-on
   - should be added to the Docker lazy-load setup instead

3. `Still worth keeping`
   - genuinely non-redundant and still desired by the end user

Decision rule:

- if redundant, recommend leaving it out
- if useful but not core, add it to Docker lazy-load
- if the end user still insists on keeping a redundant one, add it to Docker lazy-load rather than the direct always-on base

## Step 18: Review Old Skills and Workflows Before Re-Adding Them

If the end user wants old skills or workflows back:

- inspect the contents under `old-settings/antigravity/skills/` and `old-settings/antigravity/workflows/`
- identify duplicates or near-duplicates of the repo-owned skills and workflows
- only restore custom items that are still useful and not already covered

The agent should prefer:

- keeping the repo-owned canonical versions
- restoring only genuinely custom additions

## Troubleshooting

If something fails, the agent should run:

```powershell
.\MCP-Servers\scripts\setup_lazy_load.ps1
.\MCP-Servers\scripts\normalize-mcp-config-encoding.ps1 -Vendor google
.\MCP-Servers\scripts\diagnose-mcp-background.ps1 -ObserveSeconds 30
```

If Serena is unavailable, the agent should also check:

```powershell
powershell -ExecutionPolicy Bypass -File .\MCP-Servers\scripts\start-serena-http.ps1
try { Invoke-WebRequest -Uri http://127.0.0.1:9121/mcp -UseBasicParsing -TimeoutSec 5 } catch { $_.Exception.Message }
```

If Docker-related services fail, the agent should also check:

```powershell
docker compose -f .\MCP-Servers\local\searxng\docker-compose.yml ps
docker compose -f .\MCP-Servers\local\searxng\docker-compose.yml logs --tail 200
```
