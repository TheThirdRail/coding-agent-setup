# Instruction Architecture

Keep always-on prompts small. Put specialized behavior in the narrowest artifact that can own it.

| Instruction type | Canonical home |
|---|---|
| Global behavior | `Agent/OpenAI/AGENTS.md`, `Agent/Google/GEMINI.md` |
| Deep procedures | `Agent/*/Skills/*/SKILL.md` and `references/` lanes |
| Enforceable policy | `Agent/OpenAI/default.rules`, `Agent/Google/Rules/*.md`, supported client settings or hooks |
| Manual repeatable flows | `Agent/Google/Workflows/*.md` or future slash-command equivalents |
| Specialist delegation | Skill descriptions, subagent/custom-agent docs if added later |
| Scheduled recurrence | `Agent/OpenAI/Automations/*.automation.md` |
| External integrations | Vendor MCP config files and `MCP-Servers/` docs/scripts |
| Project memory | `archive-manager`, `project-continuity`, and active `Agent-Context` archives |

Rules of thumb:

- Do not expand `AGENTS.md` or `GEMINI.md` with routing tables, long workflows, MCP catalogs, or domain playbooks.
- Use skills for task-specific procedure, workflows for explicit user-invoked macros, and automations only for recurring Codex work.
- Keep documentation out of installable workflow folders unless the installer explicitly filters it out.
- Use MCP tools when they materially improve accuracy, recency, execution quality, context efficiency, or verification; prefer the smallest sufficient capability.
- This repo does not currently install Codex hooks or Antigravity product settings/allowlists. Document those limitations instead of inventing unsupported config.
