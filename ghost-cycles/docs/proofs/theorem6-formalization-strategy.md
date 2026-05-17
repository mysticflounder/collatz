# Theorem 6 Formalization Strategy: Missing Pieces

**Date:** 2026-03-23
**Status:** Design document (research-only)
**Lean version:** 4.28.0, Mathlib v4.28.0
**Existing infrastructure:** 42 verified theorems across 11 files (zero sorry)

---

## 0. Summary of the Gap

The AI math-professor subagent review (`lean-review-theorem6.md`) identifies 40--50% coverage. What is **proven**:

- $D$ odd $\Rightarrow$ coprimality with $2^k$, modular inverse exists, solution unique (Theorems 1--6 in PersistenceFull)
- Any solution $n_1$ to $n_1 D \equiv R \pmod{2^k}$ is odd for $k \ge 1$ (Theorems 7--8, 11)
- $\exists\, p > 0$ with $|D| \mid (2^p - 1)$ (Theorem 14, `exists_period`)
- Universal case-a for the **rational** orbit: $v_2(3R_i + D) = v_i$ (in GeneralOrbit)

What is **missing**:

1. **Periodicity of $D^{-1} \bmod 2^k$** --- the 2-adic expansion of $D^{-1}$ has period $p = \mathrm{ord}_2(|D|)$
2. **Valuation stability at finite levels** --- connecting `universal_case_a_general` (proved for rational orbit) to modular orbits
3. **Full persistence conclusion** --- ghost at $k_0$ implies ghost at all $k \equiv k_0 \pmod{p}$

This document proposes exact Lean 4 theorem statements and proof strategies for each piece, with honest assessments of difficulty and tractability.

---

## 1. Periodicity of $D^{-1} \bmod 2^k$

### 1.1. Mathematical Content

The claim: $|D| \mid (2^p - 1)$ implies that $D^{-1} \bmod 2^{k+p}$ and $D^{-1} \bmod 2^k$ agree modulo $2^k$. Equivalently, if $n_1 D \equiv R \pmod{2^k}$ and $n_2 D \equiv R \pmod{2^{k+p}}$, then $2^k \mid (n_1 - n_2)$.

The reason: $2^p \equiv 1 \pmod{|D|}$ means $|D| \mid (2^p - 1)$, so $D \mid (2^p - 1)$ or $D \mid (1 - 2^p)$. Either way, $D \cdot D^{-1} \equiv 1 \pmod{2^k}$ and $D \cdot D^{-1} \equiv 1 \pmod{2^{k+p}}$ share the same low-order $k$ bits because the modular inverse is computed by essentially the same extended-GCD data shifted by $p$ positions.

However, formalizing this directly via 2-adic expansions or bit-level arguments is painful. The cleaner approach uses only divisibility.

### 1.2. The Clean Algebraic Approach

The key insight that avoids 2-adic expansions entirely:

**Claim.** If $n_1 D \equiv R \pmod{2^k}$ and $n_2 D \equiv R \pmod{2^{k+p}}$, then $2^k \mid (n_1 - n_2)$.

**Proof.** From $2^{k+p} \mid (n_2 D - R)$ we get $2^k \mid (n_2 D - R)$ (trivially). Combined with $2^k \mid (n_1 D - R)$, we get $2^k \mid (n_1 - n_2) D$. Since $\gcd(D, 2^k) = 1$, we conclude $2^k \mid (n_1 - n_2)$. QED.

This is **already provable** from existing infrastructure. It is a direct corollary of `ghost_solution_unique`.

### 1.3. Proposed Theorem

```lean
/-- Solutions at higher levels refine solutions at lower levels:
    if n₂ solves the congruence mod 2^{k+p}, it also solves mod 2^k,
    and the two solutions agree mod 2^k. -/
theorem ghost_solution_level_refine
    {D : ℤ} (hD : Odd D) (k p : ℕ)
    {n₁ n₂ R : ℤ}
    (h1 : (2 : ℤ) ^ k ∣ (n₁ * D - R))
    (h2 : (2 : ℤ) ^ (k + p) ∣ (n₂ * D - R)) :
    (2 : ℤ) ^ k ∣ (n₁ - n₂) :=
  ghost_solution_unique hD k h1 (dvd_trans (pow_dvd_pow 2 (Nat.le_add_right k p)) h2)
```

**Difficulty: EASY (< 10 minutes).** This is literally `ghost_solution_unique` composed with `pow_dvd_pow`. It does not require `exists_period` at all --- it is a purely algebraic fact about coprime modular equations.

### 1.4. What This Does NOT Prove

The deeper periodicity claim --- that $D^{-1} \bmod 2^{k+p} \equiv D^{-1} \bmod 2^k \pmod{2^k}$ for the *specific* $p = \mathrm{ord}_2(|D|)$ --- requires showing that the unique solution mod $2^{k+p}$ reduces to the unique solution mod $2^k$. But this is exactly what `ghost_solution_level_refine` proves: the solution at a higher level agrees with the solution at any lower level.

The role of $p$ is different: it controls when the *full* $2^k$-residue class of $D^{-1}$ repeats (i.e., when $D^{-1} \bmod 2^{k+p} = D^{-1} \bmod 2^k$ as integers in $[0, 2^k)$). For the persistence theorem, we do not need this stronger claim. We need only that a ghost at level $k_0$ implies a ghost at level $k_0 + p$, which requires a different argument (see Section 3).

### 1.5. The Actual Periodicity Statement (If Desired)

The stronger periodicity claim requires:

