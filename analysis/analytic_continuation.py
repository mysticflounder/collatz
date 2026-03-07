"""
Spectral continuation, autocorrelation structure, and growth metrics
for the generalized Collatz family T(n) = (xn+y) / 2^v.

Three directions, nine sections:
  Direction 1 — Transfer Operators (Sections 1-4)
    1. Modular transfer matrix on residue classes mod 2^k
    2. Spectral radius rho(x) across the phase transition
    3. Truncated transfer matrix on actual integers
    4. Dynamical zeta function via Padé approximants

  Direction 2 — Autocorrelation Mystery (Sections 5-7)
    5. Variance multiplier across (x, y) space
    6. v-Transition matrices
    7. Mechanistic explanation via residue classes

  Direction 3 — carykh's Growth Metric (Sections 8-9)
    8. Geometric mean of peak/start and average path length
    9. Phase diagram overlay (convergence, growth, path length, variance)
"""

import contextlib
import math
import os
import sys
from collections import Counter

import matplotlib
import numpy as np
from scipy.interpolate import pade
from scipy.linalg import eig

matplotlib.use("Agg")
import matplotlib.pyplot as plt  # noqa: E402

sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))

PLOT_DIR = os.path.dirname(__file__)


# ---------------------------------------------------------------------------
# Local helpers (redefined to avoid import-time execution of generalized_collatz.py)
# ---------------------------------------------------------------------------
def syracuse_general(n, x, y):
    """Syracuse map: odd n -> (xn + y) / 2^v. Returns (result, v)."""
    val = x * n + y
    if val <= 0:
        return None, 0
    v = 0
    while val % 2 == 0:
        val //= 2
        v += 1
    return val, v


def trajectory_general(n, x, y, max_steps=2000):
    """Trajectory of odd n under the (x, y) Syracuse map.

    Returns: (values, v_sequence, outcome).
    """
    values = [n]
    vs = []
    visited = {n: 0}
    for step in range(1, max_steps + 1):
        result, v = syracuse_general(n, x, y)
        if result is None:
            return values, vs, "non-positive"
        vs.append(v)
        if result in visited:
            values.append(result)
            return values, vs, "cycle"
        if result > n * 1000 and step > 50:
            values.append(result)
            return values, vs, "diverged"
        visited[result] = step
        values.append(result)
        n = result
    return values, vs, "diverged"


def collatz_full(n, x, y, max_steps=100000):
    """Full Collatz trajectory (even steps included) for T(n) = xn+y."""
    trajectory = [n]
    visited = {n}
    for _ in range(max_steps):
        if n % 2 == 0:
            n = n // 2
        else:
            val = x * n + y
            if val <= 0:
                break
            n = val
        trajectory.append(n)
        if n == 1:
            break
        if n in visited:
            break
        if n > 10**18:
            break
        visited.add(n)
    return trajectory


def v_sequence_general(n, x, y, max_steps=1000):
    """v-sequence for the (x, y) Syracuse map."""
    vs = []
    visited = {n}
    for _ in range(max_steps):
        result, v = syracuse_general(n, x, y)
        if result is None:
            break
        vs.append(v)
        if result == 1 and x <= 3:
            break
        if result in visited:
            break
        if result > 10**15:
            break
        visited.add(result)
        n = result
    return vs


def autocorrelation(seq, max_lag=20):
    """Normalised autocorrelation for lags 1..max_lag."""
    x = np.array(seq, dtype=np.float64)
    n = len(x)
    if n < max_lag + 1:
        return None
    mu = x.mean()
    var = ((x - mu) ** 2).sum()
    if var == 0:
        return None
    ac = np.empty(max_lag)
    for lag in range(1, max_lag + 1):
        ac[lag - 1] = ((x[: n - lag] - mu) * (x[lag:] - mu)).sum() / var
    return ac


# ===================================================================
# DIRECTION 1: TRANSFER OPERATORS (Sections 1-4)
# ===================================================================


