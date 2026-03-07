"""
Task #53: What distinguishes 3n+1 from 3n-1?

The 3n-1 variant has non-trivial cycles (5→7→5 in Syracuse form).
The 3n+1 variant (conjecturally) does not.
Every other statistical property is identical.

This script systematically compares the two maps to find the exact
structural property that "+1" provides and "-1" does not.
If we can identify this computationally, we know what a proof must formalize.
"""

import os
import sys
from collections import Counter
from math import ceil, floor, log2

import numpy as np

sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))


# ===================================================================
# 1. Define both maps
# ===================================================================
def syracuse_plus(n):
    """Syracuse map for 3n+1: odd n -> (3n+1) / 2^v"""
    val = 3 * n + 1
    v = 0
    while val % 2 == 0:
        val //= 2
        v += 1
    return val, v


def syracuse_minus(n):
    """Syracuse map for 3n-1: odd n -> (3n-1) / 2^v"""
    val = 3 * n - 1
    v = 0
    while val % 2 == 0:
        val //= 2
        v += 1
    return val, v


def v_sequence_plus(n, max_steps=1000):
    """v-sequence for 3n+1 Syracuse map."""
    vs = []
    for _ in range(max_steps):
        if n == 1:
            break
        n, v = syracuse_plus(n)
        vs.append(v)
    return vs


def v_sequence_minus(n, max_steps=1000):
    """v-sequence for 3n-1 Syracuse map."""
    vs = []
    visited = {n}
    for _ in range(max_steps):
        if n == 1:
            break
        n, v = syracuse_minus(n)
        vs.append(v)
        if n in visited:
            break  # cycle detected
        visited.add(n)
    return vs


# ===================================================================
# 2. Find all cycles in 3n-1 (small values)
# ===================================================================
print("=" * 72)
print("SECTION 1: Cycles in 3n-1 vs 3n+1")
print("=" * 72)


def find_cycles(syracuse_fn, max_start=10000, max_steps=10000):
    """Find all cycles for a Syracuse-type map."""
    all_cycles = []
    cycle_members = set()

    for start in range(3, max_start, 2):
        if start in cycle_members:
            continue
        n = start
        visited = {}
        for step in range(max_steps):
            if n in visited:
                # Found a cycle
                # Retrace to find cycle
                cycle = []
                m = n
                while True:
                    next_m, v = syracuse_fn(m)
                    cycle.append((m, v))
                    m = next_m
                    if m == n:
                        break
                cycle_set = frozenset(e[0] for e in cycle)
                if cycle_set not in [frozenset(e[0] for e in c) for c in all_cycles]:
                    all_cycles.append(cycle)
                    cycle_members.update(e[0] for e in cycle)
                break
            visited[n] = step
            n, v = syracuse_fn(n)
            if n == 1:
                break
    return all_cycles


print("\n3n-1 cycles (Syracuse form, searching odd numbers up to 10000):")
minus_cycles = find_cycles(syracuse_minus, max_start=10000)
for i, cycle in enumerate(minus_cycles):
    values = [e[0] for e in cycle]
    v_vals = [e[1] for e in cycle]
    sum_v = sum(v_vals)
    n_steps = len(cycle)
    net = n_steps * log2(3) - sum_v
    print(f"  Cycle {i + 1}: {values}")
    print(f"    v-values: {v_vals}, sum(v)={sum_v}, steps={n_steps}")
    print(f"    Net log2 per cycle: {net:+.6f} (nonzero; offset C compensates)")
    print(f"    3^{n_steps} = {3**n_steps}, 2^{sum_v} = {2**sum_v}")
    print(f"    Ratio 3^k/2^s = {3**n_steps / 2**sum_v:.10f}")

print("\n3n+1 cycles (should only find the trivial 1→1 loop):")
plus_cycles = find_cycles(syracuse_plus, max_start=10000)
for i, cycle in enumerate(plus_cycles):
    values = [e[0] for e in cycle]
    v_vals = [e[1] for e in cycle]
    print(f"  Cycle {i + 1}: {values}, v-values: {v_vals}")


# ===================================================================
# 3. Residue class comparison mod 2^k
# ===================================================================
print()
print("=" * 72)
print("SECTION 2: Residue class compression — 3n+1 vs 3n-1")
print("=" * 72)


