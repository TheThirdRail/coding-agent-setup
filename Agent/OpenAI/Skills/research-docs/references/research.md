# Legacy Lane: research

Vendor: OpenAI Codex
Router: `research-docs`
Source archive: `.\Agent\OpenAI\deprecated-Skills\research\SKILL.md`
Consolidated: 2026-04-25

The content below is the former installable skill or workflow body, preserved as an on-demand lane reference.

```markdown
---
name: research
description: |
  Perform validated technical research using documentation, repositories, and
  recent sources. Use when researching best practices for a tech stack, finding
  current solutions to technical problems, or comparing frameworks, libraries,
  or approaches.
---
# Skill: research
Attributes: name="research", version="2.2.0"

## Metadata (`metadata`)

- `keywords`: workflow, orchestration, research, search, documentation, context7, web-search, examples, best-practices

- `source_workflow`: research.md

## Spec Contract (`spec_contract`)

- `id`: research

- `name`: research

- `version`: 2.2.0

- `last_updated`: 2026-02-09

- `purpose`: Gather accurate, current information and code examples from multiple sources, then synthesize them into a concrete recommendation.

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

- `goal`: Gather accurate, current information and code examples from multiple sources, then synthesize them into a concrete recommendation.

## Core Principles (`core_principles`)

### Principle (`principle`)
Attributes: name="Orchestrate First"

- `rule`: Act as the single Codex research skill: sequence the work, choose the right sources, and keep task focus.

### Principle (`principle`)
Attributes: name="Deterministic Flow"

- `rule`: Follow the ordered step flow from the source workflow unless constraints require adaptation.

### Principle (`principle`)
Attributes: name="Validation Before Completion"

- `rule`: Require verification checks before marking the workflow complete.

### Principle (`principle`)
Attributes: name="Source Constraints"

- `rule`: DO NOT write implementation code

- `rule`: DO NOT edit source files

- `rule`: Focus ONLY on information gathering and synthesis

### Principle (`principle`)
Attributes: name="Source Hierarchy"

- `priority` (order="1"): Official documentation and primary sources

- `priority` (order="2"): Framework and library guides with current version coverage

- `priority` (order="3"): GitHub repositories and real-world code examples

- `priority` (order="4"): Recent community discussions and technical blog posts

### Principle (`principle`)
Attributes: name="Recency Matters"

- `rule`: Note the date of every source.

- `rule`: Flag outdated information explicitly.

- `rule`: Prefer current versions and recent maintenance signals.

### Principle (`principle`)
Attributes: name="Lifecycle Awareness"

- `rule`: Verify whether the library, tool, or service is still active and supported.

- `rule`: If official docs are stale, compare them with newer credible sources and call out the discrepancy.

### Principle (`principle`)
Attributes: name="Synthesize, Do Not Dump"

- `rule`: Cross-check claims with multiple sources when the topic is important or unstable.

- `rule`: Return a recommendation, not just a list of links.

## Preferred MCP (`preferred_mcp`)

- `server`: context7

- `server`: gitmcp

- `server`: augments

- `server`: github

- `server`: fetch

- `reason`: Prefer current docs, repo context, framework references, code examples, and direct URL reading.

## Tool Usage (`tool_usage`)

### Category (`category`)
Attributes: name="Documentation and API"

#### Tool (`tool`)
Attributes: name="context7"

- `purpose`: Get current library and framework documentation.

- `use_when`: Need API signatures, official examples, or version-specific behavior.

#### Tool (`tool`)
Attributes: name="gitmcp"

- `purpose`: Read GitHub repositories and docs in an LLM-friendly format.

- `use_when`: Need to inspect real repo structure, implementation details, or README guidance.

#### Tool (`tool`)
Attributes: name="augments"

- `purpose`: Access broad framework documentation sources.

- `use_when`: Need wider framework coverage than a single official docs source.

### Category (`category`)
Attributes: name="Code Examples and Verification"

#### Tool (`tool`)
Attributes: name="github"

- `purpose`: Find real-world implementations, example repos, and issue context.

- `use_when`: Need code patterns that appear in maintained projects.

#### Tool (`tool`)
Attributes: name="fetch"

- `purpose`: Read a specific page in full once it has been identified as relevant.

- `use_when`: Need the detailed contents of a specific guide, reference, or announcement.

## Workflow (`workflow`)

### Step (`step`)
Attributes: number="1", name="Clarify the Research Topic"

- `instruction`: What specific topic to research? What decisions need to be made? Any constraints (free only, specific language, etc.)?

### Step (`step`)
Attributes: number="2", name="Verify Product Lifecycle & Status"

- `instruction`: Search for "[Topic] release history [Current Year]" and "[Topic] status" Identify the "Newest Official Source" and "Newest Credible Third-Party Source" Compare dates: If Official is significantly older than Credible, investigate discrepa...

### Step (`step`)
Attributes: number="3", name="Use ALL Search Tools"

- `instruction`: Choose tools deliberately: official docs first, then repo context, then example code, then broader web sources if needed.

### Step (`step`)
Attributes: number="4", name="Use Context MCPs for Code Research"

- `instruction`: Prefer `context7` for API docs, `gitmcp` for repo reading, `augments` for framework coverage, `github` for real-world examples, and `fetch` for deep reading.

### Step (`step`)
Attributes: number="5", name="Prioritize Recent Sources"

- `instruction`: Prefer recent sources, note the date of each source, and explicitly flag stale or conflicting guidance.

### Step (`step`)
Attributes: number="6", name="Research Areas to Cover"

- `instruction`: Current best practices, popular libraries, performance, security, community support Common solutions, edge cases, real-world examples

### Step (`step`)
Attributes: number="7", name="Cross-Verify Findings"

- `instruction`: Use at least two strong sources for important claims, verify lifecycle status, and look for anti-patterns or migration caveats.

### Step (`step`)
Attributes: number="8", name="Document Findings"

- `instruction`: # [Topic] Research **Date:** [Today's date] **Purpose:** [Why this research was needed] ## Executive Summary [2-3 sentence summary] ## Key Findings ### Best Practices (2024-2025) - [Finding 1] — Source: [URL] ### Recommended Approach [Yo...

### Step (`step`)
Attributes: number="9", name="Synthesize and Recommend"

- `instruction`: Don't just list findings — synthesize them Provide a clear recommendation Explain WHY you recommend it Note any trade-offs

## Best Practices (`best_practices`)

- `do`: Summarize progress after each major phase when the task is long-running.

- `do`: Start with primary sources before blogs and community posts.

- `do`: Check the date and lifecycle status of tools and libraries.

- `do`: Link sources for traceability.

- `do`: Synthesize rather than dumping raw results.

- `dont`: Skip validation or testing steps when the workflow defines them.

- `dont`: Expand scope beyond the workflow objective without explicit user direction.

- `dont`: Spend excessive time on tangential research.

## Related Skills (`related_skills`)

- `skill`: architecture-planner

- `skill`: code-reviewer

- `skill`: api-builder
```
