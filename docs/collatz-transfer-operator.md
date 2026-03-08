---
title: "Transfer Operators for the Syracuse Map on 2-Adic Integers: Spectral Properties and the Lasota--Yorke Obstruction"
author:
  - "Adam McKenna (adam@mysticflounder.ai, [LinkedIn](https://www.linkedin.com/in/admckenna/))"
date: "March 2026"
abstract: |
  We study the transfer operator $L$ of the Syracuse map $S(n) = (3n+1)/2^{v_2(3n+1)}$
  acting on continuous functions on the odd 2-adic integers $\mathbb{Z}_2^{\text{odd}}$.
  We establish the complete preimage structure classified by residue mod~3, prove the
  operator norm $\|L\| = 2/3$ (correcting earlier claims of $1/3$), and show that each
  inverse branch contracts by $2^{-v}$ in the 2-adic metric. Despite this contraction, we
  prove that $L$ does \emph{not} preserve the Lipschitz space $\text{Lip}_1(\mathbb{Z}_2^{\text{odd}})$:
  the weight function $W = L(\mathbf{1})$ has infinite Lipschitz seminorm because
  it depends on residues mod~3, which oscillate at every scale of the 2-adic metric.
  This obstruction extends to all H\"older, Sobolev, and bounded-variation spaces defined
  using the 2-adic metric alone. We state what \emph{is} provable: $\rho(L) \leq 1/2$,
  $\lambda = 1/4$ is a simple eigenvalue, and $\sigma(L)$ equals the closure of the
  union of spectra of finite transfer matrices $P_k$. We discuss paths forward including
  Mahler bases, Iwasawa algebras, and thermodynamic formalism.
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

# Introduction

The Syracuse map $S(n) = (3n+1)/2^{v_2(3n+1)}$ on odd positive integers extends
continuously to $\mathbb{Z}_2^{\text{odd}} = 1 + 2\mathbb{Z}_2$, the odd 2-adic
integers. The transfer operator (Perron--Frobenius operator) associated to $S$ acts on
continuous functions $f \colon \mathbb{Z}_2^{\text{odd}} \to \mathbb{R}$:
$$(Lf)(n) = \sum_{S(m) = n} 2^{-v_2(3m+1)} f(m).$$

A standard approach to proving spectral gap for transfer operators is the Lasota--Yorke
inequality: find a Banach space $X \hookrightarrow C(\mathbb{Z}_2^{\text{odd}})$ such
that $L$ maps $X$ to itself with
$$\|Lf\|_X \leq \alpha \|f\|_X + B \|f\|_{C^0},$$
where $\alpha < \|L\|_{C^0}$. This gives quasi-compactness with essential spectral
radius $\leq \alpha$, reducing the spectral analysis to finitely many isolated eigenvalues.

The most natural candidate is the Lipschitz space
$\text{Lip}_1(\mathbb{Z}_2^{\text{odd}})$ with respect to the 2-adic metric, since
each inverse branch of $S$ contracts 2-adically. Our main result shows this approach
fails fundamentally: $L$ does not even preserve $\text{Lip}_1$, and the obstruction
extends to all standard smoothness spaces defined using the 2-adic metric alone.

This negative result is not merely technical. It reflects an arithmetic tension at the
heart of the Collatz problem: the Syracuse map involves both multiplication by 3
(a 2-adic isometry) and division by powers of 2 (a 2-adic contraction). The inverse
branches contract 2-adically but expand 3-adically, and this dual nature prevents any
purely 2-adic smoothness class from being invariant.

**Prior work.** Mori (2024) and Neklyudov (2024) study operator-theoretic approaches to
Collatz, working on different function spaces. Assani (2024) treats the Collatz map as a
non-singular transformation. Our analysis identifies a specific obstruction that applies
to all these approaches when using 2-adic regularity.

**Outline.** Section 2 establishes the preimage structure. Section 3 computes the
operator norm. Section 4 proves 2-adic contraction of inverse branches. Section 5
gives conditional Lipschitz estimates within mod-3 classes. Section 6 proves the
main obstruction theorem. Section 7 shows universality. Section 8 states what is
provable. Section 9 discusses paths forward.


# Preimage Structure of the Syracuse Map

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

Each $m_v$ is odd, lies in $\mathbb{Z}_2^{\text{odd}}$, and satisfies
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
$S(m) \not\equiv 0 \pmod{3}$. Consequently $(Lf)(n) = 0$ for all $n \equiv 0 \pmod{3}$.
\end{remark}


