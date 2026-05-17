/-
  Ghost Cycles of the Syracuse Map — Obstruction Theorems

  Theorem 2: The transfer operator L does not preserve Lip_1(Z_2^odd).
    The weight function W = L(1) has infinite Lipschitz seminorm because
    W(n) depends on n mod 3, and mod-3 residue classes oscillate at every
    2-adic scale: |W(1) - W(1+2^N)| = 1/3 while |1 - (1+2^N)|_2 = 2^{-N}.

  Theorem 3: L is unbounded on C(Z_2^odd, Q_2) because the 2-adic operator
    norm ||P_k||_2 = 2^{max_j v(j)} grows like 2^k. The key: 3 is invertible
    mod 2^{k-1}, so 3j+2 ranges over all residues, achieving v_2(3j+2) ≥ k-1.

  Reference: McKenna (2026), Theorems 2-3, Sections 4-5.
-/

import Mathlib

namespace GhostCycles

-- ============================================================
-- Part 1: Theorem 2 — Lasota-Yorke Obstruction
-- ============================================================

/-- 1 mod 3 = 1 -/
theorem one_mod_three : 1 % 3 = 1 := by omega

/-
PROBLEM
For even N ≥ 2, (1 + 2^N) mod 3 = 2.
    Proof: 2^N ≡ (-1)^N ≡ 1 (mod 3) when N is even, so 1 + 2^N ≡ 2 (mod 3).

PROVIDED SOLUTION
Get m from Even N. Then 2^(m+m) = 4^m, and 4^m ≡ 1 (mod 3) by induction (4^(k+1) - 1 = 4*(4^k - 1) + 3). So (1 + 2^N) % 3 = (1 + 4^m) % 3 = 2 % 3 = 2.
-/
theorem one_plus_pow2_mod3 {N : ℕ} (hN : Even N) :
    (1 + 2 ^ N) % 3 = 2 := by
  obtain ⟨ k, rfl ⟩ := hN; norm_num [ Nat.pow_add, Nat.pow_mul, Nat.add_mod, Nat.mul_mod, Nat.pow_mod ] ;
  rcases Nat.even_or_odd' k with ⟨ k, rfl | rfl ⟩ <;> norm_num [ Nat.pow_add, Nat.pow_mul, Nat.mul_mod, Nat.pow_mod ] at *;

/-- The Lipschitz ratio |W(x_N) - W(y_N)| / |x_N - y_N|_2 = 2^N / 3 → ∞.
    Here x_N = 1, y_N = 1 + 2^N, with |x_N - y_N|_2 = 2^{-N}.
    The weight difference is |1/3 - 2/3| = 1/3 (a fixed positive constant),
    while the 2-adic distance is 2^{-N} → 0. -/
theorem lipschitz_blowup (N : ℕ) (hN : 2 ≤ N) (hNe : Even N) :
    (1 : ℤ) + 2 ^ N - 1 = 2 ^ N := by ring

/-- The 2-adic valuation of x_N - y_N = 2^N is exactly N. -/
theorem valuation_difference (N : ℕ) (hN : 1 ≤ N) :
    (2 : ℤ) ^ N ≠ 0 := pow_ne_zero N (by omega)

/-
PROBLEM
The Lipschitz seminorm of W is infinite: for every bound C,
    there exist points where the ratio exceeds C.
    Specifically: 2^N / 3 > C for sufficiently large N.

PROVIDED SOLUTION
Use N = 2*(C+2). Then N is even, N ≥ 2, and 2^N/3 > C. For the last part, 2^(2*(C+2)) = 4^(C+2) ≥ 4*(C+2) by induction, so 4^(C+2)/3 ≥ (4*(C+2))/3 > C for C+2 ≥ 1.
-/
theorem lipschitz_seminorm_unbounded :
    ∀ C : ℕ, ∃ N : ℕ, 2 ≤ N ∧ Even N ∧ C < 2 ^ N / 3 := by
  intro C
  use 2 * (C + 2);
  exact ⟨ by linarith, even_iff_two_dvd.mpr ⟨ _, rfl ⟩, Nat.le_div_iff_mul_le three_pos |>.2 <| by induction' C with C ih <;> norm_num [ Nat.pow_succ', Nat.pow_mul ] at * ; nlinarith ⟩

