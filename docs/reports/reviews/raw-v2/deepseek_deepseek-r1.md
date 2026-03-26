## Referee Report

**Preprint:** “Ghost Cycles of the Syracuse Map: 2-Adic Periodic Orbits and the Exceptional Set” by Adam McKenna  
**Date:** March 2026  

### Overall Summary  
The paper studies the Syracuse (Collatz) map via transfer matrices and a transfer operator on the odd 2-adic integers. It introduces “ghost cycles” (modular cycles beyond the fixed point {1}) and argues they are projections of genuine 2-adic periodic orbits. The main results include:  
- Construction of the transfer operator \(\mathcal{L}\) and bounds on its norm and spectral radius.  
- Two obstructions to standard spectral approaches (Lasota–Yorke and 2-adic unboundedness).  
- Exhaustive enumeration of modular cycles up to level \(k=36\).  
- A persistence theorem for case-(a) ghosts, leading to a positive lower bound (4%) for the density of the exceptional set \(E\).  
- A closed-form orbit formula and proofs of “Negative Rationality” and “Universal Case-(a)” for all compositions.  

The work is computationally extensive and contains several interesting ideas. However, the mathematical rigor of several key proofs is insufficient for a journal publication in its current form. Below I provide a detailed section-by-section assessment.

---

### 1. Abstract & Introduction  
**Claims:** The abstract and introduction present the main contributions: the transfer operator framework, obstructions, ghost cycles as 2-adic orbits, persistence, density bounds, and proofs of Negative Rationality and Universal Case-(a).  

**Assessment:**  
- The claims are well-scoped and the framing is appropriate.  
- The introduction clearly situates the work within existing literature.  

**Concerns:**  
- The statement “falsifies an initial conjecture … that \(E\) has density zero” is slightly overstated. The paper proves \(\delta(E) \ge 4\%\) (a positive lower bound), which indeed falsifies density zero, but the exact density remains conjectural. This should be clarified.  
- The “six-part spectral theorem” (Theorem 1) is cited as a key result, but its proof (discussed below) has serious gaps.  

---

### 2. Transfer Matrix (Section 3)  
**Claims:** Defines the transfer operator \(\mathcal{L}\), computes its norm (\(\|\mathcal{L}\|=2/3\)), gives a spectral radius bound (\(\rho(\mathcal{L})\le 1/2\)), and states Theorem 1 (spectral properties).  

