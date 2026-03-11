"""
Test the unifying hypothesis: v-sequence memory is driven by residue class
propagation, and the (v_i, n_i mod 2^k) Markov chain is the correct state space.

Key predictions to test:
1. The extended state (v_i, n_i mod 2^k) should be (approximately) Markov,
   even though v_i alone is not.
2. The near-deterministic chains (4,2,2,4,...) should correspond to specific
   residue class orbits.
3. The lag-4 autocorrelation should be EXPLAINED by the residue class transition
   matrix — i.e., the 4-step transition matrix on residues should predict the
   observed lag-4 v-v correlations.
4. Growth vs shrinkage in the chain segments: do the chains (5,4,2,2,4,3,1,...)
   NET shrink? What's the net log2 factor?
"""

import os
import sys
from collections import Counter, defaultdict
from math import log2

import numpy as np

sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))
from collatz.core import syracuse, v_sequence

MAX_N = 100001

# ===================================================================
# 1. Test: Is (v_i, n_i mod 2^k) approximately Markov?
# ===================================================================
print("=" * 72)
print("TEST 1: Is (v_i, n_i mod 2^k) Markov?")
print("=" * 72)
print()
print("Compare prediction accuracy of different state representations:")
print("  (a) v_i alone (order-1 Markov on v)")
print("  (b) (v_i, v_{i-1}) (order-2 Markov on v)")
print("  (c) (v_i, n_i mod 8) (residue-augmented)")
print("  (d) (v_i, n_i mod 16) (deeper residue)")
print()

# Collect trajectories with both v and Syracuse values
# For each step i, record: v_i, v_{i-1}, n_i (the odd number), v_{i+1}
records = []  # (v_prev, v_i, n_i_mod8, n_i_mod16, v_next)

for n in range(3, MAX_N + 1, 2):
    vs = v_sequence(n)
    syrac = syracuse(n)
    for i in range(1, len(vs) - 1):
        records.append(
            (
                vs[i - 1],  # v_{i-1}
                vs[i],  # v_i
                syrac[i] % 8,  # n_i mod 8
                syrac[i] % 16,  # n_i mod 16
                vs[i + 1],  # v_{i+1} (what we predict)
            )
        )

print(f"Total state transitions: {len(records):,}")


# Build predictors and measure entropy of v_{i+1} given each state representation
def conditional_entropy(state_fn, records):
    """Compute H(v_next | state) where state = state_fn(record)."""
    buckets = defaultdict(list)
    for rec in records:
        state = state_fn(rec)
        v_next = rec[4]
        buckets[state].append(v_next)

    total = len(records)
    h = 0.0
    for _state, v_nexts in buckets.items():
        p_state = len(v_nexts) / total
        cnt = Counter(v_nexts)
        n = len(v_nexts)
        h_state = 0.0
        for c in cnt.values():
            p = c / n
            if p > 0:
                h_state -= p * log2(p)
        h += p_state * h_state
    return h


# (a) v_i alone
h_v = conditional_entropy(lambda r: r[1], records)
# (b) (v_{i-1}, v_i)
h_vv = conditional_entropy(lambda r: (r[0], r[1]), records)
# (c) (v_i, n_i mod 8)
h_vn8 = conditional_entropy(lambda r: (r[1], r[2]), records)
# (d) (v_i, n_i mod 16)
h_vn16 = conditional_entropy(lambda r: (r[1], r[3]), records)
# (e) (v_{i-1}, v_i, n_i mod 8) — should be no better than (d) if Markov
h_vvn8 = conditional_entropy(lambda r: (r[0], r[1], r[2]), records)
# (f) unconditional
h_unc = conditional_entropy(lambda r: "any", records)

print(f"\nH(v_next)                     = {h_unc:.4f} bits")
print(f"H(v_next | v_i)               = {h_v:.4f} bits  (reduction: {h_unc - h_v:.4f})")
print(f"H(v_next | v_i, v_{{i-1}})      = {h_vv:.4f} bits  (reduction: {h_unc - h_vv:.4f})")
print(f"H(v_next | v_i, n_i mod 8)    = {h_vn8:.4f} bits  (reduction: {h_unc - h_vn8:.4f})")
print(f"H(v_next | v_i, n_i mod 16)   = {h_vn16:.4f} bits  (reduction: {h_unc - h_vn16:.4f})")
print(f"H(v_next | v_{{i-1}}, v_i, n%8) = {h_vvn8:.4f} bits  (reduction: {h_unc - h_vvn8:.4f})")

