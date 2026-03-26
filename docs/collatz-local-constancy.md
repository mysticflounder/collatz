---
title: "2-Adic Local Constancy of Transfer Matrices for Generalized Collatz Maps"
author:
  - "Adam McKenna (adam@mysticflounder.ai, [LinkedIn](https://www.linkedin.com/in/admckenna/))"
date: "March 2026"
abstract: |
  We study the parametric family of Syracuse-type maps $S(n) = (xn + y)/2^{v_2(xn+y)}$
  on odd integers, where $x$ and $y$ are odd parameters. At resolution $k$, the map acts
  on odd residues modulo $2^k$ via a transfer matrix $P_k(x,y)$. We prove that the map
  $x \mapsto P_k(x,y)$ is locally constant in the 2-adic topology, with tight modulus
  $M = k + V$ where $V$ is the maximum 2-adic valuation across columns. This result shows
  that polynomial continuation of spectral data in the multiplier $x$ is impossible ---
  the natural domain is the 2-adic integers, not the complex plane. For the classical
  Collatz case $x = 3$, $y = 1$, we give explicit bounds $M \approx 2k$, with worst-case
  residues $j_m = (4^m - 1)/3$. An analogous result holds for the shift parameter $y$.
  Computation confirms $M \approx 2k$ for all odd $x \in \{3, 5, \ldots, 21\}$.
keywords: "Collatz conjecture, Syracuse map, 2-adic integers, transfer matrix, local constancy, spectral radius, Fredholm determinant"
msc: "37P05 (Primary), 11F85, 11B05 (Secondary)"
documentclass: article
fontsize: 11pt
geometry: margin=1in
header-includes: |
  \usepackage{amsmath}
  \usepackage{amssymb}
  \usepackage{amsthm}
  \usepackage{hyperref}
  \usepackage{url}
  \newtheorem{theorem}{Theorem}
  \newtheorem{proposition}{Proposition}
  \newtheorem{corollary}{Corollary}
  \newtheorem{conjecture}{Conjecture}
  \newtheorem{definition}{Definition}
  \newtheorem*{remark}{Remark}
---

# Introduction

The Collatz conjecture asserts that iterating $n \mapsto n/2$ (if $n$ is even) or
$n \mapsto (3n+1)/2$ (if $n$ is odd) eventually reaches 1 from any positive starting
value. We embed this problem in a parametric family: for odd positive integers $x$ and
$y$, define the Syracuse-type map on odd integers:
$$S(n) = \frac{xn + y}{2^{v_2(xn + y)}},$$
where $v_2(m)$ denotes the 2-adic valuation of $m$. The classical Collatz map corresponds
to $x = 3$, $y = 1$.

At resolution $k \geq 2$, the map $S$ acts on the $N = 2^{k-1}$ odd residue classes
modulo $2^k$, encoded in a transfer matrix $P_k(x,y)$ whose spectral radius $\rho_k(x,y)$
measures the worst-case contraction rate over all modular cycles. A natural question is:
how does $P_k$ depend on the multiplier $x$? This is motivated by the discovery that the
exceptional set $E$ --- levels where additional modular cycles appear --- is infinite with
positive density (McKenna, 2026). One might hope for polynomial dependence in $x$,
enabling analytic continuation techniques. Our main result shows the dependence is
fundamentally different: $P_k$ is a step function that jumps at 2-adic boundaries.

This connects to the framework of Siegel (2025), who treats Collatz-type maps as iterated
function systems on 2-adic integers. Our result places the transfer matrix naturally
within the class of locally constant functions on $\mathbb{Z}_2$ that his framework is
designed to handle.

**Prior work.** Matthews and Watts (1985) studied generalized Collatz mappings.
Kontorovich and Lagarias (2009) compared $3x+1$ and $5x+1$ using growth-rate criteria.
Matthews (2010) constructs row-stochastic transition matrices on residues. Our transfer
matrix differs in that entries are weighted by $2^{-v}$, making the spectral radius
directly the convergence indicator.

**Notation.** Throughout, $x$ denotes an odd positive integer (the multiplier),
$y$ an odd integer (the shift), $k \geq 2$ an integer (the resolution),
$v_2(m)$ the 2-adic valuation of $m$, and $\rho_k(x,y)$ the spectral radius of $P_k(x,y)$.

