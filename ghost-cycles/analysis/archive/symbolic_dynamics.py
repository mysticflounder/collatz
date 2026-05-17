"""
Task #51: Formalize the chain structure as a symbolic dynamics system.

Enumerate ALL deterministic chains at various moduli, compute their
shrinkage, and determine what fraction of steps they cover.
"""

import os
import sys
from collections import Counter, defaultdict
from math import log2

import numpy as np

sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))
from collatz.core import syracuse, v_sequence


def syracuse_step_mod(r, mod):
    """Apply one Syracuse step to residue r mod 'mod'."""
    val = 3 * r + 1
    v = 0
    while val % 2 == 0:
        val //= 2
        v += 1
    return val % mod, v


# ===================================================================
# 1. Enumerate deterministic chains at each modulus
# ===================================================================
print("=" * 72)
print("DETERMINISTIC CHAIN ENUMERATION")
print("=" * 72)
print()
print("A 'deterministic chain of length L' at modulus 2^k means:")
print("For residue r mod 2^k, the next L v-values are completely fixed")
print("(all numbers n ≡ r mod 2^k produce the same v-sequence prefix).")
print()

for k in [4, 5, 6, 7, 8, 10, 12]:
    mod = 2**k
    # For each odd residue, trace forward and check if the v-sequence
    # is deterministic (same v regardless of the actual number n)
    # At mod 2^k, the first step's v-value is determined by n mod 2^k
    # But subsequent steps depend on the result mod 2^k, which may
    # not be fully determined.

    # Actually, the Syracuse map on residues mod 2^k IS deterministic:
    # each residue maps to exactly one next residue. So from any
    # starting residue, the v-sequence is completely determined
    # for as long as we stay within the mod 2^k world.

    # The question is: do different n ≡ r (mod 2^k) produce the
    # same v-sequence? The answer is: the FIRST step's v-value
    # might differ if k is too small. But if v < k, then the
    # v-value is exactly determined by r mod 2^k.

    # More precisely: v_2(3r + 1) is determined by r alone
    # (it's a property of the number, not just the residue).
    # But for n ≡ r (mod 2^k), we have 3n+1 ≡ 3r+1 (mod 3·2^k),
    # so v_2(3n+1) = v_2(3r+1) as long as v_2(3r+1) < k.

    # So a chain is "deterministic up to length L" if, tracing
    # L steps through the mod 2^k Syracuse map, each intermediate
    # v-value is < k.

    total_odd = mod // 2
    chains = {}  # residue -> (v_sequence, length_before_uncertain)

    for r in range(1, mod, 2):
        vs = []
        curr = r
        for _step in range(k):  # max k steps can be determined
            next_r, v = syracuse_step_mod(curr, mod)
            if v >= k:
                # This v-value might not be exact for all n ≡ r mod 2^k
                break
            vs.append(v)
            curr = next_r
        chains[r] = tuple(vs)

    # Statistics
    lengths = [len(vs) for vs in chains.values()]
    max_len = max(lengths) if lengths else 0
    mean_len = np.mean(lengths) if lengths else 0

    # Group by chain length
    len_counts = Counter(lengths)

    print(f"--- k = {k}, mod = {mod} ---")
    print(f"  Odd residues: {total_odd}")
    print(f"  Max deterministic chain length: {max_len}")
    print(f"  Mean chain length: {mean_len:.1f}")
    print("  Distribution of chain lengths:")
    for length in sorted(len_counts.keys()):
        cnt = len_counts[length]
        pct = cnt / total_odd * 100
        bar = "#" * max(1, int(pct / 2))
        print(f"    L={length:3d}: {cnt:6d} residues ({pct:5.1f}%) {bar}")

    # Compute coverage: what fraction of steps (weighted by frequency)
    # are in deterministic chains?
    # Weight each chain by its length (more steps = more coverage)
    total_det_steps = sum(len(vs) for vs in chains.values())
    total_possible_steps = total_odd * k  # if all had max length
    coverage = total_det_steps / total_possible_steps
    print(f"  Coverage (det steps / max possible): {coverage:.4f}")

    # Compute net shrinkage of all deterministic chains
    shrinkage_factors = []
    for _r, vs in chains.items():
        if len(vs) >= 2:
            clen = len(vs)
            sv = sum(vs)
            log_factor = clen * log2(3) - sv
            shrinkage_factors.append(log_factor)

    if shrinkage_factors:
        sf = np.array(shrinkage_factors)
        print(f"  Avg log2(factor) of chains (len≥2): {np.mean(sf):+.4f}")
        print(f"  Fraction that shrink: {np.mean(sf < 0):.4f}")
    print()


