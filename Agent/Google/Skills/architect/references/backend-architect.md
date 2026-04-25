# Legacy Lane: backend-architect

Vendor: Google Antigravity
Router: `architect`
Source archive: `.\Agent\Google\deprecated-Skills\backend-architect\SKILL.md`
Consolidated: 2026-04-25

The content below is the former installable skill or workflow body, preserved as an on-demand lane reference.

```markdown
---
name: backend-architect
description: |
  Design and build robust, scalable, and secure backend systems following language-agnostic best practices.
  Focuses on API design, database modeling, security (OWASP), and operational excellence.
  Use when designing backend services, reviewing backend architecture, or hardening API/data-layer design.
---

<skill name="backend-architect" version="2.0.0">
  <metadata>
    <keywords>backend, api, rest, graphql, database, security, microservices, architecture, owasp</keywords>
  </metadata>

  <goal>Design scalable, secure, and maintainable backend architecture adhering to modern, language-agnostic patterns.</goal>

  <core_principles>
    <principle name="API-First Design">
      <rule>Define interfaces (OpenAPI/GraphQL) BEFORE implementation.</rule>
      <rule>URI Design: Nouns for resources (`/users`), not verbs (`/createUser`).</rule>
      <rule>Versioning: Semantic versioning (`/v1/`) is mandatory.</rule>
      <rule>Standard Status Codes: Use 200, 201, 400, 401, 403, 404, 500 correctly.</rule>
    </principle>

    <principle name="Statelessness &amp; Scalability">
      <rule>Treat servers as cattle, not pets.</rule>
      <rule>No session state in application memory (use Redis/external stores).</rule>
      <rule>Any request must be handleable by any instance.</rule>
    </principle>

    <principle name="Data Integrity">
      <rule>Start normalized (3NF) to ensure integrity; denormalize only for proven bottlenecks.</rule>
      <rule>Enforce foreign keys at the database level.</rule>
      <rule>Avoid "God Tables" generic tables holding disparate data.</rule>
      <rule>Prevent N+1 queries via batching or eager loading.</rule>
    </principle>

    <principle name="Zero Trust Security">
      <rule>Never trust client input (Validate types/ranges on server).</rule>
      <rule>Sanitize outputs to prevent XSS.</rule>
      <rule>Use parameterized queries ALWAYS (SQL Injection prevention).</rule>
      <rule>Least Privilege: DB users have minimum necessary permissions.</rule>
      <rule>Secrets in environment variables, NEVER in code.</rule>
    </principle>
  </core_principles>



  <workflow>
    <step number="1" name="Define Interface (API-First)">
      <instruction>Create OpenAPI/Swagger or GraphQL schema</instruction>
      <question>What resources are being exposed?</question>
      <question>What are the inputs and outputs?</question>
      <question>Are status codes and error responses defined?</question>
    </step>

    <step number="2" name="Model Data">
      <instruction>Design database schema (ERD)</instruction>
      <check>Are relationships defined (1:1, 1:N, M:N)?</check>
      <check>Are foreign keys and constraints enforced?</check>
      <check>Are appropriate indexes planned for query patterns?</check>
    </step>

    <step number="3" name="Plan Logic &amp; Layers">
      <instruction>Separate concerns (Controller vs Service vs Repository)</instruction>
      <layer name="Controller">Parse request, validate input, send response (No business logic)</layer>
      <layer name="Service">Business rules, transaction management</layer>
      <layer name="Repository">Direct database access methods</layer>
    </step>

    <step number="4" name="Security Review">
      <check>Is authentication/authorization applied?</check>
      <check>Is input validation strict?</check>
      <check>Are secrets managed securely?</check>
    </step>

    <step number="5" name="Operational Planning">
      <check>Structured Logging (JSON) implemented?</check>
      <check>Health checks (`/health`, `/ready`) defined?</check>
      <check>Correlation IDs for request tracing?</check>
    </step>
  </workflow>

  <best_practices>
    <do>Define API contracts before writing implementation code</do>
    <do>Enforce schema constraints and foreign keys in the database</do>
    <do>Use parameterized queries and explicit input validation on every boundary</do>
    <do>Separate controller, service, and repository responsibilities</do>
    <do>Plan observability early with logs, health checks, and tracing IDs</do>
    <dont>Store secrets in source control</dont>
    <dont>Place business logic in controllers</dont>
    <dont>Rely on app-memory session state for horizontal scaling</dont>
  </best_practices>

  <anti_patterns>
    <pattern name="God Object/Table">
      <description>Single massive table or class handling unrelated responsibilities.</description>
    </pattern>
    <pattern name="N+1 Query Problem">
      <description>Executing a query for every item in a list instead of one batch query.</description>
    </pattern>
    <pattern name="Soft Deletes without Archiving">
      <description>Using `is_deleted` flags on high-volume tables destroys index performance over time. Move to archive tables instead.</description>
    </pattern>
    <pattern name="Logic in Controllers">
      <description>Putting business logic in API handlers makes it hard to test and reuse.</description>
    </pattern>
    <pattern name="Blocking I/O">
      <description>Performing synchronous file/network operations in the main thread.</description>
    </pattern>
  </anti_patterns>

  <related_skills>
    <skill>api-builder</skill>
    <skill>security-checker</skill>
    <skill>database-optimizer</skill>
    <skill>code-reviewer</skill>
  </related_skills>
</skill>
```