**Outline.** Section 2 constructs the transfer matrix and recalls standard spectral
properties. Section 3 states and proves the main theorem. Section 4 derives corollaries
including non-polynomiality of Fredholm coefficients and an analogous result for the
shift parameter $y$. Section 5 gives explicit bounds for the Collatz case. Section 6
discusses consequences and open questions.


# The Transfer Matrix

## Construction

Fix $k \geq 2$, $x$ odd positive, and $y$ odd. Let $N = 2^{k-1}$, and let
$R = \{1, 3, 5, \ldots, 2^k - 1\}$ be the odd residues modulo $2^k$, indexed as
$r_i = 2i + 1$ for $i = 0, \ldots, N-1$.

\setcounter{definition}{0}
\begin{definition}
The \textbf{transfer matrix} $P_k(x,y)$ is the $N \times N$ matrix defined as follows.
Columns and rows are indexed by the odd residues $j \in R = \{1, 3, \ldots, 2^k - 1\}$,
with the column-to-index map $\mathrm{idx}(j) = (j-1)/2$. For each column $j \in R$,
compute:
\begin{align}
\mathrm{val}_j &= x \cdot j + y, \\
v_j &= v_2(\mathrm{val}_j), \\
t_j &= (\mathrm{val}_j / 2^{v_j}) \bmod 2^k.
\end{align}
Set $P[t_j, j] = 2^{-v_j}$ (using odd residues as row and column labels). All other
entries in column $j$ are zero.
\end{definition}

The matrix is well-defined: since $x$, $r_j$, and $y$ are all odd,
$\mathrm{val}_j = x \cdot r_j + y$ is even (odd $\times$ odd $+$ odd $=$ even), so
$v_j \geq 1$, and $t_j$ is odd by maximality of $v_j$.

Each column has exactly one nonzero entry, so $P_k$ encodes a function on $R$: the
Syracuse map $S$ reduced modulo $2^k$, with each transition weighted by its contraction
factor $2^{-v_j}$.

## Spectral Radius

Since each column has exactly one nonzero entry, the functional graph of $P_k$
decomposes into cycles and trees rooted at those cycles. The eigenvalues of $P_k$ are
determined by the cycles: each cycle of length $L$ with valuations $v_1, \ldots, v_L$
contributes an eigenvalue
$$\lambda = \left(\prod_{i=1}^L 2^{-v_i}\right)^{1/L} = 2^{-\bar{v}},$$
where $\bar{v} = \frac{1}{L}\sum_{i=1}^L v_i$ is the mean valuation around the cycle.
The spectral radius is therefore
$$\rho_k(x,y) = \max_{\text{cycles}} 2^{-\bar{v}}.$$

**Standard bounds.** Since $v_j \geq 1$ for all columns (as $x$, $r_j$, $y$ are all odd),
$\rho_k(x,y) \leq 1/2$ for all odd $x$, $y$ (cf.\ Lagarias, 1985, Proposition 1, for the
$x = 3$ case; the same argument applies generally). The 2-adic valuation over odd
residues follows the universal geometric distribution $P(v = j) = 1/2^j$ for
$j = 1, \ldots, k-1$ (folklore; see Tao, 2022; Matthews, 2010). The Fredholm zeros
$z_0 = 1/\lambda_i$ all satisfy $|z_0| \geq 2$, trivially from the spectral bound.


# 2-Adic Local Constancy

\setcounter{theorem}{0}
\begin{theorem}[2-Adic Local Constancy]
\label{thm:2adic}
For fixed $k \geq 2$ and $y$ odd, the map $x \mapsto P_k(x,y)$ is locally constant in
the 2-adic topology on the odd positive integers. Explicitly: for each odd positive
integer $x_0$,
$$P_k(x, y) = P_k(x_0, y) \quad \text{for all odd positive } x \text{ with }
x \equiv x_0 \pmod{2^M},$$
where
$$M(k, x_0, y) = k + V(k, x_0, y), \qquad
V(k, x_0, y) = \max\{v_2(x_0 j + y) : j \text{ odd}, \; 1 \leq j < 2^k\}.$$
This bound is tight: no smaller $M$ suffices.
\end{theorem}

