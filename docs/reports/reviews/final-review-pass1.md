# Final Pre-Submission Review, Pass 1: Section-by-Section Deep Review

**Paper:** "Ghost Cycles as 2-Adic Periodic Orbits: Spectral Theory of the Syracuse Transfer Operator"
**Reviewer:** Internal review (dynamical systems, spectral theory, p-adic analysis)
**Date:** 2026-03-07
**Target venue:** *Experimental Mathematics*
**Review type:** Section-by-section mathematical audit (Pass 1 of final review)

---

## Section 1: Introduction (lines 39--82)

### Mathematical Claims

1. *"The spectral radius rho_k(x,y) measures the worst-case contraction rate over modular cycles: rho < 1 indicates contraction, rho > 1 indicates divergence."* -- This is stated as informal motivation and is correct in spirit, though "contraction" and "divergence" are imprecise without specifying what quantity is contracting or diverging. The sentence is acceptable for an introduction.

2. *"This operator-theoretic perspective realizes the Matthews--Watts (1985) growth-rate criterion as a spectral radius crossing 1."* -- This is an interpretive claim. Matthews and Watts characterized divergence via the expected value of log(x/2^v), which is indeed log_2(rho) when rho is interpreted as the geometric mean contraction. The connection is correct.

3. The contributions list (1)--(5) is accurate and matches the paper's content.

### Related Work Paragraph

The related work paragraph is adequate for *Experimental Mathematics*. The positioning relative to Siegel (2025) is explicit and correct: same objects, different questions. The citation of Steiner (1977) for the cycle equation and Laurent (2008) for Baker-type bounds is appropriate.

One minor issue: the paper cites Tao (2022) for *Forum of Mathematics, Pi*, but the paper was published in 2022 as volume 10, e12. The reference section lists this correctly, so no action needed.

### Local Issues

- The sentence "extending prior searches" in contribution (1) is vague. What prior searches? The introduction should state what the previous computational frontier was (presumably k around 20-25, per Wirsching or other sources). If no prior exhaustive search to this depth exists, say so.
- The outline mentions "Section 6 presents eigenvalue spectra" but should say "Section 6 presents eigenvalue spectra and Fredholm determinants" since both are discussed.

### Rating: READY

No mathematical errors. Minor clarity improvements possible.

---

## Section 2: Definitions and Setup (lines 85--127)

### Mathematical Correctness

**Definition 1 (Syracuse map).** Correct. The observation that v_2(3n+1) >= 1 for odd n is trivial and correct (3n+1 is even).

**Definition 2 (Modular Syracuse map).** Correct. The definition S_k(j) = S(j) mod 2^k is well-defined because S(j) is an odd integer and reduction mod 2^k preserves oddness. One subtlety: S(j) may depend on j beyond the first k bits (the valuation v_2(3j+1) can require more than k bits to determine). This means S_k is really defined on representatives, not just residue classes. But the paper implicitly works with the canonical representative j in {1, 3, ..., 2^k - 1}, and S(j) is computed exactly before reducing mod 2^k. This is fine.

**Definition 3 (Transfer matrix).** Correct. The matrix P_k has exactly one nonzero entry per column, so it encodes a weighted function on R_k. The weight 2^{-v_j} is the contraction factor.

**Claim after Definition 3:** *"Since each column has exactly one nonzero entry, the functional graph of P_k decomposes into cycles and trees."* Correct -- this is the structure theorem for functional graphs.

*"Each cycle of length L with valuations v_1, ..., v_L and total valuation V contributes eigenvalues that are the Lth roots of prod 2^{-v_i} = 2^{-V}."* Correct. The restriction of P_k to the invariant subspace spanned by a cycle of length L is a weighted cyclic permutation matrix, whose eigenvalues are omega^j * (prod w_i)^{1/L} for j = 0, ..., L-1, where omega = e^{2pi i / L} and the product of weights is 2^{-V}. The Lth roots of 2^{-V} are 2^{-V/L} * omega^j.

**Definition 4 (Spectral radius).** The formula rho_k = max_{cycles} 2^{-V/L} is stated, with the claim that it equals the linear-algebraic spectral radius. This is correct precisely because P_k is a direct sum of nilpotent blocks (trees) and weighted cyclic permutation blocks (cycles). The nilpotent blocks contribute only zero eigenvalues. The cyclic blocks contribute eigenvalues with modulus 2^{-V/L}. So the spectral radius is indeed the maximum over cycles.

**Definition 5 (Exceptional set).** Correct. The fixed point {1} has v = v_2(3*1+1) = v_2(4) = 2, so its contribution is 2^{-2} = 1/4. At non-exceptional levels, this is the unique cycle and rho_k = 1/4.

### Local Issues

- The notation R_k = {1, 3, 5, ..., 2^k - 1} is used but N = 2^{k-1} is defined as the number of odd residues. The relationship |R_k| = N is clear but could be stated.
- Definition 2 says "At resolution k >= 2" without explaining why k >= 2. The reason is that for k = 1, R_1 = {1} and the map is trivial. A brief remark would help but is not essential.

### Rating: READY

Clean, correct definitions. No mathematical issues.

---

## Section 3: The Parametric Family (lines 129--142)

### Mathematical Claims

1. *"The spectral radius undergoes a phase transition at x = 4."* This is stated as an empirical observation supported by the figures. No proof is given. For *Experimental Mathematics*, this is acceptable as motivation.

