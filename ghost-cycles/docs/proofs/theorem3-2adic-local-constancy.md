# Theorem 3: 2-Adic Local Constancy of the Transfer Matrix

## Introduction

Consider the generalized Collatz map T(n) = (xn + y) / 2^v, where x and y are
odd integers and v counts the factors of 2 in xn + y. The standard Collatz
conjecture is the case x = 3, y = 1.

To study this map, we work modulo 2^k: restrict attention to the 2^{k-1} odd
residue classes mod 2^k and record where each one maps. This gives a finite
transfer matrix P_k(x, y), whose spectral properties (eigenvalues, contraction
rates) capture the map's behavior at "resolution k."

A natural question is: how does this matrix depend on the multiplier x? One
might hope the dependence is polynomial — that would open the door to analytic
continuation techniques. This theorem shows the dependence is fundamentally
different.

**What the theorem says, informally:** The transfer matrix P_k(x, y) depends
only on the last ~2k binary digits of x. If two odd multipliers x and x' agree
in their last M binary digits (where M ≈ 2k), their transfer matrices are
identical — same eigenvalues, same cycles, same contraction rates. Furthermore,
M binary digits is exactly the right cutoff: with even one fewer digit of
agreement, the matrices can differ.

**Why this matters for Collatz research:**

1. **It tells us where to look — and where not to.** A longstanding hope in
   Collatz research is to embed the problem in a continuous family, vary a
   parameter, and use analytic techniques (like analytic continuation) to prove
   convergence. This theorem shows that the spectral data of the transfer
   matrix does not vary smoothly as a function of the multiplier x — it is a
   step function that jumps at 2-adic boundaries. Polynomial interpolation in x
   is the wrong tool. The correct framework is 2-adic analysis.

2. **It identifies the right notion of "nearby" multipliers.** The natural
   notion of closeness for multipliers is 2-adic: agreement in binary digits
   from the right. x = 3 and x = 3 + 2^100 produce the same transfer matrix
   at moderate resolution k, even though they are astronomically far apart as
   real numbers. Conversely, x = 3 and x = 5 differ in their second bit and
   produce different matrices even at k = 3. This means the "neighborhood" of
   x = 3 in the multiplier space is {3, 3 + 2^M, 3 + 2·2^M, ...} — integers
   sharing the same low-order bits — not the interval [2, 4] on the number line.

3. **It makes the spectral radius computable from finite data.** Since the
   matrix depends on x only through x mod 2^M, the spectral radius rho_k(x, y)
   takes finitely many values as x ranges over all odd integers. This reduces
   an infinite-parameter problem to a finite enumeration. For the Collatz case
   (x = 3, y = 1), we show M ≈ 2k, so the matrix at resolution k is determined
   by roughly 2k bits of the multiplier.

4. **It connects to the 2-adic approach.** Recent work (Siegel, arXiv:2507.13358)
   treats Collatz-type maps as iterated function systems on the 2-adic integers
   Z_2. Our result fits naturally into this framework: the transfer matrix is a
   locally constant function on Z_2, which is exactly the class of functions
   that 2-adic analysis is designed to handle.

## Statement

**Theorem.** For fixed k >= 2 and y odd, the map x -> P_k(x, y) is locally constant
in the 2-adic topology on the odd positive integers. That is: for each odd positive
integer x_0, there exists M in N such that

P_k(x, y) = P_k(x_0, y) for all odd positive x with x ≡ x_0 mod 2^M.

The minimal such M is

M(k, x_0, y) = k + V(k, x_0, y),

where V(k, x_0, y) = max{ v_2(x_0 * j + y) : j odd, 1 <= j < 2^k }.

## Definitions

Fix k >= 2, y odd. Let mod = 2^k and N = 2^{k-1}. The odd residues mod 2^k are
R = {1, 3, 5, ..., 2^k - 1}, indexed as r_i = 2i + 1 for i = 0, ..., N-1.

The **transfer matrix** P_k(x, y) is the N x N matrix defined by: for each column
index j (corresponding to odd residue r_j), compute

val_j = x * r_j + y,
v_j  = v_2(val_j),
t_j  = (val_j / 2^{v_j}) mod 2^k,

and set P[idx(t_j), j] = 2^{-v_j}, where idx maps an odd residue to its index.
All other entries in column j are zero.

The matrix is well-defined because x odd, r_j odd, y odd implies val_j is even
(odd * odd + odd = even), so v_j >= 1, and t_j is odd (val_j / 2^{v_j} is odd
by maximality of v_j).

## Proof

We must show: if x ≡ x_0 mod 2^M with M = k + V, then P_k(x, y) = P_k(x_0, y).
Since the matrix is determined column by column, it suffices to show that for each
odd j in R, the pair (v_j, t_j) is the same for x and x_0.

**Setup.** Fix an odd residue j in R. Let

val  = x_0 * j + y,
val' = x * j + y = val + (x - x_0) * j.

Write v = v_2(val), so val = 2^v * q with q odd. The perturbation is

delta = (x - x_0) * j.

Since x ≡ x_0 mod 2^M and j is odd:

v_2(delta) = v_2(x - x_0) + v_2(j) = v_2(x - x_0) >= M.

**Step 1: The valuation is preserved.**

