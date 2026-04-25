# Legacy Lane: project-setup

Vendor: Google Antigravity
Router: `architect`
Source archive: `.\Agent\Google\deprecated-Workflows\project-setup.md`
Consolidated: 2026-04-25

The content below is the former installable skill or workflow body, preserved as an on-demand lane reference.

```markdown
---
description: Project Setup - Initialize project structure after Architect Mode planning
---

<workflow name="project-setup" thinking="Normal">
  <purpose>Initialize project structure AFTER /architect planning is complete.</purpose>

  <when_to_use>
    <trigger>After /architect has created prd.md, checklist.md</trigger>
    <trigger>Before starting /code implementation</trigger>
    <trigger>To set up file structure and configuration</trigger>
  </when_to_use>

  <prerequisites>
    <prerequisite>/architect workflow MUST be completed first</prerequisite>
    <prerequisite>prd.md and checklist.md should exist</prerequisite>
    <prerequisite>Project requirements are clear</prerequisite>
  </prerequisites>

  <steps>
    <step number="1" name="Create .gitignore">
      <content><![CDATA[
# Dependencies
node_modules/
vendor/
.venv/
__pycache__/

# Build outputs

dist/
build/
.next/

# Environment

.env
.env.local
.env.*.local

# IDE

.idea/
.vscode/settings.json

# AI/Agent Generated (DO NOT COMMIT)

Agent-Context/

# Archive Data (DO NOT COMMIT)

Agent-Context/Archives/
Archive/

# Testing

coverage/

# Temporary

tmp/
temp/
      ]]></content>
    </step>

    <step number="2" name="Create Agent-Context Folder Structure">
      <instruction>Create the Agent-Context directory tree for all agent-generated files.</instruction>
      <folders>
        <folder>Agent-Context/Research</folder>
        <folder>Agent-Context/Lessons</folder>
        <folder>Agent-Context/PRD</folder>
        <folder>Agent-Context/Plan</folder>
        <folder>Agent-Context/Tasks</folder>
        <folder>Agent-Context/Communications/Agent-Notes</folder>
        <folder>Agent-Context/Communications/Proj-Mgr-Notes</folder>
        <folder>Agent-Context/Misc</folder>
      </folders>
      <note>Agent-Notes uses YAML format for structured agent-to-agent communication.</note>
      <note>Proj-Mgr-Notes uses Markdown for human-readable artifacts.</note>
    </step>

    <step number="3" name="Create Project Structure">
      <skill ref="architecture-planner">Use for structure decisions</skill>
      <instruction>Based on the tech stack from /architect, create appropriate folders</instruction>
      <template type="Web/Node">src/components/, src/pages/, src/utils/, public/, tests/, docs/</template>
      <template type="Python">src/, tests/, docs/, scripts/</template>
    </step>

    <step number="4" name="Generate Workspace Rules">
      <skill ref="workspace-rules-bootstrapper">Use to generate project-scoped rules from stack inputs</skill>
      <instruction>Collect stack profile from /architect outputs and invoke the skill to emit `.agent/rules/project-rules.md`.</instruction>
      <instruction>Ensure generated rules include dependency isolation, quality gates, runtime safety, and documentation update baselines.</instruction>
      <instruction>Require deterministic output contract fields: `stack_profile`, `baseline_modules`, and `char_count`.</instruction>
      <action>Validate output structure and enforce the 12,000 character limit.</action>
    </step>

    <step number="5" name="Initialize Git" optional="true">
      <command>git init</command>
      <command>git add .</command>
      <command>git commit -m "Initial project setup"</command>
    </step>

    <step number="6" name="Create README.md">
      <content>Project name and description (from prd.md)</content>
      <content>Installation instructions</content>
      <content>Usage examples</content>
      <content>Contributing guidelines</content>
    </step>

    <step number="7" name="Prepare for Implementation">
      <action>Inform user that project is ready</action>
      <action>Suggest proceeding with /code workflow</action>
    </step>

    <step number="8" name="Context Governance (Setup Event)">
      <instruction>Apply `/context-governance` with `event_type=setup` to validate folder schema, required formats, and archive policy constraints.</instruction>
      <instruction>Resolve schema violations before declaring setup complete.</instruction>
    </step>
  </steps>

  <exit_criteria>
    <criterion>All configuration files created</criterion>
    <criterion>Folder structure matches architecture</criterion>
    <criterion>Workspace rule generation is deterministic and under 12,000 chars</criterion>
    <criterion>Ready to proceed with /code</criterion>
  </exit_criteria>
</workflow>
```