2. *"This threshold realizes the Matthews--Watts (1985) criterion |x| < d^d / d^{d-1} = d for d = 2."* Let me check: the Matthews-Watts criterion for convergence of the generalized Syracuse map with multiplier x and base d is roughly |x| < d. For d = 2, this gives |x| < 2. But the paper says the phase transition is at x = 4, not x = 2. The formula d^d / d^{d-1} = d is trivially d for all d, so the criterion is |x| < d. For d = 2, we get |x| < 2. But the spectral radius crossing occurs at x = 4 in the figures. There appears to be a discrepancy.

    Wait -- I need to be more careful. The Matthews-Watts criterion for the map n -> (xn + y) / d^{v_d(xn+y)} concerns the expected value of log(x/d^v). The expected contraction per step is x / (product of d-powers). The heuristic growth rate per step is x * E[d^{-v}] = x * sum_{j=1}^{infty} d^{-j} * P(v=j) = x * sum d^{-j} * (1 - 1/d) * (1/d)^{j-1} = x * (1/d) / (1 - 1/d) * (1 - 1/d) -- actually let me just compute directly. For d = 2: P(v = j) = 1/2^j for j = 1, 2, .... The expected value of 2^{-v} is sum_{j=1}^{infty} 2^{-j} * 2^{-j} = sum 4^{-j} = 1/3. So the expected contraction per step is x/3 (since the map multiplies by x and divides by 2^v on average by factor 3). The growth rate per step is x * (1/3). This equals 1 when x = 3 (marginal) and exceeds 1 when x > 3. But the observed phase transition is at x = 4, not x = 3.

    Actually, I am confusing two different things. The spectral radius rho = max_{cycles} 2^{-V/L}. For a "typical" cycle with V/L close to the expected v-value of sum_{j>=1} j/2^j = 2, we get rho ~ 2^{-2} = 1/4 regardless of x, because the cycle visiting pattern is what determines V/L, and V/L depends on the distribution of v-values around the cycle, which by Proposition 2 is P(v=j) = 1/2^j regardless of x. So the "typical" rho is always 1/4. The phase transition at x = 4 must come from a different mechanism.

    Hmm, but the transfer matrix P_k has entries 2^{-v_j} for the (x,y) = (3,1) case. For general x, the entry would still be 2^{-v_2(xj+y)}. The v-distribution P(v=j) = 1/2^j holds for all odd x by Proposition 2. So the spectral radius from "typical" cycles should be the same. The difference must come from how cycles arise -- perhaps for x > 4, there are cycles with atypically low V/L. Or perhaps the relevant quantity is not rho but something involving x directly.

    In fact, I think the Matthews-Watts criterion for divergence is about the *growth* of iterates, not the spectral radius of the transfer matrix. The transfer matrix encodes division by 2^v, but the actual orbit growth involves multiplication by x and division by 2^v. The net growth per step is x * 2^{-v}, and the expected log-growth is log(x) + E[-v log 2] = log(x) - 2 log 2 = log(x/4). So the transition is at x = 4 (where the expected log-growth changes sign). This reconciles: the spectral radius rho involves only the 2^{-V/L} factor, and the paper's claim about a "phase transition at x = 4" refers to the growth rate of actual orbits, which is proportional to (x/4)^n.

    But the paper says "rho_k < 1 (contraction) for x < 4" and "rho_k > 1 at large k for x > 4." If rho is defined as max 2^{-V/L}, then rho < 1 always (since V >= L, so V/L >= 1, so 2^{-V/L} <= 1/2). The spectral radius as defined in the paper is always < 1 regardless of x. So either the paper is redefining rho for general x to include the x-factor, or there is an error.

    Looking at the definition more carefully: for general x, the transfer matrix P_k(x,y) has entries 2^{-v_j} where v_j = v_2(xj + y). The spectral radius is still max 2^{-V/L} over cycles. This is always <= 1/2 by the same argument. So rho > 1 is impossible for ANY x (since v >= 1 always for odd x, y).

    **This means the claim "for x > 4, rho_k > 1 at large k (divergence)" is FALSE as stated.** The spectral radius as defined in the paper (Definition 4) is always <= 1/2. The "phase transition at x = 4" must refer to something else -- perhaps the growth rate x * rho, or the map's actual dynamics. The paper conflates the spectral radius of the transfer matrix (which encodes only the 2-adic part) with the growth rate of orbits (which involves x).

    Actually, wait. Let me reconsider. For general x, the map is S(n) = (xn+y)/2^{v_2(xn+y)}. The transfer matrix P_k(x,y) for the modular map encodes the transition with weight 2^{-v}. The spectral radius is max 2^{-V/L}. But the net growth of the orbit per step is x * 2^{-v}, not just 2^{-v}. Perhaps the paper is defining the spectral radius differently for general x -- using weights (x/2)^{something}? Let me look at Definition 3 again.

    No, Definition 3 says P_k[t_j, j] = 2^{-v_j} for x = 3. For general x, the same definition would give P_k[t_j, j] = 2^{-v_j} regardless of x. But this means rho_k never exceeds 1/2 for ANY x, which contradicts the phase transition claim.

    I think the issue is that the paper's Definition 3 is specific to the Collatz case x = 3, and for general x, one might want to use a different weight. The growth rate per step for the (x,y) map is (x * n + y) / 2^v / n ~ x / 2^v, so the relevant weight is x * 2^{-v}, and the spectral radius with these weights would be max (x^L * 2^{-V})^{1/L} = x * max 2^{-V/L}. With this definition, rho > 1 when x * 2^{-V/L} > 1, i.e., x > 2^{V/L}. For typical cycles with V/L ~ 2, this gives x > 4.

    **The paper needs to clarify what weights are used in the transfer matrix for general x.** If the weights are 2^{-v} (as in Definition 3), rho is always < 1 and there is no phase transition. If the weights include a factor of x (or x/2), then rho can exceed 1 for large x. The claim "rho_k > 1 at large k for x > 4" is only correct with the second convention.

    This is a significant issue for Section 3 but does NOT affect the rest of the paper (which works exclusively with x = 3).

### Local Issues

- The two figure captions are adequate.
- The Lyapunov exponent Lambda(x) = log_2 rho(x) ~ -2 at x = 3: this gives rho ~ 2^{-2} = 1/4, which is consistent.

### Rating: NEEDS MINOR EDITS

The phase transition discussion has a potential inconsistency between the transfer matrix weights (Definition 3 uses 2^{-v}) and the claim about rho > 1 for x > 4. If the weights are 2^{-v}, rho <= 1/2 always and there is no phase transition in rho. The paper must clarify:
- Either the transfer matrix for general x uses weights (x/2^v) or equivalent, making Definition 3 specific to the spectral radius analysis and different from the growth-rate spectral radius.
- Or the "phase transition" refers to the growth rate, not the spectral radius as defined in Definition 4.

FLAG FOR IMPLEMENTER: Check how the spectral radius is computed in the code for the phase transition figure (Figure 1). Is the weight 2^{-v}, or does it include a factor of x? If it includes x, the paper's Definition 3 does not match.

---

## Section 4: Exceptional Set Enumeration (lines 144--323)

This is the paper's core section. I review it in subsections.

### Section 4.1: Exhaustive Search (lines 146--155)

The computational methodology is described briefly (details in Section 7). The claim of exhaustive enumeration through k = 36 (2^35 ~ 3.4 * 10^10 residues) is a computational claim.

FLAG FOR IMPLEMENTER: Verify that the k = 36 exhaustive search completed without errors by checking the output logs or re-running a subset.

### Section 4.2: Results (lines 157--185)

The table of E intersection [3, 36] lists 5 exceptional values: k = 10, 11, 12, 20, 35. The density 5/34 = 0.147 is reported as 0.152. Let me check: |[3, 36]| = 34. 5/34 = 0.1471. The paper says 0.152. But the table header says k = 3--36, which has 34 values. 5/34 ~ 0.147, not 0.152.

**Minor numerical error:** 5/34 = 0.147, not 0.152. If the denominator is 33 (treating the range as k = 3, 4, ..., 35, excluding k = 36), then 5/33 = 0.152. The issue is whether k = 36 is included in the range. The table says E intersect [3, 36] has 5 members and the range has 34 values (k = 3 through k = 36 inclusive). Either the density is 5/34 = 0.147, or the range count is wrong. This should be checked.

