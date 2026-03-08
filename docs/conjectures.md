# Precise Conjectures

Falsifiable claims with exact formulations, supporting evidence, and conditions for disproof.

## Setup and Notation

Let x be an odd positive integer, y an odd integer, and k >= 2. The Syracuse-type map on odd integers is S(n) = (xn + y) / 2^{v_2(xn+y)}, where v_2 denotes the 2-adic valuation.

This map acts on odd residues mod 2^k. There are N = 2^{k-1} odd residue classes {1, 3, 5, ..., 2^k - 1}. Define the **transfer matrix** P_k(x, y) as the N x N matrix with entry P[i,j] = 2^{-v} if S(j) maps to i mod 2^k with 2-adic valuation v, and 0 otherwise.

Since S is a function (not one-to-many), each column of P_k has exactly one nonzero entry. The matrix's functional graph decomposes into cycles and trees rooted at cycles. The **spectral radius** rho_k(x, y) equals the maximum of 2^{-mean(v)} over all cycles, where mean(v) is the arithmetic mean of the v-values around the cycle.

---

## Proposition 1: Uniform Spectral Bound (Trivially True)

**Statement.** For any odd positive integer x and odd integer y,

rho_k(x, y) <= 1/2 for all k >= 2.

For x=3, y=1 specifically, rho_k(3, 1) < 1/2 for all k >= 2.

**Proof sketch.** Since x is odd, y is odd, and n is odd, xn + y is even, so v_2(xn + y) >= 1. Every weight in the transfer matrix is 2^{-v} <= 1/2. The spectral radius, being the maximum of 2^{-mean(v)} over cycles, satisfies rho <= 2^{-1} = 1/2. The strict bound for x=3, y=1: suppose a cycle has all v_i = 1, so the map on the cycle is f(j) = (3j+1)/2. One verifies that v_2(f(j)+1) = v_2(j+1) - 1 for all odd j (since f(j)+1 = (3j+3)/2 = 3(j+1)/2, and j+1 is even with v_2(j+1) >= 1). Around a cycle of length L, v_2 drops by 1 at each step, so v_2(j_0+1) - L = v_2(j_0+1), giving L=0. Contradiction. So no all-v=1 cycle exists, and rho < 1/2.

**Note.** The original Conjecture 1 stated rho < 1, which is trivially true by the above. The interesting content is in the Main Conjecture below: not just that rho < 1/2, but that rho → 1/4 specifically.

---

## Conjecture 1: FALSIFIED — Asymptotic Spectral Radius

**Original statement.** Define the exceptional set E = {k >= 2 : the modular Syracuse map for (x=3, y=1) on odd residues mod 2^k has more than one cycle}. Then:

(a) E has natural density zero: lim_{K→∞} |E ∩ [2, K]| / K = 0.

(b) lim_{k→∞} rho_k(3,1) = 1/4.

**FALSIFIED (2026-03-05).** Both parts are false. Ghost cycles are true 2-adic periodic orbits that reappear at arithmetic progressions of levels, making E infinite with positive density.

### Falsification evidence

The ghost at k=12 (L=6, V=7, D=-601) is case (a) of the persistence theorem: a true 2-adic periodic orbit with rational elements n_tilde = R/D = -665/601. It reappears at every k ≡ 12 mod 25 (where 25 = ord_2(601)):

| k | Ghost type | D | rho |
|---|-----------|---|-----|
| 12 | L=6, V=7 | -601 | 0.4454 |
| 37 | L=6, V=7 | -601 | 0.4454 |
| 62 | L=6, V=7 | -601 | 0.4454 |
| 87 | L=6, V=7 | -601 | 0.4454 |
| 112 | L=6, V=7 | -601 | 0.4454 |
| ... | ... | ... | ... |

Similarly, D=-179 (L=5, V=6) reappears at k=35, 71, 142 (period 178, r=3). D=-5537 (L=8, V=10) reappears at k=42, 85, 126, 169 (period 84, r=2). D=-1675 (L=7, V=9) at k=12, 95, 106, 165, 189, 200, 448, 542, 661 (period 660, r=9 across 3 composition families). D=-1931 (L=7, V=8) at k=275 (period 1930, r=5). D=-6049 (L=8, V=9) at k=180 (period 1441, r=10).

Complete scan of E ∩ [37,200] (checking L≤8 ghost types) finds 19 members. Density ≈ 12%.

**This falsifies (a):** E contains the arithmetic progression {12, 37, 62, 87, ...} of density 1/25 = 4%.

