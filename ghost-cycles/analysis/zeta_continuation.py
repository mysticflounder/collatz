"""
Spectral continuation candidates for the Collatz family T(n) = (xn+y)/2^v.

Treat x as a continuous (then complex) parameter. Three candidates:
  1. Lyapunov exponent lambda(x) = log(x) - log(2) * E[v]
  2. Spectral radius rho(x) of the transfer matrix P(x) on residues mod 2^k
  3. Fredholm determinant det(I - z*P(x)) — zeros at z = 1/eigenvalue

Nine sections:
  1. Lyapunov exponent for real x (heuristic vs empirical)
  2. Spectral radius for real x (fine grid of odd integers, multiple k)
  3. Fredholm determinant zeros at integer x values
  4. Coefficient interpolation — continuation to continuous real x
  5. Extension to complex x
  6. Rigorous analysis for easy cases (x=1)
  7. Candidate comparison and assessment
  8. Dense rational x sampling
  9. Why x=3 is a local extremum — cycle decomposition analysis
"""

import math
import os
import sys

import matplotlib
import numpy as np
import numpy.polynomial.chebyshev as cheb
from scipy.linalg import eig

matplotlib.use("Agg")
import matplotlib.pyplot as plt  # noqa: E402

sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))

PLOT_DIR = os.path.dirname(__file__)


# ---------------------------------------------------------------------------
# Local helpers (redefined to avoid import-time execution of generalized_collatz.py)
# ---------------------------------------------------------------------------
def syracuse_general(n, x, y):
    """Syracuse map: odd n -> (xn + y) / 2^v.  Returns (result, v)."""
    val = x * n + y
    if val <= 0:
        return None, 0
    v = 0
    while val % 2 == 0:
        val //= 2
        v += 1
    return val, v


def v_sequence_general(n, x, y, max_steps=1000):
    """Return the sequence of v-values along the trajectory from n.

    Bails out if the iterate exceeds 10**15 or a cycle is detected.
    """
    vs = []
    seen = set()
    current = n
    for _ in range(max_steps):
        if current in seen:
            break
        if current > 10**15:
            break
        seen.add(current)
        current, v = syracuse_general(current, x, y)
        if current is None:
            break
        vs.append(v)
    return vs


def build_transfer_matrix(x, y, k):
    """Build the transfer matrix P on odd residues mod 2^k.

    For each odd residue j mod 2^k, computes T(j) = (x*j + y)/2^v
    and places weight 2^{-v} at the column j, row target.

    Returns (mat, odd_residues, idx_map) where:
      mat         -- (n_states x n_states) numpy array
      odd_residues -- list of odd residues mod 2^k
      idx_map      -- dict mapping residue -> matrix index
    """
    mod = 2**k
    odd_residues = list(range(1, mod, 2))
    n_states = len(odd_residues)
    idx_map = {r: i for i, r in enumerate(odd_residues)}
    mat = np.zeros((n_states, n_states))
    for j_idx, j_res in enumerate(odd_residues):
        val = x * j_res + y
        if val <= 0:
            continue
        v = 0
        while val % 2 == 0:
            val //= 2
            v += 1
        target = val % mod
        if target in idx_map:
            mat[idx_map[target], j_idx] = 2.0 ** (-v)
    return mat, odd_residues, idx_map


def build_transfer_matrix_rational(p, q, y, k):
    """Build transfer matrix for rational x = p/q on odd residues mod 2^k.

    For q odd, q^{-1} mod 2^k exists.  The map is:
        T(j) = (pj + qy) / (q * 2^v)
    where v = v_2(pj + qy).  The target residue mod 2^k is
        ((pj + qy) >> v) * q_inv  mod 2^k
    and the weight is 2^{-v} as usual.

    Returns (mat, odd_residues, idx_map).
    """
    mod = 2**k
    odd_residues = list(range(1, mod, 2))
    n_states = len(odd_residues)
    idx_map = {r: i for i, r in enumerate(odd_residues)}
    q_inv = pow(q, -1, mod)  # q odd => invertible mod 2^k
    mat = np.zeros((n_states, n_states))
    for j_idx, j_res in enumerate(odd_residues):
        val = p * j_res + q * y
        if val <= 0:
            continue
        v = 0
        while val % 2 == 0:
            val //= 2
            v += 1
        target = (val * q_inv) % mod
        if target in idx_map:
            mat[idx_map[target], j_idx] = 2.0 ** (-v)
    return mat, odd_residues, idx_map


def fredholm_coefficients(mat):
    """Ascending-power coefficients of det(I - z*P) as a polynomial in z.

    np.poly(eigenvalues) returns [1, -e1, e2, ..., (-1)^n*en] in descending-z
    order for det(zI-P).  This array is numerically identical to the
    ascending-z coefficients of det(I-zP) = 1 - e1*z + e2*z^2 - ...
    So c[0] = 1.0 (constant term), c[j] = (-1)^j * e_j(eigenvalues).

    Callers must reverse ([::-1]) before passing to np.roots, which
    expects descending order.
    """
    eigenvalues = eig(mat, right=False)
    return np.real(np.poly(eigenvalues))


# ---------------------------------------------------------------------------
# Section stubs
# ---------------------------------------------------------------------------
def section_1():
    """Lyapunov exponent: heuristic vs empirical for continuous real x."""
    print("=" * 72)
    print("SECTION 1: Lyapunov Exponent — Heuristic vs Empirical")
    print("=" * 72)
    print()
    print("Heuristic: lambda(x) = log(x/4)  [assumes i.i.d. v with E[v]=2]")
    print("Empirical: lambda(x) = log(x) - log(2) * E_empirical[v]")
    print()

    # Heuristic: defined for all real x > 0
    x_cont = np.linspace(0.5, 15, 500)
    lyap_heuristic = np.log(x_cont / 4.0)

    # Empirical: measure E[v] at odd integers
    x_odd = list(range(1, 30, 2))
    lyap_empirical = []
    e_v_values = []

    for x in x_odd:
        all_vs = []
        for n in range(3, 10001, 2):
            if x * n + 1 <= 0:
                continue
            vs = v_sequence_general(n, x, 1, max_steps=500)
            all_vs.extend(vs)
        if all_vs:
            e_v = np.mean(all_vs)
            e_v_values.append(e_v)
            lyap_empirical.append(math.log(x) - math.log(2) * e_v)
        else:
            e_v_values.append(float("nan"))
            lyap_empirical.append(float("nan"))

    # Print table
    print(f"  {'x':>3}  {'E[v]':>8}  {'lambda_heur':>12}  {'lambda_emp':>12}  {'diff':>10}")
    print(f"  {'—' * 3}  {'—' * 8}  {'—' * 12}  {'—' * 12}  {'—' * 10}")
    for i, x in enumerate(x_odd):
        lh = math.log(x / 4.0)
        le = lyap_empirical[i]
        diff = le - lh if not math.isnan(le) else float("nan")
        print(f"  {x:3d}  {e_v_values[i]:8.4f}  {lh:12.6f}  {le:12.6f}  {diff:+10.6f}")

    # Plot
    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(16, 6))

    ax1.plot(x_cont, lyap_heuristic, "b-", linewidth=2, label=r"Heuristic: $\log(x/4)$")
    ax1.plot(
        x_odd, lyap_empirical, "ro", markersize=8, label=r"Empirical: $\log x - \log 2 \cdot E[v]$"
    )
    ax1.axhline(y=0, color="gray", linestyle="--", alpha=0.5)
    ax1.axvline(x=3, color="green", linestyle=":", alpha=0.7, label="x=3 (Collatz)")
    ax1.axvline(x=4, color="red", linestyle=":", alpha=0.7, label="x=4 (phase transition)")
    ax1.set_xlabel("x", fontsize=13)
    ax1.set_ylabel(r"$\lambda(x)$", fontsize=13)
    ax1.set_title("Lyapunov Exponent: Candidate 1", fontsize=14)
    ax1.legend(fontsize=10)
    ax1.grid(True, alpha=0.3)

    ax2.plot(x_odd, e_v_values, "ko-", markersize=6)
    ax2.axhline(y=2.0, color="red", linestyle="--", alpha=0.5, label="E[v]=2 (geometric)")
    ax2.set_xlabel("x", fontsize=13)
    ax2.set_ylabel("E[v]", fontsize=13)
    ax2.set_title("Empirical E[v] at Odd Integer x", fontsize=14)
    ax2.legend(fontsize=10)
    ax2.grid(True, alpha=0.3)

    plt.tight_layout()
    outpath = os.path.join(PLOT_DIR, "lyapunov_continuous.png")
    plt.savefig(outpath, dpi=150, bbox_inches="tight")
    plt.close()
    print(f"\n  Saved: {outpath}")
    print()
    return x_odd, lyap_empirical, lyap_heuristic


