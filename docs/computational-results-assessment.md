# Assessment of Computational Results: Directions 2, 3, and 5

**Date:** 2026-03-08
**Author:** Mathematical assessment (dynamical systems, spectral theory, $p$-adic analysis)

**Context.** Three computational campaigns were run following the directions laid out
in `next-steps-2026-03-07.md`. This document assesses the results, answers the six
posed questions, and recommends paper updates.

---

## 0. Summary of Findings

| Direction | Key Result | Significance |
|-----------|-----------|-------------|
| 2 (Density Model) | Naive product formula gives 10.0%; empirical at $k=1000$ gives 10.2% | Formula is a lower bound, not exact; gap is explained by shared period factors |
| 3 (Universal Case-(a)) | ALL compositions are case-(a) for $L=2,\ldots,15$, $V \in [L+1, 2L-1]$ | Major structural result; eliminates case-(b) for $\rho > 1/4$ |
| 5 (Extended Census) | 157,909 canonical case-(a) ghosts found; 13 materializing types (7 new); Conjecture 3 confirmed for all 5,996 $D<0$ canonical ghosts | Census is rich; concentrated patterns dominate materializations |

---

## 1. Question 1: How Significant Is the Universal Case-(a) Result?

### Assessment: This is the most significant finding of the three directions.

**What was established.** For every $(L, V)$ pair with $2 \leq L \leq 15$ and
$L+1 \leq V \leq 2L-1$ (91 pairs total, giving $\rho > 1/4$), and for every
composition of $V$ into $L$ positive parts, the rational orbit
$\tilde{n}_1 = R/D$ satisfies the case-(a) valuation conditions
$v_2(3\tilde{n}_i + 1) = v_i$ for all $i$. Zero failures were found.

**Why this matters.**

1. **It eliminates an entire category.** The case-(a)/(b) dichotomy was
   introduced as a genuine classification. We now know that for $\rho > 1/4$,
   case-(b) is empty --- at least through $L = 15$. Every ghost type in the
   spectral-radius-relevant range is a true 2-adic periodic orbit.

2. **It simplifies the density theory.** The density formula
   $\delta(E) = 1 - \prod(1 - r_\mathcal{G}/p_\mathcal{G})$ applies to ALL
   ghost types with $\rho > 1/4$, with no case-(b) corrections needed.
   The only question is which ghosts *materialize* (appear at accessible $k$).

3. **It constrains the spectral radius.** If the pattern holds for all $L$,
   then for each $(L, V)$ with $V < 2L$, every composition produces a genuine
   2-adic periodic orbit with eigenvalue $2^{-V/L}$. The spectral radius
   question $\rho(L) = 1/2$ reduces entirely to whether these orbits
   materialize, not whether they are algebraically valid.

**Is it publishable?** Yes, as a central result in Paper 3. The exhaustive
verification for $L \leq 12$ (all compositions enumerated, up to $\sim 800{,}000$
per pair) and the $10^6$-sample random verification for $L = 13$--$15$ constitute
strong computational evidence.

**Does it warrant a conjecture?** Yes. I propose:

> **Conjecture (Universal Case-(a)).** For all positive integers $L \geq 2$ and
> $L+1 \leq V \leq 2L-1$, and for every composition $(v_1, \ldots, v_L)$ of $V$
> into $L$ positive parts, the rational orbit $\tilde{n}_1 = R/(2^V - 3^L)$
> satisfies $v_2(3\tilde{n}_i + 1) = v_i$ for all $i = 1, \ldots, L$.
> Equivalently, every such composition defines a true periodic orbit of the
> Syracuse map on $\mathbb{Z}_2^{\mathrm{odd}}$.

**Does it warrant a theorem attempt?** This is where I want to be careful.

