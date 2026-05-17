"""
Induced weight function W_I for the inducing/acceleration approach.

Tests whether the induced transfer operator weight W_I (obtained by
conditioning on v >= 2 descent events) has better Lipschitz regularity
than the original weight W = L(1).

The inducing set: A = {n in Z_2^odd : n ≡ 1 mod 4} = {n : v_2(3n+1) >= 2}.
Return to A removes the v=1 branch (weight 1/2), which is the source of
the Lasota-Yorke obstruction.

Induced operator: L_I on C(A) via
  P_I = P_AA + P_AB (I - P_BB)^{-1} P_BA
where P_K is partitioned as A/B = complement of A.

Sections:
  1. Build transfer matrix P_K (float)
  2. Compute induced transfer matrix P_I
  3. Compute W_I = row sums of P_I
  4. Lipschitz regularity test
  5. Visualization
"""

import os

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt  # noqa: E402
import numpy as np  # noqa: E402

PLOT_DIR = os.path.dirname(__file__)


# ---------------------------------------------------------------------------
# Section 1: Build transfer matrix
# ---------------------------------------------------------------------------
def build_transfer_matrix(k, x=3, y=1):
    """Build P_k as dense numpy array (float64).

    P_k[i,j] = 2^{-v} if S(2j+1) ≡ 2i+1 mod 2^k, else 0.
    n = 2^{k-1}.
    """
    mod = 2**k
    n = 2 ** (k - 1)
    P = np.zeros((n, n), dtype=float)
    for j in range(n):
        odd_j = 2 * j + 1
        val = x * odd_j + y
        v = 0
        while val % 2 == 0:
            val //= 2
            v += 1
        target = val % mod
        target_idx = (target - 1) // 2
        P[target_idx, j] = 2.0 ** (-v)
    return P


def partition_indices(k):
    """Partition {0,...,n-1} into A and B indices.

    A = {i : 2i+1 ≡ 1 mod 4} = {i : i even}
    B = {i : 2i+1 ≡ 3 mod 4} = {i : i odd}

    Returns (a_idx, b_idx) as numpy arrays of indices.
    """
    n = 2 ** (k - 1)
    all_idx = np.arange(n)
    # 2i+1 ≡ 1 mod 4 iff i ≡ 0 mod 2
    a_idx = all_idx[all_idx % 2 == 0]  # n//2 elements
    b_idx = all_idx[all_idx % 2 == 1]  # n//2 elements
    return a_idx, b_idx


# ---------------------------------------------------------------------------
# Section 2: Induced transfer matrix
# ---------------------------------------------------------------------------
def compute_induced_operator(P, a_idx, b_idx):
    """Compute P_I = P_AA + P_AB (I - P_BB)^{-1} P_BA.

    P: full transfer matrix (n x n)
    a_idx, b_idx: index partitions

    Returns P_I (|A| x |A| matrix).
    """
    P_AA = P[np.ix_(a_idx, a_idx)]
    P_AB = P[np.ix_(a_idx, b_idx)]
    P_BA = P[np.ix_(b_idx, a_idx)]
    P_BB = P[np.ix_(b_idx, b_idx)]

    nb = len(b_idx)
    I_BB = np.eye(nb, dtype=float)

    # Check spectral radius of P_BB to ensure (I-P_BB) is invertible
    rho_BB = np.max(np.abs(np.linalg.eigvals(P_BB)))
    print(f"  rho(P_BB) = {rho_BB:.6f} (should be < 1 for invertibility)")

    # (I - P_BB)^{-1}: use solve for stability
    ImPBB = I_BB - P_BB
    # P_I = P_AA + P_AB @ solve(I - P_BB, P_BA)
    # solve(A, B) gives A^{-1} B
    X = np.linalg.solve(ImPBB, P_BA)  # (I-P_BB)^{-1} P_BA
    P_I = P_AA + P_AB @ X

    return P_I, P_AA, P_AB, P_BA, P_BB


# ---------------------------------------------------------------------------
# Section 3: Compute W_I = row sums of P_I
# ---------------------------------------------------------------------------
def compute_weight_functions(P, P_I, a_idx):
    """Compute W = L(1) (row sums of P) and W_I = L_I(1) (row sums of P_I).

    W is computed for all n states.
    W_I is computed for A-states only.

    Returns (W_all, W_I, a_values) where a_values = actual odd integers in A.
    """
    W_all = P.sum(axis=1)  # Row sums = weight of each output state
    W_I = P_I.sum(axis=1)  # Row sums of induced operator

    # The actual odd integers in A
    a_values = np.array([2 * i + 1 for i in a_idx])

    return W_all, W_I, a_values


