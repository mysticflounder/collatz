# Final Referee Report: "Ghost Cycles as 2-Adic Periodic Orbits: Spectral Theory of the Syracuse Transfer Operator"

**Reviewer:** Internal review (dynamical systems, spectral theory, p-adic analysis)
**Date:** 2026-03-07
**Target venue:** *Experimental Mathematics*
**Status:** Post-revision final review

---

## 1. Checklist: Previous Review Requirements

The previous review (2026-03-06) listed 9 required changes and 2 desirable changes. I evaluate each against the revised paper.

### Required Changes

**R1. Add a definitions section (S, S_k, P_k, rho_k, E).**
**PASS.** Section 2 ("Definitions and Setup") now contains Definitions 1--5 covering the Syracuse map, the modular Syracuse map, the transfer matrix, the spectral radius, and the exceptional set. The spectral radius definition correctly notes the equivalence between the cycle-based formula max 2^{-V/L} and the linear-algebraic spectral radius, with the explanation that P_k has the structure of a weighted permutation matrix restricted to recurrent classes. This was one of my main concerns and it is handled well.

**R2. Either prove Theorems A, B, C in the paper or cite published sources precisely. Theorem C (persistence) needs a complete proof.**
**PASS.** This is the most significant improvement. Theorem 1 (cycle equation) now has a self-contained proof (the standard iterated-substitution argument), with attribution to Steiner (1977) and Wirsching (1998). Theorem 2 (persistence of case-(a) ghosts) now has a full proof spanning valuation stability, periodicity of the modular reduction, and verification at level k. The proof correctly identifies the key mechanism: n_tilde_i mod 2^k depends only on k mod p, so conditions (i)--(iii) are periodic. Baker--Wustholz appears as Proposition 1 with a clear statement and attribution to Baker--Wustholz (1993) and Laurent (2008).

**R3. Remove claims from the abstract not backed by proofs in the paper (rho(L) bounds, Lasota--Yorke obstruction), OR add the proofs.**
**PASS.** The abstract no longer claims rho(L) bounds or mentions the Lasota--Yorke obstruction. The scope has been correctly narrowed to the finite-level matrices P_k. The abstract now says "ghost cycles are modular projections of 2-adic periodic orbits whose rational elements are negative in all computed cases" --- the hedging "in all computed cases" is honest and accurate. The paper no longer overpromises.

**R4. Fill in the missing data in the ghost type table (D = -5537, D = -1675).**
**PASS.** The table in Section 4.4 now contains complete data for all four ghost types: v-patterns, rational orbit elements n_tilde, periods p, residue counts r, and spectral radii rho.

**R5. Fix the error: rho for D = -5537 was listed as 0.4353 but should be 2^{-10/8} ~ 0.4204.**
**PASS.** The table now lists rho = 0.4204 for D = -5537 (L = 8, V = 10, rho = 2^{-10/8}). Confirmed correct.

**R6. Add a related work subsection positioning this relative to Siegel, Matthews, Wirsching, and Tao.**
**PASS.** The Introduction now contains a "Related work" paragraph that cites Matthews and Watts (1985), Wirsching (1998), Lagarias and Weiss (1992), Tao (2022), Steiner (1977), and Siegel (2025). The positioning relative to Siegel is explicit: "Siegel (2025) independently uses the term 'ghost cycles' for 2-adic periodic orbits of the 3x+1 map; our work differs in computing the density of exceptional levels and classifying ghost persistence." This is adequate.

**R7. Prove or carefully qualify the "reformulation" (Conjecture 3 / Remark): explain why a 2-adic periodic orbit with positive rational elements must consist of positive integers.**
**PASS.** The Remark following Conjecture 3 now addresses this gap directly. It states: "If a 2-adic periodic orbit n_tilde_1, ..., n_tilde_L has n_tilde_i = R_i / D with all R_i / D positive integers, these integers form a true Collatz cycle (since the valuation conditions and the Syracuse map agree on Z_{>0} subset Z_2). Conversely, any positive-integer Collatz cycle is a case-(a) 2-adic orbit with positive rational elements. Thus Conjecture 3 is equivalent to the nonexistence of non-trivial positive-integer Collatz cycles." The remark then explicitly addresses the non-integer case: "Note that if R_i / D is a positive non-integer rational, the orbit elements are not positive integers, and the connection to Collatz cycles on Z_{>0} does not apply; the conjecture is specifically about the sign of the rational elements." This closes the gap I identified. The equivalence is correctly stated.

