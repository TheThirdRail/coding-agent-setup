---
name: mcp-builder
description: |
  Create custom MCP tools from scratch. For combining existing MCP tools,
  use mcp-manager's code-mode feature instead.
  Use when no existing MCP server provides the required capability and a custom MCP tool is needed.
---
# Skill: mcp-builder
Attributes: name="mcp-builder", version="2.0.0"

## Metadata (`metadata`)

- `keywords`: mcp, tools, custom, schema, handlers, development

## Spec Contract (`spec_contract`)

- `id`: mcp-builder

- `name`: mcp-builder

- `version`: 2.0.0

- `last_updated`: 2026-02-09

- `purpose`: Create custom MCP tools to extend Antigravity's capabilities.

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

- `goal`: Create custom MCP tools to extend Antigravity's capabilities.

## Core Principles (`core_principles`)

### Principle (`principle`)
Attributes: name="Schema-First Design"

- `rule`: Define the tool's interface (schema) before implementation

- `rule`: Use JSON Schema for input validation

- `rule`: Include clear descriptions for AI understanding

### Principle (`principle`)
Attributes: name="Structured Returns"

- `rule`: Always return structured data (objects), not raw strings

- `rule`: Include success/error status in responses

- `rule`: Provide contextual error messages

### Principle (`principle`)
Attributes: name="Single Responsibility"

- `rule`: Each tool should do one thing well

- `rule`: Combine multiple tools using code-mode

- `rule`: Keep input parameters focused and minimal

- `tool_anatomy`:
```text
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
```

## Workflow (`workflow`)

### Step (`step`)
Attributes: number="1", name="Define Tool Schema"

- `template`:
```text
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
```

### Step (`step`)
Attributes: number="2", name="Implement Handler"

- `template`:
```text
async function handler({ city, units = "celsius" }) {
  try {
    const result = await fetchData(city);
    return { success: true, data: result };
  } catch (error) {
    return { success: false, error: error.message, code: "API_ERROR" };
  }
}
```

### Step (`step`)
Attributes: number="3", name="Register with MCP Server"

- `instruction`: Add to tools/list and tools/call handlers

### Step (`step`)
Attributes: number="4", name="Test with mcp-exec"

- `action`: mcp-exec(name: "fetch_weather", arguments: {city: "London"})

- `decision_tree`:
```text
Need custom functionality?
    ↓
Check if existing MCP server provides it
    YES → Use existing (mcp-find)
    NO  ↓
Is it a one-off operation?
    YES → Use code-mode to script it
    NO  ↓
Define tool schema → Implement handler → Test → Register
```

## Schema Best Practices (`schema_best_practices`)

- `practice` (aspect="Names", bad="do_thing", good="create_github_issue")

- `practice` (aspect="Descriptions", bad="Does stuff", good="Creates a new issue in a GitHub repository")

- `practice` (aspect="Required fields", bad="Everything optional", good="Mark truly required fields")

- `practice` (aspect="Defaults", bad="No defaults", good="default: 'main' for branch")

- `practice` (aspect="Constraints", bad="Free text for status", good="enum: ['open', 'closed']")

## Tool Categories (`tool_categories`)

### Category (`category`)
Attributes: name="Query Tools", description="Read-Only"

- `example` (name="search_customers", inputs="query, limit", returns="matching records")

### Category (`category`)
Attributes: name="Action Tools", description="Write Operations"

- `example` (name="deploy_application", inputs="environment, version, dry_run", returns="deployment status")

### Category (`category`)
Attributes: name="Composite Tools", description="Multi-Step"

- `example` (name="analyze_project", inputs="path, include_security", returns="summary report")

- `error_handling_pattern`:
```text
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
```

## Best Practices (`best_practices`)

- `do`: Use verb_noun naming (create_issue, search_repos)

- `do`: Include parameter descriptions for AI

- `do`: Return structured objects with success/error status

- `do`: Validate inputs before processing

- `do`: Include helpful error messages

- `do`: Test with mcp-exec before registering

- `dont`: Return raw strings

- `dont`: Create tools for one-off tasks (use code-mode)

- `dont`: Make all parameters optional

- `dont`: Catch errors silently

- `dont`: Create mega-tools

- `dont`: Skip input validation

## Resource Folders (`resource_folders`)

### Folder (`folder`)
Attributes: name="scripts/", purpose="Utility scripts"

- `file`: set-mcp-secrets.ps1

## Related Skills (`related_skills`)

- `skill`: mcp-manager

- `skill`: docker-ops
