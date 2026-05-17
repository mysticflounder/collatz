"""
Archimedean Mahler row norms: compactness test for the transfer operator.

Tests whether ||M_k[m,·]||_1 -> 0 as m -> inf (archimedean norm),
where M_k = C^{-1} P_k C, C[i,j] = binom(i,j) (Mahler basis matrix).

Row decay in archimedean norm is a sufficient condition for compactness
of L on C(Z_2^odd, R). If rows do NOT decay: L is likely non-compact.

Contrast with mahler_row_decay.py which tests 2-adic row decay
(v_2 values), used for the failed nuclearity program.

Sections:
  1. Exact Fraction computation of M_k columns
  2. Row norm accumulation (archimedean)
  3. Visualization and summary
"""

import os
import time
from fractions import Fraction
from math import comb

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt  # noqa: E402
import numpy as np  # noqa: E402

PLOT_DIR = os.path.dirname(__file__)


# ---------------------------------------------------------------------------
# Section 1: Column-by-column computation of M_k = C^{-1} P_k C
# ---------------------------------------------------------------------------
def build_transfer_sparse(k, x=3, y=1):
    """Build P_k in sparse form: list of (target_row, weight) per column."""
    mod = 2**k
    n = 2 ** (k - 1)
    sparse = []
    for j in range(n):
        odd_j = 2 * j + 1
        val = x * odd_j + y
        v = 0
        while val % 2 == 0:
            val //= 2
            v += 1
        target = val % mod
        target_idx = (target - 1) // 2
        sparse.append((target_idx, Fraction(1, 2**v)))
    return sparse


def matvec_pk(pk_sparse, vec_in):
    """Multiply P_k * vec (sparse)."""
    n = len(vec_in)
    result = [Fraction(0)] * n
    for j in range(n):
        if vec_in[j] != 0:
            row, weight = pk_sparse[j]
            result[row] += weight * vec_in[j]
    return result


def matvec_cinv(vec_in):
    """Multiply C^{-1} * vec, where C^{-1}[i,j] = (-1)^{i-j} binom(i,j)."""
    n = len(vec_in)
    result = [Fraction(0)] * n
    for i in range(n):
        s = Fraction(0)
        for j in range(i + 1):
            if vec_in[j] != 0:
                sign = 1 if (i - j) % 2 == 0 else -1
                s += sign * comb(i, j) * vec_in[j]
        result[i] = s
    return result


def column_of_c(j, n):
    """j-th column of C: C[i,j] = binom(i,j)."""
    col = [Fraction(0)] * n
    for i in range(j, n):
        col[i] = Fraction(comb(i, j))
    return col


def compute_mk_column_exact(k, j, pk_sparse):
    """Compute column j of M_k = C^{-1} P_k C exactly (Fraction arithmetic).

    Returns list of Fraction of length n = 2^{k-1}.
    """
    n = 2 ** (k - 1)
    c_j = column_of_c(j, n)
    pk_cj = matvec_pk(pk_sparse, c_j)
    return matvec_cinv(pk_cj)


