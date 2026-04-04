---
name: backend-architect
description: |
  Design and build robust, scalable, and secure backend systems following language-agnostic best practices.
  Focuses on API design, database modeling, security (OWASP), and operational excellence.
  Use when designing backend services, reviewing backend architecture, or hardening API/data-layer design.
---
# Skill: backend-architect
Attributes: name="backend-architect", version="2.0.0"

## Metadata (`metadata`)

- `keywords`: backend, api, rest, graphql, database, security, microservices, architecture, owasp

## Spec Contract (`spec_contract`)

- `id`: backend-architect

- `name`: backend-architect

- `version`: 2.0.0

- `last_updated`: 2026-02-09

- `purpose`: Design scalable, secure, and maintainable backend architecture adhering to modern, language-agnostic patterns.

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

- `goal`: Design scalable, secure, and maintainable backend architecture adhering to modern, language-agnostic patterns.

## Core Principles (`core_principles`)

### Principle (`principle`)
Attributes: name="API-First Design"

- `rule`: Define interfaces (OpenAPI/GraphQL) BEFORE implementation.

- `rule`: URI Design: Nouns for resources (`/users`), not verbs (`/createUser`).

- `rule`: Versioning: Semantic versioning (`/v1/`) is mandatory.

- `rule`: Standard Status Codes: Use 200, 201, 400, 401, 403, 404, 500 correctly.

### Principle (`principle`)
Attributes: name="Statelessness & Scalability"

- `rule`: Treat servers as cattle, not pets.

- `rule`: No session state in application memory (use Redis/external stores).

- `rule`: Any request must be handleable by any instance.

### Principle (`principle`)
Attributes: name="Data Integrity"

- `rule`: Start normalized (3NF) to ensure integrity; denormalize only for proven bottlenecks.

- `rule`: Enforce foreign keys at the database level.

- `rule`: Avoid "God Tables" generic tables holding disparate data.

- `rule`: Prevent N+1 queries via batching or eager loading.

### Principle (`principle`)
Attributes: name="Zero Trust Security"

- `rule`: Never trust client input (Validate types/ranges on server).

- `rule`: Sanitize outputs to prevent XSS.

- `rule`: Use parameterized queries ALWAYS (SQL Injection prevention).

- `rule`: Least Privilege: DB users have minimum necessary permissions.

- `rule`: Secrets in environment variables, NEVER in code.

## Workflow (`workflow`)

### Step (`step`)
Attributes: number="1", name="Define Interface (API-First)"

- `instruction`: Create OpenAPI/Swagger or GraphQL schema

- `question`: What resources are being exposed?

- `question`: What are the inputs and outputs?

- `question`: Are status codes and error responses defined?

### Step (`step`)
Attributes: number="2", name="Model Data"

- `instruction`: Design database schema (ERD)

- `check`: Are relationships defined (1:1, 1:N, M:N)?

- `check`: Are foreign keys and constraints enforced?

- `check`: Are appropriate indexes planned for query patterns?

### Step (`step`)
Attributes: number="3", name="Plan Logic & Layers"

- `instruction`: Separate concerns (Controller vs Service vs Repository)

- `layer` (name="Controller"): Parse request, validate input, send response (No business logic)

- `layer` (name="Service"): Business rules, transaction management

- `layer` (name="Repository"): Direct database access methods

### Step (`step`)
Attributes: number="4", name="Security Review"

- `check`: Is authentication/authorization applied?

- `check`: Is input validation strict?

- `check`: Are secrets managed securely?

### Step (`step`)
Attributes: number="5", name="Operational Planning"

- `check`: Structured Logging (JSON) implemented?

- `check`: Health checks (`/health`, `/ready`) defined?

- `check`: Correlation IDs for request tracing?

## Best Practices (`best_practices`)

- `do`: Define API contracts before writing implementation code

- `do`: Enforce schema constraints and foreign keys in the database

- `do`: Use parameterized queries and explicit input validation on every boundary

- `do`: Separate controller, service, and repository responsibilities

- `do`: Plan observability early with logs, health checks, and tracing IDs

- `dont`: Store secrets in source control

- `dont`: Place business logic in controllers

- `dont`: Rely on app-memory session state for horizontal scaling

## Anti Patterns (`anti_patterns`)

### Pattern (`pattern`)
Attributes: name="God Object/Table"

- `description`: Single massive table or class handling unrelated responsibilities.

### Pattern (`pattern`)
Attributes: name="N+1 Query Problem"

- `description`: Executing a query for every item in a list instead of one batch query.

### Pattern (`pattern`)
Attributes: name="Soft Deletes without Archiving"

- `description`: Using `is_deleted` flags on high-volume tables destroys index performance over time. Move to archive tables instead.

### Pattern (`pattern`)
Attributes: name="Logic in Controllers"

- `description`: Putting business logic in API handlers makes it hard to test and reuse.

### Pattern (`pattern`)
Attributes: name="Blocking I/O"

- `description`: Performing synchronous file/network operations in the main thread.

## Related Skills (`related_skills`)

- `skill`: api-builder

- `skill`: security-checker

- `skill`: database-optimizer

- `skill`: code-reviewer
