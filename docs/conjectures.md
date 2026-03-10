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

---

## Conjecture 1: Density of the Exceptional Set (FALSIFIED original; REFORMULATED)

**Original statement (FALSIFIED 2026-03-05).** E has natural density zero and rho_k(3,1) → 1/4.

**Reformulated statement.** The exceptional set E = {k >= 2 : P_k(3,1) has more than one cycle} has a well-defined natural density δ(E) > 0. The density decomposes as

δ(E) = 1 - ∏_G (1 - r_G / p_G)

where the product is over all materializing case-(a) ghost types G, p_G = ord_2(|D_G|) is the period, and r_G is the number of residue classes within that period where G appears. The product formula is a lower bound when periods share common factors.

**Evidence.**
- From the 6 original ghost types (L ≤ 8): product formula gives δ(E) ≥ 10.0%.
- Empirical scan: k=100: 9.18%, k=200: 10.61%, k=500: 10.04%, k=1000: 10.22%.
- The 0.2% gap between formula and empirical is consistent with shared period factors (gcd(660,1930)=10, gcd(660,84)=12, etc.).
- D=-601 alone gives δ(E) ≥ 1/25 = 4% unconditionally.
- 7 additional ghost types from extended census contribute ~0.2% more.

---

## Conjecture 2: Spectral Radius

**Statement.** The spectral radius of the transfer operator satisfies

limsup_{k→∞} rho_k = max(1/4, sup_G 2^{-V_G/L_G})

where the supremum is over all case-(a) ghost types.

**Current lower bound.** ρ(L) ≥ 2^{-13/12} ≈ 0.4719 (from D=-523249, L=12, V=13).

**Evidence for ρ(L) = 1/2.**
- The V=L+1 family has ρ = 2^{-(L+1)/L} → 1/2. Materializing ghosts found at L=5,6,7,8,10,12,13,14,15.
- All fixed-excess families (e = V-L fixed) have ρ = 2^{-1-e/L} → 1/2 as L → ∞.
- If universal case-(a) and materialization hold, σ(L) ⊇ [1/4, 1/2].

---

## Conjecture 3: Negative Rationality

**Statement.** For every case-(a) ghost type with D < 0, all orbit elements ñ_i = R_i/D are negative rationals (equivalently, R_i > 0 for all i).

**Evidence.** Verified computationally for all 5,996 canonical case-(a) ghost types with D < 0 across 66 (L,V) pairs through L=12. Every orbit element has R_i > 0.

**Significance.** If all case-(a) orbit elements are negative rationals, then no ghost cycle corresponds to a positive-integer Collatz cycle. Conjecture 3 implies the nonexistence of non-trivial positive-integer Collatz cycles (the periodic orbit part of the Collatz conjecture).

---

## Conjecture 4: Universal Case-(a)

**Statement.** For all positive integers L ≥ 2 and L+1 ≤ V ≤ 2L-1, and for every composition (v_1, ..., v_L) of V into L positive parts, the rational orbit ñ_1 = R/(2^V - 3^L) satisfies v_2(3ñ_i + 1) = v_i for all i = 1, ..., L. Equivalently, every such composition defines a true periodic orbit of the Syracuse map on Z_2^{odd}; there are no case-(b) ghost types with ρ > 1/4.

**Evidence.**
- Verified exhaustively for all 91 (L,V) pairs with L=2,...,15 (up to ~800,000 compositions per pair for L≤12).
- Extended to L=20 via sampling (10^6 random samples per pair, 85 million total). Zero failures.
- The property also holds for V ≥ 2L (D > 0), tested exhaustively through L=12 at V=2L and V=2L+1. The sign of D does not affect universal case-(a).

**Significance.** Eliminates case-(b) from the spectral-radius-relevant range entirely. The density formula (Conjecture 1) applies to all ghost types with ρ > 1/4 without case-(b) corrections.

---

## Theorem 1: 2-Adic Local Constancy (paper: Theorem 1)

**Statement.** For fixed k >= 2 and y odd, the map x -> P_k(x, y) is locally constant in the 2-adic topology on the odd positive integers. Explicitly: for each odd positive integer x_0, P_k(x, y) = P_k(x_0, y) for all odd positive x with x ≡ x_0 mod 2^M, where

