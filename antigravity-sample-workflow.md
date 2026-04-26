# Antigravity Sample Workflow Guide

## Rules Outline (Read This First)

This section summarizes the rule system that drives Google Antigravity behavior in this repository.

### 1) Core Global Rule

Source: `Agent/Google/Rules/GEMINI.md`

Key expectations:

- define user intent before implementation
- act with autonomy unless requirements are ambiguous
- read before editing
- keep secure defaults
- return actionable failures
- keep code clean while you work

### 2) Routing Rule

Source: `Agent/Google/Workflows/task-router.md`

If intent is clear, route to the best slash command. Examples:

- planning -> `/architect`
- implementation -> `/code`
- debugging -> `/quality-repair`
- security -> `/quality-repair`
- testing -> `/code`

### 3) Quality Gate Rule

Source: `Agent/Google/Rules/GEMINI.md`

Before completion or merge:

- tests must exist and pass for new logic
- docs must be updated for behavior changes
- large files/functions may require refactor before continuing

### 4) Context Governance Rule

Source: `Agent/Google/Rules/GEMINI.md`

Agent context files should be organized consistently and archive actions should be intentional.

### 5) Archive Tools Rule

Source: `Agent/Google/Skills/archive-manager`

Use archive tools for durable memory and research:

- semantic docs archive
- git history archive
- code graph archive
- structured memory archive

## Example 1: Start a New Feature

Goal: go from idea to implementation with clean checkpoints.

What to type:

```text
/architect I want to add a beginner setup wizard for this repo.
```

What happens:

1. Requirements are clarified.
2. Scope is planned.
3. You get a checklist and architecture direction.

Next command:

```text
/project-setup Initialize folders and docs from the approved plan.
```

Then:

```text
/code Implement checklist items 1-3.
```

## Example 2: Debug Something Broken

What to type:

```text
/quality-repair The install script says source folder not found when I run it.
```

What happens:

- the issue is reproduced
- likely causes are ranked
- next fix step is suggested

Then:

```text
/quality-repair Apply a minimal patch with verification.
```

## Example 3: Quality + Security Check Before Merge

Run these in order:

```text
/quality-repair Review changed files and list severity-ranked findings.
/quality-repair Scan for secrets, unsafe patterns, and dependency risks.
/code Add missing tests for changed behavior.
/code Prepare pull request summary with verification evidence.
```

What you get:

- prioritized fixes
- confidence that changes are safe
- cleaner pull request

## Example 4: Use Skills Directly

You can call specific skills when needed.

### Research capability

```text
Use research-capability to compare two MCP server options for documentation search.
```

### Documentation generator

```text
Use documentation-generator to rewrite setup instructions for non-technical users.
```

### Security checker

```text
Use security-checker on this branch and list concrete remediation actions.
```

### Archive manager

```text
Use archive-manager to retrieve past decisions about setup scripts and README tone.
```

## Example 5: Daily Work Routine

Morning:

```text
/project-continuity Summarize branch state and top priorities.
```

During work:

```text
/code Implement current checklist tasks with minimal context switching.
```

End of day:

```text
/project-continuity Write completed work, blockers, and first next step for tomorrow.
```

## Automation Guidance (Manual Scheduling)

This repo does not currently ship dedicated Google automation template files.

For a simple manual automation routine, schedule recurring reminders and paste these prompts:

### Daily 9:00

```text
/project-continuity Summarize branch status, tests, and top 3 priorities.
```

### Weekly Monday 8:00

```text
/quality-repair Run a full security and dependency risk review.
```

### Weekly Friday 8:30

```text
/quality-repair Rank updates by risk and impact.
```

### Weekdays 17:45

```text
/project-continuity Generate an end-of-day transition note.
```

## Quick Prompt Library

```text
/architect Help me plan this feature with acceptance criteria.
/code Implement only checklist item 2 and update tests.
/quality-repair Find root cause and show proof before fixing.
/quality-repair Prioritize issues and include file references.
/quality-repair Return a remediation list ordered by severity.
```
