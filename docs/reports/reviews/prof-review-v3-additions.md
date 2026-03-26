# Review of Four Additions in v3 of "Ghost Cycles of the Syracuse Map"

**Reviewer background:** Dynamical systems, spectral theory, p-adic analysis.
**Date:** 2026-03-12
**Scope:** Four specific additions made in v3. Each assessed for correctness, completeness, gaps, and accuracy of prose.

---

## Addition 1: Projective Limit Remark (lines 231--239)

### Statement reviewed

The new Remark (Projective limit definition) clarifies that the sum in (Lf)(n) runs over odd integer preimages only, that non-integer 2-adic elements are not preimage candidates, and that each valid preimage corresponds to a branch g_v(n) = (n * 2^v - 1)/3 with weight 2^{-v}.

### Assessment

**(1) Mathematical correctness: Sound.**

The claim is correct. The transfer operator L is defined as the projective limit of the finite transfer matrices P_k, each of which acts on the 2^{k-1} odd residues mod 2^k. The preimages in P_k are necessarily odd integers (elements of R_k), and the projective limit inherits this: a preimage m of n under S satisfies 3m + 1 = n * 2^v, so m = (n * 2^v - 1)/3. Since 3 is a 2-adic unit, division by 3 is well-defined in Z_2, but the remark correctly notes that the sum ranges over positive odd integers (or equivalently, odd elements of Z_2 that are genuine preimages of S as an endomorphism of Z_2^{odd}).

**(2) Completeness: Adequate for a remark.**