```lean
/-- D⁻¹ mod 2^k is p-periodic: the unique solution n₁ ∈ [0, 2^k)
    to n₁ · D ≡ R (mod 2^k) satisfies n₁(k+p) ≡ n₁(k) (mod 2^k). -/
theorem modular_inverse_periodic
    {D : ℤ} (hD : Odd D) (habs : 1 < D.natAbs)
    {p : ℕ} (hp : 0 < p) (hperiod : (D.natAbs : ℤ) ∣ ((2 : ℤ) ^ p - 1))
    (R : ℤ) (k : ℕ)
    {n₁ n₂ : ℤ}
    (h1 : (2 : ℤ) ^ k ∣ (n₁ * D - R))
    (h2 : (2 : ℤ) ^ (k + p) ∣ (n₂ * D - R)) :
    (2 : ℤ) ^ k ∣ (n₂ - n₁)
```

This is identical to `ghost_solution_level_refine` and does not actually use `hperiod`, `hp`, or `habs`. The hypotheses about $p$ are decoration that would be needed if we wanted to prove the *converse* (that the period is exactly $p$ and not shorter), which the paper does not claim.

**Assessment:** The "periodicity of $D^{-1} \bmod 2^k$" is a red herring for the formalization. The algebraic content needed is just solution refinement, which is already essentially proved. The period $p$ matters for *counting* at which levels ghosts appear, not for *proving* they appear.

---

## 2. Valuation Stability at Finite Levels

### 2.1. Mathematical Content

The paper's condition (ii): for each step $i$, $v_2(3n_i + 1) = v_i$ where $n_i = \tilde{n}_i \bmod 2^k$.

The rational orbit has $R_{i+1} \cdot 2^{v_i} = 3R_i + D$ with all $R_i$ odd. The modular orbit at level $k$ has $n_i \equiv R_i / D \pmod{2^k}$, so $n_i \cdot D \equiv R_i \pmod{2^k}$.

The valuation condition becomes: $v_2(3n_i + 1) = v_i$ when $k$ is sufficiently large ($k > v_i$ for all $i$, i.e., $k > \max(v_1, \ldots, v_L)$).

### 2.2. The Formalization Challenge

The difficulty is that `universal_case_a_general` is stated for the orbit numerators $R_i$ satisfying $R_{i+1} \cdot 2^{v_i} = 3R_i + D$, where $R_0 = \text{ghostR}(ds)$. The modular orbit elements $n_i$ satisfy $n_{i+1} \cdot 2^{v_i} \equiv 3n_i + 1 \pmod{2^k}$ for the Syracuse map itself, not the numerator recurrence.

The connection is: $n_i = R_i \cdot D^{-1} \bmod 2^k$ (from the exact equation $n_1 \cdot D = R$, so $R_i = n_i \cdot D$ in the rational orbit). At the modular level, $n_i \cdot D \equiv R_i \pmod{2^k}$.

The valuation stability argument is:

$3n_i + 1 = 3(R_i \cdot D^{-1} \bmod 2^k) + 1$

For $k > v_i$, the first $v_i$ bits of $3n_i + 1$ are determined by $n_i \bmod 2^{v_i}$, which equals $R_i \cdot D^{-1} \bmod 2^{v_i}$, which is the same regardless of $k$ (by solution refinement).

**This is fundamentally a modular arithmetic argument about bit truncation.** Formalizing it requires:

1. A statement that $v_2(x) \ge v$ is equivalent to $2^v \mid x$ (this is standard in Mathlib via `padicValNat`/`multiplicity`).
2. A statement that $v_2(x) = v$ depends only on $x \bmod 2^{v+1}$ (also standard).
3. The transfer: $n_i \bmod 2^{v_i+1}$ is the same for all $k \ge v_i + 1$.

### 2.3. Proposed Approach: Work Modularly, Avoid $v_2$

The existing codebase states valuation conditions as divisibility/non-divisibility pairs:

```
(2 : ℤ) ^ v ∣ (3 * R_i + D) ∧ ¬ (2 : ℤ) ^ (v + 1) ∣ (3 * R_i + D)
```

This is the right style. For the modular orbit, the analogous statement would be:

```
(2 : ℤ) ^ v ∣ (3 * n_i + 1) ∧ ¬ (2 : ℤ) ^ (v + 1) ∣ (3 * n_i + 1)
```

But proving this for $n_i$ from the statement about $R_i$ requires connecting $3n_i + 1$ to $3R_i + D$ modularly.

### 2.4. The Key Bridge Lemma

The relationship between the two recurrences:

- **Rational orbit:** $R_{i+1} \cdot 2^{v_i} = 3R_i + D$ (exact, over $\mathbb{Z}$)
- **Syracuse orbit:** $n_{i+1} \cdot 2^{v_i} = 3n_i + 1$ (exact, over $\mathbb{Z}$, for actual orbits)
- **Connection:** $R_i = n_i \cdot D$ (from the exact cycle equation and the numerator recurrence)

So $3R_i + D = 3n_i D + D = D(3n_i + 1)$. Since $D$ is odd, $v_2(3R_i + D) = v_2(D) + v_2(3n_i + 1) = 0 + v_2(3n_i + 1) = v_2(3n_i + 1)$.

**This means `universal_case_a_general` already proves valuation stability for the actual orbit elements, not just the numerators!** The theorem says $v_2(3R_i + D) = v_i$, and since $3R_i + D = D(3n_i + 1)$ with $D$ odd, this gives $v_2(3n_i + 1) = v_i$.

But wait --- this is for the *rational* orbit, where $n_i = R_i / D$ is a rational number. The modular orbit has $n_i \equiv R_i \cdot D^{-1} \pmod{2^k}$, which is an integer, not a rational.

