"""
Computational verification of Baker-Wustholz analysis claims.

Verifies Theorems A-D from docs/proofs/baker-wustholz-analysis.md:
- ord_2(|D|) for known ghost cycle denominators
- K_0(L_0) bounds for short ghost cycles
- Ghost cycle reappearance scan (k=35 ghost at k=37..178)
- Small-denominator pair table
- Cycle equation algebra (Theorem B)
"""

import math

import matplotlib

matplotlib.use("Agg")


def ord_2_mod(n):
    """Multiplicative order of 2 modulo n (smallest e>0 with 2^e ≡ 1 mod n)."""
    if n <= 1 or math.gcd(2, n) != 1:
        return None
    power = 1
    for e in range(1, n + 1):
        power = (power * 2) % n
        if power == 1:
            return e
    return None


def syracuse_step(n, mod):
    """One step of Syracuse map on odd residues mod 2^k. Returns (successor, v)."""
    val = 3 * n + 1
    v = 0
    tmp = val
    while tmp % 2 == 0:
        tmp //= 2
        v += 1
    succ = (val >> v) % mod
    return succ, v


def check_ghost_cycle(k, v_pattern):
    """Check if a ghost cycle with given v-pattern exists at level k.

    Returns (exists, n1, cycle_elements) where exists is True if the
    cycle equation solution produces the correct v-pattern.
    """
    pat = list(v_pattern)
    big_l = len(pat)
    big_v = sum(pat)
    d = 2**big_v - 3**big_l
    mod = 2**k

    # Cycle equation: n_1 * (2^V - 3^L) = R (mod 2^{k+V})
    # Derivation: iterating n_{i+1} = (3*n_i + 1) / 2^{v_i} gives
    #   n_1 = 3^L * n_1 / 2^V + R / 2^V
    # where R = sum_{i=0}^{L-1} 3^{L-1-i} * 2^{S_i}
    # and S_i = v_1 + ... + v_i (partial sum), S_0 = 0.
    r = 0
    s_i = 0  # S_0 = 0
    for i in range(big_l):
        r += (3 ** (big_l - 1 - i)) * (2**s_i)
        s_i += pat[i]

    # Solve n1 * D ≡ R (mod 2^{k+V})
    # Since D is odd, it's invertible mod any power of 2
    mod_eq = 2 ** (k + big_v)
    d_inv = pow(d, -1, mod_eq)
    n1_full = (r * d_inv) % mod_eq
    n1 = n1_full % mod

    # Make sure n1 is odd and in range
    if n1 % 2 == 0:
        return False, n1, []

    # Check: follow the Syracuse map and verify v-pattern
    elements = [n1]
    cur = n1
    for i in range(big_l):
        val = 3 * cur + 1
        v_actual = 0
        tmp = val
        while tmp % 2 == 0:
            tmp //= 2
            v_actual += 1
        if v_actual != pat[i]:
            return False, n1, elements
        cur = (val >> pat[i]) % mod
        if i < big_l - 1:
            elements.append(cur)

    # Check cycle closes
    if cur != n1:
        return False, n1, elements

    return True, n1, elements


def verify_ord2_values():
    """Verify ord_2(|D|) for known ghost cycle denominators (Table in Theorem C)."""
    print("=" * 60)
    print("VERIFICATION: ord_2(|D|) for known ghost denominators")
    print("=" * 60)

    cases = [
        (5, 6, -179, 178),  # k=35 ghost
        (6, 7, -601, 25),  # k=12 ghost
    ]

    all_pass = True
    for big_l, big_v, d_expected, ord_expected in cases:
        d = 2**big_v - 3**big_l
        assert d == d_expected, f"D mismatch: {d} != {d_expected}"
        o = ord_2_mod(abs(d))
        status = "PASS" if o == ord_expected else "FAIL"
        if o != ord_expected:
            all_pass = False
        print(
            f"  (L={big_l}, V={big_v}): D = {d}, |D| = {abs(d)}, "
            f"ord_2(|D|) = {o}, expected {ord_expected} [{status}]"
        )

    print(f"\n  Result: {'ALL PASS' if all_pass else 'FAILURES DETECTED'}\n")
    return all_pass