# Operator Norm and Weight Sums

\setcounter{proposition}{0}
\begin{proposition}[Operator norm]
The operator norm of $L$ on $(C(\mathbb{Z}_2^{\text{odd}}), \|\cdot\|_\infty)$ is
$$\|L\|_{C^0 \to C^0} = 2/3.$$
More precisely, the weight function $W(n) := (L\mathbf{1})(n)$ satisfies:
$$W(n) = \begin{cases} 1/3 & n \equiv 1 \pmod{3} \\ 2/3 & n \equiv 2 \pmod{3} \\ 0 & n \equiv 0 \pmod{3}. \end{cases}$$
\end{proposition}

*Proof.* By Lemma 1:

**Case $n \equiv 1 \pmod{3}$:**
$$W(n) = \sum_{v=2,4,6,\ldots} 2^{-v} = \frac{1/4}{1 - 1/4} = \frac{1}{3}.$$

**Case $n \equiv 2 \pmod{3}$:**
$$W(n) = \sum_{v=1,3,5,\ldots} 2^{-v} = \frac{1/2}{1 - 1/4} = \frac{2}{3}.$$

**Case $n \equiv 0 \pmod{3}$:** $W(n) = 0$ (no preimages).

The bound $|(Lf)(n)| \leq W(n) \|f\|_\infty \leq (2/3)\|f\|_\infty$ is achieved by
$f = \mathbf{1}$ and $n \equiv 2 \pmod{3}$. $\square$

\begin{remark}
The value $\|L\| = 2/3$ corrects the claim $\|L\| = 1/3$ that appeared in earlier
literature on this project. The discrepancy arose from considering only preimages with
even $v$ (the $n \equiv 1 \pmod{3}$ case), which give weight sum $1/3$. The full weight
sum at $n \equiv 2 \pmod{3}$ (preimages with odd $v$) is $2/3$.
\end{remark}

\begin{proposition}[Spectral radius bound]
$\rho(L) \leq 1/2$ on $C(\mathbb{Z}_2^{\text{odd}})$.
\end{proposition}

*Proof.* Every eigenvalue of $L$ corresponds to a periodic orbit of $S$ with
$\lambda = \prod_{\text{cycle}} 2^{-v_i}$. Since each $v_i \geq 1$, the mean valuation
$\bar{v} \geq 1$, giving $|\lambda| = 2^{-\bar{v}} \leq 1/2$. The spectrum of $L$ is
the closure of the union of eigenvalues of the finite approximations $P_k$ (Section 8),
so $\rho(L) \leq 1/2$. $\square$


# Inverse Branch Contractions

\setcounter{lemma}{1}
\begin{lemma}[2-adic contraction]
For each valid $v \geq 1$, the inverse branch
$g_v(n) = (n \cdot 2^v - 1)/3$ satisfies
$$|g_v(x) - g_v(y)|_2 = 2^{-v} |x - y|_2 \quad \text{for all } x, y \in \mathbb{Z}_2.$$
\end{lemma}

*Proof.* $g_v(x) - g_v(y) = 2^v(x - y)/3$. Since $|3|_2 = 1$:
$|g_v(x) - g_v(y)|_2 = |2^v|_2 \cdot |x - y|_2 \cdot |3^{-1}|_2 = 2^{-v} |x - y|_2$. $\square$

\begin{lemma}[Weighted Lipschitz contribution]
For $f \in \text{Lip}_1(\mathbb{Z}_2^{\text{odd}})$ and an inverse branch $g_v$:
$$\frac{2^{-v} |f(g_v(x)) - f(g_v(y))|}{|x - y|_2} \leq 2^{-2v} |f|_{\text{Lip}}$$
for all distinct $x, y$ such that both $g_v(x)$ and $g_v(y)$ are defined.
\end{lemma}

*Proof.* By Lemma 2 and the Lipschitz condition:
$2^{-v} |f(g_v(x)) - f(g_v(y))| \leq 2^{-v} |f|_{\text{Lip}} \cdot 2^{-v} |x - y|_2
= 2^{-2v} |f|_{\text{Lip}} |x - y|_2$. $\square$

\begin{remark}
In the 2-adic metric, multiplication by $2^v$ contracts distances (since $|2|_2 = 1/2$),
while multiplication by 3 is an isometry ($|3|_2 = 1$). Each inverse branch is a strict
contraction matching its weight. However, in the 3-adic metric, the situation reverses:
$|g_v(x) - g_v(y)|_3 = 3|x - y|_3$, an expansion by factor 3 independent of $v$.
\end{remark}