### 2.5. The Modular Transfer

The actual modular valuation stability theorem should be:

**Claim.** Let $n_i \equiv R_i \cdot D^{-1} \pmod{2^k}$ with $k > v_i$. Then $v_2(3n_i + 1) \ge v_i$ and $v_2(3n_i + 1)$ is exactly $v_i$ if we additionally know $2^{v_i + 1} \nmid (3n_i + 1)$.

The issue is that $n_i$ is defined only modulo $2^k$, so $3n_i + 1$ is defined as an integer, and its 2-adic valuation depends on which representative we choose.

**The right formulation avoids $v_2$ entirely and works with divisibility:**

```lean
/-- Modular valuation stability.
    If the rational orbit has 2^v | (3R_i + D) and ¬ 2^{v+1} | (3R_i + D),
    and n_i satisfies n_i · D ≡ R_i (mod 2^k) with k > v,
    then 2^v | (3 · n_i + 1) and ¬ 2^{v+1} | (3 · n_i + 1).

    Key idea: 3R_i + D = D · (3n_i + 1) + 2^k · (something),
    and D odd means the low-order v bits of 3n_i + 1 match those of
    (3R_i + D) / D. -/
```

But this formulation is wrong as stated. The relationship $R_i = n_i \cdot D$ holds for the *rational* orbit. At the modular level, we have $n_i \cdot D \equiv R_i \pmod{2^k}$, so $D \cdot (3n_i + 1) = 3 n_i D + D \equiv 3R_i + D \pmod{2^k}$.

Since $D$ is odd, $\gcd(D, 2^k) = 1$, so $2^v \mid D(3n_i + 1) \Leftrightarrow 2^v \mid (3n_i + 1)$ for $v \le k$.

**Therefore:**

$$2^k \mid (n_i D - R_i) \implies 2^k \mid (D(3n_i + 1) - (3R_i + D))$$

So $D(3n_i + 1) \equiv 3R_i + D \pmod{2^k}$.

Since $D$ is odd, for $v \le k$: $2^v \mid (3n_i + 1) \Leftrightarrow 2^v \mid D(3n_i + 1) \Leftrightarrow 2^v \mid (3R_i + D)$.

This is the bridge we need, and it is clean.

### 2.6. Proposed Theorems

#### Theorem A: D·(3n+1) ≡ 3R+D mod 2^k

```lean
/-- Bridge between modular and rational valuations.
    If n·D ≡ R (mod 2^k), then D·(3n+1) ≡ 3R+D (mod 2^k). -/
theorem modular_valuation_bridge {D R n : ℤ} {k : ℕ}
    (h : (2 : ℤ) ^ k ∣ (n * D - R)) :
    (2 : ℤ) ^ k ∣ (D * (3 * n + 1) - (3 * R + D)) := by
  -- D·(3n+1) - (3R+D) = 3nD + D - 3R - D = 3(nD - R)
  have : D * (3 * n + 1) - (3 * R + D) = 3 * (n * D - R) := by ring
  rw [this]
  exact dvd_mul_of_dvd_right h 3
```

**Difficulty: EASY (< 15 minutes).** Pure algebra + one `ring` + one `dvd_mul_of_dvd_right`.

#### Theorem B: Valuation transfer (divisibility direction)

```lean
/-- Valuation transfer: if 2^v | (3R+D) and n·D ≡ R (mod 2^k) with v ≤ k,
    then 2^v | (3n+1).
    Uses: D odd, so 2^v | D·(3n+1) iff 2^v | (3n+1). -/
theorem valuation_transfer_dvd {D R n : ℤ} {k v : ℕ}
    (hD : Odd D) (hv : v ≤ k)
    (hmod : (2 : ℤ) ^ k ∣ (n * D - R))
    (hdvd : (2 : ℤ) ^ v ∣ (3 * R + D)) :
    (2 : ℤ) ^ v ∣ (3 * n + 1) := by
  -- 2^k | D·(3n+1) - (3R+D) from bridge
  -- 2^v | (3R+D) from hypothesis
  -- So 2^v | D·(3n+1)
  -- D odd → coprime to 2^v → 2^v | (3n+1)
  have hbridge := modular_valuation_bridge hmod
  have hbridge_v : (2 : ℤ) ^ v ∣ (D * (3 * n + 1) - (3 * R + D)) :=
    dvd_trans (pow_dvd_pow 2 hv) hbridge
  have : (2 : ℤ) ^ v ∣ (D * (3 * n + 1)) := by
    have := dvd_add hbridge_v hdvd
    have : D * (3 * n + 1) - (3 * R + D) + (3 * R + D) = D * (3 * n + 1) := by ring
    -- ... extract D * (3 * n + 1) divisibility
    sorry -- algebra to finish
  exact (odd_isCoprime_two_pow hD v).symm.dvd_of_dvd_mul_left this
```

**Difficulty: MEDIUM (30--60 minutes).** The divisibility algebra requires care with `dvd_add`/`dvd_sub` to extract $2^v \mid D(3n+1)$ from $2^v \mid (D(3n+1) - (3R+D))$ and $2^v \mid (3R+D)$. Then the coprimality step is one Mathlib call. The main effort is massaging the divisibility chain.

**Proof sketch (more detailed):**

1. From `hbridge_v`: $2^v \mid (D(3n+1) - (3R+D))$
2. From `hdvd`: $2^v \mid (3R+D)$
3. Therefore $2^v \mid (D(3n+1) - (3R+D) + (3R+D)) = D(3n+1)$
4. Since $\gcd(D, 2^v) = 1$ (from $D$ odd), $2^v \mid (3n+1)$

