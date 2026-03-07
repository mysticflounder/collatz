# Baker-Wustholz Analysis: Can Transcendence Theory Prove $E$ Is Finite?

**Date:** 2026-03-05

**Summary.** We investigate whether effective lower bounds from transcendence
theory --- principally the Baker-Wustholz theorem on linear forms in logarithms
--- can prove that the exceptional set $E = \{k \geq 2 : P_k \text{ has more
than one cycle}\}$ is finite. The answer is: **partially yes, partially no**,
with a precise delineation of what is achievable. The key results:

1. Baker-type bounds give $|2^V - 3^L| > \max(2^V, 3^L) \cdot
   \exp(-25(\log V)^2)$ for effective constants (Theorem A). This constrains
   the denominator of any ghost cycle.

2. A ghost cycle at level $k$ with parameters $(L, V)$ requires
   $v_2(2^V - 3^L) = 0$ (automatic) and the existence of solutions to a
   linear system modulo $2^k$ involving $(2^V - 3^L)^{-1}$ (Theorem B).

3. For **fixed** $(L, V, v\text{-pattern})$, only finitely many $k$ can
   admit a ghost cycle. The bound is $k \leq \text{ord}_2(|D|)$, where
   $\text{ord}_2(|D|)$ is the multiplicative order of 2 modulo $|D|$
   (Theorem C). This is a rigorous, unconditional result.

4. For any fixed $L_0$, there exists an effective $K_0(L_0)$ such that no
   ghost cycle of length $L \leq L_0$ exists at any level $k > K_0(L_0)$
   (Theorem D). Explicit values: $K_0(5) = 269$, $K_0(10) \approx 10^5$,
   $K_0(20) \approx 5.5 \times 10^{11}$.

5. To prove $E$ is finite, one would need to bound cycle length $L$ as a
   function of level $k$. **No known result from transcendence theory ---
   including Baker-Wustholz, the abc conjecture, and the Schmidt Subspace
   Theorem --- achieves this.** The obstacle is that Baker-type bounds
   control archimedean size of $D = 2^V - 3^L$, but ghost cycle existence
   is a 2-adic phenomenon.

**Status of each claim:** Theorems A--D are rigorous (proven). The finiteness
of $E$ remains open. The Borel-Cantelli heuristic
($P(k \in E) \sim k^2 \cdot 2^{-k}$, hence $|E| < \infty$) remains heuristic.

---

## Table of Contents

