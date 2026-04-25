# Legacy Lane: dependency-check

Vendor: Google Antigravity
Router: `quality-repair`
Source archive: `.\Agent\Google\deprecated-Workflows\dependency-check.md`
Consolidated: 2026-04-25

The content below is the former installable skill or workflow body, preserved as an on-demand lane reference.

```markdown
---
description: Check dependencies across ecosystems, enforce runtime safety policy, and produce normalized audit output.
---

<workflow name="dependency-check" thinking="Normal">
  <metadata>
    <description>Cross-ecosystem dependency maintenance with vulnerability triage, safe update sequencing, and standardized reporting.</description>
  </metadata>

  <when_to_use>
    <trigger>Monthly maintenance</trigger>
    <trigger>Before major releases</trigger>
    <trigger>After security advisories</trigger>
    <trigger>When things mysteriously break</trigger>
  </when_to_use>

  <inputs>
    <field optional="true">project_root</field>
    <field optional="true">target_ecosystems</field>
  </inputs>

  <steps>
    <step number="1" name="Detect Active Ecosystems">
      <instruction>Inspect project manifests to detect active dependency ecosystems.</instruction>
      <detection_rules>
        <rule>Node.js: package.json</rule>
        <rule>Python: pyproject.toml, requirements.txt, poetry.lock, uv.lock</rule>
        <rule>Ruby: Gemfile, Gemfile.lock</rule>
        <rule>Java: pom.xml, build.gradle, gradle.lockfile</rule>
        <rule>.NET: *.csproj, packages.lock.json, global.json</rule>
      </detection_rules>
      <instruction>If `target_ecosystems` is provided, scope checks accordingly.</instruction>
    </step>

    <step number="2" name="Run Vulnerability Audits">
      <commands>
        <command ecosystem="Node.js">npm audit</command>
        <command ecosystem="Python">pip-audit</command>
        <command ecosystem="Ruby">bundle audit</command>
        <command ecosystem="Java">mvn org.owasp:dependency-check-maven:check OR gradle dependencyCheckAnalyze</command>
        <command ecosystem=".NET">dotnet list package --vulnerable --include-transitive</command>
      </commands>
      <instruction>Run only commands relevant to detected ecosystems.</instruction>
    </step>

    <step number="3" name="Run Outdated Checks">
      <commands>
        <command ecosystem="Node.js">npm outdated</command>
        <command ecosystem="Python">pip list --outdated</command>
        <command ecosystem="Ruby">bundle outdated</command>
        <command ecosystem="Java">mvn versions:display-dependency-updates OR gradle dependencyUpdates</command>
        <command ecosystem=".NET">dotnet list package --outdated --include-transitive</command>
      </commands>
      <instruction>Capture direct and transitive dependency drift where supported.</instruction>
    </step>

    <step number="4" name="Apply Safe Update Strategy">
      <instruction>Prioritize security updates first, then patch/minor upgrades, then majors with migration review.</instruction>
      <rules>
        <rule>Critical/High vulnerabilities: remediate immediately.</rule>
        <rule>Patch/minor updates: apply in batches and retest.</rule>
        <rule>Major updates: one at a time with migration guide review.</rule>
      </rules>
    </step>

    <step number="5" name="Validate Runtime Safety Policy">
      <skill ref="runtime-safety-enforcer">Validate dependency isolation and lock/pin policy compliance</skill>
      <instruction>Confirm project-scoped dependency management and deterministic lock/pin behavior.</instruction>
      <instruction>Block completion if policy violations remain unresolved.</instruction>
    </step>

    <step number="6" name="Run Verification Suite">
      <instruction>Run project test suite and targeted smoke tests after updates.</instruction>
      <instruction>Do not approve dependency updates if critical tests fail.</instruction>
    </step>

    <step number="7" name="Emit Normalized Report">
      <output_format>
        <field>detected_ecosystems</field>
        <field>vulnerability_summary</field>
        <field>outdated_summary</field>
        <field>updates_applied</field>
        <field>runtime_safety_status</field>
        <field>overall_status</field>
        <field>remediation_steps</field>
      </output_format>
      <instruction>Set `overall_status=BLOCK` if unresolved critical vulnerabilities or policy violations remain.</instruction>
    </step>
  </steps>

  <success_criteria>
    <criterion>Detected ecosystems are explicitly reported</criterion>
    <criterion>No unresolved critical vulnerabilities</criterion>
    <criterion>Runtime safety policy is compliant</criterion>
    <criterion>Verification suite passes after updates</criterion>
    <criterion>Normalized dependency report is produced</criterion>
  </success_criteria>
</workflow>
```
