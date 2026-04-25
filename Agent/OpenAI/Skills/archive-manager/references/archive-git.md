# Legacy Lane: archive-git

Vendor: OpenAI Codex
Router: `archive-manager`
Source archive: `.\Agent\OpenAI\deprecated-Skills\archive-git\SKILL.md`
Consolidated: 2026-04-25

The content below is the former installable skill or workflow body, preserved as an on-demand lane reference.

```markdown
---
name: archive-git
description: |
  Query repository history for code evolution, ownership, and change context.
  Use when tracing when and why behavior changed, who modified critical files,
  or how specific patterns entered the codebase.
---
# Skill: archive-git
Attributes: name="archive-git", version="2.0.0"

## Metadata (`metadata`)

- `keywords`: archive, git, history, commits, evolution, blame, diffs

## Spec Contract (`spec_contract`)

- `id`: archive-git

- `name`: archive-git

- `version`: 2.0.0

- `last_updated`: 2026-02-09

- `purpose`: Provide reliable historical context by querying live git history with focused scripts.

### Inputs (`inputs`)

- `input`: User request and relevant project context.

### Outputs (`outputs`)

- `output`: Completed guidance, actions, or artifacts produced by this skill.

### Triggers (`triggers`)

- `trigger`: Use when the frontmatter description conditions are met.

- `procedure`: Follow the ordered steps in the workflow section.

### Edge Cases (`edge_cases`)

- `edge_case`: If required context is missing, gather or request it before continuing.

### Safety Constraints (`safety_constraints`)

- `constraint`: Avoid destructive operations without explicit user intent.

### Examples (`examples`)

- `example`: Activate this skill when the request matches its trigger conditions.

- `goal`: Provide reliable historical context by querying live git history with focused scripts.

## Core Principles (`core_principles`)

### Principle (`principle`)
Attributes: name="History as Evidence"

- `rule`: Use commit history and diffs to validate assumptions about system behavior changes.

- `rule`: Prefer concrete commit references over narrative guesses.

### Principle (`principle`)
Attributes: name="Query by Intent"

- `rule`: Use message mode for rationale/themes and diff mode for exact code pattern tracking.

- `rule`: Use file history when investigating regressions in a specific path.

### Principle (`principle`)
Attributes: name="Live Repository Source"

- `rule`: Queries run directly against the current git repo state, without separate indexing.

## Workflow (`workflow`)

### Step (`step`)
Attributes: number="1", name="Choose Target Repository"

- `instruction`: Set [PROJECT_PATH] to the repository root for all queries.

### Step (`step`)
Attributes: number="2", name="Select Query Mode"

- `command`: .\Agent\OpenAI\Skills\archive-git\scripts\search.ps1 -RepoPath "[PROJECT_PATH]" -Query "authentication" -Mode "message"

- `command`: .\Agent\OpenAI\Skills\archive-git\scripts\search.ps1 -RepoPath "[PROJECT_PATH]" -Query "JWT_SECRET" -Mode "diff"

### Step (`step`)
Attributes: number="3", name="Inspect File-Specific Evolution"

- `command`: .\Agent\OpenAI\Skills\archive-git\scripts\file-history.ps1 -RepoPath "[PROJECT_PATH]" -FilePath "src/auth/login.ts" -Limit 10

### Step (`step`)
Attributes: number="4", name="Review Recent Activity"

- `command`: .\Agent\OpenAI\Skills\archive-git\scripts\recent.ps1 -RepoPath "[PROJECT_PATH]" -Days 7

## Resources (`resources`)

- `script` (file="scripts/search.ps1"): Search commit history by message or diff content.

- `script` (file="scripts/file-history.ps1"): Track evolution of one file over time.

- `script` (file="scripts/recent.ps1"): Summarize recent repository activity.

## Best Practices (`best_practices`)

- `do`: Pair message and diff queries when root-cause confidence is low

- `do`: Capture commit hash and date in archived findings

- `do`: Scope queries to likely subsystems before broadening

- `dont`: Assume commit messages alone explain full behavioral impact

- `dont`: Ignore rename/move history when files changed paths

## Related Skills (`related_skills`)

- `skill`: archive-manager

- `skill`: archive-code

- `skill`: code-reviewer
```
