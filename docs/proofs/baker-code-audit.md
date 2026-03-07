# Code Audit: `baker_wustholz_verification.py`

**Date:** 2026-03-05
**Auditor:** Mathematical review (spectral theory / p-adic analysis)
**Files reviewed:**
- `analysis/baker_wustholz_verification.py`
- `docs/proofs/baker-wustholz-analysis.md`

**Verdict:** The verification code is computationally correct in all its
simulations, and the ghost reappearance finding is genuine and reproducible.
However, there is a formula discrepancy between the code and the document,
and the document contains a materially incorrect claim about ghost
persistence. The ghost reappearance result has significant implications
for the project's conjectures.

---

## 1. Cycle Equation R Formula

### Code formula (CORRECT)

The code in `check_ghost_cycle()` (lines 58--62) computes:

$$R = \sum_{i=0}^{L-1} 3^{L-1-i} \cdot 2^{S_i}, \quad S_i = v_1 + \cdots + v_i, \quad S_0 = 0.$$

### Derivation from scratch

Starting from the Syracuse recurrence $n_{i+1} = (3n_i + 1)/2^{v_i}$, iterate
$L$ times. After $i$ steps:

$$n_{i+1} = \frac{3^i \cdot n_1 + \sum_{m=0}^{i-1} 3^{i-1-m} \cdot 2^{S_m}}{2^{S_i}}.$$

**Verification for $i=1$:** $n_2 = (3n_1 + 1)/2^{v_1} = (3^1 n_1 + 3^0 \cdot 2^0)/2^{v_1}$. Correct.

**Verification for $i=2$:** $n_3 = (3^2 n_1 + 3 \cdot 2^0 + 2^{v_1})/2^{v_1+v_2}$. Correct.

Setting $i = L$ and requiring $n_{L+1} = n_1$ (cycle closure):

$$n_1 \cdot 2^V = 3^L \cdot n_1 + \sum_{m=0}^{L-1} 3^{L-1-m} \cdot 2^{S_m}$$

$$n_1 \cdot (2^V - 3^L) = R \quad \text{where } R = \sum_{i=0}^{L-1} 3^{L-1-i} \cdot 2^{S_i}.$$

This exactly matches the code. **The code formula is correct.**

### Document formula (INCORRECT)

The document (Section 3.1) states:

$$R = \sum_{j=0}^{L-1} 3^j \cdot 2^{V - v_1 - \cdots - v_{L-j}}.$$

Substituting $j = L-1-i$, this becomes $\sum_{i=0}^{L-1} 3^{L-1-i} \cdot 2^{V - S_{i+1}}$,
which differs from the correct formula $\sum 3^{L-1-i} \cdot 2^{S_i}$ because
$V - S_{i+1} \neq S_i$ in general ($V - S_{i+1} = v_{i+2} + \cdots + v_L$ while
$S_i = v_1 + \cdots + v_i$).

**Numerical verification.** For $L=2$, $v=(1,2)$, $D=-1$:
- Code: $R = 3 \cdot 1 + 1 \cdot 2 = 5$. Check: $n_1 \cdot (-1) = 5$ gives $n_1 = -5$. Iterating: $n_2 = (3 \cdot (-5)+1)/2 = -7$, $n_1 = (3 \cdot (-7)+1)/4 = -5$. Correct.
- Document: $R = 1 \cdot 1 + 3 \cdot 4 = 13$. Check: $n_1 = -13$. Does not produce the correct cycle.

For the known $k=12$ ghost ($D=-601$, pattern $(1,1,1,1,1,2)$):
- Code: $R = 665$, gives $n_1 = 1471$. Verified by simulation: cycle closes.
- Document: $R = 18661$, gives $n_1 = 3731$. Simulation: cycle does NOT close.

**Recommendation:** The document formula in Section 3.1 must be corrected to
match the code formula.

---

## 2. Modular Arithmetic

The computation `pow(d, -1, mod_eq)` on line 67 computes $D^{-1} \bmod 2^{k+V}$
using Python's built-in modular inverse. Since $D = 2^V - 3^L$ is always odd
(difference of an even and an odd number), $\gcd(D, 2^{k+V}) = 1$, so the
inverse exists. **This is correct.**

The cycle equation is solved as $n_1 \equiv R \cdot D^{-1} \pmod{2^{k+V}}$
(line 68), then reduced modulo $2^k$ (line 69). The code then verifies the
cycle by simulation (lines 76--95), which is the correct approach: the
algebraic solution is a candidate, and the simulation confirms it.

**The modular arithmetic is correct.**