FLAG FOR IMPLEMENTER: Verify the density computation: is |[3,36]| = 34 or 33? If 34, the density should be 0.147, not 0.152.

The detailed cycle table is consistent:
- k = 10: 1 extra cycle, worst rho = 0.3729. Check: this should be 2^{-V/L}. With L = 26, rho = 0.3729 means V/L = -log_2(0.3729) = 1.423. So V = 1.423 * 26 = 37.0. The table says "Worst mean v = 1.423", consistent with V/L.
- k = 12: 2 extra cycles, worst rho = 0.4454 = 2^{-7/6}. This is the D = -601 ghost (L = 6, V = 7). Correct.
- k = 35: 1 extra cycle, rho = 0.4353 = 2^{-6/5}. This is the D = -179 ghost (L = 5, V = 6). Correct.

### Section 4.3: Ghost Cycles as 2-Adic Periodic Orbits (lines 186--274)

**Theorem 1 (Cycle equation).** The statement and proof are correct. I verify the proof in detail:

Starting from $n_{i+1} = (3n_i + 1)/2^{v_i}$, we get $n_{i+1} \cdot 2^{v_i} = 3n_i + 1$. Substituting repeatedly:
- $n_2 \cdot 2^{v_1} = 3n_1 + 1$
- $n_3 \cdot 2^{v_2} = 3n_2 + 1 = 3 \cdot (3n_1 + 1) / 2^{v_1} + 1$, so $n_3 \cdot 2^{v_1 + v_2} = 3^2 n_1 + 3 + 2^{v_1}$
- After L steps: $n_1 \cdot 2^V = 3^L n_1 + \sum_{i=0}^{L-1} 3^{L-1-i} \cdot 2^{S_i}$

where $S_0 = 0$, $S_i = v_1 + ... + v_i$. This gives $n_1(2^V - 3^L) = R$ with $R = \sum_{i=0}^{L-1} 3^{L-1-i} \cdot 2^{S_i}$.

The congruence modulo $2^{k+V}$: the proof says "each step preserves residues modulo 2^k, and the accumulated shift introduces V additional bits of precision." More precisely: at each step, $n_{i+1}$ is determined modulo $2^k$, but $n_{i+1} \cdot 2^{v_i} = 3n_i + 1$ holds modulo $2^{k + v_i}$ (since $3n_i + 1$ is determined modulo $2^{k}$ and the multiplication by $2^{v_i}$ shifts everything up by $v_i$ bits). After accumulating all shifts, the equation holds modulo $2^{k+V}$. This is correct.

**The claim that D is odd:** $2^V$ is even, $3^L$ is odd, so $D = 2^V - 3^L$ is odd. Correct.

**The claim D is nonzero for $V > L \log_2 3$:** If $D = 0$ then $2^V = 3^L$, but $2^V$ and $3^L$ are coprime for V, L >= 1, so $D \neq 0$ always (not just for $V > L \log_2 3$). The condition $V > L \log_2 3$ is the condition for $D < 0$ (i.e., $2^V > 3^L$). The paper says "nonzero for $V > L \log_2 3$", which is technically correct (D is nonzero) but misleading because D is nonzero for all V, L >= 1. The condition $V > L \log_2 3$ is relevant for determining the *sign* of D. This is a minor imprecision.

**Definition 6 (Case-(a) vs Case-(b)).** The definition is clear and correct. The case-(a) assertion that the rational orbit is a true periodic orbit of S on $\mathbb{Q} \cap \mathbb{Z}_2^{\text{odd}}$ is now justified by the one-sentence argument "since the valuation conditions determine the Syracuse map step exactly." This is correct: if $v_2(3\tilde{n}_i + 1) = v_i$, then $S(\tilde{n}_i) = (3\tilde{n}_i + 1)/2^{v_i} = \tilde{n}_{i+1}$, which is the definition of the orbit.

**Theorem 2 (Persistence of case-(a) ghosts).** This is the paper's central result. I examine the proof in detail.

*Step 1: Valuation stability.* The proof writes $\tilde{n}_i = a_i / |D|$ with $a_i$ odd integer. Then $v_2(3\tilde{n}_i + 1) = v_2((3a_i + |D|) / |D|) = v_2(3a_i + |D|)$ (since |D| is odd). The case-(a) condition says this equals $v_i$, and it depends on $3a_i + |D|$ modulo $2^{v_i + 1}$. Since $a_i$ and $|D|$ are fixed integers, this is independent of $k$. Correct.

*Step 2: Periodicity of modular reduction.* The claim is that $\tilde{n}_1 \bmod 2^k = R \cdot D^{-1} \bmod 2^k$ depends on $k$ only through $k \bmod p$. The argument: $D^{-1}$ in $\mathbb{Z}_2$ has a $p$-periodic 2-adic expansion because $2^p \equiv 1 \pmod{|D|}$.

Let me verify this. We want $D^{-1} \bmod 2^k \equiv D^{-1} \bmod 2^{k+p} \pmod{2^k}$. This is equivalent to: the first $k$ 2-adic digits of $D^{-1}$ are the same whether we compute mod $2^k$ or mod $2^{k+p}$. This is trivially true (truncation). But what the proof needs is that $D^{-1} \bmod 2^{k+p}$ and $D^{-1} \bmod 2^k$ yield the *same* residue mod $2^k$, which is true by definition of modular reduction.

