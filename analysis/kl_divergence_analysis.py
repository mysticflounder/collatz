"""
KL divergence analysis of v-sequence conditional distributions in Collatz/Syracuse.

Investigates how knowledge of v_i constrains v_{i+1}, v_{i+2}, v_{i+3},
and connections to residue class structure.
"""

import os
import sys
from collections import Counter, defaultdict

import numpy as np
from scipy.optimize import curve_fit

sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))
from collatz.core import syracuse, v_sequence

# ============================================================
# Data collection: gather v-sequences from many starting values
# ============================================================
print("=" * 70)
print("Collecting v-sequences from odd integers 3..200001")
print("=" * 70)

MAX_N = 200001
all_v_seqs = {}
for n in range(3, MAX_N + 1, 2):  # odd integers only
    all_v_seqs[n] = v_sequence(n)

# Flatten into consecutive pairs, triples, quadruples
pairs = []  # (v_i, v_{i+1})
triples = []  # (v_i, v_{i+1}, v_{i+2})
quadruples = []  # (v_i, v_{i+1}, v_{i+2}, v_{i+3})

for _n, vs in all_v_seqs.items():
    for i in range(len(vs) - 1):
        pairs.append((vs[i], vs[i + 1]))
    for i in range(len(vs) - 2):
        triples.append((vs[i], vs[i + 1], vs[i + 2]))
    for i in range(len(vs) - 3):
        quadruples.append((vs[i], vs[i + 1], vs[i + 2], vs[i + 3]))

print(f"Total pairs (v_i, v_{{i+1}}):       {len(pairs):,}")
print(f"Total triples (v_i, ..., v_{{i+2}}): {len(triples):,}")
print(f"Total quadruples (v_i, ..., v_{{i+3}}): {len(quadruples):,}")

# ============================================================
# Marginal distribution of v
# ============================================================
# Use raw v-values (not flattened pairs, which double-counts interior values)
all_v = [v for vs in all_v_seqs.values() for v in vs]
v_counts = Counter(all_v)
total_v = sum(v_counts.values())
marginal = {}
for k in sorted(v_counts.keys()):
    marginal[k] = v_counts[k] / total_v

print("\n" + "=" * 70)
print("MARGINAL DISTRIBUTION OF v")
print("=" * 70)
print(f"{'v':>4s}  {'count':>10s}  {'P(v)':>10s}  {'theory 2^-v':>12s}")
print("-" * 42)
for k in sorted(marginal.keys()):
    if k <= 15:
        theory = 2.0 ** (-k)
        print(f"{k:4d}  {v_counts[k]:10,d}  {marginal[k]:10.6f}  {theory:12.6f}")


# ============================================================
# Helper: KL divergence with smoothing
# ============================================================
def kl_divergence(cond_dist, marg_dist, values):
    """KL(cond || marg) over specified values, in nats (np.log). Laplace smoothing."""
    eps = 1e-12
    kl = 0.0
    for v in values:
        p = cond_dist.get(v, 0.0)
        q = marg_dist.get(v, eps)
        if p > 0:
            kl += p * np.log(p / q)
    return kl


# ============================================================
# 1. Extended KL divergence: P(v_{i+1} | v_i = k) for k=1..15
# ============================================================
print("\n" + "=" * 70)
print("1. KL DIVERGENCE: P(v_{i+1} | v_i = k) vs marginal")
print("=" * 70)

# Build conditional distributions
cond_next = defaultdict(list)  # v_i -> list of v_{i+1}
for v_i, v_next in pairs:
    cond_next[v_i].append(v_next)

# All v-values present
all_values = sorted(marginal.keys())

print(
    f"\n{'k':>3s}  {'N samples':>10s}  {'KL div':>10s}  {'Conditional P(v_{i+1}|v_i=k) for v_{i+1}=1..8':>60s}"
)
print("-" * 90)

kl_values_lag1 = {}
for k in range(1, 16):
    samples = cond_next[k]
    n_samples = len(samples)
    if n_samples < 100:
        print(f"{k:3d}  {n_samples:10,d}  {'(too few)':>10s}")
        continue
    cnt = Counter(samples)
    cond_dist = {v: cnt[v] / n_samples for v in cnt}
    kl = kl_divergence(cond_dist, marginal, all_values)
    kl_values_lag1[k] = kl

    # Format conditional dist for v=1..8
    cond_str = "  ".join(f"{v}:{cond_dist.get(v, 0.0):.4f}" for v in range(1, 9))
    print(f"{k:3d}  {n_samples:10,d}  {kl:10.6f}  {cond_str}")