# Lipschitz Contraction Within Mod-3 Classes

\setcounter{proposition}{2}
\begin{proposition}[Conditional Lipschitz estimate]
For distinct $x, y \in \mathbb{Z}_2^{\text{odd}}$ with $x \equiv y \pmod{3}$:
$$\frac{|(Lf)(x) - (Lf)(y)|}{|x - y|_2} \leq \alpha \cdot |f|_{\text{Lip}},$$
where $\alpha = 4/15$ if $x \equiv y \equiv 2 \pmod{3}$ (preimages at odd $v$),
$\alpha = 1/15$ if $x \equiv y \equiv 1 \pmod{3}$ (preimages at even $v$), and
$\alpha = 0$ if $x \equiv y \equiv 0 \pmod{3}$.
\end{proposition}

*Proof.* When $x \equiv y \pmod{3}$, the sets of valid $v$-values coincide (Lemma 1),
and both $g_v(x)$ and $g_v(y)$ are defined for the same $v$-values. By Lemma 3:
$$\frac{|(Lf)(x) - (Lf)(y)|}{|x - y|_2} \leq \sum_{v \text{ valid}} 2^{-2v} \cdot |f|_{\text{Lip}}.$$

For $x \equiv 2 \pmod{3}$: $\sum_{v=1,3,5,\ldots} 2^{-2v} = \frac{1/4}{1 - 1/16} \cdot \frac{4}{4} = \frac{4}{15}$.

For $x \equiv 1 \pmod{3}$: $\sum_{v=2,4,6,\ldots} 2^{-2v} = \frac{1/16}{1 - 1/16} = \frac{1}{15}$.
$\square$

\begin{remark}
The contraction rate $4/15 \approx 0.267$ exceeds $1/4 = 0.250$ but is strictly less
than $1/3$. This means even if the Lasota--Yorke inequality held, the essential spectral
radius bound would be $4/15$, not $1/4$ as one might hope from naive estimates.
\end{remark}


# The Obstruction: $L$ Does Not Preserve $\text{Lip}_1$

\setcounter{theorem}{0}
\begin{theorem}[Non-preservation of $\text{Lip}_1$]
The transfer operator $L$ does not map $\text{Lip}_1(\mathbb{Z}_2^{\text{odd}})$ into
itself. Specifically:

\begin{enumerate}
\item[(a)] The constant function $f = \mathbf{1}$ has $|\mathbf{1}|_{\text{Lip}} = 0$.
\item[(b)] $L(\mathbf{1}) = W$ has $|W|_{\text{Lip}} = \infty$.
\end{enumerate}

Therefore no Lasota--Yorke inequality
$|Lf|_{\text{Lip}} \leq \alpha |f|_{\text{Lip}} + B\|f\|_\infty$ can hold.
\end{theorem}

*Proof.* Part (a) is immediate. For (b), for each even $N \geq 2$, set
$x_N = 1$ and $y_N = 1 + 2^N$. Then:

- Both are odd (since $2^N$ is even).
- $|x_N - y_N|_2 = 2^{-N}$.
- $x_N \equiv 1 \pmod{3}$, so $W(x_N) = 1/3$.
- $y_N = 1 + 2^N \equiv 1 + (-1)^N \equiv 2 \pmod{3}$ (since $N$ is even), so $W(y_N) = 2/3$.

Therefore:
$$\frac{|W(x_N) - W(y_N)|}{|x_N - y_N|_2} = \frac{1/3}{2^{-N}} = \frac{2^N}{3} \to \infty.$$
This proves $|W|_{\text{Lip}} = \infty$. $\square$

\begin{remark}[Root cause]
The weight function $W(n)$ depends on $n \bmod 3$. The residue $n \bmod 3$ is a
continuous function on $\mathbb{Z}_2$ (each residue class is clopen), but it is not
Lipschitz: every 2-adic ball $B(x, 2^{-N})$ intersects all three residue classes
mod~3 (since $\gcd(2^N, 3) = 1$). So $W$ oscillates between $0$, $1/3$, and $2/3$
at every scale of the 2-adic metric.
\end{remark}