print("\nKey comparisons:")
print(f"  v_i alone explains:          {(h_unc - h_v) / h_unc * 100:.1f}% of uncertainty")
print(f"  Adding v_{{i-1}} explains:     {(h_unc - h_vv) / h_unc * 100:.1f}%")
print(f"  Adding n mod 8 explains:     {(h_unc - h_vn8) / h_unc * 100:.1f}%")
print(f"  Adding n mod 16 explains:    {(h_unc - h_vn16) / h_unc * 100:.1f}%")
print(f"  v_{{i-1}} + v_i + n%8 explains: {(h_unc - h_vvn8) / h_unc * 100:.1f}%")

# Test if adding v_{i-1} to (v_i, n_i mod 8) helps much
residual_from_vn8 = h_vn8
residual_from_vvn8 = h_vvn8
print(
    f"\n  Gain from adding v_{{i-1}} to (v_i, n%8): {residual_from_vn8 - residual_from_vvn8:.4f} bits"
)
print(f"  Gain from adding v_{{i-1}} to v_i alone:  {h_v - h_vv:.4f} bits")
print("  If (v_i, n%8) is Markov, the first should be ~0.")


# ===================================================================
# 2. Trace the near-deterministic chains through residue classes
# ===================================================================
print()
print("=" * 72)
print("TEST 2: Tracing near-deterministic chains through residue classes")
print("=" * 72)
print()
print("For the chain (4,2,2,4,...), what residue class orbits produce it?")
print()

# Find all instances of the pattern (4,2,2,4) in actual trajectories
# and record the starting residue class
chain_residues = []
for n in range(3, MAX_N + 1, 2):
    vs = v_sequence(n)
    syrac = syracuse(n)
    for i in range(len(vs) - 3):
        if vs[i] == 4 and vs[i + 1] == 2 and vs[i + 2] == 2 and vs[i + 3] == 4:
            # Record (n_i mod 32, n_i mod 64, n_i mod 128)
            chain_residues.append(
                {
                    "n_mod32": syrac[i] % 32,
                    "n_mod64": syrac[i] % 64,
                    "n_mod128": syrac[i] % 128,
                    "n_mod256": syrac[i] % 256,
                    "next_4": [syrac[i + j] % 32 for j in range(5)],
                    "v_pattern_extended": vs[i : i + 8] if i + 8 <= len(vs) else vs[i:],
                }
            )

print(f"Found {len(chain_residues):,} instances of (4,2,2,4) pattern")
print()

# What residues mod 32 produce this chain?
mod32_counts = Counter(r["n_mod32"] for r in chain_residues)
print("Starting residue mod 32:")
for res, cnt in mod32_counts.most_common(16):
    pct = cnt / len(chain_residues) * 100
    print(f"  n ≡ {res:2d} (mod 32): {cnt:6,d} occurrences ({pct:.1f}%)")

# What about mod 64?
print("\nStarting residue mod 64 (top 10):")
mod64_counts = Counter(r["n_mod64"] for r in chain_residues)
for res, cnt in mod64_counts.most_common(10):
    pct = cnt / len(chain_residues) * 100
    print(f"  n ≡ {res:2d} (mod 64): {cnt:6,d} occurrences ({pct:.1f}%)")

# What does the chain extend to after (4,2,2,4)?
print("\nExtended v-patterns after (4,2,2,4):")
ext_counter = Counter()
for r in chain_residues:
    ext = tuple(r["v_pattern_extended"][:8])
    ext_counter[ext] += 1
for pat, cnt in ext_counter.most_common(15):
    pct = cnt / len(chain_residues) * 100
    print(f"  {pat}: {cnt:6,d} ({pct:.1f}%)")


# ===================================================================
# 3. Net growth factor of chain segments
# ===================================================================
print()
print("=" * 72)
print("TEST 3: Net growth factor of chain segments")
print("=" * 72)
print()