def section_1():
    """Modular transfer matrix on residue classes mod 2^k."""
    print("=" * 72)
    print("SECTION 1: Modular Transfer Matrix on Residue Classes mod 2^k")
    print("=" * 72)
    print()
    print("State space: odd residues {1, 3, ..., 2^k - 1}, size N = 2^(k-1)")
    print("P[i,j] = 2^{-v(j)} if T_{x,y}(j) ≡ i (mod 2^k), else 0")
    print()

    results = []

    for k in range(3, 9):
        mod = 2**k
        odd_residues = list(range(1, mod, 2))
        n_states = len(odd_residues)
        idx_map = {r: i for i, r in enumerate(odd_residues)}

        for x in [1, 3, 5, 7]:
            y = 1
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
                    i_idx = idx_map[target]
                    mat[i_idx, j_idx] = 2.0 ** (-v)

            eigenvalues = eig(mat, right=False)
            mods = np.abs(eigenvalues)
            spectral_radius = np.max(mods)
            sorted_mods = np.sort(mods)[::-1]
            spectral_gap = sorted_mods[0] - sorted_mods[1] if len(sorted_mods) > 1 else 0.0

            results.append((k, x, spectral_radius, spectral_gap))

    print(f"  {'k':>3}  {'x':>3}  {'N':>5}  {'ρ (spectral radius)':>20}  {'gap':>10}")
    print(f"  {'—' * 3}  {'—' * 3}  {'—' * 5}  {'—' * 20}  {'—' * 10}")
    for k, x, rho, gap in results:
        n_states = 2 ** (k - 1)
        print(f"  {k:3d}  {x:3d}  {n_states:5d}  {rho:20.6f}  {gap:10.6f}")

    print()
    return results


def section_2():
    """Spectral radius rho(x) across the phase transition."""
    print("=" * 72)
    print("SECTION 2: Spectral Radius ρ(x) Across the Phase Transition")
    print("=" * 72)
    print()

    x_values = [1, 3, 5, 7, 9, 11, 13, 15]
    k_values = [4, 5, 6, 7, 8]

    fig, ax = plt.subplots(figsize=(12, 7))

    for k in k_values:
        mod = 2**k
        odd_residues = list(range(1, mod, 2))
        n_states = len(odd_residues)
        idx_map = {r: i for i, r in enumerate(odd_residues)}

        rho_list = []
        for x in x_values:
            y = 1
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

            eigenvalues = eig(mat, right=False)
            rho_list.append(np.max(np.abs(eigenvalues)))

        ax.plot(x_values, rho_list, "o-", label=f"k={k}", markersize=6)

    ax.axvline(x=4, color="gray", linestyle="--", alpha=0.5, label="Phase transition x=4")
    ax.axhline(y=1, color="red", linestyle=":", alpha=0.5, label="ρ = 1")
    ax.set_xlabel("x (multiplier)", fontsize=13)
    ax.set_ylabel("Spectral radius ρ(x)", fontsize=13)
    ax.set_title("Transfer Matrix Spectral Radius vs x (mod 2^k)", fontsize=14)
    ax.legend(fontsize=10)
    ax.grid(True, alpha=0.3)

    outpath = os.path.join(PLOT_DIR, "spectral_radius_vs_x.png")
    plt.tight_layout()
    plt.savefig(outpath, dpi=150, bbox_inches="tight")
    plt.close()
    print(f"  Saved: {outpath}")
    print()


def section_3():
    """Truncated transfer matrix on actual integers."""
    print("=" * 72)
    print("SECTION 3: Truncated Transfer Matrix on Actual Integers")
    print("=" * 72)
    print()
    print("Restrict to odd integers {1, 3, ..., 2N-1}, build N×N matrix.")
    print()

    x_test = 3
    y_test = 1
    n_sizes = [50, 100, 250, 500, 1000]

    print(f"  x={x_test}, y={y_test}")
    print(f"  {'N':>6}  {'ρ (spectral radius)':>20}  {'gap':>10}")
    print(f"  {'—' * 6}  {'—' * 20}  {'—' * 10}")

    for n_sz in n_sizes:
        odd_ints = list(range(1, 2 * n_sz, 2))
        idx_map = {r: i for i, r in enumerate(odd_ints)}
        mat = np.zeros((n_sz, n_sz))

        for j_idx, j_val in enumerate(odd_ints):
            val = x_test * j_val + y_test
            v = 0
            while val % 2 == 0:
                val //= 2
                v += 1
            if val in idx_map:
                mat[idx_map[val], j_idx] = 2.0 ** (-v)

        eigenvalues = eig(mat, right=False)
        mods = np.abs(eigenvalues)
        spectral_radius = np.max(mods)
        sorted_mods = np.sort(mods)[::-1]
        gap = sorted_mods[0] - sorted_mods[1] if len(sorted_mods) > 1 else 0.0
        print(f"  {n_sz:6d}  {spectral_radius:20.6f}  {gap:10.6f}")

    print()

    # Also compare across x values at fixed N=500
    n_sz = 500
    odd_ints = list(range(1, 2 * n_sz, 2))
    idx_map = {r: i for i, r in enumerate(odd_ints)}

    print(f"  Comparison across x (N={n_sz}):")
    print(f"  {'x':>3}  {'ρ (truncated)':>15}  {'ρ (modular k=8)':>17}")
    print(f"  {'—' * 3}  {'—' * 15}  {'—' * 17}")

    for x in [1, 3, 5, 7]:
        y = 1
        mat = np.zeros((n_sz, n_sz))
        for j_idx, j_val in enumerate(odd_ints):
            val = x * j_val + y
            if val <= 0:
                continue
            v = 0
            while val % 2 == 0:
                val //= 2
                v += 1
            if val in idx_map:
                mat[idx_map[val], j_idx] = 2.0 ** (-v)

        eigenvalues = eig(mat, right=False)
        rho_trunc = np.max(np.abs(eigenvalues))

        # Modular approach at k=8
        mod = 2**8
        odd_res = list(range(1, mod, 2))
        n_states = len(odd_res)
        idx_map_mod = {r: i for i, r in enumerate(odd_res)}
        mat_mod = np.zeros((n_states, n_states))
        for j_idx, j_res in enumerate(odd_res):
            val = x * j_res + y
            if val <= 0:
                continue
            v = 0
            while val % 2 == 0:
                val //= 2
                v += 1
            target = val % mod
            if target in idx_map_mod:
                mat_mod[idx_map_mod[target], j_idx] = 2.0 ** (-v)
        eigenvalues_mod = eig(mat_mod, right=False)
        rho_mod = np.max(np.abs(eigenvalues_mod))

        print(f"  {x:3d}  {rho_trunc:15.6f}  {rho_mod:17.6f}")

    print()


