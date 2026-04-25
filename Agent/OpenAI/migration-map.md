# OpenAI Migration Map

- Updated: 2026-04-25
- Active installable skills after consolidation: 8 router skills

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

- Canonical AGENTS policy: `Agent/OpenAI/AGENTS.md`
- Repo runtime AGENTS mirror: `AGENTS.md`
- Consolidated XML rules artifact: `Agent/OpenAI/default.rules`
- Skills root: `Agent/OpenAI/Skills`
- Skill archive: `Agent/OpenAI/deprecated-Skills`
- Workflow archive: `Agent/OpenAI/deprecated-Workflows`
- Rule archive: `Agent/OpenAI/deprecated-Rules`
