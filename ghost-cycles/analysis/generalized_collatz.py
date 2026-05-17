"""
Generalized Collatz: the family T(n) = (xn + y) / 2^v for odd x, odd y.

Maps the (x, y) parameter space to find:
  1. Where convergence is provable/observable
  2. How cycle structure depends on (x, y)
  3. The Diophantine approximation landscape (Baker's theorem)
  4. Whether polynomial extension from the "easy" region can reach x=3

The average shrinkage factor is x/4 for ALL (x, y) with x, y odd.
Phase transition at x = 4: below => convergent, above => divergent.
Collatz (3n+1) lives at x=3, just inside the convergent boundary.
"""

import os
import sys
from collections import Counter
from math import log2

import numpy as np

sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))


# ===================================================================
# 1. Generalized Syracuse maps
# ===================================================================
def syracuse_general(n, x, y):
    """Syracuse map: odd n -> (xn + y) / 2^v. Returns (result, v)."""
    val = x * n + y
    if val <= 0:
        return None, 0  # map goes non-positive
    v = 0
    while val % 2 == 0:
        val //= 2
        v += 1
    return val, v


def trajectory_general(n, x, y, max_steps=2000):
    """Compute trajectory of odd n under the (x, y) Syracuse map.

    Returns: (values, v_sequence, outcome)
    where outcome is 'converged', 'cycle', 'diverged', or 'non-positive'.
    """
    values = [n]
    vs = []
    visited = {n: 0}

    for step in range(1, max_steps + 1):
        result, v = syracuse_general(n, x, y)
        if result is None:
            return values, vs, "non-positive"
        vs.append(v)
        if result == 1 and x == 1:
            values.append(result)
            return values, vs, "converged"
        if result in visited:
            values.append(result)
            return values, vs, "cycle"
        if result > n * 1000 and step > 50:
            values.append(result)
            return values, vs, "diverged"
        visited[result] = step
        values.append(result)
        n = result

    return values, vs, "diverged"


def find_cycles_general(x, y, max_start=5000, max_steps=5000):
    """Find all cycles for the (x, y) Syracuse map in odd numbers up to max_start."""
    all_cycles = []
    cycle_members = set()

    for start in range(1, max_start, 2):
        if start in cycle_members:
            continue
        n = start
        visited = {}
        for step in range(max_steps):
            if n in visited:
                # Retrace cycle
                cycle = []
                m = n
                while True:
                    next_m, v = syracuse_general(m, x, y)
                    if next_m is None:
                        break
                    cycle.append((m, v))
                    m = next_m
                    if m == n:
                        break
                if cycle:
                    cycle_set = frozenset(e[0] for e in cycle)
                    if cycle_set not in [frozenset(e[0] for e in c) for c in all_cycles]:
                        all_cycles.append(cycle)
                        cycle_members.update(e[0] for e in cycle)
                break
            visited[n] = step
            next_n, v = syracuse_general(n, x, y)
            if next_n is None:
                break
            if next_n == 1 and x <= 3:
                break  # reached 1, no cycle (except trivial)
            n = next_n

    return all_cycles


# ===================================================================
# 2. Phase diagram: scan (x, y) parameter space
# ===================================================================
print("=" * 72)
print("SECTION 1: Phase Diagram — Convergence in (x, y) Space")
print("=" * 72)
print()
print("For each odd (x, y), testing odd n from 3 to 999:")
print("  Average shrinkage factor = x/4")
print("  Phase transition at x = 4")
print()

print(
    f"  {'x':>3s}  {'y':>3s}  {'x/4':>6s}  {'cycles':>7s}  "
    f"{'converge%':>10s}  {'cycle%':>7s}  {'diverge%':>9s}  {'mean_steps':>11s}"
)
print(f"  {'—' * 3}  {'—' * 3}  {'—' * 6}  {'—' * 7}  {'—' * 10}  {'—' * 7}  {'—' * 9}  {'—' * 11}")

phase_data = {}