def compress_residue_class(r, k, sign=+1):
    """Compress k Collatz steps for residue r mod 2^k.

    Each of the k binary digits of r determines one Collatz step:
    even -> divide by 2, odd -> multiply by 3 and add sign.
    Returns: (multiplier, offset, divisions, odd_count) where
    after k Collatz steps: result = (multiplier * n + offset) / 2^divisions
    """
    mod = 2**k
    multiplier = 1
    offset = 0
    divisions = 0
    odd_count = 0

    current = r
    for _step in range(k):
        if current % 2 == 0:
            # Even step: divide by 2
            divisions += 1
            current = current // 2
        else:
            # Odd step: multiply by 3, add sign (result is always even)
            multiplier *= 3
            offset = offset * 3 + sign * (2**divisions)
            current = (3 * current + sign) % mod
            odd_count += 1

    return multiplier, offset, divisions, odd_count


for k in [4, 6, 8, 10, 12]:
    mod = 2**k
    odd_residues = list(range(1, mod, 2))

    plus_shrink = 0
    minus_shrink = 0
    plus_divisions = []
    minus_divisions = []

    for r in range(mod):  # all residues, not just odd
        # 3n+1
        mult_p, off_p, div_p, odd_p = compress_residue_class(r, k, sign=+1)
        if mult_p < 2**div_p:
            plus_shrink += 1
        plus_divisions.append(div_p)

        # 3n-1
        mult_m, off_m, div_m, odd_m = compress_residue_class(r, k, sign=-1)
        if mult_m < 2**div_m:
            minus_shrink += 1
        minus_divisions.append(div_m)

    n_classes = mod
    print(f"\n  k={k:2d} (mod {mod:5d}): {n_classes} residue classes")
    print(f"    3n+1 shrinking: {plus_shrink}/{n_classes} = {plus_shrink / n_classes:.6f}")
    print(f"    3n-1 shrinking: {minus_shrink}/{n_classes} = {minus_shrink / n_classes:.6f}")
    print(f"    3n+1 mean divisions: {np.mean(plus_divisions):.4f}")
    print(f"    3n-1 mean divisions: {np.mean(minus_divisions):.4f}")
    print(f"    Expected divisions (k/2): {k / 2:.1f}")


# ===================================================================
# 4. v-value distribution comparison
# ===================================================================
print()
print("=" * 72)
print("SECTION 3: v-value distributions — are they really identical?")
print("=" * 72)

plus_v_counts = Counter()
minus_v_counts = Counter()
plus_total = 0
minus_total = 0

for n in range(3, 100001, 2):
    vs_p = v_sequence_plus(n)
    for v in vs_p:
        plus_v_counts[v] += 1
        plus_total += 1

    vs_m = v_sequence_minus(n, max_steps=1000)
    for v in vs_m:
        minus_v_counts[v] += 1
        minus_total += 1

print("\nv-value distributions (odd n from 3 to 99999):")
print(f"  3n+1: {plus_total:,} total v-values")
print(f"  3n-1: {minus_total:,} total v-values")
print(
    f"\n  {'v':>3s}  {'3n+1 freq':>10s}  {'3n-1 freq':>10s}  {'3n+1 %':>8s}  {'3n-1 %':>8s}  {'diff':>8s}"
)
print(f"  {'-' * 3}  {'-' * 10}  {'-' * 10}  {'-' * 8}  {'-' * 8}  {'-' * 8}")

for v in range(1, 12):
    p_count = plus_v_counts.get(v, 0)
    m_count = minus_v_counts.get(v, 0)
    p_pct = p_count / plus_total * 100 if plus_total > 0 else 0
    m_pct = m_count / minus_total * 100 if minus_total > 0 else 0
    print(
        f"  {v:3d}  {p_count:10,d}  {m_count:10,d}  {p_pct:7.3f}%  {m_pct:7.3f}%  {p_pct - m_pct:+7.3f}%"
    )

plus_mean_v = sum(v * c for v, c in plus_v_counts.items()) / plus_total
minus_mean_v = sum(v * c for v, c in minus_v_counts.items()) / minus_total
print(f"\n  E[v] for 3n+1: {plus_mean_v:.6f}")
print(f"  E[v] for 3n-1: {minus_mean_v:.6f}")
print(f"  log2(3) = {log2(3):.6f}")
print(f"  Both > log2(3)? 3n+1: {plus_mean_v > log2(3)}, 3n-1: {minus_mean_v > log2(3)}")


