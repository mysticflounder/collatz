# Lean 4 Formalization Review: Theorems 7--9 (General Orbit, Negative Rationality, Universal Case-a)

**Reviewer:** Claude Opus 4.6 (mathematics professor, dynamical systems/spectral theory/p-adic analysis)
**Date:** 2026-03-23
**Files reviewed:**
- `lean/GhostCycles/Syracuse/GhostRAppend.lean` -- ghostR append decomposition
- `lean/GhostCycles/Syracuse/GeneralOrbit.lean` -- orbit_all_odd, universal_case_a_general, etc.
- `lean/GhostCycles/Syracuse/OrbitFormula.lean` -- generalized iteration (dependency)
- `lean/GhostCycles/Syracuse/Persistence.lean` -- ghostR_odd (dependency)
- `lean/GhostCycles/Syracuse/CycleEquation.lean` -- ghostR definition (dependency)
- `lean/GhostCycles/Syracuse/Basic.lean` -- three_pow_odd, parity lemmas (dependency)
- `docs/arxiv-paper-a.md`, lines 1089--1186 (Theorems 7--9)

---

## Summary Verdict

The formalization is **largely correct and mathematically sound**, with two fully proved
theorems (`orbit_all_odd`, `universal_case_a_general`) and one honest `sorry`
(`negative_rationality_general`).

- `orbit_all_odd` is a **correct, non-circular proof** of the oddness of all orbit
  numerators. It uses a different (and arguably more elegant) strategy than the paper,
  but proves exactly the same statement.
- `universal_case_a_general` is a **faithful formalization of Theorem 9**, with the
  2-adic valuation characterization correctly expressed as divisibility + non-divisibility.
- `negative_rationality_general` (Theorem 8) remains `sorry` and **cannot** be proved
  by the same ghostR_append technique without significant additional work.

The simplified proof is **weaker** than the paper's proof in one specific respect: it does
not establish Theorem 8 (positivity of $R_i$). This is an honest gap, clearly marked.

---

## A. Is the proof of `orbit_all_odd` correct?

**Yes. The proof is mathematically sound and non-circular.**

### Proof strategy (reconstructed from the Lean)

The proof splits on whether $i < L$ or $i = L$.

**Case $i = L$:** The orbit formula gives $R(L) \cdot 2^V = 3^L \cdot R(0) + D \cdot \text{ghostR}(ds)$.
Substituting $R(0) = \text{ghostR}(ds)$ and $D = 2^V - 3^L$:

$$R(L) \cdot 2^V = 3^L \cdot \text{ghostR}(ds) + (2^V - 3^L) \cdot \text{ghostR}(ds) = 2^V \cdot \text{ghostR}(ds)$$

so $R(L) = \text{ghostR}(ds)$, which is odd by `ghostR_odd` (since $v_1 \geq 1$). Correct.

**Case $i < L$:** This is the substantial case. The proof:

1. **Splits** $ds = \text{take}(i) \mathbin{+\!\!+} \text{drop}(i)$.

2. **Applies** `ghostR_append`:
   $$\text{ghostR}(ds) = 3^{L-i} \cdot \text{ghostR}(\text{take}) + 2^{S_i} \cdot \text{ghostR}(\text{drop})$$

3. **Applies** `orbit_numerator_iteration` to the prefix (first $i$ steps):
   $$R(i) \cdot 2^{S_i} = 3^i \cdot R(0) + D \cdot \text{ghostR}(\text{take})$$

4. **Substitutes** $R(0) = \text{ghostR}(ds)$ and expands using step 2:
   $$R(i) \cdot 2^{S_i} = 3^i \cdot \bigl[3^{L-i} \cdot \text{ghostR}(\text{take}) + 2^{S_i} \cdot \text{ghostR}(\text{drop})\bigr] + D \cdot \text{ghostR}(\text{take})$$
   $$= (3^L + D) \cdot \text{ghostR}(\text{take}) + 3^i \cdot 2^{S_i} \cdot \text{ghostR}(\text{drop})$$

5. **Uses the cancellation** $3^L + D = 2^V$:
   $$R(i) \cdot 2^{S_i} = 2^V \cdot \text{ghostR}(\text{take}) + 3^i \cdot 2^{S_i} \cdot \text{ghostR}(\text{drop})$$
   $$= 2^{S_i} \cdot \bigl[2^{V - S_i} \cdot \text{ghostR}(\text{take}) + 3^i \cdot \text{ghostR}(\text{drop})\bigr]$$

