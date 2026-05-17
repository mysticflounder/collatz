"""
Task #50: Prove every trajectory hits chain-initiating residue classes.

Study the transition matrix on residues mod 2^k for the Syracuse map.
If the matrix is irreducible, every trajectory visits every residue class.
"""

import os
import sys
from collections import Counter

import numpy as np

sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))
from collatz.core import v_sequence


# ===================================================================
# 1. Build exact transition matrix on ODD residues mod 2^k
# ===================================================================
def syracuse_step_mod(r, mod):
    """Apply one Syracuse step to residue r, return (result mod, v-value).

    For odd r: compute 3r+1, divide out all factors of 2.
    """
    val = 3 * r + 1
    v = 0
    while val % 2 == 0:
        val //= 2
        v += 1
    return val % mod, v


def build_transition_matrix(k):
    """Build Syracuse transition matrix on odd residues mod 2^k.

    Returns: matrix T where T[i][j] = 1 if odd residue i DETERMINISTICALLY maps
    to odd residue j (i.e., v < k so the transition is the same for all n in the
    residue class). Non-deterministic transitions (v >= k) are left as zeros.
    Also returns the mapping from index to residue, v_values, and non-deterministic set.
    """
    mod = 2**k
    odd_residues = list(range(1, mod, 2))
    n = len(odd_residues)
    res_to_idx = {r: i for i, r in enumerate(odd_residues)}

    trans = np.zeros((n, n), dtype=np.float64)
    v_values = {}
    non_deterministic = set()  # residues where v >= k

    for r in odd_residues:
        next_r, v = syracuse_step_mod(r, mod)
        i = res_to_idx[r]
        v_values[r] = v
        if v < k:
            j = res_to_idx[next_r]
            trans[i][j] = 1.0
        else:
            non_deterministic.add(r)

    return trans, odd_residues, v_values, non_deterministic


# ===================================================================
# 2. Analyze irreducibility and structure for various k
# ===================================================================
print("=" * 72)
print("RESIDUE CLASS TRANSITION ANALYSIS")
print("=" * 72)

for k in [3, 4, 5, 6, 7, 8]:
    mod = 2**k
    trans, residues, v_vals, non_det = build_transition_matrix(k)
    n = len(residues)

    # Check if the transition graph is irreducible:
    # Compute reachability matrix via matrix power
    # T^n should have all nonzero entries if irreducible
    reach = np.eye(n)
    power = trans.copy()
    for _step in range(n):
        reach = np.clip(reach + power, 0, 1)
        power = np.clip(power @ trans, 0, 1)

    # Check if all entries are reachable from all starting points
    fully_reachable = np.all(reach > 0)

    # Find strongly connected components
    # Simple: check which pairs (i,j) have reach[i][j] > 0 AND reach[j][i] > 0
    mutual_reach = (reach > 0) & (reach.T > 0)
    # Each row of mutual_reach defines an SCC
    sccs = []
    visited = set()
    for i in range(n):
        if i not in visited:
            scc = set()
            for j in range(n):
                if mutual_reach[i][j]:
                    scc.add(j)
                    visited.add(j)
            sccs.append(scc)

    print(f"\n--- k = {k}, mod = {mod}, odd residues = {n} ---")
    print(f"  Non-deterministic residues (v >= k): {len(non_det)}")
    print(f"  Irreducible (fully connected): {fully_reachable}")
    print(f"  Number of SCCs: {len(sccs)}")

    if len(sccs) <= 10:
        for idx, scc in enumerate(sccs):
            res_in_scc = sorted([residues[i] for i in scc])
            if len(res_in_scc) <= 20:
                print(f"  SCC {idx}: size={len(scc)}, residues={res_in_scc}")
            else:
                print(
                    f"  SCC {idx}: size={len(scc)}, residues=[{res_in_scc[0]}, {res_in_scc[1]}, ..., {res_in_scc[-1]}]"
                )

    # For the largest SCC, check if the chain-initiating class n≡5 mod 64 is in it
    if k >= 6:
        largest_scc = max(sccs, key=len)
        largest_res = {residues[i] for i in largest_scc}
        chain_init = 5  # n ≡ 5 (mod 64)
        # Find the corresponding residue mod 2^k
        chain_residues_in_mod = [r for r in residues if r % 64 == 5]
        in_largest = [r for r in chain_residues_in_mod if r in largest_res]
        print(
            f"  Chain-initiating residues (≡5 mod 64): {len(chain_residues_in_mod)} total, {len(in_largest)} in largest SCC"
        )

    # Compute the period of the largest SCC
    largest_scc = max(sccs, key=len) if sccs else set()
    largest_scc_list = sorted(largest_scc)
    if largest_scc_list:
        # Extract sub-matrix for this SCC
        idx_list = sorted(largest_scc)
        sub_trans = trans[np.ix_(idx_list, idx_list)]
        # Period = GCD of return times from any state
        # Compute powers and check diagonal
        periods = []
        test_state = idx_list[0]
        power = trans.copy()
        for step in range(1, min(n + 1, 100)):
            if power[test_state][test_state] > 0:
                periods.append(step)
                if len(periods) >= 3:
                    break
            power = np.clip(power @ trans, 0, 1)

        if len(periods) >= 2:
            from math import gcd

            period = gcd(*periods)
            print(f"  Period of largest SCC: {period} (aperiodic = {period == 1})")
        elif periods:
            print(f"  First return to test state at step {periods[0]}")