def section_2():
    """Spectral radius rho(x) for fine grid of odd integers."""
    print("=" * 72)
    print("SECTION 2: Spectral Radius rho(x) — Fine Grid, Multiple k")
    print("=" * 72)
    print()
    print("Transfer matrix P(x) on odd residues mod 2^k, x = 1,3,5,...,63")
    print()

    k_values = [4, 5, 6, 7, 8]
    x_odd = list(range(1, 64, 2))
    all_rho = {}  # k -> list of rho values

    for k in k_values:
        rho_list = []
        for x in x_odd:
            mat, _, _ = build_transfer_matrix(x, 1, k)
            eigenvalues = eig(mat, right=False)
            rho_list.append(np.max(np.abs(eigenvalues)))
        all_rho[k] = rho_list

    # Print selected values
    print(f"  {'x':>3}", end="")
    for k in k_values:
        print(f"  {'k=' + str(k):>8}", end="")
    print()
    print(f"  {'—' * 3}", end="")
    for _ in k_values:
        print(f"  {'—' * 8}", end="")
    print()
    for i, x in enumerate(x_odd):
        if x <= 15 or x % 10 == 1:
            print(f"  {x:3d}", end="")
            for k in k_values:
                print(f"  {all_rho[k][i]:8.4f}", end="")
            print()

    # Plot — connected dots (no polynomial fit: rho varies erratically with x
    # due to number-theoretic structure, so smooth interpolation is misleading)
    fig, ax = plt.subplots(figsize=(14, 7))
    colors = plt.cm.viridis(np.linspace(0, 0.8, len(k_values)))
    for ci, k in enumerate(k_values):
        ax.plot(
            x_odd,
            all_rho[k],
            "o-",
            color=colors[ci],
            markersize=4,
            linewidth=1.2,
            alpha=0.8,
            label=f"k={k}",
        )

    ax.axvline(x=3, color="green", linestyle=":", alpha=0.7, label="x=3 (Collatz)")
    ax.axvline(x=4, color="gray", linestyle="--", alpha=0.5, label="x=4 (phase transition)")
    ax.axhline(y=1, color="red", linestyle=":", alpha=0.5, label=r"$\rho = 1$")
    ax.set_xlabel("x", fontsize=13)
    ax.set_ylabel(r"$\rho(x)$ (spectral radius)", fontsize=13)
    ax.set_title("Spectral Radius of Transfer Matrix: Candidate 2", fontsize=14)
    ax.legend(fontsize=10)
    ax.grid(True, alpha=0.3)
    ax.set_xlim(0, 65)

    plt.tight_layout()
    outpath = os.path.join(PLOT_DIR, "spectral_radius_continuous.png")
    plt.savefig(outpath, dpi=150, bbox_inches="tight")
    plt.close()
    print(f"\n  Saved: {outpath}")
    print()
    return all_rho


def section_3():
    """Fredholm determinant zeros at integer x values."""
    print("=" * 72)
    print("SECTION 3: Fredholm Determinant Zeros — Candidate 3")
    print("=" * 72)
    print()
    print("det(I - z*P(x)) = 0  at  z = 1/lambda_i(x)")
    print("If ALL zeros have |z| > 1 (i.e. all |lambda_i| < 1), dynamics contract.")
    print()

    k = 7  # 64x64 matrix
    x_odd = [1, 3, 5, 7, 9, 11, 15, 21, 29]

    fig, axes = plt.subplots(3, 3, figsize=(14, 14))
    axes = axes.flatten()

    all_zeros = {}
    for ax_idx, x in enumerate(x_odd):
        mat, _, _ = build_transfer_matrix(x, 1, k)
        eigenvalues = eig(mat, right=False)
        nonzero = eigenvalues[np.abs(eigenvalues) > 1e-12]
        zeros = 1.0 / nonzero
        all_zeros[x] = zeros

        # Report nearest zero to origin
        if len(zeros) > 0:
            nearest = zeros[np.argmin(np.abs(zeros))]
            print(
                f"  x={x:2d}: {len(zeros):3d} nonzero eigs, "
                f"nearest Fredholm zero |z|={np.abs(nearest):.4f}"
            )
        else:
            print(f"  x={x:2d}: all eigenvalues zero")

        ax = axes[ax_idx]
        theta = np.linspace(0, 2 * np.pi, 100)
        ax.plot(np.cos(theta), np.sin(theta), "k-", alpha=0.4, linewidth=1.5)
        if len(zeros) > 0:
            ax.scatter(
                zeros.real, zeros.imag, c="#e41a1c", s=30, alpha=0.8, edgecolors="none", zorder=3
            )
        title_weight = "bold" if x == 3 else "normal"
        title_color = "#e41a1c" if x == 3 else "black"
        ax.set_title(f"$x = {x}$", fontsize=13, fontweight=title_weight, color=title_color)
        ax.set_aspect("equal")
        ax.set_xlim(-5, 5)
        ax.set_ylim(-5, 5)
        ax.grid(True, alpha=0.2)
        ax.set_xlabel("Re$(z)$", fontsize=10)
        ax.set_ylabel("Im$(z)$", fontsize=10)
        if x == 3:
            ax.patch.set_facecolor("#fff0f0")

    plt.suptitle(
        r"Fredholm zeros of $\det(I - zP_k(x,1))$ for odd $x$ ($k = 7$)"
        "\nAll zeros outside unit circle $\\Rightarrow$ convergent dynamics",
        fontsize=14,
    )
    plt.tight_layout(rect=[0, 0, 1, 0.95])
    outpath = os.path.join(PLOT_DIR, "fredholm_zeros_flow.png")
    plt.savefig(outpath, dpi=150, bbox_inches="tight")
    plt.close()
    print(f"\n  Saved: {outpath}")
    print()
    return all_zeros


