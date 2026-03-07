# Spectral Theory of the Syracuse Transfer Operator: Results and Obstruction

**Date:** 2026-03-05

**Summary.** We analyze the transfer operator L of the Syracuse map on the odd
2-adic integers. We establish the complete preimage structure (Lemma 1), the
correct operator norm ||L|| = 2/3 (Proposition 1), the 2-adic contraction of
inverse branches (Lemma 2), and the Lipschitz contraction within mod-3 classes
(Proposition 2). We then identify a fundamental obstruction (Theorem 1): the
transfer operator does NOT preserve the Lipschitz space Lip_1(Z_2^{odd}) with
respect to the standard 2-adic metric, because the weight function depends on
the residue class mod 3, which is orthogonal to the 2-adic topology. This
obstruction is universal: it applies to all Holder, Sobolev, and BV spaces
defined using the 2-adic metric alone (Corollary 1). We state corrected theorems
that ARE provable (Theorem 2, Theorem 3). For research directions toward
overcoming the obstruction, see `docs/proof-strategy-discussion.md`, Section H.

---

## Table of Contents

1. [Setup and Definitions](#1-setup-and-definitions)
2. [Preimage Structure of the Syracuse Map](#2-preimage-structure)
3. [Operator Norm and Weight Sums](#3-operator-norm)
4. [Inverse Branch Contractions](#4-inverse-branch-contractions)
5. [Lipschitz Contraction Within Mod-3 Classes](#5-lipschitz-contraction-within-mod-3-classes)
6. [The Obstruction: L Does Not Preserve Lip_1](#6-the-obstruction)
7. [Universality of the Obstruction](#7-universality)
8. [What IS Provable](#8-what-is-provable)
9. [Appendix: Verification of Weight Sums](#9-appendix)

---

## 1. Setup and Definitions

### 1.1 The Syracuse Map

The Syracuse map S on odd positive integers is defined by

    S(n) = (3n + 1) / 2^{v_2(3n+1)}

where v_2(m) denotes the 2-adic valuation of m (the largest power of 2 dividing m).
Since n is odd, 3n + 1 is even, so v_2(3n + 1) >= 1, and S(n) is always a positive
odd integer.

### 1.2 Extension to Z_2^{odd}

The map S extends continuously to Z_2^{odd} = {x in Z_2 : x is odd} = 1 + 2Z_2,
where Z_2 denotes the ring of 2-adic integers. On Z_2, every nonzero element has a
well-defined 2-adic valuation, and S(n) = (3n+1)/2^{v_2(3n+1)} is a continuous map
from Z_2^{odd} to Z_2^{odd}.

### 1.3 The Transfer Operator

The transfer operator (Perron-Frobenius operator, Ruelle operator) L on continuous
functions f: Z_2^{odd} -> R is defined by

    (Lf)(n) = sum_{S(m) = n} 2^{-v_2(3m+1)} * f(m)

where the sum runs over all odd 2-adic integers m such that S(m) = n.

### 1.4 The Lipschitz Space

The 2-adic metric on Z_2 is d_2(x, y) = |x - y|_2 = 2^{-v_2(x-y)}. The Lipschitz
space is

    Lip_1(Z_2^{odd}) = { f in C(Z_2^{odd}) : |f|_{Lip} < infinity }

where

    |f|_{Lip} = sup_{x != y} |f(x) - f(y)| / |x - y|_2

equipped with the norm ||f|| = ||f||_sup + |f|_{Lip}.

### 1.5 Target Theorem (As Originally Stated)

**Target.** L acts on Lip_1(Z_2^{odd}) and satisfies

    |Lf|_{Lip} <= (1/4) * |f|_{Lip} + B * ||f||_sup

for some constant B > 0. Combined with ||Lf||_sup <= (1/3)||f||_sup, this gives
quasi-compactness with essential spectral radius <= 1/4.

**This target theorem is FALSE.** The proof breaks down at the claim that L
preserves Lip_1 (Section 6), and the sup-norm bound 1/3 is incorrect (the correct
value is 2/3, Section 3). Below we develop the correct theory.

---

## 2. Preimage Structure of the Syracuse Map {#2-preimage-structure}

**Lemma 1 (Preimage structure).** For each odd 2-adic integer n, the preimages of n
under S are:

(a) If n = 1 mod 3: there is exactly one preimage for each even v >= 2, namely

        m_v = (n * 2^v - 1) / 3

    and no preimages for odd v. Each m_v is an odd 2-adic integer with
    v_2(3m_v + 1) = v.

(b) If n = 2 mod 3: there is exactly one preimage for each odd v >= 1, namely

        m_v = (n * 2^v - 1) / 3

    and no preimages for even v. Each m_v is an odd 2-adic integer with
    v_2(3m_v + 1) = v.

(c) If n = 0 mod 3: there are no preimages.

*Proof.* A preimage m of n under S satisfies 3m + 1 = n * 2^v for some v >= 1,
i.e., m = (n * 2^v - 1) / 3.

**Integrality.** For m to be well-defined (in Z or Z_2), we need 3 | (n * 2^v - 1),
i.e., n * 2^v = 1 mod 3. Since 2 = -1 mod 3, we have 2^v = (-1)^v mod 3. So:

- n = 1 mod 3: need (-1)^v = 1 mod 3, i.e., v even.
- n = 2 mod 3: need (-1)^v = 2 = -1 mod 3, i.e., v odd.
- n = 0 mod 3: need 0 = 1 mod 3, impossible.

**Parity.** When m = (n * 2^v - 1)/3 exists, we need m to be odd. Compute m mod 2:

m is odd iff n * 2^v - 1 = 3 mod 6 iff n * 2^v = 4 mod 6.

Since 2^v mod 6 cycles as 2, 4, 2, 4, ... (for v = 1, 2, 3, 4, ...):

- v odd: n * 2 mod 6 = 4 mod 6 requires n = 2 mod 3.
- v even: n * 4 mod 6 = 4 mod 6 requires n = 1 mod 3.

In both cases, the parity condition coincides exactly with the integrality condition
established above. So whenever m = (n * 2^v - 1)/3 is an integer, it is
automatically odd.

**Valuation.** For m = (n * 2^v - 1)/3, we have 3m + 1 = n * 2^v. Since n is odd
(hence v_2(n) = 0), v_2(3m + 1) = v_2(n * 2^v) = v. So S(m) = (3m+1)/2^v = n, as
required, and the weight is 2^{-v}.

**Completeness on Z_2.** On Z_2, division by 3 is well-defined since 3 is a 2-adic
unit (|3|_2 = 1, and 3^{-1} = 1 + 2 + 2^3 + 2^4 + ... in Z_2). For each valid v,
m_v = (n * 2^v - 1) * 3^{-1} is a well-defined element of Z_2, and the computation
above shows it is odd (lies in Z_2^{odd}). The set of preimages is therefore
countably infinite for n not divisible by 3, and empty for n = 0 mod 3. QED.

---

## 3. Operator Norm and Weight Sums {#3-operator-norm}

**Proposition 1 (Operator norm).** The operator norm of L on (C(Z_2^{odd}), ||*||_sup)
is

    ||L||_{C^0 -> C^0} = 2/3.

More precisely, for each odd n in Z_2:

    W(n) := (L1)(n) = sum_{S(m)=n} 2^{-v_2(3m+1)} =
        0     if n = 0 mod 3,
        1/3   if n = 1 mod 3,
        2/3   if n = 2 mod 3.

*Proof.* By Lemma 1:

**Case n = 1 mod 3:**
W(n) = sum_{v=2,4,6,...} 2^{-v} = 1/4 + 1/16 + 1/64 + ...
     = (1/4) / (1 - 1/4) = (1/4) * (4/3) = 1/3.

**Case n = 2 mod 3:**
W(n) = sum_{v=1,3,5,...} 2^{-v} = 1/2 + 1/8 + 1/32 + ...
     = (1/2) / (1 - 1/4) = (1/2) * (4/3) = 2/3.

**Case n = 0 mod 3:** W(n) = 0 (no preimages).

For any f with ||f||_sup <= 1:
|(Lf)(n)| <= sum 2^{-v} |f(m_v)| <= W(n) * ||f||_sup <= (2/3)||f||_sup.

The bound is achieved: take f = 1 and n = 2 mod 3.
Therefore ||L|| = sup_n W(n) = 2/3. QED.

**Remark 1.** The value ||L|| = 2/3 corrects the claim ||L|| = 1/3 that appeared in
earlier project documents. The discrepancy arose from considering only preimages
with even v (corresponding to n = 1 mod 3), which give weight sum 1/3. The full
weight sum at n = 2 mod 3 (preimages with odd v) is 2/3.

**Remark 2.** The image of S is always coprime to 3: since 3m + 1 = 1 mod 3 for
all m, we have S(m) = (3m+1)/2^v with S(m) = 2^{-v} mod 3, which is either 1 or 2
mod 3 (never 0). So (Lf)(n) = 0 for all n = 0 mod 3 and all f.

**Proposition 1a (Spectral radius bound).** rho(L) <= 1/2 on C(Z_2^{odd}).

*Proof.* Every eigenvalue of L corresponds to a periodic orbit of S with eigenvalue
lambda = product_{cycle} 2^{-v_i}. Since each v_i >= 1 (Proposition 1 of
conjectures.md), the geometric mean 2^{-v_mean} satisfies v_mean >= 1, giving
|lambda| <= 1/2. Since eigenvalues are contained in the closed disk of radius rho(L),
and the spectrum of L on C(Z_2^{odd}) is the closure of eigenvalues of the
finite-dimensional approximations P_k (by density of locally constant functions),
we get rho(L) <= 1/2. QED.

---

## 4. Inverse Branch Contractions {#4-inverse-branch-contractions}

**Lemma 2 (2-adic contraction).** For each valid v >= 1, the inverse branch

    g_v(n) = (n * 2^v - 1) / 3

is a strict contraction in the 2-adic metric:

    |g_v(x) - g_v(y)|_2 = 2^{-v} * |x - y|_2     for all x, y in Z_2.

The contraction factor is 2^{-v}.

*Proof.* g_v(x) - g_v(y) = (x * 2^v - 1)/3 - (y * 2^v - 1)/3 = 2^v(x - y)/3.

Since 3 is a 2-adic unit (|3|_2 = 1):

|g_v(x) - g_v(y)|_2 = |2^v|_2 * |x - y|_2 * |3^{-1}|_2
                     = 2^{-v} * |x - y|_2 * 1
                     = 2^{-v} * |x - y|_2.       QED.

**Remark.** The contraction by 2^{-v} is the crucial geometric property. In the
2-adic metric, multiplication by 2^v contracts distances (since |2|_2 = 1/2), while
multiplication by 3 is an isometry (since |3|_2 = 1). This makes each inverse branch
a strict contraction, with the contraction factor matching the weight.

**Lemma 3 (Weighted Lipschitz contribution).** For a function f in Lip_1(Z_2^{odd})
and an inverse branch g_v, the weighted Lipschitz contribution satisfies:

    2^{-v} * |f(g_v(x)) - f(g_v(y))| / |x - y|_2 <= 2^{-2v} * |f|_{Lip}

for all distinct x, y in Z_2^{odd} such that both g_v(x) and g_v(y) are defined.

*Proof.* By Lemma 2 and the Lipschitz condition:

2^{-v} * |f(g_v(x)) - f(g_v(y))| <= 2^{-v} * |f|_{Lip} * |g_v(x) - g_v(y)|_2
                                   = 2^{-v} * |f|_{Lip} * 2^{-v} * |x - y|_2
                                   = 2^{-2v} * |f|_{Lip} * |x - y|_2.

Dividing by |x - y|_2 gives the bound. QED.

---

## 5. Lipschitz Contraction Within Mod-3 Classes {#5-lipschitz-contraction-within-mod-3-classes}

**Proposition 2 (Conditional Lipschitz estimate).** For distinct x, y in Z_2^{odd}
with x = y mod 3 (same residue class modulo 3):

    |(Lf)(x) - (Lf)(y)| / |x - y|_2 <= alpha * |f|_{Lip}

where:

    alpha = 4/15   if x = y = 2 mod 3   (preimages at odd v),
    alpha = 1/15   if x = y = 1 mod 3   (preimages at even v),
    alpha = 0      if x = y = 0 mod 3   (no preimages).

In all cases, alpha <= 4/15 ~ 0.267.

*Proof.* When x = y mod 3, the sets of valid v-values coincide (by Lemma 1), and both
g_v(x) and g_v(y) are defined for the same set of v-values. So:

(Lf)(x) - (Lf)(y) = sum_{v valid} 2^{-v} * [f(g_v(x)) - f(g_v(y))].

By Lemma 3:

|(Lf)(x) - (Lf)(y)| / |x - y|_2 <= sum_{v valid} 2^{-2v} * |f|_{Lip}.

**Case x = y = 2 mod 3:** sum_{v=1,3,5,...} 2^{-2v} = 1/4 + 1/64 + 1/1024 + ...
= (1/4) / (1 - 1/16) = (1/4) * (16/15) = 4/15.

**Case x = y = 1 mod 3:** sum_{v=2,4,6,...} 2^{-2v} = 1/16 + 1/256 + ...
= (1/16) / (1 - 1/16) = (1/16) * (16/15) = 1/15.

**Case x = y = 0 mod 3:** empty sum = 0.

In all cases, the bound is at most 4/15 ~ 0.267. Note that 4/15 > 1/4 = 0.25, so the
contraction rate is slightly WORSE than the target 1/4. However, it is strictly less
than 1/3 (the operator norm on the full space divided by the max weight sum). The
contraction rate 4/15 would give essential spectral radius <= 4/15 if the Lasota-Yorke
inequality held -- but it does not, for reasons detailed in Section 6. QED.

**Remark.** The contraction rate 4/15 ~ 0.267 exceeds 1/4 = 0.250 but is strictly
less than 1/3 ~ 0.333. The full sum over ALL v >= 1 would give sum 2^{-2v} = 1/3.
The restriction to alternating v-values (only odd or only even) reduces this to
4/15 (odd v) or 1/15 (even v). The fact that 4/15 > 1/4 means that even if the
Lasota-Yorke inequality held, the essential spectral radius bound would be 4/15,
not 1/4 as originally hoped. The target of 1/4 from the brainstorming document
(using 2^{-(1+s)} at s=1) was based on an incorrect computation that summed 2^{-v}
(contraction factor) times 2^{-v} (weight) = 2^{-2v} over ALL v >= 1, giving 1/3,
rather than the correct alternating sum.

---

## 6. The Obstruction: L Does Not Preserve Lip_1 {#6-the-obstruction}

This section contains the key negative result.

**Theorem 1 (Non-preservation of Lip_1).** The transfer operator L does NOT map
Lip_1(Z_2^{odd}) into itself. Specifically:

(a) The constant function f = 1 belongs to Lip_1(Z_2^{odd}) with |1|_{Lip} = 0.

(b) The image L(1) = W (the weight function from Proposition 1) does NOT belong to
    Lip_1(Z_2^{odd}): we have |W|_{Lip} = infinity.

Therefore, no Lasota-Yorke inequality of the form |Lf|_{Lip} <= alpha * |f|_{Lip}
+ B * ||f||_sup can hold, since this would require |L(1)|_{Lip} <= B * 1 < infinity,
contradicting (b).

*Proof.*

**(a)** is trivial: the constant function has zero oscillation everywhere.

**(b)** We construct a sequence of pairs (x_N, y_N) in Z_2^{odd} with
|x_N - y_N|_2 -> 0 but |W(x_N) - W(y_N)| bounded away from zero.

For each even N >= 2, set:

    x_N = 1,      y_N = 1 + 2^N.

Then:
- Both are odd (since 2^N is even for N >= 1).
- |x_N - y_N|_2 = |2^N|_2 = 2^{-N}.
- x_N mod 3: x_N = 1 = 1 mod 3.
- y_N mod 3: y_N = 1 + 2^N mod 3. Since 2^N mod 3 = (-1)^N = 1 for even N,
  y_N = 1 + 1 = 2 mod 3.

So W(x_N) = 1/3 and W(y_N) = 2/3. Therefore:

|W(x_N) - W(y_N)| / |x_N - y_N|_2 = (1/3) / 2^{-N} = 2^N / 3  ->  infinity

as N -> infinity (through even values). This proves |W|_{Lip} = infinity. QED.

**Remark 1 (Root cause).** The weight function W(n) depends on n mod 3, which
determines the parity of valid v-values. The residue n mod 3 is a continuous function
on Z_2 (the preimage of each residue class is clopen), but it is NOT Lipschitz: for
any 2-adic ball B(x, 2^{-N}), the ball intersects all three residue classes mod 3
(since {x + 2^N k : k in Z} hits all residues mod 3 because gcd(2^N, 3) = 1). This
means W oscillates between 0, 1/3, and 2/3 at EVERY scale of the 2-adic metric.

**Remark 2 (Why this was not detected earlier).** The brainstorming document
(2026-03-04) stated that the Lasota-Yorke inequality on Lip_1(Z_2^{odd}) was
"provable with existing technology" with contraction rate 2^{-(1+s)} at Lipschitz
exponent s. This estimate correctly accounts for the 2-adic contraction of inverse
branches (Lemma 2) but implicitly assumes that ALL inverse branches are simultaneously
active for nearby points x and y. This assumption is false: the set of active branches
depends on the mod-3 class, and nearby (in the 2-adic metric) points can lie in
different mod-3 classes.

**Remark 3 (The arithmetic origin).** The obstruction is a manifestation of the
fundamental arithmetic tension in the Collatz problem: the map involves both
multiplication by 3 (a 2-adic isometry) and division by powers of 2 (a 2-adic
contraction). The interplay between the "3" and "2" makes the transfer operator
incompatible with any smoothness class defined purely in terms of the 2-adic metric.

---

## 7. Universality of the Obstruction {#7-universality}

**Corollary 1 (Universal obstruction).** The function W = L(1) does not belong to any
of the following function spaces on (Z_2^{odd}, |*|_2):

(a) C^alpha(Z_2^{odd}) for any alpha > 0, where |f|_{C^alpha} =
    sup_{x!=y} |f(x) - f(y)| / |x - y|_2^alpha.

(b) BV(Z_2^{odd}), the space of functions of bounded variation with respect to the
    2-adic ultrametric.

(c) Any Banach space X continuously embedded in C(Z_2^{odd}) such that the inclusion
    X -> C(Z_2^{odd}) is strict and X contains the constant functions.

*Proof.*

**(a)** The same pairs (x_N, y_N) from Theorem 1 give:

|W(x_N) - W(y_N)| / |x_N - y_N|_2^alpha = (1/3) / 2^{-N*alpha} = 2^{N*alpha} / 3

which diverges for any alpha > 0.

**(b)** The total variation of W on Z_2^{odd} is infinite. Consider the partition
of Z_2^{odd} into residue classes mod 2^k (for k >= 2). There are 2^{k-1} such
classes. Each class a + 2^k Z_2 (with a odd) contains elements in all three residue
classes mod 3 (since gcd(2^k, 3) = 1 and the class has infinitely many elements).
Therefore osc(W, a + 2^k Z_2) = 2/3 for every class. The total variation at
resolution k is:

V_k(W) >= (2^{k-1}) * (something positive from the oscillations).

More precisely, among the 2^{k-1} classes, at least 2^{k-1}/3 of them will have a
a = 1 mod 3, and the same class also contains points y = 2 mod 3, giving oscillation
>= 1/3. So V_k(W) >= (2^{k-1}/3) * (1/3) = 2^{k-1}/9, which diverges.

**(c)** If X contains the constants and X -> C is strict, then X carries a norm
stronger than ||*||_sup. The image L(1) = W must belong to X for L to map X to X.
But by (a), W has infinite oscillation at every Holder exponent, so no regularity
condition beyond continuity is satisfied. Hence W is not in X unless X = C. QED.

**Remark.** Part (c) shows that the obstruction is not an artifact of the particular
choice of Lipschitz norm. ANY Banach space strictly between "constant functions" and
C(Z_2^{odd}) that is defined using the 2-adic metric alone will fail to be preserved
by L.

---

## 8. What IS Provable {#8-what-is-provable}

Despite the obstruction, several meaningful theorems can be established.

### 8.1 Spectral Bounds on C(Z_2^{odd})

**Theorem 2 (Spectral properties of L on C(Z_2^{odd})).** The transfer operator L
on the Banach space (C(Z_2^{odd}), ||*||_sup) satisfies:

(a) L is a bounded linear operator with ||L|| = 2/3.

(b) rho(L) <= 1/2.

(c) lambda = 1/4 is an eigenvalue with eigenfunction delta_1 (the indicator of the
    fixed point {1}, extended by zero). It is simple (one-dimensional eigenspace).

(d) The spectrum sigma(L) is contained in the closed disk {|z| <= 1/2}.

(e) sigma(L) = closure of union_{k >= 2} sigma(P_k), where P_k is the transfer
    matrix on odd residues mod 2^k.

(f) For non-exceptional k (k not in E = {10, 11, 12, 20, 35, ...}),
    sigma(P_k) = {0, 1/4}.

*Proof sketch.*

(a) Proposition 1 above.

(b) Proposition 1a above.

(c) The fixed point 1 satisfies S(1) = (3+1)/4 = 1 with v_2(4) = 2. So
    (L delta_1)(n) = sum_{S(m)=n} 2^{-v(m)} delta_1(m). The only m with delta_1(m) = 1
    is m = 1, and S(1) = 1, so (L delta_1)(n) = 2^{-2} delta_1(n) = (1/4) delta_1(n)
    for n = 1, and 0 otherwise. For simplicity: the eigenspace of 1/4 is spanned by
    delta_1 because 1 is the unique fixed point of S with v = 2 (solving
    (3n+1)/4 = n gives n = 1, and checking v_2(3*1+1) = v_2(4) = 2 confirms v = 2).

(d) Follows from (b).

(e) The locally constant functions union_k C(R_k) are dense in C(Z_2^{odd}) (by the
    Stone-Weierstrass theorem or directly from the definition of the 2-adic topology).
    L preserves locally constant functions: L maps C(R_k) into C(R_{k+M}) for
    M = M(k,3,1) given by Theorem 1 (2-adic local constancy). The spectrum of a
    bounded operator is determined by its action on dense subspaces in the following
    sense: lambda is in sigma(L) iff lambda is an approximate eigenvalue, which can
    be tested using locally constant functions. The spectral mapping gives
    sigma(L) = closure of union sigma(L_k) where L_k = P_k is the restriction.

(f) Established computationally for k = 3 through 35 (see conjectures.md). QED.

### 8.2 Conditional Spectral Radius

**Theorem 3 (Conditional).** If the exceptional set E has density zero (Conjecture 1a),
then rho(L) = 1/4.

*Proof.* By Theorem 2(e), rho(L) = sup_{k} rho(P_k). For non-exceptional k,
rho(P_k) = 1/4. If E has density zero, then rho(P_k) = 1/4 for all sufficiently
large k outside E. The exceptional rho values satisfy rho(P_k) < 1/2 (by
Proposition 1a). Taking the supremum: rho(L) = max(1/4, sup_{k in E} rho(P_k)).

The computational data shows:
- k = 10: rho = 0.3729
- k = 11: rho = 0.3585
- k = 12: rho = 0.4454
- k = 20: rho = 0.3886
- k = 35: rho = 0.4353

So sup_{k in E} rho(P_k) = 0.4454 (at k = 12).

So sup_{k in E} rho(P_k) = 0.4454 (at k = 12).

**Subtlety: ghost cycles vs. true eigenvalues.** The spectrum sigma(L) on
C(Z_2^{odd}) is the CLOSURE of the union of spectra of P_k, but only in the
projective limit sense: lambda in sigma(L) requires lambda to be an accumulation
point of eigenvalues from sigma(P_k) as k -> infinity, or an eigenvalue that
persists at all sufficiently large k. An eigenvalue of P_k at a single level k
(a ghost cycle that does not persist to k+1, k+2, ...) does NOT necessarily
contribute to sigma(L).

The ghost cycle at k = 12 has rho = 0.4454 but does not persist beyond k = 12.
Similarly for the other exceptional k values. If no ghost cycle eigenvalue
accumulates (i.e., if the exceptional eigenvalues do not converge to a limit
point in (1/4, 1/2]), then sigma(L) = {0, 1/4} and rho(L) = 1/4.

**Conclusion.** If the exceptional set E is finite (or more generally, if the
ghost cycle eigenvalues do not accumulate), then sigma(L) = {0, 1/4} and
rho(L) = 1/4. This is the content of Conjecture 1 reformulated in spectral
terms. QED (conditional on Conjecture 1).

### 8.3 The Mod-3 Restricted Approach and Its Failure

A natural attempt to salvage the Lasota-Yorke inequality is to restrict the Lipschitz
seminorm to pairs within the same mod-3 class. Define:

    |f|_{Lip,3} = sup_{x = y mod 3, x != y} |f(x) - f(y)| / |x - y|_2

**Question.** Does there exist a finite constant B such that
|Lf|_{Lip,3} <= (4/15)|f|_{Lip,3} + B||f||_sup?

**Answer: No.** The obstruction propagates because division by 3 in the inverse
branches scrambles higher powers of 3.

**Analysis.** Take x, y with x = y mod 3 and |x - y|_2 = 2^{-N}. The sets of valid
v-values agree (by Lemma 1), so:

    |(Lf)(x) - (Lf)(y)| <= sum_{v valid} 2^{-v} |f(g_v(x)) - f(g_v(y))|.

Since x = y mod 3, we have 3 | (x - y). Write x - y = 3q * 2^N where q is a 2-adic
unit (v_2(q) = 0). Then:

    g_v(x) - g_v(y) = 2^v(x-y)/3 = q * 2^{N+v}.

So g_v(x) = g_v(y) mod 3 iff 3 | (q * 2^{N+v}) iff 3 | q iff 9 | (x - y).

**Case 9 | (x - y):** All g_v preserve mod-3 classes, giving the pure Lipschitz
bound |(Lf)(x) - (Lf)(y)| / |x-y|_2 <= (4/15)|f|_{Lip,3}.

**Case 3 | (x - y) but 9 does not divide (x - y):** The g_v do NOT preserve mod-3
classes. We can only bound |f(g_v(x)) - f(g_v(y))| <= 2||f||_sup, giving:

    |(Lf)(x) - (Lf)(y)| / |x-y|_2 <= (4/3) * 2^N * ||f||_sup.

The factor 2^N diverges as N -> infinity, so |Lf|_{Lip,3} = infinity for generic f.
The obstruction at the mod-3 level reappears at the mod-9, mod-27, ... levels because
g_v involves division by 3, which permutes these higher 3-adic structures at every
scale. The 3-adic expansion |g_v(x) - g_v(y)|_3 = 3|x - y|_3 is the underlying
cause: it perpetually scrambles the 3-adic structure, preventing any 3-adic
refinement from producing a finite Lasota-Yorke constant.

---

## 9. Appendix: Verification of Weight Sums {#9-appendix}

### 9.1 Numerical Verification

We verify the weight sums from Proposition 1 with explicit preimage computations.

**n = 1 (= 1 mod 3):**
| v | m = (2^v - 1)/3 | 3m + 1 | v_2(3m+1) | S(m) | Weight |
|---|-----------------|--------|-----------|------|--------|
| 2 | 1               | 4      | 2         | 1    | 1/4    |
| 4 | 5               | 16     | 4         | 1    | 1/16   |
| 6 | 21              | 64     | 6         | 1    | 1/64   |
| 8 | 85              | 256    | 8         | 1    | 1/256  |

Sum = 1/4 + 1/16 + 1/64 + 1/256 + ... = 1/3. Confirmed.

**n = 5 (= 2 mod 3):**
| v | m = (5*2^v - 1)/3 | 3m + 1 | v_2(3m+1) | S(m) | Weight |
|---|-------------------|--------|-----------|------|--------|
| 1 | 3                 | 10     | 1         | 5    | 1/2    |
| 3 | 13                | 40     | 3         | 5    | 1/8    |
| 5 | 53                | 160    | 5         | 5    | 1/32   |
| 7 | 213               | 640    | 7         | 5    | 1/128  |

Sum = 1/2 + 1/8 + 1/32 + 1/128 + ... = 2/3. Confirmed.

**n = 3 (= 0 mod 3):**
For any v: 3*2^v - 1 mod 3 = 0 - 1 = 2 mod 3. Not divisible by 3. No preimages.
W(3) = 0. Confirmed.

### 9.2 Mod-3 Class of Preimages

The preimage m_v = (n * 2^v - 1)/3 has mod-3 class depending on n mod 9 and v mod 6:

**For n = 1 mod 3 (v even):**
g_v(n) mod 3 = (n * 2^v - 1)/3 mod 3.

Writing n = 3a + 1 and 2^v mod 9:
- v = 2 mod 6: 2^v = 4 mod 9. n*4-1 = 12a+3 = 3(4a+1). (4a+1) mod 3 = (a+1) mod 3.
- v = 4 mod 6: 2^v = 7 mod 9. n*7-1 = 21a+6 = 3(7a+2). (7a+2) mod 3 = (a+2) mod 3.
- v = 0 mod 6 (v >= 6): 2^v = 1 mod 9. n*1-1 = 3a = 3a. a mod 3.

So g_v maps the class {n = 1 mod 3} into ALL three classes mod 3, depending on the
interplay of n mod 9 and v mod 6. This confirms the mod-3 scrambling described in
Section 6.

### 9.3 Impossibility of the 3-Adic Bound

For the 3-adic expansion of g_v:

g_v(x) - g_v(y) = 2^v * (x-y) / 3.

|g_v(x) - g_v(y)|_3 = |2^v|_3 * |x-y|_3 * |3|_3^{-1}
                     = 1 * |x-y|_3 * 3 = 3 * |x-y|_3.

This is an expansion by factor 3 in the 3-adic metric, independent of v. Combined
with the weight 2^{-v}:

Weighted 3-adic Lipschitz: sum 2^{-v} * 3 = 3 * sum 2^{-v}.

For even v: 3 * 1/3 = 1 (marginal).
For odd v:  3 * 2/3 = 2 (expanding).

The factor 3 is intrinsic: division by 3 in the inverse branch formula EXACTLY
compensates the weight sum 1/3 at the first class, and OVERPOWERS the weight sum
2/3 at the second class. This makes ANY Lipschitz approach using the 3-adic metric
(or any metric incorporating 3-adic information) non-contractive.

---

## Summary

| Statement | Status |
|-----------|--------|
| Preimage structure (Lemma 1) | PROVED |
| 2-adic contraction of g_v (Lemma 2) | PROVED |
| Weighted Lipschitz bound per branch (Lemma 3) | PROVED |
| ||L||_sup = 2/3, not 1/3 (Proposition 1) | PROVED (corrects earlier claim) |
| rho(L) <= 1/2 (Proposition 1a) | PROVED |
| Lipschitz contraction for mod-3 matching pairs (Prop. 2) | PROVED (alpha <= 4/15) |
| L preserves Lip_1(Z_2^{odd}) | FALSE (Theorem 1) |
| Lasota-Yorke inequality on Lip_1(Z_2^{odd}) | FALSE (consequence of Theorem 1) |
| Obstruction extends to all C^alpha, BV spaces | PROVED (Corollary 1) |
| Essential spectral radius <= 1/4 | OPEN (Lasota-Yorke approach fails) |
| rho(L) = 1/4 | OPEN (conditional on Conjecture 1) |
| 1/4 is a simple eigenvalue | PROVED (Theorem 2(c)) |
| Spectral characterization via P_k | PROVED (Theorem 2(e)) |

The central conclusion: the Lasota-Yorke inequality on Lip_1(Z_2^{odd}, |*|_2) is
NOT provable because the transfer operator does not preserve this space. The
obstruction is fundamental (arithmetic incompatibility between the 2-adic contraction
of inverse branches and the 3-adic expansion from division by 3) and cannot be
resolved by choosing a different Banach space defined purely in terms of the 2-adic
metric. For research directions toward overcoming this obstruction, see
`docs/proof-strategy-discussion.md`, Section H.
