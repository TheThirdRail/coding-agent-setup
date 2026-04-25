#!/usr/bin/env python3
"""Search documents in the ChromaDB archive semantically."""

import argparse
import json
import sys
from pathlib import Path

try:
    import chromadb
    from chromadb.config import Settings
except ImportError:
    print(
        "Error: chromadb not installed. Run: pip install chromadb sentence-transformers"
    )
    sys.exit(1)


def get_archive_path(project_path=None):
    """Get the path to the chroma archive directory."""
    if project_path:
        root = Path(project_path)
    else:
        root = Path.cwd()
    return root / "Agent-Context" / "Archives" / "chroma"


def main():
    parser = argparse.ArgumentParser(description="Search documents semantically")
    parser.add_argument("--query", required=True, help="Search query")
    parser.add_argument("--limit", type=int, default=5, help="Max results")
    parser.add_argument("--project-path", help="Path to the project root")
    args = parser.parse_args()

    archive_path = get_archive_path(args.project_path)
    if not archive_path.exists():
        print("No documents archived yet.")
        sys.exit(0)

    client = chromadb.PersistentClient(
        path=str(archive_path), settings=Settings(anonymized_telemetry=False)
    )

    try:
        collection = client.get_collection("documents")
    except Exception:
        print("No documents archived yet.")
        sys.exit(0)

    # Search
    results = collection.query(
        query_texts=[args.query],
        n_results=args.limit,
        include=["documents", "metadatas", "distances"],
    )

    if not results["ids"][0]:
        print(f"No results for: {args.query}")
        sys.exit(0)

    print(f"Search results for: '{args.query}'\n")
    print("-" * 60)

    for i, (doc_id, doc, meta, dist) in enumerate(
        zip(
            results["ids"][0],
            results["documents"][0],
            results["metadatas"][0],
            results["distances"][0],
        )
    ):
        similarity = 1 - dist  # Convert distance to similarity
        print(f"\n[{i + 1}] {doc_id} (similarity: {similarity:.2%})")
        if meta:
            print(f"    Metadata: {json.dumps(meta)}")
        # Truncate long content
        preview = doc[:300] + "..." if len(doc) > 300 else doc
        print(f"    Content: {preview}")
        print()


if __name__ == "__main__":
    main()