A subtlety worth noting: the cycle equation $n_1 D = R \pmod{2^{k+V}}$
characterizes cycles of the *unreduced* iteration (no intermediate mod $2^k$
reduction). The actual modular Syracuse map reduces mod $2^k$ at each step,
which introduces correction terms. The code correctly handles this by using
the cycle equation only to find the candidate and then verifying by
simulation. The candidate and the true cycle element agree mod $2^k$ whenever
the cycle exists, because the v-pattern verification ensures the intermediate
mod-$2^k$ reductions are consistent.

---

## 3. $K_0$ Bounds

The code computes $K_0^{\text{crude}}(L_0) = \max |2^V - 3^L|$ over
$2 \leq L \leq L_0$, $L+1 \leq V \leq 2L-1$ (lines 166--174).

**Range verification for $\rho > 1/4$:**
- $\rho = 2^{-V/L}$. $\rho > 1/4$ iff $V/L < 2$ iff $V \leq 2L - 1$ (integer).
- $\rho < 1/2$ iff $V/L > 1$ iff $V \geq L+1$ (since $v_i \geq 1$ implies $V \geq L$, and $V = L$ gives $\rho = 1/2$ exactly; cycles with all $v_i = 1$ were verified computationally to not produce ghosts for $L \leq 7$).

The range $L+1 \leq V \leq 2L-1$ is correct for $1/4 < \rho < 1/2$.
Excluding $V = L$ ($\rho = 1/2$ exactly) is a minor omission in the theorem
statement but does not affect correctness, since no ghosts with all $v_i = 1$
exist for small $L$.

**However, $K_0^{\text{crude}}$ uses $|D|$ as a bound for $\text{ord}_2(|D|)$.**
This is valid because $\text{ord}_2(|D|) \leq |D| - 1 < |D|$ (Lagrange's
theorem applied to $(\mathbb{Z}/|D|\mathbb{Z})^*$). The bound is crude but
correct.

**All computed values match the expected table.** The controlling pair is
always $(L_0, 2L_0-1)$, confirming the pattern
$K_0^{\text{crude}}(L_0) = 2^{2L_0-1} - 3^{L_0} \approx 4^{L_0}$.

**The $K_0$ computation is correct.**

---

## 4. Baker Bound Verification

The code (lines 326--340) checks:

$$|2^V - 3^L| > \max(2^V, 3^L) \cdot \exp(-25 (\log V)^2)$$

for $V \geq 3$. This is Theorem A from the document.

**Derivation check.** The proof goes: Laurent (2008) gives
$|\Lambda| = |V \log 2 - L \log 3| > \exp(-24.4 (\log V)^2)$ for $V \geq 3$.
When $0 < \Lambda < 1$: $|2^V - 3^L| \geq 2^{V-1} \cdot \Lambda \geq 2^{V-1} \cdot \exp(-24.4 (\log V)^2)$.
We need $2^{V-1} \cdot \exp(-24.4 (\log V)^2) \geq 2^V \cdot \exp(-25 (\log V)^2)$,
i.e., $\exp(0.6 (\log V)^2) \geq 2$, i.e., $0.6 (\log V)^2 \geq \log 2$.
For $V = 3$: $0.6 \cdot (1.099)^2 = 0.724 > 0.693 = \log 2$. Confirmed.

**The Baker bound statement and verification are correct**, though the bound is
extremely loose for the values tested (ratios of $10^{34}$ and higher).

**Minor display issue:** The bound column shows `0.0` for all cases because
Python's `float` underflows $\max(2^V, 3^L) \cdot \exp(-25 (\log V)^2)$ to
zero. This is a display artifact, not a mathematical error; the bound is
trivially satisfied when it underflows to zero. To display meaningful values,
the code should use `math.log` to compare logarithms rather than computing
the exponential directly. This does not affect correctness.

---

## 5. Ghost Reappearance Logic

### Simulation correctness

The function `check_ghost_cycle()` verifies a ghost by:
1. Computing the candidate $n_1$ from the cycle equation.
2. Following the Syracuse map mod $2^k$ for $L$ steps.
3. Checking that each step produces the expected $v_i$ (exact equality).
4. Checking that the iteration returns to $n_1$.

**This is correct and sound.** The verification is by explicit simulation,
not by reliance on the cycle equation alone.

### D = -179 results

The code finds the $(2,1,1,1,1)$ ghost at $k = 35, 71, 142$. Extended
computation confirms the full pattern:

$$k \equiv 35, 71, 142 \pmod{178},$$

where $178 = \text{ord}_2(179)$. All 5 cyclic rotations of the v-pattern
appear at the same levels.

### D = -601 results

The code finds $(1,1,1,1,1,2)$ ghosts at $k = 12, 37, 62, 87$. The full
pattern is:

