"""
Computation specs for Paper B ("2-Adic Local Constancy").

Spec 1: Growth rate c(x,y).
  For x in {3,5,7,...,21} and y=1, compute V(k,x,1) for k=3,...,30.
  Efficient: worst j* = (-y * x^{-1}) mod 2^k (unique maximizer).
  Fit V(k) = c*k + O(1) and report c(x,1).

Spec 2: Number of distinct P_k.
  For k=3,4,5,6 and y=1, enumerate odd x, compute P_k(x,1),
  count distinct matrices, report ratio vs 2^{M-1}.
"""

import numpy as np
from scipy.stats import linregress

# ─────────────────────────────────────────────
# Utilities
# ─────────────────────────────────────────────


def v2(n):
    """2-adic valuation of non-negative integer n."""
    if n == 0:
        return float("inf")
    count = 0
    while n % 2 == 0:
        n //= 2
        count += 1
    return count


def compute_V_fast(k, x, y):
    """
    V(k, x, y) = max{ v_2(x*j + y) : j odd, 1 <= j < 2^k }.

    Key insight: v_2(xj+y) >= s iff j ≡ -y*x^{-1} (mod 2^s).
    The unique maximizer in [1, 2^k) is j* = (-y * modinv(x, 2^k)) mod 2^k,
    which is odd (since x,y odd => -y*x^{-1} is a 2-adic unit).
    V = v_2(x*j* + y) >= k (could be much larger).
    """
    mod = 2**k
    x_inv = pow(x, -1, mod)  # modular inverse of x mod 2^k
    j_star = (-y * x_inv) % mod  # unique maximizer mod 2^k
    if j_star == 0:
        j_star = mod  # lift to odd positive representative
    # j_star should be odd; verify
    assert j_star % 2 == 1, f"j_star={j_star} is even for x={x},y={y},k={k}"
    val = x * j_star + y  # exact integer value
    return v2(val), j_star


def compute_V_brute(k, x, y):
    """Brute-force for verification (small k only)."""
    mod = 2**k
    best_v, best_j = 0, None
    for j in range(1, mod, 2):
        vv = v2(x * j + y)
        if vv > best_v:
            best_v, best_j = vv, j
    return best_v, best_j


def verify_fast_vs_brute():
    """Spot-check fast vs brute for small k."""
    ok = True
    for x in [3, 5, 7, 9]:
        for y in [1, 3]:
            for k in range(2, 9):
                vf, jf = compute_V_fast(k, x, y)
                vb, jb = compute_V_brute(k, x, y)
                if vf != vb:
                    print(f"MISMATCH x={x},y={y},k={k}: fast={vf}(j={jf}), brute={vb}(j={jb})")
                    ok = False
    if ok:
        print("✓ Fast algorithm matches brute force for all test cases.")
    return ok


def compute_transfer_matrix_key(k, x, y):
    """
    Hashable representation of P_k(x,y).
    Returns tuple of (row_idx, col_idx, v_j) for each column.
    """
    mod = 2**k
    entries = []
    for col, j in enumerate(range(1, mod, 2)):  # odd residues
        val = x * j + y
        vv = v2(val)
        t = (val >> vv) % mod  # t_j = (val / 2^v) mod 2^k, odd
        row = (t - 1) // 2
        entries.append((row, col, vv))
    return tuple(entries)


# ─────────────────────────────────────────────
# Spec 1: Growth rate of V(k,x,1)
# ─────────────────────────────────────────────