# ---------------------------------------------------------------------------
# Section 4: Lipschitz regularity test
# ---------------------------------------------------------------------------
def test_lipschitz(W_I, a_idx, k_level):
    """Test Lipschitz regularity of W_I in the 2-adic metric on A.

    For each 2-adic scale r, find all pairs (i,j) in A with
    |i - j|_2 = 2^{-r} (same residue mod 2^{r-1} but not mod 2^r,
    adjusted for the indexing).

    Actually: a_idx are even indices. Odd integers in A are 2*a_idx+1.
    2-adic distance between 2i+1 and 2j+1: |(2i+1)-(2j+1)|_2 = |2(i-j)|_2
      = 2 * |i-j|_2 = 2^{1 - v_2(i-j)}.

    So max oscillation at scale r = max |W_I(i) - W_I(j)| where v_2(i-j) = r-1.
    The 2-adic distance is 2^{1-(r-1)} = 2^{2-r}.

    Returns dict: scale -> (max_osc, 2-adic-distance, lipschitz-ratio)
    """
    results = {}

    for r in range(1, k_level - 1):
        # Find pairs with v_2(i - j) = r - 1 where i,j are in a_idx (i even, j even)
        # v_2(i-j) for i,j even: v_2(i-j) >= 1 always (since i-j even).
        # We want v_2(i-j) = r - 1 exactly, so r-1 >= 1, r >= 2.
        # For r=1: v_2(i-j) = 0 -- impossible since i,j both even -> i-j even.
        # So for r=1 in A: all pairs have 2-adic distance <= 2^{1-1} = 1.
        # Actually let's just group by residue mod 2^r and look at oscillations within groups.
        max_osc = 0.0
        count = 0

        modulus = 2**r
        # Group a_idx by residue mod modulus
        groups = {}
        for idx_pos, i in enumerate(a_idx):
            res = int(i) % modulus
            if res not in groups:
                groups[res] = []
            groups[res].append(idx_pos)

        # Within each residue class, find max oscillation
        for _res, positions in groups.items():
            if len(positions) < 2:
                continue
            vals = W_I[positions]
            osc = vals.max() - vals.min()
            if osc > max_osc:
                max_osc = osc
            count += len(positions) * (len(positions) - 1) // 2

        # 2-adic distance: within the same mod 2^r class, indices differ by multiples
        # of 2^r, so actual 2-adic distance of odd integers is:
        # |2i+1 - (2j+1)|_2 = |2(i-j)|_2 <= 2^{1-r} (at most, for i≡j mod 2^r)
        two_adic_dist = 2.0 ** (1 - r)

        lip_ratio = max_osc / two_adic_dist if two_adic_dist > 0 and max_osc > 0 else 0.0

        results[r] = {
            "max_osc": max_osc,
            "two_adic_dist": two_adic_dist,
            "lip_ratio": lip_ratio,
            "pairs": count,
        }

    return results


