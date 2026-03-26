# Publication Order Recommendation

**Reviewer:** Internal (dynamical systems, spectral theory, p-adic analysis)
**Date:** 2026-03-06
**Scope:** Optimal ordering and strategy for three Collatz papers

---

## Executive Summary

**The ordering in doc-strategy.md (Paper 1, Paper 3, Paper 2) is wrong.
Paper 3 should go first. Paper 1 second. Paper 2 third --- or not at all
as a standalone paper.**

The reasoning is straightforward: Paper 3 is the only one with a novel,
falsifiable (and indeed falsified) result that will generate attention.
Papers 1 and 2 are supporting infrastructure. Leading with infrastructure
is the wrong strategy.

---

## Paper-by-Paper Assessment

### Paper 3: "Ghost Cycles as 2-Adic Periodic Orbits"

**Standalone strength: HIGH.**

This paper contains the only genuinely novel contribution across the three
manuscripts: the discovery that ghost cycles are permanent 2-adic periodic
orbits, the case-(a)/(b) classification, the persistence theorem, and the
falsification of the authors' own conjecture. The falsification narrative ---
"we conjectured X, computed further, discovered X is false, and here is why"
--- is exactly the kind of paper *Experimental Mathematics* publishes and
that generates citations. Self-falsification is rare and attention-getting.

The paper has concrete, verifiable results: four ghost types enumerated, an
arithmetic-progression persistence mechanism proved, a density lower bound
of 4%, and three replacement conjectures that give other researchers
something to work on. It connects to transcendence theory (Baker--Wüstholz)
in a non-trivial way. The computational search through k = 36 (34 billion
residues) is a genuine contribution that others would cite as the state of
the art.

After the major revision it has undergone (adding definitions, completing
the persistence proof, correcting the ghost type table, adding the ghost
timeline figure), the paper now appears to contain what it claims. It is
close to submission-ready for *Experimental Mathematics*.

**Citation potential: HIGHEST of the three.** Anyone working on Collatz
transfer matrices will need to cite this paper's exceptional set data and
persistence mechanism. The replacement conjectures give future work clear
targets.

### Paper 1: "2-Adic Local Constancy of Transfer Matrices"

**Standalone strength: MODERATE.**

This is a clean, short paper with a single theorem proved completely. The
result --- that P_k(x,y) is locally constant in x with tight modulus
M = k + V --- is correct, the proof is self-contained, and the corollaries
(non-polynomiality of Fredholm coefficients, finiteness of spectral values)
are interesting. The paper requires no computational verification; it is
pure mathematics.

However, the result is narrow. It tells you that polynomial continuation
in x does not work and that the natural domain is 2-adic. This is a
"closing a door" result: it rules out an approach (complex-analytic
continuation in x) but does not open a new one. The paper does not connect
its result to any concrete consequence for the Collatz conjecture itself.

**Citation potential: MODERATE.** Specialists in p-adic dynamical systems
will appreciate it. It would be cited by anyone attempting analytic
continuation of Collatz spectral data, but that is a small audience.

The paper is unaffected by the falsification of Conjecture 1. This was
listed in doc-strategy.md as a reason to submit it first. But "unaffected
by bad news" is not a reason to lead with a paper --- it is a reason the
paper can be submitted at any time without urgency.

### Paper 2: "Transfer Operator Spectral Theory"

**Standalone strength: LOW as a standalone paper.**

The paper proves ||L|| = 2/3, rho(L) <= 1/2, and that the Lasota--Yorke
inequality fails on all Holder/BV/Sobolev spaces using the 2-adic metric.
The obstruction theorem is correct and the proof is clean: L(1) = W has
infinite Lipschitz seminorm because W depends on residues mod 3, which
oscillate at every 2-adic scale. The universality corollary (extending to
all smoothness spaces strictly between constants and C(Z_2^{odd})) is
a strong negative result.

However, a paper whose main theorem is "this standard approach does not
work" faces a difficult reception. Negative results are publishable when
they close off a line of attack that many people are pursuing. In the
Collatz literature, the number of researchers attempting Lasota--Yorke
on 2-adic function spaces is very small. The obstruction, while
mathematically sharp, addresses a niche concern.

Furthermore, Paper 2 now has a significant structural problem: Theorem 3
(conditional: E finite implies rho(L) = 1/4) has been falsified. The
paper must carry a remark saying "the hypothesis of our main conditional
theorem is false." This is scientifically honest but editorially awkward
as a standalone submission. The "what is provable" section (Theorem 2)
is essentially a catalog of standard bounds, not a new result.

**Citation potential: LOW as standalone.** The paths-forward discussion
(Mahler bases, Iwasawa algebras, thermodynamic formalism) is interesting
but speculative --- it contains no theorems.

---

## Recommended Ordering

### 1. Paper 3 first (target: Experimental Mathematics)

**Rationale:**

- It contains the strongest result: ghost persistence, E is infinite, and
  the falsification of the density-zero conjecture.
- It is best suited to its target venue. *Experimental Mathematics*
  explicitly values computational discovery, self-correction, and
  conjectures supported by data. This paper delivers all three.
- It establishes priority on the case-(a)/(b) classification and the
  persistence mechanism before Siegel or others publish similar
  observations. Siegel (2025) already uses the term "ghost cycles" for
  2-adic periodic orbits; this paper's contribution is the density
  computation and classification, which Siegel does not address. Priority
  matters here.
- It is self-contained: after the revision, it defines all its objects,
  proves its main theorem, and does not require the reader to have read
  Papers 1 or 2.
- Leading with the most interesting result is the correct strategy for
  building a publication record. A strong first paper makes referees
  more receptive to subsequent papers by the same authors.

### 2. Paper 1 second (target: J. Number Theory or Experimental Mathematics)