def section_4():
    """Dynamical zeta function via Padé approximants."""
    print("=" * 72)
    print("SECTION 4: Dynamical Zeta Function via Padé Approximants")
    print("=" * 72)
    print()
    print("log ζ(z) = Σ (z^n / n) · Tr(P^n)")
    print("Compute traces from modular matrix (k=6, 32×32)")
    print()

    k = 6
    mod = 2**k
    odd_residues = list(range(1, mod, 2))
    n_states = len(odd_residues)
    idx_map = {r: i for i, r in enumerate(odd_residues)}

    for x in [3, 5, 7]:
        y = 1
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

        # Compute traces Tr(P^n) for n = 1..20
        max_power = 20
        traces = np.zeros(max_power)
        mat_pow = np.eye(n_states)
        for n in range(max_power):
            mat_pow = mat_pow @ mat
            traces[n] = np.trace(mat_pow)

        print(f"  x={x}: Tr(P^n) for n=1..{max_power}:")
        for n in range(max_power):
            print(f"    n={n + 1:2d}: Tr(P^n) = {traces[n]:.8f}")

        # log zeta coefficients: a_n = Tr(P^n) / n
        log_zeta_coeffs = np.array([traces[n] / (n + 1) for n in range(max_power)])

        # Exponentiate to get zeta: exp(Σ a_n z^n) using polynomial truncation
        # Build power series for zeta(z) by exponentiating log_zeta
        # Use the identity: if log f = Σ c_n z^n, then f' = f * (log f)'
        # so f_n = (1/n) Σ_{k=1}^{n} k * c_k * f_{n-k}
        zeta_coeffs = np.zeros(max_power + 1)
        zeta_coeffs[0] = 1.0  # zeta(0) = 1
        for n in range(1, max_power + 1):
            s = 0.0
            for kk in range(1, n + 1):
                if kk - 1 < len(log_zeta_coeffs):
                    s += kk * log_zeta_coeffs[kk - 1] * zeta_coeffs[n - kk]
            zeta_coeffs[n] = s / n

        # Padé approximant [m_order/m_order] where m_order = max_power // 2
        m_order = max_power // 2
        try:
            p_coeffs, q_coeffs = pade(zeta_coeffs[: 2 * m_order + 1], m_order)
            # Poles are roots of q(z)
            q_roots = np.roots(q_coeffs.c)
            print(f"  Padé [{m_order}/{m_order}] poles (roots of denominator):")
            for root in sorted(q_roots, key=lambda z: abs(z)):
                print(f"    z = {root.real:+.6f} {root.imag:+.6f}i  (|z| = {abs(root):.6f})")
        except Exception as e:
            print(f"  Padé computation failed: {e}")
            q_roots = np.array([])

        print()

    # Plot poles for x=3
    print("  Generating pole plot for x=3...")
    y = 1
    x = 3
    mat = np.zeros((n_states, n_states))
    for j_idx, j_res in enumerate(odd_residues):
        val = x * j_res + y
        v = 0
        while val % 2 == 0:
            val //= 2
            v += 1
        target = val % mod
        if target in idx_map:
            mat[idx_map[target], j_idx] = 2.0 ** (-v)

    traces = np.zeros(max_power)
    mat_pow = np.eye(n_states)
    for n in range(max_power):
        mat_pow = mat_pow @ mat
        traces[n] = np.trace(mat_pow)

    log_zeta_coeffs = np.array([traces[n] / (n + 1) for n in range(max_power)])
    zeta_coeffs = np.zeros(max_power + 1)
    zeta_coeffs[0] = 1.0
    for n in range(1, max_power + 1):
        s = 0.0
        for kk in range(1, n + 1):
            if kk - 1 < len(log_zeta_coeffs):
                s += kk * log_zeta_coeffs[kk - 1] * zeta_coeffs[n - kk]
        zeta_coeffs[n] = s / n

    fig, axes = plt.subplots(1, 3, figsize=(18, 6))

    for ax_idx, (x_val, title) in enumerate([(3, "x=3 (Collatz)"), (5, "x=5"), (7, "x=7")]):
        mat_loc = np.zeros((n_states, n_states))
        for j_idx, j_res in enumerate(odd_residues):
            val = x_val * j_res + 1
            if val <= 0:
                continue
            v = 0
            while val % 2 == 0:
                val //= 2
                v += 1
            target = val % mod
            if target in idx_map:
                mat_loc[idx_map[target], j_idx] = 2.0 ** (-v)

        tr = np.zeros(max_power)
        mp = np.eye(n_states)
        for nn in range(max_power):
            mp = mp @ mat_loc
            tr[nn] = np.trace(mp)

        lzc = np.array([tr[nn] / (nn + 1) for nn in range(max_power)])
        zc = np.zeros(max_power + 1)
        zc[0] = 1.0
        for nn in range(1, max_power + 1):
            s = 0.0
            for kk in range(1, nn + 1):
                if kk - 1 < len(lzc):
                    s += kk * lzc[kk - 1] * zc[nn - kk]
            zc[nn] = s / nn

        try:
            p_c, q_c = pade(zc[: 2 * m_order + 1], m_order)
            q_r = np.roots(q_c.c)
        except Exception:
            q_r = np.array([])

        ax = axes[ax_idx]
        if len(q_r) > 0:
            ax.scatter(q_r.real, q_r.imag, c="red", s=60, zorder=5, label="Poles")
        theta = np.linspace(0, 2 * np.pi, 100)
        ax.plot(np.cos(theta), np.sin(theta), "k--", alpha=0.3, label="Unit circle")
        ax.set_xlabel("Re(z)")
        ax.set_ylabel("Im(z)")
        ax.set_title(f"Zeta Poles: {title}")
        ax.set_aspect("equal")
        ax.grid(True, alpha=0.3)
        ax.legend(fontsize=8)

    plt.suptitle("Dynamical Zeta Function Poles (Padé Approximant)", fontsize=14, y=1.02)
    plt.tight_layout()
    outpath = os.path.join(PLOT_DIR, "zeta_pade_poles.png")
    plt.savefig(outpath, dpi=150, bbox_inches="tight")
    plt.close()
    print(f"  Saved: {outpath}")
    print()


