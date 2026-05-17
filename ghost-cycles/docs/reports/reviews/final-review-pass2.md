# Final Pre-Submission Review, Pass 2: Cross-Section Coherence Check

**Paper:** "Ghost Cycles as 2-Adic Periodic Orbits: Spectral Theory of the Syracuse Transfer Operator"
**Reviewer:** Internal review (dynamical systems, spectral theory, p-adic analysis)
**Date:** 2026-03-07
**Target venue:** *Experimental Mathematics*
**Review type:** Cross-section coherence check (Pass 2 of final review)
**Prerequisite:** Pass 1 (section-by-section audit) completed; one blocking issue (Proposition 2 false) and eight minor issues identified.

---

## 1. Does the Abstract Accurately Reflect the Body?

The abstract makes the following claims. I check each against the paper body.

| Abstract claim | Body location | Accurate? |
|---|---|---|
| Transfer matrices $P_k$ on odd residues mod $2^k$ | Definition 3 (Section 2) | Yes |
| Exhaustive cycle enumeration through $k = 36$ | Section 4.1 | Yes |
| Ghost cycles are modular projections of 2-adic periodic orbits with negative rational elements | Section 4.3 + Conjecture 3 (Section 5) | Yes, but the abstract says "negative in all computed cases," which correctly hedges |
| Cycle equation $n_1 \cdot (2^V - 3^L) \equiv R \pmod{2^{k+V}}$ | Theorem 1 (Section 4.3) | Yes |
| Case-(a)/(b) classification | Definition 6 (Section 4.3) | Yes |
| Case-(a) ghosts reappear at arithmetic progressions | Theorem 2 (Section 4.3) | Yes |
| $E$ infinite with natural density $\geq 4\%$ | Section 5.1 | Yes |
| Falsifies earlier conjecture | Section 5 title and body | Yes |
| Four case-(a) ghost types through $k = 200$ | Table 3 (Section 4.4) | Yes |
| Replacement conjectures | Section 5.2, Conjectures 1--3 | Yes |
| Reproducible from open-source repository | Section 7.6 | Yes |

**Verdict:** The abstract is an accurate summary of the body. No overclaims, no missing key results.

---

## 2. Cross-Reference Correctness

I trace every internal cross-reference in the paper.

| Reference | Context | Correct? |
|---|---|---|
| Definition 3, referenced twice in Section 3 | "the contraction weights $2^{-v_j}$ of Definition 3" and "Definition 3 (Section 2)" | Yes -- Definition 3 is the transfer matrix |
| Theorem 1 (`\ref{thm:cycle-eq}`) | Referenced in proof of Theorem 2 and in Proposition 2's proof | Correct theorem |
| Theorem 2 (`\ref{thm:persistence}`) | Referenced in Figure 1 caption and Proposition 2's proof | Correct theorem |
| Propositions 1--2 referenced in Introduction | "our Propositions 1--2" in related work paragraph | Yes -- these are the Baker--Wustholz and detection results |
| Figure `\ref{fig:ghost_timeline}` | Referenced in Section 5.1 | Yes -- matches the figure environment |

**Table numbering.** The paper uses implicit table numbering via pandoc/LaTeX. The text references "Table 3" explicitly in Section 4.4: "Known case-(a) ghost types." Counting tables: Table 1 (E density), Table 2 (exceptional cycle details), Table 3 (known ghost types), Table 4 (eigenvalue spectra). The text at Section 6.1 says "but with different $v$-patterns from the ones listed in Table~3" -- this correctly refers to the ghost type table. Consistent.

**Theorem/proposition numbering.** The paper uses `\setcounter{theorem}{0}` before Theorem 1 (Section 4.3) and `\setcounter{conjecture}{0}` before Conjecture 1 (Section 5.2). The numbering is:
- Definitions 1--6 (five in Section 2, one in Section 4.3)
- Theorems 1--2 (Section 4.3)
- Propositions 1--2 (Section 4.5)
- Conjectures 1--3 (Section 5.2)

These are separate counters and do not conflict.

**Verdict:** Cross-references are correct. No broken or misnumbered references.

---

## 3. Narrative Arc

### Does the introduction promise what the body delivers?

The introduction lists five contributions:
1. Exhaustive cycle enumeration through $k = 36$ -- delivered in Section 4.1--4.2.
2. Ghost cycles as 2-adic periodic orbits -- delivered in Section 4.3.
3. Case-(a)/(b) classification and persistence theorem -- delivered in Definition 6 and Theorem 2.
4. Falsification of $\delta(E) = 0$ -- delivered in Section 5.
5. Replacement conjectures -- delivered in Section 5.2.

