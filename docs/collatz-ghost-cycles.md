---
title: "Ghost Cycles as 2-Adic Periodic Orbits: Spectral Theory of the Syracuse Transfer Operator"
author:
  - "Adam McKenna (adam@mysticflounder.ai, [LinkedIn](https://www.linkedin.com/in/admckenna/))"
  - Claude (Anthropic)
date: "March 2026"
abstract: |
  We study the Syracuse map $S(n) = (3n+1)/2^{v_2(3n+1)}$ on odd integers through its
  transfer matrices $P_k$ on odd residues modulo $2^k$. Exhaustive cycle enumeration
  through $k = 36$ reveals "ghost cycles" --- extra modular cycles beyond the fixed
  point $\{1\}$ --- at an exceptional set $E$ of levels. We show that ghost cycles are
  modular projections of 2-adic periodic orbits whose rational elements are negative in
  all computed cases. The cycle equation $n_1 \cdot (2^V - 3^L) \equiv R \pmod{2^{k+V}}$
  yields a rational solution $\tilde{n}_1 = R/D$ with $D = 2^V - 3^L$. We classify
  ghosts into case (a), where the 2-adic valuations of the rational orbit match the
  modular pattern exactly, and case (b), where they do not. Case-(a) ghosts reappear at
  arithmetic progressions $k \equiv k_0 \pmod{\mathrm{ord}_2(|D|)}$, making $E$ infinite
  with natural density $\geq 4\%$. This falsifies our earlier conjecture that $E$ has
  density zero and $\rho_k \to 1/4$. We identify four case-(a) ghost types with short cycles ($L \leq 8$) through
  $k = 200$ and propose replacement conjectures for the density of $E$ and the spectral
  behavior of the transfer matrices. All computations are reproducible from the
  accompanying open-source repository.
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

The Collatz conjecture, concerning the iteration $n \mapsto (3n+1)/2^{v_2(3n+1)}$ on odd
integers, remains one of the most prominent open problems in number theory. Rather than
attack it directly, we embed it in the parametric family
$$S(n) = \frac{xn + y}{2^{v_2(xn + y)}}$$
for odd parameters $x$, $y$, and study the family through its transfer matrices
$P_k(x,y)$ at resolution $k$.

The spectral radius $\rho_k(x,y)$ measures the worst-case contraction rate over modular
cycles: $\rho < 1$ indicates contraction, $\rho > 1$ indicates divergence. This
operator-theoretic perspective realizes the Matthews--Watts (1985) growth-rate criterion
as a spectral radius crossing 1.

**Our contributions.** We present:
(1) exhaustive cycle enumeration through $k = 36$, extending prior searches;
(2) identification of ghost cycles as modular projections of 2-adic periodic orbits with
negative rational elements in all computed cases;
(3) the case-(a)/(b) classification and a proof (Theorem 2) that case-(a) ghosts persist
at arithmetic progressions of levels, making $E$ infinite with positive density;
(4) falsification of the conjecture that $E$ has density zero;
(5) replacement conjectures for the density of $E$ and the spectral radius of the
transfer matrices.

