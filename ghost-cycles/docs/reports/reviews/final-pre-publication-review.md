# Final Pre-Publication Review: "Ghost Cycles of the Syracuse Map"

**Paper:** `docs/arxiv-paper-a.md` (v3, March 2026)
**Reviewer:** Independent mathematics review (dynamical systems, spectral theory, p-adic analysis)
**Date:** 2026-03-12
**Scope:** Final sweep before arXiv submission, including status check on three previously identified issues

---

## Part 1: Status of Previously Identified Issues

### Issue (a) --- Archimedean non-compactness, "clopen" error

**Status: FIXED (PASS)**

The proof of Proposition 6 (lines 1220--1237) no longer mentions "clopen sets." The argument now correctly constructs finite disjoint sets $S_+$ and $S_-$ of branch images, proves disjointness via a 2-adic valuation parity argument, and invokes the Tietze extension theorem to obtain the test function $f_{r,N} \in C(\mathbb{Z}_2^{\mathrm{odd}})$. The sets $S_+, S_-$ are finite (hence closed in the compact Hausdorff space $\mathbb{Z}_2^{\mathrm{odd}}$), and Tietze applies since compact Hausdorff spaces are normal. The proof is now correct.

### Issue (b) --- Archimedean non-compactness, $f$ depends on $r$

**Status: FIXED (PASS)**

The test function is now explicitly named $f_{r,N}$ (line 1229--1230), making the dependence on the pair $(x,y)$ (and hence on $r$) explicit. The proof correctly shows that the gap $|(\mathcal{L}f_{r,N})(x) - (\mathcal{L}f_{r,N})(y)| \geq 1 - \tfrac{7}{3} \cdot 4^{-N}$ is "independent of $r$" (line 1236), which is the essential point for non-equicontinuity. No issue remains.

### Issue (c) --- Primitivity remark, distinctness justification

**Status: FIXED (PASS)**

The Primitivity remark (lines 728--740) now gives the correct argument: "materialization at level $k_0$ with period exactly $L$ means the $L$ modular residues $n_1, \ldots, n_L$ are distinct modulo $2^{k_0}$; since $n_i \equiv \tilde{n}_i \pmod{2^{k_0}}$, the rational elements are pairwise distinct." This is the standard lift-from-modular-distinctness argument and is correct. The remark further notes that each difference $\tilde{n}_i - \tilde{n}_j$ has a fixed 2-adic valuation, ensuring distinctness persists at all sufficiently large $k$. No issue remains.

---

## Part 2: Full Final Sweep

### Section 1 (Introduction)

**PASS.** The abstract accurately reflects the paper's contents. The phrase "providing strong evidence" (line 31) is appropriately hedged for a conjecture supported by computation. The contributions list (items 1--9) correctly matches the paper's results. The outline (lines 138--149) accurately describes the section contents.

One gap noted:

**Finding 1 --- Contributions list omits Proposition 6. (MINOR)**

The abstract (lines 14--15) highlights the archimedean non-compactness result ("A third obstruction, proved by non-equicontinuity, shows $\mathcal{L}$ is also not compact on $C(\mathbb{Z}_2^{\mathrm{odd}}, \mathbb{R})$"), but the numbered contributions list (items 1--9, lines 86--107) does not include Proposition 6 among the contributions. Since the abstract presents it as a key result, the contributions list should include it --- e.g., as item (3b) or a separate item between (3) and (4).

### Section 2 (Definitions and Setup)

**PASS.** Definitions 1--5 are standard and correct. Proposition 1 (valuation distribution) with its proof is a well-known folklore result, correctly stated and attributed. The parametric family remark (lines 215--219) appropriately scopes the paper.

### Section 3 (Transfer Operator on $\mathbb{Z}_2^{\mathrm{odd}}$)

**PASS.** The projective limit remark (lines 231--241) clarifies the domain of the preimage sum. The exceptional point $n = -1/3$ is properly noted (line 225--227). Lemma 1 (preimage structure) is correctly proved. Proposition 2 (operator norm $2/3$) is a clean computation. Proposition 3 (spectral radius $\leq 1/2$) correctly defers to Theorem 1(e) with an explicit non-circularity note.

Theorem 1 (spectral properties): Parts (a)--(d) and (f) are straightforward. Part (e), the claim $\sigma(\mathcal{L}) = \overline{\bigcup_{k \geq 2} \sigma(P_k)}$, follows from a standard projective limit / approximate eigenvalue argument. The proof sketch (lines 348--366) correctly identifies the key ingredients: $\mathcal{L}$ does not preserve $A_k$ but acts on it via the projected matrix $P_k$, and density of $\bigcup A_k$ in $C(\mathbb{Z}_2^{\mathrm{odd}})$ (Stone--Weierstrass) gives both directions of the spectral approximation. The forward reference to Theorem 5 for $\sup = \limsup$ (lines 367--370) is noted as non-circular. No issues.