The actual periodicity claim needed is: $\tilde{n}_1 \bmod 2^k$ depends only on $k \bmod p$ (not just that it's determined by the first $k$ digits). This means: the 2-adic expansion of $R/D$ is eventually periodic with period $p$. A rational number $a/b$ with $\gcd(b, 2) = 1$ has a purely periodic 2-adic expansion with period $\text{ord}_2(b)$. Here $b = |D|$ and $\text{ord}_2(|D|) = p$. So the 2-adic expansion of $R/D$ is periodic with period $p$ (from the start, not just eventually). Therefore $R/D \bmod 2^k = R/D \bmod 2^{k+p} \pmod{2^k}$, AND the digits in positions $k$ through $k+p-1$ are the same as the digits in positions $k-p$ through $k-1$. This means $R/D \bmod 2^k$ depends only on $k \bmod p$. Correct.

Wait, actually: a rational $a/b$ with $\gcd(b,2) = 1$ has 2-adic expansion that is eventually periodic with period dividing $\text{ord}_2(b)$, but is it purely periodic? Not necessarily. Consider $1/3$ in the 2-adics: $1/3 = 1 + 2 + 2^2 + 2^4 + 2^5 + ... = \sum_{k=0}^{\infty} (2^{2k} + 2^{2k+1}) = ...$. Actually, $1/3$ in $\mathbb{Z}_2$: we need $3x = 1$ in $\mathbb{Z}_2$, so $x = -1/(-3) = ... $. In fact, $1/3 \bmod 2 = 1$, $1/3 \bmod 4 = 3$, $1/3 \bmod 8 = 3$, $1/3 \bmod 16 = 11$, etc. The 2-adic digits of $1/3$ are: $1, 1, 0, 1, 0, 1, 0, 1, ...$, which is eventually periodic with period 2 = $\text{ord}_2(3)$. And it's periodic from the start (digit 0 onward is period 2: 1,1,0,1,0,1,...). Actually let me recheck: $1/3 \bmod 2 = 1$, $1/3 \bmod 4 = 3$ (binary: 11), $1/3 \bmod 8 = 3$ (binary: 011), $1/3 \bmod 16 = 11$ (binary: 1011). So digits are 1,1,0,1,0,1,0,1,... with period 2 starting from position 1. The first digit breaks the pattern. So it's *eventually* periodic, not necessarily purely periodic.

This means $R/D \bmod 2^k$ depends on $k \bmod p$ only for $k$ sufficiently large (past the non-periodic prefix). The prefix length is at most $v_2(R/D - c)$ for the periodic part $c$, which is bounded. Since the ghost first appears at $k_0$, and $k_0$ is past any non-periodic prefix, the periodicity holds for $k \geq k_0$. The proof is correct.

Actually, for a fraction $a/b$ with $\gcd(a,b) = 1$ and $\gcd(b,2) = 1$, the 2-adic expansion IS purely periodic. The key point: $a/b \in \mathbb{Z}_2$ means we are looking at $a \cdot b^{-1} \bmod 2^k$ for each $k$. Since $b^{-1} \bmod 2^k$ is periodic in $k$ with period $p = \text{ord}_2(b)$, and $a$ is a fixed multiplier, $a \cdot b^{-1} \bmod 2^k$ is also periodic in $k$ with period dividing $p$. But "periodic in $k$" means: the sequence $\{a/b \bmod 2^k\}_{k \geq 0}$ satisfies $a/b \bmod 2^{k+p} \equiv a/b \bmod 2^k \pmod{2^k}$. This is always true (it says the first $k$ digits don't change when you compute more digits). What we need is that the $(k+1)$-th through $(k+p)$-th digits are the same as the $(k-p+1)$-th through $k$-th digits. This follows from the expansion being purely periodic.

In fact, the 2-adic expansion of any element of $\mathbb{Z}_2$ that is a rational $a/b$ with $\gcd(b,2) = 1$ is purely periodic (since $\mathbb{Z}_2 \cap \mathbb{Q} = \{a/b : \gcd(b,2) = 1\}$ and the periodicity of $b^{-1}$ in $\mathbb{Z}/2^k\mathbb{Z}$ starts from $k = 0$). So the proof is fine.

*Step 3: Verification at level k.* Condition (i): $n_1 = \tilde{n}_1 \bmod 2^k$ is odd. Since $\tilde{n}_1 = R/D$ with $R$ and $D$ both odd (D is odd by the earlier argument; R is... is R odd?). The proof says "$\tilde{n}_1$ has odd numerator and D is odd." Actually, R might be even. Let me check: $R = \sum_{i=0}^{L-1} 3^{L-1-i} \cdot 2^{S_i}$ with $S_0 = 0$. The $i = 0$ term is $3^{L-1} \cdot 2^0 = 3^{L-1}$, which is odd. The remaining terms all contain a factor of $2^{S_i}$ with $S_i \geq v_1 \geq 1$, so they are even. Therefore $R$ is odd. Good -- $R$ is odd and $D$ is odd, so $R/D$ is a 2-adic unit, meaning $R \cdot D^{-1} \bmod 2^k$ is odd for all $k$. Correct.

Condition (ii): $v_2(3n_i + 1) = v_i$ where $n_i = \tilde{n}_i \bmod 2^k$. The proof says this requires $k > v_i$ for all $i$. More precisely: $3n_i + 1 \equiv 3\tilde{n}_i + 1 \pmod{2^k}$ (since $n_i \equiv \tilde{n}_i \pmod{2^k}$, multiplying by 3 gives $3n_i \equiv 3\tilde{n}_i \pmod{3 \cdot 2^k}$... wait, no. $n_i \equiv \tilde{n}_i \pmod{2^k}$ means $3n_i + 1 \equiv 3\tilde{n}_i + 1 \pmod{3 \cdot 2^k}$? No, that's wrong. $n_i - \tilde{n}_i \equiv 0 \pmod{2^k}$ means $3(n_i - \tilde{n}_i) \equiv 0 \pmod{2^k}$ (since multiplying by 3 doesn't change 2-adic valuation). Wait -- $3(n_i - \tilde{n}_i)$ is divisible by $2^k$ iff $n_i - \tilde{n}_i$ is divisible by $2^k$ (since $\gcd(3, 2^k) = 1$). So $3n_i + 1 \equiv 3\tilde{n}_i + 1 \pmod{2^k}$. Since $v_2(3\tilde{n}_i + 1) = v_i$ (case-(a) condition) and $v_i < k$ (assuming $k > v_i$), the first $v_i$ bits of $3n_i + 1$ match those of $3\tilde{n}_i + 1$, so $v_2(3n_i + 1) = v_i$. The condition $k > v_i$ ensures the congruence mod $2^k$ determines the first $v_i$ bits. Correct.

The requirement $k > v_i$ for all $i$: this is $k > \max_i v_i$. For the known ghosts, max v_i = V - L + 1 (since the v-patterns have form $(1, ..., 1, V-L+1)$). For D = -601: max v_i = 7 - 6 + 1 = 2, so we need k > 2, which is satisfied for all k >= 3. Correct.

Condition (iii): $n_{L+1} = n_1 \bmod 2^k$. This follows from the cycle equation and the periodicity of the modular reduction.

**Overall verdict on Theorem 2:** The proof is correct and complete.

### Section 4.4: Known Case-(a) Ghost Types (lines 276--292)

The table data:
- D = -179: L = 5, V = 6. $2^6 - 3^5 = 64 - 243 = -179$. Correct. $\rho = 2^{-6/5} \approx 0.4353$. Correct.
- D = -601: L = 6, V = 7. $2^7 - 3^6 = 128 - 729 = -601$. Correct. $\rho = 2^{-7/6} \approx 0.4454$. Correct.
- D = -5537: L = 8, V = 10. $2^{10} - 3^8 = 1024 - 6561 = -5537$. Correct. $\rho = 2^{-10/8} = 2^{-5/4} \approx 0.4204$. Correct.
- D = -1675: L = 7, V = 9. $2^9 - 3^7 = 512 - 2187 = -1675$. Correct. $\rho = 2^{-9/7} \approx 0.4102$. Correct.

The claim that all v-patterns have form $(1, ..., 1, V-L+1)$: for D = -179, the pattern is $(2,1,1,1,1)$ and V-L+1 = 2. The "excess" is in the first position. For D = -601, pattern $(1,1,1,1,1,2)$, excess in last position. For D = -5537, pattern $(1,1,1,1,1,1,1,3)$ and V-L+1 = 3, excess in last position. For D = -1675, pattern $(1,1,1,1,1,1,3)$ and V-L+1 = 3, excess in last position. The claim says "up to cyclic rotation" so all are of this form. Correct.

FLAG FOR IMPLEMENTER: Verify the rational orbit elements $\tilde{n}_1 = R/D$ for each ghost type by computing $R = \sum_{i=0}^{L-1} 3^{L-1-i} \cdot 2^{S_i}$ with the given v-patterns and checking $R/D$ matches the table.

FLAG FOR IMPLEMENTER: Verify $p = \text{ord}_2(|D|)$ for each ghost: ord_2(601) = 25, ord_2(179) = 178, ord_2(5537) = 84, ord_2(1675) = 660.

FLAG FOR IMPLEMENTER: Verify $r$ (number of residue classes mod $p$ where the ghost appears) for each type: r = 1 for D = -601, r = 3 for D = -179, r = 2 for D = -5537, r = 3 for D = -1675.

### Section 4.5: Baker--Wustholz Bounds (lines 294--323)

**Proposition 1 (Baker--Wustholz lower bound on |D|).** The statement says: for all positive integers $V, L$ with $V \geq 3$:
$$|2^V - 3^L| > \max(2^V, 3^L) \cdot \exp(-25 (\log V)^2).$$

This is a specialization of the Baker--Wustholz theorem (or Laurent's refinement) to the linear form $\Lambda = V \log 2 - L \log 3$. The Baker--Wustholz theorem gives $|\Lambda| > \exp(-C \cdot h_1 \cdot h_2 \cdot \log B)$ where $h_i$ are logarithmic heights and $B = \max(|V|, |L|)$. For $\alpha_1 = 2, \alpha_2 = 3$: $h_1 = \log 2$, $h_2 = \log 3$, and the constant $C$ depends on the number of logarithms ($n = 2$). Laurent (2008) gives sharp estimates for $n = 2$.

The conversion from $|\Lambda|$ to $|2^V - 3^L|$: since $\Lambda = \log(2^V/3^L)$, we have $|2^V - 3^L| = 3^L |2^V/3^L - 1| = 3^L |e^\Lambda - 1| \geq 3^L |\Lambda| / 2$ for small $\Lambda$. For large $\Lambda$, the bound is trivial. So $|2^V - 3^L| \geq c \cdot 3^L \cdot |\Lambda|$ for some absolute constant $c$.

The specific constant 25 would need to be verified against Laurent's explicit formulas. I cannot do this by inspection.

FLAG FOR IMPLEMENTER: Verify the constant 25 in Proposition 1 against Laurent (2008). The key reference is Laurent, M. (2008), "Linear forms in two logarithms and interpolation determinants II," Acta Arithmetica 133(4), 325--348. Specifically, check Corollary 1 with $\alpha_1 = 2$, $\alpha_2 = 3$, $b_1 = V$, $b_2 = L$.

**Proposition 2 (Exclusion of bounded-length ghosts).** THIS PROPOSITION IS INCORRECT AS STATED.

The statement claims: "no ghost cycle of length $L \leq L_0$ with $\rho > 1/4$ exists at any level $k > K_0(L_0)$."

But the D = -601 ghost has L = 6, V = 7, $\rho = 2^{-7/6} > 1/4$, and by Theorem 2 it reappears at EVERY $k \equiv 12 \pmod{25}$ for all $k \geq 12$. Since $K_0(L_0)$ is finite (defined as a maximum of finitely many ord_2 values), there exist levels $k > K_0(6)$ where the D = -601 ghost appears. This directly contradicts the proposition.

The error is in the proof: "All appearances are bounded by $\text{ord}_2(|D|)$." For case-(a) ghosts, Theorem 2 says the ghost appears at INFINITELY MANY $k$ values (all $k \equiv k_0 \bmod p$). The appearances are not bounded by $\text{ord}_2(|D|)$; they are periodic with period $\text{ord}_2(|D|)$.

I believe the intended statement was about case-(b) ghosts only, or perhaps the intended conclusion was about the FIRST appearance level (that for fixed $L$, the first appearance of any ghost of length $L$ occurs before $K_0$). But even that is not what the proof establishes.

Let me try to reconstruct what might have been intended. Perhaps the intent was:

> "For each fixed $L_0$, the set of $(L, V)$ with $L \leq L_0$ and $\rho > 1/4$ (i.e., $V < 2L$) is finite. For each such $(L, V)$, $D = 2^V - 3^L$ is fixed, and the ghost (if case-(a)) reappears periodically with period $p = \text{ord}_2(|D|)$. Therefore, by level $K_0$, every ghost type of length $\leq L_0$ has been seen at least once if it will ever appear."

This would be a statement about *detection*, not *exclusion*: "By searching through $k = K_0(L_0)$, one is guaranteed to have seen every ghost type of length $\leq L_0$." This is useful but is a very different claim from "no ghost exists beyond $K_0$."

**This is a BLOCKING error. Proposition 2 must be corrected or removed before submission.**

Possible corrections:
1. Restrict to case-(b) ghosts: "No case-(b) ghost cycle of length $L \leq L_0$ exists beyond $K_0(L_0)$." This would be correct since case-(b) ghosts appear only finitely often.
2. Restate as a detection theorem: "Every case-(a) ghost type of length $L \leq L_0$ with $\rho > 1/4$ appears at some $k \leq K_0(L_0)$."
3. Restate as: "There are finitely many ghost types with $L \leq L_0$, and they are all detectable by searching through $k = K_0(L_0)$."

The Remark following the proposition correctly states that Baker bounds cannot prove E finite. But the proposition itself is false.

### Rating for Section 4 overall: NEEDS MAJOR EDITS

- Theorem 1: correct.
- Definition 6: correct.
- Theorem 2: correct and well-proved.
- Ghost type table: data appears correct (subject to computational verification).
- **Proposition 2: INCORRECT as stated. Must be fixed.**
- Minor: the claim "$D$ is nonzero for $V > L \log_2 3$" is correct but misleading; $D \neq 0$ always.

---

## Section 5: Falsification of Conjecture 1 (lines 326--414)

### Section 5.1: The Falsification (lines 333--364)

The falsification argument is correct and well-presented:
1. The D = -601 ghost is case-(a) (verified computationally).
2. By Theorem 2, it reappears at every $k \equiv 12 \pmod{25}$.
3. Therefore $E$ contains the arithmetic progression $\{12, 37, 62, ...\}$, which has density 1/25 = 4%.
4. This contradicts the original conjecture that E has density zero.

The claim about the Borel-Cantelli heuristic being wrong is correct: the heuristic assumed independence, but case-(a) ghosts produce deterministic, periodic reappearances.

The claim "the four known ghost types account for 17 of the 20 exceptional levels" in [37, 200] is a computational claim.

FLAG FOR IMPLEMENTER: Verify that exactly 20 levels in [37, 200] are exceptional, and that 17 of them are accounted for by the four known ghost types (D = -601, -179, -5537, -1675).

The remaining 3 levels (k = 10, 11, 20) are correctly noted as having long cycles with large denominators. Wait -- the text says "The remaining three levels (k = 10, 11, 20) are case-(a) ghosts with long cycles (L = 26, 25, 22 respectively)." But earlier, k = 10, 11, 20 were in the range [3, 36], not [37, 200]. If the claim is about [37, 200], there should be 20 - 17 = 3 levels in [37, 200] not accounted for by the four known types. But k = 10, 11, 20 are in [3, 36], not [37, 200].

Let me re-read the text. The paper says: "Beyond the exhaustive search boundary (k = 36), the four known ghost types account for 17 of the 20 exceptional levels." But then it says "The remaining three levels (k = 10, 11, 20) are case-(a) ghosts..." These are in [3, 36], within the exhaustive search boundary. So the 20 exceptional levels must be across all of [3, 200], not just [37, 200]. In [3, 36], there are 5 exceptional levels. Beyond, 17 from the four known types, but that gives 5 + 17 = 22, not 20.

Wait, I think the count is: in [3, 200], there are 20 exceptional levels total. Of these, 17 are accounted for by the four known case-(a) ghost types. The remaining 3 are k = 10, 11, 20 (which are in [3, 36] and have long cycles not matching any of the four classified types). But then: in [3, 36], the exhaustive search found 5 exceptional levels (10, 11, 12, 20, 35). Of these, k = 12 and k = 35 are explained by the four classified types (D = -601 at k = 12, D = -179 at k = 35). That accounts for 2 in [3, 36]. Beyond k = 36, the four types contribute at: D = -601 at k = 37, 62, 87, 112, 137, 162, 187 (7 values); D = -179 at k = 71, 142 (2 values, since period 178, r=3, first at k=35, next at k=35+... need to check); D = -5537 at k = 42, 85, 126, 169 (4 values, period 84, r=2); D = -1675 at k = 95, 189 (but 189 < 200? 95 + 660... no, r=3 means 3 residue classes mod 660). Let me not try to count manually.

The overall structure of the argument is sound, but the accounting of the 20 exceptional levels needs verification.

FLAG FOR IMPLEMENTER: Verify the count of 20 exceptional levels in [3, 200] (or whatever range is intended) and verify that 17 are accounted for by the four known ghost types. Clarify in the paper whether "20 exceptional levels" refers to [3, 200] or [37, 200].

### Section 5.2: New Conjectures (lines 367--414)

**Conjecture 1 (Density of E).** The density formula
$$\delta(E) = 1 - \prod_{\mathcal{G}} \left(1 - \frac{r_{\mathcal{G}}}{p_{\mathcal{G}}}\right)$$
assumes the arithmetic progressions for distinct ghost types are independent (have coprime periods). This assumption is now stated explicitly, which is good.

The paper computes $\delta(E) \geq 1 - (24/25)(175/178)(82/84)(657/660)$. Let me verify:
- D = -601: $1 - r/p = 1 - 1/25 = 24/25$. Correct.
- D = -179: $1 - r/p = 1 - 3/178 = 175/178$. Correct.
- D = -5537: $1 - r/p = 1 - 2/84 = 82/84$. Correct.
- D = -1675: $1 - r/p = 1 - 3/660 = 657/660$. Correct.

Product: $(24/25)(175/178)(82/84)(657/660)$. Let me estimate: $24/25 = 0.96$, $175/178 \approx 0.9831$, $82/84 \approx 0.9762$, $657/660 \approx 0.9955$. Product $\approx 0.96 \times 0.9831 \times 0.9762 \times 0.9955 \approx 0.917$. So $\delta(E) \geq 1 - 0.917 = 0.083 = 8.3\%$. Correct.

The paper correctly notes that $\gcd(25, 660) = 5 \neq 1$, so the independence assumption is not exactly satisfied. This is an important caveat and it is properly flagged. The unconditional bound $\delta(E) \geq 1/25 = 4\%$ from D = -601 alone is noted. Good.

**Conjecture 2 (Spectral Radius).** The formula
$$\limsup_{k \to \infty} \rho_k = \max\left(\frac{1}{4}, \; \sup_{\mathcal{G}} 2^{-V_{\mathcal{G}}/L_{\mathcal{G}}}\right)$$
is correctly stated. The max with 1/4 accounts for the fixed point. The current known supremum is $2^{-7/6} \approx 0.4454$ from D = -601. The conjecture is about limsup, which is appropriate since rho_k oscillates.

One issue: the conjecture says limsup equals the sup over ghost types. But could there be non-ghost contributions to the spectral radius at large k? For non-exceptional k, rho_k = 1/4. For exceptional k, rho_k comes from ghost cycles. So limsup rho_k = limsup over k in E of rho_k, which is sup over all ghost types of their rho. The conjecture is therefore stating that the sup is achieved (or at least that the limsup equals the sup). If there are infinitely many ghost types with rho approaching some limit, the limsup would be that limit. The conjecture is well-formulated.

**Conjecture 3 (Negative Rationality).** The conjecture states that all case-(a) orbit elements are negative rationals. The Remark correctly explains the relationship to the Collatz conjecture.

The Remark states: "Conjecture 3 is at least as strong as the Collatz conjecture: it implies the nonexistence of non-trivial positive-integer cycles, and additionally excludes positive non-integer rational orbits." This is correctly stated.

However, there is a subtle point about the logical relationship. The Collatz conjecture says: every positive integer eventually reaches 1 under the Collatz iteration. This has two parts: (i) no non-trivial cycles, and (ii) no divergent trajectories. Conjecture 3 addresses part (i) only (it says all periodic orbits have negative rational elements, hence no positive-integer periodic orbits exist). It does NOT address part (ii) -- a trajectory could diverge to infinity without cycling. So Conjecture 3 is NOT "at least as strong as the Collatz conjecture" in full generality; it is at least as strong as the "no non-trivial cycles" part. The paper should be more precise here.

Actually, re-reading the remark: "it implies the nonexistence of non-trivial positive-integer Collatz cycles." This is correctly stated -- it refers to cycles, not to the full Collatz conjecture. But then "In particular, Conjecture 3 is at least as strong as the Collatz conjecture" is an overstatement. The Collatz conjecture is stronger than just "no non-trivial cycles" because it also requires convergence to 1 (no divergence).

**Minor error in the Remark:** "Conjecture 3 is at least as strong as the Collatz conjecture" should be "Conjecture 3 is at least as strong as the periodic orbit conjecture for the Collatz map (i.e., the nonexistence of non-trivial cycles)." The full Collatz conjecture also asserts no divergent trajectories, which Conjecture 3 does not address.

### Rating: NEEDS MINOR EDITS

- The falsification argument is correct and well-presented.
- The density formula and its caveats are properly handled.
- The conjectures are well-formulated.
- Minor: the accounting of "20 exceptional levels" needs clarification.
- Minor: the relationship between Conjecture 3 and the Collatz conjecture overstates the implication.

---

## Section 6: Eigenvalue Spectra (lines 417--471)

### Section 6.1: Dense Computation (lines 419--458)

The table of spectra for k = 3, ..., 15 is a computational result. The claim that non-exceptional k have spectrum {0, 1/4} is consistent with the theory: a unique cycle (the fixed point) contributes eigenvalue 1/4, and all other eigenvalues are zero (from nilpotent tree structure).

The eigenvalue counts for exceptional k are correctly explained:
- k = 10: 1 + 26 = 27 (1 from fixed point, 26 from extra cycle of length 26).
- k = 11: 1 + 25 = 26 (1 from fixed point, 25 from extra cycle of length 25).
- k = 12: 1 + 7 + 6 = 14 (1 from fixed point, 7 from D = -1675 cycle, 6 from D = -601 cycle).

Wait -- the paper says "two extra cycles of lengths 7 and 6, corresponding to the D = -1675 and D = -601 ghost types respectively." But D = -1675 has L = 7, and the table says one extra cycle of length 7 at k = 12. Let me check: is D = -1675 a case-(a) ghost that appears at k = 12? The ghost type table says D = -1675 has period 660 and r = 3. The first appearance: the MEMORY.md says k = 95, 189, 661 (modulo 660). So k = 12 is NOT in these residue classes. And k = 12 mod 660 = 12, which is not 95, 189, or 661 mod 660.

Wait, then what produces the cycle of length 7 at k = 12? If it's not D = -1675, then it's a different ghost type with L = 7. But the paper claims it corresponds to D = -1675. This needs verification.

Actually, looking at the MEMORY.md more carefully: "D=-1675 (L=7,V=9): v=(1,1,1,1,1,1,3), n_tilde=-2059/1675, rho=0.4102, period=660, r=3. At k=95,189,661." The memory also says "Previous memory had WRONG k appearances for D=-1675 (95,106,165,180 -> 95,189,661)." So the corrected appearances are at k = 95, 189, 661. None of these equal 12.

But at k = 12, the paper claims there is a cycle of length 7 corresponding to D = -1675. If D = -1675 does NOT appear at k = 12, then either:
1. The paper is wrong about which ghost type produces the length-7 cycle at k = 12, or
2. There is a different ghost type with L = 7 and a different D that appears at k = 12.

Let me think about this. A cycle of length 7 at k = 12 has V such that $D = 2^V - 3^7 = 2^V - 2187$. For V = 9: $D = 512 - 2187 = -1675$. For V = 8: $D = 256 - 2187 = -1931$. For V = 10: $D = 1024 - 2187 = -1163$. So if the cycle at k = 12 has L = 7 and V = 9, the denominator is D = -1675, consistent with the paper's claim. But the ghost type table says D = -1675 appears at k = 95, 189, 661 (mod 660). For it to also appear at k = 12, we need k = 12 to be congruent to one of {95, 189, 661} mod 660. 12 mod 660 = 12, which is none of these. So either:
- The ghost appears at k = 12 as well (and r should be at least 4, not 3), or
- The cycle at k = 12 with L = 7 has a different V (hence different D), or
- There is an error somewhere.

Actually, there could be multiple v-patterns for the same (L, V). The ghost type table says patterns are listed "up to cyclic rotation." For L = 7, V = 9, there are multiple compositions of 9 into 7 parts each >= 1. The pattern (1,1,1,1,1,1,3) is one such composition. But there could be others: (1,1,1,1,1,2,2), (1,1,1,1,2,1,2), etc. Different v-patterns with the same (L, V) produce different R values in the cycle equation, and hence different rational orbits. Each is a separate "ghost type" sharing the same D.

So the cycle at k = 12 with L = 7 might have the same D = -1675 but a different v-pattern than (1,1,1,1,1,1,3). Or it might be a case-(b) ghost with this v-pattern, or with a different v-pattern.

This is getting complicated. The key issue is: **the paper claims the length-7 cycle at k = 12 corresponds to D = -1675 (the L = 7, V = 9 ghost type), but the ghost type table says D = -1675 first appears at k = 95.** This is either an error in the paper's identification, or there is a different v-pattern with the same (L, V) = (7, 9) that appears at k = 12 as a case-(b) ghost.

FLAG FOR IMPLEMENTER: Verify which ghost type produces the cycle of length 7 at k = 12. Specifically: (1) what is the v-pattern of the length-7 cycle at k = 12? (2) What is V? (3) If (L, V) = (7, 9), is this the same v-pattern as (1,1,1,1,1,1,3) or a different one? (4) Is this ghost at k = 12 case-(a) or case-(b)?

The Fredholm determinant claim for non-exceptional k: $\det(I - zP_k) = 1 - z/4$. This follows from the spectrum being {0, 1/4}: the Fredholm determinant is $\prod_i (1 - z\lambda_i) = (1 - z/4) \cdot 1^{N-1} = 1 - z/4$. Correct.

### Section 6.2: The Fredholm Determinant (lines 454--471)

The description of Fredholm zeros migrating as x varies is a qualitative computational observation. The two figures (Fredholm zeros and Pade poles) illustrate this.

The Pade approximant figure is mentioned without any theorem or conjecture. As noted in the previous review, this is a loose end.

The ARPACK remark is now in Section 7 (Computational Methodology), which is appropriate.

### Local Issues

- The "27 nonzero eigenvalues" at k = 10 comes from 1 extra cycle of length 26 plus the fixed point: 1 + 26 = 27. But the paper does not identify which ghost type produces the L = 26 cycle at k = 10. This is acceptable (the paper focuses on the four classified types) but could be clearer.
- As discussed above, the attribution of the L = 7 cycle at k = 12 to D = -1675 may be incorrect.
- The Pade figure serves no clear purpose in the paper.

### Rating: NEEDS MINOR EDITS

- The eigenvalue counts and Fredholm determinant claims are correct.
- The attribution of the k = 12 cycle to D = -1675 needs verification.
- The Pade figure should be developed or removed.

---

## Section 7: Computational Methodology (lines 473--530)

### Section 7.1: Transfer Matrix Construction (lines 476--480)

Correct and consistent with Definition 3.

### Section 7.2: Cycle Search Algorithm (lines 482--501)

The pseudocode is a standard linear-time cycle detection algorithm on functional graphs. The complexity is O(N) time and O(N) space, which is stated. This is correct.

### Section 7.3: On-the-fly Computation with Numba (lines 503--507)

The explanation is adequate. The memory reduction from 16 GB (full array) to 4 GB (bitarray) at k = 36 is plausible: a bitarray of 2^35 bits = 2^32 bytes = 4 GB.

### Section 7.4: Eigenvalue Computation (lines 509--516)

The note about ARPACK artifacts is appropriate here. Dense computation is feasible through k = 15 (N = 16384); this is a 16384 x 16384 matrix, which takes about 2 GB of RAM (double precision) and eigendecomposition in O(N^3) ~ 4 * 10^12 operations. This is feasible but would take several hours. The paper says it was done; this is a computational claim.

FLAG FOR IMPLEMENTER: Confirm that dense eigenvalue computation for k = 15 (N = 16384) was actually performed and that the spectrum is {0, 1/4} (one nonzero eigenvalue).

### Section 7.5: Verification (lines 518--524)

The claim "All results for k = 3, ..., 24 are verified against a separate implementation (99 unit tests)" is a self-consistency check, not independent verification against published data. The paper now says "separate implementation" rather than "independent computation," which is more precise. Adequate for *Experimental Mathematics*.

### Section 7.6: Reproducibility (lines 526--530)

The GitHub link and reproducibility statement are appropriate.

### Rating: READY

No mathematical errors. The computational methodology is clearly described.

---

## Section 8: References (lines 533--566)

### Completeness

The reference list includes:
- Baker and Wustholz (1993) -- for Proposition 1. Correct.
- Laurent (2008) -- for the refined bound. Correct.
- Steiner (1977) -- for the cycle equation. Correct.
- Wirsching (1998) -- for the dynamical systems perspective. Correct.
- Matthews and Watts (1985) -- for the Markov approach. Correct.
- Tao (2022) -- for the probabilistic approach. Correct.
- Siegel (2025) -- for independent use of "ghost cycles." Correct.
- Lagarias (1985, 2021) -- for general references. Correct.
- Lagarias and Weiss (1992) -- for stochastic models. Correct.

Additional references listed that are not cited in the text: Conway (1972), Goncalves et al. (2025), Kontorovich and Lagarias (2009), Eliahou (1993), Kurtz and Simon (2007), Matthews (2010). These are reasonable supplementary references for a Collatz paper.

### Issues

- Eliahou (1993) is listed in the references but not cited in the text. Either cite it (e.g., for cycle length lower bounds) or remove it.
- Conway (1972), Goncalves et al. (2025), Kontorovich and Lagarias (2009), Kurtz and Simon (2007), and Matthews (2010) are also listed but not cited. A journal paper should not include uncited references.

### Rating: NEEDS MINOR EDITS

Remove uncited references, or add citations in the text.

---

## Overall Summary

### BLOCKING Issues (must fix before submission)

**B1. Proposition 2 is FALSE.** The statement "no ghost cycle of length $L \leq L_0$ with $\rho > 1/4$ exists at any level $k > K_0(L_0)$" contradicts Theorem 2, which says case-(a) ghosts reappear at infinitely many levels. The D = -601 ghost (L = 6, $\rho > 1/4$) reappears at every $k \equiv 12 \pmod{25}$ forever, including at levels $k > K_0(6)$. The proposition must be corrected -- either restricted to case-(b) ghosts, or restated as a detection theorem ("every ghost type of length $\leq L_0$ appears at some $k \leq K_0(L_0)$"). See detailed discussion in the Section 4 review above.

### MINOR Issues (should fix before submission)

**M1. Phase transition weights (Section 3).** The paper claims $\rho_k > 1$ for $x > 4$, but Definition 4 defines $\rho_k = \max 2^{-V/L}$, which is always $\leq 1/2$. The phase transition claim requires either a different weight convention for general $x$ or a different interpretation. Clarify what quantity undergoes the phase transition.

**M2. k = 12 cycle attribution (Section 6).** The paper attributes the length-7 cycle at $k = 12$ to D = -1675, but the ghost type table says D = -1675 first appears at $k = 95$ with period 660. This attribution needs verification.

**M3. Conjecture 3 vs Collatz (Section 5).** The Remark says "Conjecture 3 is at least as strong as the Collatz conjecture." This is an overstatement: Conjecture 3 addresses periodic orbits but not divergent trajectories. Restate as "at least as strong as the Collatz cycle conjecture" or similar.

**M4. Density computation (Section 4.2).** The density 5/34 = 0.147 is reported as 0.152. Verify the denominator.

**M5. "$D$ nonzero for $V > L\log_2 3$" (Section 4.3).** $D \neq 0$ always (since $2^V \neq 3^L$). The condition $V > L\log_2 3$ determines the sign ($D < 0$), not nonvanishing. Rephrase.

**M6. Exceptional level count (Section 5.1).** The text says "the four known ghost types account for 17 of the 20 exceptional levels" and "the remaining three levels (k = 10, 11, 20)" are in [3, 36]. Clarify whether "20 exceptional levels" refers to [3, 200] or [37, 200], and verify the count.

**M7. Uncited references.** Six references in the bibliography are not cited in the text. Remove them or add citations.

**M8. Pade figure (Section 6).** The Pade approximant figure is not connected to any theorem, conjecture, or detailed discussion. Either develop it or remove it.

### Section-by-Section Ratings

| Section | Rating | Key Issue |
|---------|--------|-----------|
| 1. Introduction | READY | Minor clarity improvements |
| 2. Definitions and Setup | READY | Clean and correct |
| 3. The Parametric Family | NEEDS MINOR EDITS | Phase transition weight convention |
| 4. Exceptional Set Enumeration | **NEEDS MAJOR EDITS** | **Proposition 2 is false** |
| 5. Falsification of Conjecture 1 | NEEDS MINOR EDITS | Exceptional level count; Conjecture 3 overstatement |
| 6. Eigenvalue Spectra | NEEDS MINOR EDITS | k=12 cycle attribution; Pade figure |
| 7. Computational Methodology | READY | Clear and adequate |
| References | NEEDS MINOR EDITS | Uncited references |

### FLAGS FOR IMPLEMENTER

1. Check how the spectral radius is computed in the code for the phase transition figure (Figure 1). Does the weight include a factor of $x$?
2. Verify the density: is $|[3,36]| = 34$ or 33? If 34, the density should be 0.147, not 0.152.
3. Verify the constant 25 in Proposition 1 against Laurent (2008), Corollary 1.
4. Verify the explicit bounds $K_0(5) \leq 269$ and $K_0(10) \leq 465{,}239$.
5. Verify $p = \text{ord}_2(|D|)$ for each ghost: ord_2(601) = 25, ord_2(179) = 178, ord_2(5537) = 84, ord_2(1675) = 660.
6. Verify the rational orbit elements $\tilde{n}_1 = R/D$ for each ghost type.
7. Verify $r$ (residue class count) for each ghost type.
8. Verify which ghost type produces the cycle of length 7 at $k = 12$. Is it really D = -1675?
9. Verify that exactly 20 levels in [3, 200] are exceptional, and clarify the range.
10. Confirm that dense eigenvalue computation for $k = 15$ ($N = 16384$) was performed and yields spectrum $\{0, 1/4\}$.
11. Verify that the k = 36 exhaustive search completed without errors.