# ===================================================================
# DIRECTION 2: AUTOCORRELATION MYSTERY (Sections 5-7)
# ===================================================================


def section_5():
    """Variance multiplier across (x, y) space."""
    print("=" * 72)
    print("SECTION 5: Variance Multiplier Across (x, y) Space")
    print("=" * 72)
    print()
    print("Variance multiplier = 1 + 2·Σ ACF[k] for k=1..max_lag")
    print("Known: 3n+1 → ~1.07, 3n-1 → ~0.65")
    print()

    x_vals = [1, 3, 5, 7, 9, 11]
    y_vals = list(range(-9, 12, 2))
    n_max = 10000
    max_lag = 20

    vm_grid = np.full((len(x_vals), len(y_vals)), np.nan)

    for ix, x in enumerate(x_vals):
        for iy, y in enumerate(y_vals):
            all_vs = []
            for n in range(3, n_max + 1, 2):
                if x * n + y <= 0:
                    continue
                vs = v_sequence_general(n, x, y, max_steps=500)
                if len(vs) > max_lag + 5:
                    all_vs.extend(vs)

            if len(all_vs) < max_lag + 10:
                continue

            ac = autocorrelation(all_vs, max_lag)
            if ac is not None:
                vm = 1.0 + 2.0 * np.sum(ac)
                vm_grid[ix, iy] = vm

    # Print table
    xy_label = "x\\y"
    header = f"  {xy_label:>5}"
    for y in y_vals:
        header += f"  {y:+5d}"
    print(header)
    print("  " + "—" * (5 + 7 * len(y_vals)))
    for ix, x in enumerate(x_vals):
        row = f"  {x:5d}"
        for iy in range(len(y_vals)):
            val = vm_grid[ix, iy]
            if np.isnan(val):
                row += "      -"
            else:
                row += f"  {val:5.3f}"
        print(row)

    # Heatmap
    fig, ax = plt.subplots(figsize=(14, 6))
    masked = np.ma.masked_invalid(vm_grid)
    im = ax.imshow(masked, aspect="auto", origin="lower", cmap="RdBu_r", vmin=0.4, vmax=1.6)
    ax.set_xticks(range(len(y_vals)))
    ax.set_xticklabels([f"{y:+d}" for y in y_vals], fontsize=8)
    ax.set_yticks(range(len(x_vals)))
    ax.set_yticklabels(x_vals)
    ax.set_xlabel("y (offset)")
    ax.set_ylabel("x (multiplier)")
    ax.set_title(
        "Variance Multiplier: 1 + 2·Σ ACF(k)\n(>1 = positive autocorrelation, <1 = negative)"
    )
    plt.colorbar(im, ax=ax, label="Variance multiplier")

    plt.tight_layout()
    outpath = os.path.join(PLOT_DIR, "variance_multiplier_heatmap.png")
    plt.savefig(outpath, dpi=150, bbox_inches="tight")
    plt.close()
    print(f"\n  Saved: {outpath}")

    # Selected pairs at higher N
    print("\n  Selected pairs at N=50,000:")
    selected = [(3, 1), (3, -1), (5, 1), (5, -1), (7, 1), (7, -1)]
    for x, y in selected:
        all_vs = []
        for n in range(3, 50001, 2):
            if x * n + y <= 0:
                continue
            vs = v_sequence_general(n, x, y, max_steps=1000)
            if len(vs) > max_lag + 5:
                all_vs.extend(vs)
        if len(all_vs) < max_lag + 10:
            print(f"    ({x}, {y:+d}): insufficient data")
            continue
        ac = autocorrelation(all_vs, max_lag)
        if ac is not None:
            vm = 1.0 + 2.0 * np.sum(ac)
            print(f"    ({x}, {y:+d}): VM = {vm:.4f}  (ACF[1] = {ac[0]:+.4f})")

    print()
    return vm_grid