# ---------------------------------------------------------------------------
# Section 5: Visualization
# ---------------------------------------------------------------------------
def plot_weight_comparison(a_values, W_I, W_all, a_idx, b_idx, k):
    """Compare W and W_I as functions of residue mod 3 and 2-adic structure."""
    fig, axes = plt.subplots(2, 2, figsize=(16, 12))

    # Plot 1: W_I vs index, colored by mod 3
    ax = axes[0, 0]
    for mod3_val, color, label in [(1, "blue", "n≡1 mod 3"), (2, "red", "n≡2 mod 3")]:
        mask = a_values % 3 == mod3_val
        ax.scatter(
            np.where(mask)[0],
            W_I[mask],
            c=color,
            s=5,
            alpha=0.5,
            label=label,
        )
    ax.set_xlabel("A-state index (sorted)")
    ax.set_ylabel("$W_I(n)$")
    ax.set_title(f"Induced weight $W_I$ at k={k}, colored by mod 3")
    ax.legend()
    ax.grid(True, alpha=0.3)

    # Plot 2: W (original) vs index for A states, colored by mod 3
    ax = axes[0, 1]
    W_A = W_all[a_idx]
    for mod3_val, color, label in [(1, "blue", "n≡1 mod 3"), (2, "red", "n≡2 mod 3")]:
        mask = a_values % 3 == mod3_val
        ax.scatter(
            np.where(mask)[0],
            W_A[mask],
            c=color,
            s=5,
            alpha=0.5,
            label=label,
        )
    ax.set_xlabel("A-state index")
    ax.set_ylabel("$W(n)$")
    ax.set_title(f"Original weight $W$ restricted to $A$ at k={k}")
    ax.legend()
    ax.grid(True, alpha=0.3)

    # Plot 3: W_I histogram by mod-3 class
    ax = axes[1, 0]
    for mod3_val, color, label in [(1, "blue", "n≡1 mod 3"), (2, "red", "n≡2 mod 3")]:
        mask = a_values % 3 == mod3_val
        ax.hist(W_I[mask], bins=50, alpha=0.5, color=color, label=label, density=True)
    ax.set_xlabel("$W_I$ value")
    ax.set_ylabel("Density")
    ax.set_title("Distribution of $W_I$ by mod-3 class")
    ax.legend()
    ax.grid(True, alpha=0.3)

    # Plot 4: W_I vs 2-adic level (first 64 elements)
    ax = axes[1, 1]
    # Sort by 2-adic value of index and plot W_I
    # Show W_I(2i+1) for i in a_idx[:128]
    show = min(128, len(a_idx))
    ax.bar(range(show), W_I[:show], width=0.8, alpha=0.7, color="steelblue")
    ax.set_xlabel("A-state index (first 128)")
    ax.set_ylabel("$W_I(n)$")
    ax.set_title("$W_I$ values (first 128 A-states)")
    ax.grid(True, alpha=0.3)

    plt.suptitle(
        f"Induced weight function $W_I$ at level k={k}\n"
        "If $W_I$ has smaller mod-3 oscillation than $W$: inducing approach viable"
    )
    plt.tight_layout()
    path = os.path.join(PLOT_DIR, "induced_weight_WI.png")
    plt.savefig(path, dpi=150)
    plt.close()
    print(f"Saved: {path}")


def plot_lipschitz_test(lip_results, k):
    """Plot oscillation vs 2-adic scale to test Lipschitz condition."""
    scales = sorted(lip_results.keys())
    max_oscs = [lip_results[r]["max_osc"] for r in scales]
    two_adic_dists = [lip_results[r]["two_adic_dist"] for r in scales]
    lip_ratios = [lip_results[r]["lip_ratio"] for r in scales]

    fig, axes = plt.subplots(1, 2, figsize=(16, 7))

    # Plot 1: oscillation vs scale
    ax = axes[0]
    ax.semilogy(scales, max_oscs, "o-", color="blue", label="Max oscillation of $W_I$")
    ax.semilogy(
        scales,
        two_adic_dists,
        "r--",
        label="2-adic distance $2^{1-r}$ (Lipschitz reference)",
    )
    ax.set_xlabel("2-adic scale r")
    ax.set_ylabel("Magnitude (log scale)")
    ax.set_title("Max oscillation of $W_I$ vs 2-adic scale")
    ax.legend()
    ax.grid(True, alpha=0.3)

    # Plot 2: Lipschitz ratio
    ax = axes[1]
    ax.plot(scales, lip_ratios, "o-", color="green")
    ax.axhline(y=1.0, color="red", linestyle="--", label="Lipschitz constant = 1")
    ax.set_xlabel("2-adic scale r")
    ax.set_ylabel("Max osc / 2-adic dist (Lipschitz ratio)")
    ax.set_title("Lipschitz ratio of $W_I$: if bounded → $W_I$ is Lipschitz")
    ax.legend()
    ax.grid(True, alpha=0.3)

    plt.suptitle(
        f"Lipschitz regularity test for $W_I$ at k={k}\n"
        "Bounded Lipschitz ratio → inducing approach viable; "
        "unbounded → obstruction survives"
    )
    plt.tight_layout()
    path = os.path.join(PLOT_DIR, "induced_weight_lipschitz.png")
    plt.savefig(path, dpi=150)
    plt.close()
    print(f"Saved: {path}")