**R8. State the density formula's independence assumption explicitly.**
**PASS.** Conjecture 1 now states: "Assuming the arithmetic progressions for distinct ghost types have coprime periods, the density decomposes as [formula]." The text adds: "If two ghost types have periods sharing a common factor, an inclusion-exclusion correction is needed." This is the correct qualification.

**R9. Compress or cut Sections 2--3 (phase transition and parameter space) to focus the narrative.**
**PASS.** The former Sections 2--3 have been compressed into a single Section 3 ("The Parametric Family") running approximately 1 page with two figures. The Lyapunov exponent subsection has been eliminated. The paper now follows the recommended structure: Introduction -> Definitions -> Parametric Family -> Exceptional Set -> Falsification -> Eigenvalues -> Computation. This is much tighter.

### Desirable Changes

**D10. Include Baker--Wustholz exclusion result (Theorem D equivalent) to show what these bounds CAN do.**
**PASS.** Proposition 2 ("Exclusion of bounded-length ghosts") now appears in Section 4.5 with a proof. It states that for fixed L_0, no ghost of length L <= L_0 with rho > 1/4 exists beyond K_0(L_0), with explicit values K_0(5) <= 269, K_0(10) <= 465,239. The Remark correctly notes that this cannot prove E finite because bounding L as a function of k is beyond current transcendence theory. This is a nice, clean unconditional result.

**D11. Explain the eigenvalue count vs cycle length relationship in Section 6.**
**PASS.** Section 6 now explains: "The nonzero eigenvalue count is explained by cycle lengths: the fixed point {1} contributes 1 eigenvalue (1/4), and each extra cycle of length L contributes L nonzero eigenvalues (the Lth roots of 2^{-V})." Explicit arithmetic is given for k = 10, 11, 12. This connection between graph theory and linear algebra is now clear.

**D12. Add a ghost reappearance timeline figure.**
**PASS.** Figure 3 (ghost_timeline.png) shows ghost appearances by level k, with each row a ghost type and a vertical dashed line at k = 36 marking the exhaustive search boundary. The caption correctly notes that beyond k = 36, memberships are computed algebraically from Theorem 2.

**Score: 9/9 required, 3/3 desirable. All changes addressed.**

---

## 2. Mathematical Correctness

### Theorem 1 (Cycle equation)
**Correct.** The iterated-substitution proof is standard and complete. The modular arithmetic is correct: iterating n_{i+1} * 2^{v_i} = 3n_i + 1 gives n_1 * 2^V = 3^L * n_1 + R. The congruence modulo 2^{k+V} is correctly justified by noting that each step preserves residues mod 2^k with V additional bits of accumulated shift.

### Definition 6 (Case-(a) vs case-(b) classification)
**Correct.** The case-(a) assertion that the rational orbit is a true periodic orbit now includes the one-sentence justification I requested: "since the valuation conditions determine the Syracuse map step exactly, iterating S on n_tilde_1 produces n_tilde_2, ..., n_tilde_L, n_tilde_1." This is correct.

### Theorem 2 (Persistence of case-(a) ghosts)
**Correct, with one minor note.** The proof has three parts:

1. *Valuation stability:* The argument that v_2(3 n_tilde_i + 1) = v_i is independent of k is correct. Writing n_tilde_i = a_i / |D| with a_i odd, the condition depends on 3a_i + |D| modulo 2^{v_i + 1}, which is a fixed finite computation.

2. *Periodicity of modular reduction:* The claim that D^{-1} mod 2^k is periodic in k with period dividing p = ord_2(|D|) is correct. The key identity is that 2^p = 1 mod |D| implies D^{-1} has a p-periodic 2-adic expansion. This is a standard fact about 2-adic inverses.

3. *Verification at level k:* Conditions (i)--(iii) are correctly stated. Condition (ii) requires k > v_i for all i, which holds for k >= k_0 since k_0 is the first appearance level.

