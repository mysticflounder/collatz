# Proposed Changes for v3: "Ghost Cycles of the Syracuse Map"

**Date:** 2026-03-12
**Source:** Multi-model AI review (`ai-review-results.md`) + pre-submission reviews v2/v3
**Document:** `docs/arxiv-paper-a.md`

---

## Status

| # | Severity | Issue | Lines | Status |
|---|----------|-------|-------|--------|
| A | **Critical** | Archimedean compactness now proved false — section says "remains open" | 1169–1180 | DONE |
| B | **Important** | Operator definition missing projective limit clarification (prevents GPT Pro class of misread by human referees) | 222–225 | DONE |
| C | **Moderate** | Persistence proof: primitivity not argued — cycle could collapse to shorter period | 703 | DONE |
| D | **Moderate** | Rhetoric: "closing the Mahler/Amice program entirely" overstated | 13, 139 | DONE |
| E | **Minor** | k=1000 described as "scan" not clarified as algebraic membership test | 949 | DONE |
| F | **Minor** | Baker–Wüstholz: "grows superexponentially in V" overstated | 721 | DONE |
| G | **Minor** | n=−1/3 exceptional point not mentioned; "S extends continuously" is loose | 222 | DONE |

---

## A. Archimedean Compactness — Update "Remains Open" to "Proved False"

**Severity:** Critical
**Lines:** 1169–1180
**Source:** Gemini 3 Thinking, Mistral Large (both correctly flagged as weakness); resolved 2026-03-12 per `docs/spectral-limits-analysis.md`

**Current text (lines 1172–1180):**
```
However, $\mathcal{L}$ is bounded on $C(\mathbb{Z}_2^{\mathrm{odd}}, \mathbb{R})$ with
the archimedean sup norm ($\|\mathcal{L}\| = 2/3$), and the question of whether $\mathcal{L}$ is
*compact* on this space remains open. Compactness would imply
$\sigma_{\mathrm{ess}}(\mathcal{L}) = \{0\}$, reducing the spectrum to isolated eigenvalues
accumulating at 0. The Mahler basis is still a Schauder basis for
$C(\mathbb{Z}_2^{\mathrm{odd}}, \mathbb{R})$; the archimedean Mahler matrix
$M_\infty^{\mathrm{arch}}$ is well-defined (the entries converge archimedeanly, even
though they diverge 2-adically), and compactness reduces to uniform archimedean row
decay: $\sup_j |M_\infty^{\mathrm{arch}}[m,j]| \to 0$ as $m \to \infty$.
```

**Proposed replacement:**
```
The 2-adic unboundedness (Theorem~\ref{thm:2adic}) closes the Mahler/Amice program in
the 2-adic setting. The archimedean compactness question is also now resolved:
$\mathcal{L}$ is \emph{not compact} on $C(\mathbb{Z}_2^{\mathrm{odd}}, \mathbb{R})$.
The proof is by non-equicontinuity: for any $r \geq 1$, since the mod-3 splitting
of branches is independent of the 2-adic topology, there exist
$x \equiv 1 \pmod{3}$ and $y \equiv 2 \pmod{3}$ with $|x - y|_2 = 2^{-r}$
but $|(\mathcal{L}f)(x) - (\mathcal{L}f)(y)| = 1$ for the function $f = +1$ on
even-branch preimages of $x$ and $f = -1$ on odd-branch preimages of $y$.
Since $r$ is arbitrary, the image $\{\mathcal{L}f : \|f\|_\infty \leq 1\}$ is not
equicontinuous, so $\mathcal{L}$ is not compact. Both archimedean and 2-adic
obstructions are now closed.
```

---

## B. Operator Definition — Projective Limit Clarification

**Severity:** Important
**Lines:** 222–225 (after the formula for $\mathcal{L}$)
**Source:** GPT Pro ×2 (false positive on mod-3 preimage structure); one clarifying sentence prevents this entire class of misread

**Add remark after the formula** `$(\mathcal{L}f)(n) = \sum_{S(m) = n} 2^{-v_2(3m+1)} f(m)$`:

```
\begin{remark}[Projective limit definition]
$\mathcal{L}$ is the projective limit of the finite transfer matrices $P_k$:
the sum runs over \emph{odd integer} preimages $m \in R_k = \{1, 3, \ldots, 2^k-1\}$
satisfying $S_k(m) \equiv n \pmod{2^k}$, in the limit $k \to \infty$.
Non-integer 2-adic elements are not preimage candidates; equivalently, $m$ ranges
over positive odd integers with $S(m) = n$ in $\mathbb{Z}_2^{\mathrm{odd}}$.
The weight $2^{-v}$ is the contraction factor of the branch $m = g_v(n) = (n \cdot 2^v - 1)/3$.
\end{remark}
```

---

## C. Persistence Proof — Primitivity