**Assessment:**  
- The matrix construction and the computation of the operator norm are correct.  
- The spectral radius bound (Proposition 3) is claimed to follow from the fact that eigenvalues of \(P_k\) are \(L\)th roots of \(2^{-V}\) with \(V/L \ge 1\). However, the proof relies on Theorem 1(e) (\(\sigma(\mathcal{L}) = \overline{\bigcup \sigma(P_k)}\)), which is not yet proved and whose proof is incomplete. This creates a circular argument.  
- Theorem 1(e) is central but its proof is sketchy. The author considers subspaces \(A_k\) of functions constant on odd residues modulo \(2^k\) and claims that the restriction of \(\mathcal{L}\) to \(A_k\) (composed with projection) is represented by \(P_k\). However, \(\mathcal{L}\) does not map \(A_k\) into itself; it maps into a larger subspace \(A_{k'}\). The argument that the spectrum of \(\mathcal{L}\) is the closure of the union of spectra of \(P_k\) is not rigorous. A proper proof would require showing that \(\mathcal{L}\) is the limit (in an appropriate sense) of the finite-rank operators induced by \(P_k\), which is not done.  
- Theorem 1(f) is computationally verified only for \(k\le 36\); it should be labeled as a conjecture or empirical observation.  

**Specific gaps:**  
- Proposition 3’s proof must be made independent of Theorem 1(e).  
- Theorem 1(e) requires a complete proof using, e.g., the density of locally constant functions and norm-resolvent convergence.  
- Theorem 1(f) should be stated as a conjecture.  

---

### 3. Spectral Theory (Section 4)  
**Note:** The paper’s Section 4 is “The Lasota–Yorke Obstruction”. I assume the request for “Spectral Theory” refers to Theorem 1, which is in Section 3. I have addressed it above. For Section 4 proper:  

**Claims:** Theorem 2 shows that \(\mathcal{L}\) does not preserve the Lipschitz space \(\mathrm{Lip}_1(\mathbb{Z}_2^{\mathrm{odd}})\), obstructing the Lasota–Yorke approach.  

**Assessment:**  
- The proof is clear and correct. The example \(x_N=1\), \(y_N=1+2^N\) (even \(N\)) shows that the weight function \(W=\mathcal{L}\mathbf{1}\) has infinite Lipschitz constant.  
- Corollary 1 (failure in Hölder and similar spaces) follows directly.  

**No major issues.**  

---

### 4. Obstructions (Sections 5–6)  
**Section 5 (2-Adic Unboundedness):**  
**Claims:** Theorem 3 states that \(\mathcal{L}\) is unbounded on \(C(\mathbb{Z}_2^{\mathrm{odd}},\mathbb{Q}_2)\) with 2-adic sup norm, and \(\|P_k\|_{2\text{-adic}} = 2^{k+O(1)}\).  

**Assessment:**  
- The proof is correct. The operator norm of \(P_k\) in the 2-adic sup norm is \(\max_j |2^{-v(j)}|_2 = 2^{\max_j v(j)}\), and \(\max_j v(j) = k+O(1)\) is justified.  

**Section 6 (Exhaustive Cycle Enumeration):**  
**Claims:** Presents computational results for \(k=3,\dots,36\), listing exceptional levels and ghost cycles.  

**Assessment:**  
- The methodology is described and code is available, so the results are credible.  
- However, the paper presents these as factual statements without proof; they should be clearly labeled as computational findings.  

**No mathematical errors, but presentational issues.**  

---

### 5. Ghost Cycles (Section 7)  
**Claims:** Defines ghost types, case-(a)/(b) classification, gives the cycle equation (Theorem 4), and states Theorem 5 (Universal Case-(a), proved later). Theorem 6 is the persistence theorem for case-(a) ghosts.  

**Assessment:**  
- Theorem 4 (cycle equation) is standard and correctly proved.  
- Theorem 6 (persistence) is crucial but the proof is incomplete. The key step is to show that if a case-(a) ghost appears at level \(k_0\), then for every \(k \equiv k_0 \pmod{p}\) with \(k\ge k_0\), the valuation conditions \(v_2(3n_i+1)=v_i\) continue to hold. The author argues that these conditions depend only on \(3a_i+|D| \bmod 2^{v_i+1}\) and are independent of \(k\). However, \(n_i\) is the modular reduction of \(\tilde{n}_i = R_i/D\), and its 2-adic expansion changes with \(k\). One must show that the first \(v_i\) bits of \(3n_i+1\) stabilize for all sufficiently large \(k\) in the arithmetic progression. The proof lacks a rigorous argument for this stability.  

**Specific gap:**  
- Theorem 6 requires a detailed analysis of the 2-adic expansion of \(\tilde{n}_i\) and how its reduction modulo \(2^k\) behaves as \(k\) increases periodically.  

---

### 6. Persistence (Section 8)  
**Note:** The paper’s Section 8 is “Census of Ghost Types”. Persistence is in Section 7 (Theorem 6). Already addressed above.  

---

### 7. Density & Spectral Radius (Sections 9–10)  
**Claims:**  
- Density: \(\delta(E) \ge 1/25 = 4\%\) (from the \(D=-601\) ghost). Conjecture 1 gives a product formula for the density.  
- Spectral radius: \(\rho(\mathcal{L}) \ge 2^{-18/17} \approx 0.4800\), and Conjecture 2 suggests \(\limsup \rho_k = 1/2\).  

**Assessment:**  
- The lower bound \(\delta(E) \ge 4\%\) is valid because the \(D=-601\) ghost appears at all \(k \equiv 12 \pmod{25}\), a set of density \(1/25\).  
- The product formula for density is heuristic and not proved; it should be clearly labeled as a conjecture.  
- The spectral radius lower bound is correct given the persistence of the \(L=17, V=18\) ghost.  
- Conjecture 2 is plausible but unproven.  

**No major errors, but conjectures should be distinguished from theorems.**  

---

### 8. Negative Rationality (Section 11)  
**Claims:** Theorem 8 (Negative Rationality) states that for every case-(a) ghost with \(D<0\), the orbit numerators \(R_i\) are positive, so orbit elements are negative rationals. Theorem 9 (Universal Case-(a)) states that every composition yields a case-(a) orbit.  

**Assessment:**  
- These theorems rely on the closed-form orbit formula (Theorem 7). The derivation of Theorem 7 is sketched but not fully detailed in the paper; the author refers to a GitHub file. For a journal article, essential proofs must be self-contained.  
- Assuming Theorem 7, the proofs of Theorems 8 and 9 are straightforward algebra. However, the key identity \(3R_i^* + D = 2^{v_i} R_{i+1}^*\) and the parity claim (\(R_i^*\) odd) need to be proved in the paper.  

**Specific gap:**  
- The proofs of Theorems 7, 8, and 9 are not complete in the manuscript. They must be included or at least sketched in sufficient detail.  

---

### 9. Fredholm Determinant (Section 12)  
**Note:** Section 12 is “Discussion”. The Fredholm determinant is mentioned in Section 10 (Eigenvalue Spectra) and briefly in the Discussion.  

**Claims:** For non-exceptional \(k\), \(\det(I - z P_k) = 1 - z/4\).  

**Assessment:** This follows directly from the spectrum of \(P_k\) (only eigenvalue \(1/4\)). No issues.  

---

### 10. Overall Assessment  
**Strengths:**  
- Extensive computational enumeration up to \(k=36\).  
- Clear identification of ghost cycles as 2-adic periodic orbits.  
- Rigorous proofs of the Lasota–Yorke and 2-adic unboundedness obstructions.  
- The persistence idea and density lower bound are valuable contributions.  

**Weaknesses:**  
- The spectral theorem (Theorem 1) is not rigorously proved.  
- The persistence theorem (Theorem 6) proof is incomplete.  
- Key proofs (Theorems 7–9) are not self-contained.  
- Some results are presented as theorems but are only computationally verified (e.g., Theorem 1(f)).  

**Recommendation:** **Major revision**.  
The paper contains interesting ideas and substantial computational work, but it does not meet the standard of mathematical rigor required for publication in its current form. The authors should address the following:  

1. **Theorem 1(e):** Provide a complete proof that \(\sigma(\mathcal{L}) = \overline{\bigcup \sigma(P_k)}\), or remove the claim and restructure the results accordingly.  
2. **Theorem 6:** Give a rigorous proof of persistence, including the stability of valuation conditions under modular reduction.  
3. **Theorems 7–9:** Include the proofs in the paper (not in an external repository).  
4. **Clarity:** Clearly distinguish between conjectures (e.g., density product formula, spectral radius limit) and proved theorems.  
5. **Circularity:** Fix the proof of Proposition 3 so it does not rely on Theorem 1(e).  

With these revisions, the paper could be suitable for publication.  

---  

**Additional minor notes:**  
- The reference to “Siegel, M.” in earlier versions was corrected to Dhiman and Pandey (2026), which is appropriate.  
- The paper is generally well-written, but the mathematical arguments need to be tightened.  

**Confidential remarks to the editor:**  
The author uses AI tools (Claude) extensively, as acknowledged. This does not affect the mathematical content, but the referee should ensure that the proofs are logically sound and not merely AI-generated plausibility arguments. The gaps identified above suggest that the paper has not been thoroughly vetted by an expert in functional analysis and dynamical systems. I recommend that the revisions be checked by a colleague with expertise in these areas.