def section_6():
    """v-Transition matrices: P(v_{i+1} = j | v_i = k)."""
    print("=" * 72)
    print("SECTION 6: v-Transition Matrices")
    print("=" * 72)
    print()
    print("Build empirical P(v_{i+1} = j | v_i = k) for selected (x, y) pairs.")
    print("Cap v at 6 for readability.")
    print()

    v_cap = 6
    pairs = [(3, 1), (3, -1), (5, 1), (5, -1)]

    for x, y in pairs:
        # Build transition counts
        trans = np.zeros((v_cap, v_cap))
        total_transitions = 0

        for n in range(3, 10001, 2):
            if x * n + y <= 0:
                continue
            vs = v_sequence_general(n, x, y, max_steps=300)
            for i in range(len(vs) - 1):
                v_cur = min(vs[i], v_cap) - 1
                v_nxt = min(vs[i + 1], v_cap) - 1
                trans[v_cur, v_nxt] += 1
                total_transitions += 1

        # Normalise rows
        row_sums = trans.sum(axis=1)
        p_trans = np.zeros_like(trans)
        for i in range(v_cap):
            if row_sums[i] > 0:
                p_trans[i] = trans[i] / row_sums[i]

        # Marginal distribution
        marginal = trans.sum(axis=0) / total_transitions

        # KL divergence per row from marginal
        kl_per_row = np.zeros(v_cap)
        for i in range(v_cap):
            for j in range(v_cap):
                if p_trans[i, j] > 0 and marginal[j] > 0:
                    kl_per_row[i] += p_trans[i, j] * np.log2(p_trans[i, j] / marginal[j])

        print(f"  ({x}, {y:+d}): {total_transitions:,} transitions")
        col_label = "v_i\\v_{i+1}"
        print(f"  {col_label:>10}", end="")
        for j in range(1, v_cap + 1):
            print(f"  {j:>6}", end="")
        print(f"  {'KL(row‖marg)':>13}")
        print("  " + "—" * (10 + 8 * v_cap + 13))

        for i in range(v_cap):
            row_str = f"  {i + 1:>10}"
            for j in range(v_cap):
                row_str += f"  {p_trans[i, j]:6.3f}"
            row_str += f"  {kl_per_row[i]:13.6f}"
            print(row_str)

        total_kl = np.sum(kl_per_row * row_sums / total_transitions)
        print(f"  Weighted mean KL: {total_kl:.6f} bits")
        print()

    print()


