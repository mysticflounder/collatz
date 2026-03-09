"""Extended ghost census for L <= 12 across all (L, V) with rho > 1/4.

Direction 5 from next-steps-2026-03-07.md.
For each case-(a) ghost found, records orbit elements, signs,
materialization schedule, and structural properties.
"""

from fractions import Fraction
from itertools import combinations


def compositions(total, parts):
    """Generate all compositions of `total` into `parts` positive integers."""
    for dividers in combinations(range(1, total), parts - 1):
        comp = []
        prev = 0
        for d in dividers:
            comp.append(d - prev)
            prev = d
        comp.append(total - prev)
        yield tuple(comp)


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


def compute_r(v_pattern):
    """Compute R from the cycle equation."""
    big_l = len(v_pattern)
    r_val = 0
    s_val = 0
    for i in range(big_l):
        r_val += 3 ** (big_l - 1 - i) * 2**s_val
        s_val += v_pattern[i]
    return r_val


def check_case_a(v_pattern, d_val):
    """Check case-(a) and return orbit if valid."""
    big_l = len(v_pattern)
    r_val = compute_r(v_pattern)
    n_tilde = Fraction(r_val, d_val)
    current = n_tilde
    orbit = [current]

    for i in range(big_l):
        val = 3 * current + 1
        num = val.numerator
        if num == 0:
            return False, []
        actual_v = v2(num)
        if actual_v != v_pattern[i]:
            return False, []
        current = val / 2 ** v_pattern[i]
        if i < big_l - 1:
            orbit.append(current)

    return True, orbit


def ord2(n):
    """Compute the multiplicative order of 2 modulo n."""
    n = abs(n)
    if n == 1:
        return 1
    result = 1
    power = 2 % n
    while power != 1:
        power = (power * 2) % n
        result += 1
        if result > 1_000_000:
            return -1  # too large, return sentinel
    return result


def is_canonical_rotation(v_pattern):
    """Check if v_pattern is the lexicographically smallest rotation."""
    pat = list(v_pattern)
    big_l = len(pat)
    for i in range(1, big_l):
        rotated = pat[i:] + pat[:i]
        if tuple(rotated) < tuple(pat):
            return False
    return True


def is_concentrated_pattern(v_pattern):
    """Check if pattern is (1,...,1,excess) up to rotation."""
    big_l = len(v_pattern)
    big_v = sum(v_pattern)
    excess = big_v - big_l + 1
    # Check if exactly one entry equals excess and rest are 1
    target = [1] * big_l
    for pos in range(big_l):
        candidate = target[:]
        candidate[pos] = excess
        # Check all rotations
        for rot in range(big_l):
            rotated = tuple(candidate[rot:] + candidate[:rot])
            if rotated == v_pattern:
                return True
    return False