def verify_denominator_table():
    """Verify the small-denominator pairs table (Section 8.1)."""
    print("=" * 60)
    print("VERIFICATION: Small-denominator pairs |2^V - 3^L|")
    print("=" * 60)

    # (L, V, expected_D)
    cases = [
        (2, 3, -1),
        (3, 4, -11),
        (3, 5, 5),
        (4, 5, -49),
        (4, 6, -17),
        (4, 7, 47),
        (5, 6, -179),
        (5, 7, -115),
        (5, 8, 13),
        (5, 9, 269),
        (6, 7, -601),
        (6, 8, -473),
        (6, 9, -217),
        (6, 10, 295),
        (7, 11, -139),
        (8, 13, 1631),
        (9, 14, -3299),
        (10, 16, 6487),
        (12, 19, -7153),
    ]

    all_pass = True
    for big_l, big_v, d_expected in cases:
        d = 2**big_v - 3**big_l
        status = "PASS" if d == d_expected else "FAIL"
        if d != d_expected:
            all_pass = False
        print(
            f"  (L={big_l:2d}, V={big_v:2d}): 2^V - 3^L = {d:>8d}, "
            f"expected {d_expected:>8d} [{status}]"
        )

    print(f"\n  Result: {'ALL PASS' if all_pass else 'FAILURES DETECTED'}\n")
    return all_pass


def verify_k0_bounds():
    """Verify K_0(L_0) bounds from Theorem D (Section 5.2)."""
    print("=" * 60)
    print("VERIFICATION: K_0(L_0) bounds (crude, using |D|)")
    print("=" * 60)

    # Expected: K_0^crude(L_0) = max |2^V - 3^L| over
    # 2 <= L <= L_0, L+1 <= V <= 2L-1
    expected = {
        2: 1,
        3: 11,
        4: 49,
        5: 269,
        6: 1319,
        7: 6005,
        8: 26207,
        9: 111389,
        10: 465239,
    }

    all_pass = True
    for l0 in range(2, 11):
        max_d = 0
        controlling = (0, 0)
        for big_l in range(2, l0 + 1):
            for big_v in range(big_l + 1, 2 * big_l):
                d = abs(2**big_v - 3**big_l)
                if d > max_d:
                    max_d = d
                    controlling = (big_l, big_v)
        exp = expected.get(l0)
        status = "PASS" if max_d == exp else "FAIL"
        if max_d != exp:
            all_pass = False
        print(
            f"  K_0({l0:2d}) = {max_d:>10d}, controlling ({controlling[0]},{controlling[1]}), "
            f"expected {exp:>10d} [{status}]"
        )

    # Also compute L0=15 and L0=20
    for l0 in [15, 20]:
        max_d = 0
        controlling = (0, 0)
        for big_l in range(2, l0 + 1):
            for big_v in range(big_l + 1, 2 * big_l):
                d = abs(2**big_v - 3**big_l)
                if d > max_d:
                    max_d = d
                    controlling = (big_l, big_v)
        print(f"  K_0({l0:2d}) = {max_d:>15d}, controlling ({controlling[0]},{controlling[1]})")

    print(f"\n  Result: {'ALL PASS' if all_pass else 'FAILURES DETECTED'}\n")
    return all_pass


def verify_cycle_equation():
    """Verify Theorem B: cycle equation for known ghost cycles."""
    print("=" * 60)
    print("VERIFICATION: Cycle equation (Theorem B)")
    print("=" * 60)

    # Known ghost cycles: (k, v_pattern)
    known_ghosts = [
        (35, (2, 1, 1, 1, 1)),  # k=35, L=5, V=6
        (12, (1, 1, 1, 1, 1, 2)),  # k=12, L=6, V=7 (one of the k=12 cycles)
    ]

    all_pass = True
    for k, v_pat in known_ghosts:
        exists, n1, elements = check_ghost_cycle(k, v_pat)
        status = "PASS" if exists else "FAIL"
        if not exists:
            all_pass = False
        big_l = len(v_pat)
        big_v = sum(v_pat)
        d = 2**big_v - 3**big_l
        print(f"  k={k}, v-pattern={v_pat}: L={big_l}, V={big_v}, D={d}")
        print(f"    n1 = {n1}, cycle exists: {exists} [{status}]")
        if exists:
            print(f"    cycle elements: {elements}")

    print(f"\n  Result: {'ALL PASS' if all_pass else 'FAILURES DETECTED'}\n")
    return all_pass


