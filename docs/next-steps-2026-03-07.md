# Next Steps Assessment: March 7, 2026

**Author:** Mathematical assessment (dynamical systems, spectral theory, $p$-adic analysis)

**Context:** The project has produced three papers, identified 6 case-(a) ghost types,
proved the Lasota-Yorke obstruction, falsified Conjecture 1, and established the
correct spectral picture: $2^{-7/6} \leq \rho(L) \leq 1/2$ on
$C(\mathbb{Z}_2^{\text{odd}})$. Two new ghost types have just been discovered
($D = -1931$ and $D = -6049$). This document identifies the 3--5 most promising
directions, ranked by impact.

---

## Preliminary: What the New Ghosts Tell Us

### D = -1931 ($L = 7$, $V = 8$, $\rho = 0.4529$)

The spectral radius $\rho = 2^{-8/7} \approx 0.4529$ lies strictly between
the previous maximum $2^{-7/6} \approx 0.4454$ (from $D = -601$) and $1/2$.
**This is now the second-largest known $\rho$ among the 6 ghost types** ---
but see the next entry.

Parameters: period $p = 1930$, $r = 5$ residue classes, first appearance $k = 275$.
The period 1930 is large, meaning the density contribution per period is
$5/1930 \approx 0.26\%$ --- modest individually, but the ghost was not detected in
the $[37, 200]$ window because its first appearance is at $k = 275$.

### D = -6049 ($L = 8$, $V = 9$, $\rho = 0.4585$)

**This is the new record holder for spectral radius:** $\rho = 2^{-9/8} \approx 0.4585$.
This exceeds the previous champion $D = -601$ ($\rho \approx 0.4454$) and raises the
proved lower bound on $\rho(L)$ from $2^{-7/6}$ to $2^{-9/8}$.

Parameters: period $p = 1441$, $r = 10$, first appearance $k = 180$.
The 10 residue classes give density contribution $10/1441 \approx 0.69\%$.
The first appearance at $k = 180$ means this ghost WAS within the $[37, 200]$ scan
range but was found only now by the classifier.

**The trend in $V/L$ ratios is significant:**

| $D$ | $L$ | $V$ | $V/L$ | $\rho = 2^{-V/L}$ |
|-----|-----|-----|--------|--------------------|
| $-1675$ | 7 | 9 | 1.2857 | 0.4102 |
| $-5537$ | 8 | 10 | 1.2500 | 0.4204 |
| $-179$ | 5 | 6 | 1.2000 | 0.4353 |
| $-601$ | 6 | 7 | 1.1667 | 0.4454 |
| $-1931$ | 7 | 8 | 1.1429 | 0.4529 |
| $-6049$ | 8 | 9 | 1.1250 | 0.4585 |

The ratio $V/L$ is decreasing along certain ghost types, approaching 1 from above.
Since $V \geq L + 1$ (from $\rho < 1/2$), the minimum possible ratio is $(L+1)/L$,
which converges to 1 as $L \to \infty$. The ghosts $D = -1931$ ($V/L = 8/7$) and
$D = -6049$ ($V/L = 9/8$) both achieve $V = L + 1$, the minimal valuation excess.

**This makes Conjecture B2 (from the post-falsification assessment) significantly
more plausible:** if case-(a) ghosts with $V = L + 1$ exist for arbitrarily large $L$,
then $\rho(L) = 1/2$, and there is no spectral gap on $C(\mathbb{Z}_2^{\text{odd}})$.

### The universal case-(a) finding

The classifier found that ALL compositions are algebraically case-(a) --- the
$v_2$-matching always holds by construction. This requires careful interpretation.
Let me distinguish two things:

1. **Algebraic case-(a):** The rational orbit $\tilde{n}_1 = R/D$ satisfies
   $v_2(3\tilde{n}_i + 1) = v_i$ for all $i$. This is a property of the
   $(L, V, v\text{-pattern})$ triple, checkable by exact rational arithmetic.

2. **Appearance at level $k$:** The ghost actually manifests at a specific level $k$
   in the modular transfer matrix $P_k$.