### Section 4 (Lasota--Yorke Obstruction)

**PASS.** Theorem 2 is clean: $f = \mathbf{1}$ is Lipschitz, but $\mathcal{L}(\mathbf{1}) = W$ is not, with explicit divergent pairs. Corollary 1 extends to all H\"older, BV, and modulus-of-continuity spaces. The root cause remark correctly identifies the mod-3 oscillation mechanism.

### Section 5 (2-Adic Unboundedness Obstruction)

**Finding 2 --- Stale "remains open" for archimedean compactness. (MODERATE)**

The "Common root cause" remark (lines 527--538) ends with: "the question of whether $\mathcal{L}$ is compact on this space remains open." This is false as of v3: Proposition 6 (Section 12, lines 1216--1237) proves $\mathcal{L}$ is not compact on $C(\mathbb{Z}_2^{\mathrm{odd}}, \mathbb{R})$. The remark should be updated to say something like: "the question of whether $\mathcal{L}$ is compact on this space is resolved negatively in Proposition~\ref{prop:not-compact} below." This is an internal inconsistency that a referee would flag immediately.

Theorem 3 (2-adic unboundedness) and Corollary 2 are correct. The proof that $\max_j v(j) = k + O(1)$ via the bijectivity of multiplication by 3 modulo $2^{k-1}$ is clean.

### Section 6 (Exhaustive Cycle Enumeration)

**PASS.** The enumeration results through $k = 36$ are clearly presented. The table entries are internally consistent (e.g., $k = 12$ with two extra cycles of lengths 7 and 6 matches the eigenvalue table in Section 10 showing 14 nonzero eigenvalues = 1 + 7 + 6).

### Section 7 (Ghost Cycles as 2-Adic Periodic Orbits)

**PASS.** Theorem 4 (cycle equation) is a standard result, correctly stated with attribution to Steiner (1977) and Wirsching (1998). The derivation $n_1(2^V - 3^L) = R$ is straightforward. The observation that $D$ is always odd and nonzero (line 621) is correct: $2^V$ is even, $3^L$ is odd, so $D$ is odd; and $\gcd(2^V, 3^L) = 1$ means they cannot be equal.

Definition 6 (ghost type, case-(a)/(b)) is clear. Conjecture 1 (universal case-(a)) is properly stated and its verification status (exhaustive through $L = 12$, sampled through $L = 20$) is clearly described.

**Finding 3 --- Pair count 91 not corrected to 105. (MODERATE)**

Line 665 states: "This conjecture has been verified exhaustively for all 91 $(L, V)$ pairs with $L = 2, \ldots, 15$." However, the number of $(L, V)$ pairs with $L+1 \leq V \leq 2L-1$ for $L = 2, \ldots, 15$ is $\sum_{L=2}^{15}(L-1) = \sum_{j=1}^{14} j = 105$, not 91. The v3 changelog (line 1350) explicitly claims this was "corrected pair count from 91 to 105 for $L = 2,\ldots,15$," but the correction was not applied to the body text. The number 91 is wrong and must be changed to 105.

Theorem 5 (persistence of case-(a) ghosts): The proof is correct. The valuation stability argument (lines 703--707) correctly shows that case-(a) conditions are $k$-independent. The periodicity of $D^{-1} \bmod 2^k$ with period $p = \mathrm{ord}_2(|D|)$ is the 2-adic analogue of periodic decimal expansions for rationals. The verification conditions (i)--(iii) at each level $k$ are correctly argued.

The Primitivity remark is now correct (as noted in Part 1 above).

