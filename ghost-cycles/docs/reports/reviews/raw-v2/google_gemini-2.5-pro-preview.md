Of course. As a referee for a mathematics journal, I have reviewed the preprint "Ghost Cycles of the Syracuse Map: 2-Adic Periodic Orbits and the Exceptional Set" by Adam McKenna.

Here is my section-by-section review.

---

### **Referee Report: McKenna, "Ghost Cycles of the Syracuse Map"**

**Recommendation:** Major Revision

This is an ambitious and impressive paper making several significant claims about the spectral theory of the Collatz transfer operator on the 2-adic integers. The work contains a mix of deep, correct insights, extensive computational results, and major new theorems. However, it is marred by several critical gaps in its most important proofs and some organizational issues. The core new results, particularly the unconditional proofs of "Negative Rationality" and "Universal Case-(a)", appear to be correct in their strategy but are presented without the necessary algebraic details, rendering them unverifiable in their current form.

Below is a detailed section-by-section analysis.

---

#### **1. Abstract & Introduction**

*   **Claims:** The paper introduces "ghost cycles" as 2-adic periodic orbits of the Syracuse map. It claims these cycles persist, forcing the exceptional set $E$ (levels $k$ with extra modular cycles) to have positive density. It lists ten major contributions, including two "obstruction" theorems ruling out standard spectral approaches, a persistence theorem for ghost cycles, and unconditional proofs for two central conjectures ("Negative Rationality" and "Universal Case-(a)").
*   **Mathematics & Framing:** The framing is appropriate and the claims are well-scoped, if numerous. The introduction correctly situates the work within the existing literature (Lagarias, Wirsching, Tao, etc.) and properly attributes the term "ghost cycle" to Dhiman and Pandey (2026). The list of contributions is clear, though the sheer number makes the paper feel dense. The central narrative—that ghost cycles are not modular artifacts but persistent 2-adic structures with profound consequences for the operator's spectrum—is compelling.
*   **Concerns:**
    1.  **Organizational Confusion:** The outline provided at the end of the introduction does not match the paper's actual section numbering. For example, it lists the Lasota-Yorke obstruction as Section 4 and the 2-adic obstruction as Section 5, but the text of the introduction lists them in the opposite order. This should be corrected.
    2.  **Forward Referencing:** Key results are proven much later than they are stated. For instance, Theorem 5 ("Universal Case-(a)") is stated in Section 7 but only proven as Theorem 9 in Section 9. While not a fatal flaw, this makes the paper harder to follow.
    3.  **Definitional Overreach:** Definition 6 states that "every ghost cycle is the modular projection of a genuine periodic orbit ... whose elements are negative rationals." This is a major theorem (Theorem 8), not a definition. It should be stated as a theorem in the main body and only alluded to in the preliminary definitions.

#### **2. Transfer Matrix (Section 3)**

*   **Claims:** This section defines the transfer operator $\mathcal{L}$ on $C(\mathbb{Z}_2^{\mathrm{odd}})$, establishes its operator norm as $\|\mathcal{L}\| = 2/3$, provides an upper bound on its spectral radius $\rho(\mathcal{L}) \leq 1/2$, and presents a six-part spectral theorem (Theorem 1).
*   **Mathematics & Framing:** The construction of the operator and the derivation of its preimages (Lemma 1) are standard and correct. The calculation of the operator norm via the weight function $W(n) = (\mathcal{L}\mathbf{1})(n)$ in Proposition 2 is correct and a nice, explicit result. The spectral radius bound in Proposition 3 is also correct.
*   **Concerns:**
    1.  **Proof by Computation:** Theorem 1(c) claims the eigenvalue $\lambda=1/4$ is simple, but the proof is "verified computationally." This is insufficient for a mathematical proof. The author should state this as a computational observation or conjecture. What was verified? That no other cycle with product $2^{-V}=1/4$ was found, or that the geometric multiplicity of the eigenvalue $1/4$ for $P_k$ is 1 for all tested $k$? The latter is a stronger claim and requires more evidence.
    2.  **Proof by Assertion:** Theorem 1(f) claims $\sigma(P_k) = \{0, 1/4\}$ for non-exceptional $k \leq 36$, again "verified by dense eigenvalue computation." This is an empirical observation, not a theorem, and should be labeled as such. (See also concerns for Section 10).
    3.  **Sketchy Proof:** The proof of Theorem 1(e), $\sigma(\mathcal{L}) = \overline{\bigcup \sigma(P_k)}$, is a standard result for such operator approximations, but the proof given is a sketch. It relies on "norm-resolvent convergence on this dense domain," which should be either cited from a standard text (e.g., Kato, *Perturbation Theory for Linear Operators*) or given a more rigorous, self-contained proof.