If "all compositions are algebraically case-(a)" means that for every
$(L, V, v\text{-pattern})$ with $D = 2^V - 3^L < 0$ and $V < 2L$ (i.e., $\rho > 1/4$),
the rational orbit automatically satisfies the valuation conditions, then this would be
a **remarkable structural fact**: there are NO case-(b) ghosts (with $\rho > 1/4$) at all.

**CAUTION:** I am not confident this is what the data shows. The claim may be more
limited --- perhaps it was checked only for specific $(L, V)$ pairs or small cycle
lengths. If it is truly universal, it needs a proof or at least a precise conjecture.
If true, it would simplify the theory significantly: every $(L, V, v\text{-pattern})$
with $V < 2L$ would produce a genuine 2-adic periodic orbit, and the exceptional set
would be determined purely by the appearance schedule of these orbits.

**Action needed:** Clarify the scope of the "all case-(a)" finding. Is it:
(a) all compositions for the 6 known ghost types (specific $(L,V)$ pairs), or
(b) all compositions for all $(L,V)$ with $V < 2L$ up to some $L_{\max}$?
The implications are very different.

### D = -1675 has 3 rotation classes

This means the $L = 7$ cycle with $v$-pattern $(1,1,1,1,1,1,3)$ has 3 distinct
cyclic rotations that each appear at different residue classes modulo the period.
Previously this was recorded as $r = 3$. The new finding refines this: the 3
residue classes are NOT all equivalent under rotation but represent 3 genuinely
distinct modular realizations. This is consistent with the general theory (a cycle
of length $L$ has up to $L$ distinct rotations, and each rotation may appear at
different levels $k$).

---

## Ranked Directions

### Direction 1: Determine Whether $\rho(L) = 1/2$ (Highest Impact)

**What to do.** Systematically search for case-(a) ghosts with $V = L + 1$ for
$L = 9, 10, 11, \ldots, 20$ (and further if feasible). For each such $(L, V)$:

1. Compute $D = 2^{L+1} - 3^L$.
2. Enumerate or sample $v$-patterns (compositions of $L+1$ into $L$ parts, each
   $\geq 1$). These are very constrained: exactly one $v_i = 2$ and the rest
   $v_i = 1$.
3. For each such pattern, compute $R$ and check the case-(a) valuation conditions
   on $\tilde{n}_1 = R/D$.
4. If case-(a), compute $\text{ord}_2(|D|)$ and identify the first level $k$ where
   the ghost appears.

**Why it matters.** This directly addresses Conjecture B2: does $\rho(L) = 1/2$?

- If YES (case-(a) ghosts with $V = L+1$ exist for all $L$): then $\rho(L) = 1/2$,
  meaning $L$ has **no spectral gap** on $C(\mathbb{Z}_2^{\text{odd}})$. This would
  be a definitive negative result for the spectral approach on this Banach space.
  It would force any future spectral work to use a different function space that
  distinguishes positive-integer orbits from 2-adic ghost orbits.

- If NO (case-(a) ghosts with $V = L+1$ stop existing beyond some $L_0$): then
  $\rho(L) = 2^{-(L_0+1)/L_0} < 1/2$, and there IS a spectral gap (albeit small).
  This would be the first nontrivial upper bound on $\rho(L)$.

The $V = L + 1$ case is special because the compositions are trivial: exactly $L$
patterns (choose which position gets $v_i = 2$). So the search is $O(L)$ per
$(L, V)$ pair, not exponential. This makes it very efficient.

**What theorem/conjecture it advances.** Resolves (or strongly constrains)
Conjecture B from the post-falsification assessment. Updates the spectral radius
bounds in Paper 2.

**Difficulty.** Straightforward computation. The main subtlety is that $|D|$ grows
as $\sim 3^L$ for the $V = L+1$ family (since $2^{L+1} < 3^L$ for $L \geq 2$), so
$\text{ord}_2(|D|)$ can be enormous. Computing $\text{ord}_2$ of a number with
hundreds of digits requires modular exponentiation, which is feasible but may need
careful implementation for $L \geq 15$.

**Dependencies.** None. Can proceed immediately.

**SPECIFICATION FOR COMPUTATION:**

