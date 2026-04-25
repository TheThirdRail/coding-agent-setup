# Legacy Lane: security-checker

Vendor: Google Antigravity
Router: `quality-repair`
Source archive: `.\Agent\Google\deprecated-Skills\security-checker\SKILL.md`
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

<skill name="security-checker" version="2.0.0">
  <metadata>
    <keywords>security, vulnerabilities, secrets, injection, xss, audit</keywords>
  </metadata>

  <goal>Identify security vulnerabilities in code before they reach production.</goal>

  <core_principles>
    <principle name="Priority Hierarchy">
      <priority level="P0" category="Hardcoded secrets" action="Block immediately" icon="🔴"/>
      <priority level="P0" category="SQL/Command injection" action="Block immediately" icon="🔴"/>
      <priority level="P1" category="Authentication bypass" action="Block merge" icon="🔴"/>
      <priority level="P1" category="XSS vulnerabilities" action="Block merge" icon="🔴"/>
      <priority level="P2" category="Insecure dependencies" action="Recommend fix" icon="🟠"/>
      <priority level="P3" category="Missing input validation" action="Suggest improvement" icon="🟡"/>
    </principle>

    <principle name="Defense in Depth">
      <rule>Check multiple layers: input, processing, output, storage</rule>
      <rule>Assume all user input is malicious</rule>
      <rule>Verify authentication on every protected resource</rule>
    </principle>
  </core_principles>



  <recommended_mcp>
    <server>snyk</server>
    <reason>Deep vulnerability and dependency analysis</reason>
  </recommended_mcp>

  <checks>
    <category name="Exposed Secrets">
      <pattern>api_key\s*=\s*["'][^"']+["']</pattern>
      <pattern>password\s*=\s*["'][^"']+["']</pattern>
      <pattern>secret\s*=\s*["'][^"']+["']</pattern>
      <pattern>AWS_SECRET|GITHUB_TOKEN|DATABASE_URL with values</pattern>
      <action>Check .env files are in .gitignore</action>
      <action>Verify no secrets in commit history</action>
    </category>

    <category name="Injection Vulnerabilities">
      <vulnerability name="SQL Injection">
        <bad_pattern>query(f"SELECT * FROM users WHERE id = {user_id}")</bad_pattern>
        <good_pattern>query("SELECT * FROM users WHERE id = ?", [user_id])</good_pattern>
      </vulnerability>
      <vulnerability name="Command Injection">
        <bad_pattern>os.system(f"ls {user_path}")</bad_pattern>
        <good_pattern>subprocess.run(["ls", user_path], shell=False)</good_pattern>
      </vulnerability>
      <vulnerability name="XSS">
        <bad_pattern>innerHTML = userInput</bad_pattern>
        <good_pattern>textContent = userInput OR sanitize(userInput)</good_pattern>
      </vulnerability>
    </category>

    <category name="Authentication Issues">
      <check>Login/logout flow completeness</check>
      <check>Password hashing (bcrypt, argon2 preferred)</check>
      <check>Session management (expiry, invalidation)</check>
      <check>Missing auth checks on protected routes</check>
      <check>JWT validation (signature, expiry, issuer)</check>
    </category>

    <category name="File Handling">
      <rule>User input should NEVER directly control file paths</rule>
      <check>Path traversal: ../../../etc/passwd patterns</check>
      <check>File upload validation (type, size, content)</check>
    </category>
  </checks>

  <workflow>
    <step number="1" name="Scan for Secrets">
      <action>Search for hardcoded credentials</action>
      <action>Check .env files in .gitignore</action>
    </step>

    <step number="2" name="Check Injection Points">
      <action>Find all user input sources</action>
      <action>Trace data flow to queries/commands/output</action>
      <action>Verify sanitization at each point</action>
    </step>

    <step number="3" name="Review Auth Logic">
      <action>Verify auth on protected endpoints</action>
      <action>Check session/token handling</action>
    </step>

    <step number="4" name="Report Findings">
      <format>Prioritized list with severity icons</format>
      <format>Include fix suggestions for each issue</format>
    </step>
  </workflow>

  <feedback_template><![CDATA[
🔴 **Security: [Issue Type]**
**Location:** `file.py:123`
**Problem:** [What the vulnerability is]
**Risk:** [What could happen if exploited]
**Fix:** [How to remediate]
  ]]></feedback_template>

  <best_practices>
    <do>Start with secrets and injection — highest impact</do>
    <do>Trace user input through the entire flow</do>
    <do>Check both server and client-side validation</do>
    <do>Verify error messages don't leak sensitive info</do>
    <do>Check dependencies with npm audit / pip-audit</do>
    <dont>Assume frontend validation is sufficient</dont>
    <dont>Trust "it's internal only" arguments</dont>
    <dont>Skip auth checks on "unimportant" endpoints</dont>
  </best_practices>

  <resources>
    <script name="scan_secrets.ps1" purpose="Automated secret detection">
      <usage>.\scripts\scan_secrets.ps1</usage>
      <usage>.\scripts\scan_secrets.ps1 -Path "src" -Extensions "*.py","*.js"</usage>
      <description>Scans for hardcoded secrets, API keys, passwords. Checks .gitignore for .env files.</description>
    </script>
  </resources>

  <related_skills>
    <skill>code-reviewer</skill>
    <skill>test-generator</skill>
  </related_skills>
</skill>
```