Step 3 uses `dvd_add`. Step 4 uses `IsCoprime.dvd_of_dvd_mul_left`.

#### Theorem C: Valuation transfer (non-divisibility direction)

```lean
/-- Valuation transfer: if ¬ 2^{v+1} | (3R+D) and n·D ≡ R (mod 2^k) with v+1 ≤ k,
    then ¬ 2^{v+1} | (3n+1). -/
theorem valuation_transfer_not_dvd {D R n : ℤ} {k v : ℕ}
    (hD : Odd D) (hv : v + 1 ≤ k)
    (hmod : (2 : ℤ) ^ k ∣ (n * D - R))
    (hndvd : ¬ (2 : ℤ) ^ (v + 1) ∣ (3 * R + D)) :
    ¬ (2 : ℤ) ^ (v + 1) ∣ (3 * n + 1) := by
  intro habs
  apply hndvd
  -- If 2^{v+1} | (3n+1), then 2^{v+1} | D·(3n+1) (since D is just a factor)
  -- And 2^{v+1} | (D·(3n+1) - (3R+D)) from bridge (since v+1 ≤ k)
  -- So 2^{v+1} | (3R+D)
  have hbridge := modular_valuation_bridge hmod
  have hbridge_v : (2 : ℤ) ^ (v + 1) ∣ (D * (3 * n + 1) - (3 * R + D)) :=
    dvd_trans (pow_dvd_pow 2 hv) hbridge
  have hdprod : (2 : ℤ) ^ (v + 1) ∣ (D * (3 * n + 1)) :=
    (odd_isCoprime_two_pow hD (v + 1)).symm.mul_dvd (dvd_refl D) habs
    -- ... or more directly: dvd_mul_of_dvd_right habs D ... need adjustment
  -- 3R+D = D·(3n+1) - (D·(3n+1) - (3R+D))
  sorry -- extract via dvd_sub
```

**Difficulty: MEDIUM (30--60 minutes).** Symmetric to Theorem B. The proof is a contrapositive: assume $2^{v+1} \mid (3n+1)$, then $2^{v+1} \mid D(3n+1)$ (since $D$ is just a factor, no coprimality needed here), and $2^{v+1} \mid (D(3n+1) - (3R+D))$ from the bridge, so $2^{v+1} \mid (3R+D)$ by subtraction.

**Actually, this direction is simpler because we do not need coprimality at all.** If $2^{v+1} \mid (3n+1)$, then $2^{v+1} \mid D(3n+1)$, and since $2^{v+1} \mid (D(3n+1) - (3R+D))$, we get $2^{v+1} \mid (3R+D)$.

#### Theorem D: Combined valuation stability

```lean
/-- Modular valuation stability (combined).
    The modular orbit inherits exact valuations from the rational orbit. -/
theorem modular_valuation_stable {D R n : ℤ} {k v : ℕ}
    (hD : Odd D) (hv : v + 1 ≤ k)
    (hmod : (2 : ℤ) ^ k ∣ (n * D - R))
    (hval : (2 : ℤ) ^ v ∣ (3 * R + D) ∧ ¬ (2 : ℤ) ^ (v + 1) ∣ (3 * R + D)) :
    (2 : ℤ) ^ v ∣ (3 * n + 1) ∧ ¬ (2 : ℤ) ^ (v + 1) ∣ (3 * n + 1) :=
  ⟨valuation_transfer_dvd hD (Nat.le_of_succ_le hv) hmod hval.1,
   valuation_transfer_not_dvd hD hv hmod hval.2⟩
```

**Difficulty: EASY (< 10 minutes).** Just pairs the two directions.

### 2.7. Assessment

The valuation transfer theorems (A--D) are all straightforward algebraic manipulations. The key insight --- that $D(3n_i+1) \equiv 3R_i + D \pmod{2^k}$ follows from $nD \equiv R \pmod{2^k}$ by a `ring` lemma --- makes this a clean, self-contained block. No Mathlib infrastructure beyond `IsCoprime.dvd_of_dvd_mul_left` and basic divisibility arithmetic is needed.

**Total estimated time for Section 2: 1--2 hours.** The `ring` and `omega` tactics should handle most of the algebra. The main risk is divisibility chain management (`dvd_add`, `dvd_sub`, sign issues).

---

## 3. Full Persistence Conclusion

### 3.1. Mathematical Content

**Paper Theorem 6:** If the ghost first appears at level $k_0$, then it reappears at all levels $k \equiv k_0 \pmod{p}$ with $k \ge k_0$.

The proof combines:
- (i) $n_1$ is odd --- already proved (`persistence_solution_odd`)
- (ii) Valuations match --- Theorems B--D above
- (iii) Cycle closure --- trivial from rational closure + modular reduction

### 3.2. What "Ghost Materializes at Level $k$" Means

We need to define what it means for a ghost to materialize at level $k$. The cleanest definition in the existing style:

```lean
/-- A ghost cycle (ds, D, R) materializes at level k if there exists an odd
    integer n₁ with n₁ · D ≡ R (mod 2^k), and the induced modular orbit
    has the correct valuation pattern. -/
def ghost_materializes (ds : List ℕ) (k : ℕ) : Prop :=
  ∃ n₁ : ℤ,
    (2 : ℤ) ^ k ∣ (n₁ * (2 ^ ds.sum - 3 ^ ds.length) - ghostR ds)
    ∧ Odd n₁
    ∧ ∀ i (hi : i < ds.length),
        (2 : ℤ) ^ ds.get ⟨i, hi⟩ ∣ (3 * n₁ + 1)  -- placeholder: needs orbit
```

