# Lean 4 Review: Theorem 6 (Persistence of Case-(a) Ghosts)

**File under review:** `lean/GhostCycles/Syracuse/PersistenceFull.lean`
**Reviewer role:** Mathematics professor (dynamical systems, spectral theory, p-adic analysis)
**Date:** 2026-03-23

---

## 1. Paper Statement (Reference)

Theorem 6 in the paper states:

> Let $(L, V, (v_1, \ldots, v_L))$ be a case-(a) ghost with denominator $D = 2^V - 3^L$ and let $p = \mathrm{ord}_2(|D|)$ be the multiplicative order of $2$ modulo $|D|$. If the ghost first appears at level $k_0$, then it reappears at all levels $k \equiv k_0 \pmod{p}$ with $k \geq k_0$.

The proof in the paper proceeds through three verification conditions at level $k$:

1. **Oddness:** $n_1 = \tilde{n}_1 \bmod 2^k$ is odd.
2. **Valuation stability:** For each step $i$, $v_2(3n_i + 1) = v_i$ when $k > v_i$.
3. **Cycle closure:** $n_{L+1} \equiv n_1 \pmod{2^k}$ because the rational orbit closes.

And the **periodicity claim:** since $D^{-1} \bmod 2^k$ is periodic in $k$ with period dividing $p = \mathrm{ord}_2(|D|)$, the three conditions are periodic in $k$ with the same period.

---

## 2. Theorem Inventory

The file contains 15 theorems organized into 6 parts. Here is the complete inventory with verdicts.

### Part 1: Coprimality (2 theorems)

| # | Theorem | Statement | Verdict |
|---|---------|-----------|---------|
| 1 | `odd_isCoprime_two` | $D$ odd $\Rightarrow$ $\gcd(D, 2) = 1$ | **Correct, clean.** Constructive Bezout witness. |
| 2 | `odd_isCoprime_two_pow` | $D$ odd $\Rightarrow$ $\gcd(D, 2^k) = 1$ for all $k$ | **Correct.** Lifts coprimality via `IsCoprime.pow_right`. |

These are standard number theory lemmas. No issues.

### Part 2: Modular Solution Existence and Uniqueness (4 theorems)

| # | Theorem | Statement | Verdict |
|---|---------|-----------|---------|
| 3 | `coprime_mod_solution_exists` | $\gcd(D, M) = 1 \Rightarrow \exists n,\ M \mid (nD - R)$ | **Correct.** Constructive: $n = Ra$ where $aD + bM = 1$. |
| 4 | `coprime_mod_solution_unique` | $\gcd(D, M) = 1$, $M \mid (n_1 D - R)$, $M \mid (n_2 D - R) \Rightarrow M \mid (n_1 - n_2)$ | **Correct.** Standard cancellation argument. |
| 5 | `ghost_solution_exists` | $D$ odd $\Rightarrow \exists n_1,\ 2^k \mid (n_1 D - R)$ | **Correct.** Specialization of #3. |
| 6 | `ghost_solution_unique` | Uniqueness of ghost solution mod $2^k$ | **Correct.** Specialization of #4. |

Well-structured. The general-then-specialize pattern is good practice.

### Part 3: Oddness of the Solution (2 theorems)

| # | Theorem | Statement | Verdict |
|---|---------|-----------|---------|
| 7 | `ghost_solution_odd_mod2` | $D$ odd, $R$ odd, $2 \mid (n_1 D - R) \Rightarrow n_1$ odd | **Correct.** Parity contradiction via omega. |
| 8 | `ghost_solution_odd` | Same for $2^k \mid (n_1 D - R)$ with $k \geq 1$ | **Correct.** Reduces to mod 2 case. |

These establish paper condition (i). Clean proofs.

### Part 4: Solution Refinement (1 theorem)

| # | Theorem | Statement | Verdict |
|---|---------|-----------|---------|
| 9 | `ghost_solution_refines` | $2^{k+m} \mid (n_1 D - R) \Rightarrow 2^k \mid (n_1 D - R)$ | **Correct but trivial.** This is just transitivity of divisibility. |

This is the "obvious direction" of refinement. The paper's actual refinement claim is subtler: solutions at level $k+p$ **extend** solutions at level $k$ (the 2-adic digits agree), which requires the periodicity of $D^{-1}$. See Section 5 below.

### Part 5: Full Persistence (2 theorems)

| # | Theorem | Statement | Verdict |
|---|---------|-----------|---------|
| 10 | `persistence_full` | Exact equation $n_1 D = R \Rightarrow 2^k \mid (n_1 D - R)$ and $n_1$ odd | **SPECIFICATION GAP** (see below) |
| 11 | `persistence_solution_odd` | Any modular solution $n_1$ to $n_1 D \equiv R \pmod{2^k}$ is odd (for $k \geq 1$) | **Correct for what it states.** |

### Part 6: Euler-Lagrange Periodicity (4 theorems)