\begin{remark}[Arithmetic origin]
The obstruction reflects the fundamental arithmetic tension in the Collatz problem.
Each inverse branch $g_v$ contracts by $2^{-v}$ in the 2-adic metric but expands by $3$
in the 3-adic metric: $|g_v(x) - g_v(y)|_3 = 3|x - y|_3$. The 3-adic expansion
exactly compensates the weight sum, preventing contraction in any metric incorporating
3-adic information.
\end{remark}


# Universality of the Obstruction

\setcounter{corollary}{0}
\begin{corollary}[Universal obstruction]
The function $W = L(\mathbf{1})$ does not belong to any of the following spaces on
$(\mathbb{Z}_2^{\text{odd}}, |\cdot|_2)$:

\begin{enumerate}
\item[(a)] $C^\alpha(\mathbb{Z}_2^{\text{odd}})$ for any $\alpha > 0$.
\item[(b)] $BV(\mathbb{Z}_2^{\text{odd}})$ with respect to the 2-adic ultrametric.
\item[(c)] Any Banach space $X$ continuously embedded in $C(\mathbb{Z}_2^{\text{odd}})$
  such that the inclusion is strict and $X$ contains the constants.
\end{enumerate}
\end{corollary}

*Proof.* (a) The pairs from Theorem 1 give
$|W(x_N) - W(y_N)|/|x_N - y_N|_2^\alpha = 2^{N\alpha}/3 \to \infty$ for any $\alpha > 0$.

(b) At resolution $k$, among $2^{k-1}$ residue classes mod $2^k$, at least $2^{k-1}/3$
have $a \equiv 1 \pmod{3}$ while containing points $\equiv 2 \pmod{3}$, giving oscillation
$\geq 1/3$. Total variation $\geq 2^{k-1}/9 \to \infty$.

(c) If $X$ contains constants and $X \hookrightarrow C$ is strict, then $X$ carries a
norm stronger than $\|\cdot\|_\infty$. By (a), $W$ satisfies no regularity beyond
continuity, so $W \notin X$ unless $X = C$. $\square$

\begin{remark}
This shows the obstruction is not an artifact of choosing Lipschitz norms. \emph{Any}
Banach space strictly between constant functions and $C(\mathbb{Z}_2^{\text{odd}})$,
defined using the 2-adic metric alone, will fail to be preserved by $L$.
\end{remark}


# What IS Provable

Despite the obstruction, meaningful spectral results can be established.

\setcounter{theorem}{1}
\begin{theorem}[Spectral properties of $L$ on $C(\mathbb{Z}_2^{\text{odd}})$]
\hfill

\begin{enumerate}
\item[(a)] $L$ is bounded with $\|L\| = 2/3$.
\item[(b)] $\rho(L) \leq 1/2$.
\item[(c)] $\lambda = 1/4$ is a simple eigenvalue with eigenfunction $\delta_1$.
\item[(d)] $\sigma(L) \subseteq \{|z| \leq 1/2\}$.
\item[(e)] $\sigma(L) = \overline{\bigcup_{k \geq 2} \sigma(P_k)}$, where $P_k$ is the
  transfer matrix on odd residues mod $2^k$.
\item[(f)] For non-exceptional $k$ (verified computationally for $k = 3, \ldots, 35$):
  $\sigma(P_k) = \{0, 1/4\}$.
\end{enumerate}
\end{theorem}

*Proof.* Parts (a)--(b) are Propositions 1--2 above. For (c): the fixed point
$S(1) = 1$ with $v_2(4) = 2$ gives $(L\delta_1)(n) = (1/4)\delta_1(n)$. The eigenspace
is one-dimensional since 1 is the unique fixed point. Parts (d)--(e) follow from (b)
and the density of locally constant functions in $C(\mathbb{Z}_2^{\text{odd}})$ via
the Stone--Weierstrass theorem. Part (f) is verified by dense eigenvalue computation.
$\square$

\setcounter{theorem}{2}
\begin{theorem}[Conditional]
If the exceptional set $E = \{k : \sigma(P_k) \neq \{0, 1/4\}\}$ is finite, or more
generally if the exceptional eigenvalues do not accumulate in $(1/4, 1/2]$, then
$\rho(L) = 1/4$.
\end{theorem}

*Proof.* By Theorem 2(e), $\rho(L) = \sup_k \rho(P_k)$. For non-exceptional $k$,
$\rho(P_k) = 1/4$. The known exceptional values ($k \in \{10, 11, 12, 20, 35\}$ in
$[3, 36]$) have $\rho(P_k) < 1/2$. Ghost cycle eigenvalues that do not persist across
levels do not accumulate in $\sigma(L)$. If no accumulation occurs, then
$\sigma(L) = \{0, 1/4\}$. $\square$

