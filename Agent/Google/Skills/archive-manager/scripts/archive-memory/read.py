#!/usr/bin/env python3
"""Read memories from the local SQLite archive."""

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
    parser = argparse.ArgumentParser(description="Read memory from archive")
    parser.add_argument("--category", help="Memory category to filter by")
    parser.add_argument("--key", help="Specific key to retrieve")
    parser.add_argument("--search", help="Search term")
    parser.add_argument("--project-path", help="Path to the project root")
    args = parser.parse_args()

    db_path = get_db_path(args.project_path)
    if not db_path.exists():
        print("No memories found. Archive not initialized.")
        sys.exit(0)

    conn = sqlite3.connect(str(db_path))
    cursor = conn.cursor()

    if args.key and args.category:
        cursor.execute(
            "SELECT value FROM memories WHERE category=? AND key=?",
            (args.category, args.key),
        )
        row = cursor.fetchone()
        if row:
            print(row[0])
        else:
            print(f"Memory not found: [{args.category}] {args.key}")
    elif args.category:
        cursor.execute(
            "SELECT key, value FROM memories WHERE category=? ORDER BY updated_at DESC",
            (args.category,),
        )
        rows = cursor.fetchall()
        if rows:
            print(f"Memories in [{args.category}]:\n")
            for key, value in rows:
                preview = value[:100] + "..." if len(value) > 100 else value
                print(f"  {key}: {preview}")
        else:
            print(f"No memories in category: {args.category}")
    elif args.search:
        cursor.execute(
            """SELECT category, key, value FROM memories
                          WHERE value LIKE ? OR key LIKE ?
                          ORDER BY updated_at DESC""",
            (f"%{args.search}%", f"%{args.search}%"),
        )
        rows = cursor.fetchall()
        if rows:
            print(f"Search results for '{args.search}':\n")
            for cat, key, value in rows:
                preview = value[:80] + "..." if len(value) > 80 else value
                print(f"  [{cat}] {key}: {preview}")
        else:
            print(f"No memories matching: {args.search}")
    else:
        cursor.execute("SELECT category, COUNT(*) FROM memories GROUP BY category")
        rows = cursor.fetchall()
        print("Memory Archive Summary:\n")
        for cat, count in rows:
            print(f"  {cat}: {count} memories")

    conn.close()


if __name__ == "__main__":
    main()