6. **Cancels** $2^{S_i}$ (nonzero):
   $$R(i) = 2^{V - S_i} \cdot \text{ghostR}(\text{take}) + 3^i \cdot \text{ghostR}(\text{drop})$$

7. **Concludes**: The first summand is even (since $V - S_i \geq 1$, because $\text{drop}(i)$ has
   positive sum). The second summand is odd ($3^i$ is odd and $\text{ghostR}(\text{drop})$ is odd
   by `ghostR_odd`, since $\text{drop}(i)$ starts with $v_{i+1} \geq 1$). Even + odd = odd.

### Verification of each step

| Step | Claim | Verification |
|------|-------|-------------|
| `ghostR_append` | $\text{ghostR}(a \mathbin{+\!\!+} b) = 3^{|b|} \cdot \text{ghostR}(a) + 2^{\text{sum}(a)} \cdot \text{ghostR}(b)$ | Proved by induction on $a$ in `GhostRAppend.lean`. Base case: $\text{ghostR}(b) = 0 + 2^0 \cdot \text{ghostR}(b)$. Inductive step: distribute, apply IH, `ring`. **Correct.** |
| `orbit_numerator_iteration` | $R(L) \cdot 2^V = 3^L \cdot R(0) + D \cdot \text{ghostR}(ds)$ | Proved in `OrbitFormula.lean` as a specialization of `generalized_iteration`. **Correct** (reviewed in previous Lean review). |
| Cancellation $3^L + D = 2^V$ | From $D = 2^V - 3^L$ | Immediate by `ring`. **Correct.** |
| $V - S_i \geq 1$ | $\text{drop}(i)$ has positive sum | Since $\text{drop}(i)$ is nonempty (because $i < L$) and all elements are positive, its sum is at least 1. Therefore $V = S_i + \text{sum}(\text{drop}(i)) \geq S_i + 1$. **Correct.** |
| ghostR(drop) is odd | First element of drop is $\geq 1$ | Since $i < L$, $\text{drop}(i)$ is nonempty with head $v_{i+1} \geq 1$ (by `hvalid`). Then `ghostR_odd` applies. **Correct.** |
| Even + odd = odd | Standard parity | `Even.add_odd` from Mathlib. **Correct.** |

### Non-circularity

This is the critical question. The proof could be circular if, for example, it assumed
the recurrence $R(i+1) \cdot 2^{v_i} = 3 R(i) + D$ and then used it to *derive* oddness,
while the recurrence itself depended on oddness (as it does in the Syracuse dynamics,
where $v_i = v_2(3R_i + D)$ depends on $R_i$ being odd to guarantee $v_i \geq 1$).

**The proof avoids this circularity entirely.** The recurrence is taken as a *hypothesis*
(`hsteps`), not derived from the Syracuse map. The proof says: "IF some sequence $R$
satisfies this recurrence with these step sizes, THEN every $R(i)$ is odd." It does not
claim that the recurrence holds because of the Syracuse dynamics. It is a purely algebraic
statement about sequences satisfying a given linear recurrence.

The paper's Theorem 9 proof takes the same non-circular approach: define $R_i^*$ by the
closed form, then *prove* the recurrence as a consequence. The Lean takes the dual
approach: assume the recurrence, prove oddness. Both are valid and non-circular.

**Verdict: Correct, non-circular, fully machine-checked.**

---

## B. Does `universal_case_a_general` faithfully prove Theorem 9?

**Yes.**

### Paper's Theorem 9 statement

> $v_2(3R_i + D) = v_i$ for all $i = 1, \ldots, L$.

### Lean's statement

```lean
theorem universal_case_a_general ... :
    (2 : Z) ^ ds.get <i, hi> | (3 * R i + D)
    /\ ~ (2 : Z) ^ (ds.get <i, hi> + 1) | (3 * R i + D)
```

### Are these equivalent?

**Yes.** For an integer $n$ and a positive integer $v$, the 2-adic valuation
$v_2(n) = v$ is equivalent to:
$$2^v \mid n \quad \text{and} \quad 2^{v+1} \nmid n.$$

This is the standard definition of exact divisibility. The Lean formulation uses exactly
this characterization. Since $v_i \geq 1$ (from `hvi : 0 < ds.get ...`), we are in
the regime where $v_i$ is a positive integer and the characterization is valid.

