#!/usr/bin/env python3
"""
Joint denominator analysis: ghost cycle parameters in Janik's torus coordinates.

1. Map (L, V) pairs onto (V mod 216, L mod 216) torus coordinates
2. Compute distance to log₂3 foliation: |V·log2 - L·log3|
3. Check persistence period LCM growth
4. Analyze attrition: fraction of v_i = 1 in concentrated patterns
"""

import math

# Census data from Paper A, Section 8
# (D, L, V, e, rho, p, r_conc, r_nonc, first_k)
CENSUS = [
    (-179, 5, 6, 1, 0.4353, 178, 1, 0, 35),
    (-601, 6, 7, 1, 0.4454, 25, 1, 0, 12),
    (-1675, 7, 9, 2, 0.4102, 660, 1, 2, 12),
    (-1931, 7, 8, 1, 0.4529, 1930, 1, 0, 275),
    (-5537, 8, 10, 2, 0.4204, 84, 1, 0, 42),
    (-6049, 8, 9, 1, 0.4585, 1441, 1, 0, 180),
    (-17635, 9, 11, 2, 0.4286, 7052, 1, 2, 113),
    (-42665, 10, 14, 4, 0.3789, 1716, 0, 6, 224),
    (-50857, 10, 13, 3, 0.4061, 12714, 1, 11, 1690),
    (-54953, 10, 12, 2, 0.4353, 9078, 1, 3, 35),
    (-57001, 10, 11, 1, 0.4665, 5736, 1, 0, 1147),
    (-144379, 11, 15, 4, 0.3886, 144378, 0, 20, 434),
    (-160763, 11, 14, 3, 0.4139, 15996, 0, 7, 515),
    (-168955, 11, 13, 2, 0.4408, 67580, 1, 2, 2192),
    (-400369, 12, 17, 5, 0.3746, 98665, 0, 13, 58),
    (-498673, 12, 15, 3, 0.4204, 4452, 0, 3, 107),
    (-515057, 12, 14, 2, 0.4454, 10700, 1, 6, 37),
    (-523249, 12, 13, 1, 0.4719, 14065, 1, 0, 1334),
]

log2 = math.log(2)
log3 = math.log(3)
log2_3 = log3 / log2  # ≈ 1.58496...

print("=" * 80)
print("ANALYSIS 1: Ghost denominators in Janik's torus coordinates")
print("=" * 80)
print()
print(
    f"{'D':>8}  {'L':>3}  {'V':>3}  {'e':>2}  {'V%216':>5}  {'L%216':>5}  "
    f"{'|V·ln2-L·ln3|':>14}  {'V/L':>6}  {'log₂3':>6}  {'ratio':>8}  {'ρ':>6}"
)
print("-" * 95)

for D, L, V, e, rho, p, rc, rnc, fk in CENSUS:  # noqa: B007
    v_mod = V % 216
    l_mod = L % 216
    # Distance to the log₂3 foliation: how close is V/L to log₂3?
    dioph_dist = abs(V * log2 - L * log3)
    ratio = V / L
    print(
        f"{D:>8}  {L:>3}  {V:>3}  {e:>2}  {v_mod:>5}  {l_mod:>5}  "
        f"{dioph_dist:>14.6f}  {ratio:>6.4f}  {log2_3:>6.4f}  "
        f"{ratio / log2_3:>8.4f}  {rho:>6.4f}"
    )

print()
print("Note: ratio V/L ÷ log₂3 shows how close each ghost type is to the")
print("'balanced' line V = L·log₂3. Closer to 1.0 = smaller |D|.")

# Analysis 2: Persistence period LCM growth
print()
print("=" * 80)
print("ANALYSIS 2: Persistence period LCM growth")
print("=" * 80)
print()
print("At what 'resolution' N are all known ghost types accounted for?")
print("(i.e., lcm of all periods for ghost types with L ≤ L₀)")
print()

