---
name: agent-builder
description: |
  Meta-skill for extending Antigravity's capabilities. Acts as a router
  to help users build Skills, Workflows, Rules, or MCP Tools.
  Use when the user wants to "add something" to the agent or "teach" it new tricks
  but hasn't specified exactly which component type to create.
---
# Skill: agent-builder
Attributes: name="agent-builder", version="2.0.0"

## Metadata (`metadata`)

- `keywords`: build, create, extend, skill, workflow, rule, tool, mcp

## Spec Contract (`spec_contract`)

- `id`: agent-builder

- `name`: agent-builder

- `version`: 2.0.0

- `last_updated`: 2026-02-09

- `purpose`: Guide the user to the correct builder skill for extending Antigravity's capabilities.

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

- `goal`: Guide the user to the correct builder skill for extending Antigravity's capabilities.

## Core Principles (`core_principles`)

### Principle (`principle`)
Attributes: name="Route Before Building"

- `rule`: Ask minimal clarifying questions, then route to one primary builder skill.

- `rule`: Avoid mixing build tracks unless the user explicitly requests composition.

### Principle (`principle`)
Attributes: name="Prefer Existing Capability"

- `rule`: Use mcp-manager to discover existing capabilities before routing to mcp-builder.

- `rule`: Treat custom MCP construction as a last resort.

### Principle (`principle`)
Attributes: name="Keep Handoffs Explicit"

- `rule`: State which builder skill is selected and why.

- `rule`: Keep handoff criteria concrete so the target builder can execute immediately.

## Decision Tree (`decision_tree`)

### Node (`node`)
Attributes: id="start", question="What kind of capability do you want to add?"

#### Branch (`branch`)
Attributes: answer="Reusable knowledge/instructions", target="skill-builder"

- `description`: Best for: "How-to" guides, procedural knowledge, specialized tech stacks

#### Branch (`branch`)
Attributes: answer="Step-by-step process", target="workflow-builder"

- `description`: Best for: Checklists, multi-step procedures, standard operating procedures

#### Branch (`branch`)
Attributes: answer="Behavioral constraint", target="rule-builder"

- `description`: Best for: "Always do X", "Never do Y", style guides, safety rails

#### Branch (`branch`)
Attributes: answer="New functional ability", target="mcp-tool-decision"

- `description`: Best for: Executing code, API calls, system operations

### Node (`node`)
Attributes: id="mcp-tool-decision", question="Does the functionality already exist in an MCP server?"

#### Branch (`branch`)
Attributes: answer="Yes / Maybe", target="mcp-manager"

- `action`: Use mcp-manager to Find/Add existing servers

#### Branch (`branch`)
Attributes: answer="Yes, but I want to combine tools", target="mcp-manager"

- `action`: Use mcp-manager code-mode feature

#### Branch (`branch`)
Attributes: answer="No, I need to build it from scratch", target="mcp-builder"

- `action`: Create a custom MCP tool

## Workflow (`workflow`)

### Step (`step`)
Attributes: number="1", name="Identify Need"

- `instruction`: Ask clarifying questions to determine the nature of the capability.

- `example`: "Are you trying to teach me a process (Workflow), a concept (Skill), or give me a new tool (MCP)?"

### Step (`step`)
Attributes: number="2", name="Route to Builder"

- `instruction`: Invoke the appropriate sub-skill based on determination.

#### Case (`case`)
Attributes: condition="Skill"

- `action`: Execute skill-builder

#### Case (`case`)
Attributes: condition="Workflow"

- `action`: Execute workflow-builder

#### Case (`case`)
Attributes: condition="Rule"

- `action`: Execute rule-builder

#### Case (`case`)
Attributes: condition="MCP Tool"

- `action`: Execute mcp-builder

## Best Practices (`best_practices`)

- `do`: Route to one builder skill when the request maps cleanly

- `do`: Use mcp-manager before mcp-builder for capability discovery

- `do`: Reframe vague requests into concrete output goals

- `dont`: Start implementing before the capability type is identified

- `dont`: Assume custom tooling is needed without checking existing options

## Related Skills (`related_skills`)

- `skill`: skill-builder

- `skill`: workflow-builder

- `skill`: rule-builder

- `skill`: mcp-builder

- `skill`: mcp-manager
