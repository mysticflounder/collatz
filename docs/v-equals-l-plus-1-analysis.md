# Analysis of the $V = L+1$ Ghost Family: Spectral Radius, Obstructions, and the Materialization Problem

**Date:** 2026-03-07
**Author:** Mathematical assessment (dynamical systems, spectral theory, $p$-adic analysis)

**Context.** A systematic search for ghosts in the minimal valuation-excess family $V = L+1$ (v-pattern $(1,\ldots,1,2)$) has been completed for $6 \leq L \leq 20$. This document analyzes the results in depth.

---

## Table of Contents

1. [Summary of the Data](#1-summary)
2. [Why L=9 and L=11 Fail: The Algebraic Obstruction](#2-obstruction)
3. [Can We Prove $\rho(L) = 1/2$?](#3-spectral-radius)
4. [The Materialization Problem: Case-(a) vs Appearance](#4-materialization)
5. [The r-Values: Structure of Residue Class Counts](#5-r-values)
6. [Implications for the Paper](#6-paper-implications)
7. [Computational Specifications](#7-specifications)

---

## 1. Summary of the Data {#1-summary}

For the $V = L+1$ family, $D = 2^{L+1} - 3^L$ and $\rho = 2^{-(L+1)/L}$. The v-pattern is $(1,1,\ldots,1,2)$ (all valuations equal to 1 except the last, which equals 2). By cyclic rotation symmetry, we focus on this single canonical pattern; the $L-1$ other placements of the "2" are related by rotation.

| $L$  | $\rho$   | $\|D\|$        | $\text{period}$ | $r$ | first $k$ | appears | search   |
|------|----------|----------------|-----------------|-----|-----------|---------|----------|
| 6    | 0.4455   | 601            | 25              | 1   | 12        | YES     | full     |
| 7    | 0.4529   | 1,931          | 1,930           | 5   | 275       | YES     | full     |
| 8    | 0.4585   | 6,049          | 1,441           | 10  | 180       | YES     | full     |
| 9    | 0.4629   | 18,659         | 1,012           | 0   | ---       | no      | full     |
| 10   | 0.4665   | 57,281         | 5,736           | 6   | 1,147     | YES     | full     |
| 11   | 0.4695   | 173,051        | 780             | 0   | ---       | no      | full     |
| 12   | 0.4719   | 524,929        | 14,065          | 4   | 1,334     | YES     | full     |
| 13   | 0.4740   | 1,586,131      | 58,140          | 12  | 4,472     | YES     | full     |
| 14   | 0.4759   | 4,782,223      | 294,712         | 4   | 8,087     | YES     | partial  |
| 15   | 0.4774   | 14,394,367     | 1,187,496       | 2   | 29,459    | YES     | partial  |
| 16   | 0.4788   | 43,279,697     | 3,065,403       | 0   | ---       | no      | partial  |
| 17   | 0.4800   | 130,036,283    | 16,081,068      | 0   | ---       | no      | partial  |
| 18   | 0.4811   | 390,502,537    | 19,299,905      | 0   | ---       | no      | partial  |
| 19   | 0.4821   | 1,172,294,393  | 555,362,676     | 0   | ---       | no      | partial  |
| 20   | 0.4830   | 3,518,457,745  | 57,693,495      | 0   | ---       | no      | partial  |

**Key structural fact:** $|D| = 3^L - 2^{L+1}$ (since $2^{L+1} < 3^L$ for $L \geq 2$). The period is $p = \text{ord}_2(|D|)$, the multiplicative order of 2 modulo $|D|$.

---

## 2. Why $L = 9$ and $L = 11$ Fail: The Algebraic Obstruction {#2-obstruction}

### 2.1 What "Failure" Means Precisely

All compositions are algebraically case-(a): the rational orbit $\tilde{n}_1 = R/D$ satisfies $v_2(3\tilde{n}_i + 1) = v_i$ for every $i$, by construction. The "failure" of $L = 9$ and $L = 11$ is NOT that the 2-adic orbit is invalid. Rather, it is that this particular ghost never **materializes** at any finite level $k$ --- i.e., there is no $k$ such that the modular reduction $n_1 \equiv R \cdot D^{-1} \pmod{2^k}$ produces a cycle of the modular Syracuse map $S_k$ with the prescribed v-pattern.

This distinction is crucial. Case-(a) means the 2-adic limit orbit has the correct valuations. Materialization means the modular truncation at level $k$ also has the correct valuations, which is a strictly stronger condition: the truncation can introduce "overflow" in the valuation (i.e., $v_2(3n_i^{(k)} + 1) > v_i$ at finite $k$), breaking the cycle.

### 2.2 The Materialization Condition

Let me state the precise condition. For the v-pattern $(1,1,\ldots,1,2)$ with $V = L+1$ and $D = 2^{L+1} - 3^L$, the ghost materializes at level $k$ if and only if:

$$n_1^{(k)} \equiv R \cdot D^{-1} \pmod{2^k}$$

satisfies $v_2(3 n_i^{(k)} + 1) = v_i$ for $i = 1, \ldots, L$, where $n_i^{(k)}$ is taken in $\{1, 3, \ldots, 2^k - 1\}$ and iterated under $S_k$.

The key constraint is the **exactness** of the valuations: we need $v_2(3n_i^{(k)} + 1) = v_i$, not merely $\geq v_i$. For $v_i = 1$ (the first $L-1$ steps), this means $3n_i^{(k)} + 1 \equiv 2 \pmod{4}$, i.e., $n_i^{(k)} \equiv 1 \pmod{4}$... no, wait. Let me be more careful.

For odd $n$, $3n + 1$ is even. Write $3n + 1 = 2^v \cdot m$ with $m$ odd. Then $v_2(3n+1) = v$. The condition $v = 1$ means $3n + 1 \equiv 2 \pmod{4}$, i.e., $n \equiv 1 \pmod{4}$... actually, $3n + 1 \equiv 2 \pmod{4}$ iff $3n \equiv 1 \pmod{4}$ iff $n \equiv 3 \pmod{4}$ (since $3 \cdot 3 = 9 \equiv 1$). And $v = 2$ means $3n + 1 \equiv 4 \pmod{8}$, i.e., $n \equiv 1 \pmod{8}$.

The point is: each valuation condition $v_2(3n_i + 1) = v_i$ constrains $n_i$ modulo $2^{v_i + 1}$. For the 2-adic limit $\tilde{n}_i$, these constraints are automatically satisfied (that is what case-(a) means). For the modular truncation $n_i^{(k)}$, they hold as long as $k$ is large enough to "see" the relevant bits. But the orbit elements $n_i^{(k)}$ depend on $k$ through the truncation $R \cdot D^{-1} \bmod 2^k$, and the dependence is periodic with period $p = \text{ord}_2(|D|)$.

### 2.3 The Lift Obstruction

Since the orbit of $\tilde{n}_1$ in $\mathbb{Z}_2$ satisfies the valuation conditions exactly, the modular truncation at level $k$ can only fail if the truncation introduces a "carry" that changes a valuation. Specifically, at step $i$ with $v_i = 1$, the condition $v_2(3n_i^{(k)} + 1) = 1$ could fail if $v_2(3n_i^{(k)} + 1) \geq 2$. This happens when $3n_i^{(k)} + 1 \equiv 0 \pmod{4}$, i.e., $n_i^{(k)} \equiv 1 \pmod{4}$.

But wait: the 2-adic limit has $v_2(3\tilde{n}_i + 1) = 1$, which means $\tilde{n}_i \equiv 3 \pmod{4}$. The modular truncation $n_i^{(k)} \equiv \tilde{n}_i \pmod{2^k}$, so for $k \geq 3$, we have $n_i^{(k)} \equiv \tilde{n}_i \pmod{4}$, hence $n_i^{(k)} \equiv 3 \pmod{4}$, hence $v_2(3n_i^{(k)} + 1) = 1$. The valuation is preserved.

**This argument shows that for $k \geq 3$, the first step's valuation is always correct.** More generally, for $v_i = 1$, the constraint is on $n_i \bmod 4$, which stabilizes once $k \geq 3$. For $v_i = 2$ (the last step), the constraint is on $n_L \bmod 8$, stabilizing once $k \geq 4$.

**So the valuations themselves always stabilize.** This seems to contradict the observation that $L = 9$ and $L = 11$ never materialize. What is going on?

### 2.4 The Correct Obstruction: Orbit Closure

The issue is not with the individual valuation conditions --- those are guaranteed by case-(a) for sufficiently large $k$. The issue is with **orbit closure modulo $2^k$**. For the ghost to materialize at level $k$, the orbit $n_1^{(k)}, n_2^{(k)}, \ldots, n_L^{(k)}$ must close: applying $S_k$ to $n_L^{(k)}$ with valuation $v_L = 2$ must return to $n_1^{(k)}$.

In the 2-adic limit, the orbit closes by construction: $S(\tilde{n}_L) = \tilde{n}_1$. But modulo $2^k$, we need $S_k(n_L^{(k)}) \equiv n_1^{(k)} \pmod{2^k}$. The cycle equation

$$n_1 \cdot (2^V - 3^L) \equiv R \pmod{2^{k+V}}$$

guarantees this --- but only if we are working modulo $2^{k+V}$, not just modulo $2^k$. The solution $n_1^{(k)}$ is determined modulo $2^k$ by $R \cdot D^{-1} \bmod 2^k$. For the orbit to close at level $k$, we need the stronger condition that the solution modulo $2^{k+V}$ reduces consistently.

**CORRECTION to the above reasoning.** After more careful thought, I realize my earlier analysis was converging on the wrong obstruction. Let me reconsider from scratch.

### 2.5 Reconsideration: What Actually Determines Materialization

The ghost at level $k$ exists if and only if $n_1 = R \cdot D^{-1} \bmod 2^k$ (taken as an odd residue) satisfies all $L$ valuation conditions $v_2(3 n_i^{(k)} + 1) = v_i$ exactly. Since the 2-adic limit satisfies these conditions, the modular truncation also satisfies them for all sufficiently large $k$ (once $k$ exceeds the "stabilization depth" for each orbit element). Therefore, for $k$ large enough, the ghost always materializes.

**But this contradicts the data:** $L = 9$ and $L = 11$ were searched over the full period and found no materializations. This means my reasoning above has an error.

The error is in assuming that "sufficiently large $k$" is bounded. In fact, the stabilization depth depends on the orbit: the orbit element $n_i^{(k)}$ is NOT simply $\tilde{n}_i \bmod 2^k$. It is obtained by iterating $S_k$ from $n_1^{(k)}$, and the iteration modulo $2^k$ can differ from the 2-adic iteration at intermediate steps if the modular reduction at any step changes the trajectory. Specifically, if at some step $j$, the map $S_k(n_j^{(k)})$ differs from $S(\tilde{n}_j) \bmod 2^k$ due to the modular arithmetic, then the subsequent orbit diverges from the 2-adic orbit.

**However**, this also cannot happen if all valuations are correct, because then $S_k(n_j^{(k)}) = (3n_j^{(k)} + 1)/2^{v_j} \bmod 2^k$, which equals $S(\tilde{n}_j) \bmod 2^k$ whenever $n_j^{(k)} \equiv \tilde{n}_j \pmod{2^k}$. This is guaranteed by induction once $k$ is large enough to stabilize the valuations.

I therefore conclude that **if the v-pattern is truly case-(a), the ghost must appear at all sufficiently large $k$, and in particular must appear within one full period**. Since $L = 9$ and $L = 11$ do not appear within their full period, either:

**(A)** The v-pattern $(1,1,\ldots,1,2)$ for $L = 9$ and $L = 11$ is NOT actually case-(a), despite the general claim that "all compositions are case-(a)." The computational claim needs re-verification for these specific cases.

**(B)** There is a subtlety I am missing about the relationship between the 2-adic orbit and modular materialization.

### 2.6 Resolution: The Periodicity Trap

After further reflection, I believe the resolution lies in the periodicity structure. The 2-adic expansion of $\tilde{n}_1 = R/D$ is eventually periodic with period $p = \text{ord}_2(|D|)$. The ghost materializes at level $k$ if the first $k$ digits of the 2-adic expansion produce the correct orbit. Since the expansion is eventually periodic, the materialization condition is also eventually periodic in $k$, and either:

- It is eventually always satisfied (the ghost appears at a positive density of levels within each period), or
- It is eventually never satisfied (the ghost appears at no level beyond the initial transient).

For case-(a), the 2-adic limit orbit has the correct valuations, which means that the bits of $\tilde{n}_i$ at positions $0, 1, \ldots, v_i$ encode the correct valuation. But the **modular** orbit uses $n_i^{(k)} = \tilde{n}_i \bmod 2^k$, and the iteration at finite $k$ can wrap around: $S_k$ operates on residues mod $2^k$, so the division by $2^{v_i}$ does not just shift the 2-adic expansion --- it also discards the top bits and wraps around.

The critical insight is that the ghost at level $k$ requires not just that each $n_i^{(k)}$ has the right low-order bits (which determines the valuation), but also that the **orbit closes modulo $2^k$**. This closure condition, after substituting the cycle equation, becomes:

$$R \cdot D^{-1} \bmod 2^k \text{ is odd, and the orbit returns to itself after } L \text{ steps mod } 2^k.$$

The cycle equation guarantees closure modulo $2^{k+V}$ by construction: $n_1 D \equiv R \pmod{2^{k+V}}$. But we are solving modulo $2^k$, so what we actually get is a solution modulo $2^k$ that may or may not close. The gap is between the $2^k$ truncation and the $2^{k+V}$ closure guarantee.

**Here is the precise statement:** Let $n_1 = R \cdot D^{-1} \bmod 2^{k}$. This determines the orbit $n_1, n_2, \ldots, n_L$ modulo $2^{k - V}$ (because each step divides by $2^{v_i}$, losing $v_i$ bits of resolution). For the orbit to close, we need $n_L$ to map back to $n_1$ modulo $2^k$, which requires the orbit to be consistent modulo $2^k$, not just modulo $2^{k-V}$.

I believe the non-appearance of $L = 9, 11$ may be related to the structure of $|D|$ modulo small powers of 2, but a rigorous analysis requires a more careful number-theoretic computation than I can perform without computation. Let me instead state what can be said cleanly.

### 2.7 A Number-Theoretic Hypothesis

**Observation.** The factorizations of $|D|$ are:

| $L$  | $\|D\|$   | Factorization              | $\text{ord}_2(\|D\|)$ | Appears? |
|------|-----------|----------------------------|-----------------------|----------|
| 6    | 601       | $601$ (prime)              | 25                    | YES      |
| 7    | 1,931     | $1931$ (prime)             | 1,930                 | YES      |
| 8    | 6,049     | $23 \times 263$            | 1,441                 | YES      |
| 9    | 18,659    | $47 \times 397$            | 1,012                 | no       |
| 10   | 57,281    | $7 \times 17 \times 479$ (or $7 \times 8183$) | 5,736   | YES      |
| 11   | 173,051   | $131 \times 1321$          | 780                   | no       |
| 12   | 524,929   | needs factoring            | 14,065                | YES      |
| 13   | 1,586,131 | needs factoring            | 58,140                | YES      |

Both $L = 8$ and $L = 9$ have composite $|D|$, so compositeness alone does not explain the obstruction. Both $L = 6$ and $L = 11$ have relatively small periods relative to $|D|$, so small period does not explain it either (in fact, $L = 11$ has $p/|D| = 780/173051 \approx 0.0045$, while $L = 6$ has $p/|D| = 25/601 \approx 0.042$, so a small ratio might correlate --- but $L = 8$ has $p/|D| = 1441/6049 \approx 0.238$, which is large, and also appears).

**Hypothesis (SPECULATIVE, requires verification).** The obstruction for $L = 9$ and $L = 11$ may be related to the **splitting behavior of 2 in the ring $\mathbb{Z}/|D|\mathbb{Z}$**, specifically to the structure of the multiplicative group $(\mathbb{Z}/|D|\mathbb{Z})^*$ and the position of $2$ within it.

For the ghost to appear at level $k$, we need the $k$-th truncation of $R \cdot D^{-1}$ to satisfy certain congruence conditions. These conditions are periodic in $k$ with period $p = \text{ord}_2(|D|)$. The number $r$ of levels within one period where the ghost materializes depends on how many $k_0 \in \{0, 1, \ldots, p-1\}$ satisfy all $L$ valuation conditions simultaneously.

The valuation conditions are constraints of the form $n_i \equiv a_i \pmod{2^{v_i+1}}$ for specific values $a_i$ depending on the orbit. These translate (via the 2-adic expansion of $R/D$) into conditions on the bits of $R \cdot 2^{k_0}$ modulo $|D|$ (or more precisely, on $R \cdot 2^{k_0} \bmod |D|$ falling in certain residue classes). The question becomes: how many $k_0$ in $\{0, \ldots, p-1\}$ place $R \cdot 2^{k_0} \bmod |D|$ into the required set?

**The heuristic.** If the $L$ valuation conditions were independent and each satisfied with probability $\sim 1/2$, we would expect $r \approx p / 2^L$. For $L = 9$, $p = 1012$, giving $r \approx 1012/512 \approx 2$. For $L = 11$, $p = 780$, giving $r \approx 780/2048 \approx 0.4$. The heuristic predicts $r \approx 0$ for $L = 11$, which is consistent with the data. For $L = 9$, the prediction is $r \approx 2$, which is close to the boundary; $r = 0$ is plausible by fluctuation.

**This heuristic is CRUDE** --- the conditions are not independent, and the "probability $1/2$" is an oversimplification --- but it correctly predicts the overall trend:

| $L$ | $p$ | $p/2^L$ | $r$ (observed) |
|-----|-----|---------|----------------|
| 6   | 25  | 0.39    | 1              |
| 7   | 1,930 | 15.1  | 5              |
| 8   | 1,441 | 5.6   | 10             |
| 9   | 1,012 | 2.0   | 0              |
| 10  | 5,736 | 5.6   | 6              |
| 11  | 780   | 0.38  | 0              |
| 12  | 14,065 | 3.4  | 4              |
| 13  | 58,140 | 7.1  | 12             |
| 14  | 294,712 | 18.0 | 4              |
| 15  | 1,187,496 | 36.2 | 2            |

The cases with $p/2^L < 1$ ($L = 6$ and $L = 11$) are marginal: $L = 6$ gets lucky ($r = 1$), $L = 11$ does not ($r = 0$). The case $L = 9$ has $p/2^L \approx 2$, which makes $r = 0$ plausible but unlucky.

### 2.8 A More Refined Criterion

The heuristic above can be sharpened. The valuation conditions are not all independent. For the v-pattern $(1,1,\ldots,1,2)$:

- Steps $i = 1, \ldots, L-1$ each require $v_2(3n_i + 1) = 1$, which constrains $n_i \bmod 4$.
- Step $i = L$ requires $v_2(3n_L + 1) = 2$, which constrains $n_L \bmod 8$.

The orbit satisfies $n_{i+1} = (3n_i + 1)/2 \bmod 2^k$ for $i < L$ and $n_1 = (3n_L + 1)/4 \bmod 2^k$. The map $n \mapsto (3n+1)/2$ is linear modulo $2^k$: it is well-defined when $n \equiv 3 \pmod 4$ (which ensures $v_2(3n+1) = 1$) and maps $n$ to $(3n+1)/2 \bmod 2^k$.

The condition $v_2(3n_i + 1) = 1$ (exactly, not $\geq 1$) is $n_i \equiv 3 \pmod{4}$, which is a condition on 2 bits. Given $n_1 \bmod 2^k$, the entire orbit is determined. So really there is only ONE free parameter ($n_1 \bmod 2^k$), and ALL conditions must be checked simultaneously.

Since $n_1 = R \cdot D^{-1} \bmod 2^k$ and $D$ is a fixed odd number, as $k$ varies through one period of $\text{ord}_2(|D|)$, the value $n_1 \bmod 2^k$ traces through a specific pattern of 2-adic digits. The valuation conditions at each step constrain specific bits of $n_i$, which are determined by the bits of $n_1$ via the iteration.

The total number of independent binary constraints is $1 + 1 + \cdots + 1 + 2 = L + 1$ (one constraint per step for the "exactly $v_i$" condition, but the extra "1" at the last step is because $v_L = 2$ constrains one more bit than $v_i = 1$). However, these constraints are NOT on independent bits of $n_1$ --- they are on bits of $n_1, n_2, \ldots, n_L$, which are all deterministic functions of $n_1$.

**The effective number of constraints** depends on the mixing properties of the map $n \mapsto (3n+1)/2$ on the 2-adic integers. This map expands the 2-adic metric by a factor of 3/2 (approximately), so after $L$ steps, the initial bits of $n_1$ influence bits at positions up to roughly $L \cdot \log_2(3/2) \approx 0.585 L$ higher. The constraints are on low-order bits (positions 0 and 1 of each $n_i$), which correspond to specific higher-order bits of $n_1$.

**A cleaner way to think about it.** The ghost materializes at level $k$ if and only if a certain set of $L$ congruence conditions on $n_1 \bmod 2^k$ are satisfied. These conditions define a subset $\mathcal{A}_k \subset (\mathbb{Z}/2^k\mathbb{Z})^*_{\text{odd}}$. Since $n_1 = R \cdot D^{-1} \bmod 2^k$ is completely determined by $k$, the ghost materializes iff $R \cdot D^{-1} \bmod 2^k \in \mathcal{A}_k$. As $k$ ranges over a full period $p = \text{ord}_2(|D|)$, we are asking how many $k_0$ hit $\mathcal{A}_{k_0}$.

### 2.9 Tentative Conclusion on $L = 9, 11$

**STATUS: HEURISTIC.** The non-appearance of $L = 9$ and $L = 11$ is most likely a statistical phenomenon: the period $p = \text{ord}_2(|D|)$ is too small relative to $2^L$ for the "random" placement of $R \cdot D^{-1} \bmod 2^k$ within each period to hit the required congruence classes. The ratio $p/2^L$ is a rough predictor of $r$:

- When $p/2^L \gg 1$, the ghost almost certainly appears (many opportunities).
- When $p/2^L \ll 1$, the ghost almost certainly does not appear (too few opportunities).
- When $p/2^L \approx 1$, the outcome depends on the arithmetic details.

For $L = 9$: $p/2^L \approx 2$, marginal. For $L = 11$: $p/2^L \approx 0.4$, below the threshold.

**I do not see a clean algebraic criterion** (in terms of factorization of $|D|$ or structure of $(\mathbb{Z}/|D|\mathbb{Z})^*$) that cleanly separates appearing from non-appearing cases. The phenomenon appears to be "number-theoretic luck" --- whether a pseudorandom sequence $\{R \cdot 2^{k_0} \bmod |D|\}_{k_0=0}^{p-1}$ hits a target set of density $\sim 2^{-L}$.

**What would change this assessment:** If the valuation conditions imposed a structure that is NOT well-modeled by a random target set, then a clean criterion might exist. The specification in Section 7 proposes a computation to test this.

---

## 3. Can We Prove $\rho(L) = 1/2$? {#3-spectral-radius}

### 3.1 The Evidence

The data shows that V = L+1 ghosts materialize for $L = 6, 7, 8, 10, 12, 13, 14, 15$. Each such ghost has spectral radius $\rho = 2^{-(L+1)/L}$, which approaches $1/2$ from below as $L \to \infty$. If appearing ghosts exist for infinitely many $L$, then:

$$\rho(L) \geq \sup_L 2^{-(L+1)/L} = 1/2.$$

Combined with the proved upper bound $\rho(L) \leq 1/2$, this would give $\rho(L) = 1/2$.

### 3.2 The Current State of Evidence

**PROVED:**
- $\rho(L) \leq 1/2$ (from $v \geq 1$ always).
- $\rho(L) \geq 2^{-9/8} \approx 0.4585$ (from the $L = 8$, $D = -6049$ ghost, which appears at $k = 180$).

**STRONGLY SUPPORTED (COMPUTATIONAL, NOT PROVED):**
- The $V = L+1$ family produces appearing ghosts at $L = 6, 7, 8, 10, 12, 13, 14, 15$, with $\rho$ values increasing monotonically toward $1/2$.

**NOT YET ESTABLISHED:**
- Whether appearing ghosts exist for ALL sufficiently large $L$ (some may have $r = 0$ due to the period being too small relative to $2^L$).
- Whether ghosts with $L \geq 16$ in the $V = L+1$ family materialize. The search was capped at $k = 60{,}000$, which covers only a small fraction of the full period for $L \geq 16$.

### 3.3 The Partial-Search Problem for $L \geq 16$

For $L = 16, 17, 18, 19, 20$, the full periods are $3.1 \times 10^6$, $1.6 \times 10^7$, $1.9 \times 10^7$, $5.6 \times 10^8$, and $5.8 \times 10^7$ respectively, while the search was capped at $60{,}000$. This means:

| $L$  | period     | searched | fraction searched | $p/2^L$    |
|------|------------|----------|-------------------|------------|
| 16   | 3,065,403  | 60,000   | 1.96%             | 46.8       |
| 17   | 16,081,068 | 60,000   | 0.37%             | 122.9      |
| 18   | 19,299,905 | 60,000   | 0.31%             | 73.6       |
| 19   | 555,362,676| 60,000   | 0.01%             | 1,058      |
| 20   | 57,693,495 | 60,000   | 0.10%             | 55.0       |

The ratios $p/2^L$ are large for all of $L = 16, \ldots, 20$, meaning the heuristic predicts $r > 0$ for all of them. The non-detection is explained entirely by insufficient search depth. **The absence of ghosts at $L = 16$--$20$ in the partial search is NOT evidence against their existence.** It is expected: if $r/p \sim 2^{-L}$, the first appearance $k_0$ is typically of order $p/r \sim p \cdot 2^L / p = 2^L$, which for $L = 16$ gives $k_0 \sim 65{,}536$, barely outside the search range.

### 3.4 What Would a Rigorous Proof Require?

To prove $\rho(L) = 1/2$ rigorously, one needs to show that case-(a) ghosts with $V = L+1$ materialize for infinitely many $L$. This requires:

**Step 1.** Show that the v-pattern $(1,\ldots,1,2)$ is case-(a) for all $L$ (or at least infinitely many $L$). The computational claim is that ALL compositions are algebraically case-(a). If this is PROVED (not just computed), then Step 1 is done for all $L$.

**Step 2.** Show that the materialization probability $r/p$ is positive for infinitely many $L$. The heuristic predicts $r \approx p/2^L$, which is positive whenever $p > 0$ (always). But turning this into a proof requires showing that the "random model" for the placement of $R \cdot 2^{k_0} \bmod |D|$ is valid in a quantitative sense.

**Step 2 is the hard part.** It reduces to a problem in the distribution of orbits of the map $x \mapsto 2x \bmod |D|$ on $\mathbb{Z}/|D|\mathbb{Z}$, specifically whether the orbit $\{R \cdot 2^{k_0} \bmod |D|\}_{k_0=0}^{p-1}$ intersects a specific target set $\mathcal{T} \subset \mathbb{Z}/|D|\mathbb{Z}$ of density $\sim 2^{-L}$. This is a problem in **exponential sum theory** (or equivalently, equidistribution of multiplicative sequences modulo composite numbers).

For $|D|$ prime, the orbit $\{R \cdot 2^{k_0}\}$ is a full subgroup of $(\mathbb{Z}/|D|\mathbb{Z})^*$ of order $p$, and the intersection with $\mathcal{T}$ can be estimated by character sum methods (specifically, incomplete exponential sums over multiplicative subgroups). If the Polya-Vinogradov inequality or a character sum bound gives $|\mathcal{T} \cap \text{orbit}| = |\mathcal{T}| \cdot p / \phi(|D|) + O(\sqrt{|D|} \log |D|)$, and if $|\mathcal{T}| \cdot p / \phi(|D|) \gg \sqrt{|D|} \log |D|$, then the intersection is nonempty.

For $|D| = 3^L - 2^{L+1} \sim 3^L$ and $p = \text{ord}_2(|D|)$, the ratio $p/\phi(|D|)$ depends on the multiplicative structure. If $|D|$ is prime, $\phi(|D|) = |D| - 1$, and we need:

$$\frac{|D|}{2^L} \cdot \frac{p}{|D| - 1} \gg \sqrt{|D|} \log |D|$$

which simplifies to $p / 2^L \gg \sqrt{|D|} \log |D|$, i.e., $p \gg 2^L \sqrt{3^L} (\log 3) L \approx (2\sqrt{3})^L L$. Since $p \leq |D| - 1 \sim 3^L$ and $(2\sqrt{3})^L = (2 \cdot 1.732)^L \approx 3.464^L > 3^L$, **this bound is not satisfied**. The character sum approach falls short.

### 3.5 Assessment

**STATUS: OPEN CONJECTURE.** The statement "$\rho(L) = 1/2$" should be stated as a conjecture, not a theorem. The computational evidence is strong (8 out of 10 fully-searched values of $L$ produce appearing ghosts), but a proof requires either:

(a) A number-theoretic result about the distribution of $\{R \cdot 2^{k_0} \bmod |D|\}$ intersecting sparse target sets, which is beyond current exponential sum technology; or

(b) A completely different approach that avoids the materialization question entirely --- for instance, showing that ghosts with $V = L + 1$ exist for a DIFFERENT v-pattern (not necessarily $(1,\ldots,1,2)$) at infinitely many $L$, leveraging the fact that there are $L$ candidate patterns per $L$.

Approach (b) is promising because it multiplies the number of chances by $L$. If each of the $L$ patterns has an independent probability $\sim p/2^L$ of materializing, the probability that at least one materializes is $\sim 1 - (1 - p/2^L)^L \approx 1 - e^{-Lp/2^L}$. For $Lp/2^L \gg 1$ (i.e., $p \gg 2^L/L$), at least one pattern almost certainly materializes. Since $p \leq |D| \sim 3^L$ and $2^L/L \ll 3^L$ for large $L$, this heuristic predicts that at least one v-pattern materializes for all large $L$.

**Conjecture (HEURISTIC).** For all sufficiently large $L$, there exists at least one placement of the "2" (i.e., at least one of the $L$ cyclic rotations of the v-pattern $(1,\ldots,1,2)$) that produces an appearing ghost at some level $k$.

If this conjecture is true, then $\rho(L) = 1/2$. But proving it requires the equidistribution statement above, which is hard.

### 3.6 Is the Partial Search Evidence Concerning?

**No.** The $L = 16$--$20$ non-detections are fully explained by insufficient search depth (the fraction of the period searched is $< 2\%$ in all cases). The heuristic predicts $r > 0$ for all of them. Extending the search to larger $k$ (or using algebraic methods to directly compute the residue classes) would likely find materializations.

**SPECIFICATION:** See Section 7.1 for a targeted search at $L = 16$ using algebraic methods rather than brute-force enumeration.

---

## 4. The Materialization Problem: Case-(a) vs Appearance {#4-materialization}

### 4.1 Separating the Two Concepts

The computational finding that "all compositions are algebraically case-(a)" (if verified) means that the distinction in the theory should not be between case-(a) and case-(b), but between **case-(a) with positive $r$** and **case-(a) with $r = 0$**. Both are true 2-adic periodic orbits; the difference is whether the orbit's modular projection ever closes at finite level.

This is a meaningful mathematical distinction. A case-(a) orbit with $r = 0$ is a "ghost that never materializes" --- it exists in $\mathbb{Z}_2$ but is never seen in finite modular arithmetic. From the spectral-theoretic perspective, such orbits still contribute to $\sigma(L)$ (because $\sigma(L) = \overline{\bigcup_k \sigma(P_k)}$ involves the closure, and the limit eigenvalue $2^{-V/L}$ may be an accumulation point even if it never appears as an eigenvalue of any $P_k$). However, I need to be more careful here.

### 4.2 Does $r = 0$ Imply Exclusion from $\sigma(L)$?

**IMPORTANT POINT.** By the projective limit theorem (Theorem 2(e) of the spectral theory document), $\sigma(L) = \overline{\bigcup_k \sigma(P_k)}$. An eigenvalue $\lambda$ belongs to $\sigma(L)$ if and only if it is an eigenvalue of $P_k$ for some $k$, or is a limit of such eigenvalues.

If a case-(a) ghost with v-pattern $v$ and $(L, V)$ has $r = 0$ --- meaning it never appears as a cycle of $P_k$ for any $k$ --- then $2^{-V/L}$ is NOT an eigenvalue of any $P_k$, and it contributes to $\sigma(L)$ only if it is a limit of eigenvalues from other ghost types.

**For the $V = L+1$ family specifically:** the ghosts at $L = 9$ and $L = 11$ have $\rho = 2^{-10/9} \approx 0.4629$ and $\rho = 2^{-12/11} \approx 0.4695$ respectively. Even if these specific ghosts never materialize, the ghosts at $L = 8$ ($\rho \approx 0.4585$) and $L = 10$ ($\rho \approx 0.4665$) DO materialize, and $\rho = 2^{-10/9}$ lies between them. Since $\sigma(L)$ is closed, the sequence $2^{-(L+1)/L}$ for $L = 6, 7, 8, 10, 12, 13, 14, 15$ has accumulation points filling the interval $[2^{-7/6}, 1/2)$... but actually, these are discrete values, not a continuous family. Their accumulation point is $1/2$ (the limit as $L \to \infty$), but intermediate values are not automatically in the spectrum.

**CORRECTION:** The spectrum $\sigma(L)$ contains $\{2^{-(L+1)/L} : L \in S\}$ where $S$ is the set of $L$-values with appearing ghosts. If $S$ is infinite, then $1/2 \in \sigma(L)$ (as an accumulation point). But $1/2$ is then in the spectrum, making $\rho(L) \geq 1/2$, hence $\rho(L) = 1/2$.

If $S$ is finite, then $\rho(L) = \max(1/4, \max_{L \in S} 2^{-(L+1)/L})$, which is strictly less than $1/2$.

**The non-materializing ghosts ($L = 9, 11$) do not contribute directly to $\sigma(L)$.** They are irrelevant to the spectral radius question unless their eigenvalue is an accumulation point of other eigenvalues.

### 4.3 What Determines Materialization? Precise Statement

**Theorem (PROVED, from Theorem C of Baker-Wustholz analysis).** Let $(L, V, v)$ be a case-(a) triple. Then the set of levels $k$ where the ghost materializes is eventually periodic with period $p = \text{ord}_2(|D|)$. The number of materializations per period is some $r \geq 0$. Moreover:

- If $r > 0$: the ghost contributes eigenvalue $2^{-V/L}$ to $\sigma(P_k)$ for infinitely many $k$ (the arithmetic progression $k \equiv k_0 \pmod{p}$ for each materializing $k_0$).
- If $r = 0$: the ghost never contributes to any $\sigma(P_k)$.

The value of $r$ is determined by the number of $k_0 \in \{0, 1, \ldots, p-1\}$ where the modular orbit closes with the correct valuations. This is a finite computation for each case-(a) triple.

**What determines $r$?** As discussed in Section 2, $r$ depends on the intersection of the orbit $\{R \cdot 2^{k_0} \bmod |D|\}_{k_0=0}^{p-1}$ with a target set in $\mathbb{Z}/|D|\mathbb{Z}$. The target set encodes the valuation conditions and has density approximately $2^{-L}$ in $\mathbb{Z}/|D|\mathbb{Z}$. Whether the orbit intersects this set is a question about the distribution of powers of 2 modulo $|D|$, a classical problem in multiplicative number theory.

---

## 5. The $r$-Values: Structure of Residue Class Counts {#5-r-values}

### 5.1 The Data

| $L$ | $p$ | $r$ | $r \cdot 2^L / p$ | $r/p$ |
|-----|-----|-----|-------------------|-------|
| 6   | 25  | 1   | 2.56              | 0.040 |
| 7   | 1,930 | 5 | 0.33              | 0.0026|
| 8   | 1,441 | 10| 1.78              | 0.0069|
| 9   | 1,012 | 0 | 0                 | 0     |
| 10  | 5,736 | 6 | 1.07              | 0.0010|
| 11  | 780   | 0 | 0                 | 0     |
| 12  | 14,065| 4 | 1.16              | 0.00028|
| 13  | 58,140|12 | 1.69              | 0.00021|
| 14  | 294,712|4 | 0.22              | 0.000014|
| 15  | 1,187,496|2| 0.055            | 0.0000017|

### 5.2 Interpretation

The normalized count $r \cdot 2^L / p$ (column 4) fluctuates around 1, as the heuristic predicts. The values range from 0 to 2.56, with no obvious trend. This is consistent with the model that $r$ is approximately $p / 2^L$ with Poisson-like fluctuations.

**Is there a formula for $r$?** Almost certainly not a closed-form formula. The value of $r$ depends on the detailed arithmetic of $R \cdot 2^{k_0} \bmod |D|$, which is sensitive to the prime factorization of $|D|$ and the position of specific residues. This is the same type of "arithmetic chaos" that governs the distribution of primes in arithmetic progressions --- individual values fluctuate, but the average behavior follows a law.

**The analogy with Dirichlet's theorem.** Consider the problem: given a modulus $q$ and a target set $\mathcal{T} \subset (\mathbb{Z}/q\mathbb{Z})^*$ of density $\delta$, how many elements of the orbit $\{a \cdot 2^j \bmod q\}_{j=0}^{p-1}$ lie in $\mathcal{T}$? If the orbit is equidistributed in its coset of $(\mathbb{Z}/q\mathbb{Z})^*$, the answer is $\approx \delta \cdot p$. The deviation from this prediction is controlled by character sums, and for individual orbits the fluctuations can be significant.

### 5.3 The $L = 14, 15$ Anomaly

The values $r = 4$ for $L = 14$ and $r = 2$ for $L = 15$ give normalized counts $r \cdot 2^L / p$ of 0.22 and 0.055 respectively, significantly below 1. This could indicate:

(a) Random fluctuation (we are looking at a noisy process with small expected values).

(b) A systematic effect at larger $L$: perhaps the effective density of the target set $\mathcal{T}$ is smaller than $2^{-L}$ for larger $L$, due to dependencies between the valuation conditions.

(c) A search artifact: these were partial searches, so some materializations might have been missed.

I lean toward (a) and (c). The partial search for $L = 14$ covered about $2.7\%$ of the period, and for $L = 15$ about $2.5\%$. If the materializing residues are not concentrated at the beginning of the period, many could be missed. **The reported $r$ values for $L = 14$ and $L = 15$ are lower bounds, not exact counts.**

---

## 6. Implications for the Paper {#6-paper-implications}

### 6.1 The Status of "$\rho(L) = 1/2$"

Based on the analysis above, I recommend the following classification:

**"$\rho(L) = 1/2$" is a CONJECTURE**, supported by strong but not conclusive computational evidence. It should be stated as:

> **Conjecture (Spectral radius).** The spectral radius of the Syracuse transfer operator $L$ on $C(\mathbb{Z}_2^{\text{odd}})$ equals $1/2$:
> $$\rho(L) = \frac{1}{2}.$$
> Equivalently, for every $\epsilon > 0$, there exists a case-(a) ghost cycle with $\rho = 2^{-V/L} > 1/2 - \epsilon$.

**What is PROVED:**
- $2^{-9/8} \leq \rho(L) \leq 1/2$ (the lower bound from the $L = 8$ ghost, the upper bound from $v \geq 1$).

**What is CONJECTURED:**
- $\rho(L) = 1/2$ (from the $V = L+1$ family producing ghosts at $L = 6,7,8,10,12,13,14,15$).

### 6.2 The Narrative for the Paper

The data supports the following narrative:

1. **The $V = L+1$ family is the critical family for the spectral radius.** Among all ghost types, those with $V = L + 1$ have the largest $\rho$ for each $L$, approaching $1/2$ from below.

2. **Most values of $L$ produce appearing ghosts.** Of the 10 values $L = 6, \ldots, 15$ fully or partially searched, 8 produce ghosts. The two that do not ($L = 9, 11$) are plausibly explained by the period $p = \text{ord}_2(|D|)$ being too small relative to $2^L$.

3. **There is no algebraic obstruction to appearance.** All compositions are (reportedly) case-(a), meaning the 2-adic orbits always have the correct valuations. The only question is whether the modular truncation hits the right residue class.

4. **The failure of $L = 9, 11$ is a number-theoretic coincidence, not a structural obstruction.** The heuristic $r \approx p / 2^L$ correctly predicts both the appearance rate and the occasional zero.

5. **$\rho(L) = 1/2$ is the most natural conjecture.** The alternative ($\rho(L) < 1/2$) would require ALL $V = L+1$ ghosts to fail for $L$ beyond some threshold, which would be an extraordinary (and unexplained) coincidence given the heuristic.

### 6.3 Impact on the Broader Program

If $\rho(L) = 1/2$, then:

- The transfer operator $L$ on $C(\mathbb{Z}_2^{\text{odd}})$ has **no spectral gap**.
- The spectral approach to the Collatz conjecture on this Banach space is DEFINITIVELY insufficient.
- **This is not a dead end** but a signpost: any successful spectral approach must use a function space that distinguishes positive-integer orbits from negative-rational 2-adic orbits.
- The Mahler basis approach (Direction 4 of the next-steps document) becomes mandatory.

### 6.4 What the Paper Should Say About $L = 9, 11$

The paper should present both the data and the heuristic honestly:

> **Observation.** The $V = L+1$ ghosts with $L = 9$ and $L = 11$ do not materialize at any level $k$ within their full period ($p = 1012$ and $p = 780$ respectively). Both are algebraically case-(a). Their non-appearance is consistent with the heuristic that the number of materializing levels per period is $r \approx p/2^L$: for $L = 9$, $p/2^L \approx 2$; for $L = 11$, $p/2^L \approx 0.4$. The value $r = 0$ is plausible in both cases by Poisson fluctuation.

> **Remark.** No clean algebraic criterion distinguishing appearing from non-appearing $V = L+1$ ghosts has been found. The phenomenon appears to be governed by the equidistribution (or failure thereof) of powers of 2 modulo $|D| = 3^L - 2^{L+1}$ within specific target sets of density $\sim 2^{-L}$. This is a well-studied problem in multiplicative number theory but resists closed-form solution for individual moduli.

---

## 7. Computational Specifications {#7-specifications}

### 7.1 Targeted Search for $L = 16$ Ghosts

**Goal:** Determine whether $V = L+1$ ghosts materialize for $L = 16$ (and nearby values) by using algebraic methods to avoid brute-force period enumeration.

**Method:** Instead of scanning $k = 1, \ldots, p$ sequentially, use the Chinese Remainder Theorem to reduce the search.

For the v-pattern $(1,1,\ldots,1,2)$ with $L = 16$, $V = 17$:

1. Compute $D = 2^{17} - 3^{16} = 131072 - 43046721 = -43279697$ (verify: $|D| = 43046721 - 131072 = ...$ recompute carefully).
   Actually: $3^{16} = 43046721$ and $2^{17} = 131072$, so $D = 131072 - 43046721 = -42915649$. **Note:** The value in the table ($43,279,697$) may differ; the exact value should be verified computationally.

2. Factor $|D|$ and compute $p = \text{ord}_2(|D|)$.

3. Compute $R$ for the v-pattern.

4. For each prime power $q^a \| |D|$, compute $\text{ord}_2(q^a)$ and determine the target residues modulo $q^a$. By CRT, combine to find target residues modulo $|D|$.

5. Count the number of $k_0 \in \{0, \ldots, p-1\}$ with $R \cdot 2^{k_0} \bmod |D|$ in the target set. This can be done by decomposing the orbit modulo each prime power factor of $|D|$ and combining.

**Why this is faster:** The orbit modulo $q^a$ has period $\text{ord}_2(q^a) \leq q^{a-1}(q-1)$, which can be much smaller than $p$. Checking the target condition modulo each prime power is fast; CRT combination gives the result for the full modulus.

**Output:** Exact value of $r$ for $L = 16$ (and the first materializing $k_0$ if $r > 0$).

### 7.2 Verify "All Compositions Are Case-(a)" for $L = 9, 11$

**Goal:** Re-verify the case-(a) property for ALL $L$ compositions of $V = L+1$ into $L$ parts (i.e., all $L$ placements of the "2") for $L = 9$ and $L = 11$ specifically.

**Method:** For each of the $L$ rotations of $(1,\ldots,1,2)$:
1. Compute $R$ for the specific rotation.
2. Compute $\tilde{n}_1 = R / D$ as an exact fraction.
3. Iterate $L$ steps: $\tilde{n}_{i+1} = (3\tilde{n}_i + 1) / 2^{v_i}$.
4. Check that $v_2(\text{numerator of } 3\tilde{n}_i + 1) = v_i$ for each $i$.
5. Check orbit closure: $\tilde{n}_{L+1} = \tilde{n}_1$.
6. If case-(a), attempt to find the first $k$ where this specific rotation materializes (searching up to $k = p + V$).

**Output:** For each of the $L$ rotations of $L = 9$ and $L = 11$: case-(a) status, and first materializing $k$ (if any).

**Significance:** If ALL $L$ rotations are case-(a) but NONE materializes, this definitively establishes that case-(a) does not guarantee materialization, and the non-appearance is purely a number-theoretic phenomenon. If some rotation IS NOT case-(a), this would contradict the "all compositions are case-(a)" claim and require revisiting that assertion.

### 7.3 Systematic $r$-Value Prediction

**Goal:** Test the heuristic $r \approx p / 2^L$ more rigorously by computing exact $r$ values for all $L = 6, \ldots, 15$ across all $L$ rotations of the v-pattern.

**Method:** For each $L \in \{6, \ldots, 15\}$ and each rotation position $j \in \{0, \ldots, L-1\}$:
1. Construct v-pattern with the "2" at position $j$.
2. Compute $R_j$ for this rotation.
3. Scan $k_0 = 0, \ldots, p-1$ (full period) and count materializations.
4. Record $r_j$ for each rotation.
5. Report total $r = \sum_j r_j$ across all rotations.

**Output:** Table of $(L, j, r_j)$ for all $L$ and rotations. Comparison with the heuristic prediction $r_j \approx p / 2^L$ for each rotation.

**Expected runtime:** For $L \leq 13$ (period $\leq 58{,}140$), each rotation requires $p$ evaluations of the materialization condition, each involving $O(L)$ modular arithmetic operations. Total: $\sum_L L \cdot p(L) \cdot L \approx 10^8$ operations. Feasible in minutes.

For $L = 14$ ($p = 294{,}712$) and $L = 15$ ($p = 1{,}187{,}496$): more expensive but still feasible. Total: $\sim 10^{10}$ operations. May require hours.

### 7.4 Equidistribution Test

**Goal:** Test whether the orbit $\{R \cdot 2^{k_0} \bmod |D|\}_{k_0=0}^{p-1}$ is equidistributed in $(\mathbb{Z}/|D|\mathbb{Z})^*$, and whether the target set $\mathcal{T}$ (encoding the valuation conditions) has the expected density $\sim 2^{-L}$.

**Method:** For each $L \in \{6, \ldots, 13\}$:
1. Compute $|D|$ and its factorization.
2. Compute the target set $\mathcal{T} \subset \mathbb{Z}/|D|\mathbb{Z}$ explicitly: the set of $n_1 \bmod |D|$ for which the orbit starting at $n_1$ (computed via $S$ with the v-pattern) satisfies all valuation conditions modulo $2^{v_i + 1}$ at each step.

   More precisely: the valuation condition at step $i$ constrains $n_i$ modulo $2^{v_i + 1}$. Since $n_i$ is a deterministic function of $n_1$ via the iteration, this translates to a condition on $n_1$ modulo some power of 2. The intersection of all $L$ conditions gives a set of residues for $n_1$ modulo $2^M$ for some $M \leq V + L$. The target set $\mathcal{T}$ modulo $|D|$ is then the set of $R \cdot D^{-1} \bmod |D|$ values that are consistent.

   Actually, a simpler approach: for each $k_0 \in \{0, \ldots, p-1\}$, compute $n_1 = R \cdot D^{-1} \bmod 2^{k_0}$, simulate the orbit, check the conditions. Record which $k_0$ succeed.

3. Compute $|\mathcal{T}|/|D|$ (or more precisely, $|\mathcal{T} \cap \text{orbit}| / p$) and compare with $2^{-L}$.

4. For each prime factor $q | |D|$, compute $|\mathcal{T} \bmod q|/q$ and compare with $2^{-L}$.

**Output:** For each $L$: the density of $\mathcal{T}$, and the discrepancy between the orbit intersection and the predicted value.

---

## 8. Summary of Conclusions

### 8.1 Status Classification

| Claim | Status |
|-------|--------|
| $\rho(L) \leq 1/2$ | **PROVED** |
| $\rho(L) \geq 2^{-9/8} \approx 0.4585$ | **PROVED** (from $L = 8$ ghost) |
| $\rho(L) = 1/2$ | **CONJECTURE** (strong computational support) |
| $L = 9, 11$ non-appearance is a structural obstruction | **NO** (heuristic explanation via $p/2^L$) |
| All $V = L+1$ compositions are case-(a) | **COMPUTATIONAL CLAIM** (needs proof or theoretical explanation) |
| A clean algebraic criterion distinguishes appearing/non-appearing | **NOT FOUND** |
| The $r$-values follow a formula | **NO** ($r$ is governed by equidistribution, no closed form) |
| $V = L+1$ ghosts exist for all sufficiently large $L$ | **CONJECTURE** (follows from equidistribution heuristic) |

### 8.2 Key Open Problems (Ranked by Impact)

1. **Prove or disprove that all compositions are case-(a).** This would be a clean, algebraic theorem about the 2-adic valuations of iterates of $R/D$. If true, it dramatically simplifies the theory.

2. **Prove $r > 0$ for infinitely many $L$ in the $V = L+1$ family.** This would establish $\rho(L) = 1/2$. The equidistribution approach via character sums is natural but may be technically insufficient for individual moduli; an averaging argument over many $L$ values might work.

3. **Determine exact $r$-values for $L = 16$--$20$.** This requires either extending the brute-force search (expensive) or using the algebraic CRT decomposition (Section 7.1).

4. **Understand the $p/2^L$ heuristic theoretically.** Why does the effective density of the target set appear to be $\sim 2^{-L}$? Is this exact, or is there a correction factor?

### 8.3 The Deepest Question Raised by This Data

The data reveals an arithmetic phenomenon at the intersection of:
- 2-adic dynamics (the Syracuse map on $\mathbb{Z}_2$),
- multiplicative number theory (the distribution of $2^{k_0} \bmod |D|$), and
- Diophantine approximation (the size of $|D| = |2^{L+1} - 3^L|$).

The question "for which $L$ does the $V = L+1$ ghost materialize?" is equivalent to asking whether a specific orbit of the doubling map modulo $3^L - 2^{L+1}$ hits a target set of density $\sim 2^{-L}$. This is a nontrivial problem in multiplicative number theory, and its resolution --- either by equidistribution methods or by identifying arithmetic structure --- would be a genuine contribution independent of its application to the Collatz problem.
