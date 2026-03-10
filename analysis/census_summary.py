"""Census summary: markdown table of materializing ghost types grouped by D.

Runs the same materialization search as ghost_census.py and outputs
a markdown table suitable for pasting into Paper A.
"""

import random
import sys
from collections import defaultdict

sys.path.insert(0, "analysis")

from ghost_census import (
    check_case_a,
    check_materialization,
    compositions,
    compute_r,
    is_canonical_rotation,
    is_concentrated_pattern,
    ord2,
)


def run_census():
    """Run ghost census and return list of materializing ghost dicts."""
    summary_rows = []

    for big_l in range(2, 13):
        for big_v in range(big_l + 1, 2 * big_l):
            d_val = 2**big_v - 3**big_l
            rho = 2 ** (-big_v / big_l)
            case_a_ghosts = []

            for comp in compositions(big_v, big_l):
                is_ca, orbit = check_case_a(comp, d_val)
                if is_ca and is_canonical_rotation(comp):
                    concentrated = is_concentrated_pattern(comp)
                    case_a_ghosts.append(
                        {
                            "pattern": comp,
                            "concentrated": concentrated,
                        }
                    )

            summary_rows.append(
                {
                    "l": big_l,
                    "v": big_v,
                    "d": d_val,
                    "canonical_ghosts": case_a_ghosts,
                    "rho": rho,
                }
            )

    # Compute ord_2 for unique |D| values (only negative D)
    d_periods = {}
    for row in summary_rows:
        if row["d"] < 0:
            abs_d = abs(row["d"])
            if abs_d not in d_periods:
                d_periods[abs_d] = ord2(abs_d)

    # Check materialization for all canonical D < 0 patterns
    max_patterns_per_lv = 200
    materialized = []

    for row in summary_rows:
        if row["d"] >= 0:
            continue
        abs_d = abs(row["d"])
        p = d_periods.get(abs_d, -1)
        search_limit = min(p, 10000) if p > 0 else 10000

        ghosts_to_check = row["canonical_ghosts"]
        if len(ghosts_to_check) > max_patterns_per_lv:
            random.seed(row["d"])
            ghosts_to_check = random.sample(ghosts_to_check, max_patterns_per_lv)

        for ghost in ghosts_to_check:
            r_val = compute_r(ghost["pattern"])
            mat_levels = []
            for k in range(row["l"] + 2, search_limit + 1):
                if check_materialization(ghost["pattern"], row["d"], r_val, k):
                    mat_levels.append(k)

            if mat_levels:
                materialized.append(
                    {
                        "l": row["l"],
                        "v": row["v"],
                        "d": row["d"],
                        "rho": row["rho"],
                        "p": p,
                        "r": len(mat_levels),
                        "first_k": mat_levels[0],
                        "concentrated": ghost["concentrated"],
                    }
                )

    return materialized


def build_summary_table(materialized):
    """Build per-D summary rows from list of materializing ghosts."""
    by_d = defaultdict(list)
    for mg in materialized:
        by_d[mg["d"]].append(mg)

    rows = []
    for d_val in sorted(by_d, key=lambda x: abs(x)):
        entries = by_d[d_val]
        # All entries for one D share L, V, rho, p
        big_l = entries[0]["l"]
        big_v = entries[0]["v"]
        excess = big_v - big_l
        rho = entries[0]["rho"]
        p = entries[0]["p"]
        r_conc = sum(1 for e in entries if e["concentrated"])
        r_nonc = sum(1 for e in entries if not e["concentrated"])
        first_k = min(e["first_k"] for e in entries)

        rows.append(
            {
                "d": d_val,
                "l": big_l,
                "v": big_v,
                "e": excess,
                "rho": rho,
                "p": p,
                "r_conc": r_conc,
                "r_nonc": r_nonc,
                "first_k": first_k,
            }
        )

    return rows


def print_markdown_table(rows, materialized):
    """Print markdown summary table and statistics."""
    print("## Materializing Ghost Types by D (L <= 12)\n")
    print("| D | L | V | e | rho | p | r_conc | r_nonc | first_k |")
    print("|---:|---:|---:|---:|---:|---:|---:|---:|---:|")
    for row in rows:
        print(
            f"| {row['d']} "
            f"| {row['l']} "
            f"| {row['v']} "
            f"| {row['e']} "
            f"| {row['rho']:.4f} "
            f"| {row['p']} "
            f"| {row['r_conc']} "
            f"| {row['r_nonc']} "
            f"| {row['first_k']} |"
        )

    total = len(materialized)
    nonc_only_ds = [r for r in rows if r["r_conc"] == 0]
    nonc_only_count = len(nonc_only_ds)

    print(f"\n**Total materializing types**: {total}")
    print(f"**D values with only non-concentrated materializations**: {nonc_only_count}")
    if nonc_only_ds:
        d_list = ", ".join(str(r["d"]) for r in nonc_only_ds[:5])
        print(f"**Non-concentrated-only D values**: {d_list}")


def main():
    """Run census and print markdown summary."""
    print("Running ghost census...", file=sys.stderr)
    materialized = run_census()
    print(
        f"Found {len(materialized)} materializing types.",
        file=sys.stderr,
    )

    rows = build_summary_table(materialized)
    print_markdown_table(rows, materialized)


if __name__ == "__main__":
    main()
