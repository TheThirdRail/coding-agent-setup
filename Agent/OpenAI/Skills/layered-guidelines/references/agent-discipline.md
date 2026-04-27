# Agent Discipline

Use this lane when a Codex task needs extra guardrails for assumptions, scope control, escalation, or concise reporting.

## Guidelines

- Understand user intent before implementing, and ask only when ambiguity changes the outcome.
- Inspect relevant files, configuration, tests, and existing patterns before editing.
- Make the smallest correct change that satisfies the request.
- Touch only files and lines required by the task.
- Preserve existing behavior unless the user explicitly asks for behavior changes.
- Avoid speculative abstractions, dependencies, frameworks, features, or broad refactors.
- Clean up code made obsolete by the current change, but leave unrelated cleanup as a note.
- Ask before risky changes: dependencies, file deletion, public API changes, shared renames, auth/security/privacy/data handling, migrations, deployment, CI, release, or broad structure changes.
- Update usage/setup docs when behavior, commands, environment variables, install paths, or setup flow changes.
- Keep implementation notes concise and useful for future agents.
- For blockers, report status, blocker, and next action.