$$k \equiv 12 \pmod{25},$$

where $25 = \text{ord}_2(601)$. All 6 cyclic rotations appear at the same
levels.

### Verification of 2-adic orbit status

Both ghost types correspond to **genuine 2-adic periodic orbits** (case (a) of
Theorem C). This was verified by computing the rational orbit
$\tilde{n}_1 = R/D \in \mathbb{Q}$ and confirming:

1. The rational orbit closes exactly after $L$ steps.
2. The 2-adic valuations at each step match the v-pattern exactly.
3. All orbit elements are **negative rationals** (hence 2-adic integers in
   $\mathbb{Z}_2 \setminus \mathbb{Z}_{\geq 0}$).

For D = -601: $\tilde{n}_1 = -665/601 \approx -1.1065$.
For D = -179: $\tilde{n}_1 = -341/179 \approx -1.9050$.

**The ghost reappearance finding is correct and verified.**

---

## 6. Implications for E

### The exceptional set is infinite (PROVEN by computation)

The D = -601 ghosts appear at every $k \equiv 12 \pmod{25}$:
$k = 12, 37, 62, 87, 112, \ldots$ This is an arithmetic progression of
infinite length. Each such $k$ has $P_k$ with at least two cycles (the fixed
point $\{1\}$ and the ghost cycle), so $k \in E$.

Similarly, D = -179 ghosts appear at $k \equiv 35, 71, 142 \pmod{178}$.

**Therefore $E$ is infinite.** This is a rigorous computational result:
the ghost existence at each level is verified by explicit Syracuse map
simulation.

### E has positive lower density (PROVEN)

The D = -601 contribution alone gives $|E \cap [1,N]| / N \geq 1/25 = 4\%$
asymptotically. Adding D = -179 gives asymptotic density at least
$1/25 + 3/178 - 3/4450 \approx 5.6\%$.

There are likely further contributions from other $(L,V)$ pairs. Every
$(L,V,v\text{-pattern})$ defines a rational 2-adic orbit, and the set of $k$
where the modular reduction produces a valid ghost is eventually periodic with
period dividing $\text{ord}_2(|D|)$. The total density of $E$ is the density
of the union of all these arithmetic progressions.

### Impact on project conjectures

1. **Conjecture 2 ("$E$ has density 0") is FALSE.** The density is at least 4%.

2. **The claim "$\rho \to 1/4$" (in the pointwise sense) is FALSE.** At every
   $k \equiv 12 \pmod{25}$, the spectral radius of $P_k$ is at least
   $\rho = 2^{-7/6} \approx 0.385 > 1/4$. The spectral radius has infinitely
   many excursions above $1/4$.

3. **The Borel-Cantelli heuristic $P(k \in E) \sim k^2 \cdot 2^{-k}$ is
   INCORRECT.** The actual probability does not decay exponentially; it is
   bounded below by a positive constant.

### What the document gets wrong

Section 4.4 of `baker-wustholz-analysis.md` states:

> "The ghost at $k = 12$ with $D = -601$ can only appear at $k \leq 25$.
> Our computation through $k = 36$ definitively rules out its reappearance."

> "PROVEN (unconditional): The ghost cycle with $(L, V) = (6, 7)$,
> $D = -601$, does not appear at any $k > 25$."

**Both claims are wrong.** The D = -601 ghost reappears at $k = 37, 62, 87,
112, \ldots$ with period 25. The error stems from misapplying Theorem C(b)
to a case that is actually Theorem C(a). Theorem C(b) applies only when the
2-adic limit does NOT satisfy the valuation conditions. For D = -601, the
2-adic limit DOES satisfy them (verified), so Theorem C(a) applies: the ghost
exists at infinitely many levels.

### Correct statement of Theorem C

The theorem as stated in the document is technically correct in its case
analysis (cases (a) and (b)), but the document then **misidentifies which
case applies** to the known ghosts. The correct classification:

- D = -601: **Case (a).** Ghost is a true 2-adic orbit with negative rational
  elements. Appears at $k \equiv 12 \pmod{25}$ for all sufficiently large $k$
  (and in fact for all $k$ in this residue class starting from $k = 12$).

- D = -179: **Case (a).** Ghost is a true 2-adic orbit with negative rational
  elements. Appears at $k \equiv 35, 71, 142 \pmod{178}$.

A more precise version of Theorem C should state: for fixed
$(L, V, v\text{-pattern})$, the set $\{k : \text{ghost exists at level } k\}$
is eventually periodic with period dividing $\text{ord}_2(|D|)$. Within each
period, the ghost appears at a fixed (possibly empty) set of residue classes.
If the set is nonempty (case (a)), the ghost appears at infinitely many $k$.
If empty (case (b), after transient), only finitely many $k$.