for L_max in range(5, 13):
    periods = [p for D, L, V, e, rho, p, rc, rnc, fk in CENSUS if L_max >= L]
    if not periods:
        continue
    lcm_val = periods[0]
    for pp in periods[1:]:
        lcm_val = lcm_val * pp // math.gcd(lcm_val, pp)
    n_types = len(periods)
    # Compare with powers of 216
    log_lcm = math.log2(lcm_val)
    print(
        f"  L ≤ {L_max:>2}: {n_types:>2} types, lcm = {lcm_val:>15,}, "
        f"log₂(lcm) = {log_lcm:>8.1f}, "
        f"lcm/216 = {lcm_val / 216:>12.1f}"
    )

# V=L+1 family (extended)
VL1_FAMILY = [
    (5, 179, 178),
    (6, 601, 25),
    (7, 1931, 1930),
    (8, 6049, 1441),
    (9, 18659, 1012),  # r=0, doesn't materialize
    (10, 57001, 5736),
    (11, 173051, 780),  # r=0
    (12, 523249, 14065),
    (13, 1577939, 58140),
    (14, 4750201, 294712),
    (15, 14283371, 1187496),
]

print()
print("  V=L+1 family LCM growth:")
for i in range(1, len(VL1_FAMILY) + 1):
    periods = [p for _, _, p in VL1_FAMILY[:i]]
    lcm_val = periods[0]
    for pp in periods[1:]:
        lcm_val = lcm_val * pp // math.gcd(lcm_val, pp)
    L = VL1_FAMILY[i - 1][0]
    print(f"    L ≤ {L:>2}: lcm = {lcm_val:>20,}")

# Analysis 3: Attrition analysis
print()
print("=" * 80)
print("ANALYSIS 3: Hensel attrition — fuel requirements for ghost types")
print("=" * 80)
print()
print("Concentrated pattern (1,...,1,e+1): L-1 steps with v=1 (each consumes")
print("one trailing 1-bit of fuel), plus one step with v=e+1.")
print()
print(
    f"{'D':>8}  {'L':>3}  {'V':>3}  {'e':>2}  {'v=1 steps':>9}  "
    f"{'fuel needed':>11}  {'P(fuel≥d)':>10}  {'materializes':>12}"
)
print("-" * 75)

for D, L, V, e, rho, p, rc, rnc, fk in CENSUS:  # noqa: B007
    # Concentrated pattern: L-1 ones, then e+1
    v1_steps = L - 1  # steps requiring exactly 1 trailing bit
    # Each v=1 step needs the iterate to be ≡ 1 mod 4 (trailing ...01)
    # Each v≥2 step needs trailing ...0 pattern
    # Fuel = number of consecutive v=1 steps (worst case needs that many trailing 1-bits)
    fuel_needed = v1_steps  # each v=1 consumes one bit of fuel
    p_fuel = 2 ** (-fuel_needed)
    materializes = "YES" if (rc + rnc > 0) else "NO"
    print(
        f"{D:>8}  {L:>3}  {V:>3}  {e:>2}  {v1_steps:>9}  "
        f"{fuel_needed:>11}  {p_fuel:>10.2e}  {materializes:>12}"
    )

print()
print("Key insight: P(fuel ≥ d) = 2^{-d} is the probability that a random")
print("odd integer has ≥ d trailing 1-bits in binary. For L=12, concentrated")
print("patterns need 11 trailing 1-bits: probability 1/2048.")
print()
print("Non-concentrated patterns distribute fuel differently: e.g., (1,2,1,1,3)")
print("has shorter runs of v=1, requiring less consecutive fuel.")

# Analysis 4: Check k=729 against ALL ghost types
print()
print("=" * 80)
print("ANALYSIS 4: k=729 check against all ghost types")
print("=" * 80)
print()
for D, L, V, e, rho, p, rc, rnc, fk in CENSUS:  # noqa: B007
    if (rc + rnc) == 0:
        continue
    # Check if 729 is in the arithmetic progression
    residue = 729 % p
    # We don't know k₀ for all types, but first_k gives us one
    fk_residue = fk % p
    match = residue == fk_residue
    print(
        f"  D={D:>8}, p={p:>6}, 729 mod p = {residue:>5}, "
        f"first_k mod p = {fk_residue:>5}  {'*** MATCH ***' if match else ''}"
    )