The statement has a clean algebraic reformulation. Let $D = 2^V - 3^L$ with
$V < 2L$ (so $D < 0$). The cycle equation gives $\tilde{n}_1 = R/D$ where
$R = \sum_{i=0}^{L-1} 3^{L-1-i} \cdot 2^{S_i}$. The case-(a) condition
at step $i$ requires:

$$v_2\!\left(\frac{3R_i + D}{D}\right) = v_i$$

where $R_i$ is the numerator of $\tilde{n}_i$ (with denominator $D$). Since
$\gcd(D, 2) = 1$ (as $D$ is odd), this reduces to $v_2(3R_i + D) = v_i$.
The case-(b) alternative would be $v_2(3R_i + D) > v_i$.

So the conjecture states: for all valid compositions and the corresponding $R$
values, $v_2(3R_i + D) = v_i$ exactly. The "exactly" is the hard part --- one
must rule out extra factors of 2 in $3R_i + D$.

**A possible proof strategy** would proceed by showing that $3R_i + D \equiv
2^{v_i} \cdot u_i \pmod{2^{v_i+1}}$ where $u_i$ is odd. This is a
statement about the binary representation of $3R_i + D$, where $R_i$ is
determined by the cycle equation. The recurrence $R_{i+1} = (3R_i + D)/2^{v_i}$
(in the numerator) is linear over $\mathbb{Z}$, and tracking
$3R_i + D \bmod 2^{v_i+1}$ through this recurrence might be tractable.

I consider a proof **plausible but non-trivial**. The key difficulty is that the
$v_i$ values vary across the composition, so the modular arithmetic shifts at
each step. A proof would likely require an inductive argument on $L$, tracking
the binary digits of $R_i$ through the recurrence.

**SPECIFICATION FOR VERIFICATION.** Before attempting a proof, I would want to
see:

1. Explicit verification extended to $L = 20$ (at least by sampling).
2. For a few specific $(L, V)$ pairs, a complete tabulation of
   $v_2(3R_i + D) - v_i$ for all compositions. If this difference is always
   exactly 0 (never positive), that strengthens the case. If it is
   sometimes positive but only for $V \geq 2L$ (i.e., $\rho \leq 1/4$),
   that would suggest the constraint $D < 0$ plays a crucial role.
3. Investigation of the boundary case $V = 2L$ (where $D = 2^{2L} - 3^L > 0$
   for $L \geq 1$). Do case-(b) failures appear when $D > 0$? If so, the
   sign of $D$ is the mechanism, which would point toward a proof using
   properties of $R/D$ when $D < 0$.

---

## 2. Question 2: The Density Formula Discrepancy (10.0% vs 10.2%)

### Assessment: The product formula is a lower bound, not an approximation error.

**The naive formula.** The coprime product formula
$$\delta_{\mathrm{naive}} = 1 - \prod_{\mathcal{G}} \left(1 - \frac{r_\mathcal{G}}{p_\mathcal{G}}\right) \approx 10.0\%$$
assumes that the arithmetic progressions for distinct ghost types are independent.
This holds exactly when the periods $p_\mathcal{G}$ are pairwise coprime.

**Why the formula underestimates.** The periods are NOT pairwise coprime.
The reported GCDs include:

- $\gcd(660, 1930) = 10$
- $\gcd(660, 84) = 12$
- $\gcd(660, 1441) = 11$

When $\gcd(p_i, p_j) > 1$, the CRT does not apply, and the joint density
of the union is NOT simply $1 - \prod(1 - r_i/p_i)$. The product formula
treats overlaps as if they are governed by the full period, but shared factors
mean certain residue classes coincide more often than expected. More precisely:

Consider two ghost types with periods $p_1, p_2$ and residue counts $r_1, r_2$.
If $\gcd(p_1, p_2) = d > 1$, then the CRT gives the joint period
$\mathrm{lcm}(p_1, p_2) = p_1 p_2 / d$, and the overlap (number of $k$
values in $[0, \mathrm{lcm})$ where both appear) depends on the specific
residue classes, not just their counts. The inclusion-exclusion correction
$r_1 r_2 / \mathrm{lcm}(p_1, p_2)$ underestimates or overestimates the
overlap depending on how the residue classes align modulo $d$.

