# Legacy Lane: api-builder

Vendor: OpenAI Codex
Router: `architect`
Source archive: `.\Agent\OpenAI\deprecated-Skills\api-builder\SKILL.md`
Consolidated: 2026-04-25

The content below is the former installable skill or workflow body, preserved as an on-demand lane reference.

```markdown
---
name: api-builder
description: |
  Design and build RESTful and GraphQL APIs with proper structure, validation,
  authentication, and documentation. Generates OpenAPI specs, endpoint handlers,
  and middleware. Use when creating new APIs or refactoring existing endpoints.
---
# Skill: api-builder
Attributes: name="api-builder", version="2.0.0"

## Metadata (`metadata`)

- `keywords`: api, rest, graphql, openapi, endpoints, swagger

## Spec Contract (`spec_contract`)

- `id`: api-builder

- `name`: api-builder

- `version`: 2.0.0

- `last_updated`: 2026-02-09

- `purpose`: Design well-structured, secure, and documented APIs following REST conventions or GraphQL best practices.

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

- `goal`: Design well-structured, secure, and documented APIs following REST conventions or GraphQL best practices.

## Core Principles (`core_principles`)

### Principle (`principle`)
Attributes: name="REST Conventions"

- `method` (name="GET", purpose="Read resource", idempotent="true", safe="true")

- `method` (name="POST", purpose="Create resource", idempotent="false", safe="false")

- `method` (name="PUT", purpose="Replace resource", idempotent="true", safe="false")

- `method` (name="PATCH", purpose="Update resource", idempotent="false", safe="false")

- `method` (name="DELETE", purpose="Remove resource", idempotent="true", safe="false")

### Principle (`principle`)
Attributes: name="URL Design"

- `good`: GET /users, GET /users/123, POST /users, PUT /users/123, DELETE /users/123

- `bad`: GET /getUsers, POST /createUser, GET /user/delete/123

### Principle (`principle`)
Attributes: name="HTTP Status Codes"

- `code` (value="200", meaning="OK", use="Successful GET, PUT, PATCH")

- `code` (value="201", meaning="Created", use="Successful POST")

- `code` (value="204", meaning="No Content", use="Successful DELETE")

- `code` (value="400", meaning="Bad Request", use="Invalid input")

- `code` (value="401", meaning="Unauthorized", use="Missing auth")

- `code` (value="403", meaning="Forbidden", use="No permission")

- `code` (value="404", meaning="Not Found", use="Resource missing")

- `code` (value="422", meaning="Unprocessable", use="Validation failed")

- `code` (value="500", meaning="Server Error", use="Unexpected error")

## Workflow (`workflow`)

### Step (`step`)
Attributes: number="1", name="Define Resources"

- `question`: What entities does this API manage?

- `question`: What are the relationships between them?

- `question`: What actions can be performed on each?

### Step (`step`)
Attributes: number="2", name="Design Endpoints"

- `instruction`: For each resource, define CRUD endpoints following REST conventions

### Step (`step`)
Attributes: number="3", name="Define Schemas"

- `instruction`: Create TypeScript interfaces or JSON Schema for request/response bodies

### Step (`step`)
Attributes: number="4", name="Add Validation"

- `instruction`: Use Zod, Yup, or similar for input validation

### Step (`step`)
Attributes: number="5", name="Add Authentication"

- `instruction`: Implement JWT or OAuth2 middleware for protected routes

### Step (`step`)
Attributes: number="6", name="Generate Documentation"

- `instruction`: Create OpenAPI 3.0 specification

## Patterns (`patterns`)

### Pattern (`pattern`)
Attributes: name="Pagination"

- `request`: GET /users?limit=20&offset=40

- `response`: {"data": [...], "pagination": {"total": 150, "limit": 20, "offset": 40, "hasMore": true}}

### Pattern (`pattern`)
Attributes: name="Error Response"

- `format`: {"error": {"code": "VALIDATION_ERROR", "message": "Invalid request", "details": {...}}}

### Pattern (`pattern`)
Attributes: name="Versioning"

- `recommended`: /v1/users (URL path versioning)

## Best Practices (`best_practices`)

- `do`: Use nouns for resources (/users not /getUsers)

- `do`: Use plural nouns (/users not /user)

- `do`: Return consistent response shapes

- `do`: Include pagination for list endpoints

- `do`: Validate all input

- `do`: Document with OpenAPI

- `dont`: Put verbs in URLs

- `dont`: Return 200 for errors

- `dont`: Skip input validation

- `dont`: Expose internal errors

## Resources (`resources`)

### Asset (`asset`)
Attributes: name="openapi-template.yaml", purpose="Starter OpenAPI 3.0 template"

- `location`: assets/openapi-template.yaml

- `description`: Complete template with CRUD endpoints, auth schemes, error responses, and pagination

## Related Skills (`related_skills`)

- `skill`: test-generator

- `skill`: code-reviewer

- `skill`: architecture-planner
```
