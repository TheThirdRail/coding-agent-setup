# Legacy Lane: archive-manager

Vendor: Google Antigravity
Router: `archive-manager`
Source archive: `.\Agent\Google\deprecated-Skills\archive-manager\SKILL.md`
Consolidated: 2026-04-25

The content below is the former installable skill or workflow body, preserved as an on-demand lane reference.

```markdown
---
name: archive-manager
description: |
  Route archive tasks to the correct archive skill (code, docs, git, graph, or
  memory). Use when the user wants to preserve, search, or inspect project
  context but has not selected a specific archive mechanism.
---

<skill name="archive-manager" version="2.0.0">
  <metadata>
    <keywords>archive, router, context, history, memory, indexing</keywords>
  </metadata>

  <goal>Select and dispatch the correct archive capability based on the requested context operation.</goal>

  <core_principles>
    <principle name="Intent-Based Routing">
      <rule>Route based on the data type and retrieval intent, not tool familiarity.</rule>
      <rule>Choose one primary archive path first, then compose with others only when needed.</rule>
    </principle>

    <principle name="Storage Awareness">
      <rule>Keep archive outputs project-scoped unless explicitly requested otherwise.</rule>
      <rule>Prefer deterministic paths under Agent-Context/Archives.</rule>
    </principle>

    <principle name="Traceable Hand-Offs">
      <rule>State which archive skill is selected and what artifact will be produced.</rule>
    </principle>

    <principle name="Prefer Best-Fit MCP First">
      <rule>When an archive skill has a clear MCP equivalent, use the MCP path first and keep the local archive implementation as the fallback.</rule>
      <rule>Current preferred mappings are Serena for archive-code, RAGDocs for archive-docs, CodeGraph for archive-graph, and Memory MCP for archive-memory.</rule>
      <rule>When routing to archive-code, use the client-native Serena stdio server if it is already available; otherwise fall back to archive-code's ripgrep path and do not start shared Serena HTTP.</rule>
    </principle>

    <principle name="Archive Lifecycle Enforcement">
      <rule>For substantial setup, planning, research, handoff, release, architecture, or long-running project work, update project continuity or archive notes when an active archive system exists.</rule>
      <rule>For meaningful code/docs/config changes, index changed artifacts when the archive mechanism exists and the change will matter to future agents or humans.</rule>
      <rule>Do not force archive updates for trivial edits, typo fixes, small comment changes, or narrow mechanical changes with no lasting context value.</rule>
      <rule>Prefer archive-first retrieval when archive freshness is adequate; fall back to direct file reads only when needed.</rule>
    </principle>
  </core_principles>

  <workflow>
    <step number="0" name="Identify Archive Event">
      <instruction>Classify substantial requests into one of the canonical events: setup, planning, research, handoff, release, architecture, or long-running project work.</instruction>
      <instruction>For meaningful implementation/refactor/fix activity, treat completion-time indexing as part of the release event. Skip archive writes for trivial edits with no durable context value.</instruction>
    </step>

    <step number="1" name="Classify Archive Need">
      <question>Need symbol index/navigation? Route to archive-code.</question>
      <question>Need semantic document retrieval? Route to archive-docs.</question>
      <question>Need repository evolution/history? Route to archive-git.</question>
      <question>Need structural code graph? Route to archive-graph.</question>
      <question>Need durable decision/context store? Route to archive-memory.</question>
      <instruction>Prefer Serena for archive-code, RAGDocs for archive-docs, CodeGraph for archive-graph, and Memory MCP for archive-memory when those servers are available.</instruction>
      <instruction>If the route is archive-code, prefer native Serena when available; if Serena is unavailable or not project-activated, use ripgrep and report the client restart or project activation needed.</instruction>
      <question>Is this retrieval-only, post-change indexing, or both?</question>
    </step>

    <step number="2" name="Dispatch to Specialized Skill">
      <decision_tree>
        <branch condition="Code symbol navigation">archive-code</branch>
        <branch condition="Document embedding and semantic search">archive-docs</branch>
        <branch condition="Git history or commit tracing">archive-git</branch>
        <branch condition="Structural node/edge code graph">archive-graph</branch>
        <branch condition="Persistent key/value memory context">archive-memory</branch>
      </decision_tree>
    </step>

    <step number="3" name="Record Archive Contract">
      <instruction>Capture chosen skill, project path, output path, retrieval command, and freshness status.</instruction>
      <instruction>Record whether the request used the preferred MCP path or the local archive fallback.</instruction>
    </step>

    <step number="4" name="Enforce Archive Read/Write Policy">
      <instruction>If substantial code/docs/config changed, execute relevant archive writes before completion.</instruction>
      <instruction>For context gathering, use fresh archives first; if stale/missing, read source files then refresh archives.</instruction>
    </step>
  </workflow>

  <best_practices>
    <do>Use archive-code and archive-graph together for deep structural analysis</do>
    <do>Prefer Serena, RAGDocs, CodeGraph, and Memory MCP for their matching archive lanes before falling back to local scripts</do>
    <do>Use archive-memory for decisions and archive-docs for long-form references</do>
    <do>Pair archive-git with other archives when validating historical context</do>
    <dont>Store the same payload redundantly in every archive store</dont>
    <dont>Route to multiple archive skills before clarifying retrieval intent</dont>
  </best_practices>

  <related_skills>
    <skill>archive-code</skill>
    <skill>archive-docs</skill>
    <skill>archive-git</skill>
    <skill>archive-graph</skill>
    <skill>archive-memory</skill>
  </related_skills>
</skill>
```