```
For L in range(9, 21):
    V = L + 1
    D = 2**V - 3**L   # This is negative for L >= 2
    abs_D = abs(D)

    # There are exactly L v-patterns: (2,1,...,1), (1,2,1,...,1), ..., (1,...,1,2)
    for position in range(L):
        v_pattern = [1]*L
        v_pattern[position] = 2

        # Compute R = sum_{i=0}^{L-1} 3^{L-1-i} * 2^{S_i}
        # where S_0 = 0, S_i = v_1 + ... + v_i
        R = 0
        S = 0
        for i in range(L):
            R += 3**(L-1-i) * 2**S
            S += v_pattern[i]

        # Compute rational orbit
        from fractions import Fraction
        n_tilde = Fraction(R, D)

        # Check case-(a): v_2(3*n_tilde_i + 1) == v_i for all i
        current = n_tilde
        is_case_a = True
        for i in range(L):
            val = 3 * current + 1
            # val is a Fraction; compute v_2 of numerator
            num = val.numerator
            if num == 0:
                is_case_a = False; break
            actual_v = 0
            while num % 2 == 0:
                actual_v += 1
                num //= 2
            if actual_v != v_pattern[i]:
                is_case_a = False; break
            current = val / 2**v_pattern[i]

        if is_case_a:
            # Compute ord_2(|D|) = multiplicative order of 2 mod |D|
            # Check that current == n_tilde (orbit closes)
            rho = 2**(-V/L)
            print(f"Case-(a) ghost: L={L}, V={V}, D={D}, "
                  f"pos={position}, rho={rho:.6f}")

    # Report: does any v-pattern produce case-(a)?
```

Output: table of all case-(a) ghost types with $V = L+1$, their $\rho$ values,
and (if feasible) their periods $\text{ord}_2(|D|)$.

---

### Direction 2: Updated Density Model for $E$ with 6 Ghost Types (High Impact)

**What to do.** Recompute the inclusion-exclusion density formula from Conjecture E
(post-falsification assessment) using all 6 known ghost types. Then compare with an
extended empirical scan.

Specifically:

1. For each of the 6 ghost types, tabulate $(D, p, r)$ precisely:

   | $D$ | $L$ | $V$ | $p = \text{ord}_2(|D|)$ | $r$ | Density contribution $r/p$ |
   |-----|-----|-----|-------------------------|-----|---------------------------|
   | $-179$ | 5 | 6 | 178 | 3 | 1.69% |
   | $-601$ | 6 | 7 | 25 | 1 | 4.00% |
   | $-1675$ | 7 | 9 | 660 | 3 | 0.45% |
   | $-1931$ | 7 | 8 | 1930 | 5 | 0.26% |
   | $-5537$ | 8 | 10 | 84 | 2 | 2.38% |
   | $-6049$ | 8 | 9 | 1441 | 10 | 0.69% |

2. Compute the inclusion-exclusion density, accounting for common factors in periods:
   $$\delta(E) = 1 - \prod_{\mathcal{G}} \left(1 - \frac{r_{\mathcal{G}}}{p_{\mathcal{G}}}\right) + (\text{corrections for non-coprime periods}).$$

3. Extend the empirical scan of $E$ to $k = 500$ or $k = 1000$ using ghost-type
   enumeration (not exhaustive cycle search). For each $k$ in range, check all
   6 known ghost types plus a search for new ones up to $L_{\max} = 12$.

4. Compare predicted vs. empirical density.

**Why it matters.** The density of $E$ is the most concrete open question from the
falsification. With 6 ghost types, the predicted density should be closer to the
empirical value than the previous 4-type estimate ($\approx 8.3\%$ vs. empirical
$\approx 12\%$). The gap between predicted and empirical reveals how many
undiscovered ghost types remain.

Preliminary estimate with 6 types (assuming coprime periods):
$$\delta(E) \geq 1 - \frac{24}{25} \cdot \frac{175}{178} \cdot \frac{657}{660} \cdot \frac{1925}{1930} \cdot \frac{82}{84} \cdot \frac{1431}{1441}$$