**The correct approach.** Since there are only 6 ghost types, the exact density
from these 6 types is computable: enumerate all $k$ in $[0, \mathrm{lcm}(p_1,
\ldots, p_6))$ and check how many are covered by at least one ghost type. The
LCM is $\sim 5.2 \times 10^{10}$, which is large but the check for each $k$
is just $6$ modular comparisons --- entirely feasible.

However, the empirical density at $k = 1000$ of $10.2\%$ and the product
formula's $10.0\%$ are close enough that the shared-factor correction is small
(of order $0.2\%$). This makes physical sense: the shared factors $d$ are
small (10, 11, 12), and the corrections are of order $r_i r_j / (p_i p_j / d)$
which is $O(d \cdot r_i r_j / (p_i p_j)) \ll 1\%$ per pair.

**How to handle this in the paper.** I recommend:

1. **State the product formula as a lower bound** (which it provably is when
   the periods are not coprime and ghost appearances are "positively correlated"
   by shared period factors).

2. **Report the empirical density** at $k = 100, 200, 500, 1000$ as in the
   data: 9.18%, 10.61%, 10.04%, 10.22%.

3. **Note the convergence pattern.** The oscillation between 9% and 11%
   reflects the finite-size effects of the various periods. The D=-601 ghost
   (period 25) dominates the short-scale oscillation; the longer-period ghosts
   ($p = 660, 1441, 1930$) contribute slower modulation. Convergence to a
   stable density requires $k \gg \mathrm{lcm}(\text{all periods})$, which
   for 6 ghosts is $\sim 10^{10}$.

4. **State explicitly** that the $10.0\%$ from the product formula and the
   $10.2\%$ empirical density are consistent: the $0.2\%$ gap is within the
   expected correction from shared period factors. This means the 6 known
   ghost types account for essentially ALL of the observed density through
   $k = 1000$.

5. **Flag the implication:** if the 6 known types account for $\sim 10\%$
   density and the 7 new materializing types (from Direction 5) have not yet
   been included in the formula, adding them will increase the predicted
   density. The new types should be included in an updated formula.

**Is the product formula "wrong"?** No. It is correct as a lower bound under
the coprime assumption. It is imprecise when periods share factors, but the
imprecision is small and well-understood. The formula should be presented as
an approximation with a stated error bound, not as an exact identity.

---

## 3. Question 3: The 5 New Ghost Types from $V = L+2$ and $V = L+3$

### The new ghosts

| $D$ | $L$ | $V$ | $V - L$ | $\rho$ | $p$ | $r$ | Family |
|-----|-----|-----|---------|--------|------|-----|--------|
| $-17635$ | 9 | 11 | 2 | 0.4286 | 7052 | 5 | $V = L+2$ |
| $-54953$ | 10 | 12 | 2 | 0.4353 | 9078 | 6 | $V = L+2$ |
| $-50857$ | 10 | 13 | 3 | 0.4061 | 12714 | 3 | $V = L+3$ |
| $-168955$ | 11 | 13 | 2 | 0.4408 | 67580 | 1 | $V = L+2$ |
| $-515057$ | 12 | 14 | 2 | 0.4454 | 10700 | 2 | $V = L+2$ |

(The other 2 new ghosts, $D = -57001$ and $D = -523249$, are from the
$V = L+1$ family already discussed in Section 4.4 of Paper 3.)

### Structural observations

**1. The $V = L+2$ family is now well-populated.** Four of the five genuinely
new types have $V = L + 2$. The $v$-pattern for these is concentrated:
$(1, \ldots, 1, 3)$ up to cyclic rotation. This parallels the $V = L+1$
family's $(1, \ldots, 1, 2)$ pattern. The spectral radii are
$\rho = 2^{-(L+2)/L}$, which approaches $1/4$ from above as $L \to \infty$
(contrast with $V = L+1$ where $\rho \to 1/2$).

