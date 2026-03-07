"""
Deep investigation of v-sequence autocorrelation structure in Collatz/Syracuse map.

Analyses:
1. Per-trajectory vs. concatenated autocorrelation (boundary artifact check)
2. Range robustness across different starting ranges
3. Mechanism: conditional expectation E[v_{i+lag} | v_i = k]
4. Binary pattern analysis when v_i = 4
5. 4-step block frequency analysis vs. independence assumption
"""

import os
import sys
from collections import Counter, defaultdict

import numpy as np

sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))
from collatz.core import syracuse, v_sequence


# ---------------------------------------------------------------------------
# Utility: autocorrelation of a single sequence at lags 1..max_lag
# ---------------------------------------------------------------------------
def autocorrelation(seq, max_lag=20):
    """Compute normalised autocorrelation for lags 1..max_lag."""
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
# 1. PER-TRAJECTORY vs. CONCATENATED autocorrelation
# ===================================================================
def analysis_1():
    print("=" * 72)
    print("ANALYSIS 1: Per-trajectory vs. concatenated autocorrelation")
    print("=" * 72)

    max_lag = 20
    min_len = 30
    start, end, step = 3, 100001, 2

    # Collect individual v-sequences and concatenated
    all_vs = []
    per_traj_acs = []

    for n in range(start, end + 1, step):
        vs = v_sequence(n)
        all_vs.extend(vs)
        if len(vs) >= min_len:
            ac = autocorrelation(vs, max_lag)
            if ac is not None:
                per_traj_acs.append(ac)

    # Concatenated autocorrelation
    concat_ac = autocorrelation(all_vs, max_lag)

    # Average per-trajectory autocorrelation
    per_traj_acs = np.array(per_traj_acs)
    avg_per_traj = per_traj_acs.mean(axis=0)
    std_per_traj = per_traj_acs.std(axis=0)

    print(f"\nOdd n in {start}..{end}: {len(per_traj_acs)} trajectories with len >= {min_len}")
    print(f"Total concatenated length: {len(all_vs)}")
    print()
    print(
        f"{'Lag':>4}  {'Concat':>10}  {'PerTraj Avg':>12}  {'PerTraj Std':>12}  {'Difference':>10}"
    )
    print("-" * 58)
    for lag in range(max_lag):
        diff = concat_ac[lag] - avg_per_traj[lag]
        print(
            f"{lag + 1:>4}  {concat_ac[lag]:>+10.6f}  {avg_per_traj[lag]:>+12.6f}  "
            f"{std_per_traj[lag]:>12.6f}  {diff:>+10.6f}"
        )

    print()
    # Highlight lag-1 vs lag-4 in both methods
    print("Key comparison:")
    print(
        f"  Concatenated  lag-1 = {concat_ac[0]:+.6f},  lag-4 = {concat_ac[3]:+.6f},  ratio = {concat_ac[3] / concat_ac[0]:.3f}"
    )
    print(
        f"  Per-trajectory lag-1 = {avg_per_traj[0]:+.6f},  lag-4 = {avg_per_traj[3]:+.6f},  ratio = {avg_per_traj[3] / avg_per_traj[0]:.3f}"
    )
    print()
    return concat_ac


# ===================================================================
# 2. RANGE ROBUSTNESS
# ===================================================================
def analysis_2():
    print("=" * 72)
    print("ANALYSIS 2: Range robustness of concatenated autocorrelation")
    print("=" * 72)

    ranges = [
        (3, 10001),
        (3, 50001),
        (3, 100001),
        (3, 200001),
    ]
    max_lag = 20
    results = {}

    for start, end in ranges:
        all_vs = []
        for n in range(start, end + 1, 2):
            all_vs.extend(v_sequence(n))
        ac = autocorrelation(all_vs, max_lag)
        results[(start, end)] = ac
        print(f"\nRange {start}..{end} (step 2): {len(all_vs)} total v-values")

    # Print table
    print()
    header = f"{'Lag':>4}"
    for start, end in ranges:
        header += f"  {start}-{end:>6}"
    print(header)
    print("-" * (4 + 14 * len(ranges)))

    for lag in range(max_lag):
        row = f"{lag + 1:>4}"
        for start, end in ranges:
            row += f"  {results[(start, end)][lag]:>+12.6f}"
        print(row)

    print()
    print("Lag-4 values across ranges:")
    for start, end in ranges:
        val = results[(start, end)][3]
        print(f"  {start}..{end}: {val:+.6f}")