\begin{remark}[Falsification of hypothesis]
The hypothesis of Theorem 3 is FALSE. Ghost cycles are true 2-adic periodic orbits
(see companion paper) that reappear at arithmetic progressions of levels. The exceptional
set $E$ is infinite with density $\geq 4\%$, and the $D = -601$ ghost ($L = 6$, $V = 7$)
contributes $\rho \geq 2^{-7/6} \approx 0.445$ at every $k \equiv 12 \pmod{25}$.
Theorem 3 remains logically valid but its conclusion does not hold: $\rho(L) > 1/4$.
The current best bounds are $2^{-7/6} \leq \rho(L) \leq 1/2$.
\end{remark}


# Discussion

## The Mod-3 Restricted Approach

A natural salvage attempt: restrict the Lipschitz seminorm to pairs within the same
mod-3 class. However, the inverse branches involve division by 3, which scrambles
higher powers of 3. For $x \equiv y \pmod{3}$ but $9 \nmid (x - y)$, the branches
$g_v$ do not preserve mod-3 classes, and the Lipschitz ratio diverges as
$(4/3) \cdot 2^N \|f\|_\infty$. The obstruction propagates to all levels of the 3-adic
filtration.

## Paths Forward

Several approaches may circumvent the obstruction:

1. **Mahler basis / Iwasawa algebra.** The Mahler basis $\binom{x}{n}$ for
$C(\mathbb{Z}_2, \mathbb{Q}_p)$ provides a natural orthonormal system. The action of $L$
on Mahler coefficients may admit a tractable representation that accommodates both
2-adic contraction and the mod-3 structure. The Iwasawa algebra $\Lambda =
\mathbb{Z}_p[\![1 + 2\mathbb{Z}_2]\!]$ provides an alternative framework.

2. **Projective limit.** Theorem 2(e) gives $\sigma(L) = \overline{\bigcup \sigma(P_k)}$
directly, bypassing the need for quasi-compactness. However, case-(a) ghosts DO
persist across levels (they reappear periodically), so exceptional eigenvalues DO
accumulate. The question becomes: what is the supremum of $2^{-V/L}$ over all
case-(a) ghost types?

3. **Baker--W\"ustholz bounds.** Effective lower bounds on $|2^V - 3^L|$ from
transcendence theory bound ghost cycle denominators but do NOT prove $|E| < \infty$.
Case-(a) ghosts (true 2-adic periodic orbits) persist at arithmetic progressions of
levels regardless of $|D|$. Baker bounds exclude case-(b) ghosts (bounded-length,
finite persistence) but not case-(a) ghosts. See companion paper for details.

4. **Thermodynamic formalism.** Inducing schemes (cf.\ Santana, 2025) may provide
alternative routes to spectral gap, working with the natural return map rather than
the global transfer operator.


# Acknowledgments {-}

The author acknowledges substantial use of Claude (Anthropic) for code development, computational exploration, and manuscript drafting. All computational claims are verified by an automated test suite and reproducible from the open-source repository.

# References {-}

\noindent Assani, I. (2024). Collatz Map as a Non-Singular Transformation. *Studia Mathematica* 275.

\noindent Lagarias, J. (1985). The $3x+1$ Problem and Its Generalizations. *American Mathematical Monthly* 92, 3--23.

\noindent Lagarias, J. and Weiss, A. (1992). The $3x+1$ Problem: Two Stochastic Models. *Annals of Applied Probability* 2(1), 229--261.

\noindent Matthews, K. (2010). Generalized $3x+1$ Mappings: Markov Chains and Ergodic Theory. In Lagarias (ed.), *The Ultimate Challenge*, AMS.

\noindent Mori (2024). Application of Operator Theory for the Collatz Conjecture. arXiv:2411.08084.

\noindent Neklyudov, M. (2024). Functional Analysis Approach to the Collatz Conjecture. *Results in Mathematics* 79.

\noindent Siegel, M. (2025). Algebras of $p$-Adic Distributions Induced by Pointwise Products of $F$-Series. arXiv:2507.13358.

\noindent Tao, T. (2022). Almost All Orbits of the Collatz Map Attain Almost Bounded Values. *Forum of Mathematics, Pi* 10, e12.
