# Runtime Observability

Use this lane when implementing or reviewing runtime behavior, API errors, logs, or release readiness.

## Guidelines

- Do not swallow exceptions silently.
- Return actionable error information with stable, sanitized user-facing messages.
- Avoid exposing stack traces, implementation internals, credentials, or secrets in user-facing output.
- When prerequisites are missing, name the missing dependency and the shortest safe recovery path.
- Use structured logs only when the project already supports them.
- Include stable request or correlation identifiers when the runtime surface supports them.
- Use explicit severity levels for logs when the runtime supports them.
- Keep logs useful for diagnosis without leaking sensitive data.
