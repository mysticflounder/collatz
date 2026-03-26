# Pre-Submission Review: "Ghost Cycles of the Syracuse Map" (v2)

**Reviewer:** Mathematics professor (dynamical systems/spectral theory/p-adic analysis)
**Date:** 2026-03-11
**Document:** `docs/arxiv-paper-a.md`
**Focus:** New Theorem 6, "Towards a proof" remarks, abstract/body consistency

---

## 1. Abstract <-> Body Consistency

### Critical

**Lines 28--30 (Abstract).** The abstract says:

> proved unconditionally for all concentrated patterns via an explicit closed-form
> formula --- establishing that the entire high-spectral-radius regime
> ($\rho > 1/3$, equivalently $D < 0$) consists of purely negative 2-adic orbits
> with no positive-integer elements.

The word "establishing" creates the impression that negativity of the entire $D < 0$
regime is a proved result. It is not. Theorem 6 proves negativity only for
**concentrated** patterns $(1,\ldots,1,e+1)$. For the remaining 5,996 non-concentrated
$D < 0$ ghost types through $L = 12$, negativity is verified computationally. The
full assertion remains Conjecture 4 (open). A referee will catch this immediately.

**Fix:** Replace "establishing that the entire high-spectral-radius regime..." with
language that clearly distinguishes what is proved from what is conjectured. For
example: "--- providing strong evidence that the entire high-spectral-radius regime
consists of purely negative 2-adic orbits, as Conjecture 4 asserts."

### No other abstract/body inconsistencies found.

All quantitative claims in the abstract ($\|\mathcal{L}\| = 2/3$,
$\rho \leq 1/2$, $k = 36$, $k = 200$, 88+ ghost types, $L = 12$, 5,996 cases,
$\rho \geq 2^{-16/15}$, density $\geq 4\%$) match the body exactly. The four
conjectures mentioned in the abstract all appear in the body.

---

## 2. Contributions List <-> Body

### Moderate

**Lines 83--100 (Contributions list).** Theorem 6 is not mentioned. The list has
8 items; none describes the new proved result for concentrated patterns. This is a
significant omission given that Theorem 6 is the only result in the paper that
proves any part of Conjecture 4 unconditionally.

**Fix:** Add a ninth contribution item, e.g.:
"(9) an unconditional proof (Theorem 6) that all concentrated ghost types
$(1,\ldots,1,e+1)$ with $D < 0$ have purely negative rational orbit elements,
establishing Conjecture 4 for this family and case-(a) as a byproduct."

### Moderate

**Lines 131--141 (Outline).** The outline describes Section 9 as giving "density
and spectral radius results together with replacement conjectures." It does not
mention that Section 9 also contains Theorem 6. A reader scanning the outline would
not know where the new theorem lives.

**Fix:** Amend the Section 9 description to include "together with an unconditional
proof of negative rationality for concentrated patterns (Theorem 6)."

---

## 3. Theorem/Proof Completeness (Theorem 6)

### The proof is mathematically correct.

I verified every step:

1. **Recurrence.** The substitution $Q_i = 2^{i-1}R_i$ and its general solution
   $Q_i = C \cdot 3^{i-1} - D \cdot 2^{i-1}$ are correct.
2. **Initial condition.** $R_1 = 3^L - 2^L$ from the geometric series for concentrated
   patterns with $S_j = j$. Correct.
3. **Constant.** $C = 2^L(2^e - 1)$. Verified from $Q_1 = R_1 = C - D$.
4. **Closed form.** $R_i = 2^{L-i+1}(2^e-1) \cdot 3^{i-1} + (3^L - 2^{L+e})$. Correct.
5. **Positivity.** First term positive since $e \geq 1$; second term positive since
   $D < 0$ implies $3^L > 2^{L+e}$. Correct.
6. **Orbit closure.** $(3R_L + D)/2^{e+1} = R_1$ verified by direct computation:
   $3R_L + D = 2^{e+1}(3^L - 2^L)$. Correct.
