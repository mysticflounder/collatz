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
  residues $j_m = (4^m - 1)/3$.
documentclass: article
fontsize: 11pt
geometry: margin=1in
header-includes: |
  \usepackage{amsmath}
  \usepackage{amssymb}
  \usepackage{amsthm}
  \usepackage{hyperref}
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
positive density (see companion paper). One might hope for polynomial dependence in $x$,
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
including non-polynomiality of Fredholm coefficients. Section 5 gives explicit bounds for
the Collatz case.


# The Transfer Matrix

## Construction

Fix $k \geq 2$, $x$ odd positive, and $y$ odd. Let $N = 2^{k-1}$, and let
$R = \{1, 3, 5, \ldots, 2^k - 1\}$ be the odd residues modulo $2^k$, indexed as
$r_i = 2i + 1$ for $i = 0, \ldots, N-1$.

\setcounter{definition}{0}
\begin{definition}
The \textbf{transfer matrix} $P_k(x,y)$ is the $N \times N$ matrix defined as follows.
For each column index $j$ (corresponding to odd residue $r_j$), compute:
\begin{align}
\mathrm{val}_j &= x \cdot r_j + y, \\
v_j &= v_2(\mathrm{val}_j), \\
t_j &= (\mathrm{val}_j / 2^{v_j}) \bmod 2^k.
\end{align}
Set $P[\mathrm{idx}(t_j), j] = 2^{-v_j}$, where $\mathrm{idx}$ maps an odd residue to
its index. All other entries in column $j$ are zero.
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

**Standard bounds.** Since $v_j \geq 1$ for all columns, $\rho_k(x,y) \leq 1/2$ for
all odd $x$, $y$ (cf.\ Proposition 1 of Lagarias, 1985). The 2-adic valuation over odd
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
distinct values as $x$ ranges over odd positive integers, where $M \leq 2k + O(1)$.
\end{corollary}

\begin{corollary}[Non-polynomiality]
The Fredholm coefficients $c_j(x)$ are not polynomial functions of $x$ for $j \geq 1$.
\end{corollary}

*Proof.* At $k = 3$, $c_1(x) = -\operatorname{tr}(P_3(x,1)) = 0$ for infinitely many
odd $x$ (the values where no odd residue modulo 8 maps to itself). But
$c_1(3) = -0.25 \neq 0$. A polynomial with infinitely many roots is identically zero,
contradicting $c_1(3) \neq 0$. $\square$

\begin{remark}
This result identifies the correct topology for extending spectral data in $x$: the
natural domain is the 2-adic integers $\mathbb{Z}_2$, not the complex plane. The
polynomial interpolation approach (fitting Fredholm coefficients at integer $x$ and
evaluating at complex $x$) is the wrong tool. This connects to Siegel's framework
(2025), which treats Collatz-type maps as iterated function systems on $\mathbb{Z}_2$.
\end{remark}


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

: Explicit modulus bounds for the Collatz case $x = 3$, $y = 1$. The transfer matrix
$P_k(3,1)$ depends on $x$ only through $x \bmod 2^M$.

The worst-case residues $j_m = (4^m - 1)/3$ exhibit a structural pattern: each is the
$m$-fold iterate of the map $j \mapsto 4j + 1$ starting from $j_1 = 1$. These are
precisely the residues where the Syracuse map produces maximum 2-adic cancellation.

\begin{remark}
The growth $M \approx 2k$ means that determining the transfer matrix at resolution $k$
requires knowing approximately $2k$ bits of the multiplier. This is not merely an artifact
of the proof --- the minimality argument shows that $M - 1$ bits genuinely do not suffice.
\end{remark}


# Acknowledgments {-}

The author acknowledges use of Claude (Anthropic) for code development and computational exploration. All results are verified by an automated test suite and reproducible from the open-source repository.

# References {-}

\noindent Kontorovich, A. and Lagarias, J. (2009). Stochastic Models for the $3x+1$ and $5x+1$ Problems. *The Ultimate Challenge: The $3x+1$ Problem*, AMS.

\noindent Lagarias, J. (1985). The $3x+1$ Problem and Its Generalizations. *American Mathematical Monthly* 92, 3--23.

\noindent Matthews, K. (2010). Generalized $3x+1$ Mappings: Markov Chains and Ergodic Theory. In Lagarias (ed.), *The Ultimate Challenge*, AMS.

\noindent Matthews, K. and Watts, A. (1985). A Markov approach to the generalized Syracuse algorithm. *Acta Arithmetica* 45(1), 29--42.

\noindent Siegel, M. (2025). Algebras of $p$-Adic Distributions Induced by Pointwise Products of $F$-Series. arXiv:2507.13358.

\noindent Tao, T. (2022). Almost All Orbits of the Collatz Map Attain Almost Bounded Values. *Forum of Mathematics, Pi* 10, e12.