# ============================================================
# Analysis 5: Attrition barriers for non-concentrated patterns
# ============================================================
print()
print("=" * 80)
print("ANALYSIS 5: Attrition barriers — concentrated vs non-concentrated")
print("=" * 80)
print()
print("Janik's hensel_attrition theorem: d consecutive v₂=1 steps require")
print("2^(d+1) | (n+1). The barrier depends on the LONGEST run of v=1,")
print("not the total count.")
print()


def max_run_of_ones(pattern):
    """Find the longest consecutive run of 1s in a pattern."""
    max_run = 0
    current = 0
    for v in pattern:
        if v == 1:
            current += 1
            max_run = max(max_run, current)
        else:
            current = 0
    return max_run


def attrition_barrier(pattern):
    """Fraction of odd residues that can sustain this pattern's longest v=1 run."""
    d = max_run_of_ones(pattern)
    return d, 2 ** (-d) if d > 0 else 1.0


# Concentrated patterns: (1,1,...,1,e+1) for each census entry
print("--- Concentrated patterns ---")
print(f"{'D':>8}  {'L':>3}  {'e':>2}  {'pattern':>25}  {'max_run':>7}  {'P(fuel)':>10}")
print("-" * 70)

for D, L, V, e, rho, p, rc, rnc, fk in CENSUS:  # noqa: B007
    conc = [1] * (L - 1) + [e + 1]
    d, prob = attrition_barrier(conc)
    pat_str = f"({','.join(str(v) for v in conc)})"
    if len(pat_str) > 25:
        pat_str = f"(1,...,1,{e + 1}) len={L}"
    print(f"{D:>8}  {L:>3}  {e:>2}  {pat_str:>25}  {d:>7}  {prob:>10.2e}")

# Some example non-concentrated patterns and their attrition barriers
print()
print("--- Example non-concentrated patterns (lower attrition barriers) ---")
print(f"{'pattern':>30}  {'L':>3}  {'V':>3}  {'max_run':>7}  {'P(fuel)':>10}  {'vs conc':>10}")
print("-" * 80)

examples = [
    # (pattern, L, V, D_approx)
    ([2, 1, 1, 1, 2], 5, 7, -1675),
    ([1, 2, 1, 2, 1], 5, 7, -1675),
    ([3, 1, 1, 1, 1, 1, 2], 7, 10, -5537),
    ([2, 1, 2, 1, 2, 1, 1], 7, 10, -5537),
    ([1, 3, 1, 1, 2, 1, 1], 7, 10, -5537),
    ([2, 1, 1, 2, 1, 1, 1, 1, 2, 1], 10, 13, -50857),
    ([1, 2, 1, 2, 1, 1, 2, 1, 1, 1], 10, 13, -50857),
    ([2, 1, 2, 1, 1, 1, 2, 1, 1, 2], 10, 14, -54953),
    ([2, 1, 1, 1, 2, 1, 1, 1, 2, 1, 1, 1], 12, 15, -498673),
    ([1, 2, 1, 1, 1, 2, 1, 1, 1, 2, 1, 1], 12, 15, -498673),
]

for pat, L, V, D_approx in examples:  # noqa: B007
    assert len(pat) == L, f"Pattern length mismatch: {pat} has {len(pat)}, expected {L}"
    assert sum(pat) == V, f"Pattern sum mismatch: {pat} sums to {sum(pat)}, expected {V}"
    d, prob = attrition_barrier(pat)
    # Compare to concentrated
    conc_d = L - 1
    conc_prob = 2 ** (-conc_d)
    improvement = prob / conc_prob if conc_prob > 0 else float("inf")
    pat_str = f"({','.join(str(v) for v in pat)})"
    print(f"{pat_str:>30}  {L:>3}  {V:>3}  {d:>7}  {prob:>10.2e}  {improvement:>9.0f}x")

print()
print("Interpretation: non-concentrated patterns with shorter v=1 runs have")
print("exponentially higher fuel probability. A pattern with max_run=3 has")
print("P=1/8, vs P=1/2048 for concentrated L=12. That's 256x more starting")
print("points that can sustain it.")
print()
print("This explains WHY r_nonc > 0 for some types where r_conc = 0:")
print("the non-concentrated patterns have lower attrition barriers,")
print("so more residue classes can enter the cycle.")