# Print marginal for comparison
marg_str = "  ".join(f"{v}:{marginal.get(v, 0.0):.4f}" for v in range(1, 9))
print(f"{'':>3s}  {'marginal':>10s}  {'':>10s}  {marg_str}")


# ============================================================
# 2. Functional form fitting
# ============================================================
print("\n" + "=" * 70)
print("2. FUNCTIONAL FORM: KL(k) fits")
print("=" * 70)

ks = np.array(sorted(kl_values_lag1.keys()), dtype=float)
kls = np.array([kl_values_lag1[int(k)] for k in ks])

print("\nData points (k, KL):")
for k, kl in zip(ks, kls, strict=False):
    bar = "#" * int(kl * 40 / max(kls)) if max(kls) > 0 else ""
    print(f"  k={int(k):2d}  KL={kl:.6f}  {bar}")


# Linear fit
def linear(x, a, b):
    return a * x + b


# Exponential fit
def exponential(x, a, b):
    return a * np.exp(b * x)


# Power law fit
def power_law(x, a, b):
    return a * np.power(x, b)


fits = {}

# Linear
try:
    popt, _ = curve_fit(linear, ks, kls)
    pred = linear(ks, *popt)
    ss_res = np.sum((kls - pred) ** 2)
    ss_tot = np.sum((kls - np.mean(kls)) ** 2)
    r2 = 1 - ss_res / ss_tot if ss_tot > 0 else 0
    fits["Linear"] = {"params": popt, "R2": r2, "label": f"KL = {popt[0]:.6f}*k + {popt[1]:.6f}"}
    print(f"\nLinear:      KL = {popt[0]:.6f}*k + ({popt[1]:.6f})   R^2 = {r2:.6f}")
except Exception as e:
    print(f"\nLinear fit failed: {e}")

# Exponential
try:
    popt, _ = curve_fit(exponential, ks, kls, p0=[0.01, 0.3], maxfev=10000)
    pred = exponential(ks, *popt)
    ss_res = np.sum((kls - pred) ** 2)
    ss_tot = np.sum((kls - np.mean(kls)) ** 2)
    r2 = 1 - ss_res / ss_tot if ss_tot > 0 else 0
    fits["Exponential"] = {
        "params": popt,
        "R2": r2,
        "label": f"KL = {popt[0]:.6f}*exp({popt[1]:.6f}*k)",
    }
    print(f"Exponential: KL = {popt[0]:.6f}*exp({popt[1]:.6f}*k)   R^2 = {r2:.6f}")
except Exception as e:
    print(f"Exponential fit failed: {e}")

# Power law
try:
    popt, _ = curve_fit(power_law, ks, kls, p0=[0.01, 2.0], maxfev=10000)
    pred = power_law(ks, *popt)
    ss_res = np.sum((kls - pred) ** 2)
    ss_tot = np.sum((kls - np.mean(kls)) ** 2)
    r2 = 1 - ss_res / ss_tot if ss_tot > 0 else 0
    fits["Power law"] = {"params": popt, "R2": r2, "label": f"KL = {popt[0]:.6f}*k^{popt[1]:.6f}"}
    print(f"Power law:   KL = {popt[0]:.6f}*k^{popt[1]:.6f}   R^2 = {r2:.6f}")
except Exception as e:
    print(f"Power law fit failed: {e}")

best = max(fits.items(), key=lambda x: x[1]["R2"])
print(f"\nBest fit: {best[0]}  (R^2 = {best[1]['R2']:.6f})")
print(f"  {best[1]['label']}")


# ============================================================
# 3. Multi-step conditional dependence (lag 2 and lag 3)
# ============================================================
print("\n" + "=" * 70)
print("3. MULTI-STEP CONDITIONAL DEPENDENCE")
print("=" * 70)

