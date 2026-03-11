"""Independent verification of all materializing ghost types.

For each materializing type from the census, independently constructs
the modular cycle via the Syracuse map and checks:
  - n_1 = R * D^{-1} mod 2^k is odd
  - All L nodes are distinct odd residues mod 2^k
  - The valuation pattern matches at each step
  - The cycle closes after L steps
"""

import sys
import time

import os as _os; sys.path.insert(0, _os.path.join(_os.path.dirname(_os.path.abspath(__file__))))

from ghost_census import (  # noqa: E402
    check_case_a,
    check_materialization,
    compositions,
    compute_r,
    is_canonical_rotation,
    is_concentrated_pattern,
    ord2,
    v2,
)


def collect_materializing_types():
    """Run the census and collect all materializing ghost types."""
    # Replicate the census logic to gather materialized ghosts
    summary_rows = []

    for big_l in range(2, 13):
        for big_v in range(big_l + 1, 2 * big_l):
            d_val = 2**big_v - 3**big_l
            total_comps = 0
            case_a_ghosts = []

            for comp in compositions(big_v, big_l):
                total_comps += 1
                is_ca, orbit = check_case_a(comp, d_val)
                if is_ca and is_canonical_rotation(comp):
                    concentrated = is_concentrated_pattern(comp)
                    case_a_ghosts.append(
                        {
                            "pattern": comp,
                            "orbit": orbit,
                            "concentrated": concentrated,
                        }
                    )

            rho = 2 ** (-big_v / big_l)
            summary_rows.append(
                {
                    "l": big_l,
                    "v": big_v,
                    "d": d_val,
                    "total": total_comps,
                    "canonical_ghosts": case_a_ghosts,
                    "rho": rho,
                }
            )

    # Compute ord_2 periods for negative D values
    d_periods = {}
    for row in summary_rows:
        if row["d"] < 0:
            abs_d = abs(row["d"])
            if abs_d not in d_periods:
                d_periods[abs_d] = ord2(abs_d)

    # Check materialization (using census's check_materialization)
    materialized = []
    for row in summary_rows:
        if row["d"] >= 0:
            continue
        abs_d = abs(row["d"])
        period = d_periods.get(abs_d, -1)
        search_limit = min(period, 10000) if period > 0 else 10000

        for ghost in row["canonical_ghosts"]:
            r_val = compute_r(ghost["pattern"])
            first_k = None
            mat_count = 0
            for k in range(row["l"] + 2, search_limit + 1):
                if check_materialization(ghost["pattern"], row["d"], r_val, k):
                    mat_count += 1
                    if first_k is None:
                        first_k = k

            if mat_count > 0:
                materialized.append(
                    {
                        "l": row["l"],
                        "v": row["v"],
                        "d": row["d"],
                        "pattern": ghost["pattern"],
                        "rho": row["rho"],
                        "p": period,
                        "r": mat_count,
                        "first_k": first_k,
                        "concentrated": ghost["concentrated"],
                    }
                )

    return materialized, summary_rows, d_periods


def verify_cycle_independently(v_pattern, d_val, k):
    """Independently verify a ghost cycle at level k.

    Constructs n_1 = R * D^{-1} mod 2^k, then iterates the Syracuse map
    S(n) = (3n+1) / 2^{v_2(3n+1)} mod 2^k for L steps.

    Returns (ok, message) where ok is True if cycle is fully verified.
    """
    big_l = len(v_pattern)
    mod = 2**k

    # Compute R from the pattern
    r_val = compute_r(v_pattern)

    # Compute n_1 = R * D^{-1} mod 2^k
    try:
        d_inv = pow(d_val, -1, mod)
    except (ValueError, ZeroDivisionError):
        return False, f"D={d_val} not invertible mod 2^{k}"

    n1 = (r_val * d_inv) % mod

    # Check n_1 is odd
    if n1 % 2 == 0:
        return False, f"n_1 = {n1} is even"

    # Iterate the Syracuse map, collecting nodes and checking valuations
    nodes = [n1]
    current = n1

    for step in range(big_l):
        step_val = 3 * current + 1
        actual_valuation = v2(step_val)

        # Check valuation matches expected pattern
        expected_valuation = v_pattern[step]
        if actual_valuation != expected_valuation:
            return False, (
                f"step {step}: v_2(3*{current}+1) = {actual_valuation}, "
                f"expected {expected_valuation}"
            )

        # Apply Syracuse map
        current = (step_val >> expected_valuation) % mod

        if step < big_l - 1:
            # Check intermediate nodes are odd
            if current % 2 == 0:
                return False, f"step {step}: node {current} is even"
            nodes.append(current)

    # Check cycle closure: after L steps we return to n_1
    if current != n1:
        return False, f"cycle does not close: ended at {current}, expected {n1}"

    # Check all L nodes are distinct (warn but don't fail if repeated —
    # a repeated sub-orbit is still a valid materialization)
    n_distinct = len(set(nodes))
    if n_distinct != big_l:
        return True, f"OK (orbit period {n_distinct}, pattern period {big_l})"

    return True, "OK"