Note: The equivalence also holds for $v = 0$ (meaning $n$ is odd), where it says
$1 \mid n$ and $2 \nmid n$, which is just oddness. So the Lean statement is correct
even without the $v_i \geq 1$ hypothesis, though the proof uses it.

### Proof structure

`universal_case_a_general` is a clean two-step composition:

1. Call `orbit_all_odd` to get $\text{Odd}(R(i+1))$.
2. Call `case_a_step` with the recurrence, oddness of $R(i+1)$, and $v_i \geq 1$.

`case_a_step` itself is straightforward:
- **Divisibility:** $3R_i + D = R_{i+1} \cdot 2^{v_i}$ (from the recurrence), so $2^{v_i} \mid (3R_i + D)$.
- **Exactness:** If $2^{v_i + 1} \mid (3R_i + D)$, then since $3R_i + D = 2^{v_i} \cdot R_{i+1}$, we'd need $2 \mid R_{i+1}$, contradicting oddness.

This mirrors the paper's argument (3) exactly:
> $v_2(3R_i^* + D) = v_2(2^{v_i} \cdot R_{i+1}^*) = v_i + v_2(R_{i+1}^*) = v_i + 0 = v_i$.

**Verdict: Faithful formalization of Theorem 9. The 2-adic valuation is correctly
characterized by the divisibility pair.**

---

## C. Is the simplified proof STRONGER or WEAKER than the paper's proof?

**The Lean proof is WEAKER in one specific respect and EQUIVALENT in all others.**

### What the paper proves (Theorems 7--9)

| Result | Paper status | Lean status |
|--------|-------------|-------------|
| Theorem 7 (Orbit formula: closed-form double-sum for $R_i$) | Proved | Not directly formalized as a closed form; the orbit recurrence and iteration formula are proved instead |
| Theorem 8 (Negative rationality: $R_i > 0$ when $D < 0$) | Proved (each summand in the double-sum is positive) | `sorry` |
| Theorem 9 (Universal Case-a: $v_2(3R_i + D) = v_i$) | Proved | **Proved** (via oddness + recurrence) |
| Oddness of $R_i$ (key lemma for Theorem 9) | Proved (exactly one summand has 2-exponent 0) | **Proved** (via ghostR_append + cancellation) |

### The gap: Theorem 8

The paper's proof of Theorem 8 relies on the explicit double-sum formula (Theorem 7):

$$R_i = \underbrace{\sum_{j=0}^{i-2} 2^{V + S_j - S_{i-1}} \cdot 3^{i-2-j}}_{\text{Term I}} + \underbrace{\sum_{j=i-1}^{L-1} 3^{L+i-2-j} \cdot 2^{S_j - S_{i-1}}}_{\text{Term II}}$$

Every summand is a product of non-negative powers of 2 and 3, hence positive. Therefore
$R_i \geq 1 > 0$.

The Lean proof uses a different representation of $R(i)$:
$$R(i) = 2^{V - S_i} \cdot \text{ghostR}(\text{take}(i)) + 3^i \cdot \text{ghostR}(\text{drop}(i))$$

While `ghostR_nonneg` is proved (line 25--33 of `GeneralOrbit.lean`), showing that each
summand here is non-negative, this only gives $R(i) \geq 0$, not $R(i) > 0$. To get strict
positivity, one would need to show that $\text{ghostR}(\text{drop}(i)) > 0$ (not just $\geq 0$),
which requires showing that the leading term $3^{L-i-1}$ in the ghostR expansion dominates.
This is provable but has not been done.

**This is an honest gap.** The Lean formalization correctly marks it with `sorry` and does
not depend on it for Theorem 9.

### Why the gap does not affect Theorem 9

Theorem 9 requires only oddness ($R_i$ is odd), not positivity ($R_i > 0$). The Lean
proof of `orbit_all_odd` is self-contained and does not invoke `negative_rationality_general`.
The dependency chain is:

```
orbit_all_odd  (fully proved)
    |
    v
case_a_step  (fully proved)
    |
    v
universal_case_a_general  (fully proved, no sorry in transitive closure)
```

```
negative_rationality_general  (sorry, independent branch)
```

There is no contamination: the `sorry` in `negative_rationality_general` does not
propagate to `universal_case_a_general`.

### Comparison of proof strategies for oddness