The outline (end of Section 1) says:
- Section 2: definitions -- yes.
- Section 3: parametric family -- yes.
- Section 4: exceptional set and persistence -- yes.
- Section 5: falsification and conjectures -- yes.
- Section 6: eigenvalue spectra -- yes.
- Section 7: computational methodology -- yes.

### Does the evidence support the conjectures?

- Conjecture 1 (density of $E$): supported by the four known ghost types and the density formula. The caveat about coprimality of periods is explicitly stated. The gap between the lower bound (8.3%) and empirical density (12%) is noted as suggesting additional ghost types exist.
- Conjecture 2 (spectral radius limsup): follows naturally from Theorem 2 and the observation that each case-(a) ghost contributes its $\rho$ at infinitely many levels.
- Conjecture 3 (negative rationality): supported by all four computed ghost types having negative rational orbit elements. The relationship to the Collatz cycle conjecture is correctly stated in the Remark.

### Is there a logical gap anywhere?

One subtle issue in the flow. Section 3 (parametric family) introduces the $(x,y)$ parameter space and two figures showing phase transitions, but then the paper says "For the remainder of this paper, we work exclusively with the contraction-weighted matrix $P_k$ (Definition 3) at $x = 3$." This makes Section 3 feel somewhat disconnected from the main results. However, for *Experimental Mathematics*, providing this broader context is appropriate -- it motivates why one should care about the spectral radius at $x = 3$ (it sits below the phase transition). The section is short (one paragraph plus two figures) and does not overstay its welcome.

**Verdict:** The narrative arc is clean. Introduction promises match body deliverables. Conjectures follow from evidence. No logical gaps.

---

## 4. Notation Consistency

I check whether the same symbol means the same thing throughout the paper.

| Symbol | First use | Used consistently? |
|---|---|---|
| $S(n)$ | Definition 1: Syracuse map | Yes -- always the Syracuse map |
| $S_k$ | Definition 2: modular Syracuse map | Yes |
| $P_k$ | Definition 3: transfer matrix | Yes |
| $\rho_k$ | Definition 4: spectral radius | Yes |
| $E$ | Definition 5: exceptional set | Yes |
| $v_2(m)$ | Definition 1: 2-adic valuation | Yes |
| $v_i$ | Cycle valuation sequence | Yes -- always the valuation at step $i$ of a cycle |
| $V$ | Total valuation $\sum v_i$ | Yes |
| $L$ | Cycle length | Yes |
| $D$ | $2^V - 3^L$ | Yes -- introduced in Theorem 1, used consistently |
| $R$ | $\sum_{i=0}^{L-1} 3^{L-1-i} \cdot 2^{S_i}$ | Yes |
| $R_k$ | Set of odd residues mod $2^k$ | Used only in Definition 2; no conflict with $R$ above because $R$ (cycle sum) is never subscripted |
| $N$ | $2^{k-1}$, number of odd residues | Yes |
| $p$ | $\mathrm{ord}_2(\|D\|)$ | Yes |
| $r$ | Number of residue classes mod $p$ | Yes |
| $k_0$ | First appearance level | Yes |
| $S_i$ | Partial valuation sum $v_1 + \cdots + v_i$ | Used in Theorem 1 only; potential conflict with $S_k$ (modular Syracuse map), but the subscript conventions differ (capital S with numeric subscript vs. capital S with $k$). Acceptable given context |
| $\tilde{n}_i$ | Rational orbit elements | Yes |
| $\delta(E)$ | Natural density | Yes |
| $\mathcal{G}$ | Ghost type | Used only in Conjecture 1--2 |

**One minor issue:** The symbol $R_k$ (Definition 2, the set of odd residues) and $R$ (Theorem 1, the cycle sum) are both capital-R. They appear in different sections and contexts, so confusion is unlikely, but a pedantic referee might flag this. Since $R_k$ appears only once (Definition 2) and $R$ appears only in Section 4.3 onward, this is a very minor concern.

**Verdict:** Notation is consistent throughout. The only potential issue ($R_k$ vs $R$) is minor and context-disambiguated.

---

## 5. Related Work Positioning

The related work paragraph (end of Section 1) positions the paper relative to:

| Prior work | Claimed relationship | Accurate? |
|---|---|---|
| Matthews and Watts (1985) | Transfer matrix approach originates here | Correct -- they introduced the Markov chain / growth rate framework |
| Wirsching (1998) | Dynamical systems perspective | Correct -- LNM 1681 is the standard reference |
| Lagarias and Weiss (1992) | Stochastic models for heuristic contraction | Correct |
| Tao (2022) | Almost all orbits attain almost bounded values | Correct -- different method (probabilistic, not transfer matrices) |
| Steiner (1977) | Cycle equation | Correct -- Theorem 1 is attributed to Steiner |
| Siegel (2025) | Independent use of "ghost cycles" | Correct -- the paper explicitly distinguishes its contribution (density computation, persistence classification) from Siegel's |
| Baker--Wustholz (1993), Laurent (2008) | Linear forms in logarithms | Correct -- used for Propositions 1--2 |