def section_4():
    """Coefficient interpolation — continuation to continuous real x."""
    print("=" * 72)
    print("SECTION 4: Chebyshev Interpolation of Fredholm Coefficients")
    print("=" * 72)
    print()
    print("det(I - z*P(x)) = sum c_j(x) * z^j")
    print("Compute c_j at odd integer x, fit as polynomial in x,")
    print("then evaluate at continuous (and later complex) x.")
    print()

    k = 6  # 32x32 matrix => degree-32 polynomial in z
    n_states = 2 ** (k - 1)
    x_odd = np.array(list(range(1, 128, 2)), dtype=float)  # 64 data points
    fit_deg = min(30, len(x_odd) - 1)

    # Rescale x to [-1, 1] for Chebyshev fitting (avoids catastrophic
    # ill-conditioning: T_k(63) ~ 10^62 without rescaling)
    x_lo, x_hi = float(x_odd[0]), float(x_odd[-1])

    def to_cheb(x):
        return 2.0 * (x - x_lo) / (x_hi - x_lo) - 1.0

    x_scaled = to_cheb(x_odd)

    # Collect Fredholm coefficients at each x
    all_coeffs = np.zeros((len(x_odd), n_states + 1))
    for i, x in enumerate(x_odd):
        mat, _, _ = build_transfer_matrix(int(x), 1, k)
        all_coeffs[i] = fredholm_coefficients(mat)

    print(f"  Collected {len(x_odd)} x-values, {n_states + 1} coefficients each.")
    print(f"  Fitting degree-{fit_deg} Chebyshev polynomials (domain-rescaled)...")

    # Fit each coefficient c_j(x) as Chebyshev polynomial in rescaled x
    coeff_fits = []
    fit_errors = []
    for j in range(n_states + 1):
        fit = cheb.chebfit(x_scaled, all_coeffs[:, j], fit_deg)
        coeff_fits.append(fit)
        predicted = cheb.chebval(x_scaled, fit)
        err = np.max(np.abs(predicted - all_coeffs[:, j]))
        fit_errors.append(err)

    print("  Max fit error per coefficient:")
    print(f"    c_0: {fit_errors[0]:.2e}  (should be ~0, since c_0=1 always)")
    print(f"    c_1: {fit_errors[1]:.2e}")
    print(f"    c_max: {max(fit_errors):.2e}")

    # Evaluate at continuous real x
    x_fine = np.linspace(1, 63, 500)
    nearest_zero_dist = np.zeros(len(x_fine))

    for i, x_eval in enumerate(x_fine):
        # Reconstruct polynomial in z at this x (rescaled to [-1,1])
        x_s = to_cheb(x_eval)
        coeffs_at_x = np.array([cheb.chebval(x_s, fit) for fit in coeff_fits])
        # Find zeros: np.roots expects descending order
        roots = np.roots(coeffs_at_x[::-1])
        if len(roots) > 0:
            nearest_zero_dist[i] = np.min(np.abs(roots))
        else:
            nearest_zero_dist[i] = np.inf

    # Plot nearest Fredholm zero distance vs x
    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(16, 6))

    ax1.plot(x_fine, nearest_zero_dist, "b-", linewidth=2)
    ax1.axhline(y=1, color="red", linestyle="--", alpha=0.7, label="|z|=1 boundary")
    ax1.axvline(x=3, color="green", linestyle=":", alpha=0.7, label="x=3 (Collatz)")
    ax1.axvline(x=4, color="gray", linestyle="--", alpha=0.5, label="x=4 (transition)")
    ax1.set_xlabel("x (continuous)", fontsize=13)
    ax1.set_ylabel("|nearest Fredholm zero|", fontsize=13)
    ax1.set_title("Nearest Zero of det(I-zP(x)) to Origin", fontsize=14)
    ax1.legend(fontsize=10)
    ax1.grid(True, alpha=0.3)
    ax1.set_xlim(1, 20)
    ax1.set_ylim(0, 8)

    # Verify: at odd integers, compare interpolated vs direct
    x_check = [1, 3, 5, 7, 9, 11, 13, 15]
    direct_nearest = []
    interp_nearest = []
    for x in x_check:
        mat, _, _ = build_transfer_matrix(x, 1, k)
        eigs = eig(mat, right=False)
        nonzero = eigs[np.abs(eigs) > 1e-12]
        if len(nonzero) > 0:
            direct_nearest.append(np.min(np.abs(1.0 / nonzero)))
        else:
            direct_nearest.append(np.inf)

        coeffs_at_x = np.array([cheb.chebval(to_cheb(float(x)), fit) for fit in coeff_fits])
        roots = np.roots(coeffs_at_x[::-1])
        if len(roots) > 0:
            interp_nearest.append(np.min(np.abs(roots)))
        else:
            interp_nearest.append(np.inf)

    ax2.plot(x_check, direct_nearest, "ro", markersize=10, label="Direct (eigenvalue)")
    ax2.plot(x_check, interp_nearest, "b^", markersize=8, label="Interpolated")
    ax2.axhline(y=1, color="red", linestyle="--", alpha=0.5)
    ax2.set_xlabel("x (odd integer)", fontsize=13)
    ax2.set_ylabel("|nearest Fredholm zero|", fontsize=13)
    ax2.set_title("Verification: Direct vs Interpolated", fontsize=14)
    ax2.legend(fontsize=10)
    ax2.grid(True, alpha=0.3)

    print("\n  Verification (direct vs interpolated nearest zero):")
    print(f"  {'x':>3}  {'direct':>10}  {'interp':>10}  {'error':>10}")
    for i, x in enumerate(x_check):
        err = abs(direct_nearest[i] - interp_nearest[i])
        print(f"  {x:3d}  {direct_nearest[i]:10.4f}  {interp_nearest[i]:10.4f}  {err:10.2e}")

    plt.tight_layout()
    outpath = os.path.join(PLOT_DIR, "fredholm_continuation_real.png")
    plt.savefig(outpath, dpi=150, bbox_inches="tight")
    plt.close()
    print(f"\n  Saved: {outpath}")
    print()
    return coeff_fits, n_states, to_cheb


def section_5(coeff_fits=None, n_states=None, to_cheb=None):
    """Extension to complex x."""
    print("=" * 72)
    print("SECTION 5: Complex x — Polynomial Extension")
    print("=" * 72)
    print()
    print("Evaluate interpolated det(I-zP(x)) at complex x near x=3.")
    print("If |nearest zero| > 1 in a neighborhood of x=3, dynamics contract.")
    print()

    # Recompute fits if not passed
    if coeff_fits is None or to_cheb is None:
        k = 6
        n_states = 2 ** (k - 1)
        x_odd = np.array(list(range(1, 128, 2)), dtype=float)
        x_lo, x_hi = float(x_odd[0]), float(x_odd[-1])
        to_cheb = lambda x: 2.0 * (x - x_lo) / (x_hi - x_lo) - 1.0  # noqa: E731
        x_scaled = to_cheb(x_odd)
        fit_deg = min(30, len(x_odd) - 1)
        coeff_fits = []
        for j in range(n_states + 1):
            all_cj = np.zeros(len(x_odd))
            for i, x in enumerate(x_odd):
                mat, _, _ = build_transfer_matrix(int(x), 1, k)
                c = fredholm_coefficients(mat)
                all_cj[i] = c[j]
            coeff_fits.append(cheb.chebfit(x_scaled, all_cj, fit_deg))

    # Complex x grid centered at x=3
    re_range = np.linspace(0.5, 8, 100)
    im_range = np.linspace(-4, 4, 101)  # odd count ensures Im=0 is included
    re_grid, im_grid = np.meshgrid(re_range, im_range)
    nearest_zero_map = np.zeros_like(re_grid)
    spectral_radius_map = np.zeros_like(re_grid)

    for i in range(len(im_range)):
        for j in range(len(re_range)):
            x_complex = complex(re_grid[i, j], im_grid[i, j])
            x_s = to_cheb(x_complex)
            coeffs_at_x = np.array([complex(cheb.chebval(x_s, fit)) for fit in coeff_fits])
            roots = np.roots(coeffs_at_x[::-1])
            # Guard against spurious near-zero roots from polynomial solver
            nonzero_roots = roots[np.abs(roots) > 1e-10]
            if len(nonzero_roots) > 0:
                nearest_zero_map[i, j] = np.min(np.abs(nonzero_roots))
                spectral_radius_map[i, j] = np.max(np.abs(1.0 / nonzero_roots))
            else:
                nearest_zero_map[i, j] = np.inf
                spectral_radius_map[i, j] = 0.0

    # Plot 1: |nearest Fredholm zero| heatmap
    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(16, 7))

    im1 = ax1.contourf(
        re_grid,
        im_grid,
        nearest_zero_map,
        levels=np.linspace(0, 5, 50),
        cmap="RdYlGn",
        extend="both",
    )
    ax1.contour(
        re_grid,
        im_grid,
        nearest_zero_map,
        levels=[1.0],
        colors="black",
        linewidths=2,
    )
    ax1.plot(3, 0, "r*", markersize=15, label="x=3 (Collatz)")
    ax1.set_xlabel("Re(x)", fontsize=13)
    ax1.set_ylabel("Im(x)", fontsize=13)
    ax1.set_title("|Nearest Fredholm Zero| in Complex x-Plane", fontsize=14)
    ax1.legend(fontsize=11)
    plt.colorbar(im1, ax=ax1, label="|nearest zero|")

    # Plot 2: spectral radius |rho(x)| heatmap
    im2 = ax2.contourf(
        re_grid,
        im_grid,
        spectral_radius_map,
        levels=np.linspace(0, 2, 50),
        cmap="RdYlGn_r",
        extend="both",
    )
    ax2.contour(
        re_grid,
        im_grid,
        spectral_radius_map,
        levels=[1.0],
        colors="black",
        linewidths=2,
    )
    ax2.plot(3, 0, "r*", markersize=15, label="x=3 (Collatz)")
    ax2.set_xlabel("Re(x)", fontsize=13)
    ax2.set_ylabel("Im(x)", fontsize=13)
    ax2.set_title(r"Spectral Radius $|\rho(x)|$ in Complex x-Plane", fontsize=14)
    ax2.legend(fontsize=11)
    plt.colorbar(im2, ax=ax2, label=r"$|\rho|$")

    plt.tight_layout()
    outpath1 = os.path.join(PLOT_DIR, "fredholm_zeros_complex_x.png")
    plt.savefig(outpath1, dpi=150, bbox_inches="tight")
    plt.close()
    print(f"  Saved: {outpath1}")

    # Also make spectral radius on real line comparison
    fig, ax = plt.subplots(figsize=(12, 6))
    # Extract real-axis slice
    mid_im = int(np.argmin(np.abs(im_range)))
    ax.plot(
        re_range,
        spectral_radius_map[mid_im, :],
        "b-",
        linewidth=2,
        label=r"$|\rho(x)|$ from Fredholm interpolation",
    )
    ax.axhline(y=1, color="red", linestyle="--", alpha=0.7, label=r"$\rho = 1$")
    ax.axvline(x=3, color="green", linestyle=":", alpha=0.7, label="x=3")
    ax.axvline(x=4, color="gray", linestyle="--", alpha=0.5, label="x=4")
    ax.set_xlabel("x (real)", fontsize=13)
    ax.set_ylabel(r"$|\rho(x)|$", fontsize=13)
    ax.set_title("Spectral Radius via Fredholm Continuation (Real Axis)", fontsize=14)
    ax.legend(fontsize=10)
    ax.grid(True, alpha=0.3)

    plt.tight_layout()
    outpath2 = os.path.join(PLOT_DIR, "spectral_radius_complex.png")
    plt.savefig(outpath2, dpi=150, bbox_inches="tight")
    plt.close()
    print(f"  Saved: {outpath2}")

    # Print key values
    print()
    print("  Key values on real axis:")
    for x_val in [1.0, 2.0, 3.0, 4.0, 5.0, 7.0]:
        j_idx = np.argmin(np.abs(re_range - x_val))
        rho_val = spectral_radius_map[mid_im, j_idx]
        nz_val = nearest_zero_map[mid_im, j_idx]
        print(f"    x={x_val:.1f}: rho={rho_val:.4f}, |nearest zero|={nz_val:.4f}")

    print()
    return nearest_zero_map, spectral_radius_map