M(k, x_0, y) = k + max{ v_2(x_0 * j + y) : j odd, 1 <= j < 2^k }.

This bound is tight (no smaller M suffices). Note that M depends on x_0, not just k.

**Proof.** See `docs/proofs/theorem3-2adic-local-constancy.md`.

---

## Proposition 2: v-Distribution Universality (paper: Proposition 2)

**Statement.** For any odd positive integer x and any odd integer y, the 2-adic valuation v = v_2(xn + y) satisfies, over odd residues n in {1, 3, ..., 2^k - 1}:

#{n : v_2(xn + y) = j} / 2^{k-1} = 1/2^j for j = 1, ..., k-1.

**Status.** Theorem (folklore). Known to Tao, Matthews, Lagarias, Lagarias-Weiss.

---

## Proposition 3: Fredholm Zeros Outside the Unit Disk (paper: Proposition 3)

**Statement.** For each k >= 2 and any odd x with odd y, every zero z_0 of det(I - z * P_k(x, y)) satisfies |z_0| >= 2.

**Status.** Trivially true (follows from Proposition 1).

---

## Retracted: Conjecture 3 (original) — Fredholm Coefficients Are Not Polynomial

**Original claim.** The Fredholm coefficients c_j(x) are polynomials in x.

**Status.** RETRACTED. Direct computation shows c_j(x) is NOT polynomial. The natural domain is 2-adic (Theorem 1), not polynomial.

---

## The Transfer Operator on Z_2^{odd}

The finite matrices P_k are projections of an infinite-dimensional transfer operator L on C(Z_2^{odd}). For f: Z_2^{odd} → R:

(Lf)(n) = Σ_{S(m)=n} 2^{-v_2(3m+1)} · f(m)

### Proven spectral properties of L

| Property | Value | Status |
|----------|-------|--------|
| Operator norm ‖L‖ on C(Z_2^{odd}) | **2/3** | Proved |
| Spectral radius ρ(L) | ≤ 1/2 | Proved |
| Lower bound ρ(L) | ≥ 2^{-13/12} ≈ 0.4719 | Proved (from D=-523249) |
| Eigenvalue 1/4 (from fixed point {1}) | Simple | Proved |
| σ(L) = closure of ∪ σ(P_k) | Projective limit | Proved |
| Conditional: if E finite then ρ(L) = 1/4 | Theorem 3 | Proved (hypothesis FALSE) |

### Lasota-Yorke inequality: FAILS (fundamental obstruction)

L does not preserve Lip_1(Z_2^{odd}). Root cause: inverse branches g_v(n) = (n·2^v - 1)/3 contract by 2^{-v} in 2-adic metric but expand by 3 in 3-adic metric. Obstruction extends to all Holder/BV spaces using 2-adic metric alone.

### Known ghost types (13 materializing, through L=12)

Ghost types organize by excess e = V - L:
- **e=1** (V=L+1): D=-179,-601,-1931,-6049,-57001,-523249 (L=5,6,7,8,10,12)
- **e=2** (V=L+2): D=-1675,-5537,-17635,-54953,-168955,-515057 (L=7,8,9,10,11,12)
- **e=3** (V=L+3): D=-50857 (L=10)

Non-concentrated compositions of the same (L,V) also materialize. All v-patterns listed in the table are concentrated (1,...,1,e+1) as canonical representatives.

---

## Summary of Status

| Label | Status | Key result |
|-------|--------|------------|
| Proposition 1 | Proved | ρ ≤ 1/2, strict for x=3 |
| Conjecture 1 (Density) | Reformulated | δ(E) ≥ 10.0% (lower bound) |
| Conjecture 2 (Spectral Radius) | Open | ρ(L) ≥ 2^{-13/12}, likely = 1/2 |
| Conjecture 3 (Negative Rationality) | Open | Verified for 5,996 D<0 ghosts through L=12 |
| Conjecture 4 (Universal Case-(a)) | Open | Verified through L=20, including D>0 |
| Theorem 1 (2-adic local constancy) | Proved | M(k) = k + max_v |
| Proposition 2 (v-distribution) | Proved | P(v=j) = 1/2^j (folklore) |
| Proposition 3 (Fredholm zeros) | Proved | Trivially from Prop 1 |
| Original Conjecture 3 (polynomial) | Retracted | c_j(x) not polynomial |