Computing: $\frac{24}{25} = 0.960$, $\frac{175}{178} \approx 0.9831$,
$\frac{657}{660} \approx 0.9955$, $\frac{1925}{1930} \approx 0.9974$,
$\frac{82}{84} \approx 0.9762$, $\frac{1431}{1441} \approx 0.9931$.

Product $\approx 0.960 \times 0.9831 \times 0.9955 \times 0.9974 \times 0.9762 \times 0.9931 \approx 0.912$.

So $\delta(E) \geq 1 - 0.912 \approx 8.8\%$, still below the empirical $12\%$.

**Implication:** There are likely additional ghost types not yet discovered,
perhaps with large $L$ or large first-appearance $k$. The gap between the model
prediction ($\sim 8.8\%$) and the empirical density ($\sim 12\%$) quantifies our
ignorance.

**What theorem/conjecture it advances.** Conjecture A (density of $E$) and
Conjecture E (decomposition formula).

**Difficulty.** Straightforward computation. The empirical scan to $k = 500$
requires checking each ghost type algebraically (fast) plus searching for new
types with $L \leq 12$ (feasible but slower).

**Dependencies.** The exact $(p, r)$ values for $D = -1931$ and $D = -6049$
must be confirmed. (The values stated in the problem context should be verified
computationally.)

**SPECIFICATION:** Extend Specification 7.1 from the post-falsification assessment
to $K = 500$ and $K = 1000$, with all 6 ghost types. Also search for new ghost types
with $9 \leq L \leq 12$ in the same $k$-range. Report the density
$|E \cap [2, K]| / K$ at each milestone and compare with the 6-type model prediction.

---

### Direction 3: Prove or Disprove "All Compositions Are Case-(a)" (High Impact, Hard Analysis)

**What to do.** Investigate whether, for all $(L, V)$ with $V < 2L$ (i.e.,
$\rho > 1/4$) and $D = 2^V - 3^L$, EVERY composition of $V$ into $L$ positive parts
produces a case-(a) ghost (i.e., the rational orbit $R/D$ satisfies the exact
valuation conditions).

Step 1: Computational survey. For all $(L, V)$ with $2 \leq L \leq 15$ and
$L + 1 \leq V \leq 2L - 1$, enumerate all $\binom{V-1}{L-1}$ compositions and
check the case-(a) condition. Report the fraction that are case-(a).

Step 2: If all are case-(a), attempt to prove this algebraically. The key identity
to establish would be:

> For $D = 2^V - 3^L$ with $V < 2L$, and for any composition
> $(v_1, \ldots, v_L)$ of $V$ with each $v_i \geq 1$, the rational number
> $\tilde{n}_i = R_i / D$ satisfies $v_2(3\tilde{n}_i + 1) = v_i$ for all $i$,
> where $R_i$ is determined by the cycle equation.

This would require showing that the numerator of $3\tilde{n}_i + 1$ (after
reducing to lowest terms) has 2-adic valuation exactly $v_i$, not more. The
"exactly" part is the hard constraint.

Step 3: If some are NOT case-(a), characterize which fail. This might reveal a
pattern (e.g., case-(b) only for certain $V/L$ ranges, or only when $|D|$ has
specific factorization properties).

**Why it matters.** If true, this would be a major simplification:

- **Every** $(L, V, v\text{-pattern})$ with $\rho > 1/4$ produces a genuine 2-adic
  periodic orbit.
- The exceptional set $E$ is determined entirely by the appearance schedules of these
  orbits (no case-(b) transients to worry about).
- The density formula from Conjecture E becomes exact (no case-(b) corrections).
- Combined with Direction 1: if case-(a) ghosts with $V = L + 1$ exist for all $L$,
  and all compositions are case-(a), then there are infinitely many ghost types
  with $\rho \to 1/2$, and $\rho(L) = 1/2$ definitively.

If false, the counterexamples would also be informative: they would reveal the
algebraic obstruction to case-(a) persistence.

**What theorem/conjecture it advances.** Would establish a new theorem (or conjecture)
about the universal case-(a) property, replacing the old case-(a)/case-(b)
dichotomy with a simpler picture.