# Lag 2: P(v_{i+2} | v_i = k)
cond_lag2 = defaultdict(list)
for v_i, _, v_ip2 in triples:
    cond_lag2[v_i].append(v_ip2)

# Lag 3: P(v_{i+3} | v_i = k)
cond_lag3 = defaultdict(list)
for v_i, _, _, v_ip3 in quadruples:
    cond_lag3[v_i].append(v_ip3)

print(
    f"\n{'k':>3s}  {'N(lag1)':>10s}  {'KL(lag1)':>10s}  {'N(lag2)':>10s}  {'KL(lag2)':>10s}  {'N(lag3)':>10s}  {'KL(lag3)':>10s}"
)
print("-" * 75)

for k in range(1, 11):
    # Lag 1
    s1 = cond_next[k]
    n1 = len(s1)
    if n1 >= 100:
        c1 = Counter(s1)
        d1 = {v: c1[v] / n1 for v in c1}
        kl1 = kl_divergence(d1, marginal, all_values)
    else:
        kl1 = float("nan")

    # Lag 2
    s2 = cond_lag2[k]
    n2 = len(s2)
    if n2 >= 100:
        c2 = Counter(s2)
        d2 = {v: c2[v] / n2 for v in c2}
        kl2 = kl_divergence(d2, marginal, all_values)
    else:
        kl2 = float("nan")

    # Lag 3
    s3 = cond_lag3[k]
    n3 = len(s3)
    if n3 >= 100:
        c3 = Counter(s3)
        d3 = {v: c3[v] / n3 for v in c3}
        kl3 = kl_divergence(d3, marginal, all_values)
    else:
        kl3 = float("nan")

    print(f"{k:3d}  {n1:10,d}  {kl1:10.6f}  {n2:10,d}  {kl2:10.6f}  {n3:10,d}  {kl3:10.6f}")

print("\nDecay ratios (KL_lag2 / KL_lag1, KL_lag3 / KL_lag1):")
for k in range(1, 11):
    s1 = cond_next[k]
    s2 = cond_lag2[k]
    s3 = cond_lag3[k]
    if len(s1) >= 100 and len(s2) >= 100 and len(s3) >= 100:
        c1 = Counter(s1)
        d1 = {v: c1[v] / len(s1) for v in c1}
        c2 = Counter(s2)
        d2 = {v: c2[v] / len(s2) for v in c2}
        c3 = Counter(s3)
        d3 = {v: c3[v] / len(s3) for v in c3}
        kl1 = kl_divergence(d1, marginal, all_values)
        kl2 = kl_divergence(d2, marginal, all_values)
        kl3 = kl_divergence(d3, marginal, all_values)
        r2 = kl2 / kl1 if kl1 > 1e-10 else float("nan")
        r3 = kl3 / kl1 if kl1 > 1e-10 else float("nan")
        print(f"  k={k:2d}:  lag2/lag1 = {r2:.4f}   lag3/lag1 = {r3:.4f}")


# ============================================================
# 4. Residue class connection
# ============================================================
print("\n" + "=" * 70)
print("4. RESIDUE CLASS CONNECTION: Syracuse result mod 8 by v_prev")
print("=" * 70)
print("\nFor each starting odd n, the Syracuse step computes (3n+1)/2^v.")
print("We tabulate the distribution of ((3n+1)/2^v) mod 8, conditioned on v.\n")

# Collect: for each v_prev, what is the result mod 8?
residue_by_v = defaultdict(list)

for n in range(3, MAX_N + 1, 2):
    vs = all_v_seqs[n]
    # Reconstruct Syracuse trajectory to get the actual odd values
    syrac = syracuse(n)
    # syrac[i] is the odd number, vs[i] is the v-value for step i
    # After step i: result = syrac[i+1] = (3*syrac[i]+1) / 2^vs[i]
    for i in range(len(vs)):
        v_val = vs[i]
        result = syrac[i + 1]
        residue_by_v[v_val].append(result % 8)

print(f"{'v_prev':>6s}", end="")
for r in range(8):
    print(f"  {'mod8=' + str(r):>10s}", end="")
print(f"  {'N':>10s}")
print("-" * 100)

