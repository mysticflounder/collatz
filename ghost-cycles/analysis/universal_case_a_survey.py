"""Universal case-(a) survey: check whether ALL compositions produce case-(a) ghosts.

Direction 3 from next-steps-2026-03-07.md.
For each (L, V) with 2 <= L <= 15 and L+1 <= V <= 2L-1, enumerate all compositions
of V into L parts (each >= 1) and check the case-(a) valuation condition.

For large composition counts (> 1M), uses random sampling.
"""

import random
import time
from math import comb


def compositions_gen(total, parts):
    """Generate all compositions of `total` into `parts` positive integers.

    Uses integer arithmetic only — avoids Fraction overhead.
    """
    if parts == 1:
        yield (total,)
        return
    for first in range(1, total - parts + 2):
        for rest in compositions_gen(total - first, parts - 1):
            yield (first,) + rest


def random_composition(total, parts, rng):
    """Generate a uniformly random composition of `total` into `parts` parts >= 1."""
    # Place (parts-1) dividers uniformly in [1, total-1]
    dividers = sorted(rng.sample(range(1, total), parts - 1))
    comp = []
    prev = 0
    for d in dividers:
        comp.append(d - prev)
        prev = d
    comp.append(total - prev)
    return tuple(comp)


def check_case_a_int(v_pattern, d_val):
    """Check case-(a) using pure integer arithmetic (no Fraction).

    The rational orbit n_tilde = R/D. We track numerator and denominator
    separately, checking 2-adic valuations of 3*num + den at each step.
    """
    big_l = len(v_pattern)

    # Compute R as integer
    r_val = 0
    s_val = 0
    for i in range(big_l):
        r_val += 3 ** (big_l - 1 - i) * (1 << s_val)
        s_val += v_pattern[i]

    # n_tilde = R / D. Track as num/den = R/D (don't reduce to save time)
    num = r_val
    den = d_val  # may be negative

    for i in range(big_l):
        # val = 3 * (num/den) + 1 = (3*num + den) / den
        val_num = 3 * num + den
        if val_num == 0:
            return False
        # v_2 of val = v_2(val_num) - v_2(den), but den = D is odd, so v_2(den) = 0
        actual_v = 0
        temp = abs(val_num)
        while temp % 2 == 0:
            actual_v += 1
            temp //= 2
        if actual_v != v_pattern[i]:
            return False
        # next = val / 2^v_i = val_num / (den * 2^v_i)
        # But we can simplify: num_new = val_num >> v_i, den stays the same
        num = val_num >> v_pattern[i]
        # den stays = d_val (always odd, no reduction needed)

    return True


def survey():
    """Run the universal case-(a) survey for L=2..15."""
    print("Universal Case-(a) Survey", flush=True)
    print("=" * 85, flush=True)
    print(
        f"{'L':>3} {'V':>3} {'D':>14} {'compositions':>13} "
        f"{'checked':>10} {'case_a':>10} {'fraction':>10} {'time':>8}",
        flush=True,
    )
    print("-" * 85, flush=True)

    all_case_a = True
    failures = []
    sample_limit = 1_000_000
    rng = random.Random(42)

    for big_l in range(2, 16):
        for big_v in range(big_l + 1, 2 * big_l):
            d_val = 2**big_v - 3**big_l
            total_comps = comb(big_v - 1, big_l - 1)

            t0 = time.time()
            case_a_count = 0
            checked = 0
            sampled = False
            first_failure = None

            if total_comps <= sample_limit:
                # Exhaustive
                for comp in compositions_gen(big_v, big_l):
                    checked += 1
                    if check_case_a_int(comp, d_val):
                        case_a_count += 1
                    elif first_failure is None:
                        first_failure = comp
            else:
                # Random sampling
                sampled = True
                for _ in range(sample_limit):
                    comp = random_composition(big_v, big_l, rng)
                    checked += 1
                    if check_case_a_int(comp, d_val):
                        case_a_count += 1
                    elif first_failure is None:
                        first_failure = comp

            elapsed = time.time() - t0
            frac = case_a_count / checked if checked > 0 else 0
            marker = ""
            if frac < 1.0:
                marker = " ***"
            if sampled:
                marker += " (sampled)"

            print(
                f"{big_l:>3} {big_v:>3} {d_val:>14} {total_comps:>13} "
                f"{checked:>10} {case_a_count:>10} {frac:>10.6f} {elapsed:>7.1f}s{marker}",
                flush=True,
            )

            if frac < 1.0:
                all_case_a = False
                failures.append((big_l, big_v, d_val, checked, case_a_count, first_failure))

    print("-" * 85, flush=True)
    if all_case_a:
        print("\nRESULT: ALL compositions are case-(a) for all tested (L, V).", flush=True)
    else:
        print(
            f"\nRESULT: {len(failures)} (L,V) pairs have non-case-(a) compositions:",
            flush=True,
        )
        for big_l, big_v, d_val, checked_n, ca, fail in failures:
            print(
                f"\n  L={big_l}, V={big_v}, D={d_val}: "
                f"{ca}/{checked_n} case-(a) ({ca / checked_n:.4f})",
                flush=True,
            )
            if fail:
                print(f"    First failure: {fail}", flush=True)


if __name__ == "__main__":
    survey()