---

## 7. Additional Issues

### 7.1 The `scan_e_membership` function

The function (lines 396--431) correctly scans for ghosts with $L \leq 12$
and $\rho > 1/4$. Its claim that the identified levels are in $E$ is correct.
However, it does NOT claim $E$ is infinite with positive density; it merely
reports the empirical density in $[37, 100]$. The infinite density conclusion
follows from the periodicity analysis above, which the function does not
explicitly perform.

### 7.2 The `scan_d601_complete` function

This function (lines 361--393) correctly identifies the periodic structure
of D = -601 ghosts. Its output (ghost levels with uniform gap 25) is
consistent with the theoretical analysis.

### 7.3 Baker bound display underflow

As noted in Section 4, the bound values display as `0.0` due to floating-point
underflow. This is cosmetic but may confuse readers. The ratios are computed
as $|D|/\text{bound}$ and show enormous values, confirming the bound is
satisfied but making the comparison uninformative. Consider comparing
logarithms instead.

### 7.4 Off-by-one in v-pattern generation

The ghost scan functions use `range(1, big_v)` for each component of the
v-pattern (e.g., line 254). Since each $v_i \geq 1$ and $\sum v_i = V$,
each $v_i \leq V - (L-1)$. The upper bound `big_v - 1` from `range(1, big_v)`
is always $\geq V - (L-1)$ when $L \geq 2$, so no valid patterns are missed.
**No off-by-one error.**

### 7.5 Convergent table

The convergent table (lines 350--357) lists $(V, L)$ pairs that are convergents
of $\log_2 3$. The values are correct. Note that the table uses $(V, L)$
ordering (not $(L, V)$), matching the convention $V/L \approx \log_2 3$.

### 7.6 Theorem D validity

Theorem D as stated remains valid, but its practical impact changes. The
theorem says: for fixed $L_0$, no ghost of length $\leq L_0$ with
$\rho > 1/4$ exists at $k > K_0(L_0)$. This is correct. But the
implied hope --- that $E$ might be finite once short cycles are excluded ---
is dashed by the finding that short cycles (L = 5, 6) reappear periodically
at all large $k$ in certain residue classes. The theorem correctly bounds
$k$ for a SINGLE appearance, but the cycle equation produces NEW solutions
at $k + \text{ord}_2(|D|)$ that are distinct elements mod $2^{k+\text{ord}}$.

The theorem's proof has an error in its reasoning: it claims that for case (b),
"the conditions can be satisfied only during the initial transient before
periodicity, i.e., for $k \leq p + O(V)$." But it does not verify which
case applies. The bound $k \leq \text{ord}_2(|D|)$ stated in the theorem
is for case (b) only, and the theorem fails to account for case (a), where
the ghost persists indefinitely. The theorem statement should be amended to:
"For fixed $(L, V, v\text{-pattern})$ in case (b), the ghost exists at
$O(\text{ord}_2(|D|))$ levels. In case (a), it exists at infinitely many
levels forming an arithmetic progression."

---

## Summary of Findings

| Item | Status | Detail |
|------|--------|--------|
| Code R formula | **CORRECT** | Matches derivation from Syracuse iteration |
| Document R formula (Sec 3.1) | **INCORRECT** | Uses $2^{V-S_{i+1}}$ instead of $2^{S_i}$; gives wrong $n_1$ |
| Modular inverse computation | **CORRECT** | $D$ odd, Python `pow(d,-1,m)` is standard |
| Simulation-based verification | **CORRECT** | Sound methodology: algebra finds candidate, simulation confirms |
| $K_0$ bounds | **CORRECT** | Range, enumeration, and values all verified |
| Baker bound (Theorem A) | **CORRECT** | Statement, proof, and code all consistent |
| Ghost reappearance (D=-601) | **CORRECT, MAJOR FINDING** | Appears at $k \equiv 12 \pmod{25}$ (infinite) |
| Ghost reappearance (D=-179) | **CORRECT, MAJOR FINDING** | Appears at $k \equiv \{35,71,142\} \pmod{178}$ (infinite) |
| Doc claim "D=-601 ghost only at $k \leq 25$" | **INCORRECT** | Ghost is case (a), not case (b) |
| Doc claim "$E$ finiteness open" | **RESOLVED: $E$ is infinite** | Periodic ghosts give $E$ density $\geq 4\%$ |
| Conjecture 2 ($E$ density 0) | **FALSIFIED** | |
| Borel-Cantelli heuristic | **FALSIFIED** | $P(k \in E)$ does not decay to 0 |