def section_7():
    """Mechanistic explanation via residue classes."""
    print("=" * 72)
    print("SECTION 7: Mechanistic Explanation — Residue Class Landing Patterns")
    print("=" * 72)
    print()
    print("After v_i = k, track n_{i+1} mod 2^m and what v_{i+1} they force.")
    print("The +1 vs -1 creates different residue-class landing patterns.")
    print()

    for x, y in [(3, 1), (3, -1)]:
        print(f"  === ({x}, {y:+d}) ===")
        for m in [4, 5, 6]:
            mod = 2**m
            # For each v_i value, track the distribution of n_{i+1} mod 2^m
            # and the resulting v_{i+1}
            v_to_residue_dist = {}
            v_to_next_v = {}

            for n in range(3, 5001, 2):
                if x * n + y <= 0:
                    continue
                cur = n
                visited = {cur}
                for _step in range(300):
                    val = x * cur + y
                    if val <= 0:
                        break
                    v_cur = 0
                    while val % 2 == 0:
                        val //= 2
                        v_cur += 1
                    next_n = val
                    if next_n > 10**15:
                        break
                    val2 = x * next_n + y
                    if val2 <= 0:
                        break
                    v_next = 0
                    while val2 % 2 == 0:
                        val2 //= 2
                        v_next += 1

                    v_key = min(v_cur, 6)
                    if v_key not in v_to_residue_dist:
                        v_to_residue_dist[v_key] = Counter()
                        v_to_next_v[v_key] = []
                    v_to_residue_dist[v_key][next_n % mod] += 1
                    v_to_next_v[v_key].append(v_next)

                    if next_n == 1:
                        break
                    if next_n in visited:
                        break
                    visited.add(next_n)
                    cur = next_n

            print(f"  mod 2^{m} = {mod}:")
            for v_i in [1, 2, 3, 4]:
                if v_i not in v_to_next_v:
                    continue
                mean_next_v = np.mean(v_to_next_v[v_i])
                label = "v_{i+1}"
                print(f"    v_i={v_i}: E[{label}] = {mean_next_v:.4f}  ", end="")
                # Show top 3 residues
                top = v_to_residue_dist[v_i].most_common(3)
                total_r = sum(v_to_residue_dist[v_i].values())
                parts = [f"{r}({c / total_r:.2f})" for r, c in top]
                print(f"top residues mod {mod}: {', '.join(parts)}")
        print()

    # Summary comparison — single pass per (x, y) to collect all (v_cur, v_next) pairs
    print("  Summary: E[v_{i+1}] conditional on v_i")
    print(f"  {'v_i':>5}  {'(3,+1)':>8}  {'(3,-1)':>8}  {'diff':>8}")
    print(f"  {'—' * 5}  {'—' * 8}  {'—' * 8}  {'—' * 8}")

    all_means = {}
    for x, y in [(3, 1), (3, -1)]:
        # Collect all (v_cur, v_next) pairs in one pass
        next_vs_by_vi = {vi: [] for vi in range(1, 7)}
        for n in range(3, 5001, 2):
            if x * n + y <= 0:
                continue
            cur = n
            visited = {cur}
            for _step in range(300):
                val = x * cur + y
                if val <= 0:
                    break
                v = 0
                while val % 2 == 0:
                    val //= 2
                    v += 1
                next_n = val
                if next_n > 10**15:
                    break
                if v <= 5:
                    val2 = x * next_n + y
                    if val2 > 0:
                        v2 = 0
                        while val2 % 2 == 0:
                            val2 //= 2
                            v2 += 1
                        next_vs_by_vi[v].append(v2)
                if next_n == 1:
                    break
                if next_n in visited:
                    break
                visited.add(next_n)
                cur = next_n
        all_means[(x, y)] = {
            vi: np.mean(vals) if vals else float("nan") for vi, vals in next_vs_by_vi.items()
        }

    for v_i in [1, 2, 3, 4, 5]:
        m1 = all_means[(3, 1)].get(v_i, float("nan"))
        m2 = all_means[(3, -1)].get(v_i, float("nan"))
        diff = m1 - m2
        print(f"  {v_i:5d}  {m1:8.4f}  {m2:8.4f}  {diff:+8.4f}")

    print()
    print("  Key insight: For 3n+1, large v → residues that produce large subsequent v")
    print("  (positive ACF). For 3n-1, large v → residues producing small v (negative ACF).")
    print("  The +1 vs -1 creates different residue-class landing patterns after division.")
    print()


# ===================================================================
# DIRECTION 3: CARYKH'S GROWTH METRIC (Sections 8-9)
# ===================================================================