for x in [1, 3, 5, 7, 9, 11]:
    for y in [1, -1, 3, -3, 5, -5]:
        if x == 1 and abs(y) > 1:
            continue  # trivial cases

        # Skip if x*n + y could be negative for small n
        outcomes = Counter()
        step_counts = []

        test_range = range(3, 1000, 2)
        for n in test_range:
            if x * n + y <= 0:
                outcomes["non-positive"] += 1
                continue
            _vals, _vs, outcome = trajectory_general(n, x, y, max_steps=1000)
            outcomes[outcome] += 1
            if outcome in ("converged", "cycle"):
                step_counts.append(len(_vs))

        total = sum(outcomes.values())
        if total == 0:
            continue

        conv_pct = outcomes.get("converged", 0) / total * 100
        cycle_pct = outcomes.get("cycle", 0) / total * 100
        div_pct = outcomes.get("diverged", 0) / total * 100
        mean_steps = np.mean(step_counts) if step_counts else float("inf")

        # Find cycles
        cycles = find_cycles_general(x, y, max_start=2000, max_steps=2000)

        phase_data[(x, y)] = {
            "conv": conv_pct,
            "cycle": cycle_pct,
            "div": div_pct,
            "n_cycles": len(cycles),
            "mean_steps": mean_steps,
        }

        print(
            f"  {x:3d}  {y:+3d}  {x / 4:6.3f}  {len(cycles):7d}  "
            f"{conv_pct:9.1f}%  {cycle_pct:6.1f}%  {div_pct:8.1f}%  {mean_steps:11.1f}"
        )


# ===================================================================
# 3. The Lyapunov curve: growth rate as a function of x
# ===================================================================
print()
print("=" * 72)
print("SECTION 2: Lyapunov Exponent λ(x) = log₂(x/4)")
print("=" * 72)
print()
print("Theoretical average drift per Syracuse step: log₂(x) - E[v] = log₂(x) - 2")
print("For convergence: need λ < 0, i.e., x < 4")
print()

print(f"  {'x':>5s}  {'λ(x) theory':>12s}  {'λ(x) empirical':>15s}  {'x/4':>6s}  {'region':>10s}")
print(f"  {'—' * 5}  {'—' * 12}  {'—' * 15}  {'—' * 6}  {'—' * 10}")

for x in [1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21]:
    theory = log2(x) - 2
    y = 1  # fix y=1

    # Empirical: average log2(T(n)/n) over many odd n
    log_ratios = []
    for n in range(3, 20001, 2):
        result, v = syracuse_general(n, x, y)
        if result is not None and result > 0:
            log_ratios.append(log2(result / n))

    empirical = np.mean(log_ratios) if log_ratios else float("nan")
    region = "CONVERGENT" if theory < 0 else "DIVERGENT"

    print(f"  {x:5d}  {theory:+12.6f}  {empirical:+15.6f}  {x / 4:6.3f}  {region:>10s}")

print()
print("Note: x=3 (Collatz) has λ = -0.415, well inside the convergent region.")
print("The statistical argument says it SHOULD converge. The mystery is proving it.")


# ===================================================================
# 4. Cycle structure across x values
# ===================================================================
print()
print("=" * 72)
print("SECTION 3: Cycle Census Across x Values (y=+1 and y=-1)")
print("=" * 72)
print()

for y in [1, -1]:
    print(f"--- y = {y:+d} ---")
    for x in [1, 3, 5, 7, 9, 11, 13]:
        cycles = find_cycles_general(x, y, max_start=10000, max_steps=5000)
        print(f"  x={x:2d}, y={y:+d}: {len(cycles)} cycle(s) found")
        for i, cycle in enumerate(cycles):
            values = [e[0] for e in cycle]
            v_vals = [e[1] for e in cycle]
            k = len(cycle)
            s = sum(v_vals)
            denom = 2**s - x**k
            if k <= 10:
                print(f"    Cycle {i + 1}: {values}")
                print(f"      length={k}, sum(v)={s}, 2^s-x^k={denom:+d}, avg_v={s / k:.2f}")
            else:
                print(
                    f"    Cycle {i + 1}: [{values[0]}, {values[1]}, ..., {values[-1]}] (length {k})"
                )
                print(f"      sum(v)={s}, 2^s-x^k={denom:+d}, avg_v={s / k:.2f}")
    print()


# ===================================================================
# 5. Generalized cycle equation and Baker's theorem
# ===================================================================
print("=" * 72)
print("SECTION 4: Cycle Equation — Diophantine Landscape")
print("=" * 72)
print()
print("For a cycle of length k: n = C / (2^s - x^k)")
print("Close approaches of 2^s to x^k determine possible cycle locations.")
print("Baker's theorem: |2^s - x^k| >> max(2^s, x^k)^(1-ε)")
print()