# ===================================================================
# 3. MECHANISM: E[v_{i+lag} | v_i = k]
# ===================================================================
def analysis_3():
    print()
    print("=" * 72)
    print("ANALYSIS 3: Conditional expectation E[v_{i+lag} | v_i = k]")
    print("=" * 72)

    start, end, step = 3, 100001, 2
    max_lag = 8
    k_values = [1, 2, 3, 4, 5]

    # Concatenate all v-sequences (with separators to avoid cross-trajectory)
    trajectories = []
    for n in range(start, end + 1, step):
        vs = v_sequence(n)
        if len(vs) > max_lag:
            trajectories.append(vs)

    # For each k, for each lag, accumulate v_{i+lag} values
    cond_sums = {k: {lag: [] for lag in range(1, max_lag + 1)} for k in k_values}

    for vs in trajectories:
        for i in range(len(vs)):
            vi = vs[i]
            if vi in k_values:
                for lag in range(1, max_lag + 1):
                    if i + lag < len(vs):
                        cond_sums[vi][lag].append(vs[i + lag])

    # Also compute the marginal mean
    all_vs = []
    for vs in trajectories:
        all_vs.extend(vs)
    marginal_mean = np.mean(all_vs)
    print(f"\nMarginal mean of v: {marginal_mean:.6f}")
    print(f"Number of trajectories used: {len(trajectories)}")

    for k in k_values:
        print(f"\n  v_i = {k} (count = {len(cond_sums[k][1])})")
        print(
            f"  {'Lag':>4}  {'E[v_{i+lag}|v_i=k]':>20}  {'Deviation from marginal':>24}  {'Count':>8}"
        )
        for lag in range(1, max_lag + 1):
            vals = cond_sums[k][lag]
            if vals:
                m = np.mean(vals)
                print(f"  {lag:>4}  {m:>20.6f}  {m - marginal_mean:>+24.6f}  {len(vals):>8}")

    print()
    print("Interpretation: Positive deviation at lag L for v_i=k means")
    print("v=k tends to be followed L steps later by higher-than-average v-values.")


