# Legacy Lane: docker-ops

Vendor: Google Antigravity
Router: `mcp-ops`
Source archive: `.\Agent\Google\deprecated-Skills\docker-ops\SKILL.md`
Consolidated: 2026-04-25

The content below is the former installable skill or workflow body, preserved as an on-demand lane reference.

```markdown
---
name: docker-ops
description: |
  Troubleshoot Docker containers for MCP servers. Use when containers fail,
  need logs, or require health checks. For loading/unloading servers, use mcp-manager.
---

<skill name="docker-ops" version="2.0.0">
  <metadata>
    <keywords>docker, containers, debugging, logs, health-checks</keywords>
  </metadata>



  <goal>Systematic troubleshooting for Docker containers hosting MCP servers.</goal>

  <core_principles>
    <principle name="Logs Before Restart">
      <rule>Always check logs first before restarting containers</rule>
      <rule>Restarting masks the root cause of issues</rule>
      <rule>Export logs if needed for later analysis</rule>
    </principle>

    <principle name="Resource Awareness">
      <rule>Set memory and CPU limits in docker-compose</rule>
      <rule>Monitor resource usage with docker stats</rule>
    </principle>

    <principle name="Health-First Operations">
      <rule>Use health checks for all MCP servers</rule>
      <rule>Verify health after any operational changes</rule>
    </principle>
  </core_principles>

  <workflow>
    <step number="1" name="Identify Failing Container">
      <command>docker ps -a --filter "name=mcp"</command>
      <instruction>Confirm status, exit code, and recent restart behavior.</instruction>
    </step>

    <step number="2" name="Collect Diagnostics">
      <command>docker logs &lt;container&gt; --tail 200</command>
      <command>docker inspect &lt;container&gt;</command>
      <command>docker stats --no-stream</command>
    </step>

    <step number="3" name="Apply Corrective Action">
      <instruction>Fix configuration, secrets, network, or resource constraints based on diagnostics.</instruction>
      <command>docker restart &lt;container&gt;</command>
    </step>

    <step number="4" name="Verify Health">
      <instruction>Re-check health status and confirm expected behavior under load.</instruction>
      <command>docker ps --filter "name=mcp"</command>
    </step>

    <step number="5" name="Capture Outcome">
      <instruction>Record root cause, remediation, and prevention steps for future incidents.</instruction>
    </step>
  </workflow>

  <quick_reference>
    <command purpose="List MCP containers">docker ps --filter "name=mcp"</command>
    <command purpose="View container logs">docker logs &lt;container&gt; --tail 100</command>
    <command purpose="Restart container">docker restart &lt;container&gt;</command>
    <command purpose="Inspect container">docker inspect &lt;container&gt;</command>
    <command purpose="Shell into container">docker exec -it &lt;container&gt; /bin/sh</command>
    <command purpose="View resource usage">docker stats --no-stream</command>
  </quick_reference>

  <troubleshooting_workflows>
    <workflow name="MCP Server Not Responding">
      <step>Check container status: docker ps -a --filter "name=mcp-&lt;server&gt;"</step>
      <step>If stopped, check exit reason: docker logs &lt;container&gt; --tail 50</step>
      <step>If running but unresponsive, check health</step>
      <step>Restart if needed: docker restart &lt;container&gt;</step>
      <step>Verify recovery</step>
    </workflow>

    <workflow name="High Memory/CPU Usage">
      <step>Identify hogs: docker stats --no-stream</step>
      <step>Check for runaway processes: docker exec &lt;container&gt; ps aux</step>
      <step>Restart if necessary</step>
      <step>Set limits: docker update --memory="512m" &lt;container&gt;</step>
    </workflow>
  </troubleshooting_workflows>

  <lifecycle_commands>
    <category name="Starting">
      <command purpose="Start all">docker-compose -f docker-mcp.yml up -d</command>
      <command purpose="Start specific">docker-compose up -d &lt;service&gt;</command>
    </category>

    <category name="Stopping">
      <command purpose="Stop and remove">docker-compose down</command>
      <command purpose="Stop preserve">docker-compose stop</command>
    </category>

    <category name="Updating">
      <command purpose="Pull latest">docker-compose pull</command>
      <command purpose="Recreate">docker-compose up -d --force-recreate</command>
    </category>
  </lifecycle_commands>

  <log_analysis>
    <pattern purpose="View recent errors">docker logs &lt;container&gt; 2&gt;&amp;1 | grep -i "error" | tail -20</pattern>
    <pattern purpose="Watch for events">docker logs -f &lt;container&gt; 2&gt;&amp;1 | grep "tool_call"</pattern>
    <pattern purpose="Export logs">docker logs &lt;container&gt; &gt; mcp-server.log 2&gt;&amp;1</pattern>
  </log_analysis>

  <best_practices>
    <do>Always check logs before restarting</do>
    <do>Set resource limits in docker-compose</do>
    <do>Use health checks for all MCP servers</do>
    <do>Keep containers stateless (use volumes for data)</do>
    <do>Export logs before destroying failed containers</do>
    <dont>Force kill without checking logs</dont>
    <dont>Run containers without resource limits</dont>
    <dont>Store data inside containers</dont>
    <dont>Ignore health check failures</dont>
    <dont>Use docker run for stack containers (use compose)</dont>
  </best_practices>

  <resources>
    <script name="health_check.ps1" purpose="Automated container diagnostics">
      <usage>.\scripts\health_check.ps1</usage>
      <usage>.\scripts\health_check.ps1 -ContainerFilter "github" -LogLines 50</usage>
      <description>Checks all MCP containers, shows logs for unhealthy ones, reports resource usage</description>
    </script>
  </resources>

  <related_skills>
    <skill>mcp-manager</skill>
    <skill>mcp-builder</skill>
  </related_skills>
</skill>
```
