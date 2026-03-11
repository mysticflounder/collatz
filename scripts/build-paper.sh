#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

PANDOC_OPTS="--pdf-engine=pdflatex --number-sections -V geometry:margin=1in -V fontsize=11pt -V documentclass=article --highlight-style=tango --resource-path=."

# Paper A: Ghost Cycles + Transfer Operator (merged)
pandoc docs/arxiv-paper-a.md -o docs/arxiv-paper-a.pdf $PANDOC_OPTS
echo "Built docs/arxiv-paper-a.pdf"

echo "All papers built successfully."
