#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

PANDOC_OPTS="--pdf-engine=pdflatex --number-sections -V geometry:margin=1in -V fontsize=11pt -V documentclass=article --highlight-style=tango"

# Paper 1: 2-Adic Local Constancy
pandoc docs/collatz-local-constancy.md -o docs/collatz-local-constancy.pdf $PANDOC_OPTS
echo "Built docs/collatz-local-constancy.pdf"

# Paper 2: Transfer Operator Spectral Theory
pandoc docs/collatz-transfer-operator.md -o docs/collatz-transfer-operator.pdf $PANDOC_OPTS
echo "Built docs/collatz-transfer-operator.pdf"

# Paper 3: Ghost Cycles as 2-Adic Periodic Orbits
pandoc docs/collatz-ghost-cycles.md -o docs/collatz-ghost-cycles.pdf $PANDOC_OPTS
echo "Built docs/collatz-ghost-cycles.pdf"

echo "All papers built successfully."
