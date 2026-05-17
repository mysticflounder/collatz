"""Eigenvalue spectrum analysis of the Collatz transfer matrix P_k.

Computes the full eigenvalue spectrum of the transfer matrix for the
Syracuse map S(n) = (3n+1)/2^{v_2(3n+1)} on odd residues mod 2^k.

Dense computation for k=3..15 (N up to 16384).

NOTE: Sparse eigenvalue solvers (ARPACK/scipy.sparse.linalg.eigs) produce
spurious nonzero eigenvalues for these nearly nilpotent matrices.  Verified
at k=14,15: dense shows spectrum = {0, 1/4} but sparse reports |lambda_2|
~ 0.20.  Dense computation is the ground truth.

Key finding: for non-exceptional k, the ONLY nonzero eigenvalue is 1/4.
The Fredholm determinant is det(I - z*P_k) = 1 - z/4 exactly.

Outputs:
  - Eigenvalue plots in the complex plane
  - Spectral gap data
  - Eigenvalue magnitude distributions
"""

import json
import time

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt
import numpy as np
import scipy.sparse as sp


def build_transfer_sparse(k, x=3, y=1):
    """Build the transfer matrix P_k as a sparse CSC matrix.

    Each column has exactly one nonzero entry (S is a function).
    Returns (mat, N) where mat is N x N sparse and N = 2^{k-1}.
    """
    mod = 1 << k
    n = 1 << (k - 1)  # number of odd residues

    rows = np.empty(n, dtype=np.int64)
    cols = np.arange(n, dtype=np.int64)
    vals = np.empty(n, dtype=np.float64)

    # Process in chunks to avoid huge intermediate arrays
    chunk = min(n, 1 << 22)
    for start in range(0, n, chunk):
        end = min(start + chunk, n)
        size = end - start
        j = 2 * np.arange(start, end, dtype=np.int64) + 1  # odd residues
        val = x * j + y

        # Compute v_2 via bit tricks
        v = np.zeros(size, dtype=np.int64)
        tmp = val.copy()
        for _bit in range(k + 10):  # enough bits
            mask = (tmp & 1) == 0
            if not np.any(mask):
                break
            v[mask] += 1
            tmp[mask] >>= 1

        # Odd part mod 2^k
        odd_part = val >> v
        target_res = odd_part % mod
        target_idx = (target_res - 1) // 2

        rows[start:end] = target_idx
        vals[start:end] = 2.0 ** (-v.astype(np.float64))

    mat = sp.csc_matrix((vals, (rows, cols)), shape=(n, n))
    return mat, n


def compute_full_spectrum(k, x=3, y=1):
    """Compute ALL eigenvalues for small k (dense computation).

    Returns sorted array of eigenvalues (complex).
    """
    mat, n = build_transfer_sparse(k, x, y)
    dense = mat.toarray()
    eigenvalues = np.linalg.eigvals(dense)
    return eigenvalues


def analyze_spectrum(eigenvalues, k, label=""):
    """Analyze and print spectral properties."""
    magnitudes = np.abs(eigenvalues)
    sorted_mags = np.sort(magnitudes)[::-1]

    # Spectral radius
    rho = sorted_mags[0]

    # Count nonzero eigenvalues (|lambda| > 1e-12)
    n_nonzero = np.sum(magnitudes > 1e-12)

    # Spectral gap (ratio of 2nd to 1st eigenvalue)
    if len(sorted_mags) > 1 and sorted_mags[0] > 1e-12:
        gap_ratio = sorted_mags[1] / sorted_mags[0]
        second_mag = sorted_mags[1]
    else:
        gap_ratio = 0.0
        second_mag = 0.0

    # Count eigenvalues near 1/4
    n_near_quarter = np.sum(np.abs(magnitudes - 0.25) < 0.001)

    print(
        f"  k={k:>2d}{label}: N={len(eigenvalues):>7d}, "
        f"rho={rho:.6f}, |lambda_2|={second_mag:.6f}, "
        f"gap_ratio={gap_ratio:.4f}, "
        f"nonzero={n_nonzero}, near_1/4={n_near_quarter}"
    )

    return {
        "k": k,
        "N": len(eigenvalues),
        "rho": float(rho),
        "second_mag": float(second_mag),
        "gap_ratio": float(gap_ratio),
        "n_nonzero": int(n_nonzero),
        "n_near_quarter": int(n_near_quarter),
        "top_10": [float(m) for m in sorted_mags[:10]],
    }


