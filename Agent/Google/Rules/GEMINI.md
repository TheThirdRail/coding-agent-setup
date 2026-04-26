# Google Rules Index

`Agent/Google/GEMINI.md` is the canonical lean always-on Antigravity instruction file.

This directory preserves specialized rule guidance that was moved out of the global file. These rule files are repo documentation and future rule-source artifacts; the current installer copies only `Agent/Google/GEMINI.md` to `~/.gemini/GEMINI.md`.

## Specialized Rules

- `agent-discipline.md`: surgical change discipline, escalation, documentation, and communication behavior.
- `environment.md`: project-local dependency and toolchain environment policy.
- `security.md`: secrets, auth, privacy, permissions, and sensitive-data guardrails.
- `testing.md`: regression coverage and honest verification behavior.
- `runtime-observability.md`: error handling and logging safety.
- `archive.md`: continuity/archive update policy for substantial work.

## Install Mapping

- Source global: `Agent/Google/GEMINI.md`
- Installed global: `~/.gemini/GEMINI.md`
- Specialized rules: `Agent/Google/Rules/*.md`
- Workspace-local Antigravity backup installs are disabled because local agent context folders are read as active instructions.

Do not put long routing tables, workflow procedures, automation schedules, or detailed MCP server descriptions in the global file. Keep those in skills, workflows, MCP docs, or the focused rule files listed above.

## Native Settings

This repo does not currently manage Antigravity terminal auto-execution policy, review policy, JavaScript execution policy, allowlists, denylists, browser allowlists, or workspace trust settings. Keep those in Antigravity product settings unless a supported repo-owned settings installer is added later.
