# Legacy Lane: security-checker

Vendor: OpenAI Codex
Router: `quality-repair`
Source archive: `.\Agent\OpenAI\deprecated-Skills\security-checker\SKILL.md`
Consolidated: 2026-04-25

The content below is the former installable skill or workflow body, preserved as an on-demand lane reference.

```markdown
---
name: security-checker
description: |
  Analyze code for vulnerabilities, exposed secrets, and insecure patterns
  before merge or release. Use when reviewing security-sensitive changes,
  authentication/authorization flows, input handling, and dependency risk.
---
# Skill: security-checker
Attributes: name="security-checker", version="2.0.0"

## Metadata (`metadata`)

- `keywords`: security, vulnerabilities, secrets, injection, xss, audit

## Spec Contract (`spec_contract`)

- `id`: security-checker

- `name`: security-checker

- `version`: 2.0.0

- `last_updated`: 2026-02-09

- `purpose`: Identify security vulnerabilities in code before they reach production.

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

- `goal`: Identify security vulnerabilities in code before they reach production.

## Core Principles (`core_principles`)

### Principle (`principle`)
Attributes: name="Priority Hierarchy"

- `priority` (level="P0", category="Hardcoded secrets", action="Block immediately", icon="🔴")

- `priority` (level="P0", category="SQL/Command injection", action="Block immediately", icon="🔴")

- `priority` (level="P1", category="Authentication bypass", action="Block merge", icon="🔴")

- `priority` (level="P1", category="XSS vulnerabilities", action="Block merge", icon="🔴")

- `priority` (level="P2", category="Insecure dependencies", action="Recommend fix", icon="🟠")

- `priority` (level="P3", category="Missing input validation", action="Suggest improvement", icon="🟡")

### Principle (`principle`)
Attributes: name="Defense in Depth"

- `rule`: Check multiple layers: input, processing, output, storage

- `rule`: Assume all user input is malicious

- `rule`: Verify authentication on every protected resource

## Recommended Mcp (`recommended_mcp`)

- `server`: snyk

- `reason`: Deep vulnerability and dependency analysis

## Checks (`checks`)

### Category (`category`)
Attributes: name="Exposed Secrets"

- `pattern`: api_key\s*=\s*["'][^"']+["']

- `pattern`: password\s*=\s*["'][^"']+["']

- `pattern`: secret\s*=\s*["'][^"']+["']

- `pattern`: AWS_SECRET|GITHUB_TOKEN|DATABASE_URL with values

- `action`: Check .env files are in .gitignore

- `action`: Verify no secrets in commit history

### Category (`category`)
Attributes: name="Injection Vulnerabilities"

#### Vulnerability (`vulnerability`)
Attributes: name="SQL Injection"

- `bad_pattern`: query(f"SELECT * FROM users WHERE id = {user_id}")

- `good_pattern`: query("SELECT * FROM users WHERE id = ?", [user_id])

#### Vulnerability (`vulnerability`)
Attributes: name="Command Injection"

- `bad_pattern`: os.system(f"ls {user_path}")

- `good_pattern`: subprocess.run(["ls", user_path], shell=False)

#### Vulnerability (`vulnerability`)
Attributes: name="XSS"

- `bad_pattern`: innerHTML = userInput

- `good_pattern`: textContent = userInput OR sanitize(userInput)

### Category (`category`)
Attributes: name="Authentication Issues"

- `check`: Login/logout flow completeness

- `check`: Password hashing (bcrypt, argon2 preferred)

- `check`: Session management (expiry, invalidation)

- `check`: Missing auth checks on protected routes

- `check`: JWT validation (signature, expiry, issuer)

### Category (`category`)
Attributes: name="File Handling"

- `rule`: User input should NEVER directly control file paths

- `check`: Path traversal: ../../../etc/passwd patterns

- `check`: File upload validation (type, size, content)

## Workflow (`workflow`)

### Step (`step`)
Attributes: number="1", name="Scan for Secrets"

- `action`: Search for hardcoded credentials

- `action`: Check .env files in .gitignore

### Step (`step`)
Attributes: number="2", name="Check Injection Points"

- `action`: Find all user input sources

- `action`: Trace data flow to queries/commands/output

- `action`: Verify sanitization at each point

### Step (`step`)
Attributes: number="3", name="Review Auth Logic"

- `action`: Verify auth on protected endpoints

- `action`: Check session/token handling

### Step (`step`)
Attributes: number="4", name="Report Findings"

- `format`: Prioritized list with severity icons

- `format`: Include fix suggestions for each issue

- `feedback_template`:
```text
🔴 **Security: [Issue Type]**
**Location:** `file.py:123`
**Problem:** [What the vulnerability is]
**Risk:** [What could happen if exploited]
**Fix:** [How to remediate]
```

## Best Practices (`best_practices`)

- `do`: Start with secrets and injection — highest impact

- `do`: Trace user input through the entire flow

- `do`: Check both server and client-side validation

- `do`: Verify error messages don't leak sensitive info

- `do`: Check dependencies with npm audit / pip-audit

- `dont`: Assume frontend validation is sufficient

- `dont`: Trust "it's internal only" arguments

- `dont`: Skip auth checks on "unimportant" endpoints

## Resources (`resources`)

### Script (`script`)
Attributes: name="scan_secrets.ps1", purpose="Automated secret detection"

- `usage`: .\scripts\scan_secrets.ps1

- `usage`: .\scripts\scan_secrets.ps1 -Path "src" -Extensions "*.py","*.js"

- `description`: Scans for hardcoded secrets, API keys, passwords. Checks .gitignore for .env files.

## Related Skills (`related_skills`)

- `skill`: code-reviewer

- `skill`: test-generator
```