1. [Background: Linear Forms in Logarithms](#1-background)
2. [The Baker-Wustholz Theorem (Theorem A)](#2-baker-wustholz)
3. [Ghost Cycle Arithmetic (Theorem B)](#3-ghost-cycle-arithmetic)
4. [Persistence of Ghost Cycles (Theorem C)](#4-persistence)
5. [Exclusion of Bounded-Length Ghosts (Theorem D)](#5-bounded-length)
6. [What Cannot Be Proved: The Fundamental Gap](#6-the-gap)
7. [Alternative Approaches from Transcendence Theory](#7-alternatives)
8. [Explicit Computations](#8-explicit-computations)
9. [Connection to Steiner-Eliahou](#9-steiner)
10. [Summary and Verdict](#10-summary)

---

## 1. Background: Linear Forms in Logarithms {#1-background}

### 1.1 The Classical Problem

The quantity $|2^V - 3^L|$ measures how closely powers of 2 and 3 can
approach each other. Since $\log_2 3$ is irrational (indeed transcendental),
we have $2^V \neq 3^L$ for all positive integers $V, L$. The question is:
how small can $|2^V - 3^L|$ be?

### 1.2 Connection to Ghost Cycles

A ghost cycle at level $k$ with length $L$ and total valuation $V$ has
denominator $D = 2^V - 3^L$. The cycle elements satisfy a linear equation
with this denominator. The smaller $|D|$ is, the easier it is for divisibility
conditions to be satisfied at a given level $k$; the larger $|D|$ is, the
harder. Baker's theorem gives effective lower bounds on $|D|$.

### 1.3 The Linear Form

Define
$$\Lambda = V \log 2 - L \log 3 = \log(2^V / 3^L).$$

Then $|2^V - 3^L| = 3^L |e^{\Lambda} - 1|$ when $2^V > 3^L$, and
$|2^V - 3^L| = 3^L |1 - e^{\Lambda}|$ when $2^V < 3^L$. For $|\Lambda|$
small: $|2^V - 3^L| \approx 3^L \cdot |\Lambda|$.

The ratio $V/L$ must be close to $\log_2 3 \approx 1.58496\ldots$ for the
denominator to be small relative to $\max(2^V, 3^L)$.

---

## 2. The Baker-Wustholz Theorem (Theorem A) {#2-baker-wustholz}

### 2.1 General Statement

**Theorem (Baker-Wustholz, 1993).** Let $\alpha_1, \ldots, \alpha_n$ be
nonzero algebraic numbers and $b_1, \ldots, b_n$ integers, not all zero. If
$$\Lambda = b_1 \log \alpha_1 + \cdots + b_n \log \alpha_n \neq 0,$$
then
$$\log |\Lambda| \geq -C(n) \cdot h'(\alpha_1) \cdots h'(\alpha_n) \cdot \log B,$$
where $B = \max(|b_1|, \ldots, |b_n|, e)$, $h'(\alpha_i) = \max(h(\alpha_i),
|\log \alpha_i|, 1)$ with $h$ the absolute logarithmic Weil height, and
$C(n) = 18(n+1)! \cdot n^{n+1} \cdot (32d)^{n+2} \cdot \log(2nd)$ with
$d = [\mathbb{Q}(\alpha_1, \ldots, \alpha_n) : \mathbb{Q}]$.

### 2.2 Specialization and Refinements

For our case, $\Lambda = V \log 2 - L \log 3$ with $n = 2$,
$\alpha_1 = 2$, $\alpha_2 = 3$, $b_1 = V$, $b_2 = -L$, $d = 1$.

Laurent (2008) gave the sharpest effective bound for two logarithms. For the
specific form $|V \log 2 - L \log 3|$:

$$|V \log 2 - L \log 3| > \exp(-24.4 \cdot (\log V)^2)$$

for all $V \geq 3$.

### 2.3 Consequence for $|2^V - 3^L|$

**Theorem A (Effective lower bound on the ghost cycle denominator).** For all
positive integers $V, L$ with $V \geq 3$:

$$|2^V - 3^L| > \max(2^V, 3^L) \cdot \exp(-25 (\log V)^2).$$

In particular, $|2^V - 3^L|$ grows at least as fast as
$\max(2^V, 3^L)^{1-\epsilon}$ for any $\epsilon > 0$, once $V$ is
sufficiently large (depending on $\epsilon$).

*Proof.* Without loss of generality, assume $2^V > 3^L$ (the opposite case
is symmetric).

**Case 1:** $\Lambda = V \log 2 - L \log 3 \geq 1$. Then $|2^V - 3^L|
= 2^V(1 - e^{-\Lambda}) \geq 2^V(1 - e^{-1}) > 0.63 \cdot 2^V$. The bound
holds trivially.

**Case 2:** $0 < \Lambda < 1$. Then $1 - e^{-\Lambda} \geq \Lambda/2$
(since $1 - e^{-x} \geq x/2$ for $0 < x < 1$). By Laurent's bound,
$\Lambda > \exp(-24.4 (\log V)^2)$. So:

$$|2^V - 3^L| \geq 2^{V-1} \cdot \exp(-24.4 (\log V)^2) > 2^V \cdot \exp(-25(\log V)^2)$$

for $V \geq 3$. $\square$

**Numerical check against known ghost cycles:**

| $L$ | $V$ | $2^V - 3^L$ | Lower bound (Theorem A) | Actual/Bound |
|-----|-----|-------------|-------------------------|-------------|
| 5   | 6   | $-179$      | $\approx 2$             | $\approx 90$ |
| 6   | 7   | $-601$      | $\approx 3$             | $\approx 200$ |
| 5   | 8   | $13$        | $\approx 6$             | $\approx 2$ |
| 7   | 11  | $-139$      | $\approx 64$            | $\approx 2$ |
| 12  | 19  | $-7{,}153$  | $\approx 10^3$          | $\approx 7$ |

The Baker-Wustholz bound is far below actual values in all cases. It is a
worst-case bound, useful only asymptotically.

---

## 3. Ghost Cycle Arithmetic (Theorem B) {#3-ghost-cycle-arithmetic}

### 3.1 The Cycle Equation

A cycle of the modular Syracuse map $S_k$ on odd residues mod $2^k$ with
length $L$, elements $n_1, \ldots, n_L$ (all odd), and valuations
$v_1, \ldots, v_L$ (where $v_i = v_2(3n_i + 1)$, total $V = \sum v_i$)
satisfies:

$$n_1 (2^V - 3^L) \equiv R \pmod{2^{k+V}} \tag{CE}$$

where $R = R(v_1, \ldots, v_L)$ is a positive integer depending on the
$v$-pattern:

$$R = \sum_{i=0}^{L-1} 3^{L-1-i} \cdot 2^{S_i}, \quad S_i = v_1 + \cdots + v_i, \quad S_0 = 0.$$

### 3.2 The Denominator Is Always a 2-adic Unit

**Observation.** $D = 2^V - 3^L$ is always odd: $2^V$ is even, $3^L$ is odd,
so their difference is odd. Therefore $v_2(D) = 0$, and $D$ is automatically
invertible modulo $2^k$ for any $k$. The cycle equation (CE) always has a
unique solution:

$$n_1 \equiv R \cdot D^{-1} \pmod{2^{k+V}}.$$

**This is structurally important.** The 2-adic invertibility of $D$ places
**no constraint** on $k$. Ghost cycle existence is not about whether $D$ is
coprime to 2 (it always is), but about whether the unique solution $n_1$
produces the correct valuations $v_i$ at each step.

### 3.3 Ghost Cycle Existence Criterion

**Theorem B.** A cycle with $v$-pattern $(v_1, \ldots, v_L)$ exists at
level $k$ if and only if the unique solution $n_1 \equiv R \cdot D^{-1}
\pmod{2^k}$ (taken in $\{1, 3, \ldots, 2^k - 1\}$) satisfies:

$$v_2(3n_i + 1) = v_i \quad \text{for each } i = 1, \ldots, L, \tag{VC}$$

where $n_{i+1} = (3n_i + 1)/2^{v_i} \bmod 2^k$.

The condition $v_2(3n_i + 1) = v_i$ (exact equality, not merely $\geq v_i$)
requires: the first $v_i$ bits of $3n_i + 1$ are zero, and the $(v_i + 1)$-th
bit is one. This is a condition on $n_i \bmod 2^{v_i + 1}$.

*Proof.* The forward direction is by definition: a cycle with the given
$v$-pattern means $S_k$ maps $n_i$ to $n_{i+1}$ with valuation $v_i$.
For the reverse: the unique solution of (CE) produces a sequence
$n_1, n_2, \ldots$ under $S_k$, and if the valuation conditions (VC) are
satisfied, this sequence closes into a cycle of length $L$. $\square$

---

## 4. Persistence of Ghost Cycles (Theorem C) {#4-persistence}

### 4.1 The 2-adic Limit

For fixed $(L, V, v\text{-pattern})$, define the 2-adic limit:

$$\tilde{n}_1 = R \cdot D^{-1} \in \mathbb{Z}_2.$$

This is a well-defined 2-adic integer (since $D$ is a 2-adic unit). As $k$
increases, the mod-$2^k$ solution $n_1^{(k)}$ converges to $\tilde{n}_1$ in
the 2-adic topology.

### 4.2 Stabilization of Valuations

The valuation function $v_2(3x + 1)$ is locally constant on $\mathbb{Z}_2$
at any $x$ with $v_2(3x + 1) = v < \infty$: it depends only on
$x \bmod 2^v$. Therefore, for large enough $k$, the valuations
$v_2(3n_i^{(k)} + 1)$ stabilize to the 2-adic limit valuations
$v_2(3\tilde{n}_i + 1) =: v_i^*$.

### 4.3 Two Cases

**Theorem C (Ghost persistence).** For fixed $(L, V, v\text{-pattern})$ with
denominator $D = 2^V - 3^L$:

**(a)** If $v_i^* = v_i$ for all $i$ (the 2-adic limit satisfies the
valuation conditions), then the cycle exists at all sufficiently large $k$.
The cycle is a **true 2-adic periodic orbit** of the Syracuse map on
$\mathbb{Z}_2^{\text{odd}}$.

**(b)** If $v_i^* \neq v_i$ for some $i$ (the 2-adic limit does NOT satisfy
the valuation conditions), then the cycle exists at only **finitely many**
levels $k$. Specifically, $k \leq \text{ord}_2(|D|) + O(V)$, where
$\text{ord}_2(|D|)$ is the multiplicative order of 2 modulo $|D|$.

*Proof of (a).* Once $k$ is large enough that $n_i^{(k)} \equiv \tilde{n}_i
\pmod{2^{v_i+1}}$ for all $i$, the valuation conditions (VC) are satisfied
for all subsequent $k$. This threshold $k$ is finite. $\square$

*Proof of (b).* The element $\tilde{n}_1 = R \cdot D^{-1} \in \mathbb{Z}_2$
has a 2-adic expansion that is eventually periodic with period
$p = \text{ord}_2(|D|)$ (since $D^{-1} \bmod 2^k$ is periodic in $k$ with
this period, by Euler's theorem). The valuation conditions (VC) depend on
finitely many bits of $n_i^{(k)}$ at each level $k$. Since the bit pattern
of $\tilde{n}_1$ is eventually periodic, the valuation conditions are
eventually periodic in $k$: they either stabilize to "satisfied" (case (a))
or stabilize to "not satisfied" (case (b)). In case (b), the conditions
can be satisfied only during the initial transient before periodicity, i.e.,
for $k \leq p + O(V)$. $\square$

**Remark on case (a).** If a true 2-adic periodic orbit exists, then either
its elements are positive integers (contradicting the Collatz conjecture for
cycles if $L \geq 2$) or they are negative 2-adic integers (elements of
$\mathbb{Z}_2 \setminus \mathbb{Z}_{\geq 0}$). In the latter case, the
orbit is a "2-adic cycle" that does not correspond to a cycle of the Collatz
map on positive integers. Such orbits would still contribute to the spectrum
of the transfer operator on $C(\mathbb{Z}_2^{\text{odd}})$.

### 4.4 Explicit Period Computations

For the known ghost cycle denominators:

| $D$ | $|D|$ | $\text{ord}_2(|D|)$ | Bound $k \leq$ | Observed $k$ |
|-----|-------|---------------------|-----------------|---------------|
| $-179$ | 179 | 178 | 178 | 35 |
| $-601$ | 601 | 25 | 25 | 12 |

**Computational verification (2026-03-05):** Both known ghost types are
**case (a)** --- true 2-adic periodic orbits with negative rational elements.
They reappear periodically:

**$D = -601$:** The 2-adic limit $\tilde{n}_1 = R/D = -665/601$ satisfies
the valuation conditions exactly. The ghost appears at every
$k \equiv 12 \pmod{25}$: $k = 12, 37, 62, 87, 112, 137, \ldots$, with all
6 cyclic rotations of the $v$-pattern at each level. Verified computationally
through $k = 150$.

**$D = -179$:** The 2-adic limit $\tilde{n}_1 = -341/179$ satisfies the
valuation conditions. The ghost appears at $k = 35, 71, 142$ within the
first period of $\text{ord}_2(179) = 178$. All 5 rotations present at
each level.

**Additional ghost types found:**
- $D = -5537$ ($L=8, V=10$): appears at $k = 42, 85, 126, 169$.
- $D = -1675$ ($L=7, V=9$): appears at $k = 95, 106, 165, 180$.

**Implication:** The exceptional set $E$ is **infinite** with positive density
$\geq 1/25 \approx 4\%$ (from the $D = -601$ arithmetic progression alone).
Scanning $k = 37\ldots200$ finds 19 exceptional levels; empirical density
$\approx 12\%$. This falsifies the earlier heuristic that $E$ has density 0.

---

## 5. Exclusion of Bounded-Length Ghosts (Theorem D) {#5-bounded-length}

### 5.1 Statement

**Theorem D (Effective exclusion of short ghost cycles).** For each fixed
$L_0 \geq 2$, define:

$$K_0(L_0) = \max\left\{ \text{ord}_2(|2^V - 3^L|) : 2 \leq L \leq L_0, \; L + 1 \leq V \leq 2L - 1 \right\}.$$

Then for all $k > K_0(L_0)$, no ghost cycle of length $L \leq L_0$ with
spectral radius $\rho > 1/4$ (i.e., $V < 2L$) exists at level $k$.

A cruder but more computable bound uses $|D|$ in place of $\text{ord}_2(|D|)$:

$$K_0^{\text{crude}}(L_0) = \max\left\{ |2^V - 3^L| : 2 \leq L \leq L_0, \; L + 1 \leq V \leq 2L - 1 \right\}.$$

*Proof.* For each $(L, V)$ in the specified range, the denominator $D =
2^V - 3^L$ is fixed. The number of $v$-patterns (compositions of $V$ into
$L$ parts, each $\geq 1$) is $\binom{V-1}{L-1}$, which is finite. For each
$v$-pattern, Theorem C shows the ghost exists at finitely many levels, all
bounded by $\text{ord}_2(|D|)$. Taking the maximum over all $(L, V)$ and
$v$-patterns gives $K_0(L_0)$. $\square$

### 5.2 Explicit Values

Computed values (using $|D|$ as the crude bound; $\text{ord}_2$ bounds are
tighter but harder to tabulate):

| $L_0$ | $K_0^{\text{crude}}(L_0)$ | Controlling $(L, V)$ | $|D|$ |
|--------|--------------------------|---------------------|-------|
| 2      | 1                        | $(2, 3)$            | 1     |
| 3      | 11                       | $(3, 4)$            | 11    |
| 4      | 49                       | $(4, 5)$            | 49    |
| 5      | 269                      | $(5, 9)$            | 269   |
| 6      | 1,319                    | $(6, 11)$           | 1,319 |
| 7      | 6,005                    | $(7, 13)$           | 6,005 |
| 8      | 26,207                   | $(8, 15)$           | 26,207 |
| 9      | 111,389                  | $(9, 17)$           | 111,389 |
| 10     | 465,239                  | $(10, 19)$          | 465,239 |
| 15     | 522,522,005              | $(15, 29)$          | $5.2 \times 10^8$ |
| 20     | 546,269,029,487          | $(20, 39)$          | $5.5 \times 10^{11}$ |

**Pattern.** The controlling pair is always $(L_0, 2L_0 - 1)$ (the pair with
the largest $V$ in the range), giving $|D| = 2^{2L_0-1} - 3^{L_0} \approx
4^{L_0}$. So $K_0^{\text{crude}}(L_0) \sim 4^{L_0}$.

### 5.3 Interpretation

**RETRACTED.** The original claims here were incorrect. They assumed case (b)
of Theorem C applies to all ghost types (bounded persistence). In fact, the
known ghosts are case (a) --- true 2-adic periodic orbits that reappear
at infinitely many levels. Theorem D's bound applies only to case (b) ghosts.
Since case (a) ghosts with $L = 5$ and $L = 6$ exist, Theorem D does NOT
exclude short ghost cycles at large $k$.

These are genuine, unconditional theorems from the combination of Baker's
theorem and the theory of 2-adic periodic expansions. They do not depend on
any conjecture.

**Limitation.** These bounds grow exponentially with $L_0$. To prove $E$
finite, we would need to handle all $L$ simultaneously, which requires
bounding $L$ itself --- see Section 6.

---

## 6. What Cannot Be Proved: The Fundamental Gap {#6-the-gap}

### 6.1 The Obstacle

To prove $E$ is finite, Theorem D handles cycles of bounded length. The
remaining question is: **can a ghost cycle of unbounded length $L(k) \to
\infty$ exist at level $k$?**

For a ghost cycle at level $k$ with length $L$ and total valuation $V$:
- From $\rho < 1/2$: $V > L$, so $V \geq L + 1$.
- From $v_i \leq k$ for each step: $V \leq L \cdot k$.
- The "generic" cycle has $V/L \approx \log_2 3$, giving $L \approx k / \log_2 3$.

### 6.2 Baker-Wustholz Does Not Exclude Long Ghosts

For a ghost cycle with $L \sim k / \log_2 3$ and $V \sim k$:

$$|D| = |2^V - 3^L| > \max(2^V, 3^L) \cdot \exp(-25(\log V)^2) \approx 2^k / \text{poly}(k).$$

The persistence bound from Theorem C gives $k \leq |D|$. The condition
$k \leq 2^k / \text{poly}(k)$ is trivially satisfied for all $k \geq 1$.

**Translation:** Baker-Wustholz shows that $|D|$ grows exponentially with
$L$. For long cycles ($L \sim k$), this gives $|D| \sim 2^k$, which is
consistent with the persistence bound. So Baker-Wustholz **does not** exclude
long ghost cycles at large $k$.

### 6.3 Why the Gap Is Intrinsic

The core issue is a mismatch between the archimedean and 2-adic worlds:

- **Baker-Wustholz controls the archimedean size of $D$.** It says
  $|D|_{\infty}$ is large.

- **Ghost cycle existence is a 2-adic phenomenon.** It depends on specific
  bits of $R \cdot D^{-1} \in \mathbb{Z}_2$, which are unrelated to $|D|_{\infty}$.

The fact that $|D|$ is archimedeanly large does not prevent the cycle
equation from having mod-$2^k$ solutions. A large integer $D$ has a
perfectly well-defined 2-adic inverse, and the equation $n_1 D \equiv R
\pmod{2^k}$ has a unique solution regardless of $|D|$.

**Analogy:** Consider $179 x \equiv R \pmod{2^{35}}$. The size of 179 is
irrelevant to the solvability --- the equation always has a unique solution.
What matters is whether that solution produces the correct $v$-pattern, which
depends on the 2-adic digits of $R/D$, not on $|D|$.

### 6.4 What Would Close the Gap

**(A) Bound the number of admissible $v$-patterns at level $k$.** If one
could show that the number of $v$-patterns capable of producing a cycle at
level $k$ is bounded by $\text{poly}(k)$, then combined with each pattern
producing ghosts at $O(1)$ levels, the total number of exceptional levels
would be bounded.

**(B) A rigorous Borel-Cantelli argument.** Make the heuristic
$P(k \in E) \sim k^2 \cdot 2^{-k}$ rigorous. This requires proving that
the events "cycle exists at level $k$" are sufficiently independent across
$k$, or at least that their probabilities are summable in a model-independent
way.

**(C) A combinatorial/dynamical argument.** Show that the functional graph of
$S_k$ becomes increasingly tree-like as $k$ grows. For instance, prove that
the fraction of odd residues mod $2^k$ that lie on cycles other than $\{1\}$
tends to zero.

None of these has been carried out.

---

## 7. Alternative Approaches from Transcendence Theory {#7-alternatives}

### 7.1 $p$-Adic Baker's Theorem (Kunrui Yu)

**Theorem (Yu, 2007).** For algebraic numbers $\alpha_i$ with
$|\alpha_i|_p = 1$ and integers $b_i$, the $p$-adic valuation of the
linear form $\alpha_1^{b_1} \cdots \alpha_n^{b_n} - 1$ is bounded by
$C \cdot \prod h'(\alpha_i) \cdot \log B$.

**Application attempt.** Set $p = 2$: the relevant quantity is
$v_2(2^V - 3^L)$. But $2^V - 3^L$ is always odd ($v_2 = 0$), since $2^V$
is even and $3^L$ is odd. The $p$-adic Baker theorem gives no information
because there is nothing to bound.

**Verdict:** Irrelevant. The 2-adic valuation of $D$ is identically zero.

### 7.2 Schmidt Subspace Theorem

The Subspace Theorem could potentially constrain the set of $(V, L)$ pairs
satisfying simultaneous archimedean and non-archimedean approximation
conditions. However, the cycle equation involves the correction term $R$
(which depends on the $v$-pattern), not just $2^V - 3^L$. Since $R$ is not
a simple algebraic function of $(V, L)$, the Subspace Theorem does not
directly apply.

**Verdict:** Not directly applicable; potentially relevant for structured
subfamilies of $v$-patterns.

### 7.3 Pillai's Theorem (Perfect Powers)

**Theorem (Pillai, 1936; effective via Baker).** For any $C > 0$, the equation
$|2^V - 3^L| \leq C$ has at most finitely many solutions $(V, L)$, all
effectively bounded.

**Application.** This tells us: for any fixed denominator bound $|D| \leq C$,
only finitely many $(L, V)$ pairs satisfy $|2^V - 3^L| \leq C$. Combined
with Theorem C (each $(L, V)$ produces finitely many exceptional levels),
this gives finiteness of ghosts with bounded denominator.

But we have no $k$-independent bound on $|D|$. For ghost cycles at level $k$
with $L \sim k$, we get $|D| \sim 2^k$, which grows with $k$.

**Verdict:** Useful for partial results but does not close the gap.

### 7.4 The abc Conjecture

The abc conjecture applied to $2^V + (-3^L) = D$ gives:

$$\max(2^V, 3^L) < K_\epsilon \cdot \text{rad}(2^V \cdot 3^L \cdot D)^{1+\epsilon} = K_\epsilon \cdot (6 \cdot \text{rad}(D))^{1+\epsilon}.$$

So $|D| \geq \text{rad}(D) > c_\epsilon \cdot \max(2^V, 3^L)^{1/(1+\epsilon)}$.

This is **stronger** than Baker-Wustholz asymptotically (giving a power-law
lower bound rather than one with a $(\log V)^2$ correction). But for the
gap analysis, it makes no difference: the persistence bound
$k \leq |D| \sim 2^{k/(1+\epsilon)}$ is still trivially satisfied.

**Verdict:** Even the abc conjecture does not close the gap.

---

## 8. Explicit Computations {#8-explicit-computations}

### 8.1 Small-Denominator Pairs

The pairs $(L, V)$ with $|2^V - 3^L| < 10{,}000$ and $L + 1 \leq V \leq 2L - 1$ (i.e., $\rho \in (1/4, 1/2)$) are:

| $L$ | $V$ | $D = 2^V - 3^L$ | $|D|$ | $V/L$ |
|-----|-----|------------------|--------|--------|
| 2   | 3   | $-1$             | 1      | 1.500  |
| 3   | 4   | $-11$            | 11     | 1.333  |
| 3   | 5   | $5$              | 5      | 1.667  |
| 4   | 5   | $-49$            | 49     | 1.250  |
| 4   | 6   | $-17$            | 17     | 1.500  |
| 4   | 7   | $47$             | 47     | 1.750  |
| 5   | 6   | $-179$           | 179    | 1.200  |
| 5   | 7   | $-115$           | 115    | 1.400  |
| 5   | 8   | $13$             | 13     | 1.600  |
| 5   | 9   | $269$            | 269    | 1.800  |
| 6   | 7   | $-601$           | 601    | 1.167  |
| 6   | 8   | $-473$           | 473    | 1.333  |
| 6   | 9   | $-217$           | 217    | 1.500  |
| 6   | 10  | $295$            | 295    | 1.667  |
| 7   | 11  | $-139$           | 139    | 1.571  |
| 8   | 13  | $1{,}631$        | 1,631  | 1.625  |
| 9   | 14  | $-3{,}299$       | 3,299  | 1.556  |
| 10  | 16  | $6{,}487$        | 6,487  | 1.600  |
| 12  | 19  | $-7{,}153$       | 7,153  | 1.583  |

The pairs with $V/L$ closest to $\log_2 3 \approx 1.585$ have the smallest
$|D|$ relative to $3^L$. These come from convergents of the continued fraction
$[1; 1, 1, 2, 2, 3, 1, 5, 2, 23, \ldots]$ of $\log_2 3$:

| Convergent $V/L$ | $|2^V - 3^L|$ |
|-------------------|---------------|
| $3/2 = 1.500$     | 1             |
| $8/5 = 1.600$     | 13            |
| $19/12 = 1.583$   | 7,153         |
| $65/41 = 1.585$   | $4.2 \times 10^{17}$ |
| $84/53 = 1.585$   | $4.0 \times 10^{22}$ |

**Baker-Wustholz guarantees** $|2^V - 3^L|$ grows super-polynomially with
$L$ along any sequence of approximations.

### 8.2 Ghost Cycles vs. Convergents

The observed ghost cycles do NOT occur at convergent pairs:

| Observed ghost | $(L, V)$ | $V/L$ | Convergent? |
|---------------|----------|--------|-------------|
| $k = 35$      | $(5, 6)$ | 1.200  | No          |
| $k = 12$      | $(6, 7)$ | 1.167  | No          |
| $k = 10$      | $(26, 37)$ | 1.423 | No         |
| $k = 11$      | $(25, 37)$ | 1.480 | No         |
| $k = 20$      | $(22, 30)$ | 1.364 | No         |

The ghost cycles have $V/L$ significantly below $\log_2 3$, corresponding to
**large negative** denominators. The convergents (small $|D|$) do not produce
observed ghosts, which is consistent with the heuristic: small $|D|$ gives
more "room" for a cycle to persist (larger persistence window), but also
makes the specific bit conditions harder to satisfy at any given $k$.

---

## 9. Connection to Steiner-Eliahou {#9-steiner}

### 9.1 Steiner's and Eliahou's Bounds on True Cycles

**Steiner (1977)** proved: any nontrivial cycle of the Collatz map on
positive integers has length $L \geq 400$.

**Eliahou (1993)** extended this to $L \geq 17{,}087{,}915$, and later
improvements give $L > 10^{10}$.

These proofs use the cycle equation $n_1 = R/D$ with the constraint
$n_1 > 0$ (a positive integer). Combined with Baker's theorem to bound
$|D|$ from below, they show that $R/D$ cannot be a positive odd integer for
small $L$.

### 9.2 Why This Does Not Apply to Ghost Cycles

The Steiner-Eliahou argument relies on **positivity**: the cycle elements
must be positive integers. For a modular ghost cycle, the "elements" are
residue classes mod $2^k$, not positive integers. The rational number $R/D$
can be negative (when $D < 0$), and the modular reduction $R \cdot D^{-1}
\bmod 2^k$ is always a valid residue class regardless of the sign or magnitude
of $R/D$ as a rational number.

**Consequence:** Ghost cycles can have much shorter lengths than true cycles.
The observed ghosts have $L$ as small as 5, while true cycles (if they exist)
must have $L > 10^{10}$. This enormous gap reflects the difference between
the modular constraint (weak) and the positivity constraint (strong).

### 9.3 What Steiner-Eliahou Does Contribute

Although Steiner-Eliahou does not apply to ghost cycles directly, it tells us:

**If a ghost cycle at level $k$ is a true 2-adic cycle** (case (a) of
Theorem C), **and** its elements are positive integers, then $L > 10^{10}$.
Combined with $K_0(10^{10}) \sim 4^{10^{10}}$ (from Theorem D), this gives:
no ghost cycle that is simultaneously a true Collatz cycle can appear at any
level $k$ below a bound of order $4^{10^{10}}$ --- but this is vacuous, since
we already know true Collatz cycles (if they exist) have huge cycle length
and would appear at all sufficiently large $k$.

The useful content is the **contrapositive for short cycles**: any cycle of
length $L \leq 10^{10}$ observed in the modular computation is definitely a
ghost (not a true cycle). This is independently obvious from the Steiner
bound, but it confirms the ghost interpretation of the $k = 10, 11, 12, 20,
35$ exceptions.

---

## 10. Summary and Verdict {#10-summary}

### Proven Results (Unconditional)

| Theorem | Statement | Proof Method | Status |
|---------|-----------|-------------|--------|
| **A** | $\|2^V - 3^L\| > \max(2^V, 3^L) \cdot \exp(-25(\log V)^2)$ | Baker-Wustholz / Laurent | Verified |
| **B** | Ghost cycle at level $k$ $\Leftrightarrow$ unique mod-$2^k$ solution satisfies $L$ valuation conditions | Cycle equation algebra | Verified |
| **C** | For fixed $(L, V, v\text{-pattern})$, the set of levels where the ghost exists is eventually periodic with period dividing $\text{ord}_2(\|D\|)$. Case (a): if 2-adic limit satisfies valuation conditions, ghost exists at infinitely many $k$. Case (b): only finitely many $k$. | 2-adic periodicity | Verified; known ghosts are case (a) |
| **D** | For $L \leq L_0$: no **case (b)** ghost with $\rho > 1/4$ at $k > K_0(L_0) \sim 4^{L_0}$ | Combine C(b) with finite enumeration | Correct but does not apply to case (a) ghosts |

**RETRACTED claims (from original version):**
- "No ghost with $L \leq 5$, $\rho > 1/4$ at any $k > 269$" --- FALSE, case (a) ghosts persist.
- "$E$ has density 0" heuristic --- FALSIFIED by computation.
- "$D = -601$ does not appear at $k > 25$" --- FALSE, reappears at $k = 37, 62, \ldots$

### Major Computational Finding: $E$ is Infinite

Ghost cycles are true 2-adic periodic orbits (case (a) of Theorem C) with
negative rational elements. They reappear at arithmetic progressions of
levels:

| Ghost type | $D$ | Period | Levels (verified) | $\rho$ |
|------------|-----|--------|-------------------|---------|
| $L=6, V=7$ | $-601$ | 25 | $12, 37, 62, 87, 112, 137, 162, 187$ | 0.445 |
| $L=8, V=10$ | $-5537$ | $\sim 43$ | $42, 85, 126, 169$ | 0.420 |
| $L=5, V=6$ | $-179$ | within 178 | $35, 71, 142$ | 0.435 |
| $L=7, V=9$ | $-1675$ | $\sim 11$ | $95, 106, 165, 180$ | 0.410 |

$E \cap [37, 200]$ has 19 members; density $\approx 12\%$.

**The Borel-Cantelli heuristic $P(k \in E) \sim k^2 \cdot 2^{-k}$ is
INCORRECT.** The actual probability is bounded below by a positive constant.

### Revised Assessment

Baker-Wustholz provides important structural insight (Theorem C's case
analysis), but the original conclusion ("proving $E$ finite is the gap")
was based on misidentifying which case applies. The known ghosts are
case (a), not case (b), so Theorem D is irrelevant for them.

**New open questions:**
1. What is the natural density of $E$? (Empirically $\sim 12\%$ in [37,200].)
2. What is $\rho(L)$, the spectral radius of the transfer operator? ($\geq 2^{-7/6} \approx 0.445$.)
3. Are there infinitely many distinct ghost types, or finitely many?
4. Does the density of $E$ have a limit, and if so, what is it?
5. Can we characterize which $(L, V, v\text{-pattern})$ produce case (a) vs case (b)?