# ===================================================================
# 5. Autocorrelation comparison — is self-correction the same?
# ===================================================================
print()
print("=" * 72)
print("SECTION 4: Autocorrelation structure — 3n+1 vs 3n-1")
print("=" * 72)


def compute_acf(sequence, max_lag=20):
    """Compute autocorrelation function of a sequence."""
    arr = np.array(sequence, dtype=np.float64)
    arr = arr - np.mean(arr)
    n = len(arr)
    if n < max_lag + 10:
        return np.zeros(max_lag)
    acf = np.zeros(max_lag)
    var = np.dot(arr, arr)
    if var == 0:
        return acf
    for lag in range(max_lag):
        acf[lag] = np.dot(arr[: n - lag], arr[lag:]) / var
    return acf


# Collect long v-sequences
plus_long_vs = []
minus_long_vs = []

for n in range(3, 200001, 2):
    vs_p = v_sequence_plus(n, max_steps=2000)
    if len(vs_p) > 60:
        plus_long_vs.append(vs_p)

    vs_m = v_sequence_minus(n, max_steps=2000)
    if len(vs_m) > 60:
        minus_long_vs.append(vs_m)

print("\nTrajectories with length > 60:")
print(f"  3n+1: {len(plus_long_vs):,}")
print(f"  3n-1: {len(minus_long_vs):,}")

# Average ACF
max_lag = 15
plus_acfs = np.zeros(max_lag)
minus_acfs = np.zeros(max_lag)

for vs in plus_long_vs:
    deltas = [log2(3) - v for v in vs]
    acf = compute_acf(deltas, max_lag)
    plus_acfs += acf

for vs in minus_long_vs:
    deltas = [log2(3) - v for v in vs]
    acf = compute_acf(deltas, max_lag)
    minus_acfs += acf

if len(plus_long_vs) > 0:
    plus_acfs /= len(plus_long_vs)
if len(minus_long_vs) > 0:
    minus_acfs /= len(minus_long_vs)

print(f"\n  {'Lag':>4s}  {'3n+1 ACF':>10s}  {'3n-1 ACF':>10s}  {'Difference':>10s}")
print(f"  {'-' * 4}  {'-' * 10}  {'-' * 10}  {'-' * 10}")
for lag in range(max_lag):
    diff = plus_acfs[lag] - minus_acfs[lag]
    print(f"  {lag:4d}  {plus_acfs[lag]:+10.6f}  {minus_acfs[lag]:+10.6f}  {diff:+10.6f}")

plus_acf_sum = np.sum(plus_acfs[1:])  # exclude lag 0
minus_acf_sum = np.sum(minus_acfs[1:])
print(f"\n  Sum of ACF (lags 1-{max_lag - 1}):")
print(f"    3n+1: {plus_acf_sum:+.6f}")
print(f"    3n-1: {minus_acf_sum:+.6f}")
print("  Effective variance multiplier (1 + 2*sum):")
print(f"    3n+1: {1 + 2 * plus_acf_sum:.6f}")
print(f"    3n-1: {1 + 2 * minus_acf_sum:.6f}")


# ===================================================================
# 6. The critical test: mod 3 structure
# ===================================================================
print()
print("=" * 72)
print("SECTION 5: Mod 3 structure — the +1 vs -1 difference")
print("=" * 72)

print("\nFor odd n, what is (3n+1)/2^v mod 3 and (3n-1)/2^v mod 3?")
print("This is where Tao's '3-adic irregularity' lives.\n")

plus_mod3 = Counter()
minus_mod3 = Counter()

for n in range(1, 10000, 2):
    result_p, v_p = syracuse_plus(n)
    plus_mod3[result_p % 3] += 1

    result_m, v_m = syracuse_minus(n)
    minus_mod3[result_m % 3] += 1

total_p = sum(plus_mod3.values())
total_m = sum(minus_mod3.values())

