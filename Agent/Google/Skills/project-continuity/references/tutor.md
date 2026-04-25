# Legacy Lane: tutor

Vendor: Google Antigravity
Router: `project-continuity`
Source archive: `.\Agent\Google\deprecated-Workflows\tutor.md`
Consolidated: 2026-04-25

The content below is the former installable skill or workflow body, preserved as an on-demand lane reference.

```markdown
---
description: Tutor Mode - Generate educational documentation for learning the codebase
---

<workflow name="tutor" thinking="Normal">
  <purpose>Create educational documentation to help understand the codebase.</purpose>

  <when_to_use>
    <trigger>Learning a new codebase</trigger>
    <trigger>Wanting to understand how files connect</trigger>
    <trigger>Teaching someone else the project</trigger>
  </when_to_use>

  <constraints>
    <constraint>DO NOT write implementation code</constraint>
    <constraint>DO NOT modify source files</constraint>
    <constraint>Focus ONLY on generating documentation in Agent-Context/Lessons/ folder</constraint>
  </constraints>

  <request_parsing>
    <instruction>Read user's request to determine which type of documentation they want:</instruction>
    <option user_says="Tutor OR Give me an overview">Generate PROJECT_OVERVIEW.md only</option>
    <option user_says="Tutor [filename] OR Explain [file]">Generate in-depth explainer for ONE file</option>
    <option user_says="Tutor Project OR Document everything">Generate overview + explainer for ALL files</option>
  </request_parsing>

  <setup first_time_only="true">
    <action>Create the Agent-Context/Lessons/ folder if it doesn't exist</action>
    <action>Ensure Agent-Context/ is in .gitignore</action>
  </setup>

  <output_options>
    <option name="Project Overview" output="Agent-Context/Lessons/PROJECT_OVERVIEW.md">
      <content>Project file structure (tree view)</content>
      <content>Quick explainer for each file (1-3 sentences)</content>
      <content>Purpose of each file</content>
      <content>How files connect to each other</content>
      <content>Entry points and main flows</content>
    </option>

    <option name="Single File Explainer" output="Agent-Context/Lessons/[filename]_explained.md">
      <content>What the file does (plain English)</content>
      <content>Key concepts used</content>
      <content>Line-by-line or section-by-section breakdown</content>
      <content>How it connects to other files</content>
      <content>Analogies where helpful</content>
      <content>Common modifications developers make</content>
    </option>

    <option name="Full Project Documentation">
      <output>Agent-Context/Lessons/PROJECT_OVERVIEW.md + Agent-Context/Lessons/[filename]_explained.md for EVERY source file</output>
    </option>
  </output_options>

  <writing_style>
    <rule>Use plain English, not jargon</rule>
    <rule>Include analogies to real-world concepts</rule>
    <rule>Define technical terms the first time they appear</rule>
    <rule>Use code snippets with explanations</rule>
    <rule>Include "Why it matters" sections</rule>
  </writing_style>

  <exit_criteria>
    <criterion>Requested documentation created</criterion>
    <criterion>Files are in Agent-Context/Lessons/ folder</criterion>
    <criterion>User confirms understanding</criterion>
  </exit_criteria>
</workflow>
```