We have val' = val + delta = 2^v * q + delta. Since v_2(delta) >= M > v
(because M = k + V >= k + v, and k >= 2 implies M > v), and v_2(val) = v,
the standard ultrametric identity gives

v_2(val') = v_2(val + delta) = min(v_2(val), v_2(delta)) = v.

(The identity v_2(a + b) = min(v_2(a), v_2(b)) holds whenever v_2(a) != v_2(b).)

Therefore v_j is the same for x_0 and x. In particular, the weight 2^{-v_j} is
unchanged.

**Step 2: The target residue is preserved.**

The target is t = (val / 2^v) mod 2^k. We have:

val' / 2^v = val / 2^v + delta / 2^v = q + delta / 2^v.

Since v_2(delta) >= M = k + V >= k + v, we have v_2(delta / 2^v) >= k. Therefore

delta / 2^v ≡ 0 mod 2^k,

which gives

val' / 2^v ≡ val / 2^v mod 2^k.

So the target t_j mod 2^k is the same for x_0 and x.

**Conclusion.** Since both v_j and t_j are preserved for every column j, the
entire matrix P_k(x, y) is unchanged. This holds for all x with x ≡ x_0 mod 2^M. QED.

## Minimality of M

The bound M = k + V is tight. To see this, consider the column j* that achieves
V = v_2(x_0 * j* + y). Set v* = V and M' = k + v* - 1. Take x = x_0 + 2^{M'}.
Then:

delta = 2^{M'} * j* has v_2(delta) = M' (since j* is odd).

Since M' = k + v* - 1 = v* + (k-1), and v_2(val_{j*}) = v*, we have
v_2(delta) = v* + k - 1. Two cases:

(a) If k >= 2: v_2(delta) = v* + k - 1 > v*, so v_2 is preserved (same argument
    as Step 1). But delta / 2^{v*} has v_2 = k - 1, so

    delta / 2^{v*} ≢ 0 mod 2^k,

    which means the target t_{j*} CHANGES mod 2^k. Therefore P_k(x, y) != P_k(x_0, y).

This shows that no M' < M suffices.

## Bound on V for the Collatz Case

For x = 3, y = 1: V(k, 3, 1) = max{ v_2(3j + 1) : j odd, 1 <= j < 2^k }.

The maximum v_2(3j + 1) over odd j is achieved when 3j + 1 is a power of 2.
Setting 3j + 1 = 2^s gives j = (2^s - 1) / 3, which is an integer iff
2^s ≡ 1 mod 3, i.e., s is even. When s = 2m, j_m = (4^m - 1) / 3.

We verify j_m is always odd. Write j_m = (4^m - 1)/3 = sum_{i=0}^{m-1} 4^i.
Reducing mod 2: 4^i ≡ 0 mod 2 for i >= 1, and the i=0 term is 1, so
j_m ≡ 1 mod 2 for all m >= 1. Explicitly: j_1=1, j_2=5, j_3=21, j_4=85,
j_5=341 — all odd.

The largest j_m in the state space satisfies j_m < 2^k, i.e., (4^m - 1)/3 < 2^k,
giving m < (k + log_2(3)) / 2. So:

V(k, 3, 1) = 2 * floor((k + log_2(3)) / 2)

which gives V ≈ k for large k, and therefore M(k, 3, 1) ≈ 2k.

Explicit values:

| k | V = max v_2 | M = k + V | Worst j |
|---|------------|-----------|---------|
| 3 | 4 | 7 | 5 |
| 4 | 4 | 8 | 5 |
| 5 | 6 | 11 | 21 |
| 6 | 6 | 12 | 21 |
| 7 | 8 | 15 | 85 |
| 8 | 8 | 16 | 85 |
| 9 | 10 | 19 | 341 |
| 10 | 10 | 20 | 341 |

## Corollaries

**Corollary 1.** The Fredholm determinant det(I - z * P_k(x, y)), viewed as a
function of x for fixed k, y, z, is locally constant on the odd 2-adic integers.

*Proof.* The determinant is a continuous function of the matrix entries. Since the
matrix is locally constant in x, so is the determinant.

**Corollary 2.** The spectral radius rho_k(x, y) is locally constant in x
(2-adic topology).

*Proof.* The spectral radius is determined by the matrix entries. Since P_k
is locally constant in x, so is rho_k.

**Corollary 3.** For fixed k and y, the transfer matrix P_k(x, y) depends on x
only through x mod 2^{M(k,x_0,y)} (where M depends on the base point x_0).
Since M <= k + (k + O(1)) ≈ 2k, the spectral radius takes at most
2^{M-1} distinct values as x ranges over odd positive integers.

**Corollary 4 (Non-polynomiality).** The Fredholm coefficients c_j(x) are NOT
polynomial functions of x (for j >= 1).

*Proof.* At k = 3, c_1(x) = -tr(P_3(x, 1)) = 0 for infinitely many odd x
(e.g., x in {9, 19, 41, 47, ...} — 216 values in [1, 1999] alone). These are
the x values where no odd residue mod 8 maps to itself under the Syracuse map.
But c_1(3) = -0.25 != 0. A polynomial with infinitely many roots is identically
zero, contradicting c_1(3) != 0. Hence c_1 is not polynomial.