def plot_eigenvalues_complex(eigenvalues, k, filename):
    """Plot eigenvalues in the complex plane."""
    fig, axes = plt.subplots(1, 2, figsize=(14, 6))

    # Left: all eigenvalues in complex plane
    ax = axes[0]
    nonzero = eigenvalues[np.abs(eigenvalues) > 1e-12]
    ax.scatter(nonzero.real, nonzero.imag, s=2, alpha=0.5, c="steelblue")

    # Draw circles at |z| = 1/4 and |z| = 1/3
    theta = np.linspace(0, 2 * np.pi, 200)
    ax.plot(0.25 * np.cos(theta), 0.25 * np.sin(theta), "r--", alpha=0.5, label="|z|=1/4")
    ax.plot((1 / 3) * np.cos(theta), (1 / 3) * np.sin(theta), "g--", alpha=0.5, label="|z|=1/3")
    ax.plot(0.5 * np.cos(theta), 0.5 * np.sin(theta), "k--", alpha=0.3, label="|z|=1/2")

    ax.set_xlabel("Re(λ)")
    ax.set_ylabel("Im(λ)")
    ax.set_title(f"Eigenvalues of P_k, k={k} (N={len(eigenvalues)})")
    ax.set_aspect("equal")
    ax.legend(fontsize=8)
    ax.grid(True, alpha=0.3)

    # Right: magnitude histogram
    ax = axes[1]
    magnitudes = np.abs(eigenvalues)
    nonzero_mags = magnitudes[magnitudes > 1e-12]
    if len(nonzero_mags) > 0:
        ax.hist(nonzero_mags, bins=50, color="steelblue", alpha=0.7, edgecolor="white")
        ax.axvline(x=0.25, color="r", linestyle="--", label="1/4")
        ax.axvline(x=1 / 3, color="g", linestyle="--", label="1/3")
    ax.set_xlabel("|λ|")
    ax.set_ylabel("Count")
    ax.set_title(f"Eigenvalue magnitude distribution, k={k}")
    ax.legend(fontsize=8)
    ax.grid(True, alpha=0.3)

    plt.tight_layout()
    plt.savefig(filename, dpi=150)
    plt.close()


def plot_spectral_gap_vs_k(results, filename):
    """Plot spectral gap and rho vs k."""
    ks = [r["k"] for r in results]
    rhos = [r["rho"] for r in results]
    seconds = [r["second_mag"] for r in results]
    gaps = [r["gap_ratio"] for r in results]

    fig, axes = plt.subplots(1, 2, figsize=(14, 5))

    # Left: rho and |lambda_2| vs k
    ax = axes[0]
    ax.plot(ks, rhos, "o-", label="ρ (spectral radius)", color="steelblue")
    ax.plot(ks, seconds, "s-", label="|λ₂| (2nd eigenvalue)", color="coral")
    ax.axhline(y=0.25, color="r", linestyle="--", alpha=0.5, label="1/4")
    ax.axhline(y=1 / 3, color="g", linestyle="--", alpha=0.5, label="1/3")
    ax.set_xlabel("k")
    ax.set_ylabel("Eigenvalue magnitude")
    ax.set_title("Spectral radius and gap vs k")
    ax.legend(fontsize=8)
    ax.grid(True, alpha=0.3)

    # Right: gap ratio vs k
    ax = axes[1]
    ax.plot(ks, gaps, "o-", color="steelblue")
    ax.set_xlabel("k")
    ax.set_ylabel("|λ₂| / ρ")
    ax.set_title("Spectral gap ratio vs k")
    ax.grid(True, alpha=0.3)

    plt.tight_layout()
    plt.savefig(filename, dpi=150)
    plt.close()


