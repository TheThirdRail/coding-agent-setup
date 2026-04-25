# Legacy Lane: archive-git

Vendor: Google Antigravity
Router: `archive-manager`
Source archive: `.\Agent\Google\deprecated-Skills\archive-git\SKILL.md`
Consolidated: 2026-04-25

The content below is the former installable skill or workflow body, preserved as an on-demand lane reference.

```markdown
---
name: archive-git
description: |
  Query repository history for code evolution, ownership, and change context.
  Use when tracing when and why behavior changed, who modified critical files,
  or how specific patterns entered the codebase.
---

<skill name="archive-git" version="2.0.0">
  <metadata>
    <keywords>archive, git, history, commits, evolution, blame, diffs</keywords>
  </metadata>

  <goal>Provide reliable historical context by querying live git history with focused scripts.</goal>

  <core_principles>
    <principle name="History as Evidence">
      <rule>Use commit history and diffs to validate assumptions about system behavior changes.</rule>
      <rule>Prefer concrete commit references over narrative guesses.</rule>
    </principle>

    <principle name="Query by Intent">
      <rule>Use message mode for rationale/themes and diff mode for exact code pattern tracking.</rule>
      <rule>Use file history when investigating regressions in a specific path.</rule>
    </principle>

    <principle name="Live Repository Source">
      <rule>Queries run directly against the current git repo state, without separate indexing.</rule>
    </principle>
  </core_principles>

  <workflow>
    <step number="1" name="Choose Target Repository">
      <instruction>Set [PROJECT_PATH] to the repository root for all queries.</instruction>
    </step>

    <step number="2" name="Select Query Mode">
      <command>.\Agent\Google\Skills\archive-git\scripts\search.ps1 -RepoPath "[PROJECT_PATH]" -Query "authentication" -Mode "message"</command>
      <command>.\Agent\Google\Skills\archive-git\scripts\search.ps1 -RepoPath "[PROJECT_PATH]" -Query "JWT_SECRET" -Mode "diff"</command>
    </step>

    <step number="3" name="Inspect File-Specific Evolution">
      <command>.\Agent\Google\Skills\archive-git\scripts\file-history.ps1 -RepoPath "[PROJECT_PATH]" -FilePath "src/auth/login.ts" -Limit 10</command>
    </step>

    <step number="4" name="Review Recent Activity">
      <command>.\Agent\Google\Skills\archive-git\scripts\recent.ps1 -RepoPath "[PROJECT_PATH]" -Days 7</command>
    </step>
  </workflow>

  <resources>
    <script file="scripts/search.ps1">Search commit history by message or diff content.</script>
    <script file="scripts/file-history.ps1">Track evolution of one file over time.</script>
    <script file="scripts/recent.ps1">Summarize recent repository activity.</script>
  </resources>

  <best_practices>
    <do>Pair message and diff queries when root-cause confidence is low</do>
    <do>Capture commit hash and date in archived findings</do>
    <do>Scope queries to likely subsystems before broadening</do>
    <dont>Assume commit messages alone explain full behavioral impact</dont>
    <dont>Ignore rename/move history when files changed paths</dont>
  </best_practices>

  <related_skills>
    <skill>archive-manager</skill>
    <skill>archive-code</skill>
    <skill>code-reviewer</skill>
  </related_skills>
</skill>
```