| Aspect | Paper | Lean |
|--------|-------|------|
| Representation of $R_i$ | Explicit double-sum (Theorem 7) | $2^{V-S_i} \cdot \text{ghostR}(\text{take}) + 3^i \cdot \text{ghostR}(\text{drop})$ |
| Oddness argument | Exactly one summand has 2-exponent 0 | even + odd = odd |
| Positivity argument | Every summand is a positive power of 2 times a positive power of 3 | Not proved |
| Key algebraic tool | Index manipulation in the double sum | `ghostR_append` decomposition + cancellation $3^L + D = 2^V$ |

Both proofs establish oddness. The Lean proof is arguably more modular (the ghostR_append
lemma is reusable), while the paper's proof gives more information (individual summand
structure). Neither is strictly better for the oddness claim alone.

**Verdict: The Lean proof is weaker than the paper overall (it lacks Theorem 8), but it
is complete for Theorem 9. The oddness proof is an alternative route to the same
conclusion, neither stronger nor weaker for what it claims.**

---

## D. Can `negative_rationality_general` be proved using ghostR_append?

**Not directly. The ghostR_append technique is insufficient for strict positivity
without additional lemmas.**

### What would be needed

From the factored form proved in `orbit_all_odd`:
$$R(i) = 2^{V - S_i} \cdot \text{ghostR}(\text{take}(i)) + 3^i \cdot \text{ghostR}(\text{drop}(i))$$

Both summands are non-negative (by `ghostR_nonneg`). To show $R(i) > 0$, it suffices to
show at least one summand is strictly positive. The natural candidate is the second:

$$3^i \cdot \text{ghostR}(\text{drop}(i)) > 0$$

Since $3^i > 0$, this reduces to $\text{ghostR}(\text{drop}(i)) > 0$.

### Why ghostR > 0 is not yet proved

`ghostR_nonneg` gives $\text{ghostR}(ds) \geq 0$. For strict positivity of a nonempty
list with positive entries, we need:

$$\text{ghostR}(v :: vs) = 3^{|vs|} + 2^v \cdot \text{ghostR}(vs) \geq 3^{|vs|} \geq 1 > 0$$

This is straightforward: $3^{|vs|} \geq 1$ for all $|vs| \geq 0$, and $2^v \cdot \text{ghostR}(vs) \geq 0$
by `ghostR_nonneg`. So $\text{ghostR}(v :: vs) \geq 1 > 0$.

### Suggested proof path

A proof of `negative_rationality_general` could proceed as follows:

1. **Prove `ghostR_pos`:** For any nonempty list, $\text{ghostR}(ds) > 0$.
   This is a one-line strengthening of `ghostR_nonneg`: $3^{|vs|} \geq 1$.

2. **Reuse the factored form from `orbit_all_odd`:** Extract the identity
   $R(i) = 2^{V-S_i} \cdot \text{ghostR}(\text{take}) + 3^i \cdot \text{ghostR}(\text{drop})$
   as a standalone lemma (it is currently embedded in the `orbit_all_odd` proof).

3. **Combine:** Since $\text{drop}(i)$ is nonempty for $i < L$, $\text{ghostR}(\text{drop}(i)) > 0$
   by `ghostR_pos`, so $3^i \cdot \text{ghostR}(\text{drop}(i)) > 0$, so $R(i) > 0$.
   For $i = L$, $R(L) = \text{ghostR}(ds) > 0$ by `ghostR_pos`.

**Note:** This proof does NOT use the hypothesis $D < 0$. It shows $R(i) > 0$ for ALL
compositions of $V$ into $L$ positive parts, regardless of the sign of $D$. This is
consistent with the paper: Theorem 8 as stated requires $D < 0$, but the double-sum
formula shows $R_i > 0$ unconditionally. The paper restricts to $D < 0$ because that
is the case where positivity of $R_i$ implies negativity of $\tilde{n}_i = R_i / D$
(the ghost orbit elements), which is the physically meaningful conclusion.

### Assessment

The `sorry` in `negative_rationality_general` could likely be resolved with modest
additional work (a `ghostR_pos` lemma plus refactoring the factored-form identity out
of `orbit_all_odd`). The ghostR_append technique IS sufficient for positivity, but the
existing code needs two small additions: (1) strict positivity of ghostR, and
(2) extraction of the factored form as a reusable lemma.

**Verdict: The sorry is resolvable. The ghostR_append technique suffices, but two
additional lemmas are needed. Estimated effort: 20--40 lines of Lean.**

---

## E. Additional Observations

