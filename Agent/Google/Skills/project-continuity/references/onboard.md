# Legacy Lane: onboard

Vendor: Google Antigravity
Router: `project-continuity`
Source archive: `.\Agent\Google\deprecated-Workflows\onboard.md`
Consolidated: 2026-04-25

The content below is the former installable skill or workflow body, preserved as an on-demand lane reference.

```markdown
---
description: Systematic onboarding for new or inherited codebases
---

<workflow name="onboard" thinking="MAX">
  <metadata>
    <description>Deep-dive onboarding for new projects or inherited codebases</description>
  </metadata>

  <important>Use MAXIMUM thinking/reasoning depth. This workflow creates foundational understanding.</important>

  <when_to_use>
    <trigger>Joining a new project</trigger>
    <trigger>Inheriting a codebase from another developer</trigger>
    <trigger>First time working with an unfamiliar repository</trigger>
    <trigger>Returning to a project after extended absence (months)</trigger>
  </when_to_use>

  <distinction>
    <versus workflow="/morning">
      <difference>/morning is a DAILY routine for staying current</difference>
      <difference>/onboard is a ONE-TIME deep dive for initial understanding</difference>
    </versus>
  </distinction>

  <constraints>
    <constraint>DO NOT write implementation code</constraint>
    <constraint>DO NOT modify source files (read-only for understanding)</constraint>
    <constraint>Configuration/scaffolding (e.g. .env) is permitted</constraint>
  </constraints>

  <recommended_mcp>
    <server>context7</server>
    <reason>Retrieve documentation for unfamiliar frameworks</reason>
  </recommended_mcp>

  <steps>
    <step number="1" name="Map the Repository">
      <instruction>Explore directory structure and identify key files</instruction>
      <actions>
        <action>Read README.md thoroughly</action>
        <action>Identify tech stack from package.json, requirements.txt, go.mod, etc.</action>
        <action>Map high-level architecture (src/, lib/, tests/, docs/)</action>
        <action>Find configuration files (.env.example, config/, etc.)</action>
        <action>Locate entry points (main.ts, index.js, app.py)</action>
      </actions>
      <output>Mental model of project structure</output>
    </step>

    <step number="2" name="Understand the Domain">
      <skill ref="research-capability">Use to look up unfamiliar concepts/patterns</skill>
      <instruction>Gather business context and domain knowledge</instruction>
      <actions>
        <action>Read any documentation in docs/ folder</action>
        <action>Identify core entities and their relationships</action>
        <action>Understand user workflows and use cases</action>
        <action>Map external integrations (APIs, databases, services)</action>
        <action>Look for ADRs (Architecture Decision Records)</action>
      </actions>
      <questions>
        <question>What problem does this solve?</question>
        <question>Who are the users?</question>
        <question>What are the key business rules?</question>
      </questions>
    </step>

    <step number="3" name="Set Up Local Environment">
      <instruction>Prepare development environment following project conventions</instruction>
      <actions turbo="true">
        <action>Check prerequisites (Node version, Python version, etc.)</action>
        <action>Install dependencies (npm install, pip install, etc.)</action>
        <action>Copy .env.example to .env and configure</action>
        <action>Set up databases if needed</action>
        <action>Run any setup scripts mentioned in README</action>
      </actions>
      <validation>Development environment is functional</validation>
    </step>

    <step number="4" name="Verify Everything Works">
      <instruction>Run tests and start the application</instruction>
      <actions turbo="true">
        <action>Run test suite: npm test, pytest, go test, etc.</action>
        <action>Start development server</action>
        <action>Verify database connections</action>
        <action>Test 2-3 key user flows manually</action>
      </actions>
      <success_criteria>
        <criterion>Tests pass (or you understand why they fail)</criterion>
        <criterion>Application starts without errors</criterion>
        <criterion>Can perform basic operations</criterion>
      </success_criteria>
    </step>

    <step number="5" name="Trace Key Code Paths">
      <instruction>Follow execution from entry point through core functionality</instruction>
      <actions>
        <action>Trace a request from entry point to response</action>
        <action>Understand the data flow (input → processing → output)</action>
        <action>Identify key abstractions and patterns used</action>
        <action>Note any complexity or areas needing deeper study</action>
      </actions>
      <depth>Focus on 2-3 core features, not everything</depth>
    </step>

    <step number="6" name="Document Findings">
      <instruction>Create onboarding notes for future reference</instruction>
      <output file="ONBOARDING_NOTES.md (or similar)">
        <section name="Architecture Overview">High-level system description</section>
        <section name="Key Files">Important files and their purposes</section>
        <section name="Common Commands">Frequently used commands</section>
        <section name="Gotchas">Non-obvious quirks or warnings</section>
        <section name="Questions">Things still unclear</section>
      </output>
    </step>

    <step number="7" name="Identify First Contribution">
      <instruction>Find a small, low-risk task to start contributing</instruction>
      <suggestions>
        <suggestion>Fix a typo or documentation gap</suggestion>
        <suggestion>Add a missing test</suggestion>
        <suggestion>Address a small linting issue</suggestion>
        <suggestion>Complete a "good first issue" if labeled</suggestion>
      </suggestions>
      <purpose>Build confidence and verify understanding through actual contribution</purpose>
    </step>
  </steps>

  <success_criteria>
    <criterion>Can explain what the project does in 2-3 sentences</criterion>
    <criterion>Development environment is working</criterion>
    <criterion>Understand how to run tests and start the app</criterion>
    <criterion>Know where to find key functionality</criterion>
    <criterion>Have documented initial findings</criterion>
  </success_criteria>

  <related_workflows>
    <workflow>/morning</workflow>
    <workflow>/research</workflow>
    <workflow>/code</workflow>
  </related_workflows>
</workflow>
```
