# Codex Sample Workflow Guide

## Rules Outline (Read This First)

This section explains the important rules that shape how Codex behaves in this project.

### 1) Core Behavior Rules

Source: `Agent/OpenAI/AGENTS.md`

- Think first, then implement.
- Make decisions independently unless ambiguity changes outcomes.
- Read files before editing.
- Keep code secure by default.
- Use explicit error handling.
- Keep functions focused and avoid unnecessary complexity.
- Update docs when behavior changes.

### 2) Command Safety Rules

Source: `Agent/OpenAI/default.rules`

Some commands should pause for confirmation. Examples:

- destructive commands like `git reset --hard`, recursive deletes, and forceful cleanup
- network fetch commands like `curl` and `wget`
- global dependency installs

Some local development commands are allowed directly. Example:

- local Python execution and local venv setup

### 3) Workflow Routing Rules

Source: `Agent/OpenAI/AGENTS.md` and `Agent/OpenAI/Skills/*`

Codex maps common intents to orchestration skills. Examples:

- planning -> `architect`
- implementation -> `code`
- debugging -> `quality-repair`
- security scan -> `quality-repair`
- pull request prep -> `code`

### 4) Archive and Context Rules

Source: OpenAI archive skills under `Agent/OpenAI/Skills/archive-manager`

Use archive tools when you need durable project memory:

- `archive-manager` for decisions and notes
- `archive-manager` for semantic document search
- `archive-manager` for code structure
- `archive-manager` for historical changes
- `archive-manager` for fast code search

Archive data lives under `Agent-Context/` and should stay local-only.

## Example 1: Start Your Day With Context

Goal: quickly understand what happened and what to do next.

What to type:

```text
Run wf-morning for this repository. Summarize branch status, dependency health, tests, and top 3 priorities for today.
```

What happens:

1. Codex checks current branch and pending changes.
2. Codex summarizes test/dependency status.
3. You get a short action list for today.

## Example 2: Build a Feature From Idea to Code

### Step A: Plan

What to type:

```text
Use architect. I want to add a beginner onboarding screen that explains setup in plain language.
```

Expected output:

- scope definition
- architecture notes
- implementation checklist

### Step B: Implement

What to type:

```text
Use code to implement the approved checklist for the onboarding screen.
```

Expected output:

- code changes
- tests or verification steps
- concise progress summary

### Step C: Review

What to type:

```text
Use quality-repair to review the files changed for onboarding and list prioritized findings.
```

Expected output:

- critical/high/medium/low findings
- concrete fixes

## Example 3: Fix a Bug Safely

What to type:

```text
Use quality-repair to analyze this bug: setup script says source folder not found.
```

Then:

```text
Use quality-repair to fix this issue in surgical mode and patch only the minimum required files.
```

What happens:

- problem is reproduced
- root cause is identified
- minimal fix is applied
- verification is run

## Example 4: Security + Dependency Maintenance

What to type:

```text
Use quality-repair for a security audit and include dependency audit results.
```

Then:

```text
Use quality-repair for a dependency check and rank updates by risk and impact.
```

What happens:

- vulnerabilities are prioritized
- you get a safe update order

## Example 5: Archive a Decision So You Do Not Forget It

What to type:

```text
Use archive-manager and save this decision in category decisions, key readme-tone: README should stay beginner-friendly with copy/paste commands.
```

What happens:

- decision is saved locally
- future sessions can retrieve it quickly

## Example 6: Ask for Codebase Context Fast

What to type:

```text
Use archive-manager to find where README setup commands are defined in scripts and show me the source files.
```

What happens:

- router chooses archive-code, archive-graph, or archive-git as needed
- you get paths and references instead of guessing

## Automation Examples (Codex)

Templates live in `Agent/OpenAI/Automations/`.

### Morning automation

- file: `wf-morning.automation.md`
- schedule: weekdays 09:00 local
- purpose: daily status and priorities

### Security automation

- file: `wf-security-audit.automation.md`
- schedule: weekly Monday 08:00 local
- purpose: regular risk scan

### Dependency automation

- file: `wf-dependency-check.automation.md`
- schedule: weekly Friday 08:30 local
- purpose: update planning

### Handoff automation

- file: `wf-handoff-reminder.automation.md`
- schedule: weekdays 17:45 local
- purpose: end-of-day transition note

## Suggested Weekly Routine

1. Monday: run `quality-repair` for security audit.
2. Midweek: run `quality-repair` on active feature branch.
3. Friday: run `quality-repair` for dependency check.
4. Daily closeout: run `project-continuity` for handoff.

## Quick Prompt Library

Use these directly:

```text
Use architect to plan this idea and return a checklist.
Use code to implement checklist items 1 through 3.
Use quality-repair to review and prioritize findings by severity.
Use quality-repair for a security audit and include actionable fixes.
Use archive-manager to pull relevant historical context before coding.
```