*Proof.* We must show that if $x \equiv x_0 \pmod{2^M}$ with $M = k + V$, then
$P_k(x,y) = P_k(x_0,y)$. Since the matrix is determined column by column, it suffices
to show that for each odd $j \in R$, the pair $(v_j, t_j)$ is the same for $x$ and $x_0$.

Fix an odd residue $j \in R$. Let $\mathrm{val} = x_0 j + y$ and
$\mathrm{val}' = xj + y = \mathrm{val} + (x - x_0)j$. Write $v = v_2(\mathrm{val})$,
so $\mathrm{val} = 2^v q$ with $q$ odd. The perturbation is $\delta = (x - x_0)j$.

Since $x \equiv x_0 \pmod{2^M}$ and $j$ is odd:
$$v_2(\delta) = v_2(x - x_0) + v_2(j) = v_2(x - x_0) \geq M.$$

**Step 1 (Valuation preservation).** We have
$\mathrm{val}' = \mathrm{val} + \delta = 2^v q + \delta$. Since
$v_2(\delta) \geq M > v$ (because $M = k + V \geq k + v$ and $k \geq 2$), the
ultrametric identity gives
$$v_2(\mathrm{val}') = v_2(\mathrm{val} + \delta) =
\min(v_2(\mathrm{val}), v_2(\delta)) = v.$$
The identity $v_2(a + b) = \min(v_2(a), v_2(b))$ holds whenever $v_2(a) \neq v_2(b)$.
Therefore $v_j$ is the same for $x_0$ and $x$, and the weight $2^{-v_j}$ is unchanged.

**Step 2 (Target preservation).** The target is
$t = (\mathrm{val}/2^v) \bmod 2^k$. We have:
$$\mathrm{val}'/2^v = \mathrm{val}/2^v + \delta/2^v = q + \delta/2^v.$$
Since $v_2(\delta) \geq M = k + V \geq k + v$, we have $v_2(\delta/2^v) \geq k$, so
$$\delta/2^v \equiv 0 \pmod{2^k},$$
giving $\mathrm{val}'/2^v \equiv \mathrm{val}/2^v \pmod{2^k}$.

Since both $v_j$ and $t_j$ are preserved for every column $j$, the entire matrix is
unchanged. $\square$

**Minimality.** Consider the column $j^*$ achieving $V = v_2(x_0 j^* + y)$, and set
$M' = k + V - 1$. Taking $x = x_0 + 2^{M'}$, the perturbation
$\delta = 2^{M'} j^*$ has $v_2(\delta) = M'$. Since $M' = k + V - 1 > V = v_2(\mathrm{val}_{j^*})$,
the valuation is preserved. But $\delta/2^V$ has $v_2 = k - 1$, so
$\delta/2^V \not\equiv 0 \pmod{2^k}$: the target $t_{j^*}$ changes modulo $2^k$.
Therefore $P_k(x,y) \neq P_k(x_0,y)$. $\square$


# Corollaries

The following concern the Fredholm determinant
$F_k(z;x,y) = \det(I - z P_k(x,y))$.

\setcounter{corollary}{0}
\begin{corollary}
The Fredholm determinant $\det(I - z P_k(x,y))$, viewed as a function of $x$ for
fixed $k$, $y$, $z$, is locally constant on the odd 2-adic integers.
\end{corollary}

\begin{corollary}
The spectral radius $\rho_k(x,y)$ is locally constant in $x$ (2-adic topology).
\end{corollary}

\begin{corollary}[Finiteness]
For fixed $k$ and $y$, the spectral radius $\rho_k(x,y)$ takes at most $2^{M-1}$
distinct values as $x$ ranges over odd positive integers, where $M = M(k, x_0, y)$ is
the modulus of the constancy class containing $x_0$. For $x = 3$, $y = 1$, we have
$M \leq 2k + 2$ (Section 5); computationally, $M \approx 2k$ holds for all odd
$x \leq 21$ (Table 2).
\end{corollary}

\begin{corollary}[Non-polynomiality]
The Fredholm coefficients $c_j(x)$ are not polynomial functions of $x$ for $j \geq 1$.
\end{corollary}

*Proof.* At $k = 3$, $c_1(x) = -\operatorname{tr}(P_3(x,1))$. For $x = 19$, direct
computation gives $c_1(19) = 0$ (no odd residue modulo 8 maps to itself under
$S_{19,1}$). Since there are finitely many constancy classes for $P_3(x,1)$ and
each class is attained by infinitely many odd $x$ (by local constancy), infinitely
many odd $x$ satisfy $c_1(x) = 0$. But $c_1(3) = -0.25 \neq 0$. A polynomial with
infinitely many roots is identically zero, contradicting $c_1(3) \neq 0$. $\square$

\begin{remark}
This result identifies the correct topology for extending spectral data in $x$: the
natural domain is the 2-adic integers $\mathbb{Z}_2$, not the complex plane. The
polynomial interpolation approach (fitting Fredholm coefficients at integer $x$ and
evaluating at complex $x$) is the wrong tool. This connects to Siegel's framework
(2025), which treats Collatz-type maps as iterated function systems on $\mathbb{Z}_2$.
\end{remark}

The proof of Theorem 1 applies verbatim to the shift parameter $y$, giving a companion
result:

\setcounter{proposition}{3}
\begin{proposition}[$y$-Local Constancy]
For fixed $k \geq 2$ and $x$ odd, the map $y \mapsto P_k(x,y)$ is locally constant in
the 2-adic topology on the odd integers. Explicitly, for each odd $y_0$,
$$P_k(x, y) = P_k(x, y_0) \quad \text{for all odd } y \text{ with }
y \equiv y_0 \pmod{2^{M_y}},$$
where $M_y = k + V(k, x, y_0)$, with $V$ as in Theorem 1. This bound is tight.
\end{proposition}

*Proof.* Fix column $j \in R$ (odd). The value is $\mathrm{val} = xj + y_0$, and the
perturbation from replacing $y_0$ by $y$ is $\delta = y - y_0$, independent of $j$.
Since $v_2(\delta) \geq M_y = k + V \geq k + v_j$, the ultrametric identity gives
$v_2(\mathrm{val} + \delta) = v_j$, and $\delta / 2^{v_j}$ has $v_2 \geq k$, so
$(\mathrm{val} + \delta)/2^{v_j} \equiv \mathrm{val}/2^{v_j} \pmod{2^k}$.
Both the weight $2^{-v_j}$ and the target $t_j$ are preserved for every column.
Minimality: take $y = y_0 + 2^{M_y - 1}$; at the column $j^*$ achieving $V$,
$\delta/2^V$ has $v_2 = k - 1$, so $t_{j^*}$ changes modulo $2^k$. $\square$

\setcounter{corollary}{4}
\begin{corollary}[Joint Local Constancy]
The map $(x, y) \mapsto P_k(x, y)$ is locally constant on
$\mathbb{Z}_2^{\times} \times \mathbb{Z}_2^{\times}$ (the 2-adic units, i.e., odd
2-adic integers) with the product 2-adic topology.
\end{corollary}

*Proof.* Perturbations $\delta_x j$ and $\delta_y$ are controlled independently by
Theorem 1 and Proposition 4; their sum satisfies the same ultrametric bound. $\square$


# Explicit Bounds for $x = 3$, $y = 1$

The maximum $V(k, 3, 1) = \max\{v_2(3j + 1) : j \text{ odd}, 1 \leq j < 2^k\}$ is
achieved when $3j + 1$ is a power of 2. Setting $3j + 1 = 2^s$ gives
$j = (2^s - 1)/3$, which is an integer when $s$ is even. Writing $s = 2m$ gives
$j_m = (4^m - 1)/3$, which is always odd (since
$j_m = \sum_{i=0}^{m-1} 4^i \equiv 1 \pmod{2}$).

The sequence of worst-case residues is $j_1 = 1, j_2 = 5, j_3 = 21, j_4 = 85,
j_5 = 341, \ldots$, giving $v_2(3j_m + 1) = 2m$. The largest $j_m < 2^k$ satisfies
$m < (k + \log_2 3)/2$, so $V \approx k$ and $M \approx 2k$.

| $k$ | $V = \max v_2$ | $M = k + V$ | Worst $j$ |
|-----|----------------|-------------|-----------|
| 3   | 4              | 7           | 5         |
| 5   | 6              | 11          | 21        |
| 7   | 8              | 15          | 85        |
| 9   | 10             | 19          | 341       |

: Explicit modulus bounds for the Collatz case $x = 3$, $y = 1$. Any $x \equiv 3 \pmod{2^M}$
(odd) gives $P_k(x,1) = P_k(3,1)$.

The worst-case residues $j_m = (4^m - 1)/3$ exhibit a structural pattern: each is the
$m$-fold iterate of the map $j \mapsto 4j + 1$ starting from $j_1 = 1$. These are
precisely the residues where the Syracuse map produces maximum 2-adic cancellation.

\begin{remark}
The growth $M \approx 2k$ means that determining the transfer matrix at resolution $k$
requires knowing approximately $2k$ bits of the multiplier. This is not merely an artifact
of the proof --- the minimality argument shows that $M - 1$ bits genuinely do not suffice.
\end{remark}


# Discussion

## The Natural Domain Is $\mathbb{Z}_2$, Not $\mathbb{C}$

Theorem 1 shows that $P_k(x,y)$ is a *step function* of $x$ in the 2-adic topology:
constant on each coset of $2^M\mathbb{Z}$ within the odd integers, with step boundaries
at 2-adic neighborhoods. This has a negative and a positive consequence.

**Negative.** Any attempt to extend the spectral data $\rho_k(x,y)$, or the Fredholm
coefficients $c_j(x)$, as analytic functions of $x \in \mathbb{C}$ is impossible.
Corollary 4 gives non-polynomiality directly. More generally, a 2-adically locally
constant non-constant function cannot be the restriction of any holomorphic function
on a connected domain in $\mathbb{C}$: 2-adic constancy classes are dense in every
real interval (since $\{x : x \equiv a \pmod{2^m}\}$ is dense in $\mathbb{R}$ for
any $a$), so a 2-adically locally constant non-constant function is discontinuous
everywhere in the Archimedean topology, and hence cannot be the restriction of any
continuous (let alone holomorphic) function on a real interval.

**Positive.** The 2-adic topology is the *correct* topology for studying parametric
variation in $x$. Any result established for $x_0$ holds automatically for all
$x \equiv x_0 \pmod{2^M}$. Properties proved for $P_k(3,1)$ extend to all
$x \equiv 3 \pmod{2^M}$. This connects naturally to Siegel (2025), who works
exclusively in the 2-adic category; Theorem 1 provides an independent elementary proof
that the 2-adic framework is the correct setting for the multiplier variable.

## The Phase Transition at $x = 4$

The expected log-growth per Syracuse step is $\log_2 x - \mathbb{E}[v] = \log_2 x - 2$
(from $\mathbb{E}[v] = \sum_{j \geq 1} j \cdot 2^{-j} = 2$), changing sign at $x = 4$:
orbits are expected to shrink for odd $x \leq 3$ and grow for odd $x \geq 5$. The
2-adic distance from $x = 3$ to $x = 5$ is $|3 - 5|_2 = 2^{-1}$, the maximum between
consecutive odd integers, and $P_k(3,y) \neq P_k(5,y)$ for all $k \geq 2$. The phase
transition is thus a discrete jump between two locally constant regimes, with no
interpolation through the (undefined) even value $x = 4$.

The contraction-weighted matrices studied here satisfy $\rho_k \leq 1/2$ universally
(Proposition 1 of McKenna, 2026), regardless of growth-weighted behavior. The
spectral-theoretic realization of the phase transition must be understood 2-adically:
the relevant parameter space is not the real line but $\mathbb{Z}_2^{\times}$,
where $x = 3$ and $x = 5$ are adjacent neighbors rather than straddling a transition
point.

## Connection to Ghost Cycles

In McKenna (2026), *ghost cycles* arise at exceptional levels $k \in E$ and are
classified by the denominator $D = 2^V - 3^L$. For general odd $x$, the denominator
becomes $D(x) = 2^V - x^L$. Theorem 1 implies that for fixed $k$ and $y$, the entire
cycle structure of $P_k(x,y)$ --- number of cycles, lengths, valuation patterns,
denominators --- is constant on each 2-adic neighborhood. In particular:

**(a) Ghost types are locally constant in $x$.** If a ghost with parameters
$(L, V, (v_1, \ldots, v_L))$ exists at $(x_0, k)$, it exists for all odd
$x \equiv x_0 \pmod{2^M}$.

**(b) Spectral contributions are combinatorially determined.** Each cycle contributes
$2^{-V/L}$ to the spectral radius; this depends on $(L, V)$ alone, not on $x$.

**(c) Persistence periods are locally constant.** The period $p(x) = \mathrm{ord}_2(|D(x)|)$
at which a ghost type reappears is itself locally constant in $x$. Write
$D(x) - D(x_0) = x_0^L - x^L = (x_0 - x)(x_0^{L-1} + \cdots + x^{L-1})$.
For odd $L$, the second factor is a sum of $L$ terms each $\equiv x_0^{L-1} \pmod 2$
(hence odd), so $v_2(D(x) - D(x_0)) = v_2(x - x_0)$. Taking $v_2(x - x_0) > v_2(D(x_0))$
ensures $v_2(D(x)) = v_2(D(x_0))$ by the ultrametric identity, hence $p(x) = p(x_0)$.
For even $L$, the second factor has an additional factor of 2, but the argument
proceeds similarly with $M' = v_2(D(x_0)) + 1$.

The ghost cycle structure is therefore a 2-adic invariant of $x$: 2-adically close
multipliers share ghost types, exceptional set structure, and persistence periods.

## Implications for Spectral Theory

Since $\rho_k(x,y)$ is locally constant (Corollary 2), any proof that
$\rho_k < 1/2$ at $x_0$ extends immediately to a 2-adic neighborhood of $x_0$. For the
infinite-dimensional transfer operator $\mathcal{L}$ (defined in McKenna, 2026) on
$C(\mathbb{Z}_2^{\times})$, the spectral radius $\rho(\mathcal{L})(x) = \sup_k \rho_k(x,y)$
is lower semicontinuous in
$x$ (supremum of locally constant functions is lower semicontinuous). It need not be
locally constant itself: the constancy balls shrink as $k$ grows (since $M \approx 2k$),
so the limit could vary on arbitrarily fine 2-adic scales.

Local constancy also reduces the parameter space constructively. To determine $\rho_k$
for all odd $x$, it suffices to compute $P_k$ at $O(4^k)$ representative values
(Corollary 3). For $y = 1$ and $k = 3, 4, 5, 6$, direct computation over odd $x \in [1, 2^{2k+2})$
shows that the number of distinct transfer matrices is exactly $2^{2k}$ in all four
cases, attaining the Corollary 3 bound up to a factor of 2.

## Open Questions

**1. Growth rate of $M$ for general $(x,y)$.** For $x = 3$, $y = 1$, Section 5 proves
$M \approx 2k$. The efficient formula $j^* = -y x^{-1} \bmod 2^k$ (the unique maximizer
of $v_2(xj + y)$ over odd $j < 2^k$) enables large-scale computation: for
$x \in \{3, 5, 7, \ldots, 21\}$ and $k = 3, \ldots, 30$, fitting $V(k, x, 1) \approx c(x,1) \cdot k$
gives the values in Table 2. All slopes satisfy $c(x,1) \approx 1.00$ (range
$0.984$--$1.014$, $R^2 > 0.96$), confirming that $M \approx 2k$ is not special to $x = 3$
but holds across odd multipliers. The heuristic: $j^* = -yx^{-1} \bmod 2^k$ is a 2-adic
unit, so generically $v_2(xj^* + y) \approx k$, giving $V \approx k$ and $M \approx 2k$.
Proving this rigorously for all odd $(x,y)$ is open.

| $x$ | $c(x,1)$ | $M \approx$ | $R^2$ |
|-----|----------|-------------|-------|
| 3   | 0.9956   | 1.996$k$    | 0.996 |
| 5   | 1.0027   | 2.003$k$    | 0.988 |
| 7   | 0.9969   | 1.997$k$    | 0.989 |
| 9   | 1.0106   | 2.011$k$    | 0.979 |
| 11  | 0.9949   | 1.995$k$    | 0.982 |
| 13  | 0.9843   | 1.984$k$    | 0.983 |
| 15  | 0.9956   | 1.996$k$    | 0.978 |
| 17  | 1.0140   | 2.014$k$    | 0.964 |
| 19  | 0.9959   | 1.996$k$    | 0.981 |
| 21  | 1.0051   | 2.005$k$    | 0.963 |

: Fitted growth rate $c(x,1)$ from $V(k,x,1) \approx c \cdot k$ for $k = 5, \ldots, 30$
and $y = 1$. All slopes are near 1, confirming $M \approx 2k$ universally.

**2. Density of constancy classes.** Corollary 3 bounds the number of distinct transfer
matrices at resolution $k$ by $O(4^k)$. The exact count as $k \to \infty$, and whether
any hidden symmetry reduces it substantially below this bound, is open.

**3. Local constancy of $\rho(\mathcal{L})$.** Since $M(k) \to \infty$, the
infinite-dimensional spectral radius is only lower semicontinuous. Whether it is locally
constant (or varies on all 2-adic scales) is open, and closely related to whether
$\mathcal{L}$ is compact on $C(\mathbb{Z}_2^{\times})$ (see McKenna, 2026,
Section 7).

**4. Limiting Fredholm determinant.** Each $\det(I - z P_k(x,y))$ is locally constant
in $x$ (Corollary 1). If $F(z; x, y) = \lim_{k \to \infty} \det(I - z P_k(x,y))$
exists (related to compactness of $\mathcal{L}$), then local constancy of $F$ would mean
the full eigenvalue spectrum is a 2-adic invariant of $x$.

**5. Extension to 2-adic multipliers.** Since odd positive integers are dense in
$\mathbb{Z}_2^{\times}$, Theorem 1 and Proposition 4 extend by continuity: for any
$\xi \in \mathbb{Z}_2^{\times}$, define $P_k(\xi, y) = P_k(x_0, y)$ for any odd
integer $x_0 \equiv \xi \pmod{2^M}$; local constancy ensures consistency. This defines
the transfer matrix for non-integer 2-adic multipliers, connecting to the
shifted-coordinate representation $m = n + 1/3$ that makes the Syracuse map
multiplicative (cf.\ Kontorovich and Lagarias, 2009).


# Acknowledgments {-}

The author acknowledges extensive use of Claude (Anthropic) throughout this work, including code development, computational exploration, proof formalization, and manuscript preparation. The research directions, conjectures, and interpretation of results are the author's own. All computational results are verified by an automated test suite and reproducible from the open-source repository at github.com/mysticflounder/collatz.

# References {-}

\noindent Kontorovich, A. and Lagarias, J. (2009). Stochastic Models for the $3x+1$ and $5x+1$ Problems. In Lagarias (ed.), *The Ultimate Challenge: The $3x+1$ Problem*, AMS.

\noindent Lagarias, J. (1985). The $3x+1$ Problem and Its Generalizations. *American Mathematical Monthly* 92, 3--23.

\noindent Matthews, K. (2010). Generalized $3x+1$ Mappings: Markov Chains and Ergodic Theory. In Lagarias (ed.), *The Ultimate Challenge: The $3x+1$ Problem*, AMS.

\noindent Matthews, K. and Watts, A. (1985). A Markov approach to the generalized Syracuse algorithm. *Acta Arithmetica* 45(1), 29--42.

\noindent McKenna, A. (2026). Ghost Cycles of the Syracuse Map. Zenodo. \url{https://zenodo.org/records/18949342}.

\noindent Siegel, M. (2025). Algebras of $p$-Adic Distributions Induced by Pointwise Products of $F$-Series. arXiv:2507.13358.

\noindent Tao, T. (2022). Almost All Orbits of the Collatz Map Attain Almost Bounded Values. *Forum of Mathematics, Pi* 10, e12.
