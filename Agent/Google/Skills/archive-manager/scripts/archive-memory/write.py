#!/usr/bin/env python3
"""Write a memory to the local SQLite archive."""

import argparse
import sqlite3

from pathlib import Path
from datetime import datetime


def get_db_path(project_path=None):
    """Get the path to the memory database."""
    if project_path:
        root = Path(project_path)
    else:
        root = Path.cwd()
    return root / "Agent-Context" / "Archives" / "memory.db"


def init_db(conn):
    """Initialize the database schema."""
    conn.execute("""
        CREATE TABLE IF NOT EXISTS memories (
            id INTEGER PRIMARY KEY,
            category TEXT NOT NULL,
            key TEXT NOT NULL,
            value TEXT NOT NULL,
            created_at TEXT DEFAULT CURRENT_TIMESTAMP,
            updated_at TEXT DEFAULT CURRENT_TIMESTAMP,
            UNIQUE(category, key)
        )
    """)
    conn.commit()


def main():
    parser = argparse.ArgumentParser(description="Write memory to archive")
    parser.add_argument(
        "--category",
        required=True,
        choices=["decisions", "patterns", "files", "context", "custom"],
        help="Memory category",
    )
    parser.add_argument("--key", required=True, help="Unique key")
    parser.add_argument("--value", required=True, help="Content to store")
    parser.add_argument("--project-path", help="Path to the project root")
    args = parser.parse_args()

    db_path = get_db_path(args.project_path)
    db_path.parent.mkdir(parents=True, exist_ok=True)

    conn = sqlite3.connect(str(db_path))
    init_db(conn)

    # Upsert
    conn.execute(
        """
        INSERT INTO memories (category, key, value, updated_at)
        VALUES (?, ?, ?, ?)
        ON CONFLICT(category, key) DO UPDATE SET
            value = excluded.value,
            updated_at = excluded.updated_at
    """,
        (args.category, args.key, args.value, datetime.now().isoformat()),
    )
    conn.commit()
    conn.close()

    print(f"Stored memory: [{args.category}] {args.key}")


if __name__ == "__main__":
    main()
