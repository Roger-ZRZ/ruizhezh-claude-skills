#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="$HOME/.claude/skills"

echo "=== SYNCING ==="
echo "FROM: $SOURCE_DIR"
echo "TO: $SCRIPT_DIR"
cp -r "$SOURCE_DIR"/. "$SCRIPT_DIR/"