for v in range(1, 9):
    samples = residue_by_v[v]
    n_samp = len(samples)
    if n_samp < 100:
        continue
    cnt = Counter(samples)
    print(f"{v:6d}", end="")
    for r in range(8):
        frac = cnt.get(r, 0) / n_samp
        print(f"  {frac:10.4f}", end="")
    print(f"  {n_samp:10,d}")

print("\nNote: Even residues (0,2,4,6) should have P=0 since Syracuse results are odd.")
print("The distribution over odd residues {1,3,5,7} mod 8 shows structure by v_prev.")


# ============================================================
# 5. Joint conditional: P(v_{i+1} | v_i, v_{i-1})
# ============================================================
print("\n" + "=" * 70)
print("5. JOINT CONDITIONAL: P(v_{i+1} | v_i, v_{i-1})")
print("=" * 70)

# Build joint conditional from triples: (v_{i-1}, v_i, v_{i+1})
# In our triples, index 0 = v_i, 1 = v_{i+1}, 2 = v_{i+2}
# So for joint conditioning on (v_{i-1}, v_i) -> v_{i+1}:
#   v_{i-1} = triples[j][0], v_i = triples[j][1], v_{i+1} = triples[j][2]

joint_cond = defaultdict(list)  # (v_{i-1}, v_i) -> list of v_{i+1}
single_cond = defaultdict(list)  # v_i -> list of v_{i+1}  (already have this as cond_next)

for v_im1, v_i, v_ip1 in triples:
    joint_cond[(v_im1, v_i)].append(v_ip1)

print("\nP(v_{i+1} | v_i, v_{i-1}) for v_{i-1} in {1,2,3}, v_i in {1,2,3,4}:")
print(f"\n{'v_{i-1}':>7s}  {'v_i':>4s}  {'N':>8s}", end="")
for vn in range(1, 7):
    print(f"  {'P(v+1=' + str(vn) + ')':>10s}", end="")
print()
print("-" * 85)

for vim1 in [1, 2, 3]:
    for vi in [1, 2, 3, 4]:
        samples = joint_cond[(vim1, vi)]
        n_s = len(samples)
        if n_s < 50:
            continue
        cnt = Counter(samples)
        print(f"{vim1:7d}  {vi:4d}  {n_s:8,d}", end="")
        for vn in range(1, 7):
            print(f"  {cnt.get(vn, 0) / n_s:10.4f}", end="")
        print()
    print()

# Compare with single conditional
print("\nFor comparison, P(v_{i+1} | v_i) alone:")
print(f"{'':>7s}  {'v_i':>4s}  {'N':>8s}", end="")
for vn in range(1, 7):
    print(f"  {'P(v+1=' + str(vn) + ')':>10s}", end="")
print()
print("-" * 85)

for vi in [1, 2, 3, 4]:
    samples = cond_next[vi]
    n_s = len(samples)
    cnt = Counter(samples)
    print(f"{'':>7s}  {vi:4d}  {n_s:8,d}", end="")
    for vn in range(1, 7):
        print(f"  {cnt.get(vn, 0) / n_s:10.4f}", end="")
    print()

# Mutual information I(v_{i+1}; v_{i-1} | v_i)
# = H(v_{i+1} | v_i) - H(v_{i+1} | v_i, v_{i-1})
print(f"\n{'=' * 50}")
print("MUTUAL INFORMATION: I(v_{{i+1}}; v_{{i-1}} | v_i)")
print(f"{'=' * 50}")


def entropy(dist):
    """Shannon entropy of a distribution dict, in bits (np.log2)."""
    h = 0.0
    for p in dist.values():
        if p > 0:
            h -= p * np.log2(p)
    return h


# H(v_{i+1} | v_i) = sum_vi P(v_i) * H(v_{i+1} | v_i=vi)
# H(v_{i+1} | v_i, v_{i-1}) = sum_{vi,vim1} P(v_i, v_{i-1}) * H(v_{i+1} | v_i=vi, v_{i-1}=vim1)

# We'll compute over v_i in {1,2,3,4}, v_{i-1} in {1,2,3}
# using empirical frequencies from triples

# Marginal counts of (v_{i-1}, v_i) pairs from triples
pair_counts = Counter()
for vim1, vi, _vip1 in triples:
    pair_counts[(vim1, vi)] += 1
total_triples = len(triples)