**Difficulty.** The computational survey (Step 1) is straightforward for $L \leq 12$.
For $L = 15$, the number of compositions $\binom{28}{14} \approx 4 \times 10^7$
is large but feasible. A proof (Step 2) would likely require algebraic manipulation
of the cycle equation in $\mathbb{Q}$ --- this is hard analysis, possibly requiring
new ideas about the 2-adic structure of the numerators $3R_i + D$.

**Dependencies.** Clarification of what the classifier actually checked (see the
caution in the Preliminary section above).

**SPECIFICATION FOR COMPUTATION:**

```
For L in range(2, 16):
    for V in range(L+1, 2*L):
        D = 2**V - 3**L
        total_compositions = 0
        case_a_count = 0

        # Enumerate compositions of V into L parts, each >= 1
        for v_pattern in compositions(V, L):
            total_compositions += 1

            # Compute R and check case-(a) condition
            # (same algorithm as Direction 1 spec)
            ...

            if is_case_a:
                case_a_count += 1

        fraction = case_a_count / total_compositions
        print(f"L={L}, V={V}, D={D}: {case_a_count}/{total_compositions} "
              f"= {fraction:.4f} are case-(a)")
```

Output: table of $(L, V, D)$ with the fraction of compositions that are case-(a).
If any entry is $< 1.0$, report the failing compositions explicitly.

---

### Direction 4: Reformulate the Spectral Approach on a Ghost-Adapted Space (Hardest, Potentially Transformative)

**What to do.** The central obstacle is now clear: $L$ on $C(\mathbb{Z}_2^{\text{odd}})$
has $\rho(L) \geq 2^{-9/8}$ (and likely $= 1/2$) because ghost cycles with negative
rational elements contribute to the spectrum. The Collatz conjecture concerns only
positive-integer trajectories. We need a function space or a modified operator that
"filters out" the ghost contributions.

Three concrete approaches:

**(A) Restriction to positive integers.** Work on $\ell^{\infty}(\mathbb{Z}_{>0}^{\text{odd}})$
with the discrete topology. The operator $L$ is well-defined here:
$(Lf)(n) = \sum_{S(m)=n} 2^{-v_2(3m+1)} f(m)$, where the sum is over positive odd
preimages only. Ghost cycle eigenfunctions are supported on negative rationals, so they
do not contribute to the spectrum on this space. The question: what is $\rho(L)$ on
$\ell^{\infty}(\mathbb{Z}_{>0}^{\text{odd}})$?

**Problem:** This space is not separable, has no useful compactness, and the finite
approximations $P_k$ do not naturally project onto it (because modular reduction mixes
positive and negative 2-adic integers). The projective limit theorem
$\sigma(L) = \overline{\bigcup \sigma(P_k)}$ would not hold.

**(B) Signed weight operator.** Modify $L$ by incorporating the sign of the orbit elements.
Define $L_+(f)(n) = \sum_{S(m)=n} 2^{-v} \cdot \mathbf{1}_{m > 0} \cdot f(m)$ (sum over
positive preimages only). On $\mathbb{Z}_2^{\text{odd}}$, "positive" is not a 2-adically
continuous property, so $L_+$ is not continuous on $C(\mathbb{Z}_2^{\text{odd}})$. But
it IS well-defined on locally constant functions (since for each $k$, one can decide
which residue classes mod $2^k$ correspond to which positive integers up to $2^k$).

**Problem:** The resulting operator is not a transfer operator in the classical sense
(it breaks the Markov property). Its spectral theory is unclear.

**(C) Mahler basis approach.** Represent $f \in C(\mathbb{Z}_2, \mathbb{Q}_p)$ in the
Mahler basis $\binom{x}{n}$. The action of $L$ on Mahler coefficients may have a
tractable matrix representation. The key advantage: the Mahler basis respects both
the 2-adic topology (it is an orthonormal basis for $C(\mathbb{Z}_2)$) and the
polynomial structure of the map $n \mapsto 3n+1$. The obstruction from the mod-3
dependence of $W(n)$ might become a tractable algebraic condition in Mahler coordinates.

This is the approach flagged in the working notes as "most promising path forward."