print("  Syracuse output mod 3 (odd n from 1 to 9999):")
print(f"  {'mod 3':>6s}  {'3n+1 count':>11s}  {'3n+1 %':>8s}  {'3n-1 count':>11s}  {'3n-1 %':>8s}")
for r in [0, 1, 2]:
    p = plus_mod3.get(r, 0)
    m = minus_mod3.get(r, 0)
    print(f"  {r:6d}  {p:11,d}  {p / total_p * 100:7.2f}%  {m:11,d}  {m / total_m * 100:7.2f}%")


# Now check mod 9
print("\n  Syracuse output mod 9:")
plus_mod9 = Counter()
minus_mod9 = Counter()

for n in range(1, 100000, 2):
    result_p, v_p = syracuse_plus(n)
    plus_mod9[result_p % 9] += 1

    result_m, v_m = syracuse_minus(n)
    minus_mod9[result_m % 9] += 1

total_p9 = sum(plus_mod9.values())
total_m9 = sum(minus_mod9.values())

print(f"  {'mod 9':>6s}  {'3n+1 count':>11s}  {'3n+1 %':>8s}  {'3n-1 count':>11s}  {'3n-1 %':>8s}")
for r in range(9):
    p = plus_mod9.get(r, 0)
    m = minus_mod9.get(r, 0)
    print(f"  {r:6d}  {p:11,d}  {p / total_p9 * 100:7.3f}%  {m:11,d}  {m / total_m9 * 100:7.3f}%")


# ===================================================================
# 7. The key question: can v-sequences sustain E[v] < log2(3)?
# ===================================================================
print()
print("=" * 72)
print("SECTION 6: Can trajectories sustain low mean-v?")
print("=" * 72)

print("\nFor a trajectory to diverge, it needs E[v] < log2(3) ≈ 1.585")
print("over a sustained period. How often does this happen?\n")

# For both maps, track the running mean of v over windows
window_sizes = [10, 20, 50, 100]

for ws in window_sizes:
    plus_low_count = 0
    plus_total_windows = 0
    minus_low_count = 0
    minus_total_windows = 0

    for n in range(3, 50001, 2):
        vs_p = v_sequence_plus(n, max_steps=500)
        for i in range(len(vs_p) - ws + 1):
            window = vs_p[i : i + ws]
            if np.mean(window) < log2(3):
                plus_low_count += 1
            plus_total_windows += 1

        vs_m = v_sequence_minus(n, max_steps=1000)
        for i in range(len(vs_m) - ws + 1):
            window = vs_m[i : i + ws]
            if np.mean(window) < log2(3):
                minus_low_count += 1
            minus_total_windows += 1

    plus_pct = plus_low_count / plus_total_windows * 100 if plus_total_windows > 0 else 0
    minus_pct = minus_low_count / minus_total_windows * 100 if minus_total_windows > 0 else 0
    print(
        f"  Window size {ws:3d}: "
        f"3n+1 low-v windows: {plus_pct:6.2f}%  "
        f"3n-1 low-v windows: {minus_pct:6.2f}%  "
        f"diff: {plus_pct - minus_pct:+.2f}%"
    )


# ===================================================================
# 8. Transition structure on Z/3^n Z — Tao's key object
# ===================================================================
print()
print("=" * 72)
print("SECTION 7: Syracuse distribution on Z/3^n Z")
print("=" * 72)

print("\nTao works mod 3^n, not mod 2^k. Let's compare both maps there.\n")