def section_8():
    """Geometric mean of peak/start and average path length."""
    print("=" * 72)
    print("SECTION 8: carykh's Growth Metric — Peak/Start Ratio & Path Length")
    print("=" * 72)
    print()
    print("growth(n) = max(trajectory) / n")
    print("G = geometric_mean(growth(n)) = exp(mean(log(growth)))")
    print("Using FULL Collatz trajectory (even steps included)")
    print()

    x_vals = [1, 3, 5, 7, 9, 11]
    y_vals = list(range(-9, 12, 2))
    n_grid = 10000

    growth_grid = np.full((len(x_vals), len(y_vals)), np.nan)
    pathlen_grid = np.full((len(x_vals), len(y_vals)), np.nan)

    for ix, x in enumerate(x_vals):
        for iy, y in enumerate(y_vals):
            log_growths = []
            path_lens = []

            for n in range(3, n_grid + 1, 2):
                if x * n + y <= 0:
                    continue
                traj = collatz_full(n, x, y, max_steps=50000)
                if len(traj) < 2:
                    continue
                peak = max(traj)
                if n > 0 and peak > 0:
                    with contextlib.suppress(OverflowError, ValueError):
                        log_growths.append(math.log(peak) - math.log(n))
                path_lens.append(len(traj))

            if log_growths:
                mean_log_g = np.mean(log_growths)
                try:
                    g_val = math.exp(mean_log_g)
                except OverflowError:
                    g_val = float("inf")
                growth_grid[ix, iy] = g_val
                pathlen_grid[ix, iy] = np.mean(path_lens)

    # Print growth table
    print("  Geometric mean growth G = exp(mean(log(peak/start))):")
    xy_label = "x\\y"
    header = f"  {xy_label:>5}"
    for y in y_vals:
        header += f"  {y:+6d}"
    print(header)
    print("  " + "—" * (5 + 8 * len(y_vals)))
    for ix, x in enumerate(x_vals):
        row = f"  {x:5d}"
        for iy in range(len(y_vals)):
            val = growth_grid[ix, iy]
            if np.isnan(val):
                row += "       -"
            else:
                row += f"  {val:6.2f}"
        print(row)

    print()
    print("  Average path length:")
    header = f"  {xy_label:>5}"
    for y in y_vals:
        header += f"  {y:+6d}"
    print(header)
    print("  " + "—" * (5 + 8 * len(y_vals)))
    for ix, x in enumerate(x_vals):
        row = f"  {x:5d}"
        for iy in range(len(y_vals)):
            val = pathlen_grid[ix, iy]
            if np.isnan(val):
                row += "       -"
            else:
                row += f"  {val:6.1f}"
        print(row)

    # Growth heatmap
    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(18, 6))

    masked_g = np.ma.masked_invalid(growth_grid)
    im1 = ax1.imshow(masked_g, aspect="auto", origin="lower", cmap="hot_r")
    ax1.set_xticks(range(len(y_vals)))
    ax1.set_xticklabels([f"{y:+d}" for y in y_vals], fontsize=8)
    ax1.set_yticks(range(len(x_vals)))
    ax1.set_yticklabels(x_vals)
    ax1.set_xlabel("y (offset)")
    ax1.set_ylabel("x (multiplier)")
    ax1.set_title("Geometric Mean Growth G = exp(⟨log(peak/n)⟩)")
    plt.colorbar(im1, ax=ax1, label="G")

    masked_p = np.ma.masked_invalid(pathlen_grid)
    im2 = ax2.imshow(masked_p, aspect="auto", origin="lower", cmap="viridis")
    ax2.set_xticks(range(len(y_vals)))
    ax2.set_xticklabels([f"{y:+d}" for y in y_vals], fontsize=8)
    ax2.set_yticks(range(len(x_vals)))
    ax2.set_yticklabels(x_vals)
    ax2.set_xlabel("y (offset)")
    ax2.set_ylabel("x (multiplier)")
    ax2.set_title("Average Path Length (full trajectory)")
    plt.colorbar(im2, ax=ax2, label="Steps")

    plt.tight_layout()
    outpath_g = os.path.join(PLOT_DIR, "carykh_growth_heatmap.png")
    plt.savefig(outpath_g, dpi=150, bbox_inches="tight")
    plt.close()
    print(f"\n  Saved: {outpath_g}")

    # Selected pairs at higher N
    print("\n  Selected pairs at N=50,000:")
    selected = [(3, 1), (3, -1), (5, 1), (5, -1), (1, 1)]
    for x, y in selected:
        log_growths = []
        path_lens = []
        for n in range(3, 50001, 2):
            if x * n + y <= 0:
                continue
            traj = collatz_full(n, x, y, max_steps=50000)
            if len(traj) < 2:
                continue
            peak = max(traj)
            if n > 0 and peak > 0:
                with contextlib.suppress(OverflowError, ValueError):
                    log_growths.append(math.log(peak) - math.log(n))
            path_lens.append(len(traj))

        if log_growths:
            mean_lg = np.mean(log_growths)
            try:
                g_val = math.exp(mean_lg)
                g_str = f"{g_val:.4f}"
            except OverflowError:
                g_str = "inf"
            avg_path = np.mean(path_lens)
            print(f"    ({x}, {y:+d}): G = {g_str}, avg path = {avg_path:.1f}")

    print()
    return growth_grid, pathlen_grid