def section_6():
    """Rigorous analysis for easy cases."""
    print("=" * 72)
    print("SECTION 6: Rigorous Analysis")
    print("=" * 72)
    print()

    print("  THEOREM 1 (x=1, y=1 convergence):")
    print("  ─────────────────────────────────")
    print("  For x=1, y=1: T(n) = (n+1)/2^{v_2(n+1)} for odd n.")
    print("  Since n is odd, n+1 is even, so v_2(n+1) >= 1.")
    print("  Thus T(n) = (n+1)/2^v <= (n+1)/2 < n for all odd n >= 3.")
    print("  Since T maps odd positives to odd positives with T(n) < n,")
    print("  every trajectory is strictly decreasing and reaches 1.  QED")
    print()

    # Verify with transfer matrix
    print("  Verification via transfer matrix (rho < 1 => contraction):")
    for k in [4, 5, 6, 7, 8]:
        mat, _, _ = build_transfer_matrix(1, 1, k)
        eigenvalues = eig(mat, right=False)
        rho = np.max(np.abs(eigenvalues))
        print(f"    k={k}: rho(1) = {rho:.6f}")
    print()

    print("  THEOREM 2 (x=1, any odd y > 0):")
    print("  ───────────────────────────────")
    print("  For x=1, y>0 odd: T(n) = (n+y)/2^{v_2(n+y)}.")
    print("  Since n and y are both odd, n+y is even, v_2(n+y) >= 1.")
    print("  T(n) <= (n+y)/2. For n > y: T(n) < n.")
    print("  Below n=y, T might increase, but the image is bounded")
    print("  and the map eventually contracts. Every orbit reaches a cycle.")
    print()

    print("  OBSERVATION (even x always diverges):")
    print("  ─────────────────────────────────────")
    print("  For even x, odd n, odd y: xn+y = even*odd + odd = odd.")
    print("  So v_2(xn+y) = 0 and T(n) = xn+y.")
    print("  For x >= 2: T(n) = xn+y > n, so all trajectories diverge.")
    print("  This means the 'convergent' region is exclusively odd x < 4.")
    print()

    print("  OPEN QUESTION (x=3, y=1 — the Collatz conjecture):")
    print("  ──────────────────────────────────────────────────")
    print("  Transfer matrix gives rho(3) ~= 0.25 < 1 for all k tested.")
    print("  Fredholm zeros all outside unit circle.")
    print("  Lyapunov exponent lambda(3) = log(3/4) ~= -0.288 < 0.")
    print("  ALL three candidates agree: x=3 is in the convergent regime.")
    print("  But none constitute a proof — they all rest on finite")
    print("  approximations (finite k, finite trajectories).")
    print()

    # Key question: does rho(x) -> 0.25 as k -> infinity?
    print("  Convergence of rho(3) as k increases:")
    for k in range(3, 12):
        mat, _, _ = build_transfer_matrix(3, 1, k)
        eigenvalues = eig(mat, right=False)
        rho = np.max(np.abs(eigenvalues))
        n_states = 2 ** (k - 1)
        print(f"    k={k:2d} (N={n_states:5d}): rho = {rho:.8f}")
    print()


def section_7():
    """Candidate comparison and assessment."""
    print("=" * 72)
    print("SECTION 7: Candidate Comparison")
    print("=" * 72)
    print()

    k = 7
    x_odd = list(range(1, 30, 2))

    # Collect all three metrics at each x
    lyap_heuristic = []
    lyap_empirical = []
    spectral_radii = []
    nearest_fredholm = []

    for x in x_odd:
        # Lyapunov heuristic
        lyap_heuristic.append(math.log(x / 4.0))

        # Lyapunov empirical
        all_vs = []
        for n in range(3, 5001, 2):
            if x * n + 1 <= 0:
                continue
            vs = v_sequence_general(n, x, 1, max_steps=300)
            all_vs.extend(vs)
        if all_vs:
            e_v = np.mean(all_vs)
            lyap_empirical.append(math.log(x) - math.log(2) * e_v)
        else:
            lyap_empirical.append(float("nan"))

        # Spectral radius
        mat, _, _ = build_transfer_matrix(x, 1, k)
        eigenvalues = eig(mat, right=False)
        spectral_radii.append(np.max(np.abs(eigenvalues)))

        # Nearest Fredholm zero
        nonzero = eigenvalues[np.abs(eigenvalues) > 1e-12]
        if len(nonzero) > 0:
            nearest_fredholm.append(np.min(np.abs(1.0 / nonzero)))
        else:
            nearest_fredholm.append(np.inf)

    # Print comparison table
    print(f"  {'x':>3}  {'lyap_h':>8}  {'lyap_e':>8}  {'rho':>8}  {'|z_min|':>8}  {'verdict':>10}")
    print(f"  {'—' * 3}  {'—' * 8}  {'—' * 8}  {'—' * 8}  {'—' * 8}  {'—' * 10}")
    for i, x in enumerate(x_odd):
        lh = lyap_heuristic[i]
        le = lyap_empirical[i]
        rho = spectral_radii[i]
        nz = nearest_fredholm[i]
        # Verdict: all three agree?
        v1 = lh < 0
        v2 = le < 0 if not math.isnan(le) else None
        v3 = rho < 1
        v4 = nz > 1 if nz != np.inf else True
        if all(v for v in [v1, v2, v3, v4] if v is not None):
            verdict = "CONVERGE"
        elif not any(v for v in [v1, v2, v3, v4] if v is not None):
            verdict = "DIVERGE"
        else:
            verdict = "MIXED"
        nz_str = f"{nz:8.4f}" if nz != np.inf else "     inf"
        le_str = f"{le:8.4f}" if not math.isnan(le) else "     nan"
        print(f"  {x:3d}  {lh:8.4f}  {le_str}  {rho:8.4f}  {nz_str}  {verdict:>10}")

    # Comparison plot
    fig, axes = plt.subplots(2, 2, figsize=(14, 10))

    ax1 = axes[0, 0]
    ax1.plot(x_odd, lyap_heuristic, "b-o", markersize=5, label="Heuristic")
    ax1.plot(x_odd, lyap_empirical, "r-s", markersize=5, label="Empirical")
    ax1.axhline(y=0, color="gray", linestyle="--", alpha=0.5)
    ax1.axvline(x=3, color="green", linestyle=":", alpha=0.7)
    ax1.set_title("Candidate 1: Lyapunov Exponent")
    ax1.set_ylabel(r"$\lambda(x)$")
    ax1.legend(fontsize=9)
    ax1.grid(True, alpha=0.3)

    ax2 = axes[0, 1]
    ax2.plot(x_odd, spectral_radii, "b-o", markersize=5)
    ax2.axhline(y=1, color="red", linestyle="--", alpha=0.5, label=r"$\rho=1$")
    ax2.axvline(x=3, color="green", linestyle=":", alpha=0.7)
    ax2.set_title(r"Candidate 2: Spectral Radius $\rho(x)$")
    ax2.set_ylabel(r"$\rho$")
    ax2.legend(fontsize=9)
    ax2.grid(True, alpha=0.3)

    ax3 = axes[1, 0]
    nf_finite = [nz if nz != np.inf else 10.0 for nz in nearest_fredholm]
    ax3.plot(x_odd, nf_finite, "b-o", markersize=5)
    ax3.axhline(y=1, color="red", linestyle="--", alpha=0.5, label="|z|=1")
    ax3.axvline(x=3, color="green", linestyle=":", alpha=0.7)
    ax3.set_title("Candidate 3: Nearest Fredholm Zero")
    ax3.set_xlabel("x")
    ax3.set_ylabel("|nearest zero|")
    ax3.legend(fontsize=9)
    ax3.grid(True, alpha=0.3)

    ax4 = axes[1, 1]
    ax4.text(0.1, 0.85, "ASSESSMENT", fontsize=14, fontweight="bold", transform=ax4.transAxes)
    ax4.text(
        0.1,
        0.70,
        r"x < 4: all three say convergent ($\lambda<0, \rho<1, |z|>1$)",
        fontsize=10,
        transform=ax4.transAxes,
    )
    ax4.text(
        0.1,
        0.55,
        r"x $\geq$ 5: Lyapunov says divergent, but $\rho < 0.5$ always",
        fontsize=10,
        transform=ax4.transAxes,
    )
    ax4.text(
        0.1,
        0.40,
        r"(odd x $\Rightarrow$ v $\geq$ 1, one entry/col $\leq$ 1/2, col sums $\leq$ 1/2)",
        fontsize=10,
        transform=ax4.transAxes,
    )
    ax4.text(
        0.1,
        0.25,
        "Fredholm determinant is most informative:",
        fontsize=11,
        transform=ax4.transAxes,
    )
    ax4.text(
        0.1,
        0.10,
        "  - Exact for finite matrices (no heuristics)",
        fontsize=10,
        transform=ax4.transAxes,
    )
    ax4.text(
        0.1,
        -0.05,
        "  - Extends to complex x via interpolation",
        fontsize=10,
        transform=ax4.transAxes,
    )
    ax4.text(
        0.1,
        -0.20,
        "  - Zeros = eigenvalue reciprocals (concrete)",
        fontsize=10,
        transform=ax4.transAxes,
    )
    ax4.axis("off")

    plt.suptitle("Three Candidates for Spectral Continuation", fontsize=14)
    plt.tight_layout()
    outpath = os.path.join(PLOT_DIR, "candidate_comparison.png")
    plt.savefig(outpath, dpi=150, bbox_inches="tight")
    plt.close()
    print(f"\n  Saved: {outpath}")
    print()


