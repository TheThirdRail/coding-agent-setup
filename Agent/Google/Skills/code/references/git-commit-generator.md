# Legacy Lane: git-commit-generator

Vendor: Google Antigravity
Router: `code`
Source archive: `.\Agent\Google\deprecated-Skills\git-commit-generator\SKILL.md`
Consolidated: 2026-04-25

The content below is the former installable skill or workflow body, preserved as an on-demand lane reference.

```markdown
---
name: git-commit-generator
description: |
  Generate conventional commit messages from staged changes. Analyzes diffs to
  create semantic, descriptive commit messages following Conventional Commits
  specification. Use when committing code changes or preparing PR descriptions.
---

<skill name="git-commit-generator" version="2.0.0">
  <metadata>
    <keywords>git, commit, conventional-commits, changelog</keywords>
  </metadata>

  <goal>Generate semantic, descriptive commit messages following Conventional Commits specification.</goal>

  <core_principles>
    <principle name="Format">
      <template>&lt;type&gt;(&lt;scope&gt;): &lt;description&gt;</template>
      <template>[optional body]</template>
      <template>[optional footer(s)]</template>
    </principle>

    <principle name="Types">
      <type name="feat" use="New feature for the user"/>
      <type name="fix" use="Bug fix for the user"/>
      <type name="docs" use="Documentation only changes"/>
      <type name="style" use="Formatting, missing semi-colons"/>
      <type name="refactor" use="Code change that neither fixes nor adds"/>
      <type name="perf" use="Performance improvement"/>
      <type name="test" use="Adding or correcting tests"/>
      <type name="build" use="Changes to build system"/>
      <type name="ci" use="Changes to CI configuration"/>
      <type name="chore" use="Other changes"/>
    </principle>

    <principle name="Good Messages">
      <rule>Use imperative mood: "Add feature" not "Added feature"</rule>
      <rule>Keep subject line under 50 characters</rule>
      <rule>Capitalize the subject line</rule>
      <rule>Don't end subject with a period</rule>
    </principle>
  </core_principles>



  <workflow>
    <step number="1" name="Analyze Staged Changes">
      <command>git diff --staged --stat</command>
      <command>git diff --staged</command>
    </step>

    <step number="2" name="Determine Type">
      <decision condition="New feature visible to users">feat</decision>
      <decision condition="Bug fix">fix</decision>
      <decision condition="Documentation only">docs</decision>
      <decision condition="Refactoring without behavior change">refactor</decision>
      <decision condition="Performance improvement">perf</decision>
      <decision condition="Test-related">test</decision>
      <decision condition="Build/dependency related">build</decision>
      <decision condition="CI/CD related">ci</decision>
      <decision condition="Otherwise">chore</decision>
    </step>

    <step number="3" name="Identify Scope">
      <instruction>Use folder or module name (auth, api, ui, db, config)</instruction>
    </step>

    <step number="4" name="Write Subject Line">
      <example>feat(auth): add OAuth2 login support</example>
      <example>fix(api): handle null response from payment gateway</example>
      <example>docs(readme): update installation instructions</example>
    </step>

    <step number="5" name="Add Body If Needed">
      <instruction>For complex changes, explain What, Why, and How</instruction>
    </step>

    <step number="6" name="Add Footer If Needed">
      <example>BREAKING CHANGE: description</example>
      <example>Fixes #123</example>
      <example>Closes #456</example>
    </step>
  </workflow>

  <examples>
    <example name="Simple Feature">
      <changes>+ src/components/Button.tsx (new file)</changes>
      <commit>feat(ui): add reusable Button component</commit>
    </example>

    <example name="Bug Fix">
      <changes>- return date.toLocalString() + return date.toLocaleString()</changes>
      <commit>fix(utils): correct typo in date formatting function</commit>
    </example>

    <example name="Breaking Change">
      <changes>- export function getUser(id: number) + export function getUser(id: string)</changes>
      <commit><![CDATA[
refactor(api)!: change user ID type from number to string

BREAKING CHANGE: All API calls to user endpoints now require
string IDs instead of numbers.

Fixes #892
      ]]></commit>
    </example>
  </examples>

  <best_practices>
    <do>Use present tense imperative ("add" not "added")</do>
    <do>Keep subject under 50 characters</do>
    <do>Separate subject from body with blank line</do>
    <do>Wrap body at 72 characters</do>
    <do>Include issue references in footer</do>
    <do>Use ! after type for breaking changes</do>
    <dont>End subject line with period</dont>
    <dont>Use past tense</dont>
    <dont>Write vague messages ("fix stuff")</dont>
    <dont>Combine unrelated changes</dont>
  </best_practices>

  <resources>
    <script name="generate_commit.ps1" purpose="Automates commit message generation">
      <usage>.\scripts\generate_commit.ps1</usage>
      <usage>.\scripts\generate_commit.ps1 -Execute</usage>
      <description>Analyzes staged changes, detects type/scope, generates conventional commit message</description>
    </script>
  </resources>

  <related_skills>
    <skill>code-reviewer</skill>
    <skill>ci-cd-debugger</skill>
  </related_skills>
</skill>
```
