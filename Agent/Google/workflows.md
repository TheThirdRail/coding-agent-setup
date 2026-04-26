# Antigravity Workflows

Workflows are explicit user-invoked macros. They are not hidden always-on policy.

## Active Workflows

- `Workflows/task-router.md`: kept as an on-demand routing helper when the user asks which consolidated router skill should handle a request.

## Placement Rules

- Durable behavior belongs in `Agent/Google/GEMINI.md` or focused rule files.
- Deep procedures and domain playbooks belong in skills and `references/` lanes.
- MCP/tool operation detail belongs in `mcp-ops` or MCP docs.
- Specialist role behavior belongs in skill descriptions or future subagent docs.

Do not add broad workflow files that duplicate the global prompt or skills.