for mod3 in [3, 9, 27, 81]:
    plus_dist = Counter()
    minus_dist = Counter()
    count = 0

    for n in range(1, 200000, 2):
        r_p, v_p = syracuse_plus(n)
        plus_dist[r_p % mod3] += 1

        r_m, v_m = syracuse_minus(n)
        minus_dist[r_m % mod3] += 1
        count += 1

    # Compute total variation distance from uniform
    uniform = count / mod3
    plus_tv = sum(abs(plus_dist.get(r, 0) - uniform) for r in range(mod3)) / (2 * count)
    minus_tv = sum(abs(minus_dist.get(r, 0) - uniform) for r in range(mod3)) / (2 * count)

    # Count how many residues mod 3^n are hit
    plus_support = sum(1 for r in range(mod3) if plus_dist.get(r, 0) > 0)
    minus_support = sum(1 for r in range(mod3) if minus_dist.get(r, 0) > 0)

    # Specifically: which residues are NEVER hit?
    plus_zero = [r for r in range(mod3) if plus_dist.get(r, 0) == 0]
    minus_zero = [r for r in range(mod3) if minus_dist.get(r, 0) == 0]

    print(f"  mod {mod3:3d}:")
    print(f"    3n+1: support={plus_support}/{mod3}, TV from uniform={plus_tv:.6f}")
    print(f"    3n-1: support={minus_support}/{mod3}, TV from uniform={minus_tv:.6f}")
    if plus_zero:
        print(f"    3n+1 never hits: {plus_zero}")
    if minus_zero:
        print(f"    3n-1 never hits: {minus_zero}")

    # Show distribution for small mod
    if mod3 <= 27:
        print("    3n+1 distribution: ", end="")
        for r in range(mod3):
            pct = plus_dist.get(r, 0) / count * 100
            print(f"{r}:{pct:.1f}% ", end="")
        print()
        print("    3n-1 distribution: ", end="")
        for r in range(mod3):
            pct = minus_dist.get(r, 0) / count * 100
            print(f"{r}:{pct:.1f}% ", end="")
        print()


# ===================================================================
# 9. The cycle equation: when can 3^k = 2^s exactly?
# ===================================================================
print()
print("=" * 72)
print("SECTION 8: The cycle equation — why +1 prevents cycles")
print("=" * 72)

print("""
For a cycle of length k in the Syracuse map, we need:
  n = (3^k * n + C) / 2^s  where s = sum of v-values
  => n * (2^s - 3^k) = C
  => n = C / (2^s - 3^k)

For 3n+1: C > 0 (sum of positive terms with +1 offsets)
  => need 2^s > 3^k so denominator is positive
  => average v per step must exceed log2(3) ≈ 1.585
  => cycle must be NET SHRINKING (which is typical, but C/(2^s-3^k) must be integer)

For 3n-1: C < 0 (sum of negative terms with -1 offsets)
  => need 2^s < 3^k so both numerator and denominator are negative
  => average v per step must be BELOW log2(3)
  => cycle must be NET GROWING (atypical, but possible for short cycles)

Key: 3n-1 cycles live in low-v regimes. 3n+1 cycles would need high-v regimes
where C/(2^s - 3^k) happens to be a positive integer.

Let's check which (k, s) pairs give small |2^s - 3^k|:
""")

print(
    f"  {'k':>3s}  {'s=floor(k*log2(3))':>18s}  {'2^s':>15s}  {'3^k':>15s}  {'2^s - 3^k':>15s}  {'ratio':>10s}"
)
print(f"  {'-' * 3}  {'-' * 18}  {'-' * 15}  {'-' * 15}  {'-' * 15}  {'-' * 10}")

close_pairs = []

for k in range(1, 40):
    # Check both floor and ceil of k*log2(3) to find closest approach
    s_lo = floor(k * log2(3))
    s_hi = ceil(k * log2(3))
    for s in sorted({s_lo, s_hi}):
        diff = 2**s - 3**k
        ratio = 3**k / 2**s
        if abs(diff) < 3**k * 0.1:  # within 10%
            close_pairs.append((k, s, diff))
        if k <= 25 or abs(diff) < 1000:
            print(f"  {k:3d}  {s:18d}  {2**s:15,d}  {3**k:15,d}  {diff:+15,d}  {ratio:10.8f}")

print("\nClosest approaches (|2^s - 3^k| / 3^k < 10%):")
for k, s, diff in close_pairs:
    print(f"  k={k}, s={s}: 2^{s} - 3^{k} = {diff:+d}")
    # For 3n+1: cycle requires n = C / (2^s - 3^k) to be positive integer
    # The "+1" makes C > 0, so need 2^s > 3^k (diff > 0)
    if diff > 0:
        print(f"    -> 3n+1 cycle possible IF C divisible by {diff}")
        print(f"    -> minimum n would be ~1/{diff} * (order 3^k) ≈ {3**k // diff}")
    else:
        print("    -> 2^s < 3^k, so 3n+1 cycle impossible (would need negative n)")
        print("    -> BUT 3n-1 cycle IS possible (C < 0, denominator < 0)")


print()
print("=" * 72)
print("ANALYSIS COMPLETE")
print("=" * 72)