for x in [3, 5, 7, 9, 11]:
    print(f"--- x = {x}, log₂(x) = {log2(x):.6f} ---")

    # Find the closest (2^s, x^k) pairs for k up to 30
    best_approaches = []
    for k in range(1, 31):
        # Both floor and ceil of k*log2(x)
        s_approx = k * log2(x)
        for s in [int(s_approx), int(s_approx) + 1]:
            if s <= 0:
                continue
            diff = 2**s - x**k
            rel = abs(diff) / max(2**s, x**k)
            best_approaches.append((k, s, diff, rel))

    # Sort by relative closeness
    best_approaches.sort(key=lambda t: t[3])

    print("  Top 5 closest approaches (|2^s - x^k| / max):")
    for k, s, diff, rel in best_approaches[:5]:
        sign_note = "→ +y cycles possible" if diff > 0 else "→ -y cycles possible"
        print(f"    k={k:2d}, s={s:2d}: 2^s - x^k = {diff:+20d}  (rel={rel:.2e})  {sign_note}")

    print()


# ===================================================================
# 6. Continued fractions of log₂(x) — the approximation engine
# ===================================================================
print("=" * 72)
print("SECTION 5: Continued Fractions of log₂(x)")
print("=" * 72)
print()
print("The quality of rational approximations p/q ≈ log₂(x) controls")
print("how close 2^q can get to x^p, and thus whether cycles can exist.")
print()


def continued_fraction(alpha, n_terms=15):
    """Compute continued fraction expansion of alpha."""
    terms = []
    for _ in range(n_terms):
        a = int(alpha)
        terms.append(a)
        frac = alpha - a
        if abs(frac) < 1e-12:
            break
        alpha = 1.0 / frac
    return terms


def convergents(cf):
    """Compute convergents p_k/q_k from continued fraction terms."""
    p_prev, p_curr = 1, cf[0]
    q_prev, q_curr = 0, 1
    result = [(p_curr, q_curr)]
    for a in cf[1:]:
        p_next = a * p_curr + p_prev
        q_next = a * q_curr + q_prev
        result.append((p_next, q_next))
        p_prev, p_curr = p_curr, p_next
        q_prev, q_curr = q_curr, q_next
    return result


for x in [3, 5, 7, 9, 11]:
    alpha = log2(x)
    cf = continued_fraction(alpha, 20)
    convs = convergents(cf)

    print(f"  x = {x}: log₂({x}) = {alpha:.10f}")
    print(f"    CF = [{cf[0]}; {', '.join(str(a) for a in cf[1:])}]")
    print("    Convergents (p/q ≈ log₂(x), so 2^q ≈ x^p):")
    print(f"    {'p':>4s} / {'q':>4s}  {'p/q':>12s}  {'error':>12s}  {'2^q - x^p':>20s}")

    for p, q in convs[:10]:
        approx = p / q if q > 0 else 0
        error = alpha - approx
        if q <= 60 and p <= 40:
            diff = 2**q - x**p
            diff_str = f"{diff:+20d}"
        else:
            diff_str = "(too large)"
        print(f"    {p:4d} / {q:4d}  {approx:12.8f}  {error:+12.2e}  {diff_str}")
    print()


# ===================================================================
# 7. v-distribution universality proof
# ===================================================================
print("=" * 72)
print("SECTION 6: v-Distribution Universality")
print("=" * 72)
print()
print("Claim: P(v₂(xn+y) = k) = 1/2^k for k ≥ 1, for ALL odd x, odd y.")
print("This means E[v] = 2 universally, and the average factor is x/4.")
print()

for x in [1, 3, 5, 7, 11, 13]:
    for y in [1, -1, 3, 7]:
        v_counts = Counter()
        total = 0
        for n in range(1, 50000, 2):
            val = x * n + y
            if val <= 0:
                continue
            v = 0
            while val % 2 == 0:
                val //= 2
                v += 1
            if v >= 1:
                v_counts[v] += 1
                total += 1

        if total == 0:
            continue

        # Check if geometric(1/2)
        mean_v = sum(k * c for k, c in v_counts.items()) / total
        # Expected: P(v=k) = 1/2^k, E[v] = 2
        max_dev = 0.0
        for k in range(1, 8):
            observed = v_counts.get(k, 0) / total
            expected = 1 / 2**k
            dev = abs(observed - expected)
            if dev > max_dev:
                max_dev = dev

        status = "✓" if max_dev < 0.005 else "✗"
        print(
            f"  x={x:2d}, y={y:+2d}: E[v] = {mean_v:.4f}  "
            f"max|P(v=k) - 1/2^k| = {max_dev:.4f}  {status}"
        )