**This falsifies (b):** At every k ≡ 12 mod 25, rho_k ≥ 2^{-7/6} ≈ 0.445, which is bounded away from 1/4.

**The Borel-Cantelli heuristic P(k ∈ E) ~ k² · 2^{-k} was WRONG.** The true probability does not decay; it is bounded below by a positive constant.

### Verified computationally

All ghost reappearances verified by explicit Syracuse map simulation at each level k. See `analysis/baker_wustholz_verification.py` and `docs/proofs/baker-code-audit.md`.

### Revised open questions

The falsification of Conjecture 1 opens new questions:

1. **What is the natural density of E?** Empirically ~12% in [37,200]. Does it converge?
2. **What is ρ(L)?** Since E is infinite with case (a) ghosts, ρ(L) ≥ 2^{-7/6} ≈ 0.445.
3. **Are there infinitely many distinct ghost types (L,V)?** If so, the density of E may be much higher.
4. **What characterizes case (a) vs case (b)?** Can we predict which (L,V,v-pattern) produce true 2-adic orbits?
5. **Does the Collatz convergence question reduce to understanding the POSITIVE-integer orbits only?** Ghost cycles have negative rational elements and don't obstruct convergence of positive trajectories.

---

## Conjecture 3: RETRACTED — Fredholm Coefficients Are Not Polynomial

**Original claim.** The Fredholm coefficients c_j(x) are polynomials in x.

**Falsification.** Direct computation shows c_j(x) is NOT polynomial for low-order coefficients. At k=6 (N=32 states), degree-30 Chebyshev fits to c_j(x) sampled at 64 odd integers:

| Coefficient | Max fit error | Relative error | Status |
|-------------|---------------|----------------|--------|
| c_0 | 3.2e-15 | ~0 | Trivial (constant = 1) |
| c_1 | 4.5e-01 | 53% | NOT polynomial |
| c_2 | 1.6e-01 | 85% | NOT polynomial |
| c_8 | 6.8e-04 | 70% | NOT polynomial |
| c_16 | 3.0e-08 | 8% | Borderline |
| c_24+ | <1e-12 | ~0 | Near-zero (trivially fits) |

The original "machine-epsilon evidence" was misleading: it was dominated by high-order coefficients c_j for j >> 1, which are near-zero (|c_j| < 10^{-12}) and trivially fit any polynomial. The low-order coefficients, which carry the actual spectral information, have 50-85% relative fit errors even with degree-120 polynomials.

**Root cause.** The trace c_1(x) = -tr(P_k(x,1)) = -Σ 2^{-v_2(xj+y)} over diagonal entries. The function v_2(xj+y) depends on the 2-adic structure of x, not its archimedean value. It is fundamentally a 2-adic object, not a polynomial.

---

## Theorem 1 (Replacement): 2-Adic Local Constancy (paper: Theorem 1)

**Statement.** For fixed k >= 2 and y odd, the map x -> P_k(x, y) is locally constant in the 2-adic topology on the odd positive integers. Explicitly: for each odd positive integer x_0, P_k(x, y) = P_k(x_0, y) for all odd positive x with x ≡ x_0 mod 2^M, where

M(k, x_0, y) = k + max{ v_2(x_0 * j + y) : j odd, 1 <= j < 2^k }.

This bound is tight (no smaller M suffices). Note that M depends on x_0, not just k.

**Corollaries.**

(a) The Fredholm coefficients c_j(x) and the spectral radius rho_k(x, y) are locally constant functions of x in the 2-adic topology.

(b) The Fredholm coefficients are NOT polynomial in x (a polynomial that is locally constant on infinitely many residue classes must be globally constant; c_1 is not).

(c) For fixed k and x_0, the matrix P_k(x, y) depends on x only through x mod 2^{M(k,x_0,y)}. The spectral radius takes finitely many values as x ranges over any fixed residue class.

**Proof.** See `docs/proofs/theorem3-2adic-local-constancy.md` for the full proof. The key steps:

1. *Valuation preservation.* If x ≡ x_0 mod 2^M, the perturbation delta = (x - x_0) * j has v_2(delta) >= M > v_2(x_0 * j + y), so by the ultrametric identity, v_2(x * j + y) = v_2(x_0 * j + y).

2. *Target preservation.* The perturbation delta / 2^v has v_2 >= M - v >= k, so (x * j + y) / 2^v ≡ (x_0 * j + y) / 2^v mod 2^k.