| # | Theorem | Statement | Verdict |
|---|---------|-----------|---------|
| 12 | `natAbs_odd_of_odd` | $D$ odd $\Rightarrow |D|$ odd as a natural number | **Correct.** Wrapper around Mathlib. |
| 13 | `two_coprime_natAbs` | $D$ odd $\Rightarrow \gcd(2, |D|) = 1$ | **Correct.** |
| 14 | `exists_period` | $D$ odd, $|D| > 1 \Rightarrow \exists p > 0,\ |D| \mid (2^p - 1)$ | **Correct, well-executed.** Uses Lagrange's theorem on the unit group $(\mathbb{Z}/|D|\mathbb{Z})^\times$. |

The Euler-Lagrange theorem (theorem 14) is a genuine and non-trivial result. The proof is well-structured: construct $2$ as a unit in $(\mathbb{Z}/n\mathbb{Z})^\times$, apply `pow_card_eq_one`, then carefully cast back to integer divisibility. This is the strongest single theorem in the file.

---

## 3. Specification Gaps

### 3.1. The Main Gap: `persistence_full` (Theorem 10)

**What the name and docstring promise:** "Theorem 6 (Persistence, algebraic core)" --- the ghost materializes at all sufficiently large levels.

**What it actually proves:** If $n_1 \cdot D = R$ holds as an *exact integer equation*, then:
- (1) $2^k \mid (n_1 D - R)$ for all $k$, and
- (2) $n_1$ is odd.

**The problem:** Claim (1) is vacuously true. If $n_1 D = R$ exactly, then $n_1 D - R = 0$, and every integer divides zero. The proof reflects this: it rewrites via `hexact` and calls `simp`. There is no mathematical content in part (1) of this theorem.

The theorem is not *wrong* --- it is a true statement --- but it proves something much weaker than Theorem 6 of the paper. Theorem 6 is about the *modular* solutions $n_1 \equiv R \cdot D^{-1} \pmod{2^k}$ (which are different integers for different $k$), not about a single rational/integer solution $n_1 = R/D$.

Part (2), the oddness of $n_1$, *is* substantive and correct. It uses the fact that $n_1 D = R$ with $D$ odd and $R$ odd forces $n_1$ odd, via a parity argument.

**Severity:** Moderate. The theorem should be renamed or its docstring corrected to reflect that it proves "the exact equation implies divisibility (trivially) and oddness of the exact solution." It should not be described as the persistence theorem.

### 3.2. Missing: Periodicity of $D^{-1} \bmod 2^k$

The paper's key periodicity claim is:

> $D^{-1} \bmod 2^{k+p} \equiv D^{-1} \bmod 2^k \pmod{2^k}$

This is what makes persistence periodic in $k$ with period $p = \mathrm{ord}_2(|D|)$. The file proves that such a $p$ exists (`exists_period`) but never proves that $D^{-1} \bmod 2^k$ is $p$-periodic, nor that the modular solution $n_1(k) = R \cdot D^{-1} \bmod 2^k$ repeats with period $p$.

### 3.3. Missing: Valuation Stability (Paper condition (ii))

The paper requires: for each step $i$, $v_2(3n_i + 1) = v_i$ where $n_i = \tilde{n}_i \bmod 2^k$. This holds when $k > v_i$ because the first $v_i$ bits of $3n_i + 1$ match those of $3\tilde{n}_i + 1$.

This is not formalized. The file's Part 5 references `universal_case_a_general` in a comment but does not connect it to the modular setting.

### 3.4. Missing: Cycle Closure at Level $k$ (Paper condition (iii))

The paper requires $n_{L+1} \equiv n_1 \pmod{2^k}$. This follows from $\tilde{n}_{L+1} = \tilde{n}_1$ (rational closure) and the fact that modular reduction commutes with equality. This is trivially true but is not stated or proved.

### 3.5. Missing: The Full Periodicity Conclusion

The paper's punchline: if the ghost materializes at level $k_0$, then it materializes at all levels $k \equiv k_0 \pmod{p}$ with $k \geq k_0$. This conclusion is never stated in the file.

---

## 4. What IS Proven vs. What the Paper Claims

| Paper Claim | Formalized? | Notes |
|---|---|---|
| $D$ odd $\Rightarrow$ modular inverse exists mod $2^k$ | **Yes** | Theorems 1--6 |
| Solution $n_1 \equiv R D^{-1} \pmod{2^k}$ is unique | **Yes** | Theorem 6 |
| Solution $n_1$ is odd (for $k \geq 1$) | **Yes** | Theorems 7--8, 11 |
| Higher-level solutions refine lower-level ones | **Partially** | Only the trivial direction (Theorem 9) |
| $\exists\, p > 0$ with $|D| \mid (2^p - 1)$ | **Yes** | Theorem 14 |
| $D^{-1} \bmod 2^k$ is $p$-periodic in $k$ | **No** | |
| Valuation stability: $v_2(3n_i+1) = v_i$ at level $k$ | **No** | Referenced in comments only |
| Cycle closure at level $k$ | **No** | |
| Full periodicity: ghost reappears at $k \equiv k_0 \pmod{p}$ | **No** | |