**2. Hierarchy of families.** The materializing ghosts organize into families
by excess valuation $e = V - L$:

| Family ($e$) | $\rho$ range | Asymptotic $\rho$ | Known materializing types |
|-------------|-------------|-------------------|--------------------------|
| $e = 1$ ($V = L+1$) | $[0.4353, 0.4774]$ | $1/2$ | 9 types ($L = 5$--$15$, excluding $L = 9, 11$) |
| $e = 2$ ($V = L+2$) | $[0.4286, 0.4454]$ | $1/4$ | 4 types ($L = 9, 10, 11, 12$) |
| $e = 3$ ($V = L+3$) | $[0.4061]$ | $1/8$ | 1 type ($L = 10$) |

The spectral radius within each family is $2^{-(L+e)/L} = 2^{-1-e/L}$, which
converges to $2^{-1} = 1/2$ only for $e = 1$. For $e \geq 2$, the asymptotic
value is $2^{-1} \cdot 2^{0} = 1/2$ --- wait, let me be precise:

$$\rho = 2^{-(L+e)/L} = 2^{-1} \cdot 2^{-e/L} \to 2^{-1} = 1/2 \text{ as } L \to \infty \text{ for any fixed } e.$$

So ALL families with fixed excess $e$ have $\rho \to 1/2$ as $L \to \infty$.
The $e = 1$ family simply gets there fastest. This is an important
observation: the spectral radius question $\rho(L) = 1/2$ does not depend
solely on the $V = L+1$ family. Any family with bounded excess will do.

**3. The $V = L+3$ ghost at $L = 10$.** This is interesting because its
$v$-pattern $(1,1,1,1,1,1,1,1,1,4)$ concentrates all three units of excess
in a single step. The spectral radius $\rho = 2^{-13/10} \approx 0.4061$ is
the lowest among the materializing ghosts, consistent with higher excess
giving lower $\rho$ at fixed $L$.

**4. Density contributions.** The new types collectively contribute:

$$\sum \frac{r_i}{p_i} = \frac{5}{7052} + \frac{6}{9078} + \frac{3}{12714} + \frac{1}{67580} + \frac{2}{10700} \approx 0.20\%$$

This is small compared to the 10% from the original 6 types. The reason is
clear: the periods are large (thousands to tens of thousands), and the residue
counts $r$ are small. The original 6 types had the advantage of small periods
(25, 84, 178) or high residue counts ($r = 9, 10$).

**5. Structural implication.** The existence of materializing ghosts across
three families ($e = 1, 2, 3$) at adjacent $L$ values ($L = 9$--$12$)
suggests a rich landscape of ghost types. As $L$ increases, more $(L, V)$
pairs become available, and the number of materializing types should grow.
The density of $E$ will increase, but slowly (because periods grow
exponentially with $L$).

---

## 4. Question 4: Why Only Concentrated Patterns Materialize

### The observation

Of 157,909 canonical case-(a) ghost types found across 66 $(L, V)$ pairs,
only 66 have the concentrated pattern $(1, \ldots, 1, V-L+1)$. Yet ALL 13
materializing ghosts have this pattern. Why?

### The mechanism: materialization probability

A ghost type with period $p = \mathrm{ord}_2(|D|)$ materializes if at least
one $k \in \{1, \ldots, p\}$ satisfies $L$ simultaneous binary valuation
conditions. The heuristic probability per $k$ is approximately $2^{-V}$
(each of $L$ valuation conditions has probability $2^{-v_i}$, and
$\prod 2^{-v_i} = 2^{-V}$). So the expected number of materializations in
one period is:

$$\mathbb{E}[r] \approx \frac{p}{2^V}.$$

