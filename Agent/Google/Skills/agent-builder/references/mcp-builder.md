# Legacy Lane: mcp-builder

Vendor: Google Antigravity
Router: `agent-builder`
Source archive: `.\Agent\Google\deprecated-Skills\mcp-builder\SKILL.md`
Consolidated: 2026-04-25

The content below is the former installable skill or workflow body, preserved as an on-demand lane reference.

```markdown
---
name: mcp-builder
description: |
  Create custom MCP tools from scratch. For combining existing MCP tools,
  use mcp-manager's code-mode feature instead.
  Use when no existing MCP server provides the required capability and a custom MCP tool is needed.
---

<skill name="mcp-builder" version="2.0.0">
  <metadata>
    <keywords>mcp, tools, custom, schema, handlers, development</keywords>
  </metadata>



  <goal>Create custom MCP tools to extend Antigravity's capabilities.</goal>

  <core_principles>
    <principle name="Schema-First Design">
      <rule>Define the tool's interface (schema) before implementation</rule>
      <rule>Use JSON Schema for input validation</rule>
      <rule>Include clear descriptions for AI understanding</rule>
    </principle>

    <principle name="Structured Returns">
      <rule>Always return structured data (objects), not raw strings</rule>
      <rule>Include success/error status in responses</rule>
      <rule>Provide contextual error messages</rule>
    </principle>

    <principle name="Single Responsibility">
      <rule>Each tool should do one thing well</rule>
      <rule>Combine multiple tools using code-mode</rule>
      <rule>Keep input parameters focused and minimal</rule>
    </principle>
  </core_principles>

  <tool_anatomy><![CDATA[
┌──────────────────────────────────────────┐
│                MCP Tool                   │
├──────────────────────────────────────────┤
│  1. Schema (JSON)                         │
│     - name: unique identifier             │
│     - description: what it does           │
│     - inputSchema: parameters             │
├──────────────────────────────────────────┤
│  2. Handler (Function)                    │
│     - Receives validated input            │
│     - Executes business logic             │
│     - Returns structured result           │
└──────────────────────────────────────────┘
  ]]></tool_anatomy>

  <workflow>
    <step number="1" name="Define Tool Schema">
      <template><![CDATA[
{
  name: "fetch_weather",
  description: "Get current weather for a city.",
  inputSchema: {
    type: "object",
    properties: {
      city: { type: "string", description: "City name" },
      units: { type: "string", enum: ["celsius", "fahrenheit"], default: "celsius" }
    },
    required: ["city"]
  }
}
      ]]></template>
    </step>

    <step number="2" name="Implement Handler">
      <template><![CDATA[
async function handler({ city, units = "celsius" }) {
  try {
    const result = await fetchData(city);
    return { success: true, data: result };
  } catch (error) {
    return { success: false, error: error.message, code: "API_ERROR" };
  }
}
      ]]></template>
    </step>

    <step number="3" name="Register with MCP Server">
      <instruction>Add to tools/list and tools/call handlers</instruction>
    </step>

    <step number="4" name="Test with mcp-exec">
      <action>mcp-exec(name: "fetch_weather", arguments: {city: "London"})</action>
    </step>
  </workflow>

  <decision_tree><![CDATA[
Need custom functionality?
    ↓
Check if existing MCP server provides it
    YES → Use existing (mcp-find)
    NO  ↓
Is it a one-off operation?
    YES → Use code-mode to script it
    NO  ↓
Define tool schema → Implement handler → Test → Register
  ]]></decision_tree>

  <schema_best_practices>
    <practice aspect="Names" bad="do_thing" good="create_github_issue"/>
    <practice aspect="Descriptions" bad="Does stuff" good="Creates a new issue in a GitHub repository"/>
    <practice aspect="Required fields" bad="Everything optional" good="Mark truly required fields"/>
    <practice aspect="Defaults" bad="No defaults" good="default: 'main' for branch"/>
    <practice aspect="Constraints" bad="Free text for status" good="enum: ['open', 'closed']"/>
  </schema_best_practices>

  <tool_categories>
    <category name="Query Tools" description="Read-Only">
      <example name="search_customers" inputs="query, limit" returns="matching records"/>
    </category>

    <category name="Action Tools" description="Write Operations">
      <example name="deploy_application" inputs="environment, version, dry_run" returns="deployment status"/>
    </category>

    <category name="Composite Tools" description="Multi-Step">
      <example name="analyze_project" inputs="path, include_security" returns="summary report"/>
    </category>
  </tool_categories>

  <error_handling_pattern><![CDATA[
async function handler(input) {
  // 1. Validate input
  if (!input.required_field) {
    return { success: false, error: "Missing required field", code: "VALIDATION_ERROR" };
  }

  try {
    // 2. Execute operation
    const result = await doOperation(input);
    // 3. Return success
    return { success: true, data: result };
  } catch (error) {
    // 4. Return structured error
    return { success: false, error: error.message, code: "UNKNOWN_ERROR" };
  }
}
  ]]></error_handling_pattern>

  <best_practices>
    <do>Use verb_noun naming (create_issue, search_repos)</do>
    <do>Include parameter descriptions for AI</do>
    <do>Return structured objects with success/error status</do>
    <do>Validate inputs before processing</do>
    <do>Include helpful error messages</do>
    <do>Test with mcp-exec before registering</do>
    <dont>Return raw strings</dont>
    <dont>Create tools for one-off tasks (use code-mode)</dont>
    <dont>Make all parameters optional</dont>
    <dont>Catch errors silently</dont>
    <dont>Create mega-tools</dont>
    <dont>Skip input validation</dont>
  </best_practices>

  <resource_folders>
    <folder name="scripts/" purpose="Utility scripts">
      <file>set-mcp-secrets.ps1</file>
    </folder>
  </resource_folders>

  <related_skills>
    <skill>mcp-manager</skill>
    <skill>docker-ops</skill>
  </related_skills>
</skill>
```