def check_materialization(v_pattern, d_val, r_val, k):
    """Check if ghost materializes at level k."""
    big_l = len(v_pattern)
    mod = 2**k
    try:
        d_inv = pow(d_val, -1, mod)
    except (ValueError, ZeroDivisionError):
        return False
    n1 = (r_val * d_inv) % mod
    if n1 % 2 == 0:
        return False
    current = n1
    for i in range(big_l):
        step_val = 3 * current + 1
        actual = v2(step_val)
        if actual != v_pattern[i]:
            return False
        current = (step_val // 2 ** v_pattern[i]) % mod
    return current == n1


def census():
    """Run the ghost census for L=2..12."""
    print("Extended Ghost Census: L=2..12, V < 2L")
    print("=" * 90)

    summary_rows = []

    for big_l in range(2, 13):
        for big_v in range(big_l + 1, 2 * big_l):
            d_val = 2**big_v - 3**big_l
            abs_d = abs(d_val)
            rho = 2 ** (-big_v / big_l)
            total_comps = 0
            case_a_count = 0
            case_a_ghosts = []

            for comp in compositions(big_v, big_l):
                total_comps += 1
                is_ca, orbit = check_case_a(comp, d_val)
                if is_ca:
                    case_a_count += 1
                    # Only record canonical rotations to avoid duplicates
                    if is_canonical_rotation(comp):
                        all_signs_negative = all(x < 0 for x in orbit)
                        concentrated = is_concentrated_pattern(comp)
                        case_a_ghosts.append(
                            {
                                "pattern": comp,
                                "orbit": orbit,
                                "all_negative": all_signs_negative,
                                "concentrated": concentrated,
                            }
                        )

            summary_rows.append(
                {
                    "l": big_l,
                    "v": big_v,
                    "d": d_val,
                    "total": total_comps,
                    "case_a": case_a_count,
                    "canonical_ghosts": case_a_ghosts,
                    "rho": rho,
                }
            )

    # Print summary table
    print(
        f"\n{'L':>3} {'V':>3} {'D':>12} {'comps':>8} {'case_a':>8} "
        f"{'frac':>8} {'canon':>6} {'rho':>8}",
        flush=True,
    )
    print("-" * 70, flush=True)
    for row in summary_rows:
        frac = row["case_a"] / row["total"] if row["total"] > 0 else 0
        n_canon = len(row["canonical_ghosts"])
        print(
            f"{row['l']:>3} {row['v']:>3} {row['d']:>12} {row['total']:>8} "
            f"{row['case_a']:>8} {frac:>8.4f} {n_canon:>6} {row['rho']:>8.4f}",
            flush=True,
        )

    # Detailed ghost table — only concentrated patterns with D < 0 get materialization check
    print("\n\nDetailed Ghost Catalog (concentrated patterns, D < 0)", flush=True)
    print("=" * 90, flush=True)

    # Compute ord_2 for unique |D| values (only negative D)
    d_periods = {}
    for row in summary_rows:
        if row["d"] < 0:
            abs_d = abs(row["d"])
            if abs_d not in d_periods:
                p = ord2(abs_d)
                d_periods[abs_d] = p

    total_ghosts = 0
    all_negative_count = 0
    concentrated_count = 0
    non_concentrated = []
    materialized_ghosts = []

    for row in summary_rows:
        for ghost in row["canonical_ghosts"]:
            total_ghosts += 1

            if ghost["all_negative"]:
                all_negative_count += 1
            if ghost["concentrated"]:
                concentrated_count += 1
            else:
                non_concentrated.append((row["l"], row["v"], ghost["pattern"]))

            # Only check materialization for concentrated patterns with D < 0
            if ghost["concentrated"] and row["d"] < 0:
                abs_d = abs(row["d"])
                p = d_periods.get(abs_d, -1)
                r_val = compute_r(ghost["pattern"])
                materializations = []
                search_limit = min(p, 10000) if p > 0 else 10000
                for k in range(row["l"] + 2, search_limit + 1):
                    if check_materialization(ghost["pattern"], row["d"], r_val, k):
                        materializations.append(k)

                r_count = len(materializations)
                first_k = materializations[0] if materializations else "---"

                pat_str = str(ghost["pattern"])
                print(
                    f"  L={row['l']}, V={row['v']}, D={row['d']:>8}, "
                    f"v={pat_str:<25} rho={row['rho']:.4f}, "
                    f"p={p:>8}, r={r_count:>3}, first_k={str(first_k):>6}",
                    flush=True,
                )

                if r_count > 0:
                    materialized_ghosts.append(
                        {
                            "l": row["l"],
                            "v": row["v"],
                            "d": row["d"],
                            "pattern": ghost["pattern"],
                            "rho": row["rho"],
                            "p": p,
                            "r": r_count,
                            "first_k": first_k,
                        }
                    )

    # Structural summary
    print("\n\nStructural Summary", flush=True)
    print("=" * 60, flush=True)
    print(f"Total canonical case-(a) ghosts found: {total_ghosts}", flush=True)
    print(
        f"All orbit elements negative (D<0 only): {all_negative_count}/{total_ghosts}", flush=True
    )
    d_neg_count = sum(1 for row in summary_rows if row["d"] < 0 for g in row["canonical_ghosts"])
    d_neg_neg = sum(
        1
        for row in summary_rows
        if row["d"] < 0
        for g in row["canonical_ghosts"]
        if g["all_negative"]
    )
    print(f"  (Among D<0 ghosts: {d_neg_neg}/{d_neg_count})", flush=True)
    print(f"Concentrated pattern (1,...,1,excess): {concentrated_count}/{total_ghosts}", flush=True)
    if non_concentrated:
        print(f"\nNon-concentrated patterns ({len(non_concentrated)} total):", flush=True)
        for big_l, big_v, pat in non_concentrated[:20]:
            print(f"  L={big_l}, V={big_v}: {pat}", flush=True)
        if len(non_concentrated) > 20:
            print(f"  ... and {len(non_concentrated) - 20} more", flush=True)

    # Materializing ghosts summary
    if materialized_ghosts:
        print(
            f"\nMaterializing ghost types (D<0, concentrated): {len(materialized_ghosts)}",
            flush=True,
        )
        for mg in materialized_ghosts:
            print(
                f"  D={mg['d']}, L={mg['l']}, V={mg['v']}, "
                f"rho={mg['rho']:.4f}, p={mg['p']}, r={mg['r']}, "
                f"first_k={mg['first_k']}",
                flush=True,
            )


if __name__ == "__main__":
    census()
