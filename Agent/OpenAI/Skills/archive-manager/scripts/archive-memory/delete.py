#!/usr/bin/env python3
"""Delete a memory from the local SQLite archive."""

import argparse
import sqlite3
import sys
from pathlib import Path


def get_db_path(project_path=None):
    """Get the path to the memory database."""
    if project_path:
        root = Path(project_path)
    else:
        root = Path.cwd()
    return root / "Agent-Context" / "Archives" / "memory.db"


def main():
    parser = argparse.ArgumentParser(description="Delete memory from archive")
    parser.add_argument("--category", required=True, help="Memory category")
    parser.add_argument("--key", required=True, help="Key to delete")
    parser.add_argument("--project-path", help="Path to the project root")
    args = parser.parse_args()

    db_path = get_db_path(args.project_path)
    if not db_path.exists():
        print("No memories found. Archive not initialized.")
        sys.exit(0)

    conn = sqlite3.connect(str(db_path))
    cursor = conn.cursor()
    cursor.execute(
        "DELETE FROM memories WHERE category=? AND key=?", (args.category, args.key)
    )
    conn.commit()

    if cursor.rowcount > 0:
        print(f"Deleted memory: [{args.category}] {args.key}")
    else:
        print(f"Memory not found: [{args.category}] {args.key}")

    conn.close()


if __name__ == "__main__":
    main()
