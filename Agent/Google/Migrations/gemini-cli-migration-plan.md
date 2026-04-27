# Gemini CLI Migration Plan (Google Vendor)

## Purpose
Map Antigravity Google artifacts to official Gemini CLI primitives for a future cutover while keeping current local formats (`Skills`, `Workflows`, and legacy `Rules` mirrors) aligned with the active source of truth.

## Source References
- Gemini CLI context files (`GEMINI.md`) and hierarchy: https://google-gemini.github.io/gemini-cli/docs/cli/gemini-md.html
- Custom commands (`/command`) model: https://google-gemini.github.io/gemini-cli/docs/cli/custom-commands.html
- Extensions packaging model: https://google-gemini.github.io/gemini-cli/docs/extensions/
- Headless automation mode: https://google-gemini.github.io/gemini-cli/docs/cli/headless.html
- Modular imports (`@file.md`) guidance: https://google-gemini.github.io/gemini-cli/docs/core/memport.html

## Mapping Table
| Antigravity artifact | Gemini CLI target | Notes |
|---|---|---|
| `Agent/Google/GEMINI.md` global instructions | Root `GEMINI.md` + optional `@imports` | Keep durable always-on behavior in the root file. |
| Focused guidance in `Skills/layered-guidelines/references/*.md` | Imported policy sections or extension docs | Keep expanded domain guidance out of the always-on root file unless imports are explicitly adopted. |
| Legacy rule docs in `Rules/*.md` | Compatibility/source mirrors | Preserve only as migration references while `layered-guidelines` remains canonical. |
| `Workflows/*.md` command recipes | `.gemini/commands/*.toml` | Each workflow becomes a command with argument schema and prompt body. |
| `Skills/*/SKILL.md` reusable capabilities | Extension components | Package capability docs/prompts/tools inside extension structure. |
| Skill-driven tool checks | Extension-provided MCP/tool config | Keep tool routing in extension docs plus command-level prompting. |
| Automation workflows | Headless CLI jobs + CI entrypoints | Run with `gemini --headless` and pinned command invocations. |

## Migration Actions
1. Scaffold command layer:
   - Create `.gemini/commands/`.
   - Generate command files for `task-router`, `quality-gates`, `context-governance`, and existing operational workflows.
   - Map workflow inputs/outputs to command arguments and deterministic output blocks.
2. Scaffold extension package:
   - Create extension root and manifest (`gemini-extension.json`).
   - Port each Antigravity skill into extension docs/prompts grouped by capability domain.
   - Add MCP/tool config and dependency notes for each capability requiring external tools.
3. Modularize context imports:
   - Keep root `GEMINI.md` concise and import supporting policy files using `@file.md` only when a future Gemini CLI cutover needs explicit imports.
   - Separate always-on policy modules from procedural command references.
4. Bridge compatibility:
   - Keep current `Rules/*.md` wrappers pointing to canonical `layered-guidelines` references during parallel-run.
   - Add one mapping index that links each wrapper to its Gemini command/extension target.
5. Validate behavior parity:
   - For each migrated workflow/skill, run side-by-side prompts and compare route decisions, gates, and safety outputs.
   - Record mismatches and patch command prompts or extension docs until parity is acceptable.

## Command and Extension Structure (Target)
```text
.gemini/
  GEMINI.md
  commands/
    task-router.toml
    quality-gates.toml
    context-governance.toml
    ...
extensions/
  antigravity-google/
    gemini-extension.json
    prompts/
    docs/
    tools/
```

## Cutover Strategy
1. Parallel-run phase:
   - Continue current Antigravity skills and workflows as primary, with `Rules/*.md` retained only as legacy/source mirrors.
   - Execute equivalent Gemini CLI commands for the same scenarios in shadow mode.
2. Confidence checks:
   - Route-selection equivalence for `task-router`.
   - Quality gate equivalence for refactor/testing/docs outcomes.
   - Runtime safety equivalence for dependency, error, and logging checks.
3. Controlled switch:
   - Promote Gemini commands/extensions to primary only after parity checks pass for agreed scenarios.
   - Keep wrappers and old mappings for one release cycle as rollback safety.
4. Rollback:
   - Repoint execution to existing Antigravity workflows/skills immediately.
   - Preserve migration logs and mismatch reports for the next attempt.