7. **Case-(a) for $i < L$.** The recurrence gives $v_2(3R_i + D) = 1 + v_2(R_{i+1})$;
   oddness of $R_{i+1}$ (from the parity argument) gives $v_2 = 1 = v_i$. Correct.
8. **Case-(a) for $i = L$.** $3R_L + D = 2^{e+1}(3^L - 2^L)$ and $3^L - 2^L$ is odd,
   giving $v_2 = e + 1 = v_L$. Correct.
9. **Oddness of $R_i$.** First term has $v_2 = L - i + 1$; second term $3^L - 2^{L+e}$
   is odd. For $i < L$: $v_2 \geq 2$, so even + odd = odd. For $i = L$: $v_2 = 1$,
   so $2 \cdot (\text{odd}) + \text{odd} = \text{odd}$. Correct.

### Minor (expository)

**Line 995.** The proof says "the first term has $v_2 = L - i + 1 \geq 1$ for $i < L$"
but the bound that matters is $\geq 2$ (since $i \leq L-1$ gives $L - i + 1 \geq 2$).
The subsequent argument at line 997 correctly uses "$L - i + 1 \geq 2$", but the
preceding line sets up the weaker bound. Not an error, but a referee might flag the
loose statement.

### Moderate (scope of case-(a) byproduct)

**Lines 979--980.** The theorem states "As a byproduct, concentrated patterns are
always case-(a)" under the hypothesis $D < 0$. However, the case-(a) verification
in the proof (oddness of $R_i$, $v_2$ checks) does not actually use $D < 0$ -- it
uses only that $3^L - 2^{L+e}$ is odd (which holds for all $D \neq 0$) and that
$2^e - 1 \neq 0$ (which holds for $e \geq 1$). The case-(a) result therefore holds
for ALL concentrated patterns with $e \geq 1$, not just those with $D < 0$.

This matters because the "Towards a proof" remark for Conjecture 1 (line 636) cites
Theorem 6 as establishing case-(a) for concentrated patterns, but Conjecture 1 covers
compositions with $L+1 \leq V \leq 2L-1$, which includes some $D > 0$ cases (e.g.,
$L = 5$, $e = 4$, $D = 269 > 0$). Theorem 6 as stated does not cover these cases,
even though the proof does.

**Fix:** Either (a) state the case-(a) byproduct as a separate corollary without the
$D < 0$ restriction, or (b) add a sentence noting that the case-(a) argument is
independent of the sign of $D$.

### No circularity detected.

The proof of Theorem 6 relies on the cycle equation (Theorem 4) and the definition
of case-(a) (Definition 6). Neither depends on Theorem 6. The "Towards a proof"
remark for Conjecture 1 references Theorem 6, but this is a forward citation
(Conjecture 1 in Section 7, Theorem 6 in Section 9), not circularity.

---

## 4. Theorem Numbering and Cross-References

### All theorem numbers are correct.

Tracing `\setcounter{theorem}{N}` and auto-increments:

| Counter set | Next `\begin{theorem}` | Result | Line |
|---|---|---|---|
| `\setcounter{theorem}{0}` (line 294) | line 295 | Theorem 1 | Correct |
| `\setcounter{theorem}{1}` (line 364) | line 365 | Theorem 2 | Correct |
| `\setcounter{theorem}{2}` (line 449) | line 450 | Theorem 3 | Correct |
| `\setcounter{theorem}{3}` (line 564) | line 565 | Theorem 4 | Correct |
| auto-increment from 4 | line 644 | Theorem 5 | Correct |
| auto-increment from 5 | line 972 | Theorem 6 | Correct |

### All in-text references verified.

- "Theorem 1(e)" at lines 290, 340, 1153: refers to spectrum = closure of union.
  Correct (Theorem 1, part (e)).