### E.1. ghostR_nonneg placement

`ghostR_nonneg` is proved in `GeneralOrbit.lean` but is a general fact about the ghostR
function. It would be more natural in `CycleEquation.lean` or `Persistence.lean`,
alongside `ghostR_odd`. Minor organizational point, no correctness impact.

### E.2. The `hsteps_prefix` construction

In `orbit_all_odd` (lines 113--121), the proof constructs step relations for the prefix
`ds.take i` by showing that `(ds.take i).get j = ds.get j` for $j < i$. This uses
`List.getElem_take'`, which is a standard Mathlib lemma. The construction is correct:
the recurrence on the first $i$ steps depends only on the first $i$ entries of $ds$,
and the prefix extraction preserves these.

### E.3. The `hReq` derivation

The algebraic derivation of $R(i) = 2^{V-S_i} \cdot \text{ghostR}(\text{take}) + 3^i \cdot \text{ghostR}(\text{drop})$
(lines 160--209) is the technical heart of the proof. It proceeds by:

1. Showing $2^{S_i} \cdot R(i) = 2^{S_i} \cdot (\text{target expression})$
2. Cancelling $2^{S_i}$ via `mul_left_cancel_0`

This avoids natural-number subtraction issues (Lean's `Nat.sub` is truncating), which
is the right approach. The proof explicitly constructs the necessary power-of-2 split
$2^V = 2^{S_i} \cdot 2^{V - S_i}$ and the power-of-3 recombination
$3^i \cdot 3^{L-i} = 3^L$, then closes with `ring` and `linarith`. All steps are valid.

### E.4. Hypothesis comparison with paper

The Lean's `orbit_all_odd` takes the recurrence as a hypothesis, while the paper's
Theorem 9 defines $R_i^*$ by the closed form and derives the recurrence. These are
logically equivalent approaches:

- **Paper:** Define $R_i^*$ by closed form. Prove recurrence. Prove oddness from closed form. Conclude $v_2$.
- **Lean:** Assume recurrence. Prove $R(0) = \text{ghostR}(ds)$ (which IS the closed form for $i=0$, as $\text{ghostR}(ds) = \sum 3^{L-1-j} \cdot 2^{S_j}$). Use ghostR_append to propagate. Prove oddness. Conclude $v_2$.

Both ultimately rest on the same algebraic identity. The paper is self-contained
(defines, then derives). The Lean is conditional (assumes, then derives). The Lean
approach is natural for a formalization: the hypotheses can be discharged by anyone
who provides a valid orbit.

---

## F. Summary Table

| Component | Status | Correct? | Faithful to paper? |
|-----------|--------|----------|-------------------|
| `ghostR_append` | Proved | Yes | New lemma, not in paper |
| `ghostR_nonneg` | Proved | Yes | Implicit in paper's Theorem 8 proof |
| `case_a_step` | Proved | Yes | Matches paper's argument (3) |
| `orbit_all_odd` | Proved | Yes | Alternative proof strategy, same conclusion |
| `negative_rationality_general` | `sorry` | N/A | Gap vs paper's Theorem 8 |
| `universal_case_a_general` | Proved | Yes | Faithful to Theorem 9 |

### What is machine-verified (no sorry in transitive closure)

> For any nonempty list $ds$ of positive naturals, any function $R : \mathbb{N} \to \mathbb{Z}$,
> and any integer $D = 2^V - 3^L$: if $R(0) = \text{ghostR}(ds)$ and the recurrence
> $R(i+1) \cdot 2^{v_i} = 3 R(i) + D$ holds for each step, then:
>
> 1. Every $R(i)$ is odd (for $0 \leq i \leq L$).
> 2. $2^{v_i} \mid (3R(i) + D)$ and $2^{v_i+1} \nmid (3R(i) + D)$ for each $i < L$.
>
> Equivalently, $v_2(3R(i) + D) = v_i$ for all $i$.

### What remains unverified

> $R(i) > 0$ when $D < 0$ (Theorem 8). Marked with `sorry`. Resolvable with modest
> additional work (ghostR strict positivity + lemma extraction).

### Grade: A-

The formalization is correct and complete for its central claim (Theorem 9 / Universal
Case-a). The `sorry` for Theorem 8 is an honest, clearly-marked gap that does not
compromise the verified results. The ghostR_append proof technique is a clean
alternative to the paper's double-sum analysis, trading individual-summand information
for algebraic modularity.
