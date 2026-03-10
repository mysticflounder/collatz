#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

PANDOC_OPTS="--pdf-engine=pdflatex --number-sections -V geometry:margin=1in -V fontsize=11pt -V documentclass=article --highlight-style=tango"

# Paper A: Ghost Cycles + Transfer Operator (merged)
pandoc docs/arxiv-paper-a.md -o docs/arxiv-paper-a.pdf $PANDOC_OPTS
echo "Built docs/arxiv-paper-a.pdf"

# Paper B: 2-Adic Local Constancy
pandoc docs/collatz-local-constancy.md -o docs/collatz-local-constancy.pdf $PANDOC_OPTS
echo "Built docs/collatz-local-constancy.pdf"

# Legacy papers (kept for reference, not built by default)
# pandoc docs/collatz-transfer-operator.md -o docs/collatz-transfer-operator.pdf $PANDOC_OPTS
# pandoc docs/collatz-ghost-cycles.md -o docs/collatz-ghost-cycles.pdf $PANDOC_OPTS

echo "All papers built successfully."