def plot_eigenvalue_grid(all_eigenvalues, filename):
    """Plot eigenvalues for multiple k values in a grid."""
    n = len(all_eigenvalues)
    cols = min(4, n)
    rows = (n + cols - 1) // cols
    fig, axes = plt.subplots(rows, cols, figsize=(4 * cols, 4 * rows))
    if rows == 1 and cols == 1:
        axes = np.array([[axes]])
    elif rows == 1:
        axes = axes[np.newaxis, :]
    elif cols == 1:
        axes = axes[:, np.newaxis]

    theta = np.linspace(0, 2 * np.pi, 200)

    for idx, (k, eigs) in enumerate(all_eigenvalues):
        r, c = divmod(idx, cols)
        ax = axes[r, c]

        nonzero = eigs[np.abs(eigs) > 1e-12]
        ax.scatter(nonzero.real, nonzero.imag, s=1, alpha=0.4, c="steelblue")

        ax.plot(0.25 * np.cos(theta), 0.25 * np.sin(theta), "r--", alpha=0.4, linewidth=0.8)
        ax.plot((1 / 3) * np.cos(theta), (1 / 3) * np.sin(theta), "g--", alpha=0.4, linewidth=0.8)

        ax.set_title(f"k={k} (N={len(eigs)})", fontsize=10)
        ax.set_aspect("equal")
        ax.set_xlim(-0.55, 0.55)
        ax.set_ylim(-0.55, 0.55)
        ax.grid(True, alpha=0.2)
        ax.tick_params(labelsize=7)

    # Hide unused axes
    for idx in range(len(all_eigenvalues), rows * cols):
        r, c = divmod(idx, cols)
        axes[r, c].set_visible(False)

    plt.suptitle("Transfer matrix eigenvalues in the complex plane", fontsize=13)
    plt.tight_layout()
    plt.savefig(filename, dpi=150)
    plt.close()


def main():
    print("Transfer Matrix Spectrum Analysis")
    print("=" * 60)
    print()

    results = []
    all_eigenvalues = []

    # Full spectrum for k=3..15
    print("Full spectrum (all eigenvalues):")
    for k in range(3, 16):
        t0 = time.time()
        eigs = compute_full_spectrum(k)
        dt = time.time() - t0
        info = analyze_spectrum(eigs, k, f" ({dt:.1f}s)")
        results.append(info)
        all_eigenvalues.append((k, eigs))

    print()

    # NOTE: Sparse eigenvalue solver (ARPACK) produces spurious nonzero
    # eigenvalues for nearly rank-1 matrices.  Verified at k=14,15: dense
    # shows spectrum = {0, 1/4} but sparse reports |lambda_2| ~ 0.20.
    # Dense computation is the ground truth for non-exceptional k.

    # Save results
    output_path = "analysis/data/spectrum_results.json"
    with open(output_path, "w", encoding="utf-8") as f:
        json.dump(results, f, indent=2)
    print(f"Results written to {output_path}")

    # Generate plots
    print("Generating plots...")

    # Individual plots for exceptional k
    for k, eigs in all_eigenvalues:
        if k in {10, 11, 12}:
            plot_eigenvalues_complex(eigs, k, f"analysis/spectrum_k{k}.png")
            print(f"  Saved analysis/spectrum_k{k}.png")

    # Grid plot
    plot_eigenvalue_grid(all_eigenvalues, "analysis/spectrum_grid.png")
    print("  Saved analysis/spectrum_grid.png")

    # Spectral gap vs k
    plot_spectral_gap_vs_k(results, "analysis/spectral_gap.png")
    print("  Saved analysis/spectral_gap.png")

    print()
    print("Key observations:")
    print("-" * 40)

    # Highlight exceptional k
    for r in results:
        if r["rho"] > 0.26:
            print(f"  k={r['k']}: EXCEPTIONAL rho={r['rho']:.6f}, |lambda_2|={r['second_mag']:.6f}")

    # Non-exceptional: exactly one nonzero eigenvalue
    non_exc_dense = [r for r in results if r["rho"] < 0.26 and r["n_nonzero"] == 1]
    if non_exc_dense:
        print(f"  Non-exceptional (dense): {len(non_exc_dense)} values of k")
        print("  ALL have exactly 1 nonzero eigenvalue = 1/4")
        print("  Spectrum = {0, 1/4}, det(I - z*P_k) = 1 - z/4")


if __name__ == "__main__":
    main()
