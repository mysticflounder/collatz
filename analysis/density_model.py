"""Updated density model for the exceptional set E using all 6 known ghost types.

Direction 2 from next-steps-2026-03-07.md.
Computes inclusion-exclusion density, empirical scan to k=1000,
and searches for new V=L+1 ghosts at L=9..12.
"""

from fractions import Fraction
from math import gcd

# Known ghost types: (D, L, V, p=ord_2(|D|), r, residue_classes)
KNOWN_GHOSTS = [
    {"d": -179, "l": 5, "v": 6, "p": 178, "r": 3, "residues": [35, 71, 142]},
    {"d": -601, "l": 6, "v": 7, "p": 25, "r": 1, "residues": [12]},
    {
        "d": -1675,
        "l": 7,
        "v": 9,
        "p": 660,
        "r": 9,
        "residues": [12, 95, 106, 165, 189, 200, 448, 542, 661],
    },
    {"d": -1931, "l": 7, "v": 8, "p": 1930, "r": 5, "residues": [275, 470, 663, 855, 1241]},
    {"d": -5537, "l": 8, "v": 10, "p": 84, "r": 2, "residues": [42, 85]},
    {
        "d": -6049,
        "l": 8,
        "v": 9,
        "p": 1441,
        "r": 10,
        "residues": [180, 283, 386, 489, 592, 695, 798, 901, 1004, 1107],
    },
]


def compute_naive_density(ghosts):
    """Compute density assuming coprime periods: 1 - prod(1 - r/p)."""
    product = 1.0
    for g in ghosts:
        product *= 1.0 - g["r"] / g["p"]
    return 1.0 - product


def compute_exact_density_two_ghosts(g1, g2):
    """Compute the overlap density for two ghost types."""
    p1, r1 = g1["p"], g1["residues"]
    p2, r2 = g2["p"], g2["residues"]
    lcm_p = p1 * p2 // gcd(p1, p2)
    # Count k in [0, lcm_p) that are covered by either ghost
    covered = set()
    for res in r1:
        k = res % p1
        while k < lcm_p:
            covered.add(k)
            k += p1
    for res in r2:
        k = res % p2
        while k < lcm_p:
            covered.add(k)
            k += p2
    return len(covered) / lcm_p


def compute_exact_density(ghosts):
    """Compute exact density using direct enumeration over LCM period."""
    # Find LCM of all periods
    periods = [g["p"] for g in ghosts]
    lcm_val = periods[0]
    for p in periods[1:]:
        lcm_val = lcm_val * p // gcd(lcm_val, p)

    print(f"  LCM of all periods: {lcm_val:,}", flush=True)

    if lcm_val > 500_000_000:
        print("  LCM too large for direct enumeration, using inclusion-exclusion", flush=True)
        return compute_inclusion_exclusion_density(ghosts)

    # Use bytearray as bitset for memory efficiency
    covered = bytearray(lcm_val)
    for g in ghosts:
        for res in g["residues"]:
            k = res % g["p"]
            while k < lcm_val:
                covered[k] = 1
                k += g["p"]
    count = sum(covered)
    print(f"  Covered {count:,} of {lcm_val:,} residues", flush=True)
    return count / lcm_val


def compute_inclusion_exclusion_density(ghosts):
    """Inclusion-exclusion with pairwise corrections."""
    n = len(ghosts)
    total = 0.0

    # Single terms
    for g in ghosts:
        total += g["r"] / g["p"]

    # Pairwise overlaps (subtract)
    for i in range(n):
        for j in range(i + 1, n):
            overlap = compute_pairwise_overlap(ghosts[i], ghosts[j])
            total -= overlap

    # Higher-order terms are small, skip for now
    return total


def compute_pairwise_overlap(g1, g2):
    """Count fraction of k covered by BOTH ghosts."""
    p1, p2 = g1["p"], g2["p"]
    lcm_p = p1 * p2 // gcd(p1, p2)
    count = 0
    for r1 in g1["residues"]:
        for r2 in g2["residues"]:
            # Check if r1 mod p1 and r2 mod p2 have common solution mod lcm_p
            # CRT: k ≡ r1 (mod p1) and k ≡ r2 (mod p2)
            # Solution exists iff r1 ≡ r2 (mod gcd(p1,p2))
            if (r1 - r2) % gcd(p1, p2) == 0:
                count += 1
    return count / lcm_p


def empirical_scan(ghosts, k_max=1000):
    """Scan E empirically using known ghost types."""
    print(f"\nEmpirical Scan of E up to k={k_max}")
    print("-" * 60)

    exceptional = set()
    ghost_at_k = {}  # k -> list of ghost D values

    for k in range(3, k_max + 1):
        for g in ghosts:
            if k >= g["residues"][0] and k % g["p"] in {r % g["p"] for r in g["residues"]}:
                exceptional.add(k)
                if k not in ghost_at_k:
                    ghost_at_k[k] = []
                ghost_at_k[k].append(g["d"])

    milestones = [100, 200, 500, 1000]
    for milestone in milestones:
        if milestone > k_max:
            break
        count = len([k for k in exceptional if k <= milestone])
        density = count / (milestone - 2)  # k ranges from 3 to milestone
        print(
            f"  |E ∩ [3, {milestone:>4}]| = {count:>4},  "
            f"density = {density:.4f} ({density * 100:.2f}%)"
        )

    return exceptional, ghost_at_k


