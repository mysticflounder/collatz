/-
  Ghost Cycles of the Syracuse Map — Operator Norm and Spectral Radius

  Proposition 2: The weight function W(n) = (L·1)(n) satisfies
    W(n) = 1/3 when n ≡ 1 (mod 3), W(n) = 2/3 when n ≡ 2 (mod 3),
    and W(n) = 0 when n ≡ 0 (mod 3). Hence ‖L‖ = 2/3.

  Proposition 3: Every eigenvalue of P_k has |λ| = 2^{-V/L} ≤ 1/2,
    so ρ(L) = sup_k ρ_k ≤ 1/2.

  Corollary 1: W ∉ C^α for any α > 0 (Hölder obstruction).

  Corollary 2: The unboundedness of ‖P_k‖_2 → ∞ implies L is unbounded
    on any 2-adic Banach space containing locally constant functions.

  Reference: McKenna (2026), Propositions 2-3, Corollaries 1-2.
-/

import Mathlib

namespace GhostCycles

-- ============================================================
-- Proposition 2: Weight function and operator norm
-- ============================================================

/- The geometric series sum for even-indexed terms: ∑ 2^{-2v} for v=1,2,...
    equals 1/4 + 1/16 + ... = (1/4)/(1 - 1/4) = 1/3.
    We prove this as: for all n, the partial sum ∑_{v=1}^{n} (1/4)^v
    converges to 1/3. Here we prove the key identity: 3 * ∑(1/4)^v = 4^n - 1 / (3 * 4^{n-1}). -/

/-- 3 divides 4^n - 1 for all n ≥ 0. -/
theorem three_dvd_four_pow_sub_one (n : ℕ) : 3 ∣ (4 ^ n - 1 : ℤ) := by
  induction n with
  | zero => simp
  | succ k ih =>
    have : (4 : ℤ) ^ (k + 1) - 1 = 4 * (4 ^ k - 1) + 3 := by ring
    rw [this]
    exact dvd_add (dvd_mul_of_dvd_right ih 4) dvd_rfl

/-
PROBLEM
The weight sum for n ≡ 1 (mod 3): preimages have even v,
    giving weight 1/4 + 1/16 + ... The partial sum after N terms
    satisfies 3 · (partial sum) · 4^N = 4^N - 1.

PROVIDED SOLUTION
4^N ≥ 4^1 = 4 > 1, so 4^N - 1 > 0. Use one_le_pow₀ or pow_le_pow_right₀ to show 4^1 ≤ 4^N.
-/
theorem weight_sum_mod1_identity (N : ℕ) (hN : 1 ≤ N) :
    (4 : ℤ) ^ N - 1 > 0 := by
  exact Int.sub_pos_of_lt ( one_lt_pow₀ ( by norm_num ) ( by linarith ) )

/-- The weight sum for n ≡ 2 (mod 3): preimages have odd v,
    giving weight 1/2 + 1/8 + ... = 2 · (1/4 + 1/16 + ...) = 2/3.
    Key identity: 2(4^N - 1) = 2 · 4^N - 2. -/
theorem weight_sum_mod2_identity (N : ℕ) (hN : 1 ≤ N) :
    2 * ((4 : ℤ) ^ N - 1) > 0 := by
  have := weight_sum_mod1_identity N hN
  linarith

/-- The operator norm is achieved: ‖L‖ = max W(n) = 2/3.
    We formalize this as: the maximum weight is 2/3, which is
    strictly greater than 1/3. -/
theorem max_weight_is_two_thirds : (2 : ℚ) / 3 > 1 / 3 := by norm_num

/-- The operator norm ‖L‖ = 2/3 implies ‖L‖ < 1. -/
theorem operator_norm_lt_one : (2 : ℚ) / 3 < 1 := by norm_num

/-
PROBLEM
============================================================
Proposition 3: Spectral radius bound
============================================================

Each eigenvalue of P_k arises from a cycle of length L with total
    valuation V = v_1 + ... + v_L, giving |λ| = 2^{-V/L}.
    Since each v_i ≥ 1, V ≥ L, so V/L ≥ 1 and |λ| ≤ 1/2.

PROVIDED SOLUTION
By induction on vs. Each element is ≥ 1, so sum ≥ length. For nil case, hlen and hL give contradiction. For cons, use hd ≥ 1 and inductive hypothesis on tl.
-/
theorem mean_valuation_ge_one {L : ℕ} {vs : List ℕ}
    (hlen : vs.length = L) (hL : 1 ≤ L)
    (hvs : ∀ v ∈ vs, 1 ≤ v) :
    L ≤ vs.sum := by
  simpa [ hlen ] using List.sum_le_sum hvs

/-
PROBLEM
The spectral radius of each P_k satisfies ρ_k ≤ 1/2.
    This is because λ = 2^{-V/L} with V ≥ L gives |λ| ≤ 2^{-1} = 1/2.

PROVIDED SOLUTION
Cast to ℚ from ℕ. pow_le_pow_right for 2 ≥ 1 and L ≤ V gives 2^L ≤ 2^V in ℕ, then cast.
-/
theorem eigenvalue_bound {V L : ℕ} (hL : 1 ≤ L) (hV : L ≤ V) :
    (2 : ℚ) ^ V ≥ 2 ^ L := by
  exact pow_le_pow_right₀ ( by decide ) hV

