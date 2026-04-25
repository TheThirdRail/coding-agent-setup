# Legacy Lane: frontend-architect

Vendor: OpenAI Codex
Router: `architect`
Source archive: `.\Agent\OpenAI\deprecated-Skills\frontend-architect\SKILL.md`
Consolidated: 2026-04-25

The content below is the former installable skill or workflow body, preserved as an on-demand lane reference.

```markdown
---
name: frontend-architect
description: |
  Design scalable, accessible, and responsive frontend systems with clear
  component boundaries and state strategy. Use when planning UI architecture,
  implementing component systems, or improving accessibility and performance.
---
# Skill: frontend-architect
Attributes: name="frontend-architect", version="2.0.0"

## Metadata (`metadata`)

- `keywords`: frontend, ui, components, state-management, responsive, accessibility

## Spec Contract (`spec_contract`)

- `id`: frontend-architect

- `name`: frontend-architect

- `version`: 2.0.0

- `last_updated`: 2026-02-09

- `purpose`: Build maintainable frontend architecture that balances user experience, accessibility, and performance.

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

- `goal`: Build maintainable frontend architecture that balances user experience, accessibility, and performance.

## Core Principles (`core_principles`)

### Principle (`principle`)
Attributes: name="Composable Components"

- `rule`: Prefer small reusable components with explicit inputs and outputs.

- `rule`: Separate rendering concerns from data-fetching/business logic.

### Principle (`principle`)
Attributes: name="Right-Sized State"

- `rule`: Use local state first; promote to shared state only when multiple consumers require it.

- `rule`: Treat server state distinctly from UI state.

### Principle (`principle`)
Attributes: name="Accessibility by Default"

- `rule`: Keyboard navigation, semantic markup, and contrast checks are baseline requirements.

- `rule`: Use references/accessibility-patterns.md as implementation checklist.

## Workflow (`workflow`)

### Step (`step`)
Attributes: number="1", name="Clarify Product and UX Constraints"

- `question`: What user outcomes and device/browser targets are required?

- `question`: What design tokens or system constraints already exist?

### Step (`step`)
Attributes: number="2", name="Design Component and Data Boundaries"

- `instruction`: Map page-level features to reusable components and ownership boundaries.

- `output`: Component hierarchy and data-flow map

### Step (`step`)
Attributes: number="3", name="Select State and Fetching Strategy"

- `instruction`: Define local/shared/server state responsibilities and cache strategy.

- `check`: Minimal global state footprint

### Step (`step`)
Attributes: number="4", name="Implement Responsive and Accessible UI"

- `instruction`: Apply responsive layout system and accessibility checklist from references.

- `check`: Loading, empty, error, and focus states are defined

### Step (`step`)
Attributes: number="5", name="Validate and Harden"

- `instruction`: Run keyboard, screen reader, and performance checks before finalization.

- `tool`: axe DevTools

- `tool`: Browser Lighthouse/Performance panel

## Resources (`resources`)

- `reference` (file="references/accessibility-patterns.md"): WCAG-oriented checks and reusable accessibility patterns.

## Best Practices (`best_practices`)

- `do`: Favor semantic HTML and explicit labels for interactive elements

- `do`: Keep components focused and testable in isolation

- `do`: Define a consistent styling and token strategy early

- `do`: Plan for loading, empty, and error states up front

- `dont`: Over-centralize state without clear consumers

- `dont`: Ship features without keyboard and focus behavior validation

- `dont`: Hardcode breakpoints and tokens across components

## Related Skills (`related_skills`)

- `skill`: api-builder

- `skill`: test-generator

- `skill`: code-reviewer
```