def ord2(n):
    """Compute the multiplicative order of 2 modulo n (n must be odd)."""
    if n <= 0:
        n = abs(n)
    if n == 1:
        return 1
    result = 1
    power = 2 % n
    while power != 1:
        power = (power * 2) % n
        result += 1
        if result > 10_000_000:
            return result  # bail out
    return result


def v2(n):
    """2-adic valuation of integer n."""
    if n == 0:
        return float("inf")
    count = 0
    n = abs(n)
    while n % 2 == 0:
        count += 1
        n //= 2
    return count


def search_v_l_plus_1(l_min=9, l_max=12):
    """Search for new V=L+1 ghosts."""
    print(f"\nV=L+1 Ghost Search for L={l_min}..{l_max}")
    print("-" * 60)

    results = []
    for big_l in range(l_min, l_max + 1):
        big_v = big_l + 1
        d_val = 2**big_v - 3**big_l
        abs_d = abs(d_val)
        rho = 2 ** (-big_v / big_l)

        # Check each position for the v_i=2 slot
        found_any = False
        for pos in range(big_l):
            v_pattern = [1] * big_l
            v_pattern[pos] = 2

            # Compute R
            r_val = 0
            s_val = 0
            for i in range(big_l):
                r_val += 3 ** (big_l - 1 - i) * 2**s_val
                s_val += v_pattern[i]

            # Check case-(a)
            n_tilde = Fraction(r_val, d_val)
            current = n_tilde
            is_case_a = True
            for i in range(big_l):
                val = 3 * current + 1
                num = val.numerator
                if num == 0:
                    is_case_a = False
                    break
                actual_v = v2(num)
                if actual_v != v_pattern[i]:
                    is_case_a = False
                    break
                current = val / 2 ** v_pattern[i]

            if is_case_a and not found_any:
                found_any = True

        # Compute period
        p = ord2(abs_d)

        # Search for materializations
        canonical = [1] * big_l
        canonical[-1] = 2
        r_val = 0
        s_val = 0
        for i in range(big_l):
            r_val += 3 ** (big_l - 1 - i) * 2**s_val
            s_val += canonical[i]

        materializations = []
        search_limit = min(p, 50000)
        for k in range(big_l + 2, search_limit + 1):
            mod = 2**k
            try:
                pow(abs_d, -1, mod)  # test invertibility
            except ValueError:
                continue
            # n1 = R * (-D)^{-1} mod 2^k, but D is negative
            # n1 = R / D mod 2^k = R * D^{-1} mod 2^k
            n1 = (r_val * pow(d_val, -1, mod)) % mod
            if n1 % 2 == 0:
                continue

            # Check cycle
            current_n = n1
            valid = True
            for i in range(big_l):
                step_val = 3 * current_n + 1
                actual = v2(step_val)
                if actual != canonical[i]:
                    valid = False
                    break
                current_n = (step_val // 2 ** canonical[i]) % mod
            if valid and current_n == n1:
                materializations.append(k)

        r_count = len(materializations)
        first_k = materializations[0] if materializations else "---"

        print(
            f"  L={big_l:>2}, D={d_val:>12}, |D|={abs_d:>12}, "
            f"p={p:>8}, p/2^L={p / 2**big_l:.2f}, "
            f"r={r_count:>3}, first_k={str(first_k):>6}, rho={rho:.4f}"
        )

        results.append(
            {
                "l": big_l,
                "v": big_v,
                "d": d_val,
                "p": p,
                "r": r_count,
                "first_k": first_k,
                "rho": rho,
            }
        )

    return results


def density_summary():
    """Print the density model summary."""
    print("Density Model for Exceptional Set E")
    print("=" * 60)

    # Known ghosts table
    print("\nKnown Ghost Types:")
    print(f"{'D':>8} {'L':>3} {'V':>3} {'p':>6} {'r':>3} {'r/p':>8} {'rho':>8}")
    print("-" * 45)
    for g in KNOWN_GHOSTS:
        rho = 2 ** (-g["v"] / g["l"])
        print(
            f"{g['d']:>8} {g['l']:>3} {g['v']:>3} "
            f"{g['p']:>6} {g['r']:>3} {g['r'] / g['p']:>8.4f} {rho:>8.4f}"
        )

    # Naive density
    naive = compute_naive_density(KNOWN_GHOSTS)
    print(f"\nNaive density (coprime assumption): {naive:.4f} ({naive * 100:.2f}%)")

    # Exact density
    exact = compute_exact_density(KNOWN_GHOSTS)
    print(f"Exact density (inclusion-exclusion): {exact:.4f} ({exact * 100:.2f}%)")

    # Pairwise GCD table
    print("\nPairwise GCD of periods:")
    for i in range(len(KNOWN_GHOSTS)):
        for j in range(i + 1, len(KNOWN_GHOSTS)):
            g = gcd(KNOWN_GHOSTS[i]["p"], KNOWN_GHOSTS[j]["p"])
            if g > 1:
                print(
                    f"  gcd({KNOWN_GHOSTS[i]['p']}, {KNOWN_GHOSTS[j]['p']}) = {g}"
                    f"  (D={KNOWN_GHOSTS[i]['d']}, D={KNOWN_GHOSTS[j]['d']})"
                )


def main():
    density_summary()
    empirical_scan(KNOWN_GHOSTS, k_max=1000)
    search_v_l_plus_1(l_min=9, l_max=12)


if __name__ == "__main__":
    main()