# ---------------------------------------------------------------------------
# Section 2: Archimedean row norm accumulation
# ---------------------------------------------------------------------------
def compute_arch_row_norms(k, n_cols=None, verbose=True):
    """Compute archimedean row L1 and Linf norms of M_k.

    n_cols: number of columns to compute (None = all n columns).
    Returns: (row_l1, row_linf) arrays of length n.
    """
    n = 2 ** (k - 1)
    if n_cols is None:
        n_cols = n

    if verbose:
        print(f"  Building sparse P_{k} (n={n})...")
    pk_sparse = build_transfer_sparse(k)

    row_l1 = np.zeros(n, dtype=float)
    row_linf = np.zeros(n, dtype=float)

    t0 = time.time()
    for j in range(n_cols):
        col = compute_mk_column_exact(k, j, pk_sparse)
        for m in range(n):
            val = abs(float(col[m]))
            row_l1[m] += val
            if val > row_linf[m]:
                row_linf[m] = val
        if verbose and (j + 1) % max(1, n_cols // 10) == 0:
            elapsed = time.time() - t0
            eta = elapsed / (j + 1) * (n_cols - j - 1)
            print(f"    col {j + 1}/{n_cols} done, elapsed={elapsed:.1f}s, eta={eta:.0f}s")

    elapsed = time.time() - t0
    if verbose:
        print(f"  Computed {n_cols} columns in {elapsed:.1f}s")

    return row_l1, row_linf


def decay_summary(row_l1, row_linf, k, n_cols):
    """Print summary statistics for row decay."""
    n = len(row_l1)
    # Only consider rows that have nonzero contributions
    nonzero_mask = row_l1 > 1e-15

    print(f"\n{'=' * 60}")
    print(f"Archimedean row norm summary for k={k}, {n_cols} columns")
    print(f"{'=' * 60}")
    print(f"  n = {n}, columns tested = {n_cols}")

    if not np.any(nonzero_mask):
        print("  All rows are zero!")
        return

    # Split into early and late rows
    quarter = max(1, n // 4)
    early_l1 = row_l1[:quarter]
    late_l1 = row_l1[3 * quarter :]

    early_mean = np.mean(early_l1[early_l1 > 1e-15]) if np.any(early_l1 > 1e-15) else 0
    late_mean = np.mean(late_l1[late_l1 > 1e-15]) if np.any(late_l1 > 1e-15) else 0

    print("  L1 row norms:")
    print(f"    Early rows (m < {quarter}): mean = {early_mean:.6f}")
    print(f"    Late rows (m >= {3 * quarter}): mean = {late_mean:.6f}")
    print(f"    Ratio late/early = {late_mean / early_mean:.4f}" if early_mean > 0 else "")
    print(f"    Max = {row_l1.max():.6f} at row m={row_l1.argmax()}")
    print(f"    Min nonzero = {row_l1[row_l1 > 1e-15].min():.6f}")

    # Check for decay
    if late_mean < early_mean / 2:
        verdict = "DECAY OBSERVED (factor >= 2 decrease)"
    elif late_mean < early_mean:
        verdict = "WEAK DECAY (some decrease)"
    else:
        verdict = "NO DECAY (rows stay large)"
    print(f"  Verdict: {verdict}")

    # Print first 20 row L1 norms
    print("\n  First 20 row L1 norms:")
    for m in range(min(20, n)):
        print(f"    m={m:4d}: ||M_k[m,·]||_1 = {row_l1[m]:.8f}")

    # Print last 10 nonzero rows
    nonzero_rows = np.where(row_l1 > 1e-15)[0]
    if len(nonzero_rows) > 20:
        print("\n  Last 10 rows with nonzero L1 norm:")
        for m in nonzero_rows[-10:]:
            print(f"    m={m:4d}: ||M_k[m,·]||_1 = {row_l1[m]:.8f}")


# ---------------------------------------------------------------------------
# Section 3: Visualization
# ---------------------------------------------------------------------------
def plot_row_norms(results_by_k, n_cols_by_k):
    """Plot row L1 and Linf norms for each k."""
    fig, axes = plt.subplots(1, 2, figsize=(16, 7))

    for k, (row_l1, row_linf) in sorted(results_by_k.items()):
        n = len(row_l1)
        ms = np.arange(n)
        # Only plot nonzero rows
        mask = row_l1 > 1e-15
        label = f"k={k} ({n_cols_by_k[k]} cols)"
        axes[0].semilogy(
            ms[mask],
            row_l1[mask],
            "o-",
            markersize=2,
            alpha=0.7,
            label=label,
        )
        mask2 = row_linf > 1e-15
        axes[1].semilogy(
            ms[mask2],
            row_linf[mask2],
            "o-",
            markersize=2,
            alpha=0.7,
            label=label,
        )

    for ax, title, ylabel in [
        (axes[0], "L1 row norms of M_k", r"$\|M_k[m,\cdot]\|_1$"),
        (axes[1], "Linf row norms of M_k", r"$\|M_k[m,\cdot]\|_\infty$"),
    ]:
        ax.set_xlabel("Row m")
        ax.set_ylabel(ylabel)
        ax.set_title(f"Archimedean {title} (log scale)")
        ax.legend()
        ax.grid(True, alpha=0.3)

    plt.suptitle(
        "Archimedean row norms of Mahler representation $M_k = C^{-1}P_kC$\n"
        "Decay → compactness of L; no decay → non-compactness"
    )
    plt.tight_layout()
    path = os.path.join(PLOT_DIR, "mahler_arch_row_norms.png")
    plt.savefig(path, dpi=150)
    plt.close()
    print(f"\nSaved: {path}")


def plot_row_norm_comparison(results_by_k):
    """Plot row L1 norms across k values, normalized by max."""
    fig, ax = plt.subplots(figsize=(12, 7))

    for k, (row_l1, _) in sorted(results_by_k.items()):
        n = len(row_l1)
        ms = np.arange(n) / n  # Normalize x-axis to [0,1]
        mask = row_l1 > 1e-15
        if not np.any(mask):
            continue
        norm_factor = row_l1[mask].max()
        ax.plot(
            ms[mask],
            row_l1[mask] / norm_factor,
            "-",
            linewidth=1,
            alpha=0.8,
            label=f"k={k}",
        )

    ax.set_xlabel("Normalized row index m/n")
    ax.set_ylabel(r"$\|M_k[m,\cdot]\|_1$ / max")
    ax.set_title(
        "Normalized archimedean row norms across k\n"
        "(if shape is stable with k: indicates asymptotic behavior)"
    )
    ax.legend()
    ax.grid(True, alpha=0.3)
    plt.tight_layout()
    path = os.path.join(PLOT_DIR, "mahler_arch_row_normalized.png")
    plt.savefig(path, dpi=150)
    plt.close()
    print(f"Saved: {path}")


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------
def main():
    print("Archimedean Mahler Row Norm Test")
    print("=" * 60)
    print("Testing ||M_k[m,·]||_1 for decay as m -> inf.")
    print("(Archimedean = real absolute values, NOT 2-adic valuations.)\n")

    results_by_k = {}
    n_cols_by_k = {}

    # k=8: all 128 columns, exact arithmetic, fast
    # k=10: all 512 columns, exact arithmetic, ~5-15 min
    # k=12: first 64 columns only (to get a partial picture)
    schedule = [
        (8, None),  # all 128 cols
        (10, None),  # all 512 cols
        (12, 64),  # partial: first 64 cols (representative)
    ]

    for k, n_cols in schedule:
        n = 2 ** (k - 1)
        actual_cols = n if n_cols is None else min(n_cols, n)
        print(f"\n--- k={k} (n={n}, testing {actual_cols} columns) ---")
        row_l1, row_linf = compute_arch_row_norms(k, n_cols=actual_cols)
        results_by_k[k] = (row_l1, row_linf)
        n_cols_by_k[k] = actual_cols
        decay_summary(row_l1, row_linf, k, actual_cols)

    # Plots
    print("\n--- Generating plots ---")
    plot_row_norms(results_by_k, n_cols_by_k)
    plot_row_norm_comparison(results_by_k)

    print("\nDone.")
    print("\nInterpretation:")
    print("  If row L1 norms decrease with m: evidence FOR compactness")
    print("  If row L1 norms are flat or increasing: evidence AGAINST compactness")
    print("  Key comparison: early rows (small m) vs late rows (large m)")


if __name__ == "__main__":
    main()