**Problem:** The valuation condition involves the full orbit $n_1, n_2, \ldots, n_L$, not just $n_1$. Defining the modular orbit requires either:

(a) Building the orbit function from $n_1$ via the Syracuse recurrence, or
(b) Working with the orbit numerators $R_i$ and the modular reduction $n_i \equiv R_i \cdot D^{-1} \pmod{2^k}$.

Option (b) is cleaner because it connects directly to the existing infrastructure.

### 3.3. Avoiding the Full Orbit Definition

The paper's proof works at the level of the *rational* orbit and observes that modular reduction preserves the three conditions. We can follow this by not defining `ghost_materializes` as a formal predicate at all, but instead stating the persistence theorem as a chain of implications.

**The rational orbit already does all the work.** The existing `persistence_at_level` + `universal_case_a_general` + `orbit_all_odd` prove everything for the rational orbit numerators. The transfer to the modular orbit is exactly the valuation stability theorems from Section 2.

### 3.4. Proposed Structure

Rather than one monolithic theorem, the cleanest formalization is a sequence of lemmas that compose.

#### Step 1: The exact equation gives modular congruence (already proved)

This is `persistence_at_level` (trivially: $n_1 D = R \implies n_1 D \equiv R \pmod{2^k}$).

#### Step 2: The rational orbit induces a modular orbit with correct valuations

```lean
/-- The rational orbit (Theorems 7-9) induces modular valuations.
    If the rational orbit has 2^{v_i} || (3R_i + D) and n₁ · D ≡ R (mod 2^k)
    with k ≥ max(v_i) + 1, then the modular orbit has the same valuations.

    This theorem composes `universal_case_a_general` with `modular_valuation_stable`. -/
theorem persistence_valuations
    (ds : List ℕ) (hne : ds ≠ [])
    (hvalid : ∀ x ∈ ds, 0 < x)
    (hV : 1 ≤ ds.sum)
    (n₁ : ℤ)
    (hexact : n₁ * (2 ^ ds.sum - 3 ^ ds.length) = ghostR ds)
    (k : ℕ) (hk : ∀ i (hi : i < ds.length), ds.get ⟨i, hi⟩ + 1 ≤ k) :
    -- For each step i, the modular valuation is correct
    ∀ i (hi : i < ds.length),
      (2 : ℤ) ^ ds.get ⟨i, hi⟩ ∣ (3 * ... + 1)
      ∧ ¬ (2 : ℤ) ^ (ds.get ⟨i, hi⟩ + 1) ∣ (3 * ... + 1) := by
  sorry
```

**Problem:** The `...` must refer to the $i$-th element of the modular orbit, which requires defining the orbit. This is where the formalization becomes substantially harder.

### 3.5. The Orbit Definition Problem

**This is the main bottleneck.** To state the full persistence theorem, we need a function that takes $n_1$ and the deposit pattern $ds$ and produces the modular orbit $n_1, n_2, \ldots, n_L$ where each $n_{i+1} = (3n_i + 1) / 2^{v_i}$.

The rational orbit is defined as `R : ℕ → ℤ` with `R 0 = ghostR ds` and the recurrence `R (i+1) * 2^{v_i} = 3 * R i + D`. This is *given as a hypothesis*, not constructed.

To build the modular orbit, we would need:

```lean
/-- The modular orbit element at step i, given starting point n₁. -/
noncomputable def modOrbitElem (n₁ : ℤ) (ds : List ℕ) : ℕ → ℤ
  | 0 => n₁
  | i + 1 => if h : i < ds.length then
      (3 * modOrbitElem n₁ ds i + 1) / 2 ^ ds.get ⟨i, h⟩
    else 0
```

This is `noncomputable` because of the integer division, and worse, the orbit element $n_{i+1} = (3n_i + 1) / 2^{v_i}$ is only well-defined (as an integer) when $2^{v_i} \mid (3n_i + 1)$. Proving this divisibility is exactly the valuation stability condition, creating a circular dependency.

### 3.6. Breaking the Circularity

The paper sidesteps this by working with the rational orbit and then reducing modulo $2^k$. We can do the same:

**Approach:** Define the modular orbit via the rational orbit numerators and $D$:

$$n_i \equiv R_i \cdot D^{-1} \pmod{2^k}$$

Since $R_i$ is already defined (as the unique sequence satisfying the numerator recurrence with $R_0 = \text{ghostR}(ds)$), and $D^{-1} \bmod 2^k$ exists (from coprimality), we can define:

```lean
-- n_i is the unique solution to n_i · D ≡ R_i (mod 2^k)
-- Its existence is ghost_solution_exists; its uniqueness is ghost_solution_unique
```

But we do not need to *define* $n_i$ --- we can state theorems about any $n_i$ satisfying $n_i D \equiv R_i \pmod{2^k}$.

### 3.7. Revised Persistence Theorem (No Orbit Definition)

