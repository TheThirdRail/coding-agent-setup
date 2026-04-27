# MCP And Tool Use

Use this lane when deciding whether configured tools, MCP servers, or supplemental capabilities should be used.

## Guidelines

- Use configured tools and MCP servers only when they materially improve accuracy, recency, context efficiency, execution quality, or verification.
- Prefer the smallest sufficient capability.
- Use Serena or semantic codebase tools for broad cross-file symbol, reference, or project-structure understanding.
- Do not use Serena for trivial single-file edits where direct inspection is enough.
- Use docs or current-source lookup tools for APIs, platforms, or dependencies likely to have changed.
- Use Docker MCP or lazy-load tools when a supplemental server is needed, and unload or remove supplemental tools when done if repo convention says so.
- Respect approval, sandbox, and trust settings.
- Summarize only important tool findings; do not dump raw tool output unless requested.
- Codex command execution safety and shell approval behavior are governed by `Agent/OpenAI/default.rules`, not by this guidance lane.
