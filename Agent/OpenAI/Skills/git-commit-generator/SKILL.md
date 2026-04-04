---
name: git-commit-generator
description: |
  Generate conventional commit messages from staged changes. Analyzes diffs to
  create semantic, descriptive commit messages following Conventional Commits
  specification. Use when committing code changes or preparing PR descriptions.
---
# Skill: git-commit-generator
Attributes: name="git-commit-generator", version="2.0.0"

## Metadata (`metadata`)

- `keywords`: git, commit, conventional-commits, changelog

## Spec Contract (`spec_contract`)

- `id`: git-commit-generator

- `name`: git-commit-generator

- `version`: 2.0.0

- `last_updated`: 2026-02-09

- `purpose`: Generate semantic, descriptive commit messages following Conventional Commits specification.

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

- `goal`: Generate semantic, descriptive commit messages following Conventional Commits specification.

## Core Principles (`core_principles`)

### Principle (`principle`)
Attributes: name="Format"

- `template`: &lt;type&gt;(&lt;scope&gt;): &lt;description&gt;

- `template`: [optional body]

- `template`: [optional footer(s)]

### Principle (`principle`)
Attributes: name="Types"

- `type` (name="feat", use="New feature for the user")

- `type` (name="fix", use="Bug fix for the user")

- `type` (name="docs", use="Documentation only changes")

- `type` (name="style", use="Formatting, missing semi-colons")

- `type` (name="refactor", use="Code change that neither fixes nor adds")

- `type` (name="perf", use="Performance improvement")

- `type` (name="test", use="Adding or correcting tests")

- `type` (name="build", use="Changes to build system")

- `type` (name="ci", use="Changes to CI configuration")

- `type` (name="chore", use="Other changes")

### Principle (`principle`)
Attributes: name="Good Messages"

- `rule`: Use imperative mood: "Add feature" not "Added feature"

- `rule`: Keep subject line under 50 characters

- `rule`: Capitalize the subject line

- `rule`: Don't end subject with a period

## Workflow (`workflow`)

### Step (`step`)
Attributes: number="1", name="Analyze Staged Changes"

- `command`: git diff --staged --stat

- `command`: git diff --staged

### Step (`step`)
Attributes: number="2", name="Determine Type"

- `decision` (condition="New feature visible to users"): feat

- `decision` (condition="Bug fix"): fix

- `decision` (condition="Documentation only"): docs

- `decision` (condition="Refactoring without behavior change"): refactor

- `decision` (condition="Performance improvement"): perf

- `decision` (condition="Test-related"): test

- `decision` (condition="Build/dependency related"): build

- `decision` (condition="CI/CD related"): ci

- `decision` (condition="Otherwise"): chore

### Step (`step`)
Attributes: number="3", name="Identify Scope"

- `instruction`: Use folder or module name (auth, api, ui, db, config)

### Step (`step`)
Attributes: number="4", name="Write Subject Line"

- `example`: feat(auth): add OAuth2 login support

- `example`: fix(api): handle null response from payment gateway

- `example`: docs(readme): update installation instructions

### Step (`step`)
Attributes: number="5", name="Add Body If Needed"

- `instruction`: For complex changes, explain What, Why, and How

### Step (`step`)
Attributes: number="6", name="Add Footer If Needed"

- `example`: BREAKING CHANGE: description

- `example`: Fixes #123

- `example`: Closes #456

## Examples (`examples`)

### Example (`example`)
Attributes: name="Simple Feature"

- `changes`: + src/components/Button.tsx (new file)

- `commit`: feat(ui): add reusable Button component

### Example (`example`)
Attributes: name="Bug Fix"

- `changes`: - return date.toLocalString() + return date.toLocaleString()

- `commit`: fix(utils): correct typo in date formatting function

### Example (`example`)
Attributes: name="Breaking Change"

- `changes`: - export function getUser(id: number) + export function getUser(id: string)

- `commit`:
```text
refactor(api)!: change user ID type from number to string

BREAKING CHANGE: All API calls to user endpoints now require
string IDs instead of numbers.

Fixes #892
```

## Best Practices (`best_practices`)

- `do`: Use present tense imperative ("add" not "added")

- `do`: Keep subject under 50 characters

- `do`: Separate subject from body with blank line

- `do`: Wrap body at 72 characters

- `do`: Include issue references in footer

- `do`: Use ! after type for breaking changes

- `dont`: End subject line with period

- `dont`: Use past tense

- `dont`: Write vague messages ("fix stuff")

- `dont`: Combine unrelated changes

## Resources (`resources`)

### Script (`script`)
Attributes: name="generate_commit.ps1", purpose="Automates commit message generation"

- `usage`: .\scripts\generate_commit.ps1

- `usage`: .\scripts\generate_commit.ps1 -Execute

- `description`: Analyzes staged changes, detects type/scope, generates conventional commit message

## Related Skills (`related_skills`)

- `skill`: code-reviewer

- `skill`: ci-cd-debugger
