# Pre-Submission Review v3: "Ghost Cycles of the Syracuse Map"

**Reviewer:** Mathematics professor (dynamical systems/spectral theory/p-adic analysis)
**Date:** 2026-03-11
**Document:** `docs/arxiv-paper-a.md`
**Scope:** Full checklist review of v2, confirming v2 fixes and identifying new issues.

---

## Confirmed Fixes (from v2 review)

1. **[v2 Issue #1, Critical] Abstract "establishing" overstatement (lines 28--30).**
   FIXED. The abstract now reads "providing strong evidence that the entire
   high-spectral-radius regime ... consists of purely negative 2-adic orbits with no
   positive-integer elements, as Conjecture 4 asserts" (lines 29--31). The distinction
   between what is proved (concentrated patterns) and what is conjectured (all $D < 0$)
   is now clear.

2. **[v2 Issue #2, Moderate] Contributions list missing Theorem 6.**
   FIXED. Contribution (9) at lines 102--105 explicitly describes Theorem 6 and
   its case-(a) byproduct.

3. **[v2 Issue #3, Moderate] Outline missing Theorem 6 in Section 9 description.**
   FIXED. Lines 144--146 now read "and an unconditional proof of negative rationality
   for concentrated patterns (Theorem 6)."

4. **[v2 Issue #4, Moderate] Theorem 1(c) simplicity unqualified.**
   FIXED. Lines 307--310 now state "simplicity is verified computationally" explicitly,
   both in the theorem statement and its proof.

5. **[v2 Issue #5, Moderate] Case-(a) byproduct scope restricted to $D < 0$.**
   FIXED. Lines 988--991 add a parenthetical: "The case-(a) argument uses only the
   oddness of $R_i$ and $v_2$ conditions, which are independent of the sign of $D$;
   hence case-(a) holds for all concentrated patterns with $e \geq 1$, not only those
   with $D < 0$."

6. **[v2 Issue #6, Moderate] "Conjecture 4 shows."**
   FIXED. Line 1022 now reads "Conjecture 4 asserts."

7. **[v2 Issue #7, Moderate] "$R_i > 0$ always" misleading.**
   FIXED. Lines 1024--1026 now properly qualify: "$R_1 > 0$ is a sum of positive terms,
   and for $D > 0$ the recurrence ... preserves positivity."

8. **[v2 Issue #8, Minor] $v_2 \geq 1$ should be $\geq 2$ for $i < L$.**
   FIXED. Line 1007 now reads "$v_2 = L - i + 1 \geq 2$ for $i < L$ (since
   $i \leq L-1$)."

9. **[v2 Issue #9, Minor] Fredholm determinant degree.**
   PARTIALLY FIXED. See Moderate issue below.

10. **[v2 Issue #10, Minor] $L$ vs $\mathcal{L}$ notation.**
    FIXED. Explicit disambiguation at line 599: "(Throughout, $L$ denotes cycle length;
    $\mathcal{L}$ denotes the transfer operator.)" Placed inside Definition 6, which is
    the first location where both symbols appear in close proximity. Sufficient.

---

## Critical (fix before submission)

None found.

---

## Moderate (should fix)

1. **[Lines 1069--1070] Fredholm determinant degree: ambiguous parenthetical.**
   The sentence reads: "polynomial in $z$ of degree at most $N = 2^{k-1}$ (equal to
   the number of nonzero eigenvalues of $P_k$)."

   The parenthetical "(equal to the number of nonzero eigenvalues of $P_k$)" is
   grammatically attached to "$N = 2^{k-1}$", making it read as "$N$ equals the number
   of nonzero eigenvalues." This is false: $N = 2^{k-1}$ is the matrix dimension, not
   the number of nonzero eigenvalues. For non-exceptional $k$, the matrix is
   $N \times N$ but has only 1 nonzero eigenvalue.

   The intent is that the *degree* equals the number of nonzero eigenvalues, with
   "$\leq N$" being the trivial upper bound. The v2 fix addressed the original error
   ("of degree $N$") but introduced this new ambiguity.

   **Fix:** Rewrite as: "polynomial in $z$ of degree equal to the number of nonzero
   eigenvalues of $P_k$ (at most $N = 2^{k-1}$)."

2. **[Lines 341--343] $\sup_k \rho_k = \limsup_{k \to \infty} \rho_k$ is unjustified
   at this point in the paper.**
   The proof of Theorem 1(e) states: "$\rho(\mathcal{L}) = \sup_k \rho_k =
   \limsup_{k \to \infty} \rho_k$ (equality holds because $\rho_k \leq 1/2$ for all $k$)."

   The first equality $\rho(\mathcal{L}) = \sup_k \rho_k$ follows correctly from
   $\sigma(\mathcal{L}) = \overline{\bigcup \sigma(P_k)}$. However, the second equality
   $\sup_k \rho_k = \limsup_k \rho_k$ does not follow from boundedness alone. The
   $\limsup$ can be strictly less than the $\sup$ if the supremum is achieved at only
   finitely many levels. Counterexample: $\rho_k = 1/2$ at $k = 10$ and
   $\rho_k = 1/4$ for all other $k$ gives $\sup = 1/2$ but $\limsup = 1/4$.

   The equality does become justified by Theorem 5 (persistence): case-(a) ghosts
   reappear periodically, so any spectral radius achieved at one level is achieved
   infinitely often. But Theorem 5 appears in Section 7, four sections later, and the
   proof here cites only boundedness.

   **Fix:** Either (a) remove the $= \limsup_{k \to \infty} \rho_k$ claim from this
   proof and state it later (after Theorem 5) as a corollary, or (b) replace the
   parenthetical with "(equality of $\sup$ and $\limsup$ follows from Theorem 5 below,
   which shows that each $\rho_k > 1/4$ reappears at infinitely many levels; this
   forward reference does not create circularity since Theorem 5 is independent of
   Theorem 1)."

3. **[Line 1237] Incorrect editor in Kontorovich--Lagarias reference.**
   The reference lists "Bentley, P. et al. (eds.)" as editors of *The Ultimate Challenge:
   The $3x+1$ Problem*. The sole editor of this AMS volume is Jeffrey C. Lagarias. No
   "Bentley" is associated with this publication. Additionally, the standard citation year
   for this volume is 2010 (AMS publication date), not 2009.

   **Fix:** Replace with: Kontorovich, A. and Lagarias, J. (2010). Stochastic Models
   for the $3x+1$ and $5x+1$ Problems and Beyond. In Lagarias, J. C. (ed.), *The
   Ultimate Challenge: The $3x+1$ Problem*, AMS, pp. 131--188.

---

## Minor (polish)

1. **[Lines 100--101] Contributions list order differs from conjecture numbering.**
   Item (8) lists the four conjectures in the order: density of $E$ (Conj 2), spectral
   radius (Conj 3), negative rationality (Conj 4), universal case-(a) (Conj 1). The
   paper numbers them 1, 2, 3, 4. A referee might briefly wonder whether the numbering
   is intentional. Consider reordering the list to match: "universal case-(a), density
   of $E$, spectral radius, and negative rationality."

2. **[Lines 905--906] "clearly visible" in figure caption.**
   The single instance of "clearly" in the paper ("The periodic structure of case-(a)
   ghosts is clearly visible") is visual description, not a mathematical claim. No
   change needed, but some referees flag any instance of "clearly" reflexively.
   Consider replacing with "is visible" or "is evident" if desired.

3. **[Lines 232--236] Lemma 1 enumeration uses (a), (b), (c).**
   The labels (a), (b), (c) here refer to the three cases of $n \bmod 3$, not to be
   confused with the case-(a)/case-(b) classification of ghost types introduced later
   in Definition 6 (line 597). The two uses of (a)/(b) are in different contexts, but
   a referee reading linearly might create a momentary false association. Consider
   relabeling the Lemma 1 cases as (i), (ii), (iii) to avoid any potential confusion.

4. **[Line 342] Extraneous colon in spectral radius equality.**
   The phrase "$\rho_k \leq 1/2$ for all $k$: eigenvalues of $P_k$ are $L$th roots..."
   uses a colon where a comma or em-dash would be more standard in mathematical writing.
   Purely stylistic.

---

## Checklist Summary

### 1. Abstract <-> Body Consistency
All claims verified. Quantitative values ($\|\mathcal{L}\| = 2/3$, $\rho \leq 1/2$,
$k = 36$, $k = 200$, 88+, $L = 12$, 5,996, $\rho \geq 2^{-16/15}$, density $\geq 4\%$)
match the body exactly. All four conjectures mentioned in abstract appear in body. The
v1 "establishing" overstatement is corrected.

### 2. Contributions List <-> Body
All 9 items verified. Each has a corresponding result in the body. Theorem numbers
cited (2, 3, 6) are correct. No phrasing exceeds what is proved.

### 3. Outline <-> Section Structure
All 12 sections exist and match their outline descriptions. Section numbers are correct.
Cross-references verified: Section 7 (case-a/b), Section 9 (Theorem 6), Section 12
(discussion).

### 4. Theorem/Proof Completeness
All proofs verified for Theorems 1--6, Propositions 1--5, Lemma 1, Corollaries 1--2.
One issue: Theorem 1(e) proof makes an unjustified claim ($\sup = \limsup$); see
Moderate #2. No circularity detected. Theorem 6 proof is correct in all steps.

### 5. Theorem Numbering and Cross-References
All `\setcounter` values traced and verified correct. All in-text references
(Theorem 1--6, Propositions 1--5, Conjectures 1--4, Corollaries 1--2, Lemma 1,
Definition 6) point to the intended results. Forward references are genuinely forward
and non-circular.

### 6. Reference Integrity
All 18 references cited at least once; all citations have entries. References are in
alphabetical order. One factual error: Kontorovich--Lagarias editor name; see
Moderate #3.

### 7. Notation Conflicts
$L$ vs $\mathcal{L}$ disambiguation is in place (line 599). No symbol is used for two
different things. No overloaded variables in the same sentence.

### 8. Common Referee Objections
- "Simple eigenvalue" now qualified as computational (Theorem 1(c)): resolved.
- No circular proofs.
- Single "clearly" is visual, not mathematical.
- All terms defined at first use.
- Lemma 1 (a)/(b)/(c) vs case-(a)/(b) potential for minor confusion: Minor #3.

### 9. Version History
Present (lines 1269--1271). Accurately describes all v2 changes: Theorem 6, case-(a)
extension, proof strategy remarks, Theorem 1(c) qualification, Fredholm degree
correction, notation/expository fixes.

---

## Summary

**0 critical, 3 moderate, 4 minor** issues found.

**Bottom line:** All critical issues from the v2 review are resolved. The paper is
substantially improved and nearly submission-ready. The three moderate issues are
straightforward fixes (Fredholm degree rewording, $\sup = \limsup$ justification,
reference correction) that should be addressed before submission but require no
structural changes. The four minor issues are cosmetic.
