# Secrets Acquisition Guide

This guide matches the current `example.env` file and the current hybrid MCP setup.

That means:

- direct always-on MCP servers are installed straight into Codex and Antigravity
- Docker is used for the lazy-load supplemental MCP stack
- only the secrets that are actually part of the current stack are listed here

## Start Here

The end user should do these steps first:

1. Copy `example.env` to `.env`
2. Open `.env`
3. Fill in only the values they actually need
4. Leave unused values blank
5. Never commit `.env`

Create `.env` with:

```powershell
Copy-Item .\example.env .\.env
```

## Required for the Current Stack

### `SEARXNG_URL`

What it is:

- the URL the `searxng` MCP server should use to reach your local SearXNG instance

What to use:

- for the current Docker Desktop setup on Windows, the default value is:

```text
SEARXNG_URL=http://host.docker.internal:8080
```

When it is required:

- required for the current stack

How to get it:

- you do not sign up for anything
- this is your own self-hosted local SearXNG service
- the value comes from your local Docker setup, not an outside vendor

## Optional MCP Secrets

Only fill these in if you plan to use the matching MCP server.

### `GITHUB_PERSONAL_ACCESS_TOKEN`

Used by:

- `github-official`
- any other GitHub-backed MCP server that can reuse the same token

Where to create it:

- <https://github.com/settings/personal-access-tokens/new>

What type:

- Personal Access Token

Recommended access:

- `repo`
- `workflow`
- `read:org`
- `read:user`

Notes:

- use the least privilege you actually need
- this is optional unless you want GitHub MCP capabilities

### `FIRECRAWL_API_KEY`

Used by:

- `firecrawl`

Where to create it:

- <https://www.firecrawl.dev/>

What type:

- API key

Notes:

- optional
- this service is not required for the base stack
- keep this blank unless you plan to use Firecrawl

### `CONTEXT7_API_KEY`

Used by:

- direct authenticated Context7 access if you decide to wire it in that way

Where to learn more:

- Context7 upstream docs or account setup flow

Notes:

- optional
- currently treated as direct-client-only in this repo
- this is not presently synced by `MCP-Servers/scripts/set-mcp-secrets.ps1`

## What Is No Longer Part of the Current Stack

If you see old references to these in older notes, they are not part of the current `example.env`:

- `BRAVE_API_KEY`
- `TAVILY_API_KEY`
- `QDRANT_URL`
- `QDRANT_API_KEY`
- `MEM0_API_KEY`
- `SENTRY_DSN`
- `OPENAI_API_KEY`
- `ANTHROPIC_API_KEY`
- `GEMINI_API_KEY`
- older database or infrastructure secrets that are no longer in the active plan

Those may still exist in archived research, but they are not part of the current end-user setup checklist.

## After Filling in `.env`

Once `.env` is ready, the agent should load Docker-managed secrets with:

```powershell
.\MCP-Servers\scripts\setup_lazy_load.ps1
.\MCP-Servers\scripts\set-mcp-secrets.ps1
```

Important:

- `setup_lazy_load.ps1` refreshes the seeded per-user registry used by `MCP_DOCKER`
- this script only loads the values it is designed to sync
- direct-client-only values may still live only in `.env` or in client config

## Safety Notes

- never commit `.env`
- never paste real secrets into repo docs
- leave optional entries blank when unused
- if a value is blank, the sync script skips it