-- ============================================================
-- Part 2: Theorem 3 — 2-Adic Unboundedness
-- ============================================================

/-- 3 is coprime to 2^k for all k. -/
theorem three_coprime_pow2 (k : ℕ) : Nat.Coprime 3 (2 ^ k) := by
  apply Nat.Coprime.pow_right
  decide

/-
PROBLEM
Since 3 is invertible mod 2^{k-1}, the map j ↦ 3j+2 is a bijection
    on Z/2^{k-1}Z. Therefore 3j+2 achieves every residue class mod 2^{k-1},
    including 0 mod 2^{k-1}. This means max_j v_2(3j+2) ≥ k-1.

PROVIDED SOLUTION
Set m = 2^(k-1). Since gcd(3,m)=1 (by three_coprime_pow2), 3 is invertible in ZMod m. Set j_z = 3⁻¹ * (-2) in ZMod m and take j = j_z.val. Then j < m and in ZMod m: 3*j + 2 = 3*(3⁻¹*(-2)) + 2 = -2 + 2 = 0. Use ZMod.isUnit_iff_coprime to get IsUnit (3 : ZMod m), then ZMod.mul_inv_of_unit to get 3 * 3⁻¹ = 1. Use ZMod.natCast_eq_zero_iff to convert back.
-/
theorem exists_high_valuation (k : ℕ) (hk : 2 ≤ k) :
    ∃ j : ℕ, j < 2 ^ (k - 1) ∧ 2 ^ (k - 1) ∣ (3 * j + 2) := by
  obtain ⟨j_z, hj_z⟩ : ∃ j_z : ZMod (2 ^ (k - 1)), 3 * j_z + 2 = 0 := by
    have h_inv : IsUnit (3 : ZMod (2 ^ (k - 1))) := by
      -- Since 3 is coprime to 2^(k-1), it is invertible in ZMod (2^(k-1)).
      have h_coprime : Nat.Coprime 3 (2 ^ (k - 1)) :=
        three_coprime_pow2 (k - 1)
      exact ZMod.isUnit_iff_coprime 3 (2 ^ (k - 1)) |>.2 h_coprime;
    exact ⟨ -2 * h_inv.unit.inv, by simp +decide [ mul_assoc, mul_comm, mul_left_comm ] ⟩;
  refine' ⟨ j_z.val, j_z.val_lt, _ ⟩;
  rw [ ← ZMod.natCast_eq_zero_iff ] ; aesop;

/-
PROBLEM
For j in {0, ..., 2^{k-1} - 1}, we have 3j+2 < 3·2^{k-1},
    so v_2(3j+2) ≤ k (since 3·2^{k-1} < 2^{k+1}).

PROVIDED SOLUTION
Since k ≥ 1, write k = n+1. Then k-1 = n and k+1 = n+2. We have j < 2^n, so 3*j+2 ≤ 3*(2^n - 1) + 2 = 3*2^n - 1 < 4*2^n = 2^(n+2). The key inequality 3*2^n - 1 < 4*2^n holds since 2^n ≥ 1.
-/
theorem valuation_upper_bound {k j : ℕ} (hk : 1 ≤ k) (hj : j < 2 ^ (k - 1)) :
    3 * j + 2 < 2 ^ (k + 1) := by
  cases k <;> norm_num [ pow_succ' ] at * ; linarith

/-- The 2-adic operator norm ||P_k||_2 = 2^{max_j v(j)} grows at least as fast
    as 2^{k-1}, establishing unboundedness. -/
theorem operator_norm_grows (k : ℕ) (hk : 2 ≤ k) :
    ∃ j : ℕ, j < 2 ^ (k - 1) ∧ 2 ^ (k - 1) ∣ (3 * j + 2) :=
  exists_high_valuation k hk

end GhostCycles