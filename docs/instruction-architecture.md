# Instruction Architecture

Keep always-on prompts small. Put specialized behavior in the narrowest artifact that can own it.

| Instruction type | Canonical home |
|---|---|
| Global behavior | `Agent/OpenAI/AGENTS.md`, `Agent/Google/GEMINI.md` |
| Focused operational guidance | `Agent/*/Skills/layered-guidelines/SKILL.md` and `references/` |
| Deep procedures | `Agent/*/Skills/*/SKILL.md` and `references/` lanes |
| Command execution policy | `Agent/OpenAI/default.rules`; Antigravity product settings where supported |
| Project-specific constraints | Project `AGENTS.md`, project `GEMINI.md`, `.agent/rules/`, or vendor-supported workspace settings |
| Manual repeatable flows | `Agent/Google/Workflows/*.md` or future slash-command equivalents |
| Specialist delegation | Skill descriptions, subagent/custom-agent docs if added later |
| Scheduled recurrence | `Agent/OpenAI/Automations/*.automation.md` |
| External integrations | Vendor MCP config files and `MCP-Servers/` docs/scripts |
| Project memory | `archive-manager`, `project-continuity`, and active `Agent-Context` archives |

Rules of thumb:

- Do not expand `AGENTS.md` or `GEMINI.md` with routing tables, long workflows, MCP catalogs, or domain playbooks.
- Do not copy focused universal rules into every project. Keep reusable cross-project guidance in `layered-guidelines`; use workspace/project rules only for project-specific constraints.
- Use skills for task-specific procedure, workflows for explicit user-invoked macros, and automations only for recurring Codex work.
- Keep documentation out of installable workflow folders unless the installer explicitly filters it out.
- Use MCP tools when they materially improve accuracy, recency, execution quality, context efficiency, or verification; prefer the smallest sufficient capability.
- This repo does not currently install Codex hooks or Antigravity product settings/allowlists. Document those limitations instead of inventing unsupported config.
- Do not use workspace-local Antigravity backup folders for install output; Antigravity treats local agent context locations as active instructions.