```lean
/-- **Theorem 6 (Persistence, operational form).**

    Given the rational orbit R satisfying the numerator recurrence
    and universal case-a, and given ANY sequence n₁, ..., n_L of integers
    with n_i · D ≡ R_i (mod 2^k), the following hold for k large enough:

    (1) Each n_i is odd.
    (2) 2^{v_i} | (3n_i + 1) and 2^{v_i+1} ∤ (3n_i + 1).
    (3) n_{L+1} ≡ n_1 (mod 2^k).

    These are the three conditions for the ghost to materialize at level k. -/
theorem persistence_theorem6
    (ds : List ℕ) (hne : ds ≠ [])
    (hvalid : ∀ x ∈ ds, 0 < x)
    (hV : 1 ≤ ds.sum)
    -- The rational orbit
    (R : ℕ → ℤ) (D : ℤ)
    (hD : D = 2 ^ ds.sum - 3 ^ ds.length)
    (hR0 : R 0 = ghostR ds)
    (hsteps : ∀ i (h : i < ds.length),
      R (i + 1) * 2 ^ ds.get ⟨i, h⟩ = 3 * R i + D)
    -- The modular approximations
    (n : ℕ → ℤ) (k : ℕ)
    (hmod : ∀ i (hi : i ≤ ds.length),
      (2 : ℤ) ^ k ∣ (n i * D - R i))
    -- Level is large enough
    (hk : ∀ i (hi : i < ds.length), ds.get ⟨i, hi⟩ + 1 ≤ k) :
    -- Conclusion (1): each n_i is odd
    (∀ i (hi : i ≤ ds.length), Odd (n i))
    -- Conclusion (2): valuations match
    ∧ (∀ i (hi : i < ds.length),
        (2 : ℤ) ^ ds.get ⟨i, hi⟩ ∣ (3 * n i + 1)
        ∧ ¬ (2 : ℤ) ^ (ds.get ⟨i, hi⟩ + 1) ∣ (3 * n i + 1))
    -- Conclusion (3): cycle closes modularly
    ∧ (2 : ℤ) ^ k ∣ (n ds.length - n 0) := by
  sorry
```

### 3.8. Proof Strategy for persistence_theorem6

**(1) Oddness:** For each $i$, `orbit_all_odd` gives `Odd (R i)`. From `hmod i` we have $n_i D \equiv R_i \pmod{2^k}$. The oddness of $n_i$ follows from `ghost_solution_odd` applied with $D$ odd and $R_i$ odd, provided $k \ge 1$.

Actually, `ghost_solution_odd` as currently stated requires the congruence to be $n \cdot D \equiv R \pmod{2^k}$ with $R$ fixed. Here $R$ varies with $i$. But the proof of `ghost_solution_odd_mod2` only uses parity, so we need: $2 \mid (n_i D - R_i)$, $D$ odd, $R_i$ odd $\implies$ $n_i$ odd. This is directly `ghost_solution_odd_mod2` applied with the appropriate $R_i$.

We need $k \ge 1$ (so that $2 \mid (n_i D - R_i)$ follows from $2^k \mid (n_i D - R_i)$). This follows from `hk` since all deposits are $\ge 1$, so $v_i + 1 \ge 2$, giving $k \ge 2 > 1$.

**Difficulty for (1): EASY (< 30 minutes).**

**(2) Valuations:** Apply `modular_valuation_stable` (Theorem D from Section 2) at each step $i$. The hypotheses are:
- $D$ odd: from `hD` and `ghostDenom_odd`.
- $v_i + 1 \le k$: from `hk`.
- $2^k \mid (n_i D - R_i)$: from `hmod`.
- The rational valuation condition: from `universal_case_a_general`.

**Difficulty for (2): MEDIUM (30--60 minutes).** The main work is threading the right hypotheses through `universal_case_a_general` and then applying the transfer. The `universal_case_a_general` theorem uses the numerator recurrence on $R$, which is provided as `hsteps`.

**(3) Cycle closure:** From `hmod ds.length` we get $2^k \mid (n(L) \cdot D - R(L))$. From the rational orbit, $R(L) = R(0) = \text{ghostR}(ds)$ (this follows from the orbit numerator iteration and the cycle equation; specifically, this is proved in `orbit_all_odd` at the $i = L$ case: $R(L) = \text{ghostR}(ds)$). Combined with `hmod 0`: $2^k \mid (n(0) \cdot D - R(0))$. So:

$$2^k \mid (n(L) \cdot D - R(L)) - (n(0) \cdot D - R(0)) = (n(L) - n(0)) \cdot D$$

Since $\gcd(D, 2^k) = 1$, we get $2^k \mid (n(L) - n(0))$.

**Difficulty for (3): EASY (< 20 minutes).** This is `ghost_solution_unique` applied to $n(L)$ and $n(0)$ with $R = R(0) = R(L)$.

### 3.9. The Hypothesis `hmod` is the Hard Part

The theorem `persistence_theorem6` assumes `hmod`: that there exist integers $n_i$ with $n_i D \equiv R_i \pmod{2^k}$. Where do these come from?

For $i = 0$: `ghost_solution_exists` gives $\exists n_0, 2^k \mid (n_0 D - R_0)$.

For $i > 0$: We need $n_i$ satisfying $n_i D \equiv R_i \pmod{2^k}$. Again, `ghost_solution_exists` gives this for any $R_i$.

But the theorem requires a *specific sequence* $n_0, n_1, \ldots, n_L$ that is simultaneously consistent with the modular Syracuse recurrence $n_{i+1} \cdot 2^{v_i} \equiv 3 n_i + 1 \pmod{2^{k - v_i}}$ (or something similar). Are independently chosen solutions automatically consistent?

**Yes, because the modular reduction of the rational orbit is consistent by construction.** If we define $n_i$ to be the unique solution to $n_i D \equiv R_i \pmod{2^k}$, then the recurrence $R_{i+1} \cdot 2^{v_i} = 3R_i + D$ (exact) implies:

$$n_{i+1} D \cdot 2^{v_i} \equiv (3R_i + D) \pmod{2^k \cdot 2^{v_i}}$$

No, this is not quite right. The modular recurrence is more subtle.

**Alternative approach: just take $n_i$ to be *any* representative satisfying $n_i D \equiv R_i \pmod{2^k}$.** The oddness, valuation, and closure conclusions all follow from the congruence, regardless of which representative is chosen. The theorem as stated is correct with `hmod` as a hypothesis.