**Rationale:**

- It can cite Paper 3 for context ("the exceptional set E is infinite
  [Paper 3]; here we show the underlying matrices are locally constant
  in the 2-adic topology").
- It is clean and short. After Paper 3 establishes the authors'
  credibility and the interest of the transfer matrix framework, Paper 1
  contributes a rigorous structural result about that framework.
- It provides a theoretical foundation that Paper 3 uses implicitly:
  the local constancy of P_k(x,y) explains why the parametric family
  is naturally 2-adic, which supports the 2-adic periodic orbit
  interpretation in Paper 3.
- The paper is ready to submit now. No revision is needed.

### 3. Paper 2 third --- or fold into Paper 3

**Rationale:**

- Paper 2 is the weakest standalone contribution.
- Its strongest result (Lasota--Yorke fails) is a negative result that
  is most meaningful in the context of Paper 3's findings: the ghost
  persistence mechanism shows *why* spectral gap techniques fail
  (ghost eigenvalues accumulate), and the Lasota--Yorke obstruction
  shows that the standard tool for proving spectral gap cannot even
  be set up.
- The paper's Theorem 3 (conditional on E finite) is falsified.
  Submitting a paper whose conditional theorem has a false hypothesis,
  with the falsification published by the same authors in a different
  paper, is awkward.

**Recommendation:** Seriously consider Option B from doc-strategy.md,
but modified. Do not combine all three papers into one. Instead:

- **Paper 3 absorbs Paper 2's strongest results.** Add a section to
  Paper 3 covering: (a) the operator norm ||L|| = 2/3, (b) the spectral
  radius bound rho(L) <= 1/2, (c) the Lasota--Yorke obstruction, and
  (d) the projective limit relationship sigma(L) = closure(union sigma(P_k)).
  These results take approximately 2--3 pages and strengthen Paper 3
  considerably: they give the theoretical underpinning for the spectral
  claims in the abstract.

- **Paper 1 remains standalone.** It is clean, short, and independent.

This yields two papers instead of three:
1. Paper 3 (expanded) = ghost cycles + operator theory + falsification.
   Target: *Experimental Mathematics*.
2. Paper 1 (unchanged) = 2-adic local constancy. Target: *J. Number Theory*.

If Paper 2 must remain standalone (perhaps for reasons of paper count on
a CV), then submit it third, after both Paper 3 and Paper 1 are accepted.
It can cite both and frame itself as: "Paper 3 showed that ghost
eigenvalues accumulate; here we prove that the standard tool for
controlling such accumulation cannot even be applied."

---

## Why the Current Ordering Is Wrong

Doc-strategy.md recommends Paper 1 first because it is "cleanest,
unaffected by falsification." This reasoning optimizes for safety, not
impact. Specifically:

1. **Leading with a narrow structural result wastes the strongest card.**
   Paper 1 will not generate excitement on its own. It tells the
   community "polynomial continuation does not work," which is a
   closed door. Readers will think: "so what does work?" --- and the
   answer is in Paper 3, which has not been published yet.

2. **Paper 3's priority concern is urgent.** Siegel (2025) is working on
   ghost cycles independently. The case-(a)/(b) classification and the
   density computation are this project's most original contributions.
   Delaying Paper 3 to publish Paper 1 first risks being scooped on the
   most valuable result.

3. **The "unaffected by falsification" argument is backwards.** The
   falsification is a *strength* of Paper 3, not a liability. Self-
   falsification shows scientific integrity and is highly valued by
   referees. The falsification makes Paper 3 more publishable, not less.

4. **Referees judge the second paper by the first.** If Paper 1 is the
   first thing a referee sees from these authors, they will form an
   impression of "competent but incremental." If Paper 3 is first, the
   impression is "interesting computational discovery with rigorous
   follow-through." The second impression is strictly better for the
   reception of subsequent papers.

---

## Dependencies Between Papers

| Paper | Cites Paper 1? | Cites Paper 2? | Cites Paper 3? |
|-------|:-:|:-:|:-:|
| Paper 1 | --- | No | Can cite for context |
| Paper 2 | Can cite for context | --- | Should cite (Thm 3 falsified) |
| Paper 3 | Can cite for local constancy | Can absorb or cite | --- |

None of the papers strictly *requires* another to be published first.
Paper 3 is self-contained. Paper 1 is self-contained. Paper 2 benefits
from citing both but can stand alone (weakly). The dependency structure
does not constrain the ordering.

---

## Venue Considerations

- **Paper 3 at *Experimental Mathematics*:** Excellent fit. The journal
  values computation, conjecture, and narrative. The self-falsification
  story is ideal. The paper should be 18--22 pages after revision.

- **Paper 1 at *J. Number Theory*:** Good fit for a short, clean result
  in 2-adic analysis. The paper is 8--10 pages. *Experimental Mathematics*
  is also possible but the paper lacks the computational narrative that
  journal values.

- **Paper 2 at *Ergodic Theory & Dynamical Systems* or *Nonlinearity*:**
  Possible but the paper is weak for these venues. A negative result
  about Lasota--Yorke on an exotic function space, with the conditional
  theorem falsified, will face skeptical referees. If Paper 2 is
  submitted standalone, *Experimental Mathematics* may be a better
  venue, framing the obstruction as a computational/theoretical discovery
  rather than a failed program.

---

## Summary

| Order | Paper | Target | Status |
|:-----:|-------|--------|--------|
| 1 | Paper 3: Ghost Cycles | *Experimental Mathematics* | Submit after revision is complete |
| 2 | Paper 1: Local Constancy | *J. Number Theory* | Ready now; submit after Paper 3 |
| 3 | Paper 2: Operator Theory | Fold into Paper 3 or submit last | Needs restructuring |
