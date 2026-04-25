# Documentation Templates

## README Template

```md
# Project Name

Brief description of what this project does and why it exists.

## Prerequisites
- Runtime and version requirements
- Required services/datastores

## Installation
```bash
git clone [repo-url]
cd [project-name]
[install-command]
```

## Configuration
- Required environment variables
- Optional toggles and defaults

## Usage
```bash
[start-command]
```

## Testing
```bash
[test-command]
```
```

## ADR Template

```md
# ADR-NNN: [Decision Title]

## Status
Proposed | Accepted | Deprecated | Superseded

## Context
What constraints or issues motivate this decision?

## Decision
What was chosen and why?

## Consequences
### Positive
- ...
### Negative
- ...
### Neutral
- ...
```

## API Endpoint Template

```md
## Endpoint Name

`METHOD /path`

Description of endpoint behavior and side effects.

### Request
Headers, params, and body schema.

### Response
Success payload and error payloads.

### Notes
Auth requirements, rate limits, idempotency, and caveats.
```

## Changelog Template

```md
# Changelog

## [Unreleased]
### Added
- ...
### Changed
- ...
### Fixed
- ...
### Security
- ...

## [X.Y.Z] - YYYY-MM-DD
### Added
- ...
```