**Explicit bounds for x_0 = 3, y = 1.** The worst-case residues are j_m = (4^m - 1)/3 = {1, 5, 21, 85, 341, ...}, giving v_2(3j_m + 1) = 2m:

| k | V = max v_2 | M = k + V | Worst j |
|---|------------|-----------|---------|
| 3 | 4 | 7 | 5 |
| 5 | 6 | 11 | 21 |
| 7 | 8 | 15 | 85 |
| 9 | 10 | 19 | 341 |

In general, M(k, 3, 1) ≈ 2k.

**Significance.** The natural domain for extending spectral data is the 2-adic integers, not the complex plane. The "polynomial extension" framework (retracted Conjecture 3) was looking in the wrong topology. This connects to Siegel's p-adic framework (arXiv:2507.13358) where the Collatz map is treated as an iterated function system on Z_2.

---

## Proposition 2: v-Distribution Universality (paper: Proposition 2)

**Statement.** For any odd positive integer x and any odd integer y, the 2-adic valuation v = v_2(xn + y) satisfies, over odd residues n in {1, 3, ..., 2^k - 1}:

#{n : v_2(xn + y) = j} / 2^{k-1} = 1/2^j for j = 1, ..., k-1.

Equivalently, the fraction of odd residues mod 2^k where v_2(xn + y) = j is exactly 2^{-j}.

**Proof sketch.** Since x is odd, the map n → xn + y is a bijection on Z/2^k Z. For odd n, the image xn + y is even (odd × odd + odd = even). The even residues mod 2^k are uniformly distributed: exactly 2^{k-2} are ≡ 2 mod 4 (giving v=1), exactly 2^{k-3} are ≡ 4 mod 8 (giving v=2), etc. The fraction with v = j is 2^{k-1-j} / 2^{k-1} = 1/2^j.

**Prior art.** This is folklore in the Collatz literature:
- Tao (2019): "can be seen to have a geometric distribution"
- Matthews (1985): transfer matrix Q_T(m) has entries 1/d (Theorem 3.1)
- Lagarias (1985): uses as heuristic assumption
- Lagarias-Weiss (1992): modeling assumption for stochastic analysis

**Status.** Theorem, not conjecture. Should appear as a proposition in any paper.

---

## Proposition 3: Fredholm Zeros Outside the Unit Disk (paper: Proposition 3)

**Statement.** For each k >= 2 and any odd x with odd y, every zero z_0 of det(I - z * P_k(x, y)) satisfies |z_0| >= 2.

**Proof.** The zeros occur at z = 1/lambda_i where lambda_i are eigenvalues of P. By Proposition 1, |lambda_i| <= 1/2 for all eigenvalues, so |z_0| = 1/|lambda_i| >= 2.

**Note.** The original Conjecture 5 stated |z_0| > 1, which is equivalent to rho < 1 — both trivially true. The Fredholm zero formulation no longer serves as an independent conjecture. It remains useful as geometric language: Conjecture 1 can be restated as "the nearest Fredholm zero converges to |z| = 4 (corresponding to rho = 1/4)."

---

## Summary of Status Changes

| Paper label | Original Status | New Status | Reason |
|-------------|----------------|------------|--------|
| Proposition 1 | Conjecture | Proposition (trivially true) | rho <= 1/2 follows from v >= 1 |
| Conjecture 1 | Conjecture | **FALSIFIED** | E infinite with positive density; ghost cycles are true 2-adic orbits |
| Theorem 1 | Conjecture | **RETRACTED** / replaced by Theorem 1 | Falsified: c_j(x) not polynomial, 2-adically locally constant |
| Proposition 2 | Conjecture | Proposition (folklore) | Proven by equidistribution; known to Tao, Matthews, Lagarias |
| Proposition 3 | Conjecture | Proposition (trivially true) | Equivalent to Proposition 1 |

## The Transfer Operator on Z_2^{odd}

The finite matrices P_k are projections of an infinite-dimensional transfer operator L on C(Z_2^{odd}). For f: Z_2^{odd} → R:

(Lf)(n) = Σ_{S(m)=n} 2^{-v_2(3m+1)} · f(m)

### Proven spectral properties of L (see `docs/proofs/transfer-operator-spectral-theory.md`)