#### **3. Spectral Theory (Section 4 - Lasota-Yorke Obstruction)**

*   **Claims:** The operator $\mathcal{L}$ does not preserve the Lipschitz space $\mathrm{Lip}_1(\mathbb{Z}_2^{\mathrm{odd}})$ or any Hölder space $C^\alpha(\mathbb{Z}_2^{\mathrm{odd}})$, obstructing any Lasota-Yorke-type spectral gap argument based on 2-adic regularity.
*   **Mathematics & Framing:** The mathematics here is sound and elegant. The proof of Theorem 2 is a highlight of the paper. It constructs a sequence of 2-adically close points where the image under $\mathcal{L}\mathbf{1}$ remains separated, definitively showing the Lipschitz semi-norm of $W = \mathcal{L}\mathbf{1}$ is infinite. The "Root cause" remark correctly identifies the tension between the 2-adic and 3-adic structures as the source of the problem.
*   **Concerns:** None. This section is correct, well-argued, and a significant contribution.

#### **4. Obstructions (Section 5 - 2-Adic Unboundedness)**

*   **Claims:** The operator $\mathcal{L}$ is unbounded on the 2-adic Banach space $C(\mathbb{Z}_2^{\mathrm{odd}}, \mathbb{Q}_2)$, with the norm of its finite-dimensional approximations $\|P_k\|_{2\text{-adic}}$ growing as $2^{k+O(1)}$. This obstructs any approach based on Mahler coefficients or 2-adic nuclearity (the Amice program).
*   **Mathematics & Framing:** This is another excellent and correct result. The proof of Theorem 3 is clear and convincing. It correctly identifies that the 2-adic operator norm is determined by the maximum 2-adic size of the matrix entries, which is $2^{\max v_j}$. The argument that $\max v_j$ must be of order $k$ is sound.
*   **Concerns:** None. This section, like the previous one, presents a strong, well-proven, and important negative result.

#### **5. Ghost Cycles (Section 7)**

*   **Claims:** This section formally defines ghost cycles via the cycle equation (Theorem 4), classifies them into case-(a) and case-(b) based on whether the rational limit satisfies the valuation pattern, and proves the persistence of case-(a) ghosts (Theorem 6).
*   **Mathematics & Framing:** The cycle equation is standard. The case-(a)/(b) classification is a crucial and clear distinction. The persistence theorem (Theorem 6) is a key result, correctly linking the reappearance of ghost cycles to the multiplicative order of 2 modulo the cycle denominator $|D|$.
*   **Concerns:**
    1.  **Sketchy Proof:** The proof of Theorem 4 (cycle equation) is a sketch. While the result is well-known, the claim about accumulating precision to `mod 2^(k+V)` should be justified more carefully, perhaps by induction.
    2.  **Minor Gap in Persistence Proof:** The proof of Theorem 6 argues that the modular cycle $n_i = \tilde{n}_i \pmod{2^k}$ persists. The argument relies on the periodicity of $\tilde{n}_i \pmod{2^k}$ and the fact that the valuation conditions $v_2(3n_i+1)=v_i$ hold for large enough $k$ because they hold for $\tilde{n}_i$. The logic is sound but could be stated more precisely. For instance, it should be explicit that "first appearance at $k_0$" implies $k_0$ is large enough for the modular valuations to match the rational ones, a condition that then holds for all larger $k$. The primitivity remark is good but its proof is also a sketch.

#### **6. Persistence (Section 8 - Census of Ghost Types)**

*   **Claims:** This section presents a computational census of ghost cycles up to length $L=12$, organizing them into families by excess valuation $e=V-L$. It identifies 88+ materializing ghost types and provides detailed tables for the $V=L+1$ and $V=L+2$ families.
*   **Mathematics & Framing:** This is a computational section. The results are presented clearly. The heuristic explanation for the non-materialization of certain ghosts (based on the ratio $p/2^L$) is good scientific practice. The distinction between the number of materializing patterns and the number of residue classes is important and well-explained.
*   **Concerns:**
    1.  **Verifiability:** As with any computational result, a referee must take the author's claims on faith or invest significant effort in reproducing them. The public code repository is a major point in the author's favor.
    2.  **Unproven Assertion:** The text mentions an algebraic property of denominators for even $L$ ("proved via the norm form..."). This is an interesting claim that should either be proven (e.g., in an appendix) or removed if it is not essential to the main argument.