Propositions 4--5 (Baker--W\"ustholz bounds): The statement of Proposition 4 is consistent with the Baker--W\"ustholz (1993) theorem as refined by Laurent (2008). Proposition 5 correctly explains why bounded-length ghosts are detectable within a computable range.

### Section 8 (Census of Ghost Types)

**PASS.** The census table is well-organized. The notation distinction between $r$ (residue classes where any pattern materializes) and $r_{\mathrm{conc}} / r_{\mathrm{nonc}}$ (count of canonical patterns) is explicitly clarified in the "Notation" paragraph (lines 888--896). The $V = L+1$ family table is internally consistent. The observation that $L = 9$ and $L = 11$ do not materialize despite being case-(a) is correctly attributed to the equidistribution heuristic ($p/2^L$).

### Section 9 (Density and Spectral Radius)

**PASS.** The density formula (Conjecture 2) is correctly stated as a lower bound (product formula) with the caveat about shared period factors. The algebraic membership scan (lines 986--995) is correctly described as testing membership in the known catalogue, not an exhaustive search. Conjecture 3 (spectral radius) correctly states the current proved bounds $2^{-16/15} \leq \rho(\mathcal{L}) \leq 1/2$. Conjecture 4 (negative rationality) is appropriately scoped to $D < 0$ ghost types.

Theorem 6 (negative rationality for concentrated patterns): I verified the proof in detail:
- The substitution $Q_i = 2^{i-1} R_i$ correctly linearizes the recurrence.
- The general solution $Q_i = C \cdot 3^{i-1} - D \cdot 2^{i-1}$ is correct (particular solution via undetermined coefficients).
- The initial condition $R_1 = 3^L - 2^L$ is correctly derived from the geometric series.
- The constant $C = 2^L(2^e - 1)$ follows from $Q_1 = R_1 = C - D$.
- Orbit closure $(3R_L + D)/2^{e+1} = R_1$ verifies directly (I confirmed algebraically).
- Positivity: first term has $2^{L-i+1}(2^e-1) \cdot 3^{i-1} > 0$; second term $3^L - 2^{L+e} > 0$ since $D < 0$. Correct.
- Oddness of $R_i$: for $i < L$, $v_2(\text{first term}) = L - i + 1 \geq 2$ and second term is odd, so $R_i$ is odd. For $i = L$, $v_2(\text{first term}) = 1$ and second term is odd, so $R_i = 2 \cdot \text{odd} + \text{odd} = \text{odd}$. Correct.
- Case-(a) verification: for $i < L$, $v_2(3R_i + D) = 1 + v_2(R_{i+1}) = 1 + 0 = 1 = v_i$. For $i = L$, $v_2(3R_L + D) = e + 1 = v_L$. Correct.

The byproduct that case-(a) holds for all $e \geq 1$ (not only $D < 0$) is correctly stated: the oddness/valuation argument is sign-independent.

The remark following Conjecture 4 (lines 1076--1090) correctly distinguishes between $D < 0$ (ghost orbits, addressed by Conjecture 4) and $D > 0$ (would-be positive-integer cycles, addressed by Baker-type exclusion results of Steiner and Simons--de Weger). No overclaiming.

### Section 10 (Eigenvalue Spectra)

**PASS.** The eigenvalue table is consistent with the cycle data from Section 6. The Fredholm determinant statement (line 1128) is correct for the stated non-exceptional case.

### Section 11 (Computational Methodology)

**PASS.** Standard methodology, clearly described. The note about sparse eigensolvers producing artifacts (lines 1174--1177) is an important caveat.

### Section 12 (Discussion)

Proposition 6 (archimedean non-compactness): Correct, as analyzed in Part 1 above. The proof strategy (non-equicontinuity via finite branch truncation and Tietze extension) is sound.

The "Both archimedean and 2-adic obstructions are now closed" (line 1239) is appropriate.

The projective limit discussion (lines 1241--1257) correctly identifies materialization as the weakest link in the argument for $\sigma(\mathcal{L}) \supseteq [1/4, 1/2]$. This is stated as a conditional chain, not a theorem.

### References

**PASS.** All cited works are correctly attributed. The Kontorovich--Lagarias (2010) entry correctly lists Lagarias as editor. Siegel citations use appropriate year labels.

### Version History

**Finding 4 --- Version history claims a correction not applied. (MINOR)**

The v3 changelog (line 1350) claims "corrected pair count from 91 to 105 for $L = 2,\ldots,15$" but line 665 still reads 91. This is the same issue as Finding 3 but noted here as a version-history integrity concern.

---

## Part 3: Summary of Findings

| # | Location | Severity | Description |
|---|----------|----------|-------------|
| 1 | Lines 86--107 | MINOR | Contributions list omits Proposition 6 (archimedean non-compactness), despite the abstract highlighting it |
| 2 | Lines 536--537 | MODERATE | "remains open" for archimedean compactness is stale; resolved by Proposition 6 in the same paper |
| 3 | Line 665 | MODERATE | Pair count says 91, should be 105; v3 changelog claims this was fixed but fix was not applied |
| 4 | Line 1350 | MINOR | Version history integrity: claims correction that was not applied (same as Finding 3) |

All three previously identified issues (a), (b), (c) are **FIXED**.

No critical errors found. No circularity detected. No claims exceeding what is proved. All theorems/propositions have complete proofs. Cross-references are accurate (modulo Finding 2). Abstract matches body.

---

## Bottom-Line Recommendation

**Submit after fixing Findings 2 and 3.** Both are straightforward text edits (one sentence and one number). Neither requires any mathematical revision.

Specifically:
1. **Finding 2:** In the "Common root cause" remark (Section 5), replace "the question of whether $\mathcal{L}$ is compact on this space remains open" with a forward reference to Proposition 6 (e.g., "this question is resolved negatively in Proposition~\ref{prop:not-compact} below").
2. **Finding 3:** On line 665, change "91" to "105".
3. **(Optional) Finding 1:** Add Proposition 6 to the contributions list.
4. **(Optional) Finding 4:** Verify that all v3 changelog claims match the actual text.

After these repairs, the paper is ready for arXiv submission.