def print_lipschitz_summary(lip_results, W_I, a_values, k):
    """Print Lipschitz regularity summary."""
    print(f"\n{'=' * 60}")
    print(f"Lipschitz regularity of W_I at k={k}")
    print(f"{'=' * 60}")
    print(f"  W_I stats: min={W_I.min():.6f}, max={W_I.max():.6f}, mean={W_I.mean():.6f}")

    # Mod-3 split
    mod3_1 = W_I[a_values % 3 == 1]
    mod3_2 = W_I[a_values % 3 == 2]
    if len(mod3_1) > 0 and len(mod3_2) > 0:
        print(f"  W_I (n≡1 mod 3): mean={mod3_1.mean():.6f}, std={mod3_1.std():.6f}")
        print(f"  W_I (n≡2 mod 3): mean={mod3_2.mean():.6f}, std={mod3_2.std():.6f}")
        print(f"  Inter-class gap: {abs(mod3_1.mean() - mod3_2.mean()):.6f}")

    print("\n  Lipschitz test by 2-adic scale:")
    print(f"  {'Scale r':>8} {'2-adic dist':>12} {'Max osc':>12} {'Lip ratio':>12}")
    print(f"  {'-' * 50}")
    for r in sorted(lip_results.keys()):
        d = lip_results[r]
        flag = " ***" if d["lip_ratio"] > 1.0 else ""
        print(
            f"  {r:8d} {d['two_adic_dist']:12.6f} {d['max_osc']:12.6f} {d['lip_ratio']:12.4f}{flag}"
        )

    # Check if W has the same oscillation as W_I
    print("\n  Comparison: W (original) vs W_I (induced)")
    print("  Original W takes values: 0, 1/3, 2/3 (determined by mod-3 class)")
    print(
        f"  Induced W_I oscillation at scale r=1: "
        f"{lip_results.get(2, {}).get('max_osc', 'N/A'):.6f}"
    )

    # Overall verdict
    max_lip = max(d["lip_ratio"] for d in lip_results.values()) if lip_results else float("inf")
    if max_lip < 2.0:
        verdict = "W_I IS LIPSCHITZ (inducing approach viable)"
    elif max_lip < 10.0:
        verdict = "W_I is NEARLY Lipschitz (may be Holder -- worth pursuing)"
    else:
        verdict = "W_I is NOT Lipschitz (Lasota-Yorke obstruction survives)"
    print(f"\n  VERDICT: {verdict}")
    print(f"  (Max Lipschitz ratio across all tested scales: {max_lip:.4f})")


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------
def main():
    print("Induced Weight Function W_I Test")
    print("=" * 60)
    print("Testing Lipschitz regularity of W_I = L_I(1).")
    print("Inducing set A = {n ≡ 1 mod 4} (v_2(3n+1) >= 2).\n")

    # Use k=12 for detailed picture, verify at k=10
    for k in [10, 12]:
        print(f"\n{'=' * 60}")
        print(f"Level k = {k} (n = {2 ** (k - 1)}, |A| = {2 ** (k - 2)})")
        print(f"{'=' * 60}")

        # Build transfer matrix
        print("  Building P_k...")
        P = build_transfer_matrix(k)
        print(f"  P_k shape: {P.shape}, sum of entries: {P.sum():.4f}")
        print(f"  Max entry: {P.max():.4f} (expected <= 1/2)")

        # Partition
        a_idx, b_idx = partition_indices(k)
        print(f"  |A| = {len(a_idx)}, |B| = {len(b_idx)}")

        # Compute induced operator
        print("  Computing P_I (induced transfer matrix)...")
        P_I, P_AA, P_AB, P_BA, P_BB = compute_induced_operator(P, a_idx, b_idx)

        # Weight functions
        W_all, W_I, a_values = compute_weight_functions(P, P_I, a_idx)
        print(f"  W_I computed: {len(W_I)} values")

        # Lipschitz test
        print("  Testing Lipschitz regularity...")
        lip_results = test_lipschitz(W_I, a_idx, k)

        # Summary
        print_lipschitz_summary(lip_results, W_I, a_values, k)

        # Plots (only for k=12 to keep it manageable)
        if k == 12:
            print("\n  Generating plots...")
            plot_weight_comparison(a_values, W_I, W_all, a_idx, b_idx, k)
            plot_lipschitz_test(lip_results, k)

    print("\nDone.")
    print("\nInterpretation of results:")
    print("  Lipschitz W_I → inducing approach viable → Young tower framework")
    print("  Non-Lipschitz W_I → Lasota-Yorke obstruction survives inducing")
    print("  Compare oscillation with original W: 1/3 jump between mod-3 classes")


if __name__ == "__main__":
    main()
