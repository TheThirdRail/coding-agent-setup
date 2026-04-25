# Legacy Lane: api-builder

Vendor: Google Antigravity
Router: `architect`
Source archive: `.\Agent\Google\deprecated-Skills\api-builder\SKILL.md`
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

<skill name="api-builder" version="2.0.0">
  <metadata>
    <keywords>api, rest, graphql, openapi, endpoints, swagger</keywords>
  </metadata>

  <goal>Design well-structured, secure, and documented APIs following REST conventions or GraphQL best practices.</goal>

  <core_principles>
    <principle name="REST Conventions">
      <method name="GET" purpose="Read resource" idempotent="true" safe="true"/>
      <method name="POST" purpose="Create resource" idempotent="false" safe="false"/>
      <method name="PUT" purpose="Replace resource" idempotent="true" safe="false"/>
      <method name="PATCH" purpose="Update resource" idempotent="false" safe="false"/>
      <method name="DELETE" purpose="Remove resource" idempotent="true" safe="false"/>
    </principle>

    <principle name="URL Design">
      <good>GET /users, GET /users/123, POST /users, PUT /users/123, DELETE /users/123</good>
      <bad>GET /getUsers, POST /createUser, GET /user/delete/123</bad>
    </principle>

    <principle name="HTTP Status Codes">
      <code value="200" meaning="OK" use="Successful GET, PUT, PATCH"/>
      <code value="201" meaning="Created" use="Successful POST"/>
      <code value="204" meaning="No Content" use="Successful DELETE"/>
      <code value="400" meaning="Bad Request" use="Invalid input"/>
      <code value="401" meaning="Unauthorized" use="Missing auth"/>
      <code value="403" meaning="Forbidden" use="No permission"/>
      <code value="404" meaning="Not Found" use="Resource missing"/>
      <code value="422" meaning="Unprocessable" use="Validation failed"/>
      <code value="500" meaning="Server Error" use="Unexpected error"/>
    </principle>
  </core_principles>



  <workflow>
    <step number="1" name="Define Resources">
      <question>What entities does this API manage?</question>
      <question>What are the relationships between them?</question>
      <question>What actions can be performed on each?</question>
    </step>

    <step number="2" name="Design Endpoints">
      <instruction>For each resource, define CRUD endpoints following REST conventions</instruction>
    </step>

    <step number="3" name="Define Schemas">
      <instruction>Create TypeScript interfaces or JSON Schema for request/response bodies</instruction>
    </step>

    <step number="4" name="Add Validation">
      <instruction>Use Zod, Yup, or similar for input validation</instruction>
    </step>

    <step number="5" name="Add Authentication">
      <instruction>Implement JWT or OAuth2 middleware for protected routes</instruction>
    </step>

    <step number="6" name="Generate Documentation">
      <instruction>Create OpenAPI 3.0 specification</instruction>
    </step>
  </workflow>

  <patterns>
    <pattern name="Pagination">
      <request>GET /users?limit=20&amp;offset=40</request>
      <response>{"data": [...], "pagination": {"total": 150, "limit": 20, "offset": 40, "hasMore": true}}</response>
    </pattern>

    <pattern name="Error Response">
      <format>{"error": {"code": "VALIDATION_ERROR", "message": "Invalid request", "details": {...}}}</format>
    </pattern>

    <pattern name="Versioning">
      <recommended>/v1/users (URL path versioning)</recommended>
    </pattern>
  </patterns>

  <best_practices>
    <do>Use nouns for resources (/users not /getUsers)</do>
    <do>Use plural nouns (/users not /user)</do>
    <do>Return consistent response shapes</do>
    <do>Include pagination for list endpoints</do>
    <do>Validate all input</do>
    <do>Document with OpenAPI</do>
    <dont>Put verbs in URLs</dont>
    <dont>Return 200 for errors</dont>
    <dont>Skip input validation</dont>
    <dont>Expose internal errors</dont>
  </best_practices>

  <resources>
    <asset name="openapi-template.yaml" purpose="Starter OpenAPI 3.0 template">
      <location>assets/openapi-template.yaml</location>
      <description>Complete template with CRUD endpoints, auth schemes, error responses, and pagination</description>
    </asset>
  </resources>

  <related_skills>
    <skill>test-generator</skill>
    <skill>code-reviewer</skill>
    <skill>architecture-planner</skill>
  </related_skills>
</skill>
```