def scan_ghost_reappearance():
    """Scan for reappearance of k=35 ghost at k=37..178."""
    print("=" * 60)
    print("SCAN: k=35 ghost (L=5, V=6, D=-179) reappearance at k=37..178")
    print("=" * 60)

    v_pattern = (2, 1, 1, 1, 1)
    ord_bound = 178  # ord_2(179) = 178

    reappearances = []
    for k in range(37, ord_bound + 1):
        exists, n1, elements = check_ghost_cycle(k, v_pattern)
        if exists:
            reappearances.append(k)
            print(f"  k={k}: GHOST REAPPEARS! n1={n1}")

    if not reappearances:
        print(f"  No reappearance found in k=37..{ord_bound}")
    else:
        print(f"\n  Found {len(reappearances)} reappearances: {reappearances}")

    # Also scan all v-patterns for L=5 (not just (2,1,1,1,1))
    print(f"\n  Scanning ALL v-patterns with L=5, V=6 at k=37..{ord_bound}...")
    # Compositions of 6 into 5 parts, each >= 1
    from itertools import product as iter_product

    patterns = []
    for combo in iter_product(range(1, 6), repeat=5):
        if sum(combo) == 6:
            patterns.append(combo)

    any_found = False
    for pat in patterns:
        for k in range(37, ord_bound + 1):
            exists, n1, _elements = check_ghost_cycle(k, pat)
            if exists:
                any_found = True
                print(f"  k={k}: Ghost with v-pattern {pat}, n1={n1}")

    if not any_found:
        print(f"  No L=5, V=6 ghost found at any k in [37, {ord_bound}]")

    # Also check other (L,V) pairs with D=-179 or small |D|
    print("\n  Scanning other short cycles (L<=8, rho>1/4) at k=37..100...")
    found_any = False
    for big_l in range(2, 9):
        for big_v in range(big_l + 1, 2 * big_l):
            d = 2**big_v - 3**big_l
            # Generate all compositions of V into L parts >= 1
            pats = []
            for combo in iter_product(range(1, big_v), repeat=big_l):
                if sum(combo) == big_v:
                    pats.append(combo)
            for pat in pats:
                for k in range(37, 101):
                    exists, n1, _el = check_ghost_cycle(k, pat)
                    if exists:
                        found_any = True
                        print(
                            f"  k={k}: Ghost L={big_l}, V={big_v}, v-pattern={pat}, D={d}, n1={n1}"
                        )

    if not found_any:
        print("  No short ghost cycles found at k=37..100")

    print()
    return reappearances


def verify_d_always_odd():
    """Verify D = 2^V - 3^L is always odd (Section 3.2 claim)."""
    print("=" * 60)
    print("VERIFICATION: D = 2^V - 3^L is always odd")
    print("=" * 60)

    all_odd = True
    for big_l in range(1, 51):
        for big_v in range(1, 51):
            d = 2**big_v - 3**big_l
            if d % 2 == 0:
                all_odd = False
                print(f"  FAIL: D even at L={big_l}, V={big_v}")

    status = "PASS" if all_odd else "FAIL"
    print(f"  Checked L,V in [1,50]: all D odd [{status}]\n")
    return all_odd


def verify_baker_bound():
    """Verify Baker-Wustholz lower bound (Theorem A) against known values."""
    print("=" * 60)
    print("VERIFICATION: Baker-Wustholz bound |2^V - 3^L| > max * exp(-25(logV)^2)")
    print("=" * 60)

    cases = [
        (5, 6),
        (6, 7),
        (5, 8),
        (7, 11),
        (12, 19),
        (26, 37),
        (25, 37),
        (22, 30),
    ]

    all_pass = True
    for big_l, big_v in cases:
        d = abs(2**big_v - 3**big_l)
        m = max(2**big_v, 3**big_l)
        bound = m * math.exp(-25 * math.log(big_v) ** 2) if big_v >= 3 else 0
        ratio = d / bound if bound > 0 else float("inf")
        status = "PASS" if d > bound else "FAIL"
        if d <= bound:
            all_pass = False
        print(
            f"  (L={big_l:2d}, V={big_v:2d}): |D|={d:>8d}, "
            f"bound={bound:>10.1f}, ratio={ratio:>8.1f} [{status}]"
        )

    print(f"\n  Result: {'ALL PASS' if all_pass else 'FAILURES DETECTED'}\n")
    return all_pass


def verify_convergent_table():
    """Verify the convergents of log_2(3) table."""
    print("=" * 60)
    print("VERIFICATION: Convergents of log_2(3) and |2^V - 3^L|")
    print("=" * 60)

    # Known convergents of log_2(3): 1/1, 2/1, 3/2, 5/3, 8/5, 19/12, 65/41, 84/53
    convergents = [(3, 2), (8, 5), (19, 12), (65, 41), (84, 53)]

    for big_v, big_l in convergents:
        d = 2**big_v - 3**big_l
        print(
            f"  V/L = {big_v}/{big_l} = {big_v / big_l:.4f}: "
            f"2^{big_v} - 3^{big_l} = {d} (|D| = {abs(d)})"
        )

    print()


def scan_d601_complete():
    """Complete scan of D=-601 (L=6, V=7) ghosts at k=3..150 to map periodicity."""
    print("=" * 60)
    print("COMPLETE SCAN: D=-601 ghosts at k=3..150")
    print("=" * 60)

    # All cyclic rotations of v-patterns with L=6, V=7
    from itertools import product as iter_product

    patterns = []
    for combo in iter_product(range(1, 7), repeat=6):
        if sum(combo) == 7:
            patterns.append(combo)

    ghost_levels = {}  # k -> list of v-patterns found
    for k in range(3, 151):
        for pat in patterns:
            exists, n1, _el = check_ghost_cycle(k, pat)
            if exists:
                if k not in ghost_levels:
                    ghost_levels[k] = []
                ghost_levels[k].append(pat)

    print(f"  Ghost levels found: {sorted(ghost_levels.keys())}")
    if len(ghost_levels) >= 2:
        levels = sorted(ghost_levels.keys())
        gaps = [levels[i + 1] - levels[i] for i in range(len(levels) - 1)]
        print(f"  Gaps between consecutive: {gaps}")
        print("  Number of v-patterns per level:")
        for k in levels:
            print(f"    k={k:3d}: {len(ghost_levels[k])} patterns")

    print()
    return ghost_levels


