#!/usr/bin/env python3
"""Build a code knowledge graph using Tree-sitter and SQLite."""

import argparse
import sqlite3

from pathlib import Path
from tree_sitter_languages import get_parser


# Database Setup
def init_db(db_path):
    conn = sqlite3.connect(db_path)
    conn.execute("""
        CREATE TABLE IF NOT EXISTS nodes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            type TEXT NOT NULL,
            name TEXT NOT NULL,
            file_path TEXT NOT NULL,
            start_line INTEGER,
            end_line INTEGER,
            UNIQUE(file_path, name, start_line)
        )
    """)
    conn.execute("""
        CREATE TABLE IF NOT EXISTS edges (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            source_id INTEGER,
            target_id INTEGER,
            type TEXT NOT NULL, -- 'defines', 'calls', 'imports'
            FOREIGN KEY(source_id) REFERENCES nodes(id),
            FOREIGN KEY(target_id) REFERENCES nodes(id),
            UNIQUE(source_id, target_id, type)
        )
    """)
    return conn


# Parsing Logic
def parse_file(file_path, conn):
    ext = file_path.suffix.lower()
    lang_map = {
        ".py": "python",
        ".js": "javascript",
        ".ts": "typescript",
        ".tsx": "tsx",
        ".go": "go",
        ".rs": "rust",
        ".c": "c",
        ".cpp": "cpp",
        ".java": "java",
    }

    if ext not in lang_map:
        return

    lang_name = lang_map[ext]
    try:
        parser = get_parser(lang_name)
    except Exception as e:
        print(f"Skipping {file_path.name}: Language {lang_name} not available. ({e})")
        return

    try:
        content = file_path.read_bytes()
        tree = parser.parse(content)
    except Exception as e:
        print(f"Error parsing {file_path}: {e}")
        return

    cursor = conn.cursor()

    # Simple query to find definitions (customizable per language)
    # This is a simplified example; a full implementation would use specific S-expressions per language
    # For now, we use a generic AST walker for demonstration/MVP

    root_node = tree.root_node
    file_node_id = get_or_create_node(
        cursor, "file", file_path.name, str(file_path), 0, 0
    )

    walk_tree(root_node, cursor, file_node_id, str(file_path), content)
    conn.commit()


def get_or_create_node(cursor, type, name, file_path, start, end):
    cursor.execute(
        "SELECT id FROM nodes WHERE file_path=? AND name=? AND start_line=?",
        (file_path, name, start),
    )
    row = cursor.fetchone()
    if row:
        return row[0]

    cursor.execute(
        "INSERT INTO nodes (type, name, file_path, start_line, end_line) VALUES (?, ?, ?, ?, ?)",
        (type, name, file_path, start, end),
    )
    return cursor.lastrowid


def create_edge(cursor, source, target, type):
    cursor.execute(
        "INSERT OR IGNORE INTO edges (source_id, target_id, type) VALUES (?, ?, ?)",
        (source, target, type),
    )


def walk_tree(node, cursor, parent_id, file_path, content):
    # Heuristic mapping of node types to graph concepts
    node_type = node.type

    interesting_types = {
        "function_definition": "function",
        "class_definition": "class",
        "method_definition": "method",
        "identifier": "ref",
    }

    current_id = parent_id

    if node_type in interesting_types:
        # Extract name
        name_node = node.child_by_field_name("name")
        if not name_node:
            # Fallback for identifiers or nodes without named 'name' field
            if node_type == "identifier":
                name = content[node.start_byte : node.end_byte].decode("utf-8")
                # Identifiers are refs/calls, strictly speaking they are edges, but we treat them as nodes temporarily to link them
                # In a full graph, these would be edges to the definition.
                # For MVP, we'll skip identifiers as nodes and just note usage if we can resolve it.
                pass
            else:
                name = "anon"
        else:
            name = content[name_node.start_byte : name_node.end_byte].decode("utf-8")

            # Create node
            type_label = interesting_types[node_type]
            if type_label != "ref":
                current_id = get_or_create_node(
                    cursor,
                    type_label,
                    name,
                    file_path,
                    node.start_point[0],
                    node.end_point[0],
                )
                # Link to parent (contains)
                create_edge(cursor, parent_id, current_id, "contains")

    # Recurse
    for child in node.children:
        walk_tree(child, cursor, current_id, file_path, content)


def main():
    parser = argparse.ArgumentParser(description="Build code graph")
    parser.add_argument("--path", required=True, help="Project root path")
    args = parser.parse_args()

    project_path = Path(args.path)
    # Store graph.db inside the project's Agent-Context
    db_path = project_path / "Agent-Context" / "Archives" / "graph.db"
    db_path.parent.mkdir(parents=True, exist_ok=True)

    conn = init_db(str(db_path))

    project_path = Path(args.path)
    print(f"Indexing {project_path}...")

    count = 0
    for file_path in project_path.rglob("*"):
        if file_path.is_file() and not any(
            p in file_path.parts for p in [".git", "node_modules", "__pycache__"]
        ):
            parse_file(file_path, conn)
            count += 1
            if count % 10 == 0:
                print(f"Processed {count} files...", end="\r")

    print(f"\nGraph built successfully. DB: {db_path}")


if __name__ == "__main__":
    main()
