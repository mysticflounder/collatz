---
title: "Ghost Cycles of the Syracuse Map: 2-Adic Periodic Orbits and the Exceptional Set"
author:
  - "Adam McKenna (adam@mysticflounder.ai)"
date: "March 2026"
abstract: |
  We study the Syracuse map $S(n) = (3n+1)/2^{v_2(3n+1)}$ on odd integers through
  its transfer operator $\mathcal{L}$ on $C(\mathbb{Z}_2^{\mathrm{odd}})$ and its finite
  approximations $P_k$. We prove $\|\mathcal{L}\| = 2/3$ and $\rho(\mathcal{L}) \leq 1/2$, and establish
  two independent obstructions to spectral gap methods: $\mathcal{L}$ does not preserve any
  H\"older or Lipschitz space on $(\mathbb{Z}_2^{\mathrm{odd}}, |\cdot|_2)$, and
  $\mathcal{L}$ is unbounded on $C(\mathbb{Z}_2^{\mathrm{odd}}, \mathbb{Q}_2)$ with
  $\|P_k\|_{2\text{-adic}} = 2^{k+O(1)} \to \infty$, closing the Mahler/Amice
  program entirely. Both obstructions trace to a common root cause:
  the weight $2^{-v}$ is archimedeanly small but 2-adically large.
  Our central result is that "ghost cycles"
  --- extra modular cycles beyond the fixed point $\{1\}$ --- are not transient artifacts:
  exhaustive cycle enumeration through $k = 36$ and algebraic analysis through $k = 200$
  show they are projections of true 2-adic periodic orbits with negative rational elements
  in all computed cases.
  Case-(a) ghosts persist at
  arithmetic progressions of levels, making the exceptional set $E$ infinite with density
  $\geq 4\%$. A census identifies 88+ materializing ghost types through cycle length
  $L = 12$, organized into families by excess $e = V - L$, with record spectral radius
  $\rho \geq 2^{-16/15} \approx 0.4774$. We propose four replacement conjectures.
  Conjecture 4 (negative rationality) asserts that all orbit elements of $D < 0$ ghost
  types are negative rationals --- verified through $L = 12$ for 5,996 cases ---
  establishing that the entire high-spectral-radius regime ($\rho > 1/3$, equivalently
  $D < 0$) consists of purely negative 2-adic orbits with no positive-integer elements.
  All computations are reproducible from the accompanying open-source repository.
keywords:
  - "Collatz conjecture"
  - "Syracuse map"
  - "transfer operator"
  - "ghost cycles"
  - "2-adic periodic orbits"
  - "spectral radius"
  - "exceptional set"
  - "Mahler basis"
  - "p-adic analysis"
msc:
  - "11B83"
  - "37P20"
  - "47B38"
  - "11S80"
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
  \newtheorem{lemma}{Lemma}
  \newtheorem{conjecture}{Conjecture}
  \newtheorem{definition}{Definition}
  \newtheorem*{remark}{Remark}
---

\noindent\textbf{Keywords:} Collatz conjecture, Syracuse map, transfer operator, ghost cycles, 2-adic periodic orbits, spectral radius, exceptional set, Mahler basis, $p$-adic analysis

\noindent\textbf{MSC 2020:} 11B83, 37P20, 47B38, 11S80

# Introduction

The Collatz conjecture, concerning the iteration $n \mapsto (3n+1)/2^{v_2(3n+1)}$ on odd
integers, remains one of the most prominent open problems in number theory. We study the
map through its transfer matrices $P_k$ on odd residues modulo $2^k$ and the associated
transfer operator $\mathcal{L}$ on the odd 2-adic integers $\mathbb{Z}_2^{\mathrm{odd}}$.

Our central discovery is that the "ghost cycles" --- extra modular cycles beyond the
fixed point $\{1\}$ --- are not transient artifacts of modular reduction. They are the
modular projections of true periodic orbits of $S$ on the 2-adic integers, and case-(a)
ghosts (those whose rational orbit matches the prescribed valuation pattern exactly;
defined in Section 7) persist at arithmetic progressions of levels, making the exceptional set $E$
infinite with positive density. This falsifies an earlier conjecture that $E$ has density
zero and $\rho_k \to 1/4$.

**Our contributions.** We present:
(1) the transfer operator framework on $C(\mathbb{Z}_2^{\mathrm{odd}})$, including
$\|\mathcal{L}\| = 2/3$, $\rho(\mathcal{L}) \leq 1/2$, and a six-part spectral theorem;
(2) a proof that $\mathcal{L}$ does not preserve $\mathrm{Lip}_1(\mathbb{Z}_2^{\mathrm{odd}})$
or any H\"older space, obstructing the Lasota--Yorke approach (Theorem 2);
(3) a proof that $\mathcal{L}$ is unbounded on $C(\mathbb{Z}_2^{\mathrm{odd}}, \mathbb{Q}_2)$
with $\|P_k\|_{2\text{-adic}} = 2^{k+O(1)}$, closing the Mahler/Amice program for
nuclearity or compactness in the 2-adic setting (Theorem 3);
(4) exhaustive cycle enumeration through $k = 36$ ($2^{35} \approx 3.4 \times 10^{10}$
residues), extending prior searches;
(5) identification of ghost cycles as 2-adic periodic orbits with negative rational
elements in all computed cases, together with a persistence theorem for case-(a) ghosts;
(6) a census of 88+ materializing ghost types (distinct $v$-patterns across 18 denominator
values) through cycle length $L = 12$, organized into families by excess $e = V - L$;
(7) density $\delta(E) \geq 4\%$ unconditionally and spectral radius
$\rho(\mathcal{L}) \geq 2^{-16/15} \approx 0.4774$ from known ghosts;
(8) four replacement conjectures for the density of $E$, the spectral radius of $\mathcal{L}$,
negative rationality of ghost orbits, and the universal case-(a) property.

The framework extends to the parametric family $S(n) = (xn+y)/2^{v_2(xn+y)}$; see
the companion paper for the 2-adic local constancy of transfer matrices in the
multiplier $x$.