- "Theorem 2" at lines 87, 404, 441, 490, 1130: refers to Lasota-Yorke obstruction.
  Correct.
- "Theorem 3" at lines 90, 491, 1140: refers to 2-adic unboundedness. Correct.
- "Theorem 4" at line 116: refers to cycle equation. Correct.
- "Theorem 5" at lines 714, 896, 1155: refers to persistence of case-(a) ghosts.
  Correct.
- `Theorem~\ref{thm:conc}` at lines 637, 1177, 1182: refers to Theorem 6. Correct
  (label `\label{thm:conc}` is at line 973, within the Theorem 6 environment).

### All conjecture references verified.

- "Conjecture 1" at lines 1020, 1158: Universal case-(a). Correct.
- "Conjecture 2" at line 833: Density of E. Correct.
- "Conjecture 3" at line 822: Spectral Radius. Correct (forward reference from
  Section 8 to Section 9).
- "Conjecture 4" at lines 26, 1010, 1015, 1017, 1177: Negative Rationality. Correct.

### All section references verified.

- "Section 7" at line 79: case-(a) defined there. Correct.
- "Section 9" at lines 637, 1003, 1177: Theorem 6 is in Section 9. Correct.
- "Section 12" at line 1003: Discussion. Correct (12th `#`-level heading).
- "Section 4, second remark" at line 1133: refers to conditional contraction remark.
  Correct.

---

## 5. Notation Conflicts

### Minor

$L$ is used for cycle length and $\mathcal{L}$ for the transfer operator. These are
typographically distinct (italic vs. calligraphic script) and follow standard
conventions in dynamical systems / operator theory. No practical ambiguity, but a
referee unfamiliar with the transfer operator convention might briefly stumble.
Consider defining both explicitly at first joint appearance.

### No conflicts found in $V$, $D$, $R_i$, $e$.

- $V = \sum v_i$ (total valuation): used consistently throughout.
- $D = 2^V - 3^L$: used consistently as the ghost denominator.
- $R_i$: orbit numerators, consistently defined via the cycle equation.
- $e = V - L$: excess valuation, used consistently in the census and families.

---

## 6. Reference Integrity

### All 18 references are cited; all citations have entries.

Verified: Amice, Assani, Baker-Wustholz, Kontorovich-Lagarias, Lagarias (1985),
Lagarias (2021), Lagarias-Weiss, Laurent, Matthews-Watts, Mori, Neklyudov, Serre,
Siegel (2025a), Siegel (2025b), Simons-de Weger, Steiner, Tao, Wirsching.

### References are in alphabetical order. Correct.

---

## 7. Common Referee Objections

### Critical (restating finding from Section 1)

**Lines 28--30 (Abstract).** The abstract says "establishing" where the result is only
partially proved and partially conjectured. A referee will interpret "establishing" as
a claim of proof for the full regime and reject accordingly.

### Moderate

**Lines 315--318 (Theorem 1, part (c)).** The simplicity of $\lambda = 1/4$ is
stated as part of a theorem but the proof relies on computational verification
through $k \leq 36$. This is a computational claim inside a theorem environment.
A referee may ask either: (a) for a proof of simplicity, or (b) for the statement
to be qualified (e.g., "computationally verified through $k = 36$" in the theorem
statement itself, or moving simplicity to a separate proposition labeled as
computational).

### Moderate

**Lines 1010--1011.** "Conjecture 4 shows that all $D < 0$ ghost orbits are purely
negative." A conjecture does not "show" anything. Replace "shows" with "asserts" or
"predicts."

### Moderate

**Line 1013.** "since $R_i > 0$ always" --- this is true for $D > 0$ (by induction:
$3R_i + D > 0$ when both $R_i$ and $D$ are positive) and for $D < 0$ it is the
content of Conjecture 4 (unproved in general). The parenthetical is being used in the
$D > 0$ context but the unqualified "always" is misleading. A referee may read this
as an implicit claim that Conjecture 4 is trivial.