All code and data are available at
\url{https://github.com/mysticflounder/collatz}.

**Related work.** The transfer matrix approach to Collatz-type maps originates with
Matthews and Watts (1985), who studied growth rates via Markov chain models, and
Wirsching (1998), who developed the dynamical systems perspective systematically.
Lagarias and Weiss (1992) introduced stochastic models that predict the heuristic
contraction rate. Tao (2022) proved that almost all orbits attain almost bounded values
using a probabilistic approach different from transfer matrices. The cycle equation
(our Theorem 1) appears in Steiner (1977). Siegel (2025) independently uses the term
"ghost cycles" for 2-adic periodic orbits of the $3x+1$ map; our work differs in
computing the density of exceptional levels and classifying ghost persistence. The
Baker--Wüstholz (1993) bounds on linear forms in logarithms, as refined by Laurent
(2008), provide unconditional results on ghost cycle lengths (our Propositions 1--2).

**Outline.** Section 2 defines the objects of study. Section 3 places the Collatz map
in the parametric family $S(n) = (xn+y)/2^{v_2(xn+y)}$. Section 4 enumerates the
exceptional set and establishes the ghost persistence mechanism. Section 5 presents the
falsification and new conjectures. Section 6 presents eigenvalue spectra.
Section 7 describes computational methodology.


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


# The Parametric Family

While the Collatz conjecture concerns the single map $x = 3$, $y = 1$, embedding it in
the family $S(n) = (xn+y)/2^{v_2(xn+y)}$ reveals structural context. The net growth
rate per step is $x \cdot 2^{-v}$, so the expected log-growth is $\log_2 x - \mathbb{E}[v]
= \log_2 x - 2$, which changes sign at $x = 4$. This phase transition is visible in the
spectral radius of the growth-weighted transfer matrix (with entries $x \cdot 2^{-v_j}$
rather than the contraction weights $2^{-v_j}$ of Definition~3). It realizes the
Matthews--Watts (1985) criterion for $d = 2$. For the remainder of this paper, we work
exclusively with the contraction-weighted matrix $P_k$ (Definition~3) at $x = 3$.

![Spectral radius $\rho_k(x,y)$ as a function of the multiplier $x$ for several values of $k$. The phase transition at $x = 4$ is visible across all resolutions.](analysis/spectral_radius_vs_x.png){width=85%}

![Convergence rate $\rho(x,y)$ across the $(x,y)$ parameter space (left) and cycle count (right). The phase transition at $x = 4$ persists as a vertical boundary.](analysis/phase_diagram.png){width=95%}


# Exceptional Set Enumeration

## Exhaustive Search

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

## Ghost Cycles as 2-Adic Periodic Orbits

Ghost cycles are not transient artifacts of modular reduction. They are the modular
projections of true periodic orbits of $S$ on the 2-adic integers
$\mathbb{Z}_2^{\mathrm{odd}}$.

### The Cycle Equation

\setcounter{theorem}{0}
\begin{theorem}[Cycle equation; Steiner 1977, Wirsching 1998]
\label{thm:cycle-eq}
A modular cycle of length $L$ at level $k$ with valuation pattern $(v_1, \ldots, v_L)$
and total valuation $V = \sum v_i$ satisfies
$$n_1 \cdot D \equiv R \pmod{2^{k+V}},$$
where $D = 2^V - 3^L$ and
$R = \sum_{i=0}^{L-1} 3^{L-1-i} \cdot 2^{S_i}$, with $S_0 = 0$ and
$S_i = v_1 + \cdots + v_i$.
\end{theorem}

*Proof.* (Standard; included for self-containedness.) If the cycle visits odd residues
$n_1, n_2, \ldots, n_L$ with $n_{i+1} = (3n_i + 1)/2^{v_i}$, then
$n_{i+1} \cdot 2^{v_i} = 3n_i + 1$. Iterating $L$ times:
$n_1 \cdot 2^V = 3^L n_1 + R$, giving $n_1 (2^V - 3^L) = R$. This holds
modulo $2^{k+V}$ because each step preserves residues modulo $2^k$, and the
accumulated shift introduces $V$ additional bits of precision. $\square$

Since $D = 2^V - 3^L$ is always odd and nonzero (as $2^V$ and $3^L$ are coprime), the
rational limit $\tilde{n}_1 = R/D$ is well-defined. For $V > L \log_2 3$, we have
$D < 0$.

### Case-(a) vs Case-(b) Classification

\begin{definition}
Given a cycle with parameters $(L, V, (v_1, \ldots, v_L))$ and rational limit
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
(iii) $n_{L+1} = n_1 \bmod 2^k$.

Since $\tilde{n}_i \bmod 2^k$ depends only on $k \bmod p$, and conditions (i)--(ii)
are satisfied at $k_0$, they remain satisfied at all $k \equiv k_0 \pmod{p}$
with $k \geq k_0$. $\square$

\begin{remark}
For case-(b) ghosts, condition (ii) eventually fails: the ``extra'' valuation
$v_2(3\tilde{n}_i + 1) > v_i$ means that at the rational level, the Syracuse map
takes a different branch than the one prescribed by $(v_1, \ldots, v_L)$. The
modular cycle exists only at levels $k$ where the extra bits are not yet visible.
\end{remark}

### Known Case-(a) Ghost Types

| $D$ | $L$ | $V$ | $v$-pattern | $\tilde{n}_1$ | $p$ | $r$ | $\rho$ |
|-----|-----|-----|-------------|---------------|------|-----|---------|
| $-179$ | 5 | 6 | $(2,1,1,1,1)$ | $-341/179$ | $178$ | $3$ | $0.4353$ |
| $-601$ | 6 | 7 | $(1,1,1,1,1,2)$ | $-665/601$ | $25$ | $1$ | $0.4454$ |
| $-5537$ | 8 | 10 | $(1,1,1,1,1,1,1,3)$ | $-6305/5537$ | $84$ | $2$ | $0.4204$ |
| $-1675$ | 7 | 9 | $(1,1,1,1,1,1,3)$ | $-2059/1675$ | $660$ | $3$ | $0.4102$ |

: Known case-(a) ghost types. $v$-patterns are listed up to cyclic rotation. Period
$p = \mathrm{ord}_2(|D|)$ and $r$ is the number of residue classes mod $p$ at which
the ghost appears. All $v$-patterns have the form $(1, \ldots, 1, V-L+1)$: the
"excess valuation" $V - L + 1$ concentrates in a single step.

The $D = -601$ ghost ($L = 6$, $V = 7$) has $\rho = 2^{-7/6} \approx 0.4454$ and
reappears at every $k \equiv 12 \pmod{25}$: verified at $k = 12, 37, 62, 87, \ldots, 187$.
All orbit elements are negative rationals (e.g., $\tilde{n}_1 = -665/601 \approx -1.107$).

### Baker--Wüstholz Bounds

Transcendence theory constrains ghost cycle denominators.

\begin{proposition}[Effective lower bound on $|D|$; Baker--Wüstholz 1993, Laurent 2008]
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
($\binom{V-1}{L-1}$ compositions). By Theorem~\ref{thm:persistence}, each case-(a)
pattern reappears with period $p = \mathrm{ord}_2(|D|)$, so it must first appear at some
$k_0 \leq p$. Each case-(b) pattern appears finitely often, also within $[3, p]$.
Taking the maximum over all $(L, V)$ in the range gives $K_0(L_0)$. $\square$

\begin{remark}
Propositions~\ref{prop:baker} and~\ref{prop:exclusion} are unconditional, but they cannot
prove $E$ is finite: that would require bounding cycle length $L$ as a function of level
$k$, which no known result from transcendence theory achieves.
\end{remark}


# Falsification of Conjecture 1

Our original conjecture stated that $E$ has natural density zero and
$\rho_k(3,1) \to 1/4$, supported by a Borel--Cantelli heuristic suggesting
$|E| < \infty$. Baker--Wüstholz analysis and extended computation to $k = 200$
have falsified this conjecture.

## The Falsification

The $D = -601$ ghost (case (a), $L = 6$, $V = 7$) reappears at every
$k \equiv 12 \pmod{25}$, contributing $\rho \geq 2^{-7/6} \approx 0.445$ at
infinitely many levels. This alone gives $\delta(E) \geq 1/25 = 4\%$.

Empirically, $|E \cap [37, 200]| / 164 \approx 12\%$, with at least four distinct
case-(a) ghost types contributing. The "growing gaps" pattern observed in $[3, 36]$ was
an artifact of the short search range: beyond $k = 36$, ghost reappearances fill in
the gaps.

The Borel--Cantelli heuristic $P(k \in E) \sim k^2 \cdot 2^{-k}$ was wrong because it
treated ghost appearances as independent events. Case-(a) ghosts are deterministic:
once identified, their reappearance pattern is exactly periodic.

Figure~\ref{fig:ghost_timeline} shows the ghost reappearance pattern across $k = 3$
to $200$. Beyond the exhaustive search boundary ($k = 36$), the four known ghost types
account for 17 of the 20 exceptional levels in $[3, 200]$. The remaining three
($k = 10, 11, 20$, all within the exhaustive search range)
are case-(a) ghosts with long cycles ($L = 26, 25, 22$ respectively) and very large
denominators ($|D| > 10^{10}$), giving periods $p = \mathrm{ord}_2(|D|) > 10^5$; they
reappear too rarely to be observed in the range $k \leq 200$.

\begin{figure}[ht]
\centering
\includegraphics[width=\textwidth]{analysis/ghost_timeline.png}
\caption{Ghost cycle appearances by level $k$. Each row represents a ghost type
(identified by denominator $D$). The vertical dashed line at $k = 36$ marks the boundary
of exhaustive search; beyond it, ghost memberships are computed algebraically from
Theorem~\ref{thm:persistence}. The periodic structure of case-(a) ghosts is clearly
visible.}
\label{fig:ghost_timeline}
\end{figure}

## New Conjectures

\setcounter{conjecture}{0}
\begin{conjecture}[Density of $E$]
The exceptional set $E$ has a well-defined natural density $\delta(E) > 0$.
Assuming the arithmetic progressions for distinct ghost types have coprime periods,
the density decomposes as
$$\delta(E) = 1 - \prod_{\mathcal{G}} \left(1 - \frac{r_{\mathcal{G}}}{p_{\mathcal{G}}}\right)$$
where the product is over all case-(a) ghost types $\mathcal{G}$,
$p_{\mathcal{G}} = \mathrm{ord}_2(|D_{\mathcal{G}}|)$ is the period, and
$r_{\mathcal{G}}$ is the number of residue classes within that period where
$\mathcal{G}$ appears. If two ghost types have periods sharing a common factor,
an inclusion-exclusion correction is needed.
\end{conjecture}

From the four known ghost types, the formula gives
$\delta(E) \geq 1 - (24/25)(175/178)(82/84)(657/660) \approx 8.3\%$.
We note that $\gcd(p_{-601}, p_{-1675}) = \gcd(25, 660) = 5$, so the coprime
assumption is not exactly satisfied; the $8.3\%$ figure is therefore approximate,
though the qualitative conclusion ($\delta(E) > 0$) is unaffected --- the
$D = -601$ ghost alone gives $\delta(E) \geq 1/25 = 4\%$ unconditionally.
The empirical density $\approx 12\%$ suggests additional ghost types exist.

\begin{conjecture}[Spectral Radius]
The spectral radius of the transfer matrices satisfies
$$\limsup_{k \to \infty} \rho_k = \max\left(\frac{1}{4}, \; \sup_{\mathcal{G}} 2^{-V_{\mathcal{G}}/L_{\mathcal{G}}}\right),$$
where the supremum is over all case-(a) ghost types. The maximum with $1/4$ accounts
for the fixed point $\{1\}$. From the known ghosts, $\limsup \rho_k \geq 2^{-7/6} \approx 0.4454$.
\end{conjecture}

\begin{conjecture}[Negative Rationality]
For every case-(a) ghost type, all orbit elements $\tilde{n}_i = R/D$ are negative
rationals.
\end{conjecture}

\begin{remark}
If a 2-adic periodic orbit $\tilde{n}_1, \ldots, \tilde{n}_L$ has
$\tilde{n}_i = R_i / D$ with all $R_i / D$ positive integers, these integers form
a true Collatz cycle (since the valuation conditions and the Syracuse map agree on
$\mathbb{Z}_{> 0} \subset \mathbb{Z}_2$). Conversely, any positive-integer Collatz
cycle is a case-(a) 2-adic orbit with positive rational elements. Thus Conjecture 3
is equivalent to the nonexistence of non-trivial positive-integer Collatz cycles.
Note that if $R_i / D$ is a positive non-integer rational, the orbit elements are not
positive integers, and the connection to Collatz cycles on $\mathbb{Z}_{>0}$ does not
apply; the conjecture is specifically about the sign of the rational elements.
In particular, Conjecture 3 implies the nonexistence of non-trivial positive-integer
Collatz cycles (the periodic orbit part of the Collatz conjecture), and additionally
excludes positive non-integer rational orbits. It does not address divergent
trajectories.
\end{remark}


# Eigenvalue Spectra

## Dense Computation

Dense eigenvalue computation (numpy `eig`) for $k = 3, \ldots, 15$ reveals a striking
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
(two extra cycles of lengths 7 and 6, both with $D = -1675$ and $D = -601$
respectively, but with different $v$-patterns from the ones listed in Table~3).

The Fredholm determinant for non-exceptional $k$ is $\det(I - zP_k) = 1 - z/4$.

## The Fredholm Determinant

The Fredholm determinant $F_k(z; x, y) = \det(I - z \cdot P_k(x, y))$ is a polynomial
in $z$ of degree $N = 2^{k-1}$. Its zeros occur at $z = 1/\lambda_i$, the reciprocals
of eigenvalues. For non-exceptional $k$, the only zero is at $z = 4$.

As $x$ varies, the Fredholm zeros migrate in the complex plane. For $x = 3$, the nearest
zero sits near $|z| = 4$. As $x$ increases toward 4, zeros approach the unit circle;
past $x = 4$, some enter the unit disk.

![Fredholm determinant zeros in the complex $z$-plane for several values of $x$. As $x$ increases from 3 toward 5, zeros migrate inward, crossing the unit circle near $x = 4$.](analysis/fredholm_zeros_flow.png){width=85%}


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

Dense eigenvalue computation uses numpy's `eig` function on the full $N \times N$ matrix.
This is feasible through $k = 15$ ($N = 16384$). Sparse eigensolvers (ARPACK via
`scipy.sparse.linalg.eigs`) produce artifacts for these nearly nilpotent matrices,
reporting spurious nonzero eigenvalues of magnitude $\sim 0.20$--$0.24$; dense
computation confirms these are numerical artifacts. All eigenvalue results in this
paper use dense computation only.

## Verification

All results for $k = 3, \ldots, 24$ are verified against a separate implementation
(99 unit tests checking cycle counts, lengths, and spectral radii). Ghost cycle
persistence is verified algebraically: for each known ghost type, the rational orbit
$\tilde{n}_1 = R/D$ is computed exactly and the case-(a) valuation conditions are
checked. Arithmetic progression reappearance is confirmed through $k = 200$.

## Reproducibility

The complete codebase, including analysis scripts, test suite, and figure generation,
is available at \url{https://github.com/mysticflounder/collatz}. All computations use
Python 3 with numpy and optional Numba acceleration.


# References {-}

\noindent Baker, A. and Wüstholz, G. (1993). Logarithmic forms and group varieties. *Journal für die reine und angewandte Mathematik* 442, 19--62.


\noindent Lagarias, J. (1985). The $3x+1$ Problem and Its Generalizations. *American Mathematical Monthly* 92, 3--23.

\noindent Lagarias, J. (2021). The $3x+1$ Problem: An Overview. arXiv:2111.02635.

\noindent Lagarias, J. and Weiss, A. (1992). The $3x+1$ Problem: Two Stochastic Models. *Annals of Applied Probability* 2(1), 229--261.

\noindent Laurent, M. (2008). Linear forms in two logarithms and interpolation determinants II. *Acta Arithmetica* 133(4), 325--348.

\noindent Matthews, K. and Watts, A. (1985). A Markov approach to the generalized Syracuse algorithm. *Acta Arithmetica* 45(1), 29--42.

\noindent Siegel, M. (2025). Ghost Cycles of the 3x+1 Map. arXiv:2601.12772.

\noindent Steiner, R. P. (1977). A Theorem on the Syracuse Problem. In *Proceedings of the 7th Manitoba Conference on Numerical Mathematics*, pp. 553--559.

\noindent Tao, T. (2022). Almost All Orbits of the Collatz Map Attain Almost Bounded Values. *Forum of Mathematics, Pi* 10, e12.

\noindent Wirsching, G. (1998). *The Dynamical System Generated by the $3n+1$ Function*. Springer LNM 1681.
