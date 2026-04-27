# OpenAI Migration Map

- Updated: 2026-04-27
- Active installable skills after consolidation: 8 router skills plus 1 `layered-guidelines` support skill

## Workflow To Skill Mapping

| Legacy workflow trigger | Skill ID |
|---|---|
| `/analyze` | `quality-repair` |
| `/architect` | `architect` |
| `/code` | `code` |
| `/dependency-check` | `quality-repair` |
| `/deploy` | `code` |
| `/fix-issue` | `quality-repair` |
| `/handoff` | `project-continuity` |
| `/morning` | `project-continuity` |
| `/onboard` | `project-continuity` |
| `/performance-tune` | `quality-repair` |
| `/pr` | `code` |
| `/project-setup` | `architect` |
| `/refactor` | `code` |
| `/research` | `research-docs` |
| `/review` | `quality-repair` |
| `/security-audit` | `quality-repair` |
| `/test-developer` | `code` |
| `/tutor` | `project-continuity` |

## Active Artifacts

- Lean canonical AGENTS policy: `Agent/OpenAI/AGENTS.md`
- Repo runtime AGENTS mirror: `AGENTS.md`
- Consolidated command rules artifact: `Agent/OpenAI/default.rules`
- Skills root: `Agent/OpenAI/Skills`
- Skill archive: `Agent/OpenAI/deprecated-Skills`
- Workflow archive: `Agent/OpenAI/deprecated-Workflows`
- Rule archive: `Agent/OpenAI/deprecated-Rules`

## Focused Rules Migration

| Legacy/source guidance | New canonical home |
|---|---|
| Google Rules/agent-discipline.md | Skills/layered-guidelines/references/agent-discipline.md |
| Google Rules/environment.md | Skills/layered-guidelines/references/environment.md |
| Google Rules/security.md | Skills/layered-guidelines/references/security.md |
| Google Rules/testing.md | Skills/layered-guidelines/references/testing.md |
| Google Rules/runtime-observability.md | Skills/layered-guidelines/references/runtime-observability.md |
| Google Rules/archive.md | Skills/layered-guidelines/references/archive-continuity.md |
| OpenAI default.rules | remains command policy at Agent/OpenAI/default.rules |
