"""
Validation of Theorem: Conjecture 4 for Concentrated Patterns.

Verifies the closed-form formula R_i = 2^{L-i+1}(2^e-1)*3^{i-1} + (3^L - 2^{L+e})
against the recurrence, checks positivity, orbit closure, and case-(a) for all
concentrated patterns with L=2..15 and valid e.
"""

import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

import matplotlib

matplotlib.use("Agg")


def orbit_via_recurrence(L, e):
    """Compute R_i via the recurrence for concentrated pattern."""
    D = 2 ** (L + e) - 3**L
    R = [None] * (L + 1)  # 1-indexed, R[1]..R[L]
    R[1] = 3**L - 2**L
    for i in range(1, L):
        R[i + 1] = (3 * R[i] + D) // 2
    return R, D


def orbit_via_formula(L, e):
    """Compute R_i via the closed-form formula."""
    D = 2 ** (L + e) - 3**L
    R = [None] * (L + 1)
    for i in range(1, L + 1):
        R[i] = 2 ** (L - i + 1) * (2**e - 1) * 3 ** (i - 1) + (3**L - 2 ** (L + e))
    return R, D


def check_case_a(R, D, L, e):
    """Check case-(a): v_2(3*R_i + D) = v_i for all i."""
    errors = []
    for i in range(1, L + 1):
        val = 3 * R[i] + D
        v_i = 1 if i < L else e + 1
        # compute 2-adic valuation
        if val == 0:
            errors.append(f"  i={i}: 3*R_i + D = 0 (unexpected)")
            continue
        v2 = 0
        tmp = abs(val)
        while tmp % 2 == 0:
            v2 += 1
            tmp //= 2
        if v2 != v_i:
            errors.append(f"  i={i}: v_2(3*R_{i}+D)={v2}, expected v_i={v_i}")
    return errors


def check_orbit_closure(R, D, L, e):
    """Check (3*R_L + D) / 2^{e+1} == R_1."""
    numerator = 3 * R[L] + D
    if numerator % 2 ** (e + 1) != 0:
        return f"  Closure FAIL: 3*R_L+D={numerator} not divisible by 2^{e + 1}={2 ** (e + 1)}"
    result = numerator // 2 ** (e + 1)
    if result != R[1]:
        return f"  Closure FAIL: (3*R_L+D)/2^{{e+1}}={result}, R_1={R[1]}"
    return None


def main():
    print("=" * 70)
    print("Validating Theorem: Conjecture 4 for Concentrated Patterns")
    print("=" * 70)
    print()

    total_patterns = 0
    total_failures = 0
    import math

    log23 = math.log2(3) - 1  # ≈ 0.585

    for L in range(2, 16):
        e_max = int(L * log23)  # e must satisfy D < 0, i.e., e < L*(log2(3)-1)
        for e in range(1, e_max + 1):
            D = 2 ** (L + e) - 3**L
            if D >= 0:
                continue  # skip D >= 0

            total_patterns += 1
            R_rec, D_rec = orbit_via_recurrence(L, e)
            R_form, D_form = orbit_via_formula(L, e)

            failures = []

            # 1. Formula matches recurrence
            for i in range(1, L + 1):
                if R_rec[i] != R_form[i]:
                    failures.append(
                        f"  Formula mismatch at i={i}: recurrence={R_rec[i]}, formula={R_form[i]}"
                    )

            # 2. Positivity: R_i > 0 for all i
            for i in range(1, L + 1):
                if R_form[i] <= 0:
                    failures.append(f"  Positivity FAIL: R_{i}={R_form[i]} <= 0")

            # 3. Orbit closure
            closure_err = check_orbit_closure(R_rec, D_rec, L, e)
            if closure_err:
                failures.append(closure_err)

            # 4. Case-(a)
            case_a_errors = check_case_a(R_rec, D_rec, L, e)
            failures.extend(case_a_errors)

            if failures:
                total_failures += 1
                print(f"FAIL L={L}, e={e}, D={D}:")
                for f in failures:
                    print(f)
            else:
                print(
                    f"  PASS L={L:2d}, e={e}, D={D:10d}, "
                    f"min(R_i)={min(R_rec[i] for i in range(1, L + 1))}"
                )

    print()
    print("=" * 70)
    print(f"Total patterns tested: {total_patterns}")
    print(f"Failures: {total_failures}")
    if total_failures == 0:
        print("ALL PASS: Theorem verified computationally for L=2..15.")
    else:
        print(f"FAILURES FOUND: {total_failures}")
    print("=" * 70)

    # Print the appendix examples explicitly
    print()
    print("Appendix verification (from proof document):")
    for L, e in [(2, 1), (5, 1), (6, 1)]:
        R, D = orbit_via_formula(L, e)
        print(f"\n  L={L}, e={e}, D={D}:")
        for i in range(1, L + 1):
            print(f"    R_{i} = {R[i]}")
        print(f"    All R_i > 0: {all(R[i] > 0 for i in range(1, L + 1))}")


if __name__ == "__main__":
    main()