**Minor note:** The proof states the ghost reappears "at all levels k equiv k_0 mod p with k >= k_0." Strictly, the proof establishes that conditions (i)--(iii) are satisfied whenever k equiv k_0 mod p and k >= k_0, but it does not prove the converse (that no other k works). The converse is not needed for the density bound, but the paper should be clear that the arithmetic progression is a sufficient condition for reappearance. Reading the theorem statement again, it says "then it reappears at all levels k equiv k_0 mod p with k >= k_0" --- this is the correct direction (sufficient, not necessary), so it is fine as stated.

### Propositions 1--2 (Baker--Wustholz bounds)
**Correct in statement, with a caveat.** Proposition 1 states |2^V - 3^L| > max(2^V, 3^L) * exp(-25 (log V)^2) for V >= 3. This is a specialization of Laurent (2008), Corollary 1, to the linear form V log 2 - L log 3, with specific numeric constants. I cannot verify the constant 25 by inspection; the Baker--Wustholz theorem involves constants that depend on the degree and height of the algebraic numbers involved. **FLAG FOR IMPLEMENTER: Verify that the constant 25 in Proposition 1 is correct by checking against Laurent (2008), Corollary 1, with n = 2 (two logarithms), b_1 = V, b_2 = L, alpha_1 = 2, alpha_2 = 3.** The qualitative conclusion (superexponential growth of |D|) is certainly correct regardless of the specific constant.

Proposition 2 (exclusion of bounded-length ghosts) is a clean corollary. The proof correctly notes that for fixed (L, V), the denominator D is fixed, each v-pattern either persists periodically or finitely, and all appearances are bounded by ord_2(|D|). **FLAG FOR IMPLEMENTER: Verify the explicit bounds K_0(5) <= 269 and K_0(10) <= 465,239 by computing ord_2(|2^V - 3^L|) for all (L, V) in the relevant ranges.**

### Ghost type table (Section 4.4)
I check the data by inspection where possible:

- D = -601: L = 6, V = 7. D = 2^7 - 3^6 = 128 - 729 = -601. Correct. rho = 2^{-7/6} ~ 0.4454. Correct.
- D = -179: L = 5, V = 6. D = 2^6 - 3^5 = 64 - 243 = -179. Correct. rho = 2^{-6/5} ~ 0.4353. Correct.
- D = -5537: L = 8, V = 10. D = 2^{10} - 3^8 = 1024 - 6561 = -5537. Correct. rho = 2^{-10/8} = 2^{-5/4} ~ 0.4204. Correct.
- D = -1675: L = 7, V = 9. D = 2^9 - 3^7 = 512 - 2187 = -1675. Correct. rho = 2^{-9/7} ~ 0.4102. Correct.

All D values are odd (since 2^V - 3^L is always odd: 2^V is even, 3^L is odd, so 2^V - 3^L is odd). Correct.

**FLAG FOR IMPLEMENTER: Verify the claimed periods p = ord_2(|D|) for each ghost type.** The periods are: D = -601 -> p = 25, D = -179 -> p = 178, D = -5537 -> p = 84, D = -1675 -> p = 660. These are the multiplicative orders of 2 modulo 601, 179, 5537, 1675 respectively. The first two can be partially checked: ord_2(601) divides phi(601) = 600. Since 25 | 600, p = 25 is plausible. For 179 (prime), phi(179) = 178. If p = 178, then 2 is a primitive root mod 179 --- this is plausible but not trivially verified.

**FLAG FOR IMPLEMENTER: Verify the rational orbit elements n_tilde = R/D listed in the table.** The computation of R requires summing 3^{L-1-i} * 2^{S_i} for specific v-patterns, which I will not perform by hand.

### Density lower bound
The claim delta(E) >= 1/25 = 4% follows from: (1) D = -601 is case-(a) (verified computationally), (2) case-(a) ghosts reappear at all k equiv k_0 mod p (proved in Theorem 2), (3) p = 25 for D = -601. This chain of reasoning is correct. The density bound is unconditional assuming the case-(a) verification is correct. The paper is appropriately clear about this: the arithmetic progression structure is proved, and the case-(a) classification rests on computational verification.

