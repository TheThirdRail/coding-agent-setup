# Archive And Continuity

Use this lane when work creates durable project context that future agents or humans need.

## Guidelines

- Archive substantial setup, planning, research, handoff, release, architecture, or long-running project work when this repository has an active archive system.
- Index meaningful code, docs, or config changes when the archive mechanism exists and the change is substantial enough to matter later.
- Do not force archive updates for trivial edits, typo fixes, small comment changes, or narrow mechanical changes with no lasting context value.
- Route archive actions through `archive-manager` when the correct archive mechanism is not obvious.
- Prefer archive retrieval first when archive freshness is adequate; fall back to direct file reads when archives are stale or missing.
- Never archive credentials, secrets, tokens, private environment values, or sensitive personal data.