**Constructing the witnesses:** The theorem `ghost_solution_exists` applied to each $R_i$ gives existence. We can package this:

```lean
/-- The modular orbit exists: for each step i, there exists n_i
    with n_i · D ≡ R_i (mod 2^k). -/
theorem modular_orbit_exists
    (ds : List ℕ) (hV : 1 ≤ ds.sum)
    (R : ℕ → ℤ) (k : ℕ) :
    ∃ n : ℕ → ℤ, ∀ i (hi : i ≤ ds.length),
      (2 : ℤ) ^ k ∣ (n i * (2 ^ ds.sum - 3 ^ ds.length) - R i) := by
  sorry -- needs Choice; straightforward but requires dependent choice/finite case
```

**Difficulty: MEDIUM (30--60 minutes).** This requires `Classical.choice` or a finite induction. Since $i$ ranges over $\{0, \ldots, L\}$, we can use `Fin.rec` or just apply `ghost_solution_exists` $L+1$ times. The cleanest Lean 4 approach might use `fun i => (ghost_solution_exists (R i) hD_odd k).choose`.

### 3.10 Total Difficulty Assessment for Section 3

| Component | Difficulty | Estimated Time |
|-----------|------------|----------------|
| Oddness (conclusion 1) | EASY | 20--30 min |
| Valuations (conclusion 2) | MEDIUM | 30--60 min |
| Closure (conclusion 3) | EASY | 15--20 min |
| Constructing witnesses | MEDIUM | 30--45 min |
| **Total** | | **~2--3 hours** |

---

## 4. What About Periodicity?

### 4.1. Does the Formalization Need $p = \mathrm{ord}_2(|D|)$?

The paper's Theorem 6 says the ghost reappears at levels $k \equiv k_0 \pmod{p}$. This has two parts:

(A) **Existence of materialization at large levels:** For $k$ large enough (specifically $k > \max(v_i)$), the ghost materializes.

(B) **Periodicity in $k$:** The materialization pattern repeats with period $p$.

Part (A) is the substantive content. It says: for any $k > \max(v_i)$, conditions (i)--(iii) hold. This is exactly `persistence_theorem6` above, and it does not mention $p$ at all.

Part (B) is about what happens when $k \le \max(v_i)$. At these low levels, some valuations are not captured (the level is too small to see $v_i$ bits), so the ghost may or may not appear. The period $p$ controls which low levels work.

### 4.2. Can We Skip Periodicity?

For a formalization of Theorem 6 as it appears in the paper, we need Part (B). But Part (B) is the weaker, more cosmetic part of the theorem. The strong mathematical content is Part (A).

**Recommendation:** Formalize Part (A) first. This is `persistence_theorem6` and is fully tractable. Part (B) can be added later if desired, using `exists_period` to instantiate $p$.

### 4.3. Periodicity (if pursued)

The periodicity claim is: if conditions (i)--(iii) hold at level $k_0$, they hold at $k_0 + p$.

This follows from: the unique solution $n_i(k)$ to $n_i D \equiv R_i \pmod{2^k}$ satisfies $n_i(k+p) \equiv n_i(k) \pmod{2^k}$ (solution refinement, already proved). So the bits of $n_i$ up to position $k-1$ are the same at level $k$ and $k+p$. If these bits satisfy the valuation conditions at level $k$, they satisfy them at level $k+p$.

To formalize this, we would need:

```lean
/-- If conditions (i)-(iii) hold at level k₀, they hold at level k₀ + p.
    This uses solution refinement (the low-order bits are the same)
    and the fact that the conditions depend only on bits up to position max(v_i). -/
theorem persistence_periodic
    (ds : List ℕ) (hne : ds ≠ [])
    (hvalid : ∀ x ∈ ds, 0 < x)
    (hV : 1 ≤ ds.sum)
    (k₀ p : ℕ)
    (hp : 0 < p)
    -- Ghost materializes at k₀
    (hmat : ghost_materializes ds k₀)
    -- Solution refinement at step p
    (hrefine : ∀ R : ℤ, ∀ n₁ n₂ : ℤ,
      (2 : ℤ) ^ k₀ ∣ (n₁ * D - R) →
      (2 : ℤ) ^ (k₀ + p) ∣ (n₂ * D - R) →
      (2 : ℤ) ^ k₀ ∣ (n₂ - n₁)) :
    ghost_materializes ds (k₀ + p) := by
  sorry
```

**Difficulty: HARD (2+ hours).** This requires defining `ghost_materializes` as a predicate (which involves the orbit, see Section 3.5), and the proof requires threading solution refinement through all three conditions. The conceptual content is straightforward but the Lean bookkeeping is substantial.

---

## 5. Recommended Implementation Order

### Phase 1: Bridge Lemmas (EASY, ~1 hour total)

1. `ghost_solution_level_refine` --- Section 1.3
2. `modular_valuation_bridge` --- Section 2.6, Theorem A

These are self-contained, short, and extend PersistenceFull.lean naturally.

### Phase 2: Valuation Transfer (MEDIUM, ~1.5 hours total)

3. `valuation_transfer_dvd` --- Section 2.6, Theorem B
4. `valuation_transfer_not_dvd` --- Section 2.6, Theorem C
5. `modular_valuation_stable` --- Section 2.6, Theorem D

These require Theorem A and the existing coprimality infrastructure. They form the core new mathematical content.

### Phase 3: Persistence Theorem (MEDIUM, ~2 hours total)

6. `persistence_theorem6` --- Section 3.7

