#!/usr/bin/env bash
# Run a collatz analysis script using the project venv.
# Usage: scripts/run_analysis.sh analysis/<script_name>.py
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
VENV_PYTHON="${PROJECT_DIR}/../../.venv/bin/python"

if [ $# -eq 0 ]; then
    echo "Usage: $0 analysis/<script>.py"
    echo "Available scripts:"
    ls "$PROJECT_DIR/analysis/"*.py 2>/dev/null | xargs -I{} basename {}
    exit 1
fi

exec "$VENV_PYTHON" "$PROJECT_DIR/$1"
