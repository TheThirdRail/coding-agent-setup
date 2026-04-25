# Legacy Lane: docker-ops

Vendor: OpenAI Codex
Router: `mcp-ops`
Source archive: `.\Agent\OpenAI\deprecated-Skills\docker-ops\SKILL.md`
Consolidated: 2026-04-25

The content below is the former installable skill or workflow body, preserved as an on-demand lane reference.

```markdown
---
name: docker-ops
description: |
  Troubleshoot Docker containers for MCP servers. Use when containers fail,
  need logs, or require health checks. For loading/unloading servers, use mcp-manager.
---
# Skill: docker-ops
Attributes: name="docker-ops", version="2.0.0"

## Metadata (`metadata`)

- `keywords`: docker, containers, debugging, logs, health-checks

## Spec Contract (`spec_contract`)

- `id`: docker-ops

- `name`: docker-ops

- `version`: 2.0.0

- `last_updated`: 2026-02-09

- `purpose`: Systematic troubleshooting for Docker containers hosting MCP servers.

### Inputs (`inputs`)

- `input`: User request and relevant project context.

### Outputs (`outputs`)

- `output`: Completed guidance, actions, or artifacts produced by this skill.

### Triggers (`triggers`)

- `trigger`: Use when the frontmatter description conditions are met.

- `procedure`: Follow the ordered steps in the workflow section.

### Edge Cases (`edge_cases`)

- `edge_case`: If required context is missing, gather or request it before continuing.

### Safety Constraints (`safety_constraints`)

- `constraint`: Avoid destructive operations without explicit user intent.

### Examples (`examples`)

- `example`: Activate this skill when the request matches its trigger conditions.

- `goal`: Systematic troubleshooting for Docker containers hosting MCP servers.

## Core Principles (`core_principles`)

### Principle (`principle`)
Attributes: name="Logs Before Restart"

- `rule`: Always check logs first before restarting containers

- `rule`: Restarting masks the root cause of issues

- `rule`: Export logs if needed for later analysis

### Principle (`principle`)
Attributes: name="Resource Awareness"

- `rule`: Set memory and CPU limits in docker-compose

- `rule`: Monitor resource usage with docker stats

### Principle (`principle`)
Attributes: name="Health-First Operations"

- `rule`: Use health checks for all MCP servers

- `rule`: Verify health after any operational changes

## Workflow (`workflow`)

### Step (`step`)
Attributes: number="1", name="Identify Failing Container"

- `command`: docker ps -a --filter "name=mcp"

- `instruction`: Confirm status, exit code, and recent restart behavior.

### Step (`step`)
Attributes: number="2", name="Collect Diagnostics"

- `command`: docker logs &lt;container&gt; --tail 200

- `command`: docker inspect &lt;container&gt;

- `command`: docker stats --no-stream

### Step (`step`)
Attributes: number="3", name="Apply Corrective Action"

- `instruction`: Fix configuration, secrets, network, or resource constraints based on diagnostics.

- `command`: docker restart &lt;container&gt;

### Step (`step`)
Attributes: number="4", name="Verify Health"

- `instruction`: Re-check health status and confirm expected behavior under load.

- `command`: docker ps --filter "name=mcp"

### Step (`step`)
Attributes: number="5", name="Capture Outcome"

- `instruction`: Record root cause, remediation, and prevention steps for future incidents.

## Quick Reference (`quick_reference`)

- `command` (purpose="List MCP containers"): docker ps --filter "name=mcp"

- `command` (purpose="View container logs"): docker logs &lt;container&gt; --tail 100

- `command` (purpose="Restart container"): docker restart &lt;container&gt;

- `command` (purpose="Inspect container"): docker inspect &lt;container&gt;

- `command` (purpose="Shell into container"): docker exec -it &lt;container&gt; /bin/sh

- `command` (purpose="View resource usage"): docker stats --no-stream

## Troubleshooting Workflows (`troubleshooting_workflows`)

### Workflow (`workflow`)
Attributes: name="MCP Server Not Responding"

- `step`: Check container status: docker ps -a --filter "name=mcp-&lt;server&gt;"

- `step`: If stopped, check exit reason: docker logs &lt;container&gt; --tail 50

- `step`: If running but unresponsive, check health

- `step`: Restart if needed: docker restart &lt;container&gt;

- `step`: Verify recovery

### Workflow (`workflow`)
Attributes: name="High Memory/CPU Usage"

- `step`: Identify hogs: docker stats --no-stream

- `step`: Check for runaway processes: docker exec &lt;container&gt; ps aux

- `step`: Restart if necessary

- `step`: Set limits: docker update --memory="512m" &lt;container&gt;

## Lifecycle Commands (`lifecycle_commands`)

### Category (`category`)
Attributes: name="Starting"

- `command` (purpose="Start all"): docker-compose -f docker-mcp.yml up -d

- `command` (purpose="Start specific"): docker-compose up -d &lt;service&gt;

### Category (`category`)
Attributes: name="Stopping"

- `command` (purpose="Stop and remove"): docker-compose down

- `command` (purpose="Stop preserve"): docker-compose stop

### Category (`category`)
Attributes: name="Updating"

- `command` (purpose="Pull latest"): docker-compose pull

- `command` (purpose="Recreate"): docker-compose up -d --force-recreate

## Log Analysis (`log_analysis`)

- `pattern` (purpose="View recent errors"): docker logs &lt;container&gt; 2&gt;&1 | grep -i "error" | tail -20

- `pattern` (purpose="Watch for events"): docker logs -f &lt;container&gt; 2&gt;&1 | grep "tool_call"

- `pattern` (purpose="Export logs"): docker logs &lt;container&gt; &gt; mcp-server.log 2&gt;&1

## Best Practices (`best_practices`)

- `do`: Always check logs before restarting

- `do`: Set resource limits in docker-compose

- `do`: Use health checks for all MCP servers

- `do`: Keep containers stateless (use volumes for data)

- `do`: Export logs before destroying failed containers

- `dont`: Force kill without checking logs

- `dont`: Run containers without resource limits

- `dont`: Store data inside containers

- `dont`: Ignore health check failures

- `dont`: Use docker run for stack containers (use compose)

## Resources (`resources`)

### Script (`script`)
Attributes: name="health_check.ps1", purpose="Automated container diagnostics"

- `usage`: .\scripts\health_check.ps1

- `usage`: .\scripts\health_check.ps1 -ContainerFilter "github" -LogLines 50

- `description`: Checks all MCP containers, shows logs for unhealthy ones, reports resource usage

## Related Skills (`related_skills`)

- `skill`: mcp-manager

- `skill`: mcp-builder
```