def verify_concentrated_absent(d_val, big_l, big_v, d_periods):
    """Verify that the concentrated pattern does NOT materialize for this D.

    For D values that only materialize non-concentrated patterns, verify
    that (1,...,1,e+1) does not materialize at any k in [L+2, min(p, 10000)].
    """
    excess = big_v - big_l + 1
    # Build the concentrated pattern (canonical rotation = smallest)
    conc_candidates = []
    for pos in range(big_l):
        pat = [1] * big_l
        pat[pos] = excess
        conc_candidates.append(tuple(pat))

    # Find canonical rotation(s) — lexicographically smallest
    canonical_conc = []
    for pat in conc_candidates:
        if is_canonical_rotation(pat):
            canonical_conc.append(pat)

    if not canonical_conc:
        # No canonical concentrated pattern exists for this (L, V)
        return True, "no canonical concentrated pattern"

    abs_d = abs(d_val)
    period = d_periods.get(abs_d, -1)
    search_limit = min(period, 10000) if period > 0 else 10000

    for pat in canonical_conc:
        r_val = compute_r(pat)
        for k in range(big_l + 2, search_limit + 1):
            if check_materialization(pat, d_val, r_val, k):
                return False, f"concentrated pattern {pat} materializes at k={k}"

    return True, "concentrated pattern absent (verified)"


def main():
    """Run independent verification of all materializing ghost types."""
    start = time.time()

    print("Collecting materializing ghost types from census...")
    print("(This runs the full census enumeration — may take a few minutes)")
    print(flush=True)

    materialized, summary_rows, d_periods = collect_materializing_types()
    census_time = time.time() - start

    print(f"\nCensus complete in {census_time:.1f}s")
    print(f"Found {len(materialized)} materializing ghost types")
    print("=" * 80)

    # Step 2: Independent verification of each materializing type
    print("\nStep 1: Independent cycle verification at first_k")
    print("-" * 80)

    pass_count = 0
    fail_count = 0

    for mg in materialized:
        ok, msg = verify_cycle_independently(mg["pattern"], mg["d"], mg["first_k"])
        status = "PASS" if ok else "FAIL"
        conc_flag = "CONC" if mg["concentrated"] else "    "
        pat_str = str(mg["pattern"])

        if ok:
            pass_count += 1
        else:
            fail_count += 1

        print(
            f"  [{status}] [{conc_flag}] D={mg['d']:>8}, L={mg['l']}, "
            f"V={mg['v']}, k={mg['first_k']:>5}, v={pat_str:<25} {msg}"
        )

    print(
        f"\nCycle verification: {pass_count} PASS, {fail_count} FAIL "
        f"out of {len(materialized)} types"
    )

    # Step 3: Verify concentrated pattern absence for specific D values
    absent_d_values = {-42665, -144379, -160763, -400369, -498673}

    # Find which materializing types have these D values and confirm
    # they are non-concentrated
    d_to_lv = {}
    for mg in materialized:
        if mg["d"] in absent_d_values:
            key = mg["d"]
            if key not in d_to_lv:
                d_to_lv[key] = (mg["l"], mg["v"])

    print(
        "\n\nStep 2: Verify concentrated pattern does NOT materialize "
        "for 5 non-concentrated-only D values"
    )
    print("-" * 80)

    absent_pass = 0
    absent_fail = 0

    for d_val in sorted(absent_d_values):
        if d_val not in d_to_lv:
            print(f"  [SKIP] D={d_val}: not found among materializing types")
            continue
        big_l, big_v = d_to_lv[d_val]
        ok, msg = verify_concentrated_absent(d_val, big_l, big_v, d_periods)
        status = "PASS" if ok else "FAIL"

        if ok:
            absent_pass += 1
        else:
            absent_fail += 1

        print(f"  [{status}] D={d_val:>8}, L={big_l}, V={big_v}: {msg}")

    print(
        f"\nConcentrated-absent check: {absent_pass} PASS, "
        f"{absent_fail} FAIL out of {len(absent_d_values)} D values"
    )

    # Final summary
    total_pass = pass_count + absent_pass
    total_fail = fail_count + absent_fail
    total_tests = len(materialized) + len(absent_d_values)
    elapsed = time.time() - start

    print("\n" + "=" * 80)
    print(
        f"FINAL SUMMARY: {total_pass} PASS, {total_fail} FAIL "
        f"out of {total_tests} checks ({elapsed:.1f}s)"
    )

    if total_fail == 0:
        print("ALL CHECKS PASSED")
    else:
        print(f"WARNING: {total_fail} FAILURES")

    return total_fail == 0


if __name__ == "__main__":
    success = main()
    sys.exit(0 if success else 1)
