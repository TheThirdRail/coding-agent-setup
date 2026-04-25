# Legacy Lane: archive-docs

Vendor: OpenAI Codex
Router: `archive-manager`
Source archive: `.\Agent\OpenAI\deprecated-Skills\archive-docs\SKILL.md`
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
# Skill: archive-docs
Attributes: name="archive-docs", version="2.0.0"

## Metadata (`metadata`)

- `keywords`: archive, docs, embeddings, chromadb, semantic-search, knowledge-base

## Spec Contract (`spec_contract`)

- `id`: archive-docs

- `name`: archive-docs

- `version`: 2.0.0

- `last_updated`: 2026-02-09

- `purpose`: Preserve searchable project documentation context using RAGDocs first and the local Chroma archive as the fallback.

### Inputs (`inputs`)

- `input`: User request and relevant project context.

### Outputs (`outputs`)

- `output`: Completed guidance, actions, or artifacts produced by this skill.

### Triggers (`triggers`)

- `trigger`: Use when the frontmatter description conditions are met.

- `procedure`: Follow the ordered steps in the workflow section.

### Edge Cases (`edge_cases`)

- `edge_case`: If required context is missing, gather or request it before continuing.

### Safety Constraints (`safety_constraints`)

- `constraint`: Avoid destructive operations without explicit user intent.

### Examples (`examples`)

- `example`: Activate this skill when the request matches its trigger conditions.

- `goal`: Preserve searchable project documentation context using embedding-based retrieval.

## Core Principles (`core_principles`)

### Principle (`principle`)
Attributes: name="Semantic Retrieval Over Keyword-Only Search"

- `rule`: Index documents with metadata to support meaning-based lookup.

- `rule`: Use consistent document IDs for stable updates and deletions.

### Principle (`principle`)
Attributes: name="Traceable Sources"

- `rule`: Include metadata like source path, topic, and timestamp when adding documents.

- `rule`: Keep original source text accessible outside the vector store.

### Principle (`principle`)
Attributes: name="Project-Scoped Persistence"

- `rule`: Persist vectors in [PROJECT_PATH]/Agent-Context/Archives/chroma.

### Principle (`principle`)
Attributes: name="Prefer RAGDocs MCP When Available"

- `rule`: Use RAGDocs MCP first for fast semantic indexing and retrieval when the server is available.

- `rule`: Fall back to the local archive-docs scripts when RAGDocs is unavailable or when you need deterministic local archive maintenance.

## Workflow (`workflow`)

### Step (`step`)
Attributes: number="0", name="Choose Retrieval Mode"

- `instruction`: Use RAGDocs MCP first for semantic search and lightweight document indexing.

- `instruction`: Use the local Chroma-based scripts when MCP is unavailable or when you need stable local add, replace, and delete behavior.

### Step (`step`)
Attributes: number="1", name="Install Prerequisites"

- `command`: pip install chromadb sentence-transformers

### Step (`step`)
Attributes: number="2", name="Add Documents"

- `command`: python Agent\OpenAI\Skills\archive-docs\scripts\add.py --id "doc-id" --content "Document text" --metadata "{\"source\":\"docs/architecture.md\"}"

- `command`: python Agent\OpenAI\Skills\archive-docs\scripts\add.py --file "docs/architecture.md" --id "architecture"

### Step (`step`)
Attributes: number="3", name="Search Semantically"

- `command`: python Agent\OpenAI\Skills\archive-docs\scripts\search.py --query "authentication flow" --limit 5

### Step (`step`)
Attributes: number="4", name="Delete or Replace Stale Entries"

- `command`: python Agent\OpenAI\Skills\archive-docs\scripts\delete.py --id "doc-id"

## Resources (`resources`)

- `script` (file="scripts/add.py"): Add or update archived documentation entries.

- `script` (file="scripts/search.py"): Semantic search over archived documents.

- `script` (file="scripts/delete.py"): Delete archived document entries by ID.

## Best Practices (`best_practices`)

- `do`: Use deterministic IDs so updates replace the right document

- `do`: Attach source metadata for every document entry

- `do`: Batch related docs by topic for better retrieval quality

- `do`: Use RAGDocs MCP for day-to-day semantic retrieval, then use the local scripts when you need explicit local archive maintenance

- `dont`: Index transient or generated noise files without curation

- `dont`: Rely on embeddings alone when exact command/code matches are required

## Related Skills (`related_skills`)

- `skill`: archive-manager

- `skill`: research

- `skill`: documentation-generator
```