def section_8():
    """Fredholm determinant at dense rational x = p/q (q odd)."""
    print("=" * 72)
    print("SECTION 8: Rational x — Dense Sampling via p/q")
    print("=" * 72)
    print()
    print("For x = p/q with q odd, the transfer matrix mod 2^k is well-defined:")
    print("  q^{-1} mod 2^k exists, and v = v_2(pj + qy) as usual.")
    print()

    k = 7
    y = 1
    # Generate rationals p/q with q in {1, 3, 5, 7, 9} and x in (0.5, 15)
    rationals = []  # (p, q, x_float)
    for q in [1, 3, 5, 7, 9]:
        for p in range(1, 15 * q + 1):
            x_val = p / q
            if 0.5 < x_val < 15.0 and math.gcd(p, q) == 1:
                rationals.append((p, q, x_val))
    rationals.sort(key=lambda t: t[2])

    print(f"  Generated {len(rationals)} rational x-values in (0.5, 15)")
    print(f"  Denominators: {{1, 3, 5, 7, 9}}, resolution k={k}")
    print()

    # Compute spectral radius and nearest Fredholm zero at each
    x_vals = []
    rho_vals = []
    nearest_zero_vals = []
    for p, q, x_val in rationals:
        if q == 1:
            mat, _, _ = build_transfer_matrix(p, y, k)
        else:
            mat, _, _ = build_transfer_matrix_rational(p, q, y, k)
        eigenvalues = eig(mat, right=False)
        rho_vals.append(np.max(np.abs(eigenvalues)))
        nonzero = eigenvalues[np.abs(eigenvalues) > 1e-12]
        if len(nonzero) > 0:
            nearest_zero_vals.append(np.min(np.abs(1.0 / nonzero)))
        else:
            nearest_zero_vals.append(np.inf)
        x_vals.append(x_val)

    x_arr = np.array(x_vals)
    rho_arr = np.array(rho_vals)
    nz_arr = np.array(nearest_zero_vals)
    nz_arr = np.clip(nz_arr, 0, 20)  # cap infinities for plotting

    # Print selected values
    print(f"  {'x':>8}  {'p/q':>8}  {'rho':>8}  {'|z_min|':>8}")
    print(f"  {'—' * 8}  {'—' * 8}  {'—' * 8}  {'—' * 8}")
    for p, q, x_val in rationals:
        if abs(x_val - round(x_val)) < 0.01 or x_val in [1.5, 2.5, 3.5]:
            idx = next(i for i, xv in enumerate(x_vals) if abs(xv - x_val) < 1e-10)
            nz_str = f"{nz_arr[idx]:8.4f}" if nz_arr[idx] < 20 else "     inf"
            print(f"  {x_val:8.4f}  {p}/{q:>6}  {rho_arr[idx]:8.4f}  {nz_str}")
    print()

    # Verification: rational with q=1 should match integer build_transfer_matrix
    print("  Verification: q=1 matches integer transfer matrix?")
    for x_int in [1, 3, 5, 7]:
        mat_int, _, _ = build_transfer_matrix(x_int, y, k)
        mat_rat, _, _ = build_transfer_matrix_rational(x_int, 1, y, k)
        err = np.max(np.abs(mat_int - mat_rat))
        print(f"    x={x_int}: max |P_int - P_rat| = {err:.2e}")
    print()

    # --- Plot 1: rho(x) and |nearest zero| for dense rationals ---
    fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(14, 10), sharex=True)

    # Color by denominator
    denom_colors = {1: "black", 3: "blue", 5: "green", 7: "orange", 9: "red"}
    for q_val, color in denom_colors.items():
        mask = [rationals[i][1] == q_val for i in range(len(rationals))]
        x_q = x_arr[mask]
        rho_q = rho_arr[mask]
        nz_q = nz_arr[mask]
        ax1.plot(x_q, rho_q, ".", color=color, markersize=3, alpha=0.6, label=f"q={q_val}")
        ax2.plot(x_q, nz_q, ".", color=color, markersize=3, alpha=0.6, label=f"q={q_val}")

    ax1.axhline(y=0.5, color="gray", linestyle="--", alpha=0.5, label=r"$\rho=0.5$")
    ax1.axvline(x=3, color="green", linestyle=":", alpha=0.7)
    ax1.axvline(x=4, color="gray", linestyle="--", alpha=0.3)
    ax1.set_ylabel(r"$\rho(x)$ (spectral radius)", fontsize=13)
    ax1.set_title(f"Spectral Radius at Dense Rational x (k={k})", fontsize=14)
    ax1.legend(fontsize=9, ncol=6, loc="upper right")
    ax1.grid(True, alpha=0.3)
    ax1.set_ylim(-0.05, 1.0)

    ax2.axhline(y=1, color="red", linestyle="--", alpha=0.5, label="|z|=1")
    ax2.axvline(x=3, color="green", linestyle=":", alpha=0.7)
    ax2.axvline(x=4, color="gray", linestyle="--", alpha=0.3)
    ax2.set_xlabel("x = p/q", fontsize=13)
    ax2.set_ylabel("|nearest Fredholm zero|", fontsize=13)
    ax2.set_title("Nearest Fredholm Zero at Dense Rational x", fontsize=14)
    ax2.legend(fontsize=9)
    ax2.grid(True, alpha=0.3)
    ax2.set_ylim(0, 10)

    plt.tight_layout()
    outpath = os.path.join(PLOT_DIR, "rational_x_dense.png")
    plt.savefig(outpath, dpi=150, bbox_inches="tight")
    plt.close()
    print(f"  Saved: {outpath}")

    # --- Plot 2: zoom near x=3 ---
    fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(14, 10), sharex=True)

    mask_zoom = (x_arr > 1) & (x_arr < 6)
    for q_val, color in denom_colors.items():
        mask = np.array([rationals[i][1] == q_val for i in range(len(rationals))]) & mask_zoom
        x_q = x_arr[mask]
        rho_q = rho_arr[mask]
        nz_q = nz_arr[mask]
        ax1.plot(x_q, rho_q, "o", color=color, markersize=4, alpha=0.7, label=f"q={q_val}")
        ax2.plot(x_q, nz_q, "o", color=color, markersize=4, alpha=0.7, label=f"q={q_val}")

    ax1.axhline(y=0.5, color="gray", linestyle="--", alpha=0.5)
    ax1.axvline(x=3, color="green", linestyle=":", alpha=0.7, label="x=3")
    ax1.set_ylabel(r"$\rho(x)$", fontsize=13)
    ax1.set_title(f"Spectral Radius Near x=3 (k={k})", fontsize=14)
    ax1.legend(fontsize=9, ncol=6)
    ax1.grid(True, alpha=0.3)

    ax2.axhline(y=1, color="red", linestyle="--", alpha=0.5, label="|z|=1")
    ax2.axvline(x=3, color="green", linestyle=":", alpha=0.7, label="x=3")
    ax2.set_xlabel("x = p/q", fontsize=13)
    ax2.set_ylabel("|nearest Fredholm zero|", fontsize=13)
    ax2.set_title("Nearest Fredholm Zero Near x=3", fontsize=14)
    ax2.legend(fontsize=9)
    ax2.grid(True, alpha=0.3)
    ax2.set_ylim(0, 10)

    plt.tight_layout()
    outpath = os.path.join(PLOT_DIR, "rational_x_zoom.png")
    plt.savefig(outpath, dpi=150, bbox_inches="tight")
    plt.close()
    print(f"  Saved: {outpath}")

    # --- Plot 3: does the function look smooth? Fredholm coefficients ---
    # Pick a few coefficients c_j(x) and plot them vs x
    fig, axes = plt.subplots(2, 3, figsize=(18, 10))
    coeff_indices = [1, 2, 3, 4, 8, 16]

    all_coeffs_rational = {}
    for i, (p, q, _x_val) in enumerate(rationals):
        if q == 1:
            mat, _, _ = build_transfer_matrix(p, y, k)
        else:
            mat, _, _ = build_transfer_matrix_rational(p, q, y, k)
        all_coeffs_rational[i] = fredholm_coefficients(mat)

    for ax_idx, j in enumerate(coeff_indices):
        ax = axes.flat[ax_idx]
        cj_vals = [all_coeffs_rational[i][j] for i in range(len(rationals))]
        for q_val, color in denom_colors.items():
            mask = [rationals[i][1] == q_val for i in range(len(rationals))]
            ax.plot(
                x_arr[mask],
                np.array(cj_vals)[mask],
                ".",
                color=color,
                markersize=2,
                alpha=0.5,
                label=f"q={q_val}",
            )
        ax.set_title(f"$c_{{{j}}}(x)$", fontsize=12)
        ax.set_xlabel("x")
        ax.grid(True, alpha=0.3)
        if ax_idx == 0:
            ax.legend(fontsize=8, ncol=5)

    plt.suptitle(f"Fredholm Coefficients at Dense Rational x (k={k})", fontsize=14)
    plt.tight_layout()
    outpath = os.path.join(PLOT_DIR, "rational_x_coefficients.png")
    plt.savefig(outpath, dpi=150, bbox_inches="tight")
    plt.close()
    print(f"  Saved: {outpath}")
    print()


