---
name: ci-cd-debugger
description: |
  Debug failing CI/CD pipelines and GitHub Actions workflows. Analyzes build logs,
  identifies failure causes, and suggests fixes. Use when builds fail, tests break
  in CI, or deployments don't complete successfully.
---
# Skill: ci-cd-debugger
Attributes: name="ci-cd-debugger", version="2.0.0"

## Metadata (`metadata`)

- `keywords`: ci-cd, github-actions, pipeline, debugging, devops

## Spec Contract (`spec_contract`)

- `id`: ci-cd-debugger

- `name`: ci-cd-debugger

- `version`: 2.0.0

- `last_updated`: 2026-02-09

- `purpose`: Systematically diagnose and resolve CI/CD pipeline failures by identifying root causes from build logs.

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

- `goal`: Systematically diagnose and resolve CI/CD pipeline failures by identifying root causes from build logs.

## Core Principles (`core_principles`)

### Principle (`principle`)
Attributes: name="Failure Categories"

- `category` (name="Build", symptoms="Compilation fails", causes="Missing deps, syntax errors")

- `category` (name="Test", symptoms="Tests fail", causes="Code bugs, flaky tests, env issues")

- `category` (name="Lint", symptoms="Style checks fail", causes="Code style violations")

- `category` (name="Security", symptoms="Security scan fails", causes="Vulnerabilities detected")

- `category` (name="Deploy", symptoms="Deployment fails", causes="Config errors, permissions")

- `category` (name="Infra", symptoms="Runner issues", causes="Resource limits, network")

### Principle (`principle`)
Attributes: name="Debug Priority"

- `step`: Read the error message completely

- `step`: Find the FIRST failure (not cascading errors)

- `step`: Check if it works locally

- `step`: Review recent changes that could cause this

- `step`: Search for similar issues in project history

## Workflow (`workflow`)

### Step (`step`)
Attributes: number="1", name="Identify Job and Step"

- `question`: Which workflow failed?

- `question`: Which job within the workflow?

- `question`: Which step within the job?

- `question`: What is the exit code?

### Step (`step`)
Attributes: number="2", name="Read Error Message"

- `instruction`: Focus on the FIRST error, not cascading failures

### Step (`step`)
Attributes: number="3", name="Categorize Failure"

- `decision` (condition="Build failed"): Check dependencies and syntax

- `decision` (condition="Tests failed"): Check assertions, timeouts, mocks

- `decision` (condition="Lint failed"): Check formatting rules

- `decision` (condition="Deploy failed"): Check connections and permissions

### Step (`step`)
Attributes: number="4", name="Compare with Previous"

- `command`: git log --oneline &lt;last-passing-sha&gt;..HEAD

- `command`: git diff --stat &lt;last-passing-sha&gt;..HEAD

### Step (`step`)
Attributes: number="5", name="Check Environment Differences"

- `check`: Node version (.nvmrc or workflow)

- `check`: Package manager version (lock file)

- `check`: OS (runs-on)

- `check`: Environment variables (secrets)

## Common Fixes (`common_fixes`)

- `fix` (issue="Module not found", solution="Use npm ci instead of npm install")

- `fix` (issue="Cache issues", solution="Bump cache key version")

- `fix` (issue="Flaky tests", solution="Use waitFor instead of setTimeout")

- `fix` (issue="Permission denied", solution="Check permissions block, add chmod")

- `fix` (issue="Out of memory", solution="Set NODE_OPTIONS=--max-old-space-size=4096")

- `fix` (issue="Timeout", solution="Increase timeout-minutes or optimize")

- `fix` (issue="Secret not available", solution="Pass secret explicitly in env block")

## Debug Commands (`debug_commands`)

- `command` (purpose="View workflow runs"): gh run list --workflow=ci.yml

- `command` (purpose="View failed logs"): gh run view &lt;run-id&gt; --log-failed

- `command` (purpose="Re-run failed jobs"): gh run rerun &lt;run-id&gt; --failed

- `command` (purpose="Run locally"): act -j test

## Best Practices (`best_practices`)

- `do`: Read the complete error message before acting

- `do`: Find the first failure, not cascading errors

- `do`: Reproduce locally before debugging CI

- `do`: Use npm ci not npm install

- `do`: Pin action versions (@v4 not @main)

- `do`: Cache dependencies for faster builds

- `dont`: Re-run without understanding the failure

- `dont`: Commit fixes without local testing

- `dont`: Ignore flaky tests

- `dont`: Expose secrets in logs

- `dont`: Use continue-on-error to hide failures

## Related Skills (`related_skills`)

- `skill`: git-commit-generator

- `skill`: test-generator

- `skill`: docker-ops
