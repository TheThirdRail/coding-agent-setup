# Legacy Lane: ci-cd-debugger

Vendor: Google Antigravity
Router: `quality-repair`
Source archive: `.\Agent\Google\deprecated-Skills\ci-cd-debugger\SKILL.md`
Consolidated: 2026-04-25

The content below is the former installable skill or workflow body, preserved as an on-demand lane reference.

```markdown
---
name: ci-cd-debugger
description: |
  Debug failing CI/CD pipelines and GitHub Actions workflows. Analyzes build logs,
  identifies failure causes, and suggests fixes. Use when builds fail, tests break
  in CI, or deployments don't complete successfully.
---

<skill name="ci-cd-debugger" version="2.0.0">
  <metadata>
    <keywords>ci-cd, github-actions, pipeline, debugging, devops</keywords>
  </metadata>

  <goal>Systematically diagnose and resolve CI/CD pipeline failures by identifying root causes from build logs.</goal>

  <core_principles>
    <principle name="Failure Categories">
      <category name="Build" symptoms="Compilation fails" causes="Missing deps, syntax errors"/>
      <category name="Test" symptoms="Tests fail" causes="Code bugs, flaky tests, env issues"/>
      <category name="Lint" symptoms="Style checks fail" causes="Code style violations"/>
      <category name="Security" symptoms="Security scan fails" causes="Vulnerabilities detected"/>
      <category name="Deploy" symptoms="Deployment fails" causes="Config errors, permissions"/>
      <category name="Infra" symptoms="Runner issues" causes="Resource limits, network"/>
    </principle>

    <principle name="Debug Priority">
      <step>Read the error message completely</step>
      <step>Find the FIRST failure (not cascading errors)</step>
      <step>Check if it works locally</step>
      <step>Review recent changes that could cause this</step>
      <step>Search for similar issues in project history</step>
    </principle>
  </core_principles>



  <workflow>
    <step number="1" name="Identify Job and Step">
      <question>Which workflow failed?</question>
      <question>Which job within the workflow?</question>
      <question>Which step within the job?</question>
      <question>What is the exit code?</question>
    </step>

    <step number="2" name="Read Error Message">
      <instruction>Focus on the FIRST error, not cascading failures</instruction>
    </step>

    <step number="3" name="Categorize Failure">
      <decision condition="Build failed">Check dependencies and syntax</decision>
      <decision condition="Tests failed">Check assertions, timeouts, mocks</decision>
      <decision condition="Lint failed">Check formatting rules</decision>
      <decision condition="Deploy failed">Check connections and permissions</decision>
    </step>

    <step number="4" name="Compare with Previous">
      <command>git log --oneline &lt;last-passing-sha&gt;..HEAD</command>
      <command>git diff --stat &lt;last-passing-sha&gt;..HEAD</command>
    </step>

    <step number="5" name="Check Environment Differences">
      <check>Node version (.nvmrc or workflow)</check>
      <check>Package manager version (lock file)</check>
      <check>OS (runs-on)</check>
      <check>Environment variables (secrets)</check>
    </step>
  </workflow>

  <common_fixes>
    <fix issue="Module not found" solution="Use npm ci instead of npm install"/>
    <fix issue="Cache issues" solution="Bump cache key version"/>
    <fix issue="Flaky tests" solution="Use waitFor instead of setTimeout"/>
    <fix issue="Permission denied" solution="Check permissions block, add chmod"/>
    <fix issue="Out of memory" solution="Set NODE_OPTIONS=--max-old-space-size=4096"/>
    <fix issue="Timeout" solution="Increase timeout-minutes or optimize"/>
    <fix issue="Secret not available" solution="Pass secret explicitly in env block"/>
  </common_fixes>

  <debug_commands>
    <command purpose="View workflow runs">gh run list --workflow=ci.yml</command>
    <command purpose="View failed logs">gh run view &lt;run-id&gt; --log-failed</command>
    <command purpose="Re-run failed jobs">gh run rerun &lt;run-id&gt; --failed</command>
    <command purpose="Run locally">act -j test</command>
  </debug_commands>

  <best_practices>
    <do>Read the complete error message before acting</do>
    <do>Find the first failure, not cascading errors</do>
    <do>Reproduce locally before debugging CI</do>
    <do>Use npm ci not npm install</do>
    <do>Pin action versions (@v4 not @main)</do>
    <do>Cache dependencies for faster builds</do>
    <dont>Re-run without understanding the failure</dont>
    <dont>Commit fixes without local testing</dont>
    <dont>Ignore flaky tests</dont>
    <dont>Expose secrets in logs</dont>
    <dont>Use continue-on-error to hide failures</dont>
  </best_practices>

  <related_skills>
    <skill>git-commit-generator</skill>
    <skill>test-generator</skill>
    <skill>docker-ops</skill>
  </related_skills>
</skill>
```
