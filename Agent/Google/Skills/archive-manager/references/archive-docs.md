# Legacy Lane: archive-docs

Vendor: Google Antigravity
Router: `archive-manager`
Source archive: `.\Agent\Google\deprecated-Skills\archive-docs\SKILL.md`
Consolidated: 2026-04-25

The content below is the former installable skill or workflow body, preserved as an on-demand lane reference.

```markdown
---
name: archive-docs
description: |
  Store and search project documents semantically, preferring RAGDocs MCP when
  available and falling back to the local Chroma archive scripts. Use when you
  need retrieval-ready documentation memory for design notes, architecture
  explanations, runbooks, and long-form references.
---

<skill name="archive-docs" version="2.0.0">
  <metadata>
    <keywords>archive, docs, embeddings, chromadb, semantic-search, knowledge-base</keywords>
  </metadata>

  <goal>Preserve searchable project documentation context using RAGDocs first and the local Chroma archive as the fallback.</goal>

  <core_principles>
    <principle name="Semantic Retrieval Over Keyword-Only Search">
      <rule>Index documents with metadata to support meaning-based lookup.</rule>
      <rule>Use consistent document IDs for stable updates and deletions.</rule>
    </principle>

    <principle name="Traceable Sources">
      <rule>Include metadata like source path, topic, and timestamp when adding documents.</rule>
      <rule>Keep original source text accessible outside the vector store.</rule>
    </principle>

    <principle name="Project-Scoped Persistence">
      <rule>Persist vectors in [PROJECT_PATH]/Agent-Context/Archives/chroma.</rule>
    </principle>

    <principle name="Prefer RAGDocs MCP When Available">
      <rule>Use RAGDocs MCP first for fast semantic indexing and retrieval when the server is available.</rule>
      <rule>Fall back to the local archive-docs scripts when RAGDocs is unavailable or when you need deterministic local archive maintenance.</rule>
    </principle>
  </core_principles>

  <workflow>
    <step number="0" name="Choose Retrieval Mode">
      <instruction>Use RAGDocs MCP first for semantic search and lightweight document indexing.</instruction>
      <instruction>Use the local Chroma-based scripts when MCP is unavailable or when you need stable local add, replace, and delete behavior.</instruction>
    </step>

    <step number="1" name="Install Prerequisites">
      <command>pip install chromadb sentence-transformers</command>
    </step>

    <step number="2" name="Add Documents">
      <command>python Agent\Google\Skills\archive-docs\scripts\add.py --id "doc-id" --content "Document text" --metadata "{\"source\":\"docs/architecture.md\"}"</command>
      <command>python Agent\Google\Skills\archive-docs\scripts\add.py --file "docs/architecture.md" --id "architecture"</command>
    </step>

    <step number="3" name="Search Semantically">
      <command>python Agent\Google\Skills\archive-docs\scripts\search.py --query "authentication flow" --limit 5</command>
    </step>

    <step number="4" name="Delete or Replace Stale Entries">
      <command>python Agent\Google\Skills\archive-docs\scripts\delete.py --id "doc-id"</command>
    </step>
  </workflow>

  <resources>
    <script file="scripts/add.py">Add or update archived documentation entries.</script>
    <script file="scripts/search.py">Semantic search over archived documents.</script>
    <script file="scripts/delete.py">Delete archived document entries by ID.</script>
  </resources>

  <best_practices>
    <do>Use deterministic IDs so updates replace the right document</do>
    <do>Attach source metadata for every document entry</do>
    <do>Batch related docs by topic for better retrieval quality</do>
    <do>Use RAGDocs MCP for day-to-day semantic retrieval, then use the local scripts when you need explicit local archive maintenance</do>
    <dont>Index transient or generated noise files without curation</dont>
    <dont>Rely on embeddings alone when exact command/code matches are required</dont>
  </best_practices>

  <related_skills>
    <skill>archive-manager</skill>
    <skill>research-capability</skill>
    <skill>documentation-generator</skill>
  </related_skills>
</skill>
```