| Property | Value | Status |
|----------|-------|--------|
| Operator norm ‖L‖ on C(Z_2^{odd}) | **2/3** | Proved (Proposition 1 of proof doc) |
| Spectral radius ρ(L) | ≤ 1/2 | Proved |
| Eigenvalue 1/4 (from fixed point {1}) | Simple | Proved |
| σ(L) = closure of ∪ σ(P_k) | Projective limit | Proved (Theorem 2e) |
| Conditional: if E finite then ρ(L) = 1/4 | Theorem 3 | Proved (conditional; hypothesis E finite is FALSE) |

### Correction: ‖L‖ = 2/3, not 1/3

The earlier claim ‖L‖_sup = 1/3 was incorrect. It only counted preimages with even v (corresponding to n ≡ 1 mod 3). The complete preimage structure:

- n ≡ 1 mod 3: preimages at even v = 2, 4, 6, ..., weight sum = 1/3
- n ≡ 2 mod 3: preimages at odd v = 1, 3, 5, ..., weight sum = 2/3
- n ≡ 0 mod 3: no preimages, weight sum = 0

So ‖L‖ = sup_n W(n) = 2/3.

### Lasota-Yorke inequality: FAILS (fundamental obstruction)

**The transfer operator L does not preserve Lip_1(Z_2^{odd}).** The constant function f = 1 maps to W(n) = L(1)(n), which has infinite Lipschitz seminorm. Explicit counterexample: x_N = 1, y_N = 1 + 2^N (even N) gives W(x_N) = 1/3, W(y_N) = 2/3, and |W(x_N) - W(y_N)| / |x_N - y_N|_2 = 2^N/3 → ∞.

**Root cause:** W(n) depends on n mod 3, which oscillates at every scale of the 2-adic metric (since gcd(2^N, 3) = 1 for all N). This obstruction extends to ALL Holder, BV, and Lipschitz spaces defined using the 2-adic metric alone (Corollary 1 of proof doc).

**Deeper arithmetic cause:** Each inverse branch g_v(n) = (n·2^v - 1)/3 contracts by 2^{-v} in the 2-adic metric but **expands by 3** in the 3-adic metric. The 3-adic expansion exactly compensates the weight sum, giving net Lipschitz factor ≥ 1. This is the arithmetic tension between 2 and 3 at the heart of the Collatz problem.

### Paths forward for quasi-compactness

1. **Mahler basis / Iwasawa algebra** — Banach space accommodating both 2-adic and 3-adic structure
2. **Projective limit approach** — bypass Lasota-Yorke, prove quasi-compactness directly from P_k
3. **Baker-Wustholz bounds** — prove E finite via effective lower bounds on |2^V - 3^L|
4. **Thermodynamic formalism** — Santana (arXiv:2601.03297) inducing schemes

See `docs/proofs/transfer-operator-spectral-theory.md` for the full analysis and `docs/proof-strategy-discussion.md` for the broader proof strategy.

---

## Priority and Open Questions

Conjecture 1 has been falsified. The central open questions are now:

| Question | Method | Status |
|----------|--------|--------|
| Natural density of E | Enumerate ghost types, compute arithmetic progression densities | Open; empirically ~12% |
| True spectral radius ρ(L) | Determine all case (a) ghost types | Open; ≥ 0.445 |
| Case (a) vs case (b) classification | Characterize which rational orbits R/D satisfy valuation conditions | Open |
| Positive-integer convergence | Do 2-adic ghost orbits obstruct convergence of positive trajectories? | Open; likely NO (ghost elements are negative) |
| Theorem 1 (2-adic local constancy) | Formalize proof for publication | Ready |

**Key insight (2026-03-05).** Ghost cycles are not finite-level artifacts. They are true 2-adic periodic orbits with negative rational elements (e.g., -665/601 for D=-601). Their modular reductions produce valid ghost cycles at arithmetic progressions of levels k. The exceptional set E is infinite with positive density ≥ 4%.

**Lasota-Yorke obstruction (2026-03-05):** The standard route to proving essential spectral radius ≤ 1/4 via Lasota-Yorke on Lip_1(Z_2^{odd}) fails because L does not preserve this space. This is now moot: ρ(L) > 1/4 since E is infinite. See `docs/proofs/transfer-operator-spectral-theory.md`.

**Baker-Wüstholz analysis (2026-03-05):** Theorems A-D provide structural understanding (cycle equation, persistence theorem, Baker bounds). The key finding: Theorem C has two cases, and the known ghosts are case (a) — true 2-adic orbits that persist forever. See `docs/proofs/baker-wustholz-analysis.md` and `docs/proofs/baker-code-audit.md`.