# ===================================================================
# 2. The symbolic dynamics alphabet
# ===================================================================
print("=" * 72)
print("SYMBOLIC DYNAMICS: THE CHAIN ALPHABET AT MOD 64")
print("=" * 72)
print()

k = 6
mod = 64

# Build all deterministic chains and group by v-sequence
chain_groups = defaultdict(list)  # v_tuple -> list of residues
for r in range(1, mod, 2):
    vs = []
    curr = r
    for _step in range(k):
        next_r, v = syracuse_step_mod(curr, mod)
        if v >= k:
            break
        vs.append(v)
        curr = next_r
    chain_groups[tuple(vs)].append(r)

print(f"Distinct v-sequence prefixes (chain types) at mod {mod}:")
print(
    f"{'v-sequence':>30s}  {'#residues':>10s}  {'length':>6s}  {'sum(v)':>6s}  {'net log2':>10s}  {'shrinks':>8s}"
)
print("-" * 78)

sorted_chains = sorted(chain_groups.items(), key=lambda x: -len(x[1]))
for vs, residues in sorted_chains:
    clen = len(vs)
    sv = sum(vs)
    log_factor = clen * log2(3) - sv if clen > 0 else 0
    shrinks = "YES" if log_factor < 0 else "NO" if clen > 0 else "-"
    print(
        f"  {str(vs):>28s}  {len(residues):10d}  {clen:6d}  {sv:6d}  {log_factor:+10.4f}  {shrinks:>8s}"
    )

# How many steps per residue does each chain contribute?
total_odd = mod // 2
total_chain_steps = sum(len(vs) * len(res) for vs, res in chain_groups.items())
total_shrinking_steps = sum(
    len(vs) * len(res)
    for vs, res in chain_groups.items()
    if len(vs) > 0 and (len(vs) * log2(3) - sum(vs)) < 0
)
print(f"\nTotal deterministic chain steps: {total_chain_steps}")
print(f"Total shrinking chain steps: {total_shrinking_steps}")
print(f"Average chain steps per residue: {total_chain_steps / total_odd:.1f}")
print(f"Fraction of chain steps that shrink: {total_shrinking_steps / total_chain_steps:.4f}")


# ===================================================================
# 3. Higher moduli: does coverage increase?
# ===================================================================
print()
print("=" * 72)
print("COVERAGE SCALING: Does deterministic coverage increase with k?")
print("=" * 72)
print()

print(
    f"{'k':>4s}  {'mod':>10s}  {'avg chain len':>14s}  {'% shrinking chains':>20s}  {'avg net log2':>14s}"
)
print("-" * 68)

for k in [3, 4, 5, 6, 7, 8, 10, 12, 14]:
    mod = 2**k
    total_odd = mod // 2

    chain_lens = []
    shrink_count = 0
    total_chains = 0
    net_log2s = []

    for r in range(1, mod, 2):
        vs = []
        curr = r
        for _step in range(k):
            next_r, v = syracuse_step_mod(curr, mod)
            if v >= k:
                break
            vs.append(v)
            curr = next_r

        clen = len(vs)
        chain_lens.append(clen)
        if clen > 0:
            total_chains += 1
            net = clen * log2(3) - sum(vs)
            net_log2s.append(net)
            if net < 0:
                shrink_count += 1

    avg_len = np.mean(chain_lens)
    pct_shrink = shrink_count / total_chains * 100 if total_chains > 0 else 0
    avg_net = np.mean(net_log2s) if net_log2s else 0

    print(f"{k:4d}  {mod:10d}  {avg_len:14.2f}  {pct_shrink:20.1f}%  {avg_net:+14.4f}")