# ===================================================================
# 3. Deep dive: k=6 (mod 64), trace the chain-initiating class
# ===================================================================
print()
print("=" * 72)
print("DEEP DIVE: Reachability of n ≡ 5 (mod 64)")
print("=" * 72)

k = 6
mod = 64
trans, residues, v_vals, non_det = build_transition_matrix(k)
res_to_idx = {r: i for i, r in enumerate(residues)}

print(f"\nNon-deterministic residues (v >= k={k}): {sorted(non_det) if non_det else 'none'}")

# From each odd residue, how many steps to first reach residue 5?
target_idx = res_to_idx[5]

first_hit = {}
for start_r in residues:
    start_idx = res_to_idx[start_r]
    # BFS/iteration
    current = start_idx
    power = np.zeros(len(residues))
    power[start_idx] = 1.0
    for step in range(1, 200):
        power = power @ trans
        if power[target_idx] > 0:
            first_hit[start_r] = step
            break
    else:
        first_hit[start_r] = -1  # unreachable

reachable = {r: s for r, s in first_hit.items() if s > 0}
unreachable = {r: s for r, s in first_hit.items() if s <= 0}

print(f"\nFrom {len(residues)} odd residues mod {mod}:")
print(f"  {len(reachable)} can reach n≡5 (mod 64)")
print(f"  {len(unreachable)} CANNOT reach n≡5 (mod 64)")

if unreachable:
    print(f"\n  Unreachable starting residues: {sorted(unreachable.keys())}")
else:
    print("\n  ALL odd residues can reach n≡5 (mod 64)!")

# Distribution of first-hit times
if reachable:
    times = sorted(reachable.values())
    print("\n  First-hit time distribution:")
    print(f"    Min: {min(times)}, Max: {max(times)}, Mean: {np.mean(times):.1f}")
    time_counts = Counter(times)
    for t in sorted(time_counts.keys()):
        bar = "#" * time_counts[t]
        print(f"    Step {t:3d}: {time_counts[t]:3d} residues  {bar}")


# ===================================================================
# 4. Can a trajectory avoid chain-initiating classes?
# ===================================================================
print()
print("=" * 72)
print("CAN TRAJECTORIES AVOID CHAIN-INITIATING CLASSES?")
print("=" * 72)
print()

# For actual trajectories, measure the gap between consecutive
# visits to the (4,2,2,4) chain pattern
print("Gap analysis: steps between consecutive (4,2,2,4) chains in trajectories")
print()

gap_lengths = []
for n in range(3, 100001, 2):
    vs = v_sequence(n)
    # Find positions where (4,2,2,4) starts
    chain_positions = []
    for i in range(len(vs) - 3):
        if vs[i] == 4 and vs[i + 1] == 2 and vs[i + 2] == 2 and vs[i + 3] == 4:
            chain_positions.append(i)
    # Compute gaps
    for j in range(1, len(chain_positions)):
        gap = chain_positions[j] - chain_positions[j - 1]
        gap_lengths.append(gap)