The combined density formula 1 - (24/25)(175/178)(82/84)(657/660) ~ 8.3% uses the coprime-periods assumption. **I note that gcd(25, 84) = 1, gcd(25, 178) = 1, gcd(25, 660) = 5 != 1.** Since 25 = 5^2 and 660 = 4 * 5 * 33, the periods for D = -601 and D = -1675 share a common factor of 5. The independence assumption is therefore not exactly satisfied for these two ghost types. The paper correctly caveats this with "if two ghost types have periods sharing a common factor, an inclusion-exclusion correction is needed." But I would recommend the paper explicitly note that this situation already arises among the four known ghosts (gcd(25, 660) = 5), so the 8.3% figure is approximate. This is a **MINOR** issue: the lower bound delta(E) >= 4% from D = -601 alone is unconditional.

### Conjecture 3 and Remark
The equivalence stated in the Remark is now correct. The argument: if all n_tilde_i = R_i / D are positive integers, they form a Collatz cycle (trivial direction). Conversely, any positive-integer Collatz cycle gives a case-(a) 2-adic orbit with positive integer (hence positive rational) elements. The remark correctly notes that positive non-integer rationals do not imply positive-integer cycles. The conjecture is about the sign of n_tilde, not about whether n_tilde is an integer.

One subtle point: could a case-(a) 2-adic orbit have positive rational elements that are not integers? If n_tilde_i = R_i / D and |D| > 1 and |D| does not divide all R_i, then yes. In that case, the orbit elements are positive non-integer rationals in Q intersect Z_2, and the Syracuse map S restricted to Z_2 maps them to each other via the prescribed valuations. Such an orbit would live in Q_2 but not in Z_{>0}. This is NOT a Collatz cycle on positive integers, and Conjecture 3 (negativity of all rational elements) would be false without contradicting the Collatz conjecture. The paper correctly identifies this logical gap: "the conjecture is specifically about the sign of the rational elements." Conjecture 3 is therefore strictly stronger than the Collatz conjecture. The paper should consider stating this explicitly (see Minor Issues below).

### Eigenvalue spectra (Section 6)
The claim that non-exceptional k in [3, 15] have spectrum {0, 1/4} is a computational result. The explanation via cycle lengths is correct: a unique cycle (the fixed point {1}) contributes exactly one nonzero eigenvalue (1/4 = 2^{-2}). The Fredholm determinant det(I - zP_k) = 1 - z/4 for non-exceptional k follows immediately.

The relationship between eigenvalue count and cycle structure is now clearly explained. For k = 12: the paper claims "two extra cycles of lengths 7 and 6, corresponding to the D = -1675 and D = -601 ghost types respectively." **Check:** D = -601 has L = 6 (correct). D = -1675 has L = 7 (correct). So k = 12 should have 1 + 6 + 7 = 14 nonzero eigenvalues. The table says 14. Consistent.

For k = 10: "one extra cycle of length 26." The table says 27 nonzero eigenvalues = 1 + 26. **Observation:** This cycle (L = 26) does not correspond to any of the four known ghost types (which have L = 5, 6, 7, 8). This is one of the k values (10, 11, 20) described as "corresponding to ghost types not yet classified." The paper does not discuss what ghost type produces L = 26 at k = 10. This is not a problem per se --- the paper focuses on the four classified types --- but it would strengthen the paper to note that the long cycles at k = 10, 11, 20 are case-(b) ghosts (which do not persist), if that is what the computation shows. Currently the paper says "three levels (k = 10, 11, 20) correspond to ghost types not yet classified." **FLAG FOR IMPLEMENTER: Confirm that the ghost cycles at k = 10, 11, 20 are case-(b) and state this in the paper.**

---

## 3. Presentation Quality

### Structure
The paper now follows a clean logical arc: Introduction (with related work) -> Definitions -> Parametric Family (brief) -> Exceptional Set and Ghost Cycles -> Falsification and New Conjectures -> Eigenvalue Spectra -> Computational Methodology. This is well-suited to *Experimental Mathematics*.

### Writing quality
The writing is clear and mostly concise. Technical definitions are precise. The proof of Theorem 2 is well-structured with labeled parts (Valuation stability, Periodicity, Verification). The Remark on Conjecture 3 handles the subtle logical point about the connection to the Collatz conjecture with care.

