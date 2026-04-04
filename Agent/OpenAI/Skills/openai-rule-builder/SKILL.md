---
name: openai-rule-builder
description: |
  Create and maintain OpenAI Codex-compatible Starlark command rules in `default.rules`.
  Use when adding, revising, or auditing prefix-based command policies for safety,
  dependency environment enforcement, and network/destructive command prompting.
---
# Skill: openai-rule-builder
Attributes: name="openai-rule-builder", version="1.0.0"

## Metadata (`metadata`)

- `keywords`: rules, codex, starlark, prefix_rule, safety, openai

## Spec Contract (`spec_contract`)

- `id`: openai-rule-builder

- `name`: openai-rule-builder

- `version`: 1.0.0

- `last_updated`: 2026-02-09

- `purpose`: Produce valid OpenAI Codex Starlark command policy rules and keep them deterministic.

### Inputs (`inputs`)

- `input`: Rule intent, command patterns, decision level (allow/prompt/deny), and environment constraints.

### Outputs (`outputs`)

- `output`: Updated `Agent/OpenAI/default.rules` in valid Starlark syntax with ordered policy entries.

### Triggers (`triggers`)

- `trigger`: Use when Codex command policy must be created, corrected, or expanded.

- `procedure`: Classify command patterns, emit `prefix_rule(...)` entries, and verify deterministic ordering.

### Edge Cases (`edge_cases`)

- `edge_case`: If a command can be destructive, default decision should be `prompt` unless explicitly overridden.

### Safety Constraints (`safety_constraints`)

- `constraint`: Do not output XML or markdown as active `.rules` runtime policy syntax.

### Examples (`examples`)

- `example`: Add prompt policy for global package installs across Python, Node, Ruby, .NET, and Rust toolchains.

- `goal`: Maintain Codex-compatible Starlark rule files with clear allow/prompt/deny command policies.

## Core Principles (`core_principles`)

### Principle (`principle`)
Attributes: name="Starlark-Only Runtime Syntax"

- `rule`: Active OpenAI Codex command rules must use valid `prefix_rule(...)` Starlark syntax.

### Principle (`principle`)
Attributes: name="Least Privilege Defaults"

- `rule`: Unknown or risky commands default to `prompt` rather than `allow`.

### Principle (`principle`)
Attributes: name="Deterministic Ordering"

- `rule`: Group rules by policy domain and keep ordering stable to reduce diff noise.

### Principle (`principle`)
Attributes: name="Cross-Ecosystem Environment Safety"

- `rule`: Dependency management policies must cover multiple ecosystems, not Python only.

## Workflow (`workflow`)

### Step (`step`)
Attributes: number="1", name="Gather Policy Intent"

- `instruction`: Identify command families and desired decisions: allow, prompt, or deny.

### Step (`step`)
Attributes: number="2", name="Classify Risk Domains"

- `instruction`: Split into destructive operations, network operations, and dependency management operations.

### Step (`step`)
Attributes: number="3", name="Author Starlark Rules"

- `instruction`: Emit one `prefix_rule(pattern=[...], decision=\"...\")` per policy entry with explicit token arrays.

### Step (`step`)
Attributes: number="4", name="Normalize Ordering"

- `instruction`: Sort rules by domain and then by command pattern for deterministic output.

### Step (`step`)
Attributes: number="5", name="Write Canonical File"

- `instruction`: Update `Agent/OpenAI/default.rules` as the single active source file.

### Step (`step`)
Attributes: number="6", name="Verify Integration"

- `instruction`: Run OpenAI installer/validation scripts in dry-run mode to confirm target paths and policy sync.

## Best Practices (`best_practices`)

- `do`: Prefer `prompt` for commands with high blast radius.

- `do`: Keep comments concise and focused on policy intent.

- `do`: Explicitly cover global dependency installs across ecosystems.

- `dont`: Use legacy XML blocks as active `.rules` runtime content.

- `dont`: Create overlapping duplicate patterns with conflicting decisions.

## Related Skills (`related_skills`)

- `skill`: rule-builder

- `skill`: skill-builder

- `skill`: automation-builder