This composes Phase 2 with existing theorems. The main work is threading hypotheses correctly.

### Phase 4 (Optional): Periodicity

7. Define `ghost_materializes` predicate
8. `persistence_periodic` --- Section 4.3

This is the final polish but is not needed for the core mathematical content.

---

## 6. Mathlib Dependencies

All proposed theorems use only:

| Mathlib component | Import | Used for |
|---|---|---|
| `IsCoprime` | `Mathlib.RingTheory.Coprime.Lemmas` | Coprimality and cancellation |
| `pow_dvd_pow` | `Mathlib.Algebra.Order.Ring.Lemmas` (or `Mathlib.Tactic`) | Divisibility chains |
| `dvd_add`, `dvd_sub` | Basic algebra | Divisibility arithmetic |
| `dvd_mul_of_dvd_right` | Basic algebra | Factor introduction |
| `Int.not_odd_iff_even` | `Mathlib.Algebra.Ring.Parity` | Parity arguments |
| `ring`, `omega`, `linarith` | `Mathlib.Tactic` | Automation |

No new Mathlib imports are needed beyond what PersistenceFull.lean already uses. In particular:

- We do **not** need `ZMod` (the `exists_period` proof uses it internally, but none of the new theorems do).
- We do **not** need `padicValNat` (valuations are expressed as divisibility pairs).
- We do **not** need `orderOf` or multiplicative order infrastructure (the period $p$ is handled via `exists_period` which is already proved).

---

## 7. What Would Be Prohibitively Hard

### 7.1. Formalizing the full modular orbit as a dependent type

Defining `modOrbitElem n₁ ds k : ℕ → ℤ` where each step requires a divisibility proof from the previous step creates a dependent-type nightmare. The existing codebase wisely avoids this by taking the orbit as a hypothesis (`R : ℕ → ℤ` with recurrence assumptions). The proposed formalization follows the same pattern.

### 7.2. Proving $p = \mathrm{ord}_2(|D|)$ is the MINIMAL period

The existing `exists_period` proves existence of *some* $p > 0$ with $|D| \mid (2^p - 1)$. Proving this $p$ is the *multiplicative order* (the smallest such) would require `orderOf` from Mathlib's group theory and showing `orderOf (2 : (ZMod n)ˣ) = p`. This is doable but adds substantial overhead for no mathematical payoff in the persistence theorem.

### 7.3. Constructing modular orbits that satisfy the Syracuse recurrence

Showing that $n_i = R_i \cdot D^{-1} \bmod 2^k$ actually satisfies $n_{i+1} \cdot 2^{v_i} \equiv 3n_i + 1 \pmod{2^{k-v_i}}$ requires careful modular arithmetic about how division by $2^{v_i}$ interacts with reduction mod $2^k$. This is conceptually routine but formalizing modular division is notoriously tedious in proof assistants.

**The proposed formalization completely avoids this** by working with the congruence $n_i D \equiv R_i \pmod{2^k}$ rather than the Syracuse recurrence on $n_i$ directly.

---

## 8. Circularity Check

The proposed proof chain has no circularity:

1. `ghostDenom_odd` (Basic.lean) --- standalone
2. `odd_isCoprime_two_pow` (PersistenceFull.lean) --- uses (1)
3. `ghost_solution_exists/unique` (PersistenceFull.lean) --- uses (2)
4. `ghost_solution_odd` (PersistenceFull.lean) --- uses parity only
5. `orbit_all_odd` (GeneralOrbit.lean) --- uses `ghostR_append`, independent of (1)--(4)
6. `universal_case_a_general` (GeneralOrbit.lean) --- uses (5) + `case_a_step`
7. `modular_valuation_bridge` (NEW) --- pure algebra, no dependencies beyond `dvd`
8. `valuation_transfer_dvd/not_dvd` (NEW) --- uses (2) + (7)
9. `persistence_theorem6` (NEW) --- uses (3), (4), (5), (6), (8)

No theorem in the chain references itself or a later theorem. The dependency graph is a DAG.

---

## 9. What Gets Renamed

Per the reviewer's recommendation, `persistence_full` should be renamed to `exact_equation_mod_and_odd` or `exact_cycle_divisibility_and_oddness`. Its current name and docstring are misleading --- it proves a trivially true divisibility statement ($2^k \mid 0$) combined with oddness, not persistence in the sense of Theorem 6.

Similarly, `ghost_solution_refines` (which is just transitivity of divisibility) should be demoted to a `have` inside any proof that uses it, or renamed to `dvd_of_higher_pow_dvd` to avoid the misleading "refines" terminology.

---

## 10. Tractability Summary

| Theorem | Difficulty | Time | Single session? |
|---------|-----------|------|-----------------|
| `ghost_solution_level_refine` | EASY | 10 min | Yes |
| `modular_valuation_bridge` | EASY | 15 min | Yes |
| `valuation_transfer_dvd` | MEDIUM | 45 min | Yes |
| `valuation_transfer_not_dvd` | MEDIUM | 45 min | Yes |
| `modular_valuation_stable` | EASY | 10 min | Yes |
| `persistence_theorem6` | MEDIUM | 90 min | Yes |
| `persistence_periodic` | HARD | 3+ hours | Possibly not |
| **Total (Phases 1--3)** | | **~3.5 hours** | **Yes** |

Phases 1--3 bring the formalization from ~45% to ~85% of Theorem 6. Phase 4 (periodicity) would bring it to ~95%, but is substantially harder due to the need for a `ghost_materializes` predicate.

The remaining ~5% (minimality of the period, primitivity of the cycle) is cosmetic and can be deferred indefinitely without weakening the mathematical content.