### Figures and tables
The paper has reduced its figure count. The remaining figures serve clear purposes:
- Figure 1 (spectral radius vs x): contextualizes the phase transition.
- Figure 2 (phase diagram): provides the parameter-space overview.
- Figure 3 (ghost timeline): the most informative figure, showing the periodic reappearance pattern.
- Figure 4 (Fredholm zeros): supports the eigenvalue section.
- Figure 5 (Pade poles): the weakest figure --- see Minor Issues.

Tables are well-formatted and contain the necessary data.

### Length
The paper is a reasonable length for *Experimental Mathematics*. The compression of the parametric family section was effective.

---

## 4. Remaining Issues

### BLOCKING

None. All blocking issues from the previous review have been resolved.

### MINOR

**M1. Coprime periods caveat.** As noted above, gcd(25, 660) = 5, so the independence assumption in Conjecture 1's density formula is already violated among the four known ghost types. Add a sentence acknowledging this: "We note that gcd(p_{-601}, p_{-1675}) = gcd(25, 660) = 5, so the coprime assumption is not exactly satisfied; the 8.3% figure is therefore approximate, though the qualitative conclusion (delta(E) > 0) is unaffected."

**M2. Conjecture 3 vs Collatz conjecture.** The paper should state explicitly that Conjecture 3 is at least as strong as the Collatz conjecture: it implies the nonexistence of non-trivial positive-integer cycles (one direction of the Collatz conjecture), but it also excludes positive non-integer rational orbits, which is a logically independent condition. A single sentence would suffice.

**M3. Unclassified ghosts at k = 10, 11, 20.** The paper mentions "three levels (k = 10, 11, 20) correspond to ghost types not yet classified." If these are case-(b) ghosts (which do not persist), stating this would strengthen the paper by showing that the classification framework is complete for the exhaustive search range: all persistent ghosts are accounted for, and the remaining ghosts are transient.

**M4. Pade approximant figure.** Figure 5 (Pade poles) is mentioned without any theorem, conjecture, or detailed discussion. It is a loose end. Either develop it (e.g., conjecture about pole locations) or remove it.

**M5. Verification clarification.** Section 7.5 says "All results for k = 3, ..., 24 are verified against an independent computation (99 unit tests)." The word "independent" could mean verified against published literature or against a separate implementation. The text clarifies it is the latter (the test suite in the repository). For a journal paper, stating "verified against a separate implementation" is more precise than "independent computation."

**M6. ARPACK remark.** The Remark in Section 6 about ARPACK artifacts is useful for practitioners but slightly out of place in a mathematical paper. Consider moving it to Section 7 (Computational Methodology) or a footnote.

---

## 5. Overall Verdict

**The paper is ready for submission to *Experimental Mathematics*, subject to the minor edits above (M1--M6).**

The revision has been thorough and responsive. All nine required changes from the previous review have been addressed, along with all three desirable changes. The paper now contains:

- **A clean definitions section** that makes the paper self-contained.
- **A complete proof** of the main theoretical result (Theorem 2, persistence of case-(a) ghosts).
- **An honest abstract** that accurately reflects the paper's content without overclaiming.
- **A well-organized narrative** progressing from definitions through computation to falsification and new conjectures.
- **Correct numerical data** in all tables (the D = -5537 error has been fixed).
- **Proper positioning** relative to existing literature.
- **Clear demarcation** between what is proved, what is verified computationally, and what is conjectured.

The core contribution --- the case-(a)/(b) classification and the proof that case-(a) ghosts make E infinite with positive density --- is novel, correct, and appropriate for *Experimental Mathematics*. The falsification narrative is scientifically valuable. The computational evidence is extensive (exhaustive through k = 36, algebraic verification through k = 200) and reproducible.

**Items for the implementer to verify before submission:**

1. The constant 25 in Proposition 1 (Baker--Wustholz specialization).
2. The explicit bounds K_0(5) <= 269 and K_0(10) <= 465,239 in Proposition 2.
3. The periods p = ord_2(|D|) for all four ghost types.
4. The rational orbit elements n_tilde = R/D for all four ghost types.
5. Whether the ghost cycles at k = 10, 11, 20 are case-(b).

None of these are likely to reveal problems --- they are consistency checks on computational data that has been extensively tested --- but they should be confirmed before a journal submission.

**Recommendation: Accept for submission with minor edits (M1--M6).**
