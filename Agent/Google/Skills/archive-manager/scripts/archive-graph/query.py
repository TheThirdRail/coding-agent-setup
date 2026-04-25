#!/usr/bin/env python3
"""Query the local code graph."""

import argparse
import sqlite3
import sys
from pathlib import Path


def get_db_path(project_path=None):
    if project_path:
        root = Path(project_path)
    else:
        root = Path.cwd()
    return root / "Agent-Context" / "Archives" / "graph.db"


def main():
    parser = argparse.ArgumentParser(description="Query code graph")
    parser.add_argument("--query", help="Text search for node names")
    parser.add_argument("--files", action="store_true", help="List all files")
    parser.add_argument(
        "--structure", help="Show structure of a specific file (by name pattern)"
    )
    parser.add_argument("--project-path", help="Path to the project root")
    args = parser.parse_args()

    db_path = get_db_path(args.project_path)
    if not db_path.exists():
        print("No graph database found. Run build.py first.")
        sys.exit(0)

    conn = sqlite3.connect(str(db_path))
    cursor = conn.cursor()

    if args.files:
        cursor.execute(
            "SELECT name, file_path FROM nodes WHERE type='file' ORDER BY name"
        )
        for name, path in cursor.fetchall():
            print(f"{name} ({path})")

    elif args.structure:
        # Find file node
        cursor.execute(
            "SELECT id, name FROM nodes WHERE type='file' AND name LIKE ?",
            (f"%{args.structure}%",),
        )
        file_node = cursor.fetchone()
        if not file_node:
            print(f"File not found matching: {args.structure}")
            sys.exit(0)

        print(f"Structure of {file_node[1]}:")

        # Recursive CTE to get structure
        # query = """
        # WITH RECURSIVE file_structure AS (
        #     SELECT id, type, name, 0 as level
        #     FROM nodes WHERE id = ?
        #     UNION ALL
        #     SELECT n.id, n.type, n.name, fs.level + 1
        #     FROM nodes n
        #     JOIN edges e ON e.target_id = n.id
        #     JOIN file_structure fs ON e.source_id = fs.id
        #     WHERE e.type = 'contains'
        # )
        # SELECT type, name, level FROM file_structure ORDER BY level, start_line
        # """
        # Note: start_line sort hack requires joining back to nodes, simplified for now

        # Simpler non-recursive query for immediate children (often sufficient for simple listing)
        cursor.execute(
            """
            SELECT n.type, n.name, n.start_line
            FROM nodes n
            JOIN edges e ON n.id = e.target_id
            WHERE e.source_id = ? AND e.type = 'contains'
            ORDER BY n.start_line
        """,
            (file_node[0],),
        )

        for type, name, line in cursor.fetchall():
            print(f"  [{line}] {type}: {name}")

    elif args.query:
        cursor.execute(
            """
            SELECT type, name, file_path, start_line
            FROM nodes
            WHERE name LIKE ?
            ORDER BY type, name
        """,
            (f"%{args.query}%",),
        )

        results = cursor.fetchall()
        if not results:
            print("No matching nodes found.")
        else:
            print(f"Nodes matching '{args.query}':\n")
            for type, name, path, line in results:
                print(f"  [{type}] {name} \t {Path(path).name}:{line}")

    conn.close()


if __name__ == "__main__":
    main()