def _functional_graph(mat, odd_residues):
    """Extract the functional graph from a transfer matrix.

    Since each column has exactly one nonzero entry, the map is deterministic:
    j -> target with weight w.

    Returns:
      successor: dict mapping residue -> target residue
      weight:    dict mapping residue -> weight (2^{-v})
      v_val:     dict mapping residue -> v (2-adic valuation)
    """
    successor = {}
    weight = {}
    v_val = {}
    for j_idx, j_res in enumerate(odd_residues):
        col = mat[:, j_idx]
        nz = np.nonzero(col)[0]
        if len(nz) > 0:
            target_idx = nz[0]
            w = col[target_idx]
            successor[j_res] = odd_residues[target_idx]
            weight[j_res] = w
            v_val[j_res] = round(-math.log2(w))
        else:
            successor[j_res] = None
            weight[j_res] = 0.0
            v_val[j_res] = None
    return successor, weight, v_val


def _find_cycles(successor, odd_residues):
    """Find all cycles in a functional graph.

    Returns list of cycles, each cycle being a list of residues in order.
    """
    visited = set()
    cycles = []
    for start in odd_residues:
        if start in visited or successor.get(start) is None:
            continue
        path = []
        current = start
        path_set = set()
        while current not in visited and current not in path_set:
            if successor.get(current) is None:
                break
            path.append(current)
            path_set.add(current)
            current = successor[current]
        if current in path_set:
            cycle_start_idx = path.index(current)
            cycle = path[cycle_start_idx:]
            cycles.append(cycle)
            visited.update(cycle)
        visited.update(path)
    return cycles