**Why it matters.** If Direction 1 confirms $\rho(L) = 1/2$ on
$C(\mathbb{Z}_2^{\text{odd}})$, then any further progress on the Collatz conjecture
via spectral methods REQUIRES a new function space. This direction is the necessary
response to a potential definitive negative result from Direction 1.

If $\rho(L) < 1/2$ (Direction 1 finds that case-(a) ghosts with $V = L+1$ stop
beyond some $L_0$), then this direction is still valuable: the spectral gap
$1/2 - \rho(L)$ exists but is tiny, and understanding its origin requires the
same deeper analysis.

**What theorem/conjecture it advances.** Question 4 from the post-falsification
assessment (Section 6.2): what is $\rho(L)$ on a Collatz-relevant function space?

**Difficulty.** Open problem. The Mahler basis approach (C) is the most concrete, but
even computing $L$ in Mahler coordinates for small truncations is nontrivial. This is
a research program, not a single computation.

**Dependencies.** Logically independent, but Direction 1 determines the urgency.
If $\rho(L) = 1/2$, this direction becomes mandatory.

---

### Direction 5: Extended Ghost Census and Structure Theory (Medium Impact, High Feasibility)

**What to do.** Systematically catalog ghost types for $L \leq 12$ across all
$(L, V)$ with $\rho > 1/4$. For each type found:

1. Record $(L, V, D, \tilde{n}_1, p, r, \rho, \text{first } k)$.
2. Verify the $v$-pattern structure. The known ghosts all have the form
   $(1, \ldots, 1, V-L+1)$ up to rotation. Does this pattern persist?
3. Check whether $D$ is prime or composite. The known denominators:
   $-179$ (prime), $-601$ (prime), $-1675 = -5^2 \times 67$,
   $-1931$ (prime), $-5537$ (prime), $-6049$ (unknown factorization).
   Is primality of $D$ correlated with being case-(a)?
4. For each ghost type, compute $\tilde{n}_1 = R/D$ and verify that all orbit
   elements are negative rationals (testing Conjecture D / Conjecture 3 of
   Paper 3).

**Additional structural questions to probe:**

- **All $v$-patterns have the form $(1, \ldots, 1, V-L+1)$.** Is this universal?
  If so, WHY? The pattern says: all steps have minimal valuation ($v = 1$) except
  one step where all the "excess" concentrates. This is related to the constraint
  $V > L$ (for $\rho < 1/2$): if $V = L + e$ with $e \geq 1$, exactly one step
  absorbs the excess $e$. But compositions with two or more excess steps
  (e.g., $(2, 2, 1, \ldots, 1)$) are also valid. Why don't they produce case-(a)
  ghosts? If this pattern is universal, it dramatically constrains the ghost census:
  for each $(L, V)$, there are only $L$ candidate patterns (choose which position
  gets the excess), not $\binom{V-1}{L-1}$.

  **IMPORTANT CAVEAT:** The new finding that "all compositions are case-(a)" (if
  confirmed) would contradict the claim that only $(1, \ldots, 1, V-L+1)$ patterns
  appear. If all compositions are case-(a), then patterns like $(2, 2, 1, \ldots, 1)$
  are also genuine 2-adic orbits. The question then becomes: which patterns produce
  ghosts that actually APPEAR at levels $k \leq K$ for accessible $K$? The
  $(1, \ldots, 1, V-L+1)$ patterns may simply be the ones with the smallest
  first-appearance level.

- **Rotation classes.** For each ghost type, how many of the $L$ cyclic rotations
  appear, and do they appear at the same or different levels? The finding that
  $D = -1675$ has 3 distinct rotation classes suggests this is nontrivial.

**Why it matters.** A complete census drives the density model (Direction 2), informs
the spectral radius question (Direction 1), and may reveal patterns that guide the
theoretical analysis (Direction 3).

**What theorem/conjecture it advances.** Conjectures A, C, D, and E.

**Difficulty.** Straightforward computation for $L \leq 10$. For $L = 11, 12$,
the number of compositions grows but remains manageable with sampling.

**Dependencies.** None. Can proceed in parallel with all other directions.