**Assessment:** Roughly 40--50% of Theorem 6's content is formalized. The algebraic prerequisites (coprimality, existence/uniqueness/oddness of solutions, existence of the period $p$) are all solid. The dynamical conclusions (valuation stability, periodicity of materialization) are absent.

---

## 5. Proof Quality

### Strengths

1. **`exists_period` is excellent.** The proof navigates the Mathlib interface for finite groups, ZMod units, and casting between natural and integer divisibility with precision. The use of Lagrange's theorem via `pow_card_eq_one` is the right approach.

2. **`coprime_mod_solution_exists` is constructive.** The Bezout witness $n = Ra$ is computed explicitly, not just asserted to exist. This is good formalization practice.

3. **`ghost_solution_odd_mod2` is clean.** The parity argument is direct and the omega finish is appropriate.

4. **Modular organization.** The 6-part structure with section comments is clear and follows a logical progression.

### Weaknesses

1. **`persistence_full` part (1) is a no-op.** The statement $2^k \mid (n_1 D - R)$ given $n_1 D = R$ is $2^k \mid 0$, which is trivially true. This inflates the theorem count without adding content.

2. **Redundancy with `Persistence.lean`.** The original file already has `persistence_modular` (exact equation implies modular congruence) and `persistence_at_level` (with orbits). The new file's `persistence_full` essentially re-proves the same trivial observation with a conjunction.

3. **`ghost_solution_refines` is trivial.** Divisibility by $2^{k+m}$ implies divisibility by $2^k$ is a one-line consequence of transitivity. This should not be presented as a "refinement" theorem --- the interesting refinement (2-adic compatibility of solutions at different levels) is not what this proves.

4. **`persistence_solution_odd` duplicates work.** The oddness argument in `persistence_full` and `persistence_solution_odd` repeat the same $D$-odd/$R$-odd extraction. These could share a common lemma.

---

## 6. Recommendations

### High Priority

1. **Rename `persistence_full` to something like `exact_equation_implies_mod_and_odd`.** Its current name and docstring are misleading. It does not prove persistence in the sense of Theorem 6.

2. **Formalize the periodicity of $D^{-1} \bmod 2^k$.** This is the mathematical core of Theorem 6 that is missing. Specifically: using `exists_period`, prove that $D^{-1} \bmod 2^{k+p} \equiv D^{-1} \bmod 2^k \pmod{2^k}$. This requires showing that $|D| \mid (2^p - 1)$ implies $D \cdot D^{-1} \equiv 1 \pmod{2^k}$ has solutions whose 2-adic digits repeat with period $p$.

3. **State and prove the full persistence conclusion.** After periodicity is established, state: if the ghost materializes at level $k_0$ (meaning: $n_1$ is odd, valuations match, orbit closes), then it materializes at every $k \equiv k_0 \pmod{p}$ with $k \geq k_0$.

### Medium Priority

4. **Connect valuation stability to `universal_case_a_general`.** The existing theorem proves $v_2(3R_i + D) = v_i$ for the rational orbit numerators. A transfer principle is needed: the modular reduction $n_i = R_i \bmod 2^k$ inherits the same valuations when $k$ is large enough. This is the content of paper condition (ii).

5. **Remove or downgrade `ghost_solution_refines`.** It is a one-liner that does not merit theorem status in its current form. If kept, rename to `dvd_of_dvd_pow_add` or similar to avoid implying a deeper refinement result.

### Low Priority

6. **Consolidate oddness proofs.** Extract a shared lemma for "extract $D$-odd and $R$-odd from deposit pattern hypotheses" to reduce duplication between `persistence_full` and `persistence_solution_odd`.

---

## 7. Summary

The file provides solid algebraic infrastructure for Theorem 6: coprimality of $D$ with powers of 2, existence and uniqueness of modular solutions, oddness of solutions, and the Euler-Lagrange theorem guaranteeing the existence of a multiplicative period $p$. The `exists_period` proof is the highlight --- it is non-trivial and well-executed.

However, the file does not prove Theorem 6 as stated in the paper. The central claim --- that ghost cycles reappear periodically with period $p = \mathrm{ord}_2(|D|)$ --- is absent. The theorem named `persistence_full` proves a trivially true divisibility statement (anything divides zero) combined with an oddness result. The periodicity of $D^{-1} \bmod 2^k$, valuation stability at finite levels, and the full persistence conclusion are all missing.

**Bottom line:** The file formalizes necessary *prerequisites* for Theorem 6 but not Theorem 6 itself. It should be understood as "infrastructure for persistence" rather than "persistence proved."