**Missing related work?** The paper does not cite:
- Chamberland (1996) on cycle lengths -- could be relevant but not essential.
- Monks et al. (2002) on trees and branches of the Collatz graph -- tangentially related.
- Kontorovich and Lagarias (2009) -- was in the Pass 1 reference list as "uncited" but has been removed from the current references. Good.

For *Experimental Mathematics*, the related work section is adequate. It covers the main threads (transfer matrices, probabilistic methods, transcendence theory, 2-adic orbits) and explicitly positions relative to the most directly relevant prior work (Siegel 2025).

**Verdict:** Related work positioning is accurate and adequate for the venue.

---

## 6. Were Pass 1 Issues Adequately Fixed?

### Blocking Issue

**B1. Proposition 2 was FALSE** -- it claimed "no ghost cycle of length $L \leq L_0$ with $\rho > 1/4$ exists at any level $k > K_0(L_0)$," which contradicts Theorem 2 (case-(a) ghosts reappear at infinitely many levels).

**Status: FIXED.** Proposition 2 has been restated as a detection theorem: "every ghost type with $L \leq L_0$ and $\rho > 1/4$ appears at some level $k \leq K_0(L_0)$: searching through $k = K_0(L_0)$ suffices to detect all such types." The new statement is logically correct. The proof has been updated: it correctly argues that for fixed $(L, V)$ with finitely many $v$-patterns, each case-(a) pattern reappears with period $p$ (so it first appears at $k_0 \leq p$), and each case-(b) pattern appears finitely often within $[3, p]$. Taking the maximum gives $K_0(L_0)$. Sound.

The explicit bounds $K_0(5) \leq 269$ and $K_0(10) \leq 465{,}239$ are retained. These are computational claims that should be verified (flagged in Pass 1) but do not affect the theorem's correctness.

### Minor Issues

**M1. Phase transition weights (Section 3).** The paper now says: "This phase transition is visible in the spectral radius of the growth-weighted transfer matrix (with entries $x \cdot 2^{-v_j}$ rather than the contraction weights $2^{-v_j}$ of Definition 3)." This explicitly distinguishes the two weight conventions, resolving the confusion. **FIXED.**

**M2. k = 12 cycle attribution (Section 6).** The paper now says: "two extra cycles of lengths 7 and 6, both with $D = -1675$ and $D = -601$ respectively, but with different $v$-patterns from the ones listed in Table 3." This acknowledges that the cycle at $k = 12$ has a different $v$-pattern from the classified case-(a) type. The attribution to $D = -1675$ (same $L = 7$, $V = 9$) is correct in the sense that the denominator is the same, even if the $v$-pattern differs. The clarification "with different $v$-patterns from the ones listed in Table 3" resolves the apparent contradiction with Table 3 showing $D = -1675$ first appearing at $k = 95$. **FIXED.** (A referee might ask whether this alternative $v$-pattern is case-(a) or case-(b). Since it appears at $k = 12$ but not at subsequent multiples, it is presumably case-(b). The paper does not state this explicitly, but the issue is minor.)

**M3. Conjecture 3 vs Collatz (Section 5).** The Remark now reads: "Conjecture 3 implies the nonexistence of non-trivial positive-integer Collatz cycles (the periodic orbit part of the Collatz conjecture), and additionally excludes positive non-integer rational orbits. It does not address divergent trajectories." This is precisely correct and resolves the overstatement. **FIXED.**

**M4. Density computation (Section 4.2).** The table now shows density 0.147, not 0.152. This is consistent with $5/34 = 0.147$. **FIXED.**

**M5. "$D$ nonzero" phrasing (Section 4.3).** The text after Theorem 1 now reads: "Since $D = 2^V - 3^L$ is always odd and nonzero (as $2^V$ and $3^L$ are coprime), the rational limit $\tilde{n}_1 = R/D$ is well-defined. For $V > L \log_2 3$, we have $D < 0$." This correctly separates nonvanishing (always, by coprimality) from sign ($D < 0$ when $V > L \log_2 3$). **FIXED.**

**M6. Exceptional level count (Section 5.1).** The text now states: "the four known ghost types account for 17 of the 20 exceptional levels in $[3, 200]$. The remaining three ($k = 10, 11, 20$, all within the exhaustive search range) are case-(a) ghosts with long cycles." This makes clear that "20 exceptional levels" refers to $[3, 200]$, and the arithmetic works: 17 from the four classified types + 3 from long-cycle types = 20. **FIXED.**

**M7. Uncited references.** The reference list now contains only cited references: Baker--Wustholz, Lagarias (1985, 2021), Lagarias--Weiss, Laurent, Matthews--Watts, Siegel, Steiner, Tao, Wirsching. The previously uncited references (Conway, Goncalves, Kontorovich--Lagarias, Eliahou, Kurtz--Simon, Matthews 2010) have been removed. **FIXED.**

**M8. Pade figure (Section 6).** The Pade approximant figure has been removed. Section 6 now contains only the Fredholm zeros figure, which is directly relevant to the discussion of Fredholm determinants. **FIXED.**

---

## 7. Additional Cross-Section Observations

### 7.1 Internal consistency of ghost type data

The four ghost types appear in three locations: Table 3 (Section 4.4), the falsification argument (Section 5.1), and the density formula (Section 5.2). I verify consistency:

- $D = -601$: Table 3 says $p = 25$, $r = 1$. Section 5.1 says "reappears at every $k \equiv 12 \pmod{25}$." Section 5.2 uses $r/p = 1/25$. All consistent.
- $D = -179$: Table 3 says $p = 178$, $r = 3$. Section 5.2 uses $r/p = 3/178$. Consistent.
- $D = -5537$: Table 3 says $p = 84$, $r = 2$. Section 5.2 uses $r/p = 2/84$. Consistent.
- $D = -1675$: Table 3 says $p = 660$, $r = 3$. Section 5.2 uses $r/p = 3/660$. Consistent.

The $\gcd$ note: Section 5.2 says $\gcd(25, 660) = 5$. Indeed $660 = 5 \cdot 132$ and $25 = 5^2$, so $\gcd = 5$. Correct.

### 7.2 The $\rho$ values

Table 3 reports $\rho$ values. The abstract says density $\geq 4\%$ (from $D = -601$ alone). Section 5 says $\limsup \rho_k \geq 2^{-7/6} \approx 0.4454$. These are consistent -- the $D = -601$ ghost has $\rho = 2^{-7/6}$ and reappears infinitely often.

### 7.3 Transition from Section 4 to Section 5

Section 4 establishes the mechanism (Theorem 2) and catalogs the known ghosts (Table 3). Section 5 draws the consequences (falsification, new conjectures). The transition is logical: Section 4 provides the tools, Section 5 applies them. No gap.

### 7.4 Section 6 relative to the main narrative

Section 6 (eigenvalue spectra) is somewhat standalone. It confirms that non-exceptional $k$ have spectrum $\{0, 1/4\}$ and provides the Fredholm determinant perspective. While not strictly necessary for the falsification argument (Sections 4--5 are self-contained), it adds depth appropriate for *Experimental Mathematics* and connects to the spectral radius theme of the title.

### 7.5 One remaining small issue

The abstract says "four case-(a) ghost types through $k = 200$." This is accurate as far as the classified types go. However, Section 5.1 also mentions that $k = 10, 11, 20$ host ghosts with "long cycles ($L = 26, 25, 22$ respectively) and very large denominators ($|D| > 10^{10}$)." These are also identified as case-(a) ghosts (the text says "are case-(a) ghosts"), bringing the total number of known case-(a) ghost types to at least seven, not four. The abstract's "four" refers to the four types that have been fully classified (with known period and residue count), not the total number observed. The distinction could be sharper. This is a very minor point -- the context in Section 5.1 makes the meaning clear -- but a referee might notice.

**Recommendation:** Consider changing the abstract from "We identify four case-(a) ghost types through $k = 200$" to "We classify four case-(a) ghost types with short cycles ($L \leq 8$) through $k = 200$" to distinguish classified types from the longer-cycle types observed at $k = 10, 11, 20$.

---

## Overall Assessment

The paper is in good shape after the Pass 1 fixes. The blocking issue (Proposition 2) has been correctly resolved -- the new "detection theorem" formulation is logically sound and does not conflict with Theorem 2. All eight minor issues have been addressed.

The cross-section coherence is strong:
- Abstract matches body.
- Cross-references are correct.
- Narrative arc is clean.
- Notation is consistent.
- Related work is accurately positioned.
- Ghost type data is consistent across all sections.

I found one very minor point (the abstract's "four" ghost types vs. the seven observed) that could be clarified with a single word change. This is not blocking.

### Verdict

**READY FOR SUBMISSION** (with the one optional clarification above).

The paper presents a clear computational discovery (ghost cycles as 2-adic periodic orbits), proves its central theorem (persistence at arithmetic progressions), honestly reports a falsification of a prior conjecture, and proposes well-motivated replacements. The mathematical content is correct, the computational methodology is transparent, and the writing is appropriate for *Experimental Mathematics*.