**Fix:** Replace "since $R_i > 0$ always" with "since $R_1 > 0$ (a sum of positive
terms) and, for $D > 0$, the recurrence $R_{i+1} = (3R_i + D)/2^{v_i}$ preserves
positivity."

### Minor

**Lines 1056--1058.** "The Fredholm determinant $F_k(z) = \det(I - z \cdot P_k)$ is a
polynomial in $z$ of degree $N = 2^{k-1}$." This is incorrect: $\deg F_k = N$ only
when $P_k$ is nonsingular ($\det P_k \neq 0$). For non-exceptional $k$, all but one
eigenvalue is zero, so $\deg F_k = 1$. Even for exceptional $k$, $P_k$ is singular
($N - 1$ or more zero eigenvalues), so $\deg F_k \ll N$.

**Fix:** "polynomial in $z$ of degree at most $N = 2^{k-1}$" or "of degree equal to
the number of nonzero eigenvalues."

### No instances of "clearly" or "trivially" before non-trivial steps.

The single "clearly" (line 896, figure caption: "clearly visible") is visual
description, not a mathematical claim.

---

## 8. Overall Narrative

### The abstract accurately describes a paper with conjectures AND a new theorem.

Lines 25--30 correctly present the structure: four conjectures are proposed, and
Conjecture 4 is partially proved (for concentrated patterns) by Theorem 6. The only
issue is the "establishing" overstatement flagged as Critical above.

### The distinction between proved results and open conjectures is clear throughout.

- Theorems 1--6 are proved (with the caveat on Theorem 1(c) simplicity).
- Conjectures 1--4 are explicitly labeled as conjectures.
- Computational claims are qualified ("verified computationally," "exhaustive search").
- The "Towards a proof" remarks correctly distinguish what is known from what is open.

### Minor structural observation.

Theorem 6 appears inside Section 9 ("Density and Spectral Radius") under the
subsection "Conjecture 4 (Negative Rationality)." A referee might find it odd that
a theorem with a full proof sits inside a subsection named after a conjecture.
Consider either: (a) giving Theorem 6 its own subsection titled "Negative Rationality
for Concentrated Patterns," or (b) adding a brief transitional sentence before the
theorem making clear that the conjecture motivates the theorem, which then proves a
special case.

---

## Summary of Findings

| # | Severity | Lines | Issue |
|---|----------|-------|-------|
| 1 | **Critical** | 28--30 | Abstract says "establishing" for full $D<0$ regime; only concentrated patterns are proved |
| 2 | Moderate | 83--100 | Contributions list does not mention Theorem 6 |
| 3 | Moderate | 139 | Outline does not mention Theorem 6 in Section 9 description |
| 4 | Moderate | 315--318 | Simplicity of $1/4$ in Theorem 1(c) is computational, not proved |
| 5 | Moderate | 979--980 | Case-(a) byproduct of Theorem 6 is stated under $D<0$ but the proof works for all $D \neq 0$ |
| 6 | Moderate | 1010--1011 | "Conjecture 4 shows" -- a conjecture does not show |
| 7 | Moderate | 1013 | "$R_i > 0$ always" is misleading; true for $D > 0$ by induction, content of Conj. 4 for $D < 0$ |
| 8 | Minor | 995 | $v_2 \geq 1$ should be $v_2 \geq 2$ in the case $i < L$ |
| 9 | Minor | 1057 | Fredholm determinant degree claimed as $N$; actually $\leq$ rank of $P_k$ |
| 10 | Minor | --- | $L$ vs $\mathcal{L}$ notation: typographically distinct but worth noting at first joint use |

**Bottom line:** The proof of Theorem 6 is correct and the paper is in good shape
overall. The one critical fix (issue #1) must be made before submission: the abstract
must not claim as "established" what is only partially proved and partially
conjectured. The moderate issues should also be addressed to preempt standard referee
objections. The minor issues are cosmetic.