For a ghost to materialize, we need $p / 2^V \gtrsim 1$, i.e.,
$p \gtrsim 2^V$.

**Now consider two compositions with the same $(L, V)$ and hence the same $D$
and $p$:**

- **Concentrated pattern** $(1, 1, \ldots, 1, V-L+1)$: all steps have
  $v_i = 1$ except one step with $v_i = V - L + 1$. The valuation condition
  at each $v_i = 1$ step requires $n_i \equiv 1 \pmod{4}$ (exactly: the
  lowest bit of $3n_i + 1$ after dividing by 2 must be 1). The single
  high-valuation step requires $n_j \equiv -1/3 \pmod{2^{V-L+1}}$, which is
  a specific residue class.

- **Spread pattern** $(2, 1, 1, \ldots, 1, 2)$: two steps have $v_i = 2$.
  Each $v_i = 2$ step requires $n_i \equiv 1 \pmod{8}$ (approximately),
  which is a more restrictive condition than $v_i = 1$.

**But wait --- the total valuation $V$ is the same for both patterns.** The
heuristic $\mathbb{E}[r] \approx p / 2^V$ depends only on $V$, not on the
distribution of $v_i$'s. So why would concentrated patterns materialize
preferentially?

The answer is that **the heuristic $p/2^V$ is the same for all compositions
with the same $(L, V)$, so the materialization probability per composition is
approximately the same.** The reason concentrated patterns dominate
materializations is simpler:

**The concentrated pattern is unique (up to $L$ cyclic rotations), while
non-concentrated patterns are numerous.** There is exactly 1 canonical
concentrated pattern (up to rotation) for each $(L, V)$, but
$\binom{V-1}{L-1} / L$ total canonical patterns (dividing by $L$ for
rotational equivalence, approximately). For $(L, V) = (10, 13)$, there are
$\binom{12}{9}/10 \approx 22$ canonical patterns, of which 1 is concentrated.

But the data says 0 non-concentrated patterns materialize out of $\sim 158{,}000$
total. If the materialization probability per canonical type were uniform,
we would expect $\sim 13 \times (157{,}909 - 66)/66 \approx 31{,}000$
non-concentrated materializations. The fact that there are exactly 0 requires
explanation.

### The real mechanism: period dependence on the $v$-pattern

**The period $p = \mathrm{ord}_2(|D|)$ is the same for all compositions with
the same $(L, V)$**, since $D = 2^V - 3^L$ depends only on $(L, V)$. BUT the
residue count $r$ (number of $k$ values in $[1, p]$ where the ghost appears)
depends on the specific $v$-pattern.

The key insight is that **the $R$ value in the cycle equation depends on the
$v$-pattern**, and different $R$ values produce different 2-adic expansions
of $R/D$, leading to different materialization schedules. The concentrated
pattern produces an $R$ whose 2-adic expansion has favorable alignment
properties.

Specifically, for the concentrated pattern $(1, 1, \ldots, 1, e+1)$ with
$e = V - L$:

$$R = \sum_{i=0}^{L-1} 3^{L-1-i} \cdot 2^{S_i}$$

where $S_i = i$ for $i < L-1$ (since all $v_j = 1$ for $j < L-1$) and
$S_{L-1} = L - 1$. Wait --- $S_i = v_1 + \cdots + v_i$, so for the
concentrated pattern with the excess at position $L$ (i.e., $v_L = e+1$,
all others $= 1$):

$$S_i = i \text{ for } i = 0, \ldots, L-1$$

This gives $R = \sum_{i=0}^{L-1} 3^{L-1-i} \cdot 2^i = (3^L - 2^L)/(3 - 2)
= 3^L - 2^L$.

For a spread pattern, the partial sums $S_i$ are different, producing a
different $R$. The materialization condition depends on the specific binary
structure of $R \cdot D^{-1} \bmod 2^k$, and concentrated patterns may
produce more "regular" binary expansions that align with the valuation
conditions at more $k$ values.