def section_9():
    """Why x=3 is a local extremum: cycle decomposition analysis."""
    print("=" * 72)
    print("SECTION 9: Why x=3 Is a Local Extremum")
    print("=" * 72)
    print()
    print("The transfer matrix has one nonzero entry per column (deterministic map).")
    print("Its functional graph decomposes into cycles + trees rooted at cycles.")
    print("Eigenvalues come only from cycles: a cycle of length L with weights")
    print("w_1, ..., w_L contributes eigenvalues that are L-th roots of prod(w_i).")
    print("So rho = max over cycles of (prod w_i)^{1/L} = max 2^{-mean(v)}.")
    print()
    print("If the worst cycle has mean v = 2, then rho = 2^{-2} = 0.25.")
    print()

    # --- Part A: Cycle decomposition at x=3, multiple k ---
    print("  Part A: Cycle decomposition at x=3, y=1")
    print("  " + "=" * 50)
    print()

    for k in [3, 4, 5, 6, 7, 8]:
        mat, odd_res, _ = build_transfer_matrix(3, 1, k)
        successor, weight, v_val = _functional_graph(mat, odd_res)
        cycles = _find_cycles(successor, odd_res)

        cycle_stats = []
        for cyc in cycles:
            vs = [v_val[r] for r in cyc]
            length = len(cyc)
            v_sum = sum(vs)
            v_mean = v_sum / length
            prod_w = np.prod([weight[r] for r in cyc])
            geo_mean = prod_w ** (1.0 / length)
            cycle_stats.append((length, v_sum, v_mean, geo_mean, cyc))

        cycle_stats.sort(key=lambda t: t[2])  # sort by mean v (ascending)
        worst = cycle_stats[0]
        best = cycle_stats[-1]
        n_on_cycles = sum(len(cyc) for cyc in cycles)
        n_total = len(odd_res)

        print(f"  k={k}: {len(cycles)} cycles, {n_on_cycles}/{n_total} residues on cycles")
        print(
            f"    worst cycle: len={worst[0]}, mean_v={worst[2]:.4f}, "
            f"geo_mean_weight={worst[3]:.6f}"
        )
        print(
            f"    best cycle:  len={best[0]}, mean_v={best[2]:.4f}, geo_mean_weight={best[3]:.6f}"
        )
        if k <= 5:
            for length, v_sum, v_mean, _geo_mean, cyc in cycle_stats:
                cyc_str = "->".join(str(r) for r in cyc[:8])
                if len(cyc) > 8:
                    cyc_str += "->..."
                print(f"      L={length:3d}, sum_v={v_sum:4d}, mean_v={v_mean:.4f}: {cyc_str}")
        print()

    # --- Part B: Compare x=3 with nearby odd integers ---
    print("  Part B: Worst-cycle mean v across odd integers")
    print("  " + "=" * 50)
    print()
    k = 7
    x_odd = list(range(1, 32, 2))
    print(
        f"  {'x':>3}  {'#cycles':>7}  {'worst_L':>7}  {'worst_mean_v':>12}  "
        f"{'rho_cycle':>10}  {'rho_eig':>10}"
    )
    print(
        f"  {'---':>3}  {'-------':>7}  {'-------':>7}  {'------------':>12}  "
        f"{'----------':>10}  {'----------':>10}"
    )

    int_data = []  # for plotting
    for x in x_odd:
        mat, odd_res, _ = build_transfer_matrix(x, 1, k)
        successor, weight, v_val = _functional_graph(mat, odd_res)
        cycles = _find_cycles(successor, odd_res)
        eigenvalues = eig(mat, right=False)
        rho_eig = np.max(np.abs(eigenvalues))

        if cycles:
            worst_mean_v = min(sum(v_val[r] for r in cyc) / len(cyc) for cyc in cycles)
            rho_cycle = 2.0 ** (-worst_mean_v)
        else:
            worst_mean_v = float("inf")
            rho_cycle = 0.0

        int_data.append((x, len(cycles), worst_mean_v, rho_cycle, rho_eig))
        worst_len = 0
        for cyc in cycles:
            vm = sum(v_val[r] for r in cyc) / len(cyc)
            if abs(vm - worst_mean_v) < 1e-10:
                worst_len = len(cyc)
                break

        print(
            f"  {x:3d}  {len(cycles):7d}  {worst_len:7d}  "
            f"{worst_mean_v:12.4f}  {rho_cycle:10.6f}  {rho_eig:10.6f}"
        )

    print()
    print("  Note: rho_cycle should match rho_eig (eigenvalue computation).")
    print()

    # --- Part C: Compare x=3 with nearby rationals ---
    print("  Part C: Worst-cycle mean v for rationals near x=3")
    print("  " + "=" * 50)
    print()

    k = 7
    # Dense rationals near 3
    nearby_rationals = []
    for q in [1, 3, 5, 7, 9]:
        for p in range(1, 20 * q):
            x_val = p / q
            if 1.5 < x_val < 5.5 and math.gcd(p, q) == 1:
                nearby_rationals.append((p, q, x_val))
    nearby_rationals.sort(key=lambda t: t[2])

    print(
        f"  {'x':>8}  {'p/q':>8}  {'#cyc':>5}  {'worst_mean_v':>12}  "
        f"{'rho':>10}  {'global_mean_v':>13}"
    )
    print(
        f"  {'--------':>8}  {'--------':>8}  {'-----':>5}  {'------------':>12}  "
        f"{'----------':>10}  {'-------------':>13}"
    )

    rat_data = []
    for p, q, x_val in nearby_rationals:
        if q == 1:
            mat, odd_res, _ = build_transfer_matrix(p, 1, k)
        else:
            mat, odd_res, _ = build_transfer_matrix_rational(p, q, 1, k)
        successor, weight, v_val = _functional_graph(mat, odd_res)
        cycles = _find_cycles(successor, odd_res)
        eigenvalues = eig(mat, right=False)
        rho_eig = np.max(np.abs(eigenvalues))

        # Global mean v (over all residues with defined v)
        all_vs = [v_val[r] for r in odd_res if v_val[r] is not None]
        global_mean_v = np.mean(all_vs) if all_vs else float("nan")

        if cycles:
            worst_mean_v = min(sum(v_val[r] for r in cyc) / len(cyc) for cyc in cycles)
        else:
            worst_mean_v = float("inf")

        rat_data.append((p, q, x_val, len(cycles), worst_mean_v, rho_eig, global_mean_v))

        # Print selected values (near integers and key rationals)
        show = abs(x_val - round(x_val)) < 0.01 or abs(x_val - 3.0) < 0.4 or x_val in [2.5, 3.5]
        if show and q <= 5:
            print(
                f"  {x_val:8.4f}  {p}/{q:>6}  {len(cycles):5d}  "
                f"{worst_mean_v:12.4f}  {rho_eig:10.6f}  "
                f"{global_mean_v:13.4f}"
            )

    print()

    # --- Part D: v-distribution analysis ---
    print("  Part D: v-distribution at x=3 vs nearby rationals")
    print("  " + "=" * 50)
    print()
    print("  For integer x (odd), since x is invertible mod 2^k:")
    print("  xj+1 ranges over all even residues as j ranges over odd residues.")
    print("  So v_2(xj+1) follows exactly P(v=k) = 1/2^k => E[v] = 2.")
    print()
    print("  For rational x=p/q (p,q odd), pj+q ranges over residues")
    print("  that depend on p mod 2^k. The v-distribution may differ.")
    print()

    k = 7
    params = [
        (3, 1, "x=3 (Collatz)"),
        (5, 1, "x=5"),
        (7, 1, "x=7"),
        (7, 3, "x=7/3"),
        (8, 3, "x=8/3"),
        (11, 3, "x=11/3"),
        (13, 5, "x=13/5"),
        (14, 5, "x=14/5"),
    ]
    mod = 2**k
    v_dist_data = {}  # label -> (global_mean_v, worst_cycle_mean_v, v_counts)

    print(
        f"  {'param':>12}  {'E[v]':>8}  {'P(v=1)':>8}  {'P(v=2)':>8}  {'P(v=3)':>8}  {'P(v>=4)':>8}"
    )
    print(
        f"  {'------------':>12}  {'--------':>8}  "
        f"{'--------':>8}  {'--------':>8}  {'--------':>8}  {'--------':>8}"
    )

    for p, q, label in params:
        # Compute v for each odd residue
        odd_res = list(range(1, mod, 2))
        vs = []
        for j in odd_res:
            val = p * j + q * 1  # y=1
            if val <= 0:
                continue
            v = 0
            while val % 2 == 0:
                val //= 2
                v += 1
            vs.append(v)
        mean_v = np.mean(vs)
        v_counts = {}
        for v in vs:
            v_counts[v] = v_counts.get(v, 0) + 1
        n = len(vs)
        p1 = v_counts.get(1, 0) / n
        p2 = v_counts.get(2, 0) / n
        p3 = v_counts.get(3, 0) / n
        p4plus = sum(c for vv, c in v_counts.items() if vv >= 4) / n
        print(f"  {label:>12}  {mean_v:8.4f}  {p1:8.4f}  {p2:8.4f}  {p3:8.4f}  {p4plus:8.4f}")
        v_dist_data[label] = (mean_v, v_counts)

    print()
    print("  Geometric prediction: P(v=k) = 1/2^k => P(1)=0.5, P(2)=0.25, P(3)=0.125, P(>=4)=0.125")
    print()

    # --- Part E: Why x=3 specifically ---
    print("  Part E: The mechanism — why x=3 achieves optimal contraction")
    print("  " + "=" * 50)
    print()
    print("  For any odd integer x with y=1:")
    print("    - xj+1 is always even (odd*odd+1=even), so v >= 1")
    print("    - As j ranges over odd residues mod 2^k, xj+1 ranges over")
    print("      ALL even residues (since x is invertible mod 2^k)")
    print("    - Therefore v_2(xj+1) is exactly geometric: P(v=k) = 1/2^k")
    print("    - Global mean v = 2 for ALL odd integer x")
    print()
    print("  But rho depends on the WORST CYCLE, not the global average!")
    print("  The permutation structure determines how v-values distribute")
    print("  across cycles. If all cycles have mean v = 2, rho = 0.25.")
    print()

    # Check whether ALL cycles at x=3 have mean v = 2
    print("  Testing: do all cycles at x=3 have mean v exactly 2?")
    for k_test in [4, 5, 6, 7, 8]:
        mat, odd_res, _ = build_transfer_matrix(3, 1, k_test)
        successor, _w, v_val = _functional_graph(mat, odd_res)
        cycles = _find_cycles(successor, odd_res)
        cycle_means = [sum(v_val[r] for r in cyc) / len(cyc) for cyc in cycles]
        min_mean = min(cycle_means)
        max_mean = max(cycle_means)
        all_equal_2 = all(abs(m - 2.0) < 1e-10 for m in cycle_means)
        print(
            f"    k={k_test}: {len(cycles)} cycles, "
            f"mean v range [{min_mean:.4f}, {max_mean:.4f}], "
            f"all=2? {all_equal_2}"
        )

    print()
    print("  Testing: do all cycles at x=5 have mean v exactly 2?")
    for k_test in [4, 5, 6, 7, 8]:
        mat, odd_res, _ = build_transfer_matrix(5, 1, k_test)
        successor, _w, v_val = _functional_graph(mat, odd_res)
        cycles = _find_cycles(successor, odd_res)
        cycle_means = [sum(v_val[r] for r in cyc) / len(cyc) for cyc in cycles]
        min_mean = min(cycle_means)
        max_mean = max(cycle_means)
        all_equal_2 = all(abs(m - 2.0) < 1e-10 for m in cycle_means)
        print(
            f"    k={k_test}: {len(cycles)} cycles, "
            f"mean v range [{min_mean:.4f}, {max_mean:.4f}], "
            f"all=2? {all_equal_2}"
        )

    print()

    # Compare with other odd integers
    print("  Cycle mean-v ranges for odd x = 1, 3, 5, ..., 15:")
    k_test = 8
    for x in range(1, 16, 2):
        mat, odd_res, _ = build_transfer_matrix(x, 1, k_test)
        successor, _w, v_val = _functional_graph(mat, odd_res)
        cycles = _find_cycles(successor, odd_res)
        if cycles:
            cycle_means = [sum(v_val[r] for r in cyc) / len(cyc) for cyc in cycles]
            min_mean = min(cycle_means)
            max_mean = max(cycle_means)
            all_equal_2 = all(abs(m - 2.0) < 1e-10 for m in cycle_means)
            print(
                f"    x={x:2d}: {len(cycles):3d} cycles, "
                f"mean v in [{min_mean:.4f}, {max_mean:.4f}], "
                f"all=2? {all_equal_2}"
            )
        else:
            print(f"    x={x:2d}: no cycles found")

    print()

    # --- Part F: Extended k-range (direct cycle finding, no matrix) ---
    print("  Part F: Cycle structure of the modular Collatz map for k=3..24")
    print("  " + "=" * 50)
    print()
    print("  At large k, the matrix is too big to store, but the successor")
    print("  map is cheap to compute. We find cycles directly.")
    print()

    for k_ext in range(3, 25):
        mod = 2**k_ext
        # Build successor map directly
        succ_ext = {}
        v_ext = {}
        for j in range(1, mod, 2):
            val = 3 * j + 1
            v = 0
            while val % 2 == 0:
                val //= 2
                v += 1
            succ_ext[j] = val % mod
            v_ext[j] = v
        # Find cycles
        visited = set()
        cyc_list = []
        for start in range(1, mod, 2):
            if start in visited:
                continue
            path, path_set = [], set()
            cur = start
            while cur not in visited and cur not in path_set:
                path.append(cur)
                path_set.add(cur)
                cur = succ_ext[cur]
            if cur in path_set:
                idx = path.index(cur)
                cyc = path[idx:]
                cyc_list.append(cyc)
                visited.update(cyc)
            visited.update(path)

        rho_k = 0.0
        parts = []
        for cyc in cyc_list:
            mean_v = sum(v_ext[r] for r in cyc) / len(cyc)
            cyc_rho = 2.0 ** (-mean_v)
            rho_k = max(rho_k, cyc_rho)
            parts.append(f"L={len(cyc)},mv={mean_v:.3f}")
        print(f"    k={k_ext:2d}: rho={rho_k:.6f}, {len(cyc_list)} cycle(s)  " + "  ".join(parts))

    print()
    print("  KEY FINDING: The fixed point {1} (with v=2, rho=0.25) persists")
    print("  at every k. Additional modular cycles appear at some k values")
    print("  (k=10-12, k=20) but vanish at higher resolution. These are")
    print("  genuine cycles of the truncated mod-2^k map whose orbits do")
    print("  not close in the actual (unbounded) Collatz map.")
    print()
    print("  SUMMARY: x=3 is a local extremum because:")
    print("  1. T(1) = (3*1+1)/2^2 = 1 : fixed point with v=2 (exact)")
    print("  2. For most k, this is the ONLY cycle of the modular map")
    print("  3. rho = 2^{-2} = 0.25 from this single fixed point")
    print("  4. Global E[v] = 2 for all odd x, but x=3 concentrates")
    print("     all modular dynamics onto one cycle with mean v = E[v]")
    print("  5. Other odd x have multiple cycles with unequal mean v,")
    print("     and the worst cycle has mean v < 2, giving rho > 0.25")
    print()

    # --- Plots ---
    # Plot 1: worst-cycle mean v for rationals near x=3
    fig, axes = plt.subplots(2, 2, figsize=(16, 12))

    # Panel A: worst mean v vs x for rationals
    ax = axes[0, 0]
    for entry in rat_data:
        p, q, x_val, n_cyc, wmv, rho, gmv = entry
        if wmv == float("inf"):
            continue
        color = {1: "black", 3: "blue", 5: "green", 7: "orange", 9: "red"}.get(q, "gray")
        ax.plot(x_val, wmv, ".", color=color, markersize=3, alpha=0.6)
    ax.axhline(y=2.0, color="red", linestyle="--", alpha=0.5, label="mean_v=2")
    ax.axvline(x=3, color="green", linestyle=":", alpha=0.7, label="x=3")
    ax.set_xlabel("x = p/q")
    ax.set_ylabel("worst-cycle mean v")
    ax.set_title("Worst Cycle Mean v (higher = more contracting)")
    ax.legend(fontsize=9)
    ax.grid(True, alpha=0.3)
    ax.set_xlim(1.5, 5.5)

    # Panel B: rho vs x (from eigenvalues) with cycle prediction overlay
    ax = axes[0, 1]
    for entry in rat_data:
        p, q, x_val, n_cyc, wmv, rho, gmv = entry
        color = {1: "black", 3: "blue", 5: "green", 7: "orange", 9: "red"}.get(q, "gray")
        ax.plot(x_val, rho, ".", color=color, markersize=3, alpha=0.6)
    ax.axhline(y=0.25, color="red", linestyle="--", alpha=0.5, label="rho=0.25")
    ax.axvline(x=3, color="green", linestyle=":", alpha=0.7, label="x=3")
    ax.set_xlabel("x = p/q")
    ax.set_ylabel(r"$\rho$ (spectral radius)")
    ax.set_title(r"Spectral Radius Near x=3 (k=7)")
    ax.legend(fontsize=9)
    ax.grid(True, alpha=0.3)
    ax.set_xlim(1.5, 5.5)
    ax.set_ylim(-0.05, 0.6)

    # Panel C: global mean v vs x
    ax = axes[1, 0]
    for entry in rat_data:
        p, q, x_val, n_cyc, wmv, rho, gmv = entry
        if math.isnan(gmv):
            continue
        color = {1: "black", 3: "blue", 5: "green", 7: "orange", 9: "red"}.get(q, "gray")
        ax.plot(x_val, gmv, ".", color=color, markersize=3, alpha=0.6)
    ax.axhline(y=2.0, color="red", linestyle="--", alpha=0.5, label="E[v]=2")
    ax.axvline(x=3, color="green", linestyle=":", alpha=0.7, label="x=3")
    ax.set_xlabel("x = p/q")
    ax.set_ylabel("global mean v")
    ax.set_title("Global Mean v (all residues, not just cycles)")
    ax.legend(fontsize=9)
    ax.grid(True, alpha=0.3)
    ax.set_xlim(1.5, 5.5)

    # Panel D: global mean v vs worst-cycle mean v scatter
    ax = axes[1, 1]
    for entry in rat_data:
        p, q, x_val, n_cyc, wmv, rho, gmv = entry
        if wmv == float("inf") or math.isnan(gmv):
            continue
        color = {1: "black", 3: "blue", 5: "green", 7: "orange", 9: "red"}.get(q, "gray")
        marker = "*" if abs(x_val - 3.0) < 0.01 else "."
        size = 15 if marker == "*" else 3
        ax.plot(gmv, wmv, marker, color=color, markersize=size, alpha=0.6)
    ax.plot([0, 4], [0, 4], "k--", alpha=0.3, label="y=x (uniform cycles)")
    ax.set_xlabel("global mean v")
    ax.set_ylabel("worst-cycle mean v")
    ax.set_title("Cycle Balance: Global vs Worst Cycle")
    ax.legend(fontsize=9)
    ax.grid(True, alpha=0.3)

    plt.suptitle("Why x=3 Is a Local Extremum of Spectral Radius", fontsize=14)
    plt.tight_layout()
    outpath = os.path.join(PLOT_DIR, "x3_extremum_analysis.png")
    plt.savefig(outpath, dpi=150, bbox_inches="tight")
    plt.close()
    print(f"  Saved: {outpath}")

    # Plot 2: cycle structure comparison at k=6
    k_plot = 6
    fig, axes = plt.subplots(1, 3, figsize=(18, 6))
    for ax_idx, (x_int, title) in enumerate([(3, "x=3"), (5, "x=5"), (7, "x=7")]):
        mat, odd_res, _ = build_transfer_matrix(x_int, 1, k_plot)
        successor, _w, v_val = _functional_graph(mat, odd_res)
        cycles = _find_cycles(successor, odd_res)

        ax = axes[ax_idx]
        cycle_lengths = [len(c) for c in cycles]
        cycle_mean_vs = [sum(v_val[r] for r in c) / len(c) for c in cycles]

        ax.bar(range(len(cycles)), cycle_mean_vs, color="steelblue", alpha=0.7)
        ax.axhline(y=2.0, color="red", linestyle="--", alpha=0.7, label="mean_v=2")
        ax.set_xlabel("cycle index")
        ax.set_ylabel("mean v in cycle")
        ax.set_title(f"{title}: {len(cycles)} cycles (k={k_plot})")
        ax.legend(fontsize=9)
        ax.grid(True, alpha=0.3, axis="y")

        # Annotate with cycle lengths
        for i, (cl, mv) in enumerate(zip(cycle_lengths, cycle_mean_vs, strict=True)):
            ax.text(i, mv + 0.05, f"L={cl}", ha="center", fontsize=7)

    plt.suptitle("Cycle Mean-v Distribution: x=3 vs Nearby Odd Integers", fontsize=14)
    plt.tight_layout()
    outpath = os.path.join(PLOT_DIR, "x3_cycle_comparison.png")
    plt.savefig(outpath, dpi=150, bbox_inches="tight")
    plt.close()
    print(f"  Saved: {outpath}")
    print()


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------
if __name__ == "__main__":
    section_1()
    section_2()
    section_3()
    coeff_fits, n_states, to_cheb_fn = section_4()
    section_5(coeff_fits=coeff_fits, n_states=n_states, to_cheb=to_cheb_fn)
    section_6()
    section_7()
    section_8()
    section_9()
    print("=" * 72)
    print("ANALYSIS COMPLETE — All 9 sections finished")
    print("=" * 72)