#### **7. Density & Spectral Radius (Section 9)**

*   **Claims:** This section proves that the exceptional set $E$ has positive density, presents conjectures for the exact density and the spectral radius, and, most importantly, provides proofs for a general orbit formula (Thm 7), Negative Rationality (Thm 8), and Universal Case-(a) (Thm 9).
*   **Mathematics & Framing:** The falsification of the density-zero conjecture is correct and a direct consequence of Theorem 6. The new conjectures (1 and 2) are well-motivated and plausible. The proof strategies for Theorems 7, 8, and 9 are the most significant new contributions of the paper. The idea of using a closed-form expression for the orbit elements to prove the case-(a) property and their sign is brilliant.
*   **Concerns:**
    1.  **FATAL GAP: Missing Proofs.** The proofs of Theorem 7 (General orbit formula) and Theorem 9 (Universal Case-(a)) are the heart of the paper, yet they are not provided. The author states that the recurrence is solved to get Theorem 7, and that Theorem 9 follows from a "direct expansion" and a "term by term" match. The paper then refers to markdown files in a code repository. **This is unacceptable for a mathematical publication.** The full, detailed, and self-contained algebraic derivations must be included in the paper, for example in an appendix. Without these proofs, the paper's main claims are unsubstantiated.
    2.  **Consequence of Gap:** The proof of Theorem 8 (Negative Rationality) is elegant, but it is entirely conditional on the correctness of the unproven Theorem 7.

#### **8. Negative Rationality (Section 11 - Computational Methodology)**

*This section of the prompt appears to be mislabeled based on the paper's content. I will review Section 11 of the paper.*
*   **Claims:** This section details the computational methods used for cycle searching, eigenvalue computation, and verification.
*   **Mathematics & Framing:** The description of the algorithms is clear. The use of on-the-fly computation with Numba for large $k$ is a sensible and modern approach. The mention of an extensive test suite and a public repository inspires confidence in the computational results.
*   **Concerns:**
    1.  **Eigenvalue Computation Method:** The author states that dense eigenvalue computation uses `numpy.eig`, which is a floating-point algorithm. In Section 10, the author makes the very strong claim that for non-exceptional $k$, the spectrum is *exactly* $\{0, 1/4\}$. Floating-point arithmetic cannot prove this; it can only suggest it. Small, non-zero eigenvalues could be lost in numerical noise. To make such a claim, one would need to use exact rational arithmetic or a symbolic algebra system, at least for smaller $k$, to establish a pattern rigorously. This discrepancy undermines the certainty of the claims in Section 10.

#### **9. Fredholm Determinant (Section 12 - Discussion)**

*This section of the prompt is also mislabeled. I will review Section 12 of the paper.*
*   **Claims:** The discussion section synthesizes the results, proves the non-compactness of $\mathcal{L}$ on the archimedean space $C(\mathbb{Z}_2^{\mathrm{odd}}, \mathbb{R})$ (Proposition 6), and speculates on future directions.
*   **Mathematics & Framing:** The proof of non-compactness via non-equicontinuity (Proposition 6) is another strong, correct result that complements the obstructions in Sections 4 and 5. The discussion of the spectral gap and the potential for $\sigma(\mathcal{L})$ to contain the interval $[1/4, 1/2]$ is insightful and shows a deep command of the subject. The Iwasawa analogy is speculative but thought-provoking.
*   **Concerns:** None. This is a well-written and insightful discussion section.

#### **10. Overall Assessment**

*   **Recommendation:** **Major Revision.**
*   **Strongest Parts:**
    1.  **The Obstruction Theorems:** The proofs that $\mathcal{L}$ fails to preserve Hölder spaces (Theorem 2), is unbounded 2-adically (Theorem 3), and is not compact on the archimedean space (Proposition 6) are rigorous, elegant, and significant. They definitively close off several standard avenues for a spectral attack on the conjecture.
    2.  **The Ghost Cycle Framework:** The systematic development of ghost cycles as 2-adic orbits, the case-(a)/(b) classification, and the persistence theorem (Theorem 6) provide a powerful new lens for studying the problem.
    3.  **The Main Conjectural Proofs (Strategy):** The strategy for proving Negative Rationality and Universal Case-(a)