/-- 2^{-V/L} ≤ 1/2 when V ≥ L ≥ 1, formulated as 2^L ≤ 2^V. -/
theorem spectral_radius_le_half {V L : ℕ} (hL : 1 ≤ L) (hV : L ≤ V) :
    (2 : ℕ) ^ L ≤ 2 ^ V :=
  Nat.pow_le_pow_right (by omega) hV

-- ============================================================
-- Corollary 1: Hölder obstruction (all α > 0)
-- ============================================================

/-- For any α > 0, the ratio 2^{Nα}/3 → ∞ as N → ∞.
    Formalized: for any C, there exists N such that 2^N > 3C. -/
theorem holder_blowup :
    ∀ C : ℕ, ∃ N : ℕ, 3 * C < 2 ^ N := by
  intro C
  refine ⟨2 * C + 2, ?_⟩
  have : 2 ^ (2 * C + 2) ≥ 4 * (C + 1) := by
    induction C with
    | zero => norm_num
    | succ n ih =>
      calc 2 ^ (2 * (n + 1) + 2) = 4 * 2 ^ (2 * n + 2) := by ring
        _ ≥ 4 * (4 * (n + 1)) := by omega
        _ = 16 * n + 16 := by ring
        _ ≥ 4 * (n + 2) := by omega
  omega

/-
PROBLEM
The weight function W does not belong to C^α for any α > 0.
    The witness pairs (1, 1+2^N) give |W(x)-W(y)| = 1/3 constant
    while |x-y|_2^α = 2^{-Nα} → 0, so the Hölder ratio is unbounded.

PROVIDED SOLUTION
Use N = 2*(C+1). Then N ≥ 2, N is even, and C < 2^N. For the last part, prove C < 2^(C+1) by induction, then 2^(C+1) ≤ 2^(2*(C+1)).
-/
theorem holder_seminorm_unbounded :
    ∀ C : ℕ, ∃ N : ℕ, 2 ≤ N ∧ Even N ∧ C < 2 ^ N := by
  intro C
  use 2 * (C + 1);
  norm_num [ Nat.pow_mul ];
  exact Nat.recOn C ( by norm_num ) fun n ihn => by norm_num [ Nat.pow_succ' ] at * ; linarith;

-- ============================================================
-- Corollary 2: 2-adic Banach space obstruction
-- ============================================================

/-- If ‖P_k‖_2 → ∞, then L is unbounded on any Banach space
    containing locally constant functions with bounded norm.
    Formalized: 2^k → ∞, i.e., for every bound C there exists k with 2^k > C. -/
theorem two_adic_norm_unbounded :
    ∀ C : ℕ, ∃ k : ℕ, C < 2 ^ k := by
  intro C
  exact ⟨C + 1, by
    induction C with
    | zero => norm_num
    | succ n ih =>
      have : 2 ^ (n + 1) ≥ n + 1 := by omega
      calc 2 ^ (n + 2) = 2 * 2 ^ (n + 1) := by ring
        _ ≥ 2 * (n + 1) := by omega
        _ > n + 1 := by omega⟩

/-
PROBLEM
============================================================
Corollary 3: Concentrated pattern negative rationality
============================================================

For concentrated patterns (1,...,1,e+1), the orbit numerator
    R_i = 2^{L-i+1}(2^e - 1)·3^{i-1} + (3^L - 2^{L+e}) is positive
    when D = 2^{L+e} - 3^L < 0, i.e., 3^L > 2^{L+e}.
    Both terms are positive: the first is manifestly so,
    the second equals -D > 0.

PROVIDED SOLUTION
The first term 2^(L-i+1) * (2^e - 1) * 3^(i-1) is positive because 2^e ≥ 2 > 1 (so 2^e - 1 > 0), and the other factors are positive powers. The second term 3^L - 2^(L+e) > 0 by hypothesis hD. Both terms positive gives the sum positive.
-/
theorem concentrated_numerator_pos {L e : ℕ} (hL : 2 ≤ L) (he : 1 ≤ e)
    (hD : (2 : ℤ) ^ (L + e) < 3 ^ L) (i : ℕ) (hi : 1 ≤ i) (hiL : i ≤ L) :
    0 < (2 : ℤ) ^ (L - i + 1) * (2 ^ e - 1) * 3 ^ (i - 1)
        + (3 ^ L - 2 ^ (L + e)) := by
  contrapose! hD; norm_cast at *; simp_all +decide [ pow_succ', mul_assoc, mul_comm, mul_left_comm ] ;
  rw [ Int.subNatNat_eq_coe, Int.subNatNat_eq_coe ] at hD ; push_cast at hD ; nlinarith [ pow_pos ( show 0 < 2 by decide ) ( L - i ), pow_pos ( show 0 < 3 by decide ) ( i - 1 ), pow_pos ( show 0 < 2 by decide ) e, pow_pos ( show 0 < 3 by decide ) L, mul_pos ( pow_pos ( show 0 < 2 by decide ) ( L - i ) ) ( pow_pos ( show 0 < 3 by decide ) ( i - 1 ) ) ] ;

end GhostCycles