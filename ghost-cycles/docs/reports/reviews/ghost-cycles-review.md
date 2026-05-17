# Referee Report: "Ghost Cycles as 2-Adic Periodic Orbits: Spectral Theory of the Syracuse Transfer Operator"

**Reviewer:** Internal review (dynamical systems, spectral theory, p-adic analysis)
**Date:** 2026-03-06
**Target venue:** *Experimental Mathematics*

---

## 1. Overall Assessment

**Recommendation: Major revision required before submission.**

The paper reports a genuinely interesting and, to my knowledge, novel finding:
that "ghost cycles" in the modular Collatz transfer matrices are modular
projections of true 2-adic periodic orbits, that these orbits have negative
rational elements, and that their periodic reappearance at arithmetic
progressions of levels makes the exceptional set E infinite with positive
density. The falsification of the authors' own earlier conjecture (that E has
density zero) is scientifically honest and, as a narrative, well-suited to
*Experimental Mathematics*.

**Strongest part:** The case-(a)/(b) classification (Section 4.3) and its
consequences. The idea that the 2-adic limit of the cycle equation either
satisfies the valuation conditions exactly (producing a true periodic orbit
that reappears forever) or fails to (producing a transient ghost) is clean,
correct, and genuinely illuminating. The arithmetic-progression persistence
of case-(a) ghosts is the key result.

**Weakest part:** The paper does not actually contain proofs of most of the
results it claims. Theorem C (the persistence theorem) is stated but the
"proof" given is a two-sentence sketch. Theorem A (Baker-Wustholz bound)
is stated but attributed to Laurent without a self-contained derivation.
The cycle equation (Theorem B) is stated without proof. The spectral radius
bounds claimed in the abstract ($2^{-7/6} \leq \rho(L) \leq 1/2$) appear
nowhere in the body as a theorem with proof. The paper reads as a research
announcement, not a proof paper. For *Experimental Mathematics* this may be
acceptable if the computational evidence is presented with full rigor --- but
even the computational claims need tightening (see Section 5 below).

---

## 2. Missing Content

The following MUST be added before submission. I am specific about what
is needed.

### 2.1 A Proper "Setup and Definitions" Section

The paper jumps from the Introduction directly to the phase transition at
x = 4 (Section 2). Before any results, the reader needs:

- A formal definition of the Syracuse map S on odd integers.
- A formal definition of the modular Syracuse map S_k on odd residues
  mod 2^k.
- A formal definition of the transfer matrix P_k(x,y), with its indexing
  convention and normalization.
- A definition of "spectral radius" rho_k in terms of cycles of the
  functional graph (the paper's rho_k is NOT the spectral radius of P_k
  in the usual linear-algebraic sense --- it is the maximum of 2^{-V/L}
  over cycles, which equals the spectral radius only because P_k is a
  column-stochastic-like matrix with special structure). This distinction
  must be made explicit.
- A definition of the exceptional set E.

Currently the paper uses all of these without definition. A reader coming
to the paper fresh --- even one familiar with Collatz --- will not know
what P_k is.

### 2.2 Proofs or Proof References for Theorems A--C

The paper states Theorems A, B, and C in Section 4 but does not prove them.
For a journal submission, each must have either:

(a) A self-contained proof in the paper, or
(b) A precise citation to a published source where the proof appears.

Currently:
- **Theorem A** cites Baker-Wustholz (1993) and Laurent (2008) but does not
  give the specialization argument. The supporting document
  `baker-wustholz-analysis.md` contains a proof sketch that is adequate.
  This should be included in the paper as a short proposition.
- **Theorem B** (cycle equation) is well-known in the Collatz literature
  (Wirsching 1998, Steiner 1977). Cite these explicitly and state the
  result as a lemma with proof or a precise reference.
- **Theorem C** (persistence) is the paper's main theoretical contribution.
  The two-case argument given in Section 4.3 is correct in outline but
  needs to be written as a proper proof. In particular:
  - The claim that "for large enough k, the valuations stabilize" needs
    an explicit threshold: k >= max_i(v_i + 1) suffices for the bits
    relevant to each valuation condition.
  - The claim about eventually periodic bit patterns needs a proof that
    ties to the multiplicative order of 2 mod |D|. The supporting document
    has this, but the paper does not.
  - The phrase "all sufficiently large k" in case (a) should be "all
    k >= k_0 with k congruent to k_0 mod p" where p = ord_2(|D|) and k_0
    is the first appearance level. The current statement is imprecise ---
    it says "all sufficiently large k" without specifying the arithmetic
    progression structure, which is the whole point.

### 2.3 The Transfer Operator L on C(Z_2^{odd})

The abstract claims spectral bounds for the transfer operator L on
C(Z_2^{odd}), but the body of the paper never defines L, never proves
||L|| = 2/3, never proves rho(L) <= 1/2, and never establishes the
projective limit relationship sigma(L) = closure of union of sigma(P_k).
These are all stated and proved in the supporting document
`transfer-operator-spectral-theory.md` (referenced in `conjectures.md`)
but they do not appear in the paper.

Either:
(a) Add a section on the infinite-dimensional operator with proofs, or
(b) Remove the claims about L from the abstract and body, restricting
    the paper to the finite-level matrices P_k.

Option (b) is probably better for paper length. The paper's main
contribution is the ghost persistence mechanism and the density result,
not the operator theory. Save the operator theory for a companion paper.

### 2.4 The Lasota-Yorke Obstruction

The abstract mentions that "the Lasota-Yorke inequality fails on all
Holder spaces." This result appears nowhere in the body of the paper.
Either add a section proving it (with the explicit counterexample
from the supporting documents) or remove the claim from the abstract.

### 2.5 The Reformulation (Conjecture 3)

The abstract and Section 5 claim a reformulation: "the Collatz conjecture
is equivalent to all 2-adic periodic orbits having negative rational
elements." This is stated as a remark after Conjecture 3, which says it
is "not an independent statement" but is "equivalent to the nonexistence
of non-trivial positive-integer cycles." This equivalence needs a proof.
The direction "positive integer cycle implies positive-rational 2-adic
orbit" is trivial. The direction "positive-rational 2-adic orbit implies
positive integer cycle" requires showing that a 2-adic periodic orbit
with positive rational elements actually consists of positive integers
(not just positive rationals). This is not proved or even discussed.

Specifically: if n_tilde = R/D is a positive rational with D | R, then
n_1 = R/D is a positive integer and generates a true Collatz cycle. But
if gcd(R, D) != |D|, then n_1 is a non-integer positive rational, and
it is NOT obvious that this generates a positive-integer Collatz cycle.
The paper needs to address this gap. (In fact, the orbit elements must
all be odd integers for the cycle to be a true Collatz cycle, which
imposes further constraints.)

---

## 3. Rigor Issues

### 3.1 "Proved" vs Actually Proved in the Paper

The following claims are stated or implied as proved, but no proof
appears in the paper:

| Claim | Status in paper | Actual status |
|-------|----------------|---------------|
| rho(L) <= 1/2 | Abstract, Section 5 | Proved in supporting docs, NOT in paper |
| rho(L) >= 2^{-7/6} | Abstract, Section 5 | Follows from D=-601 ghost being case (a), NOT proved in paper |
| ||L|| = 2/3 | Not mentioned in body | Proved in supporting docs only |
| Lasota-Yorke fails | Abstract | Proved in supporting docs, NOT in paper |
| Theorem C (persistence) | Sketch in Section 4.3 | Correct argument but not a complete proof |
| sigma(L) = closure(union sigma(P_k)) | Not in paper | Proved in supporting docs only |

**This is the single biggest problem with the paper.** The abstract
promises results that the body does not deliver. A referee at
*Experimental Mathematics* will notice this immediately.

### 3.2 The Lower Bound 2^{-7/6}

The lower bound rho(L) >= 2^{-7/6} depends on:
1. The D = -601 ghost being case (a) --- this is verified computationally.
2. Case (a) ghosts contributing eigenvalue 2^{-V/L} to sigma(P_k) for
   infinitely many k --- this is argued but not proved in the paper.
3. sigma(L) = closure(union sigma(P_k)) --- this is not proved in the paper.

The chain of reasoning is sound but the paper needs to either prove (2)
and (3) or explicitly label the lower bound as "conditional on the
projective limit theorem proved in [companion document]."

### 3.3 Density Claim

The paper claims delta(E) >= 1/25 = 4%. This follows from the D = -601
ghost appearing at every k congruent to 12 mod 25. But "appearing" here
means "the cycle equation has a solution with the correct valuations,"
and this has been verified computationally through k = 200 (per the
supporting documents). The paper should state clearly:

- The arithmetic progression structure is PROVED (it follows from the
  periodicity of 2-adic expansions --- this is Theorem C(a)).
- The case-(a) classification of D = -601 is VERIFIED COMPUTATIONALLY
  (by checking the valuation conditions on the rational orbit R/D).
- Therefore the density bound is PROVED assuming the case-(a)
  verification is correct.

This is a fine level of rigor for *Experimental Mathematics*, but the
paper must be explicit about what rests on computation vs pure proof.

### 3.4 The Table of Ghost Types (Section 4.3)

The table lists four ghost types with D = -179, -601, -5537, -1675. For
D = -5537 and D = -1675, the v-pattern and rational orbit n_tilde are
listed as "---". These MUST be filled in. A claimed case-(a) ghost
without its defining data is not verifiable.

### 3.5 Theorem D Is Missing

The Baker-Wustholz analysis document contains a Theorem D (exclusion of
bounded-length case-(b) ghosts) which is a genuine unconditional theorem.
It does not appear in the paper. The paper should include it, both because
it is a real result and because it clarifies what Baker-type bounds CAN
and CANNOT do. Currently the paper mentions Baker-Wustholz only in the
verification section (Section 7), not as a source of theorems.

---

## 4. Structural Issues

### 4.1 The Phase Transition and Parameter Space (Sections 2--3)

Sections 2 and 3 describe the phase transition at x = 4 and the (x,y)
parameter space. These are interesting and provide context, but they are
not directly relevant to the paper's main results (which concern x = 3,
y = 1 exclusively). For *Experimental Mathematics*, these sections are
acceptable as scene-setting, but they consume approximately 30% of the
paper's non-reference content while contributing no theorems.

**Recommendation:** Compress Sections 2--3 into a single introductory
subsection (1 page maximum). Move the figures to a supplementary
appendix or the repository. The paper's narrative would be tighter:
Introduction -> Definitions -> Exceptional set enumeration ->
Ghost persistence -> Falsification -> Eigenvalues -> Computation.

### 4.2 Section Ordering

The current order is:
1. Introduction
2. Phase transition
3. Parameter space
4. Exceptional set enumeration
5. Falsification and new conjectures
6. Eigenvalue spectra
7. Computational methodology

The eigenvalue section (6) feels disconnected. It describes spectra for
k = 3..15 (non-exceptional k have spectrum {0, 1/4}) and Fredholm
determinants. This is interesting but is a different story from the ghost
persistence narrative. Consider either:
(a) Integrating the eigenvalue results into Section 4 (as evidence that
    non-exceptional levels are spectrally clean), or
(b) Making the eigenvalue section explicitly about what the spectrum
    tells us about ghost vs non-ghost levels.

### 4.3 Missing "Related Work" Section

The paper references Siegel (arXiv:2601.12772) for independent use of
the term "ghost cycles" and lists other references, but there is no
structured discussion of related work. For publication, the paper needs
a subsection (in the Introduction or as a standalone Section 2) that:

- Positions the transfer matrix approach relative to Matthews (1985),
  Wirsching (1998), and the stochastic models of Lagarias-Weiss (1992).
- Distinguishes this work from Tao (2022), which is probabilistic and
  does not use transfer matrices.
- Explains the relationship to Siegel's work precisely: same objects
  (2-adic periodic orbits), different questions (Siegel does not compute
  density or connect to spectral radius).
- Addresses the "Spectral Calculus" preprint mentioned in the
  post-falsification assessment, which claims a Lasota-Yorke inequality.
  If that preprint's operator and Banach space differ from yours, say so.
  If they are the same, your obstruction result contradicts it.

---

## 5. Specific Edits Needed

### 5.1 Abstract

> "We prove that ghost cycles are the modular projections of true 2-adic
> periodic orbits with negative rational elements"

This is not proved in the paper. The paper proves (in sketch) that ghost
cycles correspond to 2-adic periodic orbits. The negativity of the
rational elements is verified computationally for four ghost types, not
proved in general. Rewrite to: "We show that ghost cycles are modular
projections of 2-adic periodic orbits whose rational elements are
negative in all computed cases."

> "Case-(a) ghosts, whose 2-adic valuations match exactly, reappear at
> arithmetic progressions of levels k equiv k_0 mod ord_2(|D|)"

This is correct but should add "making the exceptional set E infinite"
(which it does) and should note that this is proved, not just observed.

> "We establish 2^{-7/6} <= rho(L) <= 1/2"

The upper bound rho(L) <= 1/2 is proved in supporting documents. The
lower bound depends on the case-(a) classification of D = -601 (verified
computationally) plus the projective limit theorem (proved in supporting
documents). Neither appears in the paper. Either prove them or say
"we establish (see companion paper [ref])."

> "prove that the Lasota-Yorke inequality fails on all Holder spaces"

Not proved in the paper. Remove from abstract or add the proof.

### 5.2 Section 4.2, Cycle Equation

The cycle equation is stated as:
$$n_1 \cdot (2^V - 3^L) = R \pmod{2^{k+V}}$$

This should be $\equiv$ not $=$. Also, the paper should clarify: this
congruence holds modulo 2^{k+V}, but the cycle exists modulo 2^k. The
extra V bits of precision are needed for the valuation conditions. This
subtlety is easy to miss and should be explained.

### 5.3 Section 4.3, Case-(a) Definition

> "If v_2(3 n_tilde_i + 1) = v_i for all i (exact valuation match), the
> rational orbit is a true periodic orbit of S on Z_2^{odd}."

This needs a one-sentence proof: "Since the valuation conditions
determine the Syracuse map step, and the rational orbit R/D satisfies
them exactly, iterating S on n_tilde_1 produces n_tilde_2, ...,
n_tilde_L, n_tilde_1, closing the orbit." The statement as given is an
assertion, not a theorem.

### 5.4 Section 4.3, Ghost Type Table

The table claims rho = 0.4353 for both D = -179 and D = -5537. For
D = -179: rho = 2^{-6/5} = 2^{-1.2} approx 0.4353. For D = -5537:
rho = 2^{-10/8} = 2^{-1.25} approx 0.4204. The value 0.4353 for
D = -5537 appears to be wrong. Check and correct.

### 5.5 Section 5, Conjecture 1 (Density Formula)

The density formula uses a product over ghost types:
$$\delta(E) = 1 - \prod_G (1 - r_G / p_G)$$

This assumes the arithmetic progressions for distinct ghost types are
independent (coprime periods). The paper should state this assumption
explicitly. If two ghost types have periods sharing a common factor,
the formula needs an inclusion-exclusion correction. This is mentioned
in the supporting documents but not in the paper.

### 5.6 Section 5, Conjecture 2 (Spectral Radius)

> rho(L) = sup_G 2^{-V_G/L_G}

This conjecture implicitly assumes that the spectral radius of L equals
the supremum of spectral radii contributed by ghost cycles. But L also
has eigenvalue 1/4 from the fixed point {1}. The formula should be:

$$\rho(L) = \max(1/4, \sup_G 2^{-V_G/L_G})$$

In practice, 2^{-7/6} > 1/4, so the max is redundant for the known
ghosts. But the conjecture should be stated correctly.

### 5.7 Section 6, Eigenvalue Table

The table shows k = 10 has "27 nonzero" eigenvalues and 1 extra cycle.
The relationship between "number of extra cycles" and "number of nonzero
eigenvalues" is not explained. If there is 1 extra cycle of length 26,
this contributes 26 nonzero eigenvalues (the 26th roots of 2^{-V}) plus
the 1 eigenvalue from the fixed point, giving 27 total. This should be
stated explicitly --- it is a nice connection between the graph theory
(cycle counting) and the linear algebra (eigenvalue counting).

### 5.8 Section 7, Computational Methodology

The algorithm pseudocode in Section 7.2 (cycle search) is clear but
should state the complexity: O(N) time and O(N) space (or O(N/8) with
bitpacking). For k = 36, N = 2^35 approx 3.4 * 10^{10}.

The verification statement "All results are verified against known cycle
structures for k = 3, ..., 24 (99 unit tests)" should specify what
"known" means --- known from prior literature, or known from a
separate computation? If the latter, it is self-consistency, not
independent verification.

### 5.9 References

- Laurent (2008) is cited in the supporting documents for the sharpest
  two-logarithm bound but does not appear in the paper's reference list.
  Add it.
- Eliahou (1993) is mentioned in the supporting documents (for the
  cycle length lower bound) but not in the paper. If the Steiner-Eliahou
  connection is relevant (it is, for explaining why ghost cycles cannot
  be true cycles), add a remark and cite both.
- The "Spectral Calculus" preprint should be cited if the Lasota-Yorke
  obstruction is included, since it claims the opposite.

---

## 6. What to Cut

### 6.1 Figures

The paper has 7 figures. For *Experimental Mathematics*, this is
acceptable, but:

- Figures 1--5 (Sections 2--3) concern the parameter space and phase
  transition, which are tangential to the main results. Consider keeping
  at most 2 (the spectral radius vs x, and one phase diagram) and
  moving the rest to a supplement.
- Figure 6 (Fredholm zeros) and Figure 7 (Pade poles) are in Section 6
  and relate to the eigenvalue/Fredholm story. These are interesting but
  disconnected from the ghost-cycle narrative. If Section 6 is trimmed,
  these can go.

### 6.2 The Pade Approximant Discussion

Section 6 mentions Pade approximant poles for the Fredholm determinant.
This is a brief mention with a figure but no theorem or conjecture. It
does not serve the main narrative. Cut it or develop it.

### 6.3 Lyapunov Exponent Subsection

Section 2.1 defines the Lyapunov exponent Lambda(x) = log_2 rho(x) and
states Lambda approx -2 for x = 3. This is a restatement of rho approx
1/4 in different notation. It adds no content and can be folded into a
one-sentence remark.

---

## 7. Summary of Required Changes

**Before submission, the paper must:**

1. Add a definitions section (S, S_k, P_k, rho_k, E).
2. Either prove Theorems A, B, C in the paper or cite published sources
   precisely (page/theorem number). Theorem C in particular needs a
   complete proof, not a sketch.
3. Remove claims from the abstract that are not backed by proofs in the
   paper (rho(L) bounds, Lasota-Yorke obstruction), OR add the proofs.
4. Fill in the missing data in the ghost type table (D = -5537, D = -1675).
5. Fix the apparent error: rho for D = -5537 is listed as 0.4353 but
   should be 2^{-10/8} approx 0.4204.
6. Add a related work subsection positioning this relative to Siegel,
   Matthews, Wirsching, and Tao.
7. Prove or carefully qualify the "reformulation" (Conjecture 3 / Remark):
   explain why a 2-adic periodic orbit with positive rational elements
   must consist of positive integers.
8. State the density formula's independence assumption explicitly.
9. Compress or cut Sections 2--3 (phase transition and parameter space)
   to focus the narrative on the main contribution.

**Desirable but not required:**

10. Include Theorem D (exclusion of bounded-length case-(b) ghosts) to
    show what Baker-Wustholz CAN do.
11. Explain the eigenvalue count vs cycle length relationship in
    Section 6.
12. Add a figure showing the ghost reappearance pattern (a timeline of
    k values with ghost types marked) --- this would be more informative
    than the parameter-space figures.

---

## 8. Final Verdict

The core finding --- that ghost cycles are permanent 2-adic residents
producing an infinite exceptional set with positive density --- is
novel, correct (to the extent I can verify from the documents), and
well-suited to *Experimental Mathematics*. The falsification narrative
is honest and scientifically valuable.

However, the paper in its current form is not publication-ready. It
reads as a draft that assumes the reader has access to the supporting
documents. The proofs are elsewhere, the definitions are implicit, and
the abstract promises more than the body delivers. With the revisions
listed above --- primarily adding definitions, completing the proof of
Theorem C, and bringing the abstract in line with the paper's actual
content --- this could be a strong submission.

The paper should NOT overclaim. The results are:
- **PROVED (in supporting docs, needs to be in paper):** Theorem C
  (persistence), the case-(a)/(b) classification, the arithmetic
  progression structure.
- **VERIFIED COMPUTATIONALLY:** Four ghost types are case (a); the
  density of E in [37, 200] is approximately 12%.
- **CONJECTURED with evidence:** The density formula, the spectral
  radius conjecture, the negative rationality conjecture.
- **HEURISTIC:** The claim that there are infinitely many ghost types.

Keep these categories sharp in the paper and it will be publishable.