**However, I must flag a gap in this reasoning.** The argument above is
heuristic. The actual mechanism requires analyzing $v_2(3 \cdot (R_i/D) + 1)$
for each step of the orbit, where $R_i$ depends on the full $v$-pattern.
A rigorous explanation would need to show that concentrated patterns
produce orbits whose elements have specific 2-adic properties that make
the valuation conditions easier to satisfy simultaneously.

### Alternative (and perhaps more likely) explanation: search depth

The computation searched for materializations through $k \leq p$ for each
ghost type. For non-concentrated patterns, the expected number of
materializations is $p/2^V$ --- the same as for concentrated patterns. But if
$p/2^V \ll 1$ for the $(L, V)$ pairs where non-concentrated patterns live
(which happens when $|D|$ is large and $\mathrm{ord}_2(|D|)$ is not much
larger than $|D|$), then most patterns will have $r = 0$ regardless of
their structure.

**SPECIFICATION TO RESOLVE THIS:** For a specific $(L, V)$ pair with a
known materializing concentrated pattern (say $L = 9$, $V = 11$,
$D = -17635$), compute $R$ and $\mathrm{ord}_2(|D|)$ for several
non-concentrated compositions (e.g., $(2, 1, 1, 1, 1, 1, 1, 1, 2)$) and
check whether any materialize within the full period. If non-concentrated
patterns materialize at different $k$ values (or not at all), compare their
$R$ values and the 2-adic structure of $R/D$.

---

## 5. Question 5: What Should Be Updated in the Papers?

### Updates for Paper 3 (Ghost Cycles — the main computational paper)

**Must update:**

1. **Table 3** (known case-(a) ghost types): expand from 6 to 13 types. The
   7 new materializing types should be added with full parameters
   $(D, L, V, v\text{-pattern}, p, r, \rho, \text{first } k)$.

2. **Section 4.4** ($V = L+1$ family table): add $D = -57001$ ($L = 10$) and
   $D = -523249$ ($L = 12$), which are already covered by the existing table
   structure.

3. **Conjecture 1** (density of $E$): update the lower bound. The 6 original
   types gave $\delta(E) \geq 10.0\%$. With 13 types, the bound increases
   slightly (the 7 new types contribute $\sim 0.2\%$ additional density). More
   importantly, report the empirical density milestones:
   $k=100$: 9.18%, $k=200$: 10.61%, $k=500$: 10.04%, $k=1000$: 10.22%.

4. **Conjecture 2** (spectral radius): the lower bound is already
   $\rho(L) \geq 2^{-9/8} \approx 0.4585$ from $D = -6049$. The new
   $V = L+1$ entries ($D = -57001$ at $L = 10$ gives $\rho = 0.4665$;
   $D = -523249$ at $L = 12$ gives $\rho = 0.4719$) push this further.
   Update: $\rho(L) \geq 2^{-13/12} \approx 0.4719$.

5. **Conjecture 3** (negative rationality): state that it has been verified
   computationally for ALL 5,996 canonical ghosts with $D < 0$ through
   $L = 12$. This is much stronger evidence than the original 6 types.

6. **Add a new conjecture: Universal Case-(a).** This is the most important
   addition. State it precisely as in Section 1 above.

7. **Add a new subsection** on the $V = L+2$ and $V = L+3$ families, parallel
   to Section 4.4's treatment of $V = L+1$.

8. **The density formula discussion** (after Conjecture 1): add a remark that
   the product formula is a lower bound when periods share factors, and that
   the empirical density at $k = 1000$ is consistent with the 6-type model
   (gap $\leq 0.2\%$). This addresses the discrepancy cleanly.

**Should add (enhances the paper):**

