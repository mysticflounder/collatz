#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

PANDOC_OPTS="--pdf-engine=pdflatex --number-sections -V geometry:margin=1in -V fontsize=11pt -V documentclass=article --highlight-style=tango --resource-path=."

pandoc docs/collatz-local-constancy.md -o docs/collatz-local-constancy.pdf $PANDOC_OPTS
echo "Built docs/collatz-local-constancy.pdf"
