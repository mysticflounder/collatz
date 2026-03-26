# Ghost Cycles of the Syracuse Map

Computational code accompanying the paper:

> **Ghost Cycles of the Syracuse Map: 2-Adic Periodic Orbits and the Exceptional Set**
> Adam McKenna, March 2026
> DOI: [10.5281/zenodo.18949342](https://doi.org/10.5281/zenodo.18949342)

## Setup

**Requirements:** Python 3.11+, with `numpy`, `scipy`, `matplotlib`, `gmpy2`.

```bash
# Clone the repo
git clone https://github.com/mysticflounder/collatz.git
cd collatz

# Create and activate a virtual environment
python3 -m venv .venv
source .venv/bin/activate

# Install the package and dependencies
pip install -e ".[dev]"
```

## Running the Tests

```bash
pytest tests/
```

All 113 tests should pass. The test suite covers transfer matrix construction,
Fredholm coefficients, cycle detection, v-distribution, and 2-adic local constancy.

## Reproducing Paper Results

Each script corresponds to a section of the paper. Run from the repo root:

```bash
scripts/run_analysis.sh analysis/<script>.py
```

### §6 — Exhaustive Cycle Enumeration (Table 1, Figure 1)
```bash
scripts/run_analysis.sh analysis/cycle_search_extended.py
```
Enumerates all modular cycles through k = 36 (~34 billion residues).
Reproduces the exceptional set E ∩ [3, 36] = {10, 11, 12, 20, 35}.

### §7 — Ghost Cycles as 2-Adic Periodic Orbits
```bash
scripts/run_analysis.sh analysis/baker_wustholz_verification.py
```
Verifies Baker–Wüstholz bounds on ghost cycle denominators and confirms
case-(a) persistence at arithmetic progressions of levels through k = 200.

### §8 — Census of Materializing Ghost Types (Table 2)
```bash
scripts/run_analysis.sh analysis/ghost_census.py
scripts/run_analysis.sh analysis/census_summary.py
```
Enumerates all 157,909 canonical case-(a) ghost types through L = 12,
identifies the 88+ materializing types, and prints the summary table.

### §8 — Independent Materialization Verification
```bash
scripts/run_analysis.sh analysis/verify_materializations.py
```
Independently constructs each materializing ghost cycle from scratch and
verifies the valuation pattern, distinctness, and closure conditions.

### §9 — Density of E and Spectral Radius (Conjectures 2–4)
```bash
scripts/run_analysis.sh analysis/density_model.py
```
Computes the product formula lower bound δ(E) ≥ 10.0% and empirical
density through k = 1000. Verifies Conjecture 4 (negative rationality)
for all 5,996 canonical D < 0 ghost types through L = 12.

### §9 — Universal Case-(a) Survey (Conjecture 1)
```bash
scripts/run_analysis.sh analysis/universal_case_a_survey.py
```
Verifies exhaustively through L = 15 and by sampling through L = 20
that every composition is case-(a). Zero failures across ~85 million samples.

### §10 — Eigenvalue Spectra (Table 3)
```bash
scripts/run_analysis.sh analysis/spectrum_analysis.py
```
Computes dense eigenvalue spectra of P_k for k = 3, …, 15.
Confirms σ(P_k) = {0, 1/4} for all non-exceptional k in this range.

### §12 — Archimedean Non-Compactness (Discussion)
```bash
scripts/run_analysis.sh analysis/archimedean_non_compactness.py
```
Verifies the non-equicontinuity proof that L is **not compact** on
C(Z_2^odd, R). For each 2-adic scale r = 1..16, exhibits an explicit
witness pair (x, y) with x ≡ 1 (mod 3), y ≡ 2 (mod 3), |x − y|_2 = 2^{−r},
and a test function f (‖f‖_∞ ≤ 1) such that |(Lf)(x) − (Lf)(y)| = 1
independent of r. Confirms branch disjointness and convergence of partial
sums to the exact values 1/3 and 2/3. No dependencies beyond the standard
library (uses `fractions.Fraction` for exact arithmetic).

### Figures
```bash
scripts/run_analysis.sh analysis/visualizations.py
```
Regenerates all figures in `analysis/figures/`, including the chord diagrams
(`ghost_contrast.png`) and ghost timeline (`ghost_timeline.png`).

## Repository Structure

```
analysis/           Analysis scripts (Paper A)
analysis/figures/   Generated figures
analysis/data/      Cached computation results (JSON)
analysis/archive/   Exploratory scripts (not part of the paper)
collatz/            Python package (core, residue, stats, visualize)
docs/               Paper source (Markdown/LaTeX) and proofs
notebooks/          Jupyter notebooks for interactive exploration
scripts/            Helper scripts (run_analysis.sh, build-paper.sh)
tests/              Test suite (113 tests)
```

## Building the Paper PDF

Requires [Pandoc](https://pandoc.org/) and a LaTeX distribution.

```bash
scripts/build-paper.sh
# Output: docs/arxiv-paper-a.pdf
```

## License

[MIT](LICENSE)