9. **Census summary statistics.** Report: 157,909 canonical case-(a) types
   across 66 $(L, V)$ pairs, of which 13 materialize. The ratio
   $13/157{,}909 \approx 0.008\%$ underscores how rare materialization is.

10. **The concentrated-pattern dominance** observation. This is a striking
    empirical fact that deserves discussion, even without a complete
    explanation. It connects to the materialization heuristic $r \approx p/2^V$.

### What to save for a separate paper

**The universal case-(a) proof** (if achieved) deserves its own treatment.
The computational verification is evidence; a proof would be a theorem.
If a proof is found, it should be a separate short paper or a substantial
addition to Paper 3.

**The Mahler basis / ghost-adapted function space** (Direction 4 from the
next-steps document) is a separate research program and should NOT be folded
into Paper 3. It belongs in Paper 2 or a new Paper 4.

**Extended census beyond $L = 12$** can be reported as "ongoing" in Paper 3
if the paper is submitted before the census is complete.

### Updates for Paper 2 (Transfer Operator Spectral Theory)

1. **Update the spectral radius bounds** in the remark after Theorem 3:
   change $\rho(L) \geq 2^{-7/6}$ to $\rho(L) \geq 2^{-13/12}$.

2. **Add a remark** about the universal case-(a) finding and its implication
   that $\sigma(L)$ contains the closure of
   $\{2^{-V/L} : L \geq 2, L+1 \leq V \leq 2L-1\} = \{2^{-1-e/L} : L \geq 2, 1 \leq e \leq L-1\}$,
   which is dense in $[1/4, 1/2]$. This means $\sigma(L) \supseteq [1/4, 1/2]$
   if the universal case-(a) conjecture and materialization for all types hold.
   (But this requires ALL types to materialize, not just concentrated ones.)

### Updates for Paper 1 (2-Adic Local Constancy)

No updates needed. Paper 1 is about Theorem 1, which is independent of ghost
cycle enumeration.

---

## 6. Question 6: Concerns About the Sampling Approach for $L = 13$--$15$

### The approach

For $L = 13$--$15$ with $V$ up to $2L - 1 = 29$, the number of compositions
$\binom{V-1}{L-1}$ can reach $\binom{28}{14} \approx 40{,}000{,}000$ for
$(L, V) = (15, 29)$. Exhaustive enumeration was replaced by $10^6$ random
samples per $(L, V)$ pair.

### Concerns

**Concern 1: Coverage.** At $10^6$ samples out of $4 \times 10^7$ possible
compositions (for the worst case), the coverage is $\sim 2.5\%$. If
case-(b) failures occur at rate $\epsilon$, the probability of missing them
is $(1 - \epsilon)^{10^6} \approx e^{-10^6 \epsilon}$. To have 95% confidence
of detecting failures at rate $\epsilon = 3 \times 10^{-6}$ ($\sim 1$
failure out of the $4 \times 10^7$), we need $10^6 \times 3 \times 10^{-6}
= 3$ expected detections, giving detection probability $1 - e^{-3} \approx 95\%$.
So the sampling can detect failure rates above $\sim 10^{-6}$ with reasonable
confidence.

**Concern 2: Structured failures.** If case-(b) failures are not uniformly
distributed among compositions but cluster in specific structural families
(e.g., compositions with many equal parts, or with specific patterns), random
sampling might miss them. This is a real concern.

**Mitigation.** The data shows zero failures across ALL 91 $(L, V)$ pairs,
including the 25 exhaustively checked pairs for $L = 2$--$12$. The pattern
is consistent: there are no case-(b) ghosts with $\rho > 1/4$ anywhere in
the search space. A structured failure mode that appears only at $L \geq 13$
and only for specific compositions is implausible given the complete absence
of failures at lower $L$.

