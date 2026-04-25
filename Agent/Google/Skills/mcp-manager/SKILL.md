---
name: mcp-manager
description: |
  Orchestrate MCP servers: load, unload, and optimize context usage.
  For container troubleshooting (logs, health), use docker-ops instead.
  Use when you need to discover, enable, optimize, or disable MCP server usage for a task.
---

<skill name="mcp-manager" version="2.0.0">
  <metadata>
    <keywords>mcp, docker, context, lazy-load, optimization</keywords>
  </metadata>



  <goal>Maintain optimal Antigravity context by managing MCP servers with lazy-loading.</goal>

  <core_principles>
    <principle name="Pure Lazy-Load Default">
      <rule>Default state: Zero enabled servers</rule>
      <rule>At startup, MCP_DOCKER should expose only Docker gateway native tools: mcp-find, mcp-add, mcp-config-set, mcp-remove, mcp-exec, and code-mode</rule>
      <rule>Load on demand: Use mcp-find to discover, mcp-add to load</rule>
      <rule>Clean up: Use mcp-remove for every server added during the task when the task is complete</rule>
    </principle>

    <principle name="Tool Budget">
      <threshold name="Target" count="20-30">Comfortable working range</threshold>
      <threshold name="Recommended Max" count="50">Antigravity recommendation</threshold>
      <threshold name="Hard Limit" count="100">Antigravity maximum</threshold>
    </principle>

    <principle name="Code-Mode First">
      <rule>For multi-tool tasks, create ONE composite tool using code-mode</rule>
      <rule>Result: ~90% context savings (~750 tokens saved)</rule>
    </principle>
  </core_principles>

  <workflow>
    <step number="1" name="Assess Need">
      <instruction>Determine if capability is needed</instruction>
    </step>

    <step number="2" name="Find Server">
      <action>mcp-find(query: "github")</action>
    </step>

    <step number="3" name="Check Budget">
      <instruction>Current tools + new server tools &lt; 50?</instruction>
    </step>

    <step number="4" name="Load Temporarily">
      <action>mcp-add(name: "github", activate: false)</action>
    </step>

    <step number="5" name="Perform Work">
      <instruction>Use mcp-exec for single calls, code-mode for multiple</instruction>
    </step>

    <step number="6" name="Cleanup">
      <action>mcp-remove(name: "github")</action>
      <command>powershell -ExecutionPolicy Bypass -File .\scripts\cleanup-runtime.ps1 -StaleMinutes 30</command>
    </step>
  </workflow>

  <decision_tree><![CDATA[
Need capability?
    ↓
Can Antigravity do it natively?
    YES → Use built-in, don't load server
    NO  ↓
Is server currently loaded?
    YES → Use it directly
    NO  ↓
Check tool budget (current + new < 50?)
    NO  → Remove unused servers first
    YES → Safe to add
    ↓
Multiple operations needed?
    YES → Use code-mode to combine
    NO  → Use mcp-exec directly
    ↓
Task complete? → mcp-remove every server loaded for this task
  ]]></decision_tree>

  <server_categories>
    <category name="Always Consider First">
      <server name="memory" tools="9" purpose="Knowledge graph storage"/>
      <server name="sequential-thinking" tools="1" purpose="Reasoning framework"/>
    </category>

    <category name="Load On-Demand">
      <server name="github" tools="26" purpose="GitHub API"/>
      <server name="brave-search" tools="2" purpose="Web search"/>
      <server name="playwright" tools="22" purpose="Browser automation"/>
    </category>

    <category name="Specialized (Use Rarely)">
      <server name="lsmcp, pylance, rust-analyzer" purpose="Language servers"/>
      <server name="cloudflare, supabase, neon" purpose="Cloud services"/>
    </category>
  </server_categories>

  <code_mode_pattern><![CDATA[
Instead of:
  mcp-add github + mcp-add memory
  Call github.search_repos
  Call memory.create_entities (5 times)
  mcp-remove both

Do this:
  mcp-add github + memory
  Use code-mode to create ONE custom tool
  Call that ONE tool
  mcp-remove both

Context savings: ~750 tokens per operation
  ]]></code_mode_pattern>

  <best_practices>
    <do>Always check tool count before adding servers</do>
    <do>Use mcp-find to discover capabilities</do>
    <do>Prefer code-mode for multi-step operations</do>
    <do>Unload every task-loaded server immediately after task completion</do>
    <do>After MCP-heavy sessions, run <command>.\scripts\cleanup-runtime.ps1 -StaleMinutes 30</command> to remove stale duplicate MCP gateway or runtime processes.</do>
    <do>Use Antigravity's built-in features when available</do>
    <dont>Leave servers loaded "just in case"</dont>
    <dont>Add servers without checking budget</dont>
    <dont>Use multiple separate tool calls when code-mode can combine</dont>
    <dont>Load language servers unless actively coding in that language</dont>
  </best_practices>

  <troubleshooting>
    <issue problem="Too many tools error">Reset: docker mcp server reset</issue>
    <issue problem="Server won't load">Check secrets: docker mcp secret ls</issue>
    <issue problem="Context still bloated">Verify 0 permanently enabled servers</issue>
  </troubleshooting>

  <related_skills>
    <skill>docker-ops</skill>
    <skill>mcp-builder</skill>
  </related_skills>
</skill>