# ===================================================================
# 4. BINARY PATTERN ANALYSIS for v_i = 4
# ===================================================================
def analysis_4():
    print()
    print("=" * 72)
    print("ANALYSIS 4: Binary patterns and next-v distribution when v_i = 4")
    print("=" * 72)

    start, end, step = 3, 100001, 2

    # Collect (current_v, next_v) pairs from all trajectories
    # Also collect info about the Syracuse iterate after v=4
    next_v_given_current = defaultdict(list)
    all_next_v = []  # marginal distribution of next_v

    low_bits_after_v4 = []  # low bits of Syracuse iterate after dividing by 2^4

    for n in range(start, end + 1, step):
        vs = v_sequence(n)
        # Also regenerate the Syracuse trajectory to get the actual numbers
        syra = syracuse(n)  # syra[0] = n, syra[i] = odd iterate after step i

        for i in range(len(vs) - 1):
            current_v = vs[i]
            next_v = vs[i + 1]
            next_v_given_current[current_v].append(next_v)
            all_next_v.append(next_v)

            if current_v == 4:
                # The Syracuse iterate after this step is syra[i+1]
                # (syra[i] is the odd number BEFORE step i, syra[i+1] after step i)
                odd_after = syra[i + 1]
                # low 8 bits
                low_bits_after_v4.append(odd_after & 0xFF)

    # Marginal distribution of v
    marginal_counter = Counter(all_next_v)
    total_marginal = sum(marginal_counter.values())

    print(f"\nTotal (current_v, next_v) pairs: {total_marginal}")

    # Distribution of next_v | current_v = k, for k = 1..5
    print("\n--- P(next_v | current_v) vs P(next_v) ---")
    for k in [1, 2, 3, 4, 5]:
        nexts = next_v_given_current[k]
        if not nexts:
            continue
        cond_counter = Counter(nexts)
        total_cond = len(nexts)
        print(f"\n  current_v = {k}  (n_pairs = {total_cond})")
        print(f"  {'next_v':>8}  {'P(next|cur=k)':>14}  {'P(next) marginal':>16}  {'Ratio':>8}")
        for v_val in sorted(set(list(cond_counter.keys())[:10])):
            if v_val > 8:
                continue
            p_cond = cond_counter[v_val] / total_cond
            p_marg = marginal_counter[v_val] / total_marginal
            ratio = p_cond / p_marg if p_marg > 0 else float("inf")
            print(f"  {v_val:>8}  {p_cond:>14.6f}  {p_marg:>16.6f}  {ratio:>8.4f}")

    # Specifically for v=4: distribution of next_v
    print("\n--- Detailed: P(next_v | current_v = 4) ---")
    nexts_4 = next_v_given_current[4]
    cond_counter_4 = Counter(nexts_4)
    total_4 = len(nexts_4)
    print(f"  Total transitions from v=4: {total_4}")
    print(f"  {'next_v':>8}  {'Count':>8}  {'P(cond)':>10}  {'P(marginal)':>12}  {'Ratio':>8}")
    for v_val in sorted(cond_counter_4.keys()):
        if v_val > 12:
            continue
        cnt = cond_counter_4[v_val]
        p_cond = cnt / total_4
        p_marg = marginal_counter[v_val] / total_marginal
        ratio = p_cond / p_marg if p_marg > 0 else float("inf")
        print(f"  {v_val:>8}  {cnt:>8}  {p_cond:>10.6f}  {p_marg:>12.6f}  {ratio:>8.4f}")

    # Low-bit analysis of the odd iterate produced when v=4
    print("\n--- Low bits of Syracuse iterate after v=4 step ---")
    print("  (These are the low 8 bits of the odd number reached after dividing by 2^4)")
    low_mod = [b % 16 for b in low_bits_after_v4]  # mod 16 = low 4 bits
    mod16_counter = Counter(low_mod)
    print("\n  Low 4 bits (mod 16) distribution of odd iterates after v=4:")
    print(f"  {'mod16':>6}  {'Count':>8}  {'Fraction':>10}")
    for val in sorted(mod16_counter.keys()):
        cnt = mod16_counter[val]
        print(f"  {val:>6}  {cnt:>8}  {cnt / len(low_mod):>10.6f}")

    # The next v-value is determined by v_2(3*odd_after + 1)
    # Show distribution of low bits (mod 32) to understand depth
    low_mod32 = [b % 32 for b in low_bits_after_v4]
    mod32_counter = Counter(low_mod32)
    print("\n  Low 5 bits (mod 32) distribution of odd iterates after v=4:")
    print(f"  {'mod32':>6}  {'Count':>8}  {'Fraction':>10}  {'v2(3x+1)':>10}")
    for val in sorted(mod32_counter.keys()):
        cnt = mod32_counter[val]
        # Compute what v_2(3*val+1) would be
        test = 3 * val + 1
        v2 = 0
        while test > 0 and test % 2 == 0:
            test //= 2
            v2 += 1
        print(f"  {val:>6}  {cnt:>8}  {cnt / len(low_mod32):>10.6f}  {v2:>10}")