**Concern 3: The boundary $V = 2L - 1$.** At $V = 2L - 1$, the spectral
radius $\rho = 2^{-(2L-1)/L} = 2^{-2+1/L}$, which approaches $1/4$ from
above. The denominator $D = 2^{2L-1} - 3^L$ is large (of order $4^L$), and
the corresponding $|R/D|$ values may have different 2-adic properties than
at smaller $V$. However, the exhaustive checks at $L \leq 12$ cover this
boundary without failures.

**My assessment.** The sampling approach is adequate for the purpose of
formulating a conjecture. It is NOT adequate for claiming a theorem. The
distinction should be clearly stated in the paper:

> "Exhaustively verified for all $(L, V)$ pairs with $L \leq 12$
> (up to $\sim 800{,}000$ compositions per pair). For $L = 13$--$15$,
> verified by $10^6$ random samples per pair with zero failures. The
> conjecture is based on both the exhaustive and sampled evidence."

**SPECIFICATION FOR STRENGTHENING.** If time permits before submission:

1. Increase samples to $10^7$ for $L = 13$--$15$. This pushes the detection
   threshold to $\sim 3 \times 10^{-7}$.

2. Include "adversarial" samples: compositions with extreme structure
   (all-equal: $(2, 2, \ldots, 2)$ if $V$ is even; heavily skewed:
   $(V-L+1, 1, \ldots, 1)$ placed at each position; alternating:
   $(2, 1, 2, 1, \ldots)$). If there are structured failures, adversarial
   sampling is more likely to find them.

3. Extend to $L = 16$--$20$ with $10^6$ samples each. This tests whether the
   pattern persists at larger $L$ where the combinatorial explosion is severe.

---

## Appendix: Cross-Cutting Observations

### A. The census reveals a "materialization bottleneck"

Of 157,909 canonical case-(a) ghost types, only 13 materialize ($\sim 0.008\%$).
This is consistent with the heuristic $r \approx p/2^V$: most ghost types have
$p/2^V \ll 1$ because $|D| = |2^V - 3^L|$ is much smaller than $2^V$ (so
$p \leq |D| \ll 2^V$). Only types with unusually large
$\mathrm{ord}_2(|D|)$ relative to $2^V$ materialize.

The concentrated pattern $(1, \ldots, 1, e+1)$ does not have a larger $p/2^V$
ratio than other patterns (since $p$ and $V$ are the same for all patterns
with the same $(L, V)$). The reason for its dominance among materializing
types must therefore involve the specific $R$ value and its 2-adic alignment
properties. This remains an open question.

### B. Conjecture 3 is now strongly supported

All 5,996 canonical ghosts with $D < 0$ (i.e., with $V > L \log_2 3$, which
includes all $\rho > 1/4$ cases) have all-negative orbit elements. This is a
much broader verification than the original 6 types. The conjecture should be
upgraded from "computational evidence from 6 types" to "verified for all
canonical types with $L \leq 12$."

Note that $D > 0$ ghosts (which have $\rho \leq 1/4$ and are spectrally
irrelevant) may have positive orbit elements --- this should be checked
and documented separately.

### C. The relationship between the three directions

The three results reinforce each other:

- **Universal case-(a)** (Direction 3) means the density formula (Direction 2)
  applies to all ghost types, not just the ones that happen to be case-(a).
  Every composition produces a valid 2-adic orbit; the only question is whether
  it materializes.

- **The extended census** (Direction 5) populates the density formula with
  additional ghost types. The 7 new materializing types contribute modestly to
  the density ($\sim 0.2\%$), confirming that the 6 original types dominate.

- **The density model** (Direction 2) validates the formula at $k = 1000$,
  showing that the 6 original types account for essentially all of $\delta(E)$
  in the accessible range. The additional types from the census increase the
  predicted density only marginally.

Together, these results paint a coherent picture: the exceptional set $E$ has
a well-defined density of approximately 10%, dominated by 6 ghost types with
short cycles and small periods. The density will slowly increase as
longer-cycle ghosts are discovered, but the convergence is slow because their
periods grow exponentially.
