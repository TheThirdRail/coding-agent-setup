# Security And Sensitive Data

Use this lane for security-sensitive implementation, review, setup, and release work.

## Guidelines

- Never expose secrets, credentials, tokens, keys, private environment values, or sensitive personal data.
- Do not commit or archive credentials or secrets.
- Sanitize user-facing errors and avoid exposing stack traces or internal implementation details.
- Avoid logging credentials, tokens, secrets, private URLs, or sensitive user data.
- Treat authentication, authorization, permissions, payments, privacy, and data handling as high-risk surfaces.
- Ask before making changes that alter auth, permissions, secrets handling, privacy behavior, payment flow, production data access, or security posture.
- Prefer secure defaults, explicit validation, least privilege, and fail-closed behavior.
- For security findings, report the risk, affected location, and the shortest safe remediation path.
