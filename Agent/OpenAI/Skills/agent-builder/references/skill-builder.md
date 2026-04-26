# Legacy Lane: skill-builder

Vendor: OpenAI Codex
Router: `agent-builder`
Source archive: `.\Agent\OpenAI\deprecated-Skills\skill-builder\SKILL.md`
Consolidated: 2026-04-25

The content below is the former installable skill or workflow body, preserved as an on-demand lane reference.

```markdown
---
name: skill-builder
description: |
  Create and upgrade OpenAI Codex skills using the current `SKILL.md` plus
  `agents/openai.yaml` format. Use when building a new skill, converting a
  legacy XML or metadata-based skill, validating skill structure, or preparing
  a skill for local or global installation.
---

# Skill Builder

## Overview

Create or modernize a skill so another Codex instance can discover it from frontmatter, follow concise Markdown instructions, and load scripts, references, or assets only when needed.

## Working Rules

- Use only `name` and `description` in `SKILL.md` frontmatter.
- Put trigger language in `description`, not in a separate "When to Use" body section.
- Write the body as plain Markdown. Do not embed XML in `SKILL.md`.
- Add `agents/openai.yaml` with `display_name`, `short_description`, and `default_prompt`.
- Create `scripts/`, `references/`, and `assets/` only when they provide repeatable value.
- Keep references one level deep from `SKILL.md`.

## Workflow

### 1. Define the skill

- Clarify what the skill does, when it should trigger, and what outputs it should produce.
- Ask for concrete usage examples if the scope is still fuzzy.

### 2. Plan reusable resources

- Put repeatable automation in `scripts/`.
- Put detailed documentation or schemas in `references/`.
- Put templates, boilerplate, or binary resources in `assets/`.

### 3. Initialize the folder

- Run `scripts/init_skill.ps1 -Name "skill-name" -Path "skill-name"` to scaffold outside an active agent-context folder.
- Pass `-Resources "scripts,references,assets"` only for folders the skill actually needs.
- Pass repeated `-Interface key=value` values when you already know the UI metadata.

### 4. Write the skill

- Keep the frontmatter concise and discovery-focused.
- Use imperative instructions in the body.
- Link to bundled resources directly from `SKILL.md`.
- Remove placeholder/example files that are no longer needed.

### 5. Generate UI metadata

- Run `python scripts/generate_openai_yaml.py <path-to-skill>`.
- Override interface fields only when the defaults are not good enough.

### 6. Validate

- Run `python scripts/quick_validate.py <path-to-skill>`.
- Run `scripts/validate-links.ps1 -SkillsRoot <skills-root>` to verify related skill references.
- Run `scripts/package_skill.ps1 -Path <path-to-skill> -OutputDir <dist-dir>` when you need a packaged artifact.

### 7. Install

- Use `scripts/move-global-skill.ps1` for a global install.
- Use `scripts/move-local-skill.ps1` for a workspace-local install.

### 8. Iterate

- Improve the description when discovery is weak.
- Split large or unfocused skills instead of growing them indefinitely.
- Re-run validation after every structural change.

## Commands

```powershell
scripts/init_skill.ps1 -Name "skill-name" -Path "skill-name"
python scripts/generate_openai_yaml.py skill-name
python scripts/quick_validate.py skill-name
scripts/validate-links.ps1 -SkillsRoot .
scripts/package_skill.ps1 -Path skill-name -OutputDir .\dist
```

## Best Practices

- Keep `description` specific enough that the right tasks trigger the skill.
- Prefer short examples over long theory.
- Store detailed docs in `references/` instead of bloating `SKILL.md`.
- Test bundled scripts instead of assuming they work.
- Remove obsolete files when converting a legacy skill.

## Related Skills

- `workflow-builder`
- `mcp-manager`
- `mcp-builder`
```
