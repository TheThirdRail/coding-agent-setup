# Google Rules Index

The focused rule guidance formerly stored here has been migrated into:

`Agent/Google/Skills/layered-guidelines/references/`

These files remain only as migration/source documentation unless a future Antigravity workspace-rules installer is added.

The active global behavior remains:

`Agent/Google/GEMINI.md`

The reusable focused guidance is now installed globally as the `layered-guidelines` skill.

## Specialized Rules

- `agent-discipline.md`: legacy/source mirror for surgical change discipline, escalation, documentation, and communication behavior.
- `environment.md`: legacy/source mirror for project-local dependency and toolchain environment policy.
- `security.md`: legacy/source mirror for secrets, auth, privacy, permissions, and sensitive-data guardrails.
- `testing.md`: legacy/source mirror for regression coverage and honest verification behavior.
- `runtime-observability.md`: legacy/source mirror for error handling and logging safety.
- `archive.md`: legacy/source mirror for continuity/archive update policy for substantial work.

## Install Mapping

- Source global: `Agent/Google/GEMINI.md`
- Installed global: `~/.gemini/GEMINI.md`
- Focused guidance source: `Agent/Google/Skills/layered-guidelines/references/*.md`
- Legacy/source rule docs: `Agent/Google/Rules/*.md`
- Workspace-local Antigravity backup installs are disabled because local agent context folders are read as active instructions.

Do not put long routing tables, workflow procedures, automation schedules, or detailed MCP server descriptions in the global file. Keep those in skills, workflows, MCP docs, or the `layered-guidelines` reference lanes listed above.

## Native Settings

This repo does not currently manage Antigravity terminal auto-execution policy, review policy, JavaScript execution policy, allowlists, denylists, browser allowlists, or workspace trust settings. Keep those in Antigravity product settings unless a supported repo-owned settings installer is added later.