**SPECIFICATION:** Extend Specification 7.2 from the post-falsification assessment.
For each $(L, V)$ with $2 \leq L \leq 12$, $L + 1 \leq V \leq 2L - 1$:
enumerate all compositions, check case-(a), and for case-(a) ghosts, compute
$(D, p, r, \rho, \tilde{n}_1, \text{first } k, \text{sign of elements})$.
Report:
- Total number of case-(a) types found.
- Fraction of compositions that are case-(a) (cf. Direction 3).
- Whether the $v$-pattern $(1, \ldots, 1, V-L+1)$ accounts for all appearing ghosts
  or just the first-appearing ones.
- Whether all orbit elements are negative (Conjecture D).

---

## Summary Table

| Rank | Direction | Impact | Difficulty | Dependencies |
|------|-----------|--------|------------|-------------|
| 1 | $V = L+1$ ghost search ($\rho(L) = 1/2$?) | Highest | Straightforward computation | None |
| 2 | Updated density model (6 ghost types) | High | Straightforward computation | Verify $(p,r)$ for new ghosts |
| 3 | Universal case-(a) property | High | Hard analysis (proof); straightforward (survey) | Clarify classifier scope |
| 4 | Ghost-adapted function space | Potentially transformative | Open problem | Direction 1 determines urgency |
| 5 | Extended ghost census | Medium | Straightforward computation | None |

**Recommended execution order:** Directions 1, 2, and 5 can proceed in parallel
immediately. Direction 3 (computational survey) can also run in parallel. Direction 4
is a theoretical research program that should begin once Direction 1 is resolved.

---

## Implications for the Papers

### Updates needed for Paper 3 (Ghost Cycles)

1. **Table 3** (known case-(a) ghost types): add $D = -1931$ and $D = -6049$.
2. **Conjecture 2** (spectral radius): update the lower bound from $2^{-7/6}$ to
   $2^{-9/8}$. The statement becomes
   $\limsup_{k \to \infty} \rho_k \geq 2^{-9/8} \approx 0.4585$.
3. **Conjecture 1** (density of $E$): update the lower bound from $\geq 8.3\%$ to
   $\geq 8.8\%$ (with 6 ghost types).
4. **Abstract and Introduction**: the narrative shifts from "4 known ghost types" to "6 known
   ghost types with $\rho$ values approaching $1/2$."
5. **Discussion section**: add the observation that $V/L \to 1$ along the new ghosts,
   and the implication for $\rho(L)$.

### Updates needed for Paper 2 (Transfer Operator)

1. **Remark after Theorem 3**: update the spectral radius bounds from
   $2^{-7/6} \leq \rho(L) \leq 1/2$ to $2^{-9/8} \leq \rho(L) \leq 1/2$.
2. **Discussion of paths forward**: add the Mahler basis approach as a concrete
   research direction, motivated by the ghost-adapted space problem.

---

## What NOT to Do

1. **Do not attempt to prove $\rho(L) = 1/2$ theoretically before the computational
   evidence is in.** Direction 1 will determine whether this is true within days.
   A premature theoretical argument would risk the same fate as the Borel-Cantelli
   heuristic.

2. **Do not try to salvage the Lasota-Yorke approach on a different Banach space
   without first understanding why it fails.** The obstruction is fundamental (mod-3
   oscillation at every 2-adic scale). Any proposed replacement space must explicitly
   address how it handles the mod-3 structure. The Mahler basis is promising precisely
   because it does this.

3. **Do not claim the Collatz conjecture is affected by $\rho(L) = 1/2$ (if true).**
   Ghost cycles have negative rational elements. They obstruct the spectral approach
   on $C(\mathbb{Z}_2^{\text{odd}})$ but say nothing about positive-integer trajectories.
   The Collatz conjecture remains as open as before.

4. **Do not extrapolate the density formula beyond its domain.** The inclusion-exclusion
   formula assumes that the arithmetic progressions for distinct ghost types are
   "sufficiently independent." With 6 types, common factors in periods
   (e.g., $\gcd(25, 660) = 5$) make the coprime assumption approximate. Compute
   exact overlaps before quoting a predicted density.
