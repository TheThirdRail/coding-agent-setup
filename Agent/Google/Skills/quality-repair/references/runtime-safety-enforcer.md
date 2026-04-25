# Legacy Lane: runtime-safety-enforcer

Vendor: Google Antigravity
Router: `quality-repair`
Source archive: `.\Agent\Google\deprecated-Skills\runtime-safety-enforcer\SKILL.md`
Consolidated: 2026-04-25

The content below is the former installable skill or workflow body, preserved as an on-demand lane reference.

```markdown
---
name: runtime-safety-enforcer
description: |
  Enforce dependency-environment isolation, API error contract safety, and structured logging policy.
  Use when implementing or reviewing runtime behavior and release readiness.
---

<skill name="runtime-safety-enforcer" version="1.0.0">
  <metadata>
    <keywords>dependency-management, error-contract, logging, correlation-id, safety</keywords>
  </metadata>

  <goal>Guarantee runtime safety standards for dependency isolation, errors, and observability.</goal>

  <core_principles>
    <principle name="Dependency Isolation">
      <rule>Use project-scoped dependency environments for every ecosystem with a dependency manager.</rule>
      <rule>Avoid global installs for project dependencies unless explicitly requested by the user.</rule>
      <rule>Use lockfiles or equivalent deterministic manifests where available.</rule>
    </principle>
    <principle name="Stable Error Contract">
      <rule>Use stable error response envelopes with machine code, safe message, details, and correlation_id.</rule>
      <rule>Do not expose stack traces or internal implementation details in user-facing responses.</rule>
    </principle>
    <principle name="Safe Structured Logging">
      <rule>Use structured logging with timestamp, level, message, correlation_id, and context.</rule>
      <rule>Never log credentials, secrets, tokens, or sensitive personal data.</rule>
    </principle>
  </core_principles>

  <dependency_environment_policy>
    <ecosystem name="Python">
      <rule>Use local virtual environments (`.venv`, `venv`, `uv`, or `poetry`).</rule>
    </ecosystem>
    <ecosystem name="Node.js">
      <rule>Use local package installs and lockfiles (`package-lock.json`, `pnpm-lock.yaml`, or `yarn.lock`).</rule>
    </ecosystem>
    <ecosystem name="Ruby">
      <rule>Use Bundler with project `Gemfile` and `Gemfile.lock`.</rule>
    </ecosystem>
    <ecosystem name="Java">
      <rule>Use project wrappers and build manifests (`mvnw`/`gradlew`).</rule>
    </ecosystem>
    <ecosystem name=".NET">
      <rule>Use project restore and local tool manifests for project tooling.</rule>
    </ecosystem>
    <ecosystem name="Other">
      <rule>Use project-scoped managers and pinned versions where supported.</rule>
    </ecosystem>
  </dependency_environment_policy>

  <workflow>
    <step number="1" name="Dependency Environment Check">
      <instruction>Validate project-scoped dependency installation and lock/pin usage.</instruction>
    </step>
    <step number="2" name="Error Contract Check">
      <instruction>Validate response envelope shape, safe messaging, and status mapping.</instruction>
    </step>
    <step number="3" name="Logging Safety Check">
      <instruction>Validate structured fields, correlation propagation, and secret redaction.</instruction>
    </step>
    <step number="4" name="Return Compliance Report">
      <instruction>Return pass/fail by domain with remediation steps.</instruction>
    </step>
  </workflow>

  <best_practices>
    <do>Fail closed with actionable remediation instructions.</do>
    <do>Apply runtime safety checks before deployment workflows.</do>
    <dont>Permit global dependency installs as default behavior.</dont>
  </best_practices>

  <related_skills>
    <skill>backend-architect</skill>
    <skill>security-checker</skill>
  </related_skills>

  <related_workflows>
    <workflow>/security-audit</workflow>
    <workflow>/deploy</workflow>
    <workflow>/dependency-check</workflow>
  </related_workflows>
</skill>
```