# Also need P(v_i) from triples for fair comparison
vi_counts_triples = Counter()
for _vim1, vi, _vip1 in triples:
    vi_counts_triples[vi] += 1

# H(v_{i+1} | v_i) over v_i in {1,2,3,4}
# Use triples-derived conditional (v_i -> v_{i+1}) for consistency with joint
h_next_given_vi = 0.0
vi_range = [1, 2, 3, 4]
vim1_range = [1, 2, 3]
total_in_range = sum(vi_counts_triples[vi] for vi in vi_range)

# Build v_i -> v_{i+1} conditional from triples (middle -> last element)
cond_next_from_triples = defaultdict(list)
for _vim1, vi, vip1 in triples:
    cond_next_from_triples[vi].append(vip1)

for vi in vi_range:
    p_vi = vi_counts_triples[vi] / total_triples
    samples = cond_next_from_triples[vi]
    n_s = len(samples)
    if n_s < 50:
        continue
    cnt = Counter(samples)
    dist = {v: cnt[v] / n_s for v in cnt}
    h_next_given_vi += p_vi * entropy(dist)

# H(v_{i+1} | v_i, v_{i-1}) over v_i in {1,2,3,4}, v_{i-1} in {1,2,3}
h_next_given_both = 0.0
total_joint_in_range = sum(pair_counts[(vim1, vi)] for vim1 in vim1_range for vi in vi_range)

for vim1 in vim1_range:
    for vi in vi_range:
        p_joint = pair_counts[(vim1, vi)] / total_triples
        samples = joint_cond[(vim1, vi)]
        n_s = len(samples)
        if n_s < 50:
            continue
        cnt = Counter(samples)
        dist = {v: cnt[v] / n_s for v in cnt}
        h_next_given_both += p_joint * entropy(dist)

mi = h_next_given_vi - h_next_given_both
print(f"\n(Restricted to v_i in {vi_range}, v_{{i-1}} in {vim1_range})")
print(f"H(v_{{i+1}} | v_i)            = {h_next_given_vi:.6f} bits")
print(f"H(v_{{i+1}} | v_i, v_{{i-1}})  = {h_next_given_both:.6f} bits")
print(f"I(v_{{i+1}}; v_{{i-1}} | v_i)  = {mi:.6f} bits")
print(
    f"\nInterpretation: {'Significant' if mi > 0.01 else 'Negligible'} additional predictive power"
)
print("from knowing v_{i-1} beyond what v_i alone provides.")

# Per-v_i breakdown
print("\nPer-v_i breakdown of conditional mutual information:")
print(f"{'v_i':>4s}  {'H(v+1|v_i)':>12s}  {'H(v+1|v_i,v-1)':>16s}  {'MI':>10s}")
print("-" * 48)
for vi in vi_range:
    # H(v_{i+1} | v_i = vi) — use triples-derived for consistency
    s_vi = cond_next_from_triples[vi]
    if len(s_vi) < 50:
        continue
    c_vi = Counter(s_vi)
    d_vi = {v: c_vi[v] / len(s_vi) for v in c_vi}
    h_vi = entropy(d_vi)

    # H(v_{i+1} | v_i = vi, v_{i-1}) = sum_{v-1} P(v-1|vi) * H(v+1|vi,v-1)
    # P(v_{i-1}=vim1 | v_i=vi) from triples
    vim1_given_vi = Counter()
    for vim1, v, _vip1 in triples:
        if v == vi:
            vim1_given_vi[vim1] += 1
    total_vim1 = sum(vim1_given_vi.values())

    h_both = 0.0
    for vim1 in vim1_range:
        p_vim1 = vim1_given_vi.get(vim1, 0) / total_vim1 if total_vim1 > 0 else 0
        s_both = joint_cond[(vim1, vi)]
        if len(s_both) < 50 or p_vim1 == 0:
            continue
        c_both = Counter(s_both)
        d_both = {v: c_both[v] / len(s_both) for v in c_both}
        h_both += p_vim1 * entropy(d_both)

    mi_vi = h_vi - h_both
    print(f"{vi:4d}  {h_vi:12.6f}  {h_both:16.6f}  {mi_vi:10.6f}")


print("\n" + "=" * 70)
print("ANALYSIS COMPLETE")
print("=" * 70)
