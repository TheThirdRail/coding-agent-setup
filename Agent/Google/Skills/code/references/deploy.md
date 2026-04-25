# Legacy Lane: deploy

Vendor: Google Antigravity
Router: `code`
Source archive: `.\Agent\Google\deprecated-Workflows\deploy.md`
Consolidated: 2026-04-25

The content below is the former installable skill or workflow body, preserved as an on-demand lane reference.

```markdown
---
description: Safe deployment workflow with verification and rollback
---

<workflow name="deploy" thinking="Normal">
  <metadata>
    <description>Production deployment with pre-checks, verification, and rollback capability</description>
  </metadata>

  <when_to_use>
    <trigger>Deploying to staging or production</trigger>
    <trigger>Releasing a new version</trigger>
    <trigger>Rolling out critical fixes</trigger>
  </when_to_use>

  <recommended_mcp>
    <server>github</server>
    <reason>Track deployment commits and releases</reason>
  </recommended_mcp>

  <steps>
    <step number="1" name="Pre-Deployment Checklist">
      <skill ref="runtime-safety-enforcer">Validate dependency isolation, error contract, and logging safety posture</skill>
      <instruction>Verify all prerequisites before deployment</instruction>
      <checks>
        <check>All tests passing</check>
        <check>Quality gate status is PASS (/quality-gates)</check>
        <check>Security audit clear (/security-audit)</check>
        <check>Dependencies up to date (/dependency-check)</check>
        <check>Database migrations prepared and tested</check>
        <check>Environment variables configured</check>
        <check>Feature flags set appropriately</check>
      </checks>
      <blocker>Do NOT proceed if any critical check fails</blocker>
    </step>

    <step number="2" name="Quality Gate Enforcement (Mandatory)">
      <instruction>Apply `/quality-gates` before build/deployment execution.</instruction>
      <instruction>If `overall_status=BLOCK`, halt deployment and remediate.</instruction>
      <required_output>overall_status=PASS</required_output>
    </step>

    <step number="3" name="Prepare Deployment Artifacts">
      <instruction>Build and validate deployment package</instruction>
      <actions turbo="true">
        <action>Build production artifacts</action>
        <action>Verify build output (no warnings, correct size)</action>
        <action>Run smoke tests against build</action>
      </actions>
    </step>

    <step number="4" name="Create Backup Point">
      <instruction>Ensure rollback capability</instruction>
      <actions>
        <action>Tag current production state (git tag)</action>
        <action>Backup database if schema changes</action>
        <action>Document rollback procedure</action>
      </actions>
    </step>

    <step number="5" name="Choose Deployment Strategy">
      <instruction>Select appropriate deployment method</instruction>
      <strategies>
        <strategy name="Direct Deploy">
          <use_when>Low-traffic application, non-critical updates</use_when>
          <downtime>Brief</downtime>
        </strategy>
        <strategy name="Blue-Green">
          <use_when>Zero-downtime required, two environments available</use_when>
          <downtime>None (instant switch)</downtime>
        </strategy>
        <strategy name="Canary">
          <use_when>Risky changes, need gradual rollout</use_when>
          <downtime>None (gradual switch)</downtime>
        </strategy>
        <strategy name="Rolling">
          <use_when>Multiple instances, can update incrementally</use_when>
          <downtime>None (gradual update)</downtime>
        </strategy>
      </strategies>
    </step>

    <step number="6" name="Execute Deployment">
      <instruction>Deploy to target environment</instruction>
      <actions>
        <action>Run deployment command</action>
        <action>Watch for deployment errors</action>
        <action>Verify deployment completes successfully</action>
      </actions>
      <timing>Schedule during low-traffic window if possible</timing>
    </step>

    <step number="7" name="Post-Deployment Verification">
      <instruction>Verify deployment success</instruction>
      <checks>
        <check>Health endpoints responding</check>
        <check>Smoke tests passing</check>
        <check>Key user flows working</check>
        <check>No new errors in logs</check>
        <check>Performance metrics normal</check>
      </checks>
    </step>

    <step number="8" name="Context Governance (Release Event)">
      <instruction>Apply `/context-governance` with `event_type=release` for release archiving and policy checks.</instruction>
      <instruction>Resolve any blocking governance violations before finalizing release status.</instruction>
    </step>

    <step number="9" name="Monitor">
      <instruction>Watch for issues after deployment</instruction>
      <duration>Monitor closely for 30-60 minutes</duration>
      <watch_for>
        <item>Error rate spikes</item>
        <item>Response time increases</item>
        <item>Memory leaks</item>
        <item>User-reported issues</item>
      </watch_for>
    </step>

    <step number="10" name="Document Deployment">
      <instruction>Record deployment details</instruction>
      <output>
        <item>What was deployed (version, commit)</item>
        <item>When and by whom</item>
        <item>Any issues encountered</item>
        <item>Rollback procedure if needed</item>
      </output>
    </step>
  </steps>

  <rollback_procedure>
    <trigger>Deployment causes critical issues</trigger>
    <steps>
      <step>Decide to rollback (within rollback window)</step>
      <step>Execute rollback (redeploy previous version)</step>
      <step>Verify rollback success</step>
      <step>Investigate and fix issues before retrying</step>
    </steps>
  </rollback_procedure>

  <success_criteria>
    <criterion>Application is running the new version</criterion>
    <criterion>All health checks passing</criterion>
    <criterion>Quality gate status is PASS before deploy</criterion>
    <criterion>No increase in error rates</criterion>
    <criterion>Performance metrics stable</criterion>
  </success_criteria>

  <related_workflows>
    <workflow>/quality-gates</workflow>
    <workflow>/context-governance</workflow>
    <workflow>/security-audit</workflow>
    <workflow>/dependency-check</workflow>
    <workflow>/pr</workflow>
  </related_workflows>
</workflow>
```