def spec1():
    print("=" * 70)
    print("SPEC 1: Growth rate of V(k,x,1) for general x")
    print("=" * 70)

    # Verify fast algorithm
    verify_fast_vs_brute()
    print()

    x_values = [3, 5, 7, 9, 11, 13, 15, 17, 19, 21]
    y = 1
    k_values = list(range(3, 31))

    results = {}
    worst_j = {}
    for x in x_values:
        vs, js = [], []
        for k in k_values:
            vv, jj = compute_V_fast(k, x, y)
            vs.append(vv)
            js.append(jj)
        results[x] = vs
        worst_j[x] = js

    # Print table of V values
    print(f"{'k':>3}", end="")
    for x in x_values:
        print(f"  x={x:>2}", end="")
    print()
    print("-" * (4 + 7 * len(x_values)))
    for i, k in enumerate(k_values):
        print(f"{k:>3}", end="")
        for x in x_values:
            print(f"  {results[x][i]:>4}", end="")
        print()

    # Fit V(k) = c*k + b for k >= 5
    print(f"\n{'x':>4}  {'c(x,1)':>8}  {'intercept':>10}  {'R^2':>6}  {'M≈(1+c)k':>12}")
    print("-" * 50)
    growth_constants = {}
    for x in x_values:
        vs = results[x]
        ks_fit = np.array(k_values[2:])  # k=5,...,30
        vs_fit = np.array(vs[2:])
        slope, intercept, r, _, _ = linregress(ks_fit, vs_fit)
        growth_constants[x] = slope
        print(f"{x:>4}  {slope:>8.4f}  {intercept:>10.4f}  {r**2:>6.4f}  M≈{1 + slope:.4f}k")

    print("\nNote: For x=3, c≈1 confirms M≈2k from Section 5.")
    print("For other x, c is approximately 1 as the heuristic predicts.")

    # Worst-case residues for x=3 (match paper table)
    print("\nWorst-case residues for x=3, y=1 (cf. Table 1 in paper):")
    print(f"{'k':>4}  {'V=max_v2':>9}  {'M=k+V':>7}  {'j*':>10}")
    for k in [3, 5, 7, 9]:
        vv, jj = compute_V_fast(k, 3, 1)
        print(f"{k:>4}  {vv:>9}  {k + vv:>7}  {jj:>10}")

    # M values for general x at k=10
    k0 = 10
    print(f"\nM(k={k0}, x, 1) = {k0} + V for various x:")
    print(f"{'x':>4}  {'V':>4}  {'M':>4}  {'j*':>12}")
    for x in x_values:
        vv, jj = compute_V_fast(k0, x, 1)
        print(f"{x:>4}  {vv:>4}  {k0 + vv:>4}  {jj:>12}")

    return results, growth_constants


# ─────────────────────────────────────────────
# Spec 2: Distinct transfer matrices
# ─────────────────────────────────────────────


def spec2():
    print("\n" + "=" * 70)
    print("SPEC 2: Number of distinct P_k(x,1) matrices")
    print("=" * 70)

    y = 1

    print(f"\n{'k':>3}  {'M_bnd':>6}  {'N_x':>8}  {'distinct':>10}  {'ratio':>8}  {'2^{M-1}':>10}")
    print("-" * 55)

    for k in [3, 4, 5, 6]:
        # Use M_bound = 2k+2 as upper bound (generous)
        M_bound = 2 * k + 2
        n_odd_x = 2 ** (M_bound - 1)  # number of odd x in [1, 2^M_bound)

        seen = set()
        x = 1
        while x < 2**M_bound:
            key = compute_transfer_matrix_key(k, x, y)
            seen.add(key)
            x += 2

        n_distinct = len(seen)
        ratio = n_distinct / n_odd_x

        print(f"{k:>3}  {M_bound:>6}  {n_odd_x:>8}  {n_distinct:>10}  {ratio:>8.4f}  {n_odd_x:>10}")

    # Detailed breakdown for k=3
    print("\nDetailed: k=3, y=1. V and matrix class for odd x in [1, 127]:")
    print(f"{'x':>4}  {'V(3,x,1)':>9}  {'M':>4}  {'j*':>6}")
    for x in range(1, 128, 2):
        vv, jj = compute_V_fast(3, x, 1)
        print(f"{x:>4}  {vv:>9}  {3 + vv:>4}  {jj:>6}")


# ─────────────────────────────────────────────
# Main
# ─────────────────────────────────────────────

if __name__ == "__main__":
    results, growth_constants = spec1()
    spec2()
