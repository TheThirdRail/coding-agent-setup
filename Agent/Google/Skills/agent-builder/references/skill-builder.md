# Legacy Lane: skill-builder

Vendor: Google Antigravity
Router: `agent-builder`
Source archive: `.\Agent\Google\deprecated-Skills\skill-builder\SKILL.md`
Consolidated: 2026-04-25

The content below is the former installable skill or workflow body, preserved as an on-demand lane reference.

```markdown
---
name: skill-builder
description: |
  Create and upgrade skills using strict v2 structure, validation, and
  packaging conventions. Use when building new skills, modernizing legacy
  skills, or preparing skills for distribution and CI enforcement.
---

<skill name="skill-builder" version="2.1.0">
  <metadata>
    <keywords>skills, meta, template, builder, creation, packaging</keywords>
  </metadata>

  <goal>Guide creation of AI agent skills with progressive disclosure, clear descriptions, proper structure, and automation scripts.</goal>

  <core_principles>
    <principle name="Progressive Disclosure">
      <level name="Metadata" tokens="~50">Name + description loaded at startup</level>
      <level name="Instructions" tokens="~2-5K">Full SKILL.md when activated</level>
      <level name="Resources" tokens="variable">Scripts/examples loaded on-demand</level>
    </principle>

    <principle name="Single Responsibility">
      <rule>One skill = one capability</rule>
      <rule>If scope creeps, split into multiple skills</rule>
      <rule>Skills can reference other skills for composition</rule>
    </principle>

    <principle name="Discovery-First Design">
      <rule>Description must explain WHEN to use (not just what)</rule>
      <rule>Include trigger conditions in description, NOT in body</rule>
      <rule>Use keywords for searchability</rule>
    </principle>

    <principle name="Strict Validation Gate">
      <rule>Body must not include trigger-only sections such as &lt;when_to_use&gt;.</rule>
      <rule>Every skill must pass XML structure, metadata schema, and reference checks before packaging.</rule>
      <rule>Warnings are promoted to errors in strict mode.</rule>
    </principle>

    <principle name="Degrees of Freedom">
      <level name="High Freedom" use="text-based instructions">
        Use when multiple approaches are valid or decisions depend on context
      </level>
      <level name="Medium Freedom" use="pseudocode or scripts with parameters">
        Use when a preferred pattern exists but some variation is acceptable
      </level>
      <level name="Low Freedom" use="specific scripts, few parameters">
        Use when operations are fragile, consistency is critical, or a specific sequence must be followed
      </level>
      <note>Narrow bridge with cliffs → low freedom; open field → high freedom</note>
    </principle>
  </core_principles>

  <resource_folders>
    <folder name="scripts/" purpose="Executable code">
      <when>Same code is rewritten repeatedly OR deterministic reliability needed</when>
      <examples>rotate_pdf.py, validate_yaml.ps1, lint_schema.sh</examples>
      <benefit>Token efficient, deterministic, can execute without loading into context</benefit>
    </folder>

    <folder name="references/" purpose="Documentation for context">
      <when>Claude needs to reference while working (schemas, APIs, policies)</when>
      <examples>schema.md, api_docs.md, company_policies.md</examples>
      <benefit>Keeps SKILL.md lean; loaded only when needed</benefit>
      <tip>For files >10k words, include grep search patterns in SKILL.md</tip>
    </folder>

    <folder name="assets/" purpose="Output resources">
      <when>Files used in final output (not loaded into context)</when>
      <examples>logo.png, template.pptx, frontend-boilerplate/</examples>
      <benefit>Separates output resources from documentation</benefit>
    </folder>

    <decision_guide>
      <case trigger="Rotating a PDF">scripts/rotate_pdf.py — same code every time</case>
      <case trigger="Building frontend app">assets/hello-world/ — boilerplate template</case>
      <case trigger="Querying database">references/schema.md — needs schema knowledge</case>
    </decision_guide>
  </resource_folders>

  <anti_patterns>
    <rule severity="critical">Do NOT create extraneous documentation files:</rule>
    <forbidden>README.md</forbidden>
    <forbidden>INSTALLATION_GUIDE.md</forbidden>
    <forbidden>QUICK_REFERENCE.md</forbidden>
    <forbidden>CHANGELOG.md</forbidden>
    <forbidden>CONTRIBUTING.md</forbidden>
    <reason>Skills are for AI agents, not humans. Extra docs add clutter and confusion.</reason>
    <rule>Information lives in SKILL.md OR references/, never both</rule>
    <rule>Keep references one level deep (no nested directories)</rule>
  </anti_patterns>

  <workflow>
    <step number="1" name="Define the Skill">
      <question>What capability does this skill provide?</question>
      <question>When should an agent use this skill? (triggers)</question>
      <question>What inputs does it need?</question>
      <question>What outputs does it produce?</question>
      <question>Can you give concrete examples of how it would be used?</question>
      <tip>Ask 2-3 questions at a time; don't overwhelm the user</tip>
    </step>

    <step number="2" name="Plan Resource Types">
      <instruction>For each example, decide: script, reference, or asset?</instruction>
      <decision_tree>
        <if condition="Same code rewritten repeatedly">→ scripts/</if>
        <if condition="Needs documentation while working">→ references/</if>
        <if condition="File used in output (not in context)">→ assets/</if>
      </decision_tree>
    </step>

    <step number="3" name="Initialize Skill Structure">
      <instruction>Run the init script to scaffold the skill</instruction>
      <command>scripts/init_skill.ps1 -Name "skill-name" -Path "skill-name"</command>
      <generates>
        <item>skill-name/SKILL.md — template with frontmatter</item>
        <item>skill-name/scripts/ — example script</item>
        <item>skill-name/references/ — example reference</item>
        <item>skill-name/assets/ — example asset</item>
      </generates>
      <note>Delete unused example files after initialization</note>
    </step>

    <step number="4" name="Implement Resources">
      <instruction>Create scripts, references, and assets identified in Step 2</instruction>
      <rule>Test all scripts by running them</rule>
      <rule>If many similar scripts, test representative sample</rule>
      <rule>Delete example files not needed</rule>
    </step>

    <step number="5" name="Write SKILL.md">
      <format>YAML frontmatter + XML body</format>
      <template><![CDATA[
---
name: skill-name
description: |
  Brief description of what the skill does.
  Include WHEN to use this skill (triggers).
  Keep under 200 words.
---

<skill name="skill-name" version="2.0.0">
  <metadata>
    <keywords>keyword1, keyword2, keyword3</keywords>
  </metadata>

  <goal>One sentence describing the skill's purpose.</goal>

  <core_principles>
    <principle name="Key Principle">
      <rule>Specific rule or guideline</rule>
    </principle>
  </core_principles>

  <workflow>
    <step number="1" name="Step Name">
      <instruction>What to do in this step</instruction>
    </step>
  </workflow>

  <best_practices>
    <do>What to do</do>
    <dont>What to avoid</dont>
  </best_practices>
</skill>
      ]]></template>

      <frontmatter_rules>
        <rule>name: The skill name (kebab-case)</rule>
        <rule>description: Primary trigger mechanism — explain WHEN to use</rule>
        <rule>Do NOT include "When to Use" in body (loaded after trigger)</rule>
        <rule>Do NOT include &lt;when_to_use&gt; in body XML</rule>
        <rule>No other fields in frontmatter</rule>
      </frontmatter_rules>
    </step>

    <step number="6" name="Package for Distribution">
      <instruction>Validate and package the skill</instruction>
      <command>scripts/package_skill.ps1 -Path "skill-name" -OutputDir "./dist"</command>
      <validates>
        <check>YAML frontmatter format and required fields</check>
        <check>Skill naming conventions (kebab-case, max 64 chars)</check>
        <check>Description completeness</check>
        <check>Required XML sections and workflow step sequencing</check>
        <check>Metadata schema validation (metadata.json)</check>
        <check>Related skill/workflow references resolve</check>
        <check>File organization and resource references</check>
      </validates>
      <output>Creates skill-name.skill (zip with .skill extension)</output>
    </step>

    <step number="7" name="Install Skill">
      <instruction>Move the skill to the appropriate location.</instruction>
      <decision_tree>
        <branch condition="Global Skill (Apply to ALL projects)">
          <action>Run: scripts/move-global-skill.ps1 -Name "skill-name" -Vendor "anthropic|openai|google"</action>
        </branch>
        <branch condition="Workspace Skill (Apply to THIS project only)">
          <action>Run: scripts/move-local-skill.ps1 -Name "skill-name" -Vendor "anthropic|openai"</action>
          <note>Do not use workspace-local Antigravity backup folders; Antigravity reads them as active context.</note>
        </branch>
      </decision_tree>
    </step>

    <step number="8" name="Iterate">
      <instruction>Improve based on real usage</instruction>
      <cycle>
        <action>Use the skill on real tasks</action>
        <action>Notice struggles or inefficiencies</action>
        <action>Identify what to update in SKILL.md or resources</action>
        <action>Implement changes and test again</action>
      </cycle>
      <tip>Iterate immediately after use while context is fresh</tip>
    </step>
  </workflow>

  <validation_gates>
    <command>scripts/validate-links.ps1</command>
    <command>scripts/audit-skills.ps1 -Strict</command>
    <command>scripts/ci-validate-skills.ps1</command>
  </validation_gates>

  <platform_compatibility>
    <platform name="Antigravity" location="~/.gemini/antigravity/skills/"/>
    <platform name="Claude Code" location=".claude/skills/"/>
    <platform name="GitHub Copilot" location=".github/skills/"/>
    <platform name="Cursor" location=".cursor/skills/"/>
  </platform_compatibility>

  <installation_paths>
    <global>
      <vendor name="Anthropic" location="~/.claude/skills/"/>
      <vendor name="OpenAI" location="~/.agents/skills/" legacy_location="~/.codex/skills/"/>
      <vendor name="Google" location="~/.gemini/antigravity/skills/"/>
    </global>
    <local>
      <vendor name="Anthropic" location=".claude/skills/"/>
      <vendor name="OpenAI" location=".agents/skills/" legacy_location=".codex/skills/"/>
    </local>
  </installation_paths>

  <best_practices>
    <do>Keep SKILL.md as the "reception desk" pointing to resources</do>
    <do>Write descriptions that explain WHEN to use (triggers)</do>
    <do>Include decision trees for complex branching</do>
    <do>Provide concrete examples</do>
    <do>Use tables for quick reference data</do>
    <do>Keep references one level deep</do>
    <do>Test scripts before packaging</do>
    <do>Use imperative/infinitive form in instructions</do>
    <dont>Put everything in one massive file (max ~500 lines)</dont>
    <dont>Write vague descriptions ("Does stuff")</dont>
    <dont>Create mega-skills (split if scope creeps)</dont>
    <dont>Skip the "When to use" in description</dont>
    <dont>Deeply nest file references</dont>
    <dont>Create README, CHANGELOG, or other auxiliary docs</dont>
    <dont>Duplicate info between SKILL.md and references/</dont>
  </best_practices>

  <troubleshooting>
    <issue problem="Skill not discovered">Check description explains WHEN to use</issue>
    <issue problem="Skill partially loaded">Keep references one level deep</issue>
    <issue problem="Wrong skill activated">Make description more specific</issue>
    <issue problem="Instructions ignored">Use numbered steps, not prose</issue>
    <issue problem="Context window bloat">Split into reference files, stay under 500 lines</issue>
  </troubleshooting>

  <related_skills>
    <skill>workflow-builder</skill>
    <skill>mcp-manager</skill>
    <skill>mcp-builder</skill>
  </related_skills>
</skill>
```