The key content -- that "non-integer 2-adic elements are not preimage candidates" -- is the operationally important point and is stated clearly. One could expand on why this is so (S is defined as a map on Z_2^{odd}, and each g_v(n) lands in Z_2^{odd} by Lemma 1, so the preimage set is determined by the map's domain), but this is implicit from Lemma 1 and does not need further elaboration in a remark.

**(3) Gaps or unstated assumptions: None significant.**

The remark says "equivalently, m ranges over positive odd integers with S(m) = n." Strictly speaking, in the 2-adic setting one should say "odd 2-adic integers" rather than "positive odd integers," since Z_2^{odd} contains elements like -1/3 that are not positive. However, the preceding sentence already frames the discussion in terms of the projective limit of P_k (which does operate on positive odd residues), so the "positive" qualifier is defensible as referring to the finite-level representatives. This is a minor notational infelicity, not a mathematical error.

**(4) Prose accuracy: Good.**

The remark does what it claims to do and does not overstate. It clarifies the scope of the preimage sum without introducing new results.

**Verdict: PASS.** Clean, helpful clarification. The only suggestion is to replace "positive odd integers" with "odd 2-adic integers" for precision in the 2-adic limit, or to add a parenthetical noting that at finite level the representatives are positive.

---

## Addition 2: Archimedean Non-Compactness (lines 1198--1214)

### Statement reviewed

The paper claims L is not compact on C(Z_2^{odd}, R) by the following argument:

1. For any r >= 1, there exist x = 1 (mod 3) and y = 2 (mod 3) with |x - y|_2 = 2^{-r}.
2. The even-v preimage branches of x and the odd-v preimage branches of y are disjoint clopen sets.
3. Define f = +1 on even branches of x, f = -1 on odd branches of y, with |f| <= 1 elsewhere.
4. Then (Lf)(x) = 1/3, (Lf)(y) = -2/3, so |(Lf)(x) - (Lf)(y)| = 1 regardless of r.
5. Conclusion: the image {Lf : ||f|| <= 1} is not equicontinuous, hence L is not compact.

### Assessment

**(1) Mathematical correctness: Sound, with one point requiring clarification.**

The geometric series computations are correct and follow directly from Proposition 2:
- (Lf)(x) = sum_{v=2,4,...} 2^{-v} * (+1) = (1/4)/(1 - 1/4) = 1/3.
- (Lf)(y) = sum_{v=1,3,...} 2^{-v} * (-1) = -(1/2)/(1 - 1/4) = -2/3.
- Gap = 1/3 - (-2/3) = 1.

The existence of witness pairs (x, y) is correct: {n in Z_2^{odd} : n = 1 mod 3} and {n in Z_2^{odd} : n = 2 mod 3} are both dense in Z_2^{odd} because the 2-adic topology and mod-3 residue are independent (since gcd(2^r, 3) = 1 for all r, every 2-adic ball B(a, 2^{-r}) intersects every mod-3 class). The verification script provides explicit constructions.

The conclusion (not equicontinuous implies not compact) invokes the Arzela-Ascoli theorem, which is the correct tool: on a compact space X (and Z_2^{odd} is compact), a subset of C(X, R) is relatively compact in the sup norm if and only if it is bounded and equicontinuous. Since we exhibit a family of images {Lf : ||f|| <= 1} that fails equicontinuity at every scale, the unit ball's image under L is not relatively compact, so L is not compact.

**The point requiring clarification:** The argument constructs a *different* test function f for each r. The paper says "regardless of r," which could be misread as claiming a single f works for all r simultaneously. In fact, the argument is: for each delta > 0, there exists an f with ||f|| <= 1 and points x, y with |x-y|_2 < delta such that |(Lf)(x) - (Lf)(y)| = 1. This is the negation of equicontinuity of the *set* {Lf : ||f|| <= 1}, which requires: there exists epsilon > 0 such that for all delta > 0, there exist f, x, y with ||f|| <= 1, |x-y|_2 < delta, and |(Lf)(x) - (Lf)(y)| >= epsilon.

The argument as written does establish exactly this (with epsilon = 1), but the prose "regardless of r" slightly obscures that f depends on the pair (x, y), which depends on r. Technically, the function f constructed at each r is different because it is defined relative to different x, y. However, since the gap is always exactly 1 (not depending on r in magnitude), the non-equicontinuity conclusion follows correctly.

Actually, on closer inspection, there is a subtlety worth noting: the function f depends on x and y (since its support involves the preimage branches of x and y), and x and y depend on r. So the correct reading is that for each r, we produce f_r with ||f_r|| <= 1 such that |(Lf_r)(x_r) - (Lf_r)(y_r)| = 1 while |x_r - y_r|_2 = 2^{-r}. This is precisely what non-equicontinuity of {Lf : ||f|| <= 1} means. The proof is correct.

**(2) Completeness: Essentially complete, with one implicit step.**

The disjointness of the two branch sets is stated ("disjoint clopen sets") but justified only by the parenthetical that elements of even branches have v_2(3m+1) even while elements of odd branches have v_2(3m+1) odd. This is correct: if m = g_v(n) then v_2(3m+1) = v by Lemma 1, so the valuation parity of 3m+1 distinguishes the two sets. But this relies on the branches of x and the branches of y being literally disjoint as subsets of Z_2^{odd}, which is stronger than just having different valuation parities.

Let me verify: the even branches of x are {g_v(x) : v = 2,4,6,...} and the odd branches of y are {g_v(y) : v = 1,3,5,...}. Could g_{2j}(x) = g_{2i+1}(y) for some j, i? If so, we would need m = (x * 2^{2j} - 1)/3 = (y * 2^{2i+1} - 1)/3, hence x * 2^{2j} = y * 2^{2i+1}. Since x and y are both odd, this would require 2^{2j} = 2^{2i+1} * (y/x), which is impossible since the left side is a power of 2 with even exponent and the right side has odd exponent (y/x is a 2-adic unit). So the disjointness is indeed guaranteed by the valuation parity, and the argument in the paper (citing even vs. odd v) is sufficient. Good.

The clopen claim for the branch images deserves a word: each g_v(n) is a specific odd 2-adic integer, and the set {g_v(n)} for a single v is a singleton. Countable unions of singletons in Z_2 need not be clopen. However, for defining f it suffices that f is continuous, which holds because f takes values +1 or -1 on specific points and can be extended to a continuous function with |f| <= 1 by the Tietze extension theorem (Z_2^{odd} is compact Hausdorff). The paper says "disjoint clopen sets" -- this is slightly imprecise since individual branch images are singletons (which are closed but not open in Z_2). However, the argument does not actually require the sets to be clopen; it only requires f to be continuous with ||f|| <= 1, and this follows from Tietze. The clopen claim is a minor inaccuracy in the justification, but it does not affect the validity of the proof.

Wait -- I should reconsider. The paper says "f = +1 on even-valuation preimage branches of x." The "even-valuation preimage branches of x" is the set {g_v(x) : v even, v >= 2}. This is a countably infinite set of distinct points. In Z_2, every singleton {a} is indeed clopen (the 2-adic integers are totally disconnected, and {a} = intersection of all balls B(a, 2^{-r}), each of which is clopen). Actually, singletons in Z_2 are closed but NOT open (Z_2 has no isolated points). So the branch sets are closed (countable, closed points) but not open. Tietze extension still applies: define f = +1 on one closed set, f = -1 on a disjoint closed set, extend continuously to all of Z_2^{odd} with |f| <= 1. This works, but the paper's parenthetical "(disjoint clopen sets, so f is continuous)" is technically incorrect -- they are disjoint *closed* sets, and continuity of f follows from Tietze, not from clopenness.

This is a minor expositional error that does not affect the mathematical conclusion.

**(3) Gaps or unstated assumptions:**

- The Tietze extension issue noted above (closed, not clopen).
- The argument implicitly assumes f can be defined to take specific values on two disjoint countable closed sets and still remain continuous with ||f|| <= 1. This is guaranteed by the Tietze extension theorem but should be cited.
- The paper does not explicitly say that f changes with r, though this is logically implied.

**(4) Prose accuracy: Good, with minor issues.**

The phrase "regardless of r" accurately conveys that the gap magnitude (= 1) does not depend on the scale parameter, but could be clarified by noting that f depends on r.

**Verdict: PASS.** The proof is correct and the conclusion is valid. Two minor issues to address in revision:

(a) Replace "disjoint clopen sets" with "disjoint closed sets" and cite Tietze extension (or Urysohn's lemma) for the existence of the continuous test function f.

(b) Consider adding a sentence clarifying that f depends on the pair (x, y) and hence on r, while the gap remains 1 for all r.

---

## Addition 3: Primitivity Remark (lines 719--729)

### Statement reviewed

After Theorem 5 (persistence), a new remark argues that the cycle at each level k = k_0 (mod p) has period exactly L (not a proper divisor). The argument is:

1. The rational orbit elements n~_1, ..., n~_L are distinct (they are determined by the cycle equation with D != 0 and "distinct step indices").
2. Each difference n~_i - n~_j (for i != j) is a nonzero rational with fixed 2-adic valuation.
3. So n_i mod 2^k != n_j mod 2^k for all k > max_{i != j} v_2(n~_i - n~_j).
4. Since k_0 already exceeds this threshold (materialization at k_0 requires period exactly L), and since n~_i mod 2^k is periodic in k with period p, the distinctness holds at every k = k_0 (mod p).

### Assessment

**(1) Mathematical correctness: The conclusion is correct, but the justification of step 1 has a gap.**

The claim that n~_1, ..., n~_L are distinct is true for any genuine periodic orbit of period exactly L (by definition). But the remark needs to establish that the *rational orbit* has period exactly L (minimal period), not merely that it is periodic with period dividing L.

The remark says the distinctness follows from "the cycle equation with D != 0 and distinct step indices." Let me examine this more carefully:

The cycle equation gives n~_1 = R/D. The orbit recurrence n~_{i+1} = (3 n~_i + 1)/2^{v_i} determines n~_2, ..., n~_L uniquely from n~_1 and the valuation pattern. If we had n~_i = n~_j for some 1 <= i < j <= L, then the sub-orbit from position i to position j would be a periodic orbit of length j - i < L with valuation sub-pattern (v_i, ..., v_{j-1}). This sub-orbit would satisfy its own cycle equation with denominator D' = 2^{V'} - 3^{j-i} where V' = v_i + ... + v_{j-1}. The rational starting point of this sub-orbit would be n~_i = R'/D'.

So distinctness of the n~_i is equivalent to saying the valuation pattern (v_1, ..., v_L) is *primitive* -- it is not a repetition of a shorter pattern. This is a condition on the pattern itself, not something that follows from D != 0.

However, the remark is placed after the persistence theorem and implicitly refers to a ghost type (L, V, (v_1, ..., v_L)) that *materializes* at level k_0 with period exactly L. If the pattern were a repetition (v_1,...,v_{L/d}) repeated d times, then the modular cycle at level k_0 would have period L/d, not L. So materialization with period exactly L implies the pattern is primitive, which implies the rational orbit elements are distinct.

The gap is that the remark attributes distinctness to "D != 0 and distinct step indices" rather than to the primitivity of the pattern (equivalently, the materialization hypothesis). The phrase "distinct step indices" is not a standard term and its meaning is unclear. If it means i != j, that is not sufficient to conclude n~_i != n~_j. If it means the valuation pattern is not periodic with a smaller period, then the argument is valid but the terminology is nonstandard and unexplained.

**(2) Completeness: The argument has the right structure but elides the key step.**

Steps 2--4 are correct given step 1. The 2-adic valuation of n~_i - n~_j is indeed fixed (it is a nonzero rational number, so its 2-adic valuation is well-defined and finite). The threshold condition is standard. The periodicity-in-k argument is a direct consequence of the persistence theorem's proof. The only incomplete step is the justification of distinctness.

**(3) Gaps:**

- The justification of distinctness should be: "Materialization at level k_0 with period exactly L implies the modular cycle has L distinct elements mod 2^{k_0}. Since n_i = n~_i mod 2^{k_0}, the rational elements n~_i are pairwise distinct (they differ mod 2^{k_0}, hence a fortiori as rationals)." This is simpler and more direct than the argument given.

- Alternatively: "The valuation pattern (v_1,...,v_L) defining the ghost type has minimal period L (by the definition of ghost type as a primitive cycle). The orbit recurrence with a primitive valuation pattern produces distinct orbit elements whenever D != 0, since a collision n~_i = n~_j would imply the pattern decomposes as a repetition."

Either formulation would close the gap.

**(4) Prose accuracy: Mostly accurate but imprecise in one clause.**

The phrase "distinct step indices" is unclear and does not convey the intended mathematical content.

**Verdict: PASS with revision needed.** The conclusion is correct and follows from the materialization hypothesis, but the *stated* justification ("D != 0 and distinct step indices") does not constitute a proof. The fix is simple: either appeal to the materialization hypothesis directly (the cycle has period exactly L at level k_0, so the L residues are distinct mod 2^{k_0}, hence the rational orbit elements are distinct), or note that the ghost type has a primitive valuation pattern by definition.

---

## Addition 4: The n = -1/3 Exceptional Point Note (lines 225--228)

### Statement reviewed

The parenthetical notes that n = -1/3 is an element of Z_2^{odd} where 3n + 1 = 0, so S maps outside the domain; but since -1/3 has no preimages under S, we have (Lf)(-1/3) = 0 for all f and the operator analysis is unaffected.

### Assessment

**(1) Mathematical correctness: Sound.**

First, -1/3 is indeed in Z_2^{odd}. In Z_2, we have 3^{-1} = sum_{k>=0} (-2)^k / ... more concretely, -1/3 in Z_2 has 2-adic expansion ...10101011 (the unique solution to 3x = -1 in Z_2), which is odd (last bit is 1), so -1/3 is in 1 + 2Z_2 = Z_2^{odd}.

Second, 3(-1/3) + 1 = -1 + 1 = 0, and v_2(0) = infinity, so S is undefined at -1/3 (or, if one extends the definition, S(-1/3) = 0/2^{infinity} is not meaningful). So -1/3 is the unique singular point of S on Z_2^{odd}.

Third, the claim that -1/3 has no preimages under S. A preimage m of -1/3 would satisfy S(m) = -1/3, i.e., (3m+1)/2^{v_2(3m+1)} = -1/3. This means 3m + 1 = -2^v/3 for some v >= 1, i.e., 9m + 3 = -2^v, i.e., 9m = -3 - 2^v. For this to yield m in Z_2^{odd}, we need -3 - 2^v divisible by 9. Now 2^v mod 9 cycles through 2, 4, 8, 7, 5, 1, 2, 4, 8, 7, 5, 1, ... (period 6). So -3 - 2^v mod 9 cycles through -5, -7, -11 = -2, -10 = -1, -8, -4, ... which is 4, 2, 7, 8, 1, 5 mod 9. None of these is 0, so -3 - 2^v is never divisible by 9.

Wait, let me reconsider. The preimage equation is: m is a preimage of n = -1/3 means m = g_v(n) = (n * 2^v - 1)/3 = ((-1/3) * 2^v - 1)/3 = (-2^v/3 - 1)/3 = (-2^v - 3)/9. For this to be in Z_2, we need 9 | (2^v + 3) in Z_2. Since 9 is a 2-adic unit, divisibility by 9 in Z_2 is the same as in Z. We need 2^v = -3 mod 9, i.e., 2^v = 6 mod 9. Checking: 2^1=2, 2^2=4, 2^3=8, 2^4=7, 2^5=5, 2^6=1 mod 9, and repeating. The value 6 never appears in this cycle, so indeed -1/3 has no preimages.

Alternatively, by Lemma 1: -1/3 mod 3 = -1/3 mod 3. Since -1/3 = (-1)(3^{-1}), and in Z/3Z we have 3^{-1} = 0... no, 3 = 0 mod 3, so -1/3 is not well-defined mod 3 in the usual sense. Let me think again. In Z_2, the element -1/3 has a well-defined residue mod 3: we compute -1/3 mod 3. Since 1/3 is the 2-adic limit of numbers congruent to 0 mod 3 (namely, 1/3 itself is the element x with 3x = 1, so x mod 3 satisfies 3x = 1 mod 3, hence 0 = 1 mod 3, a contradiction). Actually, 1/3 is not in Z_2 in the usual sense because 3 is a unit. Let me be more careful: -1/3 in Z_2 is the element x satisfying 3x = -1. Then 3x mod 3 = 0, but -1 mod 3 = 2, so 0 = 2 mod 3 is a contradiction...

No. The issue is that -1/3 as an element of Z_2 is perfectly well-defined: it is the unique 2-adic integer x with 3x = -1. To find x mod 3: from 3x = -1, reducing mod 3 gives 0 = -1 = 2 mod 3, which is a contradiction. This means -1/3 is not in Z, but it is in Z_2. The residue "mod 3" of a 2-adic integer that is not a rational integer requires care. In Z_2, every element has a well-defined image in Z_2/3Z_2 = Z/3Z (since 3 is a unit in Z_2, we have 3Z_2 = Z_2, so Z_2/3Z_2 is trivial). Actually, that's the point: since 3 is a unit in Z_2, the ideal 3Z_2 = Z_2, so the quotient Z_2/3Z_2 = 0. The "mod 3" operation is not well-defined on Z_2 in the ring-theoretic sense.

However, we can still ask: does -1/3 have preimages under S? The preimage branches are g_v(n) = (n * 2^v - 1)/3 = ((-1/3) * 2^v - 1)/3 = (-2^v - 3)/(3 * 3) = (-2^v - 3)/9. For g_v(-1/3) to be in Z_2, we need (-2^v - 3)/9 to be a 2-adic integer, equivalently 9 | (2^v + 3) in Z. As computed above, 2^v + 3 mod 9 cycles through 5, 7, 2, 1, 8, 4 (for v = 1,...,6), never hitting 0. So g_v(-1/3) is not a 2-adic integer for any v >= 1.

This confirms the paper's claim: -1/3 has no preimages under S (no valid branch g_v lands in Z_2), so (Lf)(-1/3) = 0 for all f, and the transfer operator is well-defined at -1/3 with the convention that an empty sum equals 0.

Fourth, the claim that the analysis is unaffected. Since (Lf)(-1/3) = 0 for all f, the operator L is well-defined on all of C(Z_2^{odd}). The point -1/3 contributes nothing to the spectral behavior of L: it is mapped to 0 regardless of f, and no orbit can reach it (since it has no preimages, no cycle passes through it). This is correct.

**(2) Completeness: Adequate for a parenthetical.**

The essential facts are stated: -1/3 is in the domain, S is undefined there, it has no preimages, and (Lf)(-1/3) = 0. A reader who wants the details can verify the no-preimage claim as above. For a parenthetical remark, this level of detail is appropriate.

**(3) Gaps or unstated assumptions:**

One could note that -1/3 is the *unique* point in Z_2^{odd} where S is undefined (the only solution to 3n + 1 = 0 in Z_2). The paper says "the sole exception" earlier in the same sentence, which covers this. No significant gap.

**(4) Prose accuracy: Precise and appropriate.**

**Verdict: PASS.** Clean and correct. No revision needed.

---

## Summary Table

| Addition | Correctness | Completeness | Gaps | Prose | Verdict |
|----------|------------|-------------|------|-------|---------|
| 1. Projective limit remark | Sound | Adequate | "Positive odd" should be "odd 2-adic" | Good | PASS (minor wording) |
| 2. Archimedean non-compactness | Sound | Essentially complete | "Clopen" should be "closed" + cite Tietze; clarify f depends on r | Good | PASS (two minor fixes) |
| 3. Primitivity remark | Conclusion correct | Key step elided | "Distinct step indices" does not justify distinctness; needs appeal to materialization | Imprecise | PASS with revision |
| 4. n = -1/3 note | Sound | Adequate | None | Precise | PASS |

---

## Detailed Recommendations

### Addition 2 (non-compactness) -- suggested replacement for the parenthetical:

Current: "(disjoint clopen sets, so f is continuous)"

Suggested: "(disjoint closed subsets of the compact space Z_2^{odd}; by the Tietze extension theorem, f extends to a continuous function with ||f|| <= 1)"

Also add after "regardless of r": "Note that f depends on the pair (x, y) and hence on r, but the gap magnitude is always 1."

### Addition 3 (primitivity) -- suggested replacement for the distinctness justification:

Current: "they are determined by the cycle equation with D != 0 and distinct step indices, so n~_i - n~_j != 0 for i != j"

Suggested: "materialization at level k_0 with period exactly L means the L modular residues n_1, ..., n_L are distinct mod 2^{k_0}; since n_i = n~_i mod 2^{k_0}, the rational orbit elements n~_1, ..., n~_L are pairwise distinct"

This is cleaner because it uses a hypothesis (period exactly L at materialization) that is already part of the setup, rather than trying to derive distinctness from the algebraic structure of the cycle equation.

---

## Overall Assessment

All four additions are mathematically sound in their conclusions. Additions 1 and 4 require no substantive changes. Addition 2 has a correct proof with two minor expositional inaccuracies (clopen vs. closed; implicit dependence of f on r) that should be fixed before submission. Addition 3 has a correct conclusion but an incomplete justification that needs a one-sentence repair. None of the additions introduce circular reasoning or unsupported claims about the Collatz conjecture itself. The paper accurately represents what is proved versus what is conjectured throughout these additions.