# ===================================================================
# 4. The cycle structure: which chains feed into which?
# ===================================================================
print()
print("=" * 72)
print("CHAIN TRANSITION GRAPH AT MOD 64")
print("=" * 72)
print()

k = 6
mod = 64

# Build: for each starting residue, its chain, and what residue it ends at
chain_endpoints = {}  # residue -> (chain_vs, end_residue)
for r in range(1, mod, 2):
    vs = []
    curr = r
    for _step in range(k):
        next_r, v = syracuse_step_mod(curr, mod)
        if v >= k:
            break
        vs.append(v)
        curr = next_r
    chain_endpoints[r] = (tuple(vs), curr)

# Group residues by their chain type AND end residue
print("Chain types and their transitions:")
transition_count = Counter()
for _r, (vs, end_r) in chain_endpoints.items():
    end_chain = chain_endpoints.get(end_r, ((), end_r))[0]
    if end_chain:
        transition_count[(vs, end_chain)] += 1
    else:
        transition_count[(vs, ("?",))] += 1

for (src, dst), cnt in sorted(transition_count.items(), key=lambda x: -x[1]):
    src_log = len(src) * log2(3) - sum(src) if src else 0
    dst_log = len(dst) * log2(3) - sum(dst) if all(isinstance(x, int) for x in dst) else 0
    print(
        f"  {str(src):>20s} -> {str(dst):>20s}  (x{cnt:3d})  log2: {src_log:+.2f} -> {dst_log:+.2f}"
    )


# ===================================================================
# 5. Empirical: what fraction of actual trajectory steps are covered
#    by deterministic chains of various lengths?
# ===================================================================
print()
print("=" * 72)
print("EMPIRICAL CHAIN COVERAGE IN ACTUAL TRAJECTORIES")
print("=" * 72)
print()

# For each trajectory, align it to residue classes mod 64 and check
# how many steps match the deterministic prediction

total_steps = 0
chain_matched_steps = 0  # steps consumed by full-chain matches
single_matched_steps = 0  # single steps where first v matches
mismatched_steps = 0  # single steps where first v doesn't match

chain_lens_seen = []

for n in range(3, 50001, 2):
    vs = v_sequence(n)
    syrac = syracuse(n)

    i = 0
    while i < len(vs):
        r = syrac[i] % mod
        predicted_chain = chain_endpoints.get(r, ((), r))[0]

        if predicted_chain and i + len(predicted_chain) <= len(vs):
            actual = tuple(vs[i : i + len(predicted_chain)])
            if actual == predicted_chain:
                chain_matched_steps += len(predicted_chain)
                total_steps += len(predicted_chain)
                chain_lens_seen.append(len(predicted_chain))
                i += len(predicted_chain)
                continue

        # Single step fallback
        total_steps += 1
        if predicted_chain and vs[i] == predicted_chain[0]:
            single_matched_steps += 1
        else:
            mismatched_steps += 1
        i += 1

print(f"Total steps analyzed: {total_steps:,}")
print(
    f"Steps in complete chains: {chain_matched_steps:,} ({chain_matched_steps / total_steps * 100:.1f}%)"
)
print(
    f"Single-step matches: {single_matched_steps:,} ({single_matched_steps / total_steps * 100:.1f}%)"
)
print(f"Mismatched steps: {mismatched_steps:,} ({mismatched_steps / total_steps * 100:.1f}%)")

if chain_lens_seen:
    print("\nChain length distribution (when full chain matched):")
    cl_counter = Counter(chain_lens_seen)
    for length, cnt in sorted(cl_counter.items()):
        total_from = cnt * length
        print(f"  Length {length}: {cnt:6,d} chains ({total_from:8,d} steps)")


print()
print("=" * 72)
print("ANALYSIS COMPLETE")
print("=" * 72)
