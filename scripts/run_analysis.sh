#!/usr/bin/env bash
# Run a collatz analysis script.
# Usage: scripts/run_analysis.sh analysis/<script_name>.py
#
# Python resolution order:
#   1. .venv/bin/python  (virtualenv at repo root)
#   2. venv/bin/python   (alternate venv name)
#   3. python3           (system python)
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

if   [ -f "$PROJECT_DIR/.venv/bin/python" ]; then
    PYTHON="$PROJECT_DIR/.venv/bin/python"
elif [ -f "$PROJECT_DIR/venv/bin/python" ]; then
    PYTHON="$PROJECT_DIR/venv/bin/python"
else
    PYTHON="python3"
fi

if [ $# -eq 0 ]; then
    echo "Usage: $0 analysis/<script>.py"
    echo "Available scripts:"
    ls "$PROJECT_DIR/analysis/"*.py 2>/dev/null | xargs -I{} basename {}
    exit 1
fi

exec "$PYTHON" "$PROJECT_DIR/$1"