# For each common chain, compute the APPROXIMATE net log2 factor.
# Chain (v1, v2, ..., vk) means k Syracuse steps with those v-values.
# Each step: n_{i+1} = (3*n_i + 1) / 2^{v_i}, so exact factor is
# product((3*n_i + 1) / (n_i * 2^{v_i})). We approximate this as
# 3^k / 2^{sum(v)}, ignoring the "+1" correction (which is ~1/(3*n_i)
# relative error per step, negligible for large n but ~11% at n=3).
# log2(approx factor) = k * log2(3) - sum(v)

common_chains = [
    (4, 2, 2, 4),
    (1, 1, 5, 4),
    (2, 2, 4, 3),
    (3, 1, 1, 5),
    (1, 2, 3, 4),
    (2, 4, 3, 1),
    (5, 4, 2, 2, 4, 3, 1),  # extended cycle
    (4, 2, 2, 4, 3, 1, 1, 5),  # another phase of the cycle
    (1, 1, 1, 1),  # baseline
    (1, 2, 1, 2),
]

log2_3 = log2(3)
print(
    f"{'Chain':>30s}  {'k':>3s}  {'sum(v)':>6s}  {'log2(3^k/2^sum(v))':>18s}  {'Net factor':>12s}  {'Shrinks?':>8s}"
)
print("-" * 90)
for chain in common_chains:
    k = len(chain)
    sv = sum(chain)
    log_factor = k * log2_3 - sv
    factor = 3**k / 2**sv
    shrinks = "YES" if log_factor < 0 else "NO"
    print(
        f"  {str(chain):>28s}  {k:>3d}  {sv:>6d}  {log_factor:>+18.4f}  {factor:>12.6f}  {shrinks:>8s}"
    )

# Now trace the FULL long cycle and compute its net factor
# From the block analysis: 4→2→2→4→3→1→1→5→... (period ~8?)
# Let's find the actual period by following chains in the data
print()
print("Long cycle search:")
print("Starting from pattern (4,2,2,4), what follows most often?")

# Trace the chain: start with (4,2,2,4), find most common next v
current = [4, 2, 2, 4]
print(f"  Start: {current}")
for step in range(12):
    block = tuple(current[-4:])
    next_counts = Counter()
    for n in range(3, 50001, 2):  # smaller range for speed
        vs = v_sequence(n)
        for i in range(len(vs) - 4):
            if tuple(vs[i : i + 4]) == block and i + 4 < len(vs):
                next_counts[vs[i + 4]] += 1
    if not next_counts:
        print(f"  Step {step}: No continuation found for {block}")
        break
    most_common = next_counts.most_common(3)
    best_v = most_common[0][0]
    total = sum(c for _, c in next_counts.items())
    pcts = [(v, cnt / total * 100) for v, cnt in most_common]
    current.append(best_v)
    pct_str = ", ".join(f"v={v}: {p:.1f}%" for v, p in pcts)
    print(f"  After {block} → most likely: v={best_v} ({pct_str})")

print(f"\n  Full traced chain: {current}")
k = len(current)
sv = sum(current)
log_factor = k * log2_3 - sv
print(f"  Length: {k}, sum(v): {sv}")
print(f"  log2(net factor): {log_factor:+.4f}")
print(f"  Net factor: {3**k / 2**sv:.6f}")
print(f"  Per-step average log2: {log_factor / k:+.4f}")
print(f"  Theoretical random: {log2_3 - 2:+.4f}")


# ===================================================================
# 4. Compare predicted vs observed lag-4 correlation from residue model
# ===================================================================
print()
print("=" * 72)
print("TEST 4: Residue mod 8 transition structure and v-value determinism")
print("=" * 72)
print()

# Build transition matrix on (n mod 8) → (next_n mod 8) from actual Syracuse steps
trans_mod8 = defaultdict(lambda: defaultdict(int))
v_given_mod8 = defaultdict(list)

for n in range(3, MAX_N + 1, 2):
    vs = v_sequence(n)
    syrac = syracuse(n)
    for i in range(len(vs)):
        cur_mod = syrac[i] % 8
        v_given_mod8[cur_mod].append(vs[i])
        if i + 1 < len(syrac):
            next_mod = syrac[i + 1] % 8
            trans_mod8[cur_mod][next_mod] += 1

# Show transition matrix
print("Syracuse transition matrix on residues mod 8:")
header = "from\\to"
print(f"{header:>8s}", end="")
for j in [1, 3, 5, 7]:
    print(f"  {'mod8=' + str(j):>10s}", end="")