if gap_lengths:
    gap_arr = np.array(gap_lengths)
    print(f"Total inter-chain gaps observed: {len(gap_lengths):,}")
    print(f"Mean gap: {np.mean(gap_arr):.1f} steps")
    print(f"Median gap: {np.median(gap_arr):.1f} steps")
    print(f"Max gap: {np.max(gap_arr)} steps")
    print(f"Std dev: {np.std(gap_arr):.1f}")
    print()
    print("Gap distribution:")
    bins = [0, 8, 16, 24, 32, 48, 64, 96, 128, 256, 512, 1024]
    for i in range(len(bins) - 1):
        count = np.sum((gap_arr >= bins[i]) & (gap_arr < bins[i + 1]))
        pct = count / len(gap_arr) * 100
        bar = "#" * int(pct)
        print(f"  [{bins[i]:4d}, {bins[i + 1]:4d}): {count:6,d} ({pct:5.1f}%) {bar}")
    count = np.sum(gap_arr >= bins[-1])
    print(f"  [{bins[-1]:4d},  inf): {count:6,d} ({count / len(gap_arr) * 100:5.1f}%)")


# ===================================================================
# 5. Broader chain coverage: any residue class that initiates shrinkage
# ===================================================================
print()
print("=" * 72)
print("BROADER CHAIN ANALYSIS: All shrinking residue classes mod 64")
print("=" * 72)
print()

# For each odd residue mod 64, compute the v-value and check if
# that v-value initiates a deterministic chain
print("Odd residues mod 64, their v-values, and where they map:")
print(
    f"{'Residue':>8s}  {'v':>3s}  {'Next mod64':>10s}  {'Chain?':>7s}  {'Net log2 (8 steps)':>18s}"
)
print("-" * 55)

for r in range(1, 64, 2):
    next_r, v = syracuse_step_mod(r, 64)
    # Trace up to 8 steps, stopping at first non-deterministic step
    chain = []
    curr = r
    for _ in range(8):
        nr, nv = syracuse_step_mod(curr, 64)
        if nv >= 6:
            break
        chain.append(nv)
        curr = nr
    if chain:
        net_log2 = len(chain) * np.log2(3) - sum(chain)
        print(f"{r:8d}  {v:3d}  {next_r:10d}  {'YES':>7s}  {net_log2:+18.4f}")
    else:
        print(f"{r:8d}  {v:3d}  {next_r:10d}  {'NO':>7s}  {'N/A':>18s}")

# More useful: trace orbits and show cycles
print()
print("Orbit structure of Syracuse map on odd residues mod 64:")
visited_global = set()
orbit_id = 0
for start_r in range(1, 64, 2):
    if start_r in visited_global:
        continue
    orbit_id += 1
    orbit = []
    r = start_r
    visited_orbit = set()
    while r not in visited_orbit:
        visited_orbit.add(r)
        visited_global.add(r)
        next_r, v = syracuse_step_mod(r, 64)
        orbit.append((r, v, next_r))
        r = next_r
    # Find the cycle
    cycle_start = r
    cycle = []
    in_cycle = False
    for entry in orbit:
        if entry[0] == cycle_start:
            in_cycle = True
        if in_cycle:
            cycle.append(entry)

    tail = orbit[: len(orbit) - len(cycle)]
    v_cycle = [e[1] for e in cycle]
    cycle_sum_v = sum(v_cycle)
    cycle_len = len(cycle)
    cycle_log2 = cycle_len * np.log2(3) - cycle_sum_v

    res_cycle = [e[0] for e in cycle]
    res_tail = [e[0] for e in tail]

    if tail:
        print(f"  Orbit {orbit_id}: tail {res_tail} → cycle {res_cycle}")
    else:
        print(f"  Orbit {orbit_id}: cycle {res_cycle}")
    print(f"    v-values in cycle: {v_cycle}")
    print(f"    Cycle length: {cycle_len}, sum(v): {cycle_sum_v}, net log2: {cycle_log2:+.4f}")
    print(f"    Net factor per cycle: {3**cycle_len / 2**cycle_sum_v:.6f}")
    shrinks = "SHRINKS" if cycle_log2 < 0 else "GROWS"
    print(f"    → {shrinks}")
    print()


print("=" * 72)
print("ANALYSIS COMPLETE")
print("=" * 72)