def section_9(vm_grid=None, growth_grid=None, pathlen_grid=None):
    """Phase diagram overlay: convergence, growth, path length, variance."""
    print("=" * 72)
    print("SECTION 9: Phase Diagram Overlay")
    print("=" * 72)
    print()

    x_vals = [1, 3, 5, 7, 9, 11]
    y_vals = list(range(-9, 12, 2))

    # Compute convergence grid if needed
    conv_grid = np.full((len(x_vals), len(y_vals)), np.nan)
    for ix, x in enumerate(x_vals):
        for iy, y in enumerate(y_vals):
            conv = 0
            total = 0
            for n in range(3, 10001, 2):
                if x * n + y <= 0:
                    continue
                _, _, outcome = trajectory_general(n, x, y, max_steps=500)
                total += 1
                if outcome in ("converged", "cycle"):
                    conv += 1
            if total > 0:
                conv_grid[ix, iy] = conv / total

    # Use passed grids or compute fresh
    if growth_grid is None or pathlen_grid is None:
        growth_grid = np.full((len(x_vals), len(y_vals)), np.nan)
        pathlen_grid = np.full((len(x_vals), len(y_vals)), np.nan)
        for ix, x in enumerate(x_vals):
            for iy, y in enumerate(y_vals):
                log_growths = []
                path_lens = []
                for n in range(3, 10001, 2):
                    if x * n + y <= 0:
                        continue
                    traj = collatz_full(n, x, y, max_steps=50000)
                    if len(traj) < 2:
                        continue
                    peak = max(traj)
                    if n > 0 and peak > 0:
                        log_growths.append(np.log(peak / n))
                    path_lens.append(len(traj))
                if log_growths:
                    growth_grid[ix, iy] = np.exp(np.mean(log_growths))
                    pathlen_grid[ix, iy] = np.mean(path_lens)

    if vm_grid is None:
        vm_grid = np.full((len(x_vals), len(y_vals)), np.nan)

    fig, axes = plt.subplots(2, 2, figsize=(18, 14))

    grids = [
        (conv_grid, "Convergence Fraction", "RdYlGn", None, None),
        (growth_grid, "Growth Metric G", "hot_r", None, None),
        (pathlen_grid, "Average Path Length", "viridis", None, None),
        (vm_grid, "Variance Multiplier", "RdBu_r", 0.4, 1.6),
    ]

    for ax, (grid, title, cmap, vmin, vmax) in zip(axes.flatten(), grids, strict=False):
        masked = np.ma.masked_invalid(grid)
        kwargs = {"aspect": "auto", "origin": "lower", "cmap": cmap}
        if vmin is not None:
            kwargs["vmin"] = vmin
        if vmax is not None:
            kwargs["vmax"] = vmax
        im = ax.imshow(masked, **kwargs)
        ax.set_xticks(range(len(y_vals)))
        ax.set_xticklabels([f"{y:+d}" for y in y_vals], fontsize=7)
        ax.set_yticks(range(len(x_vals)))
        ax.set_yticklabels(x_vals)
        ax.set_xlabel("y (offset)")
        ax.set_ylabel("x (multiplier)")
        ax.set_title(title)
        plt.colorbar(im, ax=ax)

    plt.suptitle(
        "Phase Diagram: Four Views of the (x, y) Parameter Space",
        fontsize=14,
        y=1.01,
    )
    plt.tight_layout()
    outpath = os.path.join(PLOT_DIR, "phase_overlay.png")
    plt.savefig(outpath, dpi=150, bbox_inches="tight")
    plt.close()
    print(f"  Saved: {outpath}")
    print()


# ===================================================================
# MAIN
# ===================================================================
if __name__ == "__main__":
    section_1()
    section_2()
    section_3()
    section_4()
    vm_grid = section_5()
    section_6()
    section_7()
    growth_grid, pathlen_grid = section_8()
    section_9(vm_grid=vm_grid, growth_grid=growth_grid, pathlen_grid=pathlen_grid)
    print("=" * 72)
    print("ANALYSIS COMPLETE — All 9 sections finished")
    print("=" * 72)