# ===================================================================
# 5. 4-STEP BLOCK ANALYSIS
# ===================================================================
def analysis_5():
    print()
    print("=" * 72)
    print("ANALYSIS 5: 4-step block frequencies vs. independence assumption")
    print("=" * 72)

    start, end, step = 3, 100001, 2
    max_v_for_blocks = 6  # cap v-values at 6 to keep block space manageable

    # Collect all v-sequences and extract 4-tuples (within trajectories)
    block_counter = Counter()
    marginal_counter = Counter()
    total_blocks = 0
    total_v = 0

    for n in range(start, end + 1, step):
        vs = v_sequence(n)
        # Cap at max_v_for_blocks for block analysis
        vs_capped = [min(v, max_v_for_blocks) for v in vs]
        for i in range(len(vs_capped)):
            marginal_counter[vs_capped[i]] += 1
            total_v += 1
        for i in range(len(vs_capped) - 3):
            block = tuple(vs_capped[i : i + 4])
            block_counter[block] += 1
            total_blocks += 1

    print(f"\nTotal v-values: {total_v}")
    print(f"Total 4-blocks: {total_blocks}")
    print(f"v-values capped at {max_v_for_blocks}")

    # Marginal probabilities
    marginal_prob = {k: v / total_v for k, v in marginal_counter.items()}
    print("\nMarginal distribution (capped):")
    for k in sorted(marginal_prob.keys()):
        print(f"  v={k}: {marginal_prob[k]:.6f} (count={marginal_counter[k]})")

    # Expected frequency under independence
    # For each observed 4-tuple, compute expected count
    print("\nTop 30 most common 4-tuples:")
    print(
        f"{'Block':>20}  {'Observed':>10}  {'Expected':>10}  {'O/E ratio':>10}  {'(O-E)^2/E':>12}"
    )
    most_common = block_counter.most_common(30)
    for block, obs in most_common:
        expected = total_blocks
        for v in block:
            expected *= marginal_prob.get(v, 0)
        if expected > 0:
            ratio = obs / expected
            chi2_contrib = (obs - expected) ** 2 / expected
        else:
            ratio = float("inf")
            chi2_contrib = 0
        print(
            f"  {str(block):>20}  {obs:>10}  {expected:>10.1f}  {ratio:>10.4f}  {chi2_contrib:>12.2f}"
        )

    # Full chi-squared over all observed blocks
    print("\n--- Chi-squared test over all observed 4-tuples ---")
    chi2 = 0.0
    n_cells = 0
    max_contrib_blocks = []
    for block, obs in block_counter.items():
        expected = total_blocks
        for v in block:
            expected *= marginal_prob.get(v, 0)
        if expected > 0:
            contrib = (obs - expected) ** 2 / expected
            chi2 += contrib
            n_cells += 1
            max_contrib_blocks.append((contrib, block, obs, expected))

    print(f"  Total chi-squared: {chi2:.2f}")
    print(f"  Number of observed 4-tuple types: {n_cells}")
    n_vals = len(marginal_prob)
    possible_cells = n_vals**4
    print(f"  Possible 4-tuple types (with cap): {possible_cells}")
    dof = n_cells - n_vals  # subtract n_vals-1 estimated marginal params + 1
    print(f"  Degrees of freedom: {dof} (n_cells={n_cells} - n_vals={n_vals})")
    print(f"  Chi-squared / dof: {chi2 / dof:.4f}")

    # Top deviators
    max_contrib_blocks.sort(reverse=True)
    print("\n  Top 15 blocks by chi-squared contribution:")
    print(f"  {'Block':>20}  {'Observed':>10}  {'Expected':>10}  {'O/E':>8}  {'ChiSq contrib':>14}")
    for contrib, block, obs, expected in max_contrib_blocks[:15]:
        ratio = obs / expected if expected > 0 else float("inf")
        print(f"  {str(block):>20}  {obs:>10}  {expected:>10.1f}  {ratio:>8.4f}  {contrib:>14.2f}")

    # Pair correlations: compare P(v_{i}, v_{i+4}) with P(v_i)*P(v_{i+4})
    print("\n--- Pairwise lag-4 joint distribution vs. independence ---")
    pair_counter = Counter()
    total_pairs = 0
    for n in range(start, end + 1, step):
        vs = v_sequence(n)
        vs_capped = [min(v, max_v_for_blocks) for v in vs]
        for i in range(len(vs_capped) - 4):
            pair = (vs_capped[i], vs_capped[i + 4])
            pair_counter[pair] += 1
            total_pairs += 1

    print(f"  Total lag-4 pairs: {total_pairs}")
    print(f"\n  {'(v_i, v_{i+4})':>16}  {'Observed':>10}  {'Expected':>10}  {'O/E':>8}")
    # Show pairs involving small v values
    for a in range(1, max_v_for_blocks + 1):
        for b in range(1, max_v_for_blocks + 1):
            obs = pair_counter.get((a, b), 0)
            exp = total_pairs * marginal_prob.get(a, 0) * marginal_prob.get(b, 0)
            if obs > 100 and exp > 0:
                ratio = obs / exp
                if abs(ratio - 1.0) > 0.02:  # only show notable deviations
                    print(f"  {str((a, b)):>16}  {obs:>10}  {exp:>10.1f}  {ratio:>8.4f}")


# ===================================================================
# MAIN
# ===================================================================
if __name__ == "__main__":
    analysis_1()
    analysis_2()
    analysis_3()
    analysis_4()
    analysis_5()
    print("\n" + "=" * 72)
    print("ANALYSIS COMPLETE")
    print("=" * 72)