print()
print("-" * 52)
for i in [1, 3, 5, 7]:
    total = sum(trans_mod8[i].values())
    print(f"  mod8={i}", end="")
    for j in [1, 3, 5, 7]:
        frac = trans_mod8[i][j] / total if total > 0 else 0
        print(f"  {frac:10.4f}", end="")
    print()

# Expected v given residue class
print("\nExpected v by residue class mod 8:")
for r in [1, 3, 5, 7]:
    vals = v_given_mod8[r]
    if vals:
        print(
            f"  E[v | n≡{r} mod 8] = {np.mean(vals):.4f}  (std = {np.std(vals):.4f}, n = {len(vals):,})"
        )


# ===================================================================
# 5. The critical test: does the chain structure ensure convergence?
# ===================================================================
print()
print("=" * 72)
print("TEST 5: Chain structure and convergence")
print("=" * 72)
print()
print("For trajectories that contain the dominant chain pattern,")
print("what fraction of steps are in 'chain' segments vs 'random'?")
print()

# Define chains as sequences where consecutive v-values have
# conditional probability > 0.3 (much higher than marginal)
# From our data: (5→4), (4→2 or 3), specific mod-8 driven transitions

chain_pairs = {
    (5, 4),  # P(4|5) = 0.42 vs marginal 0.08
    (4, 2),  # P(2|4) = 0.29 vs marginal 0.24 (modest)
    (4, 3),  # P(3|4) = 0.24 vs marginal 0.12
}

total_steps = 0
chain_steps = 0
growth_in_chains = []
growth_outside = []

for n in range(3, MAX_N + 1, 2):
    vs = v_sequence(n)
    for i in range(len(vs) - 1):
        total_steps += 1
        pair = (vs[i], vs[i + 1])
        step_log2 = log2_3 - vs[i]  # log2 growth of this step
        if pair in chain_pairs:
            chain_steps += 1
            growth_in_chains.append(step_log2)
        else:
            growth_outside.append(step_log2)

print(f"Total consecutive v-pairs: {total_steps:,}")
print(f"Pairs in identified chains: {chain_steps:,} ({chain_steps / total_steps * 100:.1f}%)")
print()

growth_in = np.array(growth_in_chains)
growth_out = np.array(growth_outside)
print(f"Average log2(growth) in chain segments:  {np.mean(growth_in):+.4f}")
print(f"Average log2(growth) outside chains:     {np.mean(growth_out):+.4f}")
print(
    f"Overall average log2(growth):            {np.mean(np.concatenate([growth_in, growth_out])):+.4f}"
)
print()
print(f"In chains: average v = {-np.mean(growth_in) + log2_3:.4f}")
print(f"Outside:   average v = {-np.mean(growth_out) + log2_3:.4f}")
print()

# Net: for the full chain (5,4,2,2,4,3,1,...) what is the per-step shrinkage?
# Compare to theoretical 3/4
print("For common chain segment (5,4,2,2,4,3,1,1):")
chain = [5, 4, 2, 2, 4, 3, 1, 1]
k = len(chain)
sv = sum(chain)
per_step = (k * log2_3 - sv) / k
print(f"  Per-step log2: {per_step:+.4f}")
print(f"  Theoretical random (E[v]=2): {log2_3 - 2:+.4f}")
print(f"  Simple heuristic (3/4): {log2(3 / 4):+.4f}")
print()
print("The chain grows FASTER than random when v is large (v=5,4)")
print("but shrinks FASTER when v is small (v=1,1).")
print("Question: does the chain NET shrink on average?")
print()

# Weighted average: frequency of chain × per-step factor
# This is just the overall average which we already have
print("BOTTOM LINE:")
all_growth = np.concatenate([growth_in, growth_out])
print(f"  Overall geometric mean step ratio: {np.exp(np.mean(all_growth) * np.log(2)):.6f}")
print(f"  This is {'< 1 (SHRINKING)' if np.mean(all_growth) < 0 else '>= 1 (GROWING)'}")
print(f"  Average log2 per step: {np.mean(all_growth):+.6f}")
print(f"  To reach 1 from n, need ~{-1 / np.mean(all_growth):.1f} × log2(n) steps")


print()
print("=" * 72)
print("ANALYSIS COMPLETE")
print("=" * 72)