def scan_e_membership():
    """Determine E membership for k=37..200 using known ghost (L,V) pairs.

    Rather than enumerating all compositions (combinatorial explosion),
    we check the specific (L,V) pairs known to produce ghosts (L<=8),
    trying all cyclic v-patterns for each.
    """
    print("=" * 60)
    print("EXCEPTIONAL SET E: membership scan k=37..200")
    print("=" * 60)

    from itertools import product as iter_product

    # Known ghost-producing (L,V) pairs with rho > 1/4
    # For each, enumerate v-patterns (compositions of V into L parts >= 1)
    lv_pairs = [
        (2, 3),
        (3, 4),
        (3, 5),
        (4, 5),
        (4, 6),
        (4, 7),
        (5, 6),
        (5, 7),
        (5, 8),
        (5, 9),
        (6, 7),
        (6, 8),
        (6, 9),
        (6, 10),
        (6, 11),
        (7, 8),
        (7, 9),
        (7, 10),
        (7, 11),
        (7, 12),
        (7, 13),
        (8, 9),
        (8, 10),
        (8, 11),
        (8, 12),
        (8, 13),
        (8, 14),
        (8, 15),
    ]

    # Pre-compute patterns for each (L,V) — only feasible for small L
    lv_patterns = {}
    for big_l, big_v in lv_pairs:
        if big_v < big_l + 1 or big_v >= 2 * big_l:
            continue  # skip if rho not in (1/4, 1/2)
        pats = []
        for combo in iter_product(range(1, big_v), repeat=big_l):
            if sum(combo) == big_v:
                pats.append(combo)
        if pats:
            lv_patterns[(big_l, big_v)] = pats

    e_members = []
    e_details = {}  # k -> list of (L, V, D, pat) tuples

    for k in range(37, 201):
        found_ghost = False
        for (big_l, big_v), pats in lv_patterns.items():
            if big_v >= k:
                continue
            d = 2**big_v - 3**big_l
            for pat in pats:
                exists, n1, _el = check_ghost_cycle(k, pat)
                if exists:
                    if not found_ghost:
                        e_members.append(k)
                        e_details[k] = []
                        found_ghost = True
                    e_details[k].append((big_l, big_v, d, pat))
                    break  # one ghost suffices to mark k ∈ E
            if found_ghost:
                break  # move to next k

    print(f"  E ∩ [37,200] (L<=8) = {e_members}")
    print(f"  |E ∩ [37,200]| = {len(e_members)}")
    if e_members:
        density = len(e_members) / 164
        print(f"  Density in [37,200] = {density:.3f}")
        # Show details for first few
        for k in e_members[:15]:
            details = e_details[k]
            cyc_l, v, d, pat = details[0]
            print(f"    k={k:3d}: L={cyc_l}, V={v}, D={d}, rho={2 ** (-v / cyc_l):.4f}")

        # Check periodicity
        print("\n  Gaps between consecutive E members:")
        gaps = [e_members[i + 1] - e_members[i] for i in range(min(20, len(e_members) - 1))]
        print(f"    {gaps}")
    print()
    return e_members


if __name__ == "__main__":
    results = {}

    results["D always odd"] = verify_d_always_odd()
    results["Denominator table"] = verify_denominator_table()
    results["ord_2 values"] = verify_ord2_values()
    results["K_0 bounds"] = verify_k0_bounds()
    results["Baker bound"] = verify_baker_bound()
    results["Cycle equation"] = verify_cycle_equation()
    verify_convergent_table()
    reappearances = scan_ghost_reappearance()

    # New: complete D=-601 scan and E membership
    d601_levels = scan_d601_complete()
    e_members = scan_e_membership()

    print("=" * 60)
    print("FINAL SUMMARY")
    print("=" * 60)
    for name, passed in results.items():
        print(f"  {name}: {'PASS' if passed else 'FAIL'}")
    if reappearances:
        print(f"  Ghost reappearance: FOUND at k={reappearances}")
    else:
        print("  Ghost reappearance: None found in k=37..178")
    print(f"  D=-601 ghost levels (k=3..150): {sorted(d601_levels.keys())}")
    print(f"  E ∩ [37,100] = {e_members}")
    print()
