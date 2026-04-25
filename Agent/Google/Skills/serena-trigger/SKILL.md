---
name: serena-trigger
description: |
  Confirm that Serena is available through the client-native stdio MCP setup.
  Use when Serena-backed navigation is expected but unavailable, or when a
  client needs project activation guidance.
---

<skill name="serena-trigger" version="1.1.0">
  <metadata>
    <keywords>serena, mcp, stdio, project-activation, archive-code</keywords>
  </metadata>

  <goal>Keep Serena aligned with the documented per-client native MCP setup.</goal>

  <core_principles>
    <principle name="Native Serena">
      <rule>Do not start or retarget a shared Serena HTTP server for Codex or Antigravity.</rule>
      <rule>Codex starts Serena with <code>--project-from-cwd --context codex</code>.</rule>
      <rule>Antigravity starts Serena with <code>--context antigravity</code>; activate the project from Serena if the client does not pass it automatically.</rule>
      <rule>If Serena is unavailable after config changes, restart the client so it starts a fresh stdio MCP process.</rule>
    </principle>
  </core_principles>

  <workflow>
    <step number="0" name="Check Native Serena">
      <command>uvx -p 3.13 --from git+https://github.com/oraios/serena serena start-mcp-server --help</command>
      <instruction>Verify the client config has a serena entry using uvx.</instruction>
      <instruction>Use Serena project activation from the MCP tools when Antigravity needs a project selected.</instruction>
    </step>
  </workflow>

  <best_practices>
    <do>Keep Serena as the only non-Docker native MCP server in client configs.</do>
    <do>Restart the client after changing Serena MCP config.</do>
    <dont>Use the deprecated shared HTTP launcher for normal Codex or Antigravity work.</dont>
  </best_practices>

  <related_skills>
    <skill>archive-code</skill>
    <skill>archive-manager</skill>
  </related_skills>
</skill>