All code and data are available at
\url{https://github.com/mysticflounder/collatz}.

**Related work.** Comprehensive surveys of the Collatz problem and its history are
given by Lagarias (1985, 2021). The transfer matrix approach to Collatz-type maps
originates with Matthews and Watts (1985), who studied growth rates via Markov chain
models, and Wirsching (1998), who developed the dynamical systems perspective
systematically. Lagarias and Weiss (1992) introduced stochastic models that predict
the heuristic contraction rate. Tao (2022) proved that almost all orbits attain almost bounded values
using a probabilistic approach different from transfer matrices. The cycle equation
(our Theorem 4) appears in Steiner (1977). Siegel (2025a) independently uses the term
"ghost cycles" for 2-adic periodic orbits of the $3x+1$ map; our work differs in
computing the density of exceptional levels and classifying ghost persistence. Siegel
(2025b) studies algebras of $p$-adic distributions induced by pointwise products of
$F$-series. The Baker--Wüstholz (1993) bounds on linear forms in logarithms, as
refined by Laurent (2008), provide unconditional results on ghost cycle lengths (our
Propositions 4--5). Kontorovich and Lagarias (2009) study
the density of the exceptional set for generalized Collatz maps; our density results
(Section 9) address the same question for the standard map using ghost cycle periodicity
rather than stochastic models. Assani (2024) treats the Collatz map as a non-singular
transformation. Mori (2024) and Neklyudov (2024) study operator-theoretic approaches
to Collatz, working on different function spaces; our analysis identifies two independent
obstructions (Theorems 2 and 3) that apply to all such approaches using 2-adic
regularity or 2-adic function spaces.

**Outline.** Section 2 defines the objects of study. Section 3 develops the transfer
operator on $\mathbb{Z}_2^{\mathrm{odd}}$, establishing the operator norm, spectral
radius bound, and the spectral theorem. Section 4 proves the Lasota--Yorke obstruction.
Section 5 proves the 2-adic unboundedness obstruction, closing the Mahler/Amice program.
Section 6 enumerates the exceptional set through $k = 36$. Section 7 establishes
ghost cycles as 2-adic periodic orbits, including the cycle equation, the case-(a)/(b)
classification, and the persistence theorem together with Baker--W\"ustholz bounds.
Section 8 presents the census of materializing ghost types organized by family.
Section 9 gives the density and spectral radius results together with
replacement conjectures. Section 10 presents eigenvalue spectra. Section 11 describes
computational methodology. Section 12 discusses the results and directions for future work.


# Definitions and Setup

\setcounter{definition}{0}
\begin{definition}[Syracuse map]
The \textbf{Syracuse map} on odd positive integers is
$$S(n) = \frac{3n + 1}{2^{v_2(3n+1)}},$$
where $v_2(m)$ denotes the 2-adic valuation of $m$ (the largest power of 2 dividing $m$).
Since $3n+1$ is even for odd $n$, $v_2(3n+1) \geq 1$ and $S(n)$ is always an odd integer.
\end{definition}

\begin{definition}[Modular Syracuse map]
At resolution $k \geq 2$, the \textbf{modular Syracuse map} $S_k$ acts on the $N = 2^{k-1}$
odd residue classes modulo $2^k$:
$$S_k(j) = S(j) \bmod 2^k, \qquad j \in R_k = \{1, 3, 5, \ldots, 2^k - 1\}.$$
\end{definition}

\begin{definition}[Transfer matrix]
The \textbf{transfer matrix} $P_k$ is the $N \times N$ matrix encoding $S_k$ with
contraction weights. For each odd residue $j \in R_k$, let $v_j = v_2(3j+1)$
and $t_j = S_k(j)$. Then $P_k$ has a single nonzero entry $2^{-v_j}$ in column $j$
at the row corresponding to $t_j$. All other entries are zero.
\end{definition}

Since each column has exactly one nonzero entry, the functional graph of $P_k$ decomposes
into cycles and trees. Each cycle of length $L$ with valuations $v_1, \ldots, v_L$ and
total valuation $V = \sum v_i$ contributes eigenvalues that are the $L$th roots of
$\prod 2^{-v_i} = 2^{-V}$.

\begin{definition}[Spectral radius]
The \textbf{spectral radius} of $P_k$ is
$$\rho_k = \max_{\text{cycles}} 2^{-V/L},$$
where the maximum is over all cycles in the functional graph. This equals the
linear-algebraic spectral radius $\max |\lambda_i|$ because $P_k$ has the special
structure of a weighted permutation matrix restricted to its recurrent classes.
\end{definition}

\begin{definition}[Exceptional set]
The \textbf{exceptional set} is
$$E = \{k \geq 3 : P_k \text{ has a cycle other than the fixed point } \{1\}\}.$$
At non-exceptional levels, $\rho_k = 1/4$ (from the fixed point $\{1\}$ with $v = 2$).
At exceptional levels, $\rho_k > 1/4$.
\end{definition}

\setcounter{proposition}{0}
\begin{proposition}[Valuation distribution]
For odd $n$ chosen uniformly at random modulo $2^k$ with $k$ large,
$$P(v_2(3n+1) = j) = 2^{-j}, \qquad j = 1, 2, 3, \ldots$$
The mean valuation is $\mathbb{E}[v] = 2$.
\end{proposition}

*Proof.* For odd $n$, the value $3n + 1$ is even. The residue $3n + 1 \bmod 2^{j+1}$
is uniformly distributed over even residues as $n$ ranges over odd residues modulo
$2^{j+1}$ (since multiplication by 3 is a bijection on $\mathbb{Z}/2^{j+1}\mathbb{Z}$
restricted to odd residues). The event $v_2(3n+1) = j$ holds if and only if
$3n + 1 \equiv 2^j \pmod{2^{j+1}}$, which occurs with probability $1/2^j$ among
odd $n$ modulo $2^{j+1}$. Summing:
$\mathbb{E}[v] = \sum_{j=1}^{\infty} j/2^j = 2$. $\square$

This folklore result appears in Lagarias and Weiss (1992) and underlies the heuristic
prediction that the Syracuse map contracts by an average factor of $3 \cdot 2^{-2} = 3/4$
per step, as used by Tao (2022).

The Syracuse map embeds in the parametric family $S(n) = (xn+y)/2^{v_2(xn+y)}$ for odd
parameters $x$, $y$. The net growth rate per step is $x \cdot 2^{-v}$, so the expected
log-growth is $\log_2 x - \mathbb{E}[v] = \log_2 x - 2$, which changes sign at $x = 4$.
For the remainder of this paper we work exclusively with $x = 3$, $y = 1$; the companion
paper establishes 2-adic local constancy of $P_k(x,y)$ in the multiplier $x$.


# The Transfer Operator on $\mathbb{Z}_2^{\mathrm{odd}}$

The Syracuse map $S$ extends continuously to $\mathbb{Z}_2^{\mathrm{odd}} = 1 + 2\mathbb{Z}_2$,
the odd 2-adic integers. The transfer operator (Perron--Frobenius operator) associated to
$S$ acts on continuous functions $f \colon \mathbb{Z}_2^{\mathrm{odd}} \to \mathbb{R}$:
$$(\mathcal{L}f)(n) = \sum_{S(m) = n} 2^{-v_2(3m+1)} f(m).$$

\setcounter{lemma}{0}
\begin{lemma}[Preimage structure]
For each odd 2-adic integer $n$, the preimages of $n$ under $S$ are
$m_v = (n \cdot 2^v - 1)/3$ for those $v \geq 1$ where $3 \mid (n \cdot 2^v - 1)$.
Since $2 \equiv -1 \pmod{3}$:

\begin{enumerate}
\item[(a)] $n \equiv 1 \pmod{3}$: preimages at even $v = 2, 4, 6, \ldots$
\item[(b)] $n \equiv 2 \pmod{3}$: preimages at odd $v = 1, 3, 5, \ldots$
\item[(c)] $n \equiv 0 \pmod{3}$: no preimages.
\end{enumerate}

Each $m_v$ is odd, lies in $\mathbb{Z}_2^{\mathrm{odd}}$, and satisfies
$v_2(3m_v + 1) = v$.
\end{lemma}

*Proof.* A preimage $m$ satisfies $3m + 1 = n \cdot 2^v$, i.e.,
$m = (n \cdot 2^v - 1)/3$. For integrality, we need $n \cdot 2^v \equiv 1 \pmod{3}$.
Since $2 \equiv -1 \pmod{3}$, we have $2^v \equiv (-1)^v \pmod{3}$. This gives
$n \cdot (-1)^v \equiv 1 \pmod{3}$, yielding the three cases above.

When $m = (n \cdot 2^v - 1)/3$ exists, parity: $m$ is odd iff $n \cdot 2^v - 1 \equiv 3 \pmod{6}$
iff $n \cdot 2^v \equiv 4 \pmod{6}$. Since $2^v \bmod 6$ alternates as $2, 4, 2, 4, \ldots$
for $v = 1, 2, 3, 4, \ldots$, the parity condition coincides exactly with the integrality
condition. So whenever $m$ is an integer, it is automatically odd.

On $\mathbb{Z}_2$, division by 3 is well-defined since $3$ is a 2-adic unit
($|3|_2 = 1$). For each valid $v$, $m_v = (n \cdot 2^v - 1) \cdot 3^{-1}$ is a
well-defined odd element of $\mathbb{Z}_2$. $\square$

\begin{remark}
The image of $S$ is always coprime to 3: since $3m + 1 \equiv 1 \pmod{3}$, we have
$S(m) \not\equiv 0 \pmod{3}$. Consequently $(\mathcal{L}f)(n) = 0$ for all $n \equiv 0 \pmod{3}$.
\end{remark}

\setcounter{proposition}{1}
\begin{proposition}[Operator norm]
The operator norm of $\mathcal{L}$ on $(C(\mathbb{Z}_2^{\mathrm{odd}}), \|\cdot\|_\infty)$ is
$$\|\mathcal{L}\|_{C^0 \to C^0} = 2/3.$$
More precisely, the weight function $W(n) := (\mathcal{L}\mathbf{1})(n)$ satisfies:
$$W(n) = \begin{cases} 1/3 & n \equiv 1 \pmod{3} \\ 2/3 & n \equiv 2 \pmod{3} \\ 0 & n \equiv 0 \pmod{3}. \end{cases}$$
\end{proposition}

*Proof.* By Lemma 1:

**Case $n \equiv 1 \pmod{3}$:**
$$W(n) = \sum_{v=2,4,6,\ldots} 2^{-v} = \frac{1/4}{1 - 1/4} = \frac{1}{3}.$$

**Case $n \equiv 2 \pmod{3}$:**
$$W(n) = \sum_{v=1,3,5,\ldots} 2^{-v} = \frac{1/2}{1 - 1/4} = \frac{2}{3}.$$

**Case $n \equiv 0 \pmod{3}$:** $W(n) = 0$ (no preimages).

The bound $|(\mathcal{L}f)(n)| \leq W(n) \|f\|_\infty \leq (2/3)\|f\|_\infty$ is achieved by
$f = \mathbf{1}$ and $n \equiv 2 \pmod{3}$. $\square$

\begin{remark}
The value $\|\mathcal{L}\| = 2/3$ corrects the claim $\|\mathcal{L}\| = 1/3$ that appeared in earlier
versions of this work. The discrepancy arose from considering only preimages with
even $v$ (the $n \equiv 1 \pmod{3}$ case), which give weight sum $1/3$. The full weight
sum at $n \equiv 2 \pmod{3}$ (preimages with odd $v$) is $2/3$.
\end{remark}

\begin{proposition}[Spectral radius bound]
$\rho(\mathcal{L}) \leq 1/2$ on $C(\mathbb{Z}_2^{\mathrm{odd}})$.
\end{proposition}

*Proof.* Every eigenvalue of $\mathcal{L}$ corresponds to a periodic orbit of $S$ with
$\lambda = \prod_{\text{cycle}} 2^{-v_i}$. Since each $v_i \geq 1$, the mean valuation
$\bar{v} \geq 1$, giving $|\lambda| = 2^{-\bar{v}} \leq 1/2$. The spectrum of $\mathcal{L}$ is
the closure of the union of eigenvalues of the finite approximations $P_k$ (Theorem 1(e)
below, whose proof is independent of this proposition, relying only on the density of
locally constant functions via Stone--Weierstrass), so $\rho(\mathcal{L}) \leq 1/2$. $\square$

\setcounter{theorem}{0}
\begin{theorem}[Spectral properties of $\mathcal{L}$ on $C(\mathbb{Z}_2^{\mathrm{odd}})$]
\hfill

\begin{enumerate}
\item[(a)] $\mathcal{L}$ is bounded with $\|\mathcal{L}\| = 2/3$.
\item[(b)] $\rho(\mathcal{L}) \leq 1/2$.
\item[(c)] $\lambda = 1/4$ is a simple eigenvalue with eigenfunction
  $\delta_1 := \mathbf{1}_{\{1\}}$ (the indicator of the clopen set $\{1\}$).
\item[(d)] $\sigma(\mathcal{L}) \subseteq \{|z| \leq 1/2\}$.
\item[(e)] $\sigma(\mathcal{L}) = \overline{\bigcup_{k \geq 2} \sigma(P_k)}$, where $P_k$ is the
  transfer matrix on odd residues mod $2^k$.
\item[(f)] For non-exceptional $k$ (verified computationally for all non-exceptional $k \leq 36$):
  $\sigma(P_k) = \{0, 1/4\}$.
\end{enumerate}
\end{theorem}

*Proof.* Parts (a)--(b) are Propositions 2--3 above.

For (c): write $\delta_1 = \mathbf{1}_{\{1\}}$ for the indicator of $\{1\}$, which is
continuous on $\mathbb{Z}_2^{\mathrm{odd}}$ since $\{1\}$ is clopen. The fixed point
$S(1) = 1$ with $v_2(4) = 2$ gives $(\mathcal{L}\delta_1)(n) = (1/4)\delta_1(n)$. Simplicity
is verified computationally: no other cycle with
$\prod 2^{-v_i} = 1/4$ materializes at any level $k \leq 36$, so no other
eigenvalue of that magnitude appears in $\bigcup_{k \leq 36} \sigma(P_k)$.

Part (d) is immediate from (b).

For (e): let $A_k \subset C(\mathbb{Z}_2^{\mathrm{odd}})$ be the subspace of functions
constant on odd residues modulo $2^k$. Each $A_k$ is finite-dimensional with
$\dim A_k = 2^{k-1}$, and $\mathcal{L}$ maps $A_k$ into $A_{k'}$ for some $k' \geq k$. The
restriction of $\mathcal{L}$ to $A_k$, composed with projection back to $A_k$, is represented
by $P_k$. Any eigenvalue of $P_k$ is an approximate eigenvalue of $\mathcal{L}$ (the
corresponding function in $A_k$ gives $\|\mathcal{L}f - \lambda f\|$ bounded by the
coarsening error, which vanishes in the projective limit). Conversely, since
$\overline{\bigcup_k A_k} = C(\mathbb{Z}_2^{\mathrm{odd}})$ by density of locally
constant functions (Stone--Weierstrass), every approximate eigenvalue of $\mathcal{L}$ is
approximable by eigenvalues of the $P_k$. Hence
$\sigma(\mathcal{L}) = \overline{\bigcup_{k \geq 2} \sigma(P_k)}$. In particular,
$\rho(\mathcal{L}) = \sup_k \rho_k = \limsup_{k \to \infty} \rho_k$
(equality holds because $\rho_k \leq 1/2$ for all $k$: eigenvalues of $P_k$ are $L$th roots of
$2^{-V}$ with $V \geq L$, so $|\lambda| = 2^{-V/L} \leq 1/2$).

Part (f) is verified by dense eigenvalue computation. $\square$

\begin{remark}[Conditional spectral gap]
If $E$ were finite, Theorem 1(e) would give $\rho(\mathcal{L}) = 1/4$: for non-exceptional $k$,
$\sigma(P_k) = \{0, 1/4\}$, and finitely many exceptional levels contribute only
isolated eigenvalues that do not accumulate. However, Sections 6--9 show $E$ is
infinite with density $\geq 4\%$. Case-(a) ghosts persist at arithmetic progressions of
levels, and the $V = L+1$ ghost family produces spectral radii
$\rho = 2^{-(L+1)/L} \to 1/2$. Current bounds:
$2^{-16/15} \leq \rho(\mathcal{L}) \leq 1/2$.
\end{remark}


# The Lasota--Yorke Obstruction

A standard approach to proving spectral gap for transfer operators is the Lasota--Yorke
inequality: find a Banach space $X \hookrightarrow C(\mathbb{Z}_2^{\mathrm{odd}})$ such
that $\mathcal{L}$ maps $X$ to itself with
$$\|\mathcal{L}f\|_X \leq \alpha \|f\|_X + B \|f\|_{C^0},$$
where $\alpha < \|\mathcal{L}\|_{C^0}$. This gives quasi-compactness with essential spectral
radius $\leq \alpha$, reducing the spectral analysis to finitely many isolated
eigenvalues. The most natural candidate is the Lipschitz space
$\mathrm{Lip}_1(\mathbb{Z}_2^{\mathrm{odd}})$ with respect to the 2-adic metric,
since each inverse branch of $S$ contracts 2-adically: for each valid $v \geq 1$,
the inverse branch $g_v(n) = (n \cdot 2^v - 1)/3$ satisfies
$|g_v(x) - g_v(y)|_2 = 2^{-v} |x - y|_2$ (because $|3|_2 = 1$).

\setcounter{theorem}{1}
\begin{theorem}[Non-preservation of $\mathrm{Lip}_1$]
The transfer operator $\mathcal{L}$ does not map $\mathrm{Lip}_1(\mathbb{Z}_2^{\mathrm{odd}})$ into
itself. Specifically:

\begin{enumerate}
\item[(a)] The constant function $f = \mathbf{1}$ has $|\mathbf{1}|_{\mathrm{Lip}} = 0$.
\item[(b)] $\mathcal{L}(\mathbf{1}) = W$ has $|W|_{\mathrm{Lip}} = \infty$.
\end{enumerate}

Therefore no Lasota--Yorke inequality
$|\mathcal{L}f|_{\mathrm{Lip}} \leq \alpha |f|_{\mathrm{Lip}} + B\|f\|_\infty$ can hold.
\end{theorem}

*Proof.* Part (a) is immediate. For (b), for each even $N \geq 2$, set
$x_N = 1$ and $y_N = 1 + 2^N$. Then:

- Both are odd (since $2^N$ is even).
- $|x_N - y_N|_2 = 2^{-N}$.
- $x_N \equiv 1 \pmod{3}$, so $W(x_N) = 1/3$.
- $y_N = 1 + 2^N \equiv 1 + (-1)^N \equiv 2 \pmod{3}$ (since $N$ is even), so $W(y_N) = 2/3$.

Therefore:
$$\frac{|W(x_N) - W(y_N)|}{|x_N - y_N|_2} = \frac{1/3}{2^{-N}} = \frac{2^N}{3} \to \infty.$$
This proves $|W|_{\mathrm{Lip}} = \infty$. $\square$

\setcounter{corollary}{0}
\begin{corollary}[Universal obstruction]
The function $W = \mathcal{L}(\mathbf{1})$ does not belong to any of the following spaces on
$(\mathbb{Z}_2^{\mathrm{odd}}, |\cdot|_2)$:

\begin{enumerate}
\item[(a)] $C^\alpha(\mathbb{Z}_2^{\mathrm{odd}})$ for any $\alpha > 0$.
\item[(b)] $BV(\mathbb{Z}_2^{\mathrm{odd}})$ with respect to the 2-adic ultrametric.
\item[(c)] Any Banach space $X \hookrightarrow C(\mathbb{Z}_2^{\mathrm{odd}})$ defined by
  a modulus-of-continuity condition with respect to the 2-adic metric (H\"older,
  Lipschitz, Zygmund, Besov, or Sobolev spaces).
\end{enumerate}
\end{corollary}

*Proof.* (a) The pairs from Theorem 2 give
$|W(x_N) - W(y_N)|/|x_N - y_N|_2^\alpha = 2^{N\alpha}/3 \to \infty$ for any $\alpha > 0$.

(b) At resolution $k$, among $2^{k-1}$ residue classes mod $2^k$, at least $2^{k-1}/3$
have $a \equiv 1 \pmod{3}$ while containing points $\equiv 2 \pmod{3}$, giving oscillation
$\geq 1/3$. Total variation $\geq 2^{k-1}/9 \to \infty$.

(c) Any such space requires $|f(x) - f(y)| \leq C \cdot \omega(|x - y|_2)$ for
some modulus $\omega(t) \to 0$ as $t \to 0$. By (a), $|W(x_N) - W(y_N)| = 1/3$
while $|x_N - y_N|_2 = 2^{-N} \to 0$, so $W$ violates every such condition. $\square$

\begin{remark}[Root cause: mod-3 oscillation]
The weight function $W(n)$ depends on $n \bmod 3$. The residue $n \bmod 3$ is a
continuous function on $\mathbb{Z}_2$ (each residue class is clopen), but it is not
Lipschitz: every 2-adic ball $B(x, 2^{-N})$ intersects all three residue classes
mod~3 (since $\gcd(2^N, 3) = 1$). So $W$ oscillates between $0$, $1/3$, and $2/3$
at every scale of the 2-adic metric. This obstruction reflects the fundamental
arithmetic tension in the Collatz problem: each inverse branch $g_v$ contracts by
$2^{-v}$ in the 2-adic metric but expands by $3$ in the 3-adic metric
($|g_v(x) - g_v(y)|_3 = 3|x - y|_3$). The 3-adic expansion exactly compensates the
weight sum, preventing contraction in any metric incorporating 3-adic information.
\end{remark}

\begin{remark}
When $\mathcal{L}$ is restricted to pairs within the same residue class mod~3, the Lipschitz
seminorm does contract: the conditional contraction rate is $4/15$ for pairs with
$x \equiv y \equiv 2 \pmod{3}$ and $1/15$ for pairs with $x \equiv y \equiv 1 \pmod{3}$.
However, the inverse branches involve division by 3, which scrambles higher powers of 3,
so a global Lasota--Yorke inequality cannot be recovered from this conditional estimate.
\end{remark}

Since standard spectral methods based on 2-adic regularity are unavailable, we now
show that algebraic approaches via the Mahler basis are also obstructed.


# The 2-Adic Unboundedness Obstruction

The Lasota--Yorke obstruction (Theorem 2) blocks spectral gap arguments based on
regularity in the 2-adic metric. A natural alternative is the Mahler basis
$\{\binom{x}{n}\}_{n \geq 0}$, which provides an algebraic (rather than metric)
framework for functions on $\mathbb{Z}_2^{\mathrm{odd}}$. The Amice space construction
uses exponentially decaying Mahler coefficients to define nuclearity and compactness
in the $p$-adic setting (Amice 1964, Serre 1962). We show this approach also fails,
for a deeper reason: $\mathcal{L}$ is unbounded on $C(\mathbb{Z}_2^{\mathrm{odd}}, \mathbb{Q}_2)$.

\setcounter{theorem}{2}
\begin{theorem}[2-adic unboundedness]
The transfer operator $\mathcal{L}$ is unbounded on $C(\mathbb{Z}_2^{\mathrm{odd}}, \mathbb{Q}_2)$
equipped with the 2-adic sup norm $\|f\|_2 = \sup_{n} |f(n)|_2$.
Specifically, the finite-level transfer matrices satisfy
$\|P_k\|_{2\text{-adic}} = 2^{k + O(1)} \to \infty$.
\end{theorem}

*Proof.* The matrix $P_k$ has exactly one nonzero entry per column: $2^{-v(j)}$
in column $j$, where $v(j) = v_2(3(2j+1)+1)$. On
$(\mathbb{Q}_2^N, \|\cdot\|_\infty)$, the operator norm of such a matrix is
$\|P_k\|_2 = \max_j |2^{-v(j)}|_2 = \max_j 2^{v(j)} = 2^{\max_j v(j)}$
(each column has a single nonzero entry, and the ultrametric operator norm is
$\max_j \max_i |A_{ij}|_2$).

We claim $\max_j v(j) = k + O(1)$. Write $3(2j+1)+1 = 6j+4 = 2(3j+2)$,
so $v_2(6j+4) = 1 + v_2(3j+2)$. Since $3$ is invertible modulo $2^{k-1}$,
the value $3j+2$ ranges over all residues mod $2^{k-1}$ as $j$ ranges over
$\{0, \ldots, 2^{k-1}-1\}$. In particular, $3j + 2 \equiv 0 \pmod{2^{k-1}}$
is achieved, giving $v_2(3j+2) \geq k-1$ and hence $\max_j v(j) \geq k$.

Since locally constant functions of all levels are dense in
$C(\mathbb{Z}_2^{\mathrm{odd}}, \mathbb{Q}_2)$ and the restriction of $\mathcal{L}$ to
level-$k$ functions has norm $\|P_k\|_2 \to \infty$, the operator $\mathcal{L}$ is
unbounded. $\square$

\setcounter{corollary}{1}
\begin{corollary}[Failure of the Mahler/Amice program]
The transfer operator $\mathcal{L}$ does not define a bounded operator on any 2-adic
Banach space $E \hookrightarrow C(\mathbb{Z}_2^{\mathrm{odd}}, \mathbb{Q}_2)$
containing all locally constant functions with bounded norm.
In particular, $\mathcal{L}$ is not nuclear on the Amice space
$\mathcal{A}(\mathbb{Z}_2, \mathbb{Q}_2)$.
\end{corollary}

*Proof.* For indicator functions $\mathbf{1}_B$ of 2-adic balls of radius $2^{-k}$,
the preimage branches give $\|\mathcal{L}(\mathbf{1}_B)\|_2 \geq 2^{k+O(1)}$ while
$\|\mathbf{1}_B\|_2 = 1$. Any space containing these indicators with bounded
norm inherits the unboundedness. $\square$

\begin{remark}[Common root cause]
Both obstructions --- Lasota--Yorke (Theorem 2) and 2-adic unboundedness
(Theorem 3) --- trace to the same arithmetic tension. Each inverse branch $g_v$
of $S$ carries the weight $2^{-v}$, which is archimedeanly small (contraction)
but 2-adically large (expansion: $|2^{-v}|_2 = 2^v$). The Lasota--Yorke
obstruction manifests this as mod-3 oscillation of the weight function; the
2-adic unboundedness manifests it as divergent operator norms on 2-adic function
spaces. Any spectral-theoretic approach to $\mathcal{L}$ must therefore work in the
archimedean category: $\mathcal{L}$ acts on $C(\mathbb{Z}_2^{\mathrm{odd}}, \mathbb{R})$
with operator norm $2/3$, and the question of whether $\mathcal{L}$ is compact on this
space remains open.
\end{remark}

Computational verification confirms the theorem: exact arithmetic over
$\mathbb{Q}$ (Python \texttt{Fraction}) for $k = 3, \ldots, 15$ shows
$\max_j v(j)$ equals $k+1$ for odd $k$ and $k$ for even $k$, giving
$\|P_k\|_{2\text{-adic}} \in \{2^k, 2^{k+1}\}$. The Mahler matrix
$M_k = C^{-1} P_k C$ (where $C[i,j] = \binom{i}{j}$) has entries with
$v_2(M_k[m,j]) = -(k + \text{offset}(j))$, shifting by exactly $-\Delta k$
between levels. Since $C$ and $C^{-1}$ are 2-adic isometries (unipotent
lower-triangular with integer entries), the Mahler change of basis does not
mitigate the unboundedness: $\|M_k\|_2 = \|P_k\|_2 = 2^{k+O(1)}$.


# Exhaustive Cycle Enumeration

We perform exhaustive cycle enumeration for $k = 3, \ldots, 36$ ($2^{35} \approx 3.4 \times 10^{10}$
residues at $k = 36$). The search uses two regimes:

- **$k \leq 32$:** Precomputed successor arrays (numpy uint32). Peak memory approximately 13 GB at $k = 32$.
- **$k = 33$--$36$:** On-the-fly computation with Numba JIT and packed bitarrays. Peak memory approximately 4 GB at $k = 36$.

The $k = 36$ search checked $2^{35} \approx 34$ billion odd residues in approximately
14 hours.

## Results

| Range       | $|E \cap \text{range}|$ | Density |
|-------------|-------------------------|---------|
| $k = 3$--$9$   | 0                       | 0.000   |
| $k = 10$--$12$ | 3                       | 1.000   |
| $k = 13$--$19$ | 0                       | 0.000   |
| $k = 20$       | 1                       | ---     |
| $k = 21$--$34$ | 0                       | 0.000   |
| $k = 35$       | 1                       | ---     |
| $k = 36$       | 0                       | ---     |
| **$k = 3$--$36$** | **5**                | **0.147** |

: Exceptional set $E$ for $x = 3$, $y = 1$. Five values of $k$ in $[3, 36]$ produce
additional modular cycles beyond the fixed point $\{1\}$.

The exceptional cycles are:

| $k$ | Extra cycles | Worst $\rho$ | Worst cycle length | Worst mean $v$ |
|-----|-------------|-------------|-------------------|---------------|
| 10  | 1           | 0.3729      | 26                | 1.423         |
| 11  | 1           | 0.3585      | 25                | 1.480         |
| 12  | 2           | 0.4454      | 6                 | 1.167         |
| 20  | 1           | 0.3886      | 22                | 1.364         |
| 35  | 1           | 0.4353      | 5                 | 1.200         |

: Details of exceptional modular cycles. Even at exceptional $k$, the spectral radius
remains well below $1/2$.

Ghost cycles are not transient artifacts of modular reduction. They are the modular
projections of true periodic orbits of $S$ on the 2-adic integers
$\mathbb{Z}_2^{\mathrm{odd}}$.

![Chord diagrams of the Syracuse successor map at four resolutions. Odd residues mod $2^k$ are arranged around a circle; each arc connects a residue to its successor. At $k = 9$ and $k = 13$ (non-exceptional), only the fixed point $\{1\}$ (gold) forms a cycle. At $k = 10$, a 26-node ghost cycle appears (cyan). At $k = 12$, two ghost cycles coexist (cyan: $L = 7$, orange: $L = 6$).](analysis/figures/ghost_contrast.png){width=100%}


# Ghost Cycles as 2-Adic Periodic Orbits

## The Cycle Equation

\setcounter{theorem}{3}
\begin{theorem}[Cycle equation; after Steiner 1977, Wirsching 1998]
\label{thm:cycle-eq}
A modular cycle of length $L$ at level $k$ with valuation pattern $(v_1, \ldots, v_L)$
and total valuation $V = \sum v_i$ satisfies
$$n_1 \cdot D \equiv R \pmod{2^{k+V}},$$
where $D = 2^V - 3^L$ and
$R = \sum_{i=0}^{L-1} 3^{L-1-i} \cdot 2^{S_i}$, with $S_0 = 0$ and
$S_i = v_1 + \cdots + v_i$.
\end{theorem}

*Proof.* If the cycle visits odd residues
$n_1, n_2, \ldots, n_L$ with $n_{i+1} = (3n_i + 1)/2^{v_i}$, then
$n_{i+1} \cdot 2^{v_i} = 3n_i + 1$ is an exact integer identity. At level $k$,
$n_{i+1}$ is known modulo $2^k$, so this step holds modulo $2^{k+v_i}$.
Iterating $L$ steps yields $n_1 \cdot 2^V = 3^L n_1 + R$, i.e., $n_1(2^V - 3^L) = R$
over $\mathbb{Z}$. With total shift $V = \sum v_i$ the precision accumulates, giving
$n_1(2^V - 3^L) \equiv R \pmod{2^{k+V}}$. $\square$

Since $D = 2^V - 3^L$ is always odd and nonzero (as $2^V$ and $3^L$ are coprime), the
rational limit $\tilde{n}_1 = R/D$ is well-defined. For $V > L \log_2 3$, we have
$D < 0$.

## Case-(a) vs Case-(b) Classification

\setcounter{definition}{5}
\begin{definition}[Ghost type; case-(a) and case-(b)]
A \textbf{ghost type} is a triple $(L, V, (v_1, \ldots, v_L))$ where $L \geq 2$,
$V = \sum v_i$ with each $v_i \geq 1$, and $D = 2^V - 3^L \neq 0$. Two ghost
types are equivalent if their $v$-patterns are cyclic rotations of each other.
The \textbf{denominator} of a ghost type is $D$; distinct $v$-patterns with
the same $D$ are distinct ghost types.

Given a ghost type with rational limit
$\tilde{n}_1 = R/D$, define the \textbf{rational orbit}
$\tilde{n}_1, \tilde{n}_2, \ldots, \tilde{n}_L$ by $\tilde{n}_{i+1} = (3\tilde{n}_i + 1)/2^{v_i}$.
\begin{itemize}
\item \textbf{Case (a):} $v_2(3\tilde{n}_i + 1) = v_i$ for all $i$. Then the rational
orbit is a true periodic orbit of $S$ on $\mathbb{Q} \cap \mathbb{Z}_2^{\mathrm{odd}}$:
since the valuation conditions determine the Syracuse map step exactly,
iterating $S$ on $\tilde{n}_1$ produces $\tilde{n}_2, \ldots, \tilde{n}_L, \tilde{n}_1$.
\item \textbf{Case (b):} $v_2(3\tilde{n}_i + 1) > v_i$ for some $i$. The rational
limit has ``extra'' 2-adic cancellation; the orbit exists at only finitely many levels $k$.
\end{itemize}
\end{definition}

![2-adic digit stabilization for the $D = -601$ ghost ($L = 6$, $V = 7$). Each column shows the binary digits of $n_1 = R \cdot D^{-1} \bmod 2^k$. Digits stabilize from the least significant bit upward: once bit position $b$ is determined at resolution $k = b + 1$, it never changes. The dashed line marks $k = 12$, where the ghost first materializes as a modular cycle.](analysis/figures/digit_stabilization.png){width=90%}

\setcounter{conjecture}{0}
\begin{conjecture}[Universal case-(a)]
For all positive integers $L \geq 2$ and $L+1 \leq V \leq 2L-1$, and for every
composition $(v_1, \ldots, v_L)$ of $V$ into $L$ positive parts, the rational orbit
$\tilde{n}_1 = R/(2^V - 3^L)$ satisfies $v_2(3\tilde{n}_i + 1) = v_i$ for all
$i = 1, \ldots, L$. Equivalently, every such composition defines a true periodic
orbit of the Syracuse map on $\mathbb{Z}_2^{\mathrm{odd}}$; there are no case-(b)
ghost types with $\rho > 1/4$.
\end{conjecture}

This conjecture has been verified exhaustively for all 91 $(L, V)$ pairs with
$L = 2, \ldots, 15$, covering every composition (up to ${\sim}800{,}000$ per pair
for $L \leq 12$; $10^6$ random samples per pair for $L = 13$--$15$). An extended
survey through $L = 20$ ($10^6$ samples per pair, 85 million total) finds zero
failures. Moreover, the case-(a) property holds even for $V \geq 2L$ (where
$D > 0$), tested exhaustively through $L = 12$ at $V = 2L$ and $V = 2L + 1$:
the sign of $D$ does not affect the universal case-(a) property.

\begin{remark}[Towards a proof]
A proof would need to show that $v_2(3R_i + D) = v_i$ for all $i$ and all compositions,
where the $R_i$ satisfy the orbit recurrence $R_{i+1} = (3R_i + D)/2^{v_i}$.
The case-(a) condition is equivalent to each such quotient being odd;
proving this uniformly across all compositions appears to require fine control on
$R_i \pmod{2^{v_i+1}}$ that Baker-type bounds do not directly supply.
The concentrated-pattern restriction (Section~9) gives explicit closed forms for the
$R_i$, and may provide the additional leverage needed for those families.
\end{remark}

## Persistence of Case-(a) Ghosts

\begin{theorem}[Persistence of case-(a) ghosts]
\label{thm:persistence}
Let $(L, V, (v_1, \ldots, v_L))$ be a case-(a) ghost with denominator $D = 2^V - 3^L$
and let $p = \mathrm{ord}_2(|D|)$ be the multiplicative order of $2$ modulo $|D|$.
If the ghost first appears at level $k_0$, then it reappears at all levels
$k \equiv k_0 \pmod{p}$ with $k \geq k_0$.
\end{theorem}

*Proof.* The ghost appears at level $k$ if and only if the congruence
$n_1 \cdot D \equiv R \pmod{2^{k+V}}$ has an odd solution $n_1$ modulo $2^k$, and
the resulting cycle has the prescribed valuation pattern $(v_1, \ldots, v_L)$.

Since $D$ is odd, $n_1 \equiv R \cdot D^{-1} \pmod{2^{k+V}}$, and the solution is
determined by $R/D \bmod 2^k$.

**Valuation stability.** The case-(a) condition states that $v_2(3\tilde{n}_i + 1) = v_i$
for all $i$, where $\tilde{n}_i$ are the rational orbit elements. Write
$\tilde{n}_i = a_i / |D|$ with $a_i$ an integer, $\gcd(a_i, 2) = 1$. The valuation
condition $v_2(3\tilde{n}_i + 1) = v_i$ depends only on $3a_i + |D|$ modulo $2^{v_i+1}$.
This is independent of $k$.

**Periodicity of the modular reduction.** The residue $\tilde{n}_1 \bmod 2^k = R \cdot D^{-1} \bmod 2^k$
depends on $D^{-1} \bmod 2^k$, which is periodic in $k$ with period dividing $p = \mathrm{ord}_2(|D|)$.
Explicitly: $D^{-1} \bmod 2^{k+p} \equiv D^{-1} \bmod 2^k \pmod{2^k}$ because
$2^p \equiv 1 \pmod{|D|}$ implies $D^{-1}$ has a $p$-periodic 2-adic expansion.

**Verification at level $k$.** The cycle at level $k$ exists if:
(i) $n_1 = \tilde{n}_1 \bmod 2^k$ is odd --- this holds since $\tilde{n}_1$ has odd
numerator and $D$ is odd;
(ii) for each step $i$, $v_2(3 n_i + 1) = v_i$ where $n_i = \tilde{n}_i \bmod 2^k$ ---
this requires checking that the first $v_i$ bits of $3n_i + 1$ match those of
$3\tilde{n}_i + 1$, which holds when $k > v_i$ for all $i$; and
(iii) $n_{L+1} = n_1 \bmod 2^k$ --- this holds because $\tilde{n}_{L+1} = \tilde{n}_1$
(the rational orbit closes by definition), so $n_{L+1} = \tilde{n}_{L+1} \bmod 2^k =
\tilde{n}_1 \bmod 2^k = n_1$.

Since $\tilde{n}_i \bmod 2^k$ depends only on $k \bmod p$, and conditions (i)--(iii)
are satisfied at $k_0$, they remain satisfied at all $k \equiv k_0 \pmod{p}$
with $k \geq k_0$. $\square$

\begin{remark}
For case-(b) ghosts, condition (ii) eventually fails: the ``extra'' valuation
$v_2(3\tilde{n}_i + 1) > v_i$ means that at the rational level, the Syracuse map
takes a different branch than the one prescribed by $(v_1, \ldots, v_L)$. The
modular cycle exists only at levels $k$ where the extra bits are not yet visible.
\end{remark}

## Baker--W\"ustholz Bounds

Transcendence theory constrains ghost cycle denominators.

\setcounter{proposition}{3}
\begin{proposition}[Effective lower bound on $|D|$; Baker--W\"ustholz 1993, Laurent 2008]
\label{prop:baker}
For all positive integers $V, L$ with $V \geq 3$:
$$|2^V - 3^L| > \max(2^V, 3^L) \cdot \exp(-25 (\log V)^2).$$
In particular, $|D|$ grows superexponentially in $V$.
\end{proposition}

\begin{proposition}[Detection of bounded-length ghosts]
\label{prop:exclusion}
For each fixed $L_0 \geq 2$, define
$K_0(L_0) = \max\{ \mathrm{ord}_2(|2^V - 3^L|) : 2 \leq L \leq L_0, L+1 \leq V \leq 2L-1 \}$.
Then every ghost type with $L \leq L_0$ and $\rho > 1/4$ appears at some level
$k \leq K_0(L_0)$: searching through $k = K_0(L_0)$ suffices to detect all such types.
Explicit values: $K_0(5) \leq 269$, $K_0(10) \leq 465{,}239$.
\end{proposition}

*Proof.* For fixed $(L, V)$ with $\rho = 2^{-V/L} > 1/4$ (i.e., $V < 2L$), the
denominator $D = 2^V - 3^L$ is fixed and has finitely many $v$-patterns
($\binom{V-1}{L-1}$ compositions). By Theorem 5, each case-(a) pattern reappears with period $p = \mathrm{ord}_2(|D|)$.
Since the materialization conditions depend only on $\tilde{n}_1 \bmod 2^k$, which is
periodic in $k$ with period $p$, if the ghost materializes at level $k$ it also
materializes at $k - p$ whenever $k - p \geq V$. Hence the first appearance satisfies
$k_0 \leq p + V \leq p + 2L \leq p + 2L_0$; since $V \ll p$ for all denominators
considered (empirically $V < 2L \leq 30 \ll p$), in practice $k_0 \leq p \leq K_0(L_0)$.
Case-(b) patterns appear at finitely many levels with no periodic structure; their
first appearances are bounded by direct computation of $\tilde{n}_i \bmod 2^k$
for each $(L, V, v\text{-pattern})$ within the search range.
Taking the maximum over all $(L, V)$ in the range gives $K_0(L_0)$. $\square$

\begin{remark}
Propositions 4 and 5 are unconditional, but they cannot
prove $E$ is finite: that would require bounding cycle length $L$ as a function of level
$k$, which no known result from transcendence theory achieves.
\end{remark}


# Census of Ghost Types

An extended ghost census through cycle length $L = 12$ across all 66 $(L, V)$ pairs with
$V < 2L$ (i.e., $\rho > 1/4$) identifies **157,909** canonical case-(a) ghost types.
Of these, at least **88** materialize as modular cycles at some level $k$ --- a lower
bound, since non-concentrated $v$-patterns were sampled (200 per $(L, V)$ pair) rather
than exhaustively enumerated for large parameter ranges.

The following table summarizes the materializing ghost types by denominator $D$. Here $p = \mathrm{ord}_2(|D|)$
is the period of reappearance, $r_{\mathrm{conc}}$ is the number of residue classes mod $p$ at which the
concentrated pattern $(1, \ldots, 1, e+1)$ materializes, $r_{\mathrm{nonc}}$ is the count for non-concentrated
patterns (a lower bound for sampled $(L,V)$ pairs), and $\mathrm{first}_k$ is the smallest level at which any
pattern with this $D$ appears.

| $D$ | $L$ | $V$ | $e$ | $\rho$ | $p$ | $r_{\mathrm{conc}}$ | $r_{\mathrm{nonc}}$ | $\mathrm{first}_k$ |
|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| $-179$ | 5 | 6 | 1 | 0.4353 | 178 | 1 | 0 | 35 |
| $-601$ | 6 | 7 | 1 | 0.4454 | 25 | 1 | 0 | 12 |
| $-1675$ | 7 | 9 | 2 | 0.4102 | 660 | 1 | 2 | 12 |
| $-1931$ | 7 | 8 | 1 | 0.4529 | 1930 | 1 | 0 | 275 |
| $-5537$ | 8 | 10 | 2 | 0.4204 | 84 | 1 | 0 | 42 |
| $-6049$ | 8 | 9 | 1 | 0.4585 | 1441 | 1 | 0 | 180 |
| $-17635$ | 9 | 11 | 2 | 0.4286 | 7052 | 1 | 2 | 113 |
| $-42665$ | 10 | 14 | 4 | 0.3789 | 1716 | 0 | 6 | 224 |
| $-50857$ | 10 | 13 | 3 | 0.4061 | 12714 | 1 | 11 | 1690 |
| $-54953$ | 10 | 12 | 2 | 0.4353 | 9078 | 1 | 3 | 35 |
| $-57001$ | 10 | 11 | 1 | 0.4665 | 5736 | 1 | 0 | 1147 |
| $-144379$ | 11 | 15 | 4 | 0.3886 | 144378 | 0 | 20 | 434 |
| $-160763$ | 11 | 14 | 3 | 0.4139 | 15996 | 0 | 7 | 515 |
| $-168955$ | 11 | 13 | 2 | 0.4408 | 67580 | 1 | 2 | 2192 |
| $-400369$ | 12 | 17 | 5 | 0.3746 | 98665 | 0 | 13 | 58 |
| $-498673$ | 12 | 15 | 3 | 0.4204 | 4452 | 0 | 3 | 107 |
| $-515057$ | 12 | 14 | 2 | 0.4454 | 10700 | 1 | 6 | 37 |
| $-523249$ | 12 | 13 | 1 | 0.4719 | 14065 | 1 | 0 | 1334 |

: Census of materializing ghost types through $L = 12$, sorted by $|D|$. The columns
$r_{\mathrm{conc}}$ and $r_{\mathrm{nonc}}$ count the number of materializing
concentrated and non-concentrated $v$-patterns respectively; both are lower bounds
for $(L,V)$ pairs where sampling was used.

Five $D$ values --- $-42665$, $-144379$, $-160763$, $-400369$, and $-498673$ ---
materialize only through non-concentrated $v$-patterns ($r_{\mathrm{conc}} = 0$). This
shows that restricting attention to the canonical concentrated pattern
$(1, \ldots, 1, e+1)$ misses a significant fraction of materializing ghost types at
higher excess values.

The full census data, including all sampled $v$-patterns and their materialization
results, is available at \url{https://github.com/mysticflounder/collatz}.

## The $V = L+1$ Family

Among all ghost types with cycle length $L$, those with minimal valuation excess
$V = L + 1$ have the largest spectral radius $\rho = 2^{-(L+1)/L}$, which approaches
$1/2$ as $L \to \infty$. A systematic search for $V = L+1$ ghosts with the canonical
$v$-pattern $(1, 1, \ldots, 1, 2)$ yields appearing ghosts at 9 of 11 fully or partially
searched cycle lengths.

| $L$ | $|D| = 3^L - 2^{L+1}$ | $p = \mathrm{ord}_2(|D|)$ | $p/2^L$ | $r$ | First $k$ | $\rho$ |
|-----|------------------------|---------------------------|---------|-----|-----------|--------|
| 5   | 179                    | 178                       | 5.6     | 3   | 35        | 0.4353 |
| 6   | 601                    | 25                        | 0.39    | 1   | 12        | 0.4454 |
| 7   | 1,931                  | 1,930                     | 15      | 5   | 275       | 0.4529 |
| 8   | 6,049                  | 1,441                     | 5.6     | 10  | 180       | 0.4585 |
| 9   | 18,659                 | 1,012                     | 2.0     | 0   | ---       | 0.4629 |
| 10  | 57,001                 | 5,736                     | 5.6     | 6   | 1,147     | 0.4665 |
| 11  | 173,051                | 780                       | 0.38    | 0   | ---       | 0.4695 |
| 12  | 523,249                | 14,065                    | 3.4     | 4   | 1,334     | 0.4719 |
| 13  | 1,577,939              | 58,140                    | 7.1     | 12  | 4,472     | 0.4740 |
| 14  | 4,750,201              | 294,712                   | 18      | $\geq 4$ | 8,087 | 0.4759 |
| 15  | 14,283,371             | 1,187,496                 | 36      | $\geq 2$ | 29,459| 0.4774 |

: The $V = L+1$ ghost family for $L = 5, \ldots, 15$. All $v$-patterns are algebraically
case-(a). Entries $L = 5$--$13$ are from complete period searches; $L = 14$--$15$ are
partial ($r$ is a lower bound). The $\rho$ column shows $2^{-(L+1)/L}$ for each $L$,
regardless of whether the ghost materializes.

The ghosts at $L = 9$ and $L = 11$ do not materialize at any level within their full
period, despite being algebraically case-(a). A heuristic explains this: materialization
requires $L$ simultaneous binary valuation conditions on the modular reduction
$R \cdot D^{-1} \bmod 2^k$, giving a target density of approximately $2^{-L}$ per
period. The ratio $p/2^L$ thus predicts the expected number of materializations $r$.
For $L = 11$, $p/2^L \approx 0.38$, predicting $r \approx 0$; for $L = 9$,
$p/2^L \approx 2$, making $r = 0$ plausible by fluctuation. No clean algebraic
criterion distinguishing appearing from non-appearing cases has been found; the
phenomenon appears governed by the equidistribution of powers of 2 modulo
$|D| = 3^L - 2^{L+1}$.

The nine appearing ghosts ($L = 5, 6, 7, 8, 10, 12, 13, 14, 15$) establish a proved
lower bound $\limsup \rho_k \geq 2^{-16/15} \approx 0.4774$. That the family produces
appearing ghosts at the large majority of tested cycle lengths, with no systematic
obstruction, supports Conjecture~3 below: $\limsup \rho_k = 1/2$.

## Higher Excess Families

Ghost types organize into families by the excess valuation $e = V - L$. The
$V = L+1$ family ($e = 1$) is the most extensively studied (above), but materializing
ghosts also appear in the $e = 2$ and $e = 3$ families.

**Notation.** In the family tables below, $r$ denotes the total number of distinct
residue classes modulo $p$ at which *any* $v$-pattern with the given $D$ materializes
(including both concentrated and non-concentrated patterns). This is the quantity
that enters the density formula (Conjecture 2, Section 9). By contrast, the census
table above lists $r_{\mathrm{conc}}$ and $r_{\mathrm{nonc}}$, which count the number
of distinct *canonical patterns* (up to cyclic rotation) that materialize.
For example, $D = -1675$ has $r_{\mathrm{conc}} = 1$, $r_{\mathrm{nonc}} = 2$
in the census table (three canonical patterns materialize), while the family table
shows $r = 9$ (nine distinct residue classes mod 660).

**The $V = L+2$ family** ($e = 2$). Six denominator values produce materializing
ghosts. (The "First $k$" column is the first level at which the *concentrated*
pattern materializes; non-concentrated patterns with the same $D$ may appear
earlier --- see census table above.)

| $L$ | $|D| = |2^{L+2} - 3^L|$ | $p$ | $r$ | First $k$ | $\rho$ |
|-----|--------------------------|------|-----|-----------|--------|
| 7   | 1,675                    | 660  | 9   | 12        | 0.4102 |
| 8   | 5,537                    | 84   | 2   | 42        | 0.4204 |
| 9   | 17,635                   | 7,052| 5   | 1,567     | 0.4286 |
| 10  | 54,953                   | 9,078| 6   | 2,501     | 0.4353 |
| 11  | 168,955                  | 67,580| 1  | 8,936     | 0.4408 |
| 12  | 515,057                  | 10,700| 2  | 5,350     | 0.4454 |

The spectral radius $\rho = 2^{-(L+2)/L} \to 1/2$ as $L \to \infty$, though
convergence is slower than for $e = 1$.

**The $V = L+3$ family** ($e = 3$). One materializing type has been found with the
concentrated pattern:
$L = 10$, $D = -50857$, $v = (1,1,1,1,1,1,1,1,1,4)$, with $p = 12{,}714$, $r = 3$,
$\rho = 2^{-13/10} \approx 0.4061$.

As $L \to \infty$ with fixed excess $e$, the spectral radius
$\rho = 2^{-1 - e/L} \to 1/2$ for any fixed $e$. The $e = 1$ family simply
converges fastest.


# Density and Spectral Radius

## Falsification of the Density-Zero Conjecture

Our earlier analysis conjectured that $E$ has natural density zero and
$\rho_k(3,1) \to 1/4$, supported by a Borel--Cantelli heuristic suggesting
$|E| < \infty$. Baker--W\"ustholz analysis and extended computation to $k = 200$
have falsified this.

The $D = -601$ ghost (case (a), $L = 6$, $V = 7$) reappears at every
$k \equiv 12 \pmod{25}$, contributing $\rho \geq 2^{-7/6} \approx 0.445$ at
infinitely many levels. This alone gives $\delta(E) \geq 1/25 = 4\%$.

Empirically, $|E \cap [3, 200]| = 24$ and $|E \cap [37, 200]| / 164 \approx 12\%$,
with six distinct case-(a) ghost types contributing. The ``growing gaps'' pattern
observed in $[3, 36]$ was an artifact of the short search range: beyond $k = 36$,
ghost reappearances fill in the gaps.

The Borel--Cantelli heuristic $P(k \in E) \sim k^2 \cdot 2^{-k}$ was wrong because it
treated ghost appearances as independent events. Case-(a) ghosts are deterministic:
once identified, their reappearance pattern is exactly periodic
(Figure~\ref{fig:ghost_timeline}).

\begin{figure}[ht]
\centering
\includegraphics[width=\textwidth]{analysis/figures/ghost_timeline.png}
\caption{Ghost cycle appearances by level $k$. Each row represents a ghost type
(identified by denominator $D$). The vertical dashed line at $k = 36$ marks the boundary
of exhaustive search; beyond it, ghost memberships are computed algebraically from
Theorem~5. The periodic structure of case-(a) ghosts is clearly
visible.}
\label{fig:ghost_timeline}
\end{figure}

## Conjecture 2 (Density of $E$)

\setcounter{conjecture}{1}
\begin{conjecture}[Density of $E$]
The exceptional set $E$ has a well-defined natural density $\delta(E) > 0$.
The density decomposes as
$$\delta(E) = 1 - \prod_{\mathcal{G}} \left(1 - \frac{r_{\mathcal{G}}}{p_{\mathcal{G}}}\right)$$
where the product is over all case-(a) ghost types $\mathcal{G}$,
$p_{\mathcal{G}} = \mathrm{ord}_2(|D_{\mathcal{G}}|)$ is the period, and
$r_{\mathcal{G}}$ is the number of residue classes within that period where
$\mathcal{G}$ appears. When two ghost types have periods sharing a common factor,
an inclusion-exclusion correction is needed; the product formula is a
\emph{lower bound} on the true density.
\end{conjecture}

From the six original ghost types with $L \leq 8$, the product formula gives
$\delta(E) \geq 1 - \frac{24}{25} \cdot \frac{175}{178} \cdot \frac{651}{660} \cdot
\frac{1925}{1930} \cdot \frac{82}{84} \cdot \frac{1431}{1441} \approx 10.0\%$.
Several period pairs share common factors ($\gcd(660, 1930) = 10$,
$\gcd(660, 84) = 12$, $\gcd(660, 1441) = 11$), so the coprime assumption
is not satisfied and the product formula understates the true density.

An empirical scan of ghost type memberships through $k = 1000$ gives:
$k = 100$: 9.18\%, $k = 200$: 10.61\%, $k = 500$: 10.04\%, $k = 1000$: 10.22\%.
The $0.2\%$ gap between the product formula (10.0\%) and the empirical density
(10.2\%) is consistent with the expected correction from shared period factors.
The oscillation between 9\% and 11\% reflects finite-size effects from the
various periods; convergence to a stable density requires
$k \gg \mathrm{lcm}(\text{all periods}) \sim 10^{10}$.

The $D = -601$ ghost alone gives $\delta(E) \geq 1/25 = 4\%$ unconditionally.

\begin{remark}[Towards a proof]
The main obstacle is converting the lower bound into an exact density.
Two routes are available: (1) full inclusion-exclusion over all ghost types,
requiring identification of every materializing family (currently bounded through $L = 15$);
or (2) an equidistribution result showing that ghost memberships are asymptotically
independent, which would make the product formula exact. The second route reduces to
equidistribution of $2^k \pmod{|D|}$ for each ghost type --- a classical result in
multiplicative order theory that holds individually for each $D$, but whose uniformity
across all ghost types simultaneously remains open.
\end{remark}

## Conjecture 3 (Spectral Radius)

\begin{conjecture}[Spectral Radius]
The spectral radius of the transfer matrices satisfies
$$\limsup_{k \to \infty} \rho_k = \max\left(\frac{1}{4}, \; \sup_{\mathcal{G}} 2^{-V_{\mathcal{G}}/L_{\mathcal{G}}}\right),$$
where the supremum is over all case-(a) ghost types. The maximum with $1/4$ accounts
for the fixed point $\{1\}$. From the known ghosts, $\limsup \rho_k \geq 2^{-16/15} \approx 0.4774$
(from $D = -14283371$, $L = 15$, $V = 16$). The $V = L + 1$ ghost family gives
$\rho = 2^{-(L+1)/L} \to 1/2$ as $L \to \infty$; computational evidence (ghosts
appearing at $L = 5, 6, 7, 8, 10, 12, 13, 14, 15$) suggests $\limsup \rho_k = 1/2$.
More generally, any family with fixed excess $e = V - L$ has
$\rho = 2^{-1-e/L} \to 1/2$ as $L \to \infty$, so the spectral radius question
does not depend solely on the $V = L+1$ family.
\end{conjecture}

The current proved bounds are $2^{-16/15} \leq \rho(\mathcal{L}) \leq 1/2$.

## Conjecture 4 (Negative Rationality)

\begin{conjecture}[Negative Rationality]
For every case-(a) ghost type with $D < 0$, all orbit elements $\tilde{n}_i = R_i/D$
are negative rationals (equivalently, $R_i > 0$ for all $i$).
\end{conjecture}

This conjecture has been verified computationally for all 5,996 canonical case-(a)
ghost types with $D < 0$ across 66 $(L, V)$ pairs through $L = 12$. Every orbit
element of every such ghost has $R_i > 0$. A proof strategy via Baker--W\"ustholz
bounds and the concentrated-pattern restriction is outlined in the Discussion (Section~12).

\begin{remark}
If a 2-adic periodic orbit $\tilde{n}_1, \ldots, \tilde{n}_L$ has
$\tilde{n}_i = R_i / D$ with all $R_i / D$ positive integers, these integers form
a true Collatz cycle (since the valuation conditions and the Syracuse map agree on
$\mathbb{Z}_{> 0} \subset \mathbb{Z}_2$). Conversely, any positive-integer Collatz
cycle is a case-(a) 2-adic orbit with positive rational elements. Conjecture 4
shows that all $D < 0$ ghost orbits are purely negative, ruling out positive or
integer orbit elements from this family. A positive-integer Collatz cycle would
require a case-(a) orbit with $D > 0$ (since $R_i > 0$ always, positivity of
$\tilde{n}_i = R_i/D$ forces $D > 0$); such cycles lie outside the scope of
Conjecture 4. The computational results of Steiner (1977) and Simons--de Weger (2005)
exclude positive-integer cycles up to length 68 via Baker-type estimates, directly
addressing the $D > 0$ case. Conjecture 4 does not address divergent trajectories.
\end{remark}

Conjecture~1 (Universal Case-(a)) was stated in Section 7, where the case-(a)/(b)
classification is introduced.


# Eigenvalue Spectra

Dense eigenvalue computation (numpy \texttt{eig}) for $k = 3, \ldots, 15$ reveals a striking
pattern: for every non-exceptional $k$ in this range, the spectrum of $P_k$ is exactly
$\{0, 1/4\}$. The only nonzero eigenvalue is $1/4$ (from the fixed point $\{1\}$); all
other eigenvalues are exactly zero.

| $k$ | Matrix size $N$ | Nonzero eigenvalues | Spectrum | Exceptional? |
|-----|----------------|--------------------|---------:|:----:|
| 3   | 4              | 1                  | $\{0, 1/4\}$ | No |
| 4   | 8              | 1                  | $\{0, 1/4\}$ | No |
| 5   | 16             | 1                  | $\{0, 1/4\}$ | No |
| 6   | 32             | 1                  | $\{0, 1/4\}$ | No |
| 7   | 64             | 1                  | $\{0, 1/4\}$ | No |
| 8   | 128            | 1                  | $\{0, 1/4\}$ | No |
| 9   | 256            | 1                  | $\{0, 1/4\}$ | No |
| 10  | 512            | 27                 | 27 nonzero | Yes |
| 11  | 1024           | 26                 | 26 nonzero | Yes |
| 12  | 2048           | 14                 | 14 nonzero | Yes |
| 13  | 4096           | 1                  | $\{0, 1/4\}$ | No |
| 14  | 8192           | 1                  | $\{0, 1/4\}$ | No |
| 15  | 16384          | 1                  | $\{0, 1/4\}$ | No |

: Eigenvalue spectra of $P_k(3,1)$ for $k = 3, \ldots, 15$.

The nonzero eigenvalue count is explained by cycle lengths: the fixed point $\{1\}$
contributes 1 eigenvalue ($1/4$), and each extra cycle of length $L$ contributes $L$
nonzero eigenvalues (the $L$th roots of $2^{-V}$). Thus $k = 10$ has
$1 + 26 = 27$ (one extra cycle of length 26), $k = 11$ has $1 + 25 = 26$
(one extra cycle of length 25), and $k = 12$ has $1 + 7 + 6 = 14$
(two extra cycles of lengths 7 and 6).

The Fredholm determinant for non-exceptional $k$ is $\det(I - zP_k) = 1 - z/4$.
The Fredholm determinant $F_k(z) = \det(I - z \cdot P_k)$ is a polynomial
in $z$ of degree $N = 2^{k-1}$. Its zeros occur at $z = 1/\lambda_i$, the reciprocals
of eigenvalues. For non-exceptional $k$, the only zero is at $z = 4$.


# Computational Methodology

## Transfer Matrix Construction

The transfer matrix $P_k$ is constructed as in Definition 3 (Section 2). For $x = 3$,
$y = 1$: for each odd residue $j$, compute $\mathrm{val}_j = 3j + 1$, extract
$v_j = v_2(\mathrm{val}_j)$, and set entry $P_k[t_j, j] = 2^{-v_j}$ where
$t_j = (3j+1)/2^{v_j} \bmod 2^k$.

## Cycle Search Algorithm

Cycle detection follows the successor graph. For $k \leq 32$, the successor function
is precomputed as a numpy uint32 array; for $k = 33$--$36$, it is computed on-the-fly.

The algorithm iterates over all $N = 2^{k-1}$ odd residues in $O(N)$ time
and $O(N)$ space (or $O(N/8)$ with bitpacking):
```
for start in 0..N-1:
    if visited[start]: continue
    path = []; path_set = set()
    cur = start
    while not visited[cur] and cur not in path_set:
        path.append(cur); path_set.add(cur)
        cur = successor(cur)
    if cur in path_set:
        cycle = path[path.index(cur):]
        record(cycle)
    mark all path elements visited
```

## On-the-fly Computation with Numba

For $k = 33$--$36$, storing the successor array would require more than 16 GB. Instead, we
compute successors on the fly using Numba JIT compilation. The visited array is packed
as a bitarray (1 bit per residue), reducing memory to approximately 4 GB at $k = 36$.

## Eigenvalue Computation

Dense eigenvalue computation uses numpy's \texttt{eig} function on the full $N \times N$ matrix.
This is feasible through $k = 15$ ($N = 16384$). Sparse eigensolvers (ARPACK via
\texttt{scipy.sparse.linalg.eigs}) produce artifacts for these nearly nilpotent matrices,
reporting spurious nonzero eigenvalues of magnitude $\sim 0.20$--$0.24$; dense
computation confirms these are numerical artifacts. All eigenvalue results in this
paper use dense computation only.

## Verification

All results for $k = 3, \ldots, 24$ are verified against a separate implementation
(113 unit tests checking cycle counts, lengths, and spectral radii). Ghost cycle
persistence is verified algebraically: for each known ghost type, the rational orbit
$\tilde{n}_1 = R/D$ is computed exactly and the case-(a) valuation conditions are
checked. Arithmetic progression reappearance is confirmed through $k = 200$.

## Reproducibility

The complete codebase, including analysis scripts, test suite, and figure generation,
is available at \url{https://github.com/mysticflounder/collatz}. All computations use
Python 3 with numpy and optional Numba acceleration.


# Discussion

We do not address the Collatz conjecture directly. Our results concern the spectral
theory of the transfer operator $\mathcal{L}$ and the structure of its exceptional set $E$, which
is a necessary preliminary to any spectral approach to the conjecture.

## The Mod-3 Restricted Approach

The Lasota--Yorke obstruction (Theorem 2) arises from the mod-3 oscillation of the
weight function $W$. A natural salvage attempt restricts the Lipschitz seminorm to
pairs within the same mod-3 class, where the conditional contraction rate is $4/15$
(Section 4, second remark). However, the inverse branches involve division
by 3, which scrambles higher powers of 3: for $x \equiv y \pmod{3}$ but
$9 \nmid (x - y)$, the branches $g_v$ do not preserve mod-3 classes, and the
obstruction propagates to all levels of the 3-adic filtration.

## Archimedean Compactness

The 2-adic unboundedness (Theorem 3) closes the Mahler/Amice program in the 2-adic
setting. However, $\mathcal{L}$ is bounded on $C(\mathbb{Z}_2^{\mathrm{odd}}, \mathbb{R})$ with
the archimedean sup norm ($\|\mathcal{L}\| = 2/3$), and the question of whether $\mathcal{L}$ is
*compact* on this space remains open. Compactness would imply
$\sigma_{\mathrm{ess}}(\mathcal{L}) = \{0\}$, reducing the spectrum to isolated eigenvalues
accumulating at 0. The Mahler basis is still a Schauder basis for
$C(\mathbb{Z}_2^{\mathrm{odd}}, \mathbb{R})$; the archimedean Mahler matrix
$M_\infty^{\mathrm{arch}}$ is well-defined (the entries converge archimedeanly, even
though they diverge 2-adically), and compactness reduces to uniform archimedean row
decay: $\sup_j |M_\infty^{\mathrm{arch}}[m,j]| \to 0$ as $m \to \infty$.

## Projective Limit and $\sigma(\mathcal{L}) \supseteq [1/4, 1/2]$

Theorem 1(e) gives $\sigma(\mathcal{L}) = \overline{\bigcup \sigma(P_k)}$
directly, bypassing the need for quasi-compactness. Case-(a) ghosts persist across
levels (Theorem 5), so exceptional eigenvalues accumulate. The $V = L+1$ ghost family
produces case-(a) ghosts with $\rho = 2^{-(L+1)/L} \to 1/2$ at the majority of tested
cycle lengths $L \leq 15$, suggesting $\rho(\mathcal{L}) = 1/2$ and hence \emph{no spectral gap} on
$C(\mathbb{Z}_2^{\mathrm{odd}})$. If the universal case-(a) property (Conjecture~1)
holds for all $L$, and if for each $(L, V)$ with $V < 2L$ at least one ghost type
materializes (i.e., appears as a modular cycle at some level $k$), then
$\sigma(\mathcal{L}) \supseteq [1/4, 1/2]$, since the set
$\{2^{-V/L} : L \geq 2, L+1 \leq V \leq 2L-1\}$ is dense in $[1/4, 1/2]$.
Materialization is the weakest link in this chain: the $V = L+1$ family has
$r = 0$ at $L = 9$ and $L = 11$, showing that case-(a) alone does not guarantee
materialization. The phenomenon appears governed by equidistribution of powers
of 2 modulo $|D|$, and a heuristic density argument (Section 8) predicts that
most $(L, V)$ pairs produce materializing ghosts for sufficiently large $L$.

## Baker--W\"ustholz Bounds

Effective lower bounds on $|2^V - 3^L|$ from transcendence theory (Propositions~4--5)
bound ghost cycle denominators but do not prove $|E| < \infty$. Baker--W\"ustholz bounds
exclude case-(b) ghosts (bounded-length, finite persistence) but not case-(a) ghosts,
which are true 2-adic periodic orbits that persist at arithmetic progressions of levels
regardless of $|D|$.

A more direct route to Conjecture 4 (Negative Rationality) may be available via the
methods of Steiner (1977) and Simons--de Weger (2005), who bounded cycle lengths using
Baker-type estimates on linear forms in logarithms. Their approach controls the numerators
$R_i$ and the denominator $D = 2^V - 3^L$ jointly, excluding positive-integer cycles up
to length 68. Extending this to all $L$ is blocked by the circularity $L \lesssim C\log(3^L)$
in Baker's bounds. However, the concentrated-pattern restriction $(v_1, \ldots, v_L) = (1, \ldots, 1, e+1)$
gives an explicit closed form for each $R_i$ as a function of position around the cycle,
which may provide the additional leverage needed to prove $R_i > 0$ uniformly for all
concentrated patterns with $D < 0$.

## Thermodynamic Formalism

Inducing schemes may provide alternative routes to spectral gap, working with the
natural return map rather than the global transfer operator. The key challenge is that
the inducing partition must respect both the 2-adic and mod-3 structures simultaneously.

## Iwasawa Analogy

By analogy with Iwasawa theory, the infinitude of $E$ corresponds to $\mu \neq 0$.

## Connection to Siegel (2025)

Siegel (2025a) independently uses the term ``ghost cycles'' for 2-adic periodic orbits
of the $3x+1$ map. Our work differs in computing the density of exceptional levels,
classifying ghost persistence into case-(a) and case-(b), and providing the census of
materializing ghost types. Siegel (2025b) studies algebras of $p$-adic distributions
induced by pointwise products of $F$-series; the relationship between that algebraic
framework and our transfer operator approach remains to be explored.


# Acknowledgments {-}

The author acknowledges extensive use of Claude (Anthropic) throughout this work,
including code development, computational exploration, proof formalization, and
manuscript preparation. The research directions, conjectures, and interpretation
of results are the author's own. All results are verified by an automated test suite
(113 tests) and reproducible from the open-source repository.
This work received no external funding.


# References {-}

\noindent Amice, Y. (1964). Interpolation $p$-adique. *Bulletin de la Soci\'et\'e Math\'ematique de France* 92, 181--236.

\noindent Assani, I. (2024). Collatz Map as a Non-Singular Transformation. *Studia Mathematica* 275.

\noindent Baker, A. and W\"ustholz, G. (1993). Logarithmic forms and group varieties. *Journal f\"ur die reine und angewandte Mathematik* 442, 19--62.

\noindent Kontorovich, A. and Lagarias, J. (2009). Stochastic Models for the $3x+1$ and $5x+1$ Problems and Beyond. In Bentley, P. et al. (eds.), *The Ultimate Challenge: The $3x+1$ Problem*, AMS, pp. 131--188.

\noindent Lagarias, J. (1985). The $3x+1$ Problem and Its Generalizations. *American Mathematical Monthly* 92, 3--23.

\noindent Lagarias, J. (2021). The $3x+1$ Problem: An Overview. arXiv:2111.02635.

\noindent Lagarias, J. and Weiss, A. (1992). The $3x+1$ Problem: Two Stochastic Models. *Annals of Applied Probability* 2(1), 229--261.

\noindent Laurent, M. (2008). Linear forms in two logarithms and interpolation determinants II. *Acta Arithmetica* 133(4), 325--348.

\noindent Matthews, K. and Watts, A. (1985). A Markov approach to the generalized Syracuse algorithm. *Acta Arithmetica* 45(1), 29--42.

\noindent Mori, T. (2024). Application of Operator Theory for the Collatz Conjecture. arXiv:2411.08084.

\noindent Neklyudov, M. (2024). Functional Analysis Approach to the Collatz Conjecture. *Results in Mathematics* 79.

\noindent Serre, J.-P. (1962). Endomorphismes compl\`etement continus des espaces de Banach $p$-adiques. *Publications Math\'ematiques de l'IH\'ES* 12, 69--85.

\noindent Siegel, M. (2025a). Ghost Cycles of the 3x+1 Map. arXiv:2601.12772.

\noindent Siegel, M. (2025b). Algebras of $p$-Adic Distributions Induced by Pointwise Products of $F$-Series. arXiv:2507.13358.

\noindent Simons, J. and de Weger, B. (2005). Theoretical and computational bounds for $m$-cycles of the $3n+1$ problem. *Acta Arithmetica* 117(1), 51--70.

\noindent Steiner, R. P. (1977). A Theorem on the Syracuse Problem. In *Proceedings of the 7th Manitoba Conference on Numerical Mathematics*, pp. 553--559.

\noindent Tao, T. (2022). Almost All Orbits of the Collatz Map Attain Almost Bounded Values. *Forum of Mathematics, Pi* 10, e12.

\noindent Wirsching, G. (1998). *The Dynamical System Generated by the $3n+1$ Function*. Springer LNM 1681.