**Severity:** Moderate
**Lines:** After line 703 (end of Theorem 5 proof)
**Source:** GPT-5.4 Thinking (exclusive; genuine mathematical gap)

The current proof shows the orbit exists at each level in the arithmetic progression but does not argue that the modular cycle has period exactly $L$ rather than a proper divisor.

**Add remark after the proof's $\square$:**

```
\begin{remark}[Primitivity]
The cycle at each level $k \equiv k_0 \pmod{p}$ has period exactly $L$, not a
proper divisor. The rational orbit elements $\tilde{n}_1, \ldots, \tilde{n}_L$
are distinct: they satisfy the cycle equation with $D \neq 0$ and distinct
step indices, so $\tilde{n}_i - \tilde{n}_j \neq 0$ for $i \neq j$.
Each difference is a nonzero rational with a fixed 2-adic valuation, so
$n_i \bmod 2^k \neq n_j \bmod 2^k$ for all $k > \max_{i \neq j} v_2(\tilde{n}_i - \tilde{n}_j)$.
Since $k_0$ already exceeds this threshold (the cycle materializes at $k_0$
with period $L$), and since $\tilde{n}_i \bmod 2^k$ is periodic in $k$ with
period $p$, the same distinctness holds at all $k \equiv k_0 \pmod{p}$.
\end{remark}
```

---

## D. Rhetoric — Remove "Entirely"

**Severity:** Moderate
**Lines:** Abstract line 13–14; Outline line 139
**Source:** GPT Pro ×2, GPT Thinking, Mistral Large

The result closes the 2-adic function space approach. "Entirely" implies no other approach is viable, which is stronger than what is proved.

**Abstract (line 13–14):**
- Before: `closing the Mahler/Amice program entirely`
- After: `closing the Mahler/Amice program for 2-adic function spaces`

**Outline (line 139):**
- Before: `closing the Mahler/Amice program`
- After: `closing the Mahler/Amice program in the 2-adic setting`

(Contributions list line 90–91 already says "in the 2-adic setting" — this makes all three locations consistent.)

---

## E. k=1000 Scan Clarification

**Severity:** Minor
**Lines:** 949–950
**Source:** GPT-5.4 Thinking

Current text describes an "empirical scan" without clarifying it is algebraic membership testing using known ghost periods, not a new cycle search.

**Add parenthetical** after "through $k = 1000$":

```
(using the algebraic periodicity formula of Theorem~\ref{thm:persistence}:
ghost type $\mathcal{G}$ is present at level $k$ iff
$k \equiv k_0 \pmod{p_{\mathcal{G}}}$; this tests membership in the
known catalogue of ghost types, not an exhaustive search for new cycles)
```

---

## F. Baker–Wüstholz — "Superexponential" Overstatement

**Severity:** Minor
**Line:** 721
**Source:** GPT-5.4 Pro run 2

The Baker–Wüstholz bound gives $|D| > 2^V \cdot \exp(-25(\log V)^2)$, which is quasi-exponential in $V$, not superexponential.

**Line 721:**
- Before: `In particular, $|D|$ grows superexponentially in $V$.`
- After: `In particular, $|D|$ cannot be polynomially small: the bound guarantees $|D| > 2^{V(1-o(1))}$ as $V \to \infty$.`

---

## G. n = −1/3 Exceptional Point

**Severity:** Minor
**Lines:** 222–223
**Source:** GPT-5.4 Pro run 2

"$S$ extends continuously to $\mathbb{Z}_2^{\mathrm{odd}}$" is not quite accurate: $n = -1/3 \in \mathbb{Z}_2^{\mathrm{odd}}$ satisfies $3n+1 = 0$, so $S(-1/3) = 0 \notin \mathbb{Z}_2^{\mathrm{odd}}$. The transfer operator is unaffected ($(\mathcal{L}f)(-1/3) = 0$ since $-1/3$ has no preimages), but the domain claim is loose.

**Add parenthetical** after "extends continuously to $\mathbb{Z}_2^{\mathrm{odd}}$":

```
(with the sole exception $n = -1/3 \in \mathbb{Z}_2^{\mathrm{odd}}$,
where $3n+1 = 0$ and $S$ maps outside the domain;
since $-1/3$ has no preimages under $S$, $(\mathcal{L}f)(-1/3) = 0$
and the operator analysis is unaffected)
```

---

## Notes

- **Not addressed here:** Product formula independence assumption — correctly labeled as open in the paper (Remark after Conjecture 2); no fix needed.
- **Already fixed:** Fredholm determinant degree (confirmed correct in current paper), Kontorovich–Lagarias reference (confirmed correct), sup=limsup in Theorem 1(e) proof (forward reference to Theorem 5 already in place).
- **Eigenfunction $\delta_1$:** GPT Pro flagged this needs careful treatment in the 2-adic setting; assessed as editorial (the clopen set argument in the proof is correct).