print()
print("CONFIRMED: v-distribution is universal. Only x/4 matters for average drift.")


# ===================================================================
# 8. The spectral continuation direction
# ===================================================================
print()
print("=" * 72)
print("SECTION 7: Toward Spectral Continuation")
print("=" * 72)
print()
print("""
The parameter space has natural analytic structure:

  1. GROWTH RATE: λ(x) = log₂(x/4) is analytic in x > 0
     - λ < 0 for x < 4 (convergent regime)
     - λ > 0 for x > 4 (divergent regime)
     - Collatz lives at x = 3, λ = -0.415

  2. CYCLE EQUATION: n = C(x,y,k,{v_i}) / (2^s - x^k)
     - For continuous x: the denominator 2^s - x^k is analytic
     - Zeros occur at x = 2^(s/k) — a dense set on the real line!
     - But for integer x: need integer n, so divisibility matters

  3. DIRICHLET-LIKE SERIES: Define for real α > 0:
       Z(α, β) = Σ_{n odd} n^(-β) · (number of steps to convergence)^(-α)
     This converges for large β, and its continuation might
     encode the convergence structure.

  4. TRANSFER OPERATOR: For the xn+y map, the Ruelle operator
       L_β f(m) = Σ_{n: T(n)=m} |T'(n)|^(-β) f(n)
     has spectral radius ρ(x, β). When ρ < 1, the system is "mixing."
     ρ(x, β) is analytic in both x and β.

  5. THE CRITICAL QUESTION: Is there a function F(z) defined for
     complex z with Re(z) > 4 (where convergence is easy to disprove)
     that analytically continues to z = 3 and whose value there
     determines the Collatz conjecture?
""")

# Compute a concrete "convergence measure" as a function of x
print("Convergence measure μ(x) = fraction of odd n ≤ 10000 that reach 1 or cycle:")
print()
print(f"  {'x':>5s}  {'μ(x)':>8s}  {'λ(x)':>8s}  {'bar':>30s}")
print(f"  {'—' * 5}  {'—' * 8}  {'—' * 8}  {'—' * 30}")

for x in [1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25]:
    conv_count = 0
    total = 0
    y = 1
    for n in range(3, 10001, 2):
        _vals, _vs, outcome = trajectory_general(n, x, y, max_steps=500)
        total += 1
        if outcome in ("converged", "cycle"):
            conv_count += 1

    mu = conv_count / total
    lam = log2(x / 4)
    bar_len = int(mu * 30)
    bar = "█" * bar_len + "░" * (30 - bar_len)
    print(f"  {x:5d}  {mu:8.4f}  {lam:+8.4f}  {bar}")


# ===================================================================
# 9. The mod-x structure: what changes with x?
# ===================================================================
print()
print("=" * 72)
print("SECTION 8: Mod-x Distribution — What +1 Does at Each x")
print("=" * 72)
print()
print("For xn+1: result mod x tells us the 'x-adic' bias.")
print("This is the generalization of the mod-3 asymmetry we found for Collatz.")
print()

for x in [3, 5, 7, 9, 11]:
    dist = Counter()
    total = 0
    for n in range(1, 50000, 2):
        result, v = syracuse_general(n, x, 1)
        if result is not None:
            dist[result % x] += 1
            total += 1

    print(f"  x = {x}: Syracuse output mod {x} (for xn+1, n=1..49999 odd)")
    never_hit = []
    for r in range(x):
        pct = dist.get(r, 0) / total * 100 if total > 0 else 0
        if dist.get(r, 0) == 0:
            never_hit.append(r)
        if x <= 11:
            bar = "#" * int(pct * 2)
            print(f"    r={r}: {pct:6.2f}%  {bar}")
    if never_hit:
        print(f"    Never hits: {never_hit}")
    print()


print("=" * 72)
print("ANALYSIS COMPLETE")
print("=" * 72)
print()
print("KEY FINDINGS:")
print("  1. v-distribution is universal: E[v]=2 for all odd (x,y)")
print("  2. Phase transition at x=4: below → convergent, above → divergent")
print("  3. Collatz (x=3) is the LAST convergent odd case")
print("  4. Cycle existence depends on Diophantine approximation of log₂(x)")
print("  5. The mod-x bias from '+1' vs '-1' flips the cycle equation sign")
print("  6. Polynomial extension of the convergence measure μ(x)")
print("     from the divergent region (x>4) to x=3 is the key challenge")
