/-
  Cycle exclusion at parity-word lengths L = 4 and L = 5.

  Extends the symbolic L = 1, 2, 3 exclusions in `CycleExclusion.lean`:
  for any positive integer `n` and any positive valuations
  `a, b, c, d (, e)`, the integer cycle equation

      n · (2^V − 3^L) = R(v)

  with `v` the parity word `[a, b, c, d (, e)]`, `V = a+b+c+d (+e)`,
  `L = 4` or `L = 5`, and `R(v) = (offset v : ℤ)`, admits the trivial
  solution `n = 1` only.

  Two ingredients are combined:

  - **R/D ratio bounds** for large total valuation `V`. For
    `L = 4, V ≥ 9` we have `R < 3·D`; for `L = 5, V ≥ 11` we have
    `R < 5·D`. Together with parity / mod-3 exclusions of small `n`
    these force `n = 1`.
  - **Exhaustive V-checks** for the remaining small-V slices (`L = 4`
    at `V ∈ {7, 8}`, `L = 5` at `V ∈ {8, 9, 10}`), via `interval_cases`.

  Mathlib-dependent (`nlinarith`, `interval_cases`, `Prime.dvd_of_dvd_pow`).
-/

import CollatzConjecture.SmallCycles
import CollatzConjecture.CycleResults
import Mathlib.Tactic

namespace CycleExclusionL4L5

open ParityWords

/-! ## Bridge: ghostR via offset -/

def ghostR (ds : List Nat) : Int := (ParityWords.offset ds : Int)

@[simp] theorem ghostR_nil : ghostR [] = 0 := rfl

theorem ghostR_cons (v : Nat) (rest : List Nat) :
    ghostR (v :: rest) = 3 ^ rest.length + 2 ^ v * ghostR rest := by
  unfold ghostR
  simp [ParityWords.offset_cons]

theorem ghostR_nonneg (ds : List Nat) : 0 ≤ ghostR ds := by
  unfold ghostR; exact_mod_cast Nat.zero_le _

/-! ## Closed-form ghostR for small lists -/

theorem ghostR_four (a b c d : Nat) :
    ghostR [a, b, c, d] = 27 + 9 * 2 ^ a + 3 * 2 ^ (a + b) + 2 ^ (a + b + c) := by
  simp [ghostR_cons, ghostR_nil]; ring

theorem ghostR_L5 (a b c d e : Nat) :
    ghostR [a, b, c, d, e] =
      81 + 27 * 2 ^ a + 9 * 2 ^ (a + b) + 3 * 2 ^ (a + b + c) +
        2 ^ (a + b + c + d) := by
  simp [ghostR_cons, ghostR_nil]; ring

theorem ghostR_L6 (a b c d e f : Nat) :
    ghostR [a, b, c, d, e, f] =
      243 + 81 * 2 ^ a + 27 * 2 ^ (a + b) + 9 * 2 ^ (a + b + c) +
        3 * 2 ^ (a + b + c + d) + 2 ^ (a + b + c + d + e) := by
  simp [ghostR_cons, ghostR_nil]; ring

/-! ## R < kD ratio bounds -/

theorem R_lt_3D_L4 (a b c d : Nat)
    (_ha : 1 ≤ a) (_hb : 1 ≤ b) (_hc : 1 ≤ c) (_hd : 1 ≤ d)
    (hV : 9 ≤ a + b + c + d) :
    ghostR [a, b, c, d] < 3 * (2 ^ (a + b + c + d) - 81) := by
  rw [ghostR_four]
  set V₃ := a + b + c + d - 3
  have hV₃_eq : a + b + c + d = V₃ + 3 := by omega
  have h2a : (2 : Int) ^ a ≤ 2 ^ V₃ :=
    pow_le_pow_right₀ (by norm_num) (by omega)
  have h2ab : (2 : Int) ^ (a + b) ≤ 2 * 2 ^ V₃ := by
    calc (2 : Int) ^ (a + b)
        ≤ 2 ^ (V₃ + 1) := pow_le_pow_right₀ (by norm_num) (by omega)
      _ = 2 * 2 ^ V₃ := by ring
  have h2abc : (2 : Int) ^ (a + b + c) ≤ 4 * 2 ^ V₃ := by
    calc (2 : Int) ^ (a + b + c)
        ≤ 2 ^ (V₃ + 2) := pow_le_pow_right₀ (by norm_num) (by omega)
      _ = 4 * 2 ^ V₃ := by ring
  have h64 : (64 : Int) ≤ 2 ^ V₃ :=
    le_trans (by norm_num : (64 : Int) ≤ 2 ^ 6)
      (pow_le_pow_right₀ (by norm_num) (by omega))
  have hV_pow : (2 : Int) ^ (a + b + c + d) = 8 * 2 ^ V₃ := by
    rw [hV₃_eq]; ring
  nlinarith

theorem R_lt_5D_L5 (a b c d e : Nat)
    (_ha : 1 ≤ a) (_hb : 1 ≤ b) (_hc : 1 ≤ c) (_hd : 1 ≤ d) (_he : 1 ≤ e)
    (hV : 11 ≤ a + b + c + d + e) :
    ghostR [a, b, c, d, e] < 5 * (2 ^ (a + b + c + d + e) - 243) := by
  rw [ghostR_L5]
  set V₄ := a + b + c + d + e - 4
  have hV₄_eq : a + b + c + d + e = V₄ + 4 := by omega
  have h2a : (2 : Int) ^ a ≤ 2 ^ V₄ :=
    pow_le_pow_right₀ (by norm_num) (by omega)
  have h2ab : (2 : Int) ^ (a + b) ≤ 2 * 2 ^ V₄ := by
    calc (2 : Int) ^ (a + b)
        ≤ 2 ^ (V₄ + 1) := pow_le_pow_right₀ (by norm_num) (by omega)
      _ = 2 * 2 ^ V₄ := by ring
  have h2abc : (2 : Int) ^ (a + b + c) ≤ 4 * 2 ^ V₄ := by
    calc (2 : Int) ^ (a + b + c)
        ≤ 2 ^ (V₄ + 2) := pow_le_pow_right₀ (by norm_num) (by omega)
      _ = 4 * 2 ^ V₄ := by ring
  have h2abcd : (2 : Int) ^ (a + b + c + d) ≤ 8 * 2 ^ V₄ := by
    calc (2 : Int) ^ (a + b + c + d)
        ≤ 2 ^ (V₄ + 3) := pow_le_pow_right₀ (by norm_num) (by omega)
      _ = 8 * 2 ^ V₄ := by ring
  have h128 : (128 : Int) ≤ 2 ^ V₄ :=
    le_trans (by norm_num : (128 : Int) ≤ 2 ^ 7)
      (pow_le_pow_right₀ (by norm_num) (by omega))
  have hV_pow : (2 : Int) ^ (a + b + c + d + e) = 16 * 2 ^ V₄ := by
    rw [hV₄_eq]; ring
  nlinarith

theorem R_lt_7D_L6 (a b c d e f : Nat)
    (_ha : 1 ≤ a) (_hb : 1 ≤ b) (_hc : 1 ≤ c) (_hd : 1 ≤ d)
    (_he : 1 ≤ e) (_hf : 1 ≤ f)
    (hV : 14 ≤ a + b + c + d + e + f) :
    ghostR [a, b, c, d, e, f] < 7 * (2 ^ (a + b + c + d + e + f) - 729) := by
  rw [ghostR_L6]
  set V₅ := a + b + c + d + e + f - 5
  have hV₅_eq : a + b + c + d + e + f = V₅ + 5 := by omega
  have h2a : (2 : Int) ^ a ≤ 2 ^ V₅ :=
    pow_le_pow_right₀ (by norm_num) (by omega)
  have h2ab : (2 : Int) ^ (a + b) ≤ 2 * 2 ^ V₅ := by
    calc (2 : Int) ^ (a + b)
        ≤ 2 ^ (V₅ + 1) := pow_le_pow_right₀ (by norm_num) (by omega)
      _ = 2 * 2 ^ V₅ := by ring
  have h2abc : (2 : Int) ^ (a + b + c) ≤ 4 * 2 ^ V₅ := by
    calc (2 : Int) ^ (a + b + c)
        ≤ 2 ^ (V₅ + 2) := pow_le_pow_right₀ (by norm_num) (by omega)
      _ = 4 * 2 ^ V₅ := by ring
  have h2abcd : (2 : Int) ^ (a + b + c + d) ≤ 8 * 2 ^ V₅ := by
    calc (2 : Int) ^ (a + b + c + d)
        ≤ 2 ^ (V₅ + 3) := pow_le_pow_right₀ (by norm_num) (by omega)
      _ = 8 * 2 ^ V₅ := by ring
  have h2abcde : (2 : Int) ^ (a + b + c + d + e) ≤ 16 * 2 ^ V₅ := by
    calc (2 : Int) ^ (a + b + c + d + e)
        ≤ 2 ^ (V₅ + 4) := pow_le_pow_right₀ (by norm_num) (by omega)
      _ = 16 * 2 ^ V₅ := by ring
  have h512 : (512 : Int) ≤ 2 ^ V₅ :=
    le_trans (by norm_num : (512 : Int) ≤ 2 ^ 9)
      (pow_le_pow_right₀ (by norm_num) (by omega))
  have hV_pow : (2 : Int) ^ (a + b + c + d + e + f) = 32 * 2 ^ V₅ := by
    rw [hV₅_eq]; ring
  nlinarith

/-! ## Parity / mod arguments on n -/

theorem n_ne_2_L4 (n : Int) (a b c d : Nat) (ha : 1 ≤ a)
    (heq : n * (2 ^ (a + b + c + d) - 3 ^ 4) = ghostR [a, b, c, d]) :
    n ≠ 2 := by
  intro hn2
  rw [hn2, ghostR_four, show (3 : Int) ^ 4 = 81 from by norm_num] at heq
  have heq' : 2 * ((2 : Int) ^ (a + b + c + d) - 81) -
      (9 * 2 ^ a + 3 * 2 ^ (a + b) + 2 ^ (a + b + c)) = 27 := by linarith
  set a' := a - 1
  have ha_eq : a = a' + 1 := by omega
  obtain ⟨k, hk⟩ : (2 : Int) ∣ (9 * 2 ^ a + 3 * 2 ^ (a + b) + 2 ^ (a + b + c)) :=
    ⟨9 * 2 ^ a' + 3 * 2 ^ (a' + b) + 2 ^ (a' + b + c), by rw [ha_eq]; ring⟩
  rw [hk] at heq'
  omega

theorem n_odd_L5 (n : Int) (a b c d e : Nat) (ha : 1 ≤ a)
    (heq : n * (2 ^ (a + b + c + d + e) - 3 ^ 5) = ghostR [a, b, c, d, e]) :
    ¬ 2 ∣ n := by
  intro ⟨m, hm⟩
  rw [hm, ghostR_L5, show (3 : Int) ^ 5 = 243 from by norm_num] at heq
  have heq' : 2 * (m * ((2 : Int) ^ (a + b + c + d + e) - 243)) -
      (27 * 2 ^ a + 9 * 2 ^ (a + b) + 3 * 2 ^ (a + b + c) +
        2 ^ (a + b + c + d)) = 81 := by linarith
  set a' := a - 1
  have ha_eq : a = a' + 1 := by omega
  obtain ⟨k, hk⟩ : (2 : Int) ∣ (27 * 2 ^ a + 9 * 2 ^ (a + b) +
      3 * 2 ^ (a + b + c) + 2 ^ (a + b + c + d)) :=
    ⟨27 * 2 ^ a' + 9 * 2 ^ (a' + b) + 3 * 2 ^ (a' + b + c) +
      2 ^ (a' + b + c + d), by rw [ha_eq]; ring⟩
  rw [hk] at heq'
  omega

theorem n_ne_3_L5 (n : Int) (a b c d e : Nat)
    (heq : n * (2 ^ (a + b + c + d + e) - 3 ^ 5) = ghostR [a, b, c, d, e]) :
    n ≠ 3 := by
  intro hn3
  rw [hn3, ghostR_L5, show (3 : Int) ^ 5 = 243 from by norm_num] at heq
  have hdvd : (3 : Int) ∣ 2 ^ (a + b + c + d) := by
    refine ⟨(2 : Int) ^ (a + b + c + d + e) - 270 -
      9 * 2 ^ a - 3 * 2 ^ (a + b) - 2 ^ (a + b + c), ?_⟩
    linarith
  have h3p : Prime (3 : Int) := by
    rw [Int.prime_iff_natAbs_prime]; norm_num
  exact absurd hdvd (mt (Prime.dvd_of_dvd_pow h3p) (by norm_num))

theorem n_odd_L6 (n : Int) (a b c d e f : Nat) (ha : 1 ≤ a)
    (heq : n * (2 ^ (a + b + c + d + e + f) - 3 ^ 6) = ghostR [a, b, c, d, e, f]) :
    ¬ 2 ∣ n := by
  intro ⟨m, hm⟩
  rw [hm, ghostR_L6, show (3 : Int) ^ 6 = 729 from by norm_num] at heq
  have heq' : 2 * (m * ((2 : Int) ^ (a + b + c + d + e + f) - 729)) -
      (81 * 2 ^ a + 27 * 2 ^ (a + b) + 9 * 2 ^ (a + b + c) +
        3 * 2 ^ (a + b + c + d) + 2 ^ (a + b + c + d + e)) = 243 := by linarith
  set a' := a - 1
  have ha_eq : a = a' + 1 := by omega
  obtain ⟨k, hk⟩ : (2 : Int) ∣
      (81 * 2 ^ a + 27 * 2 ^ (a + b) + 9 * 2 ^ (a + b + c) +
        3 * 2 ^ (a + b + c + d) + 2 ^ (a + b + c + d + e)) :=
    ⟨81 * 2 ^ a' + 27 * 2 ^ (a' + b) + 9 * 2 ^ (a' + b + c) +
      3 * 2 ^ (a' + b + c + d) + 2 ^ (a' + b + c + d + e),
      by rw [ha_eq]; ring⟩
  rw [hk] at heq'
  omega

theorem n_ne_3_L6 (n : Int) (a b c d e f : Nat)
    (heq : n * (2 ^ (a + b + c + d + e + f) - 3 ^ 6) = ghostR [a, b, c, d, e, f]) :
    n ≠ 3 := by
  intro hn3
  rw [hn3, ghostR_L6, show (3 : Int) ^ 6 = 729 from by norm_num] at heq
  have hdvd : (3 : Int) ∣ 2 ^ (a + b + c + d + e) := by
    refine ⟨(2 : Int) ^ (a + b + c + d + e + f) - 810 -
      27 * 2 ^ a - 9 * 2 ^ (a + b) - 3 * 2 ^ (a + b + c) - 2 ^ (a + b + c + d), ?_⟩
    linarith
  have h3p : Prime (3 : Int) := by rw [Int.prime_iff_natAbs_prime]; norm_num
  exact absurd hdvd (mt (Prime.dvd_of_dvd_pow h3p) (by norm_num))

/-! ## V-large branches: n = 1 -/

theorem no_cycle_L4_large_V (n : Int) (hn : 0 < n)
    (a b c d : Nat) (ha : 1 ≤ a) (hb : 1 ≤ b) (hc : 1 ≤ c) (hd : 1 ≤ d)
    (hV : 9 ≤ a + b + c + d)
    (heq : n * (2 ^ (a + b + c + d) - 3 ^ 4) = ghostR [a, b, c, d]) :
    n = 1 := by
  have hn2 : n ≠ 2 := n_ne_2_L4 n a b c d ha heq
  have h81 : (3 : Int) ^ 4 = 81 := by norm_num
  rw [h81] at heq
  have hD_pos : (0 : Int) < 2 ^ (a + b + c + d) - 81 := by
    nlinarith [show (512 : Int) ≤ 2 ^ (a + b + c + d) from
      le_trans (by norm_num : (512 : Int) ≤ 2 ^ 9)
        (pow_le_pow_right₀ (by norm_num) hV)]
  have hR_lt := R_lt_3D_L4 a b c d ha hb hc hd hV
  have hn_lt : n < 3 := by
    by_contra h
    push_neg at h
    have : 3 * (2 ^ (a + b + c + d) - 81) ≤ n * (2 ^ (a + b + c + d) - 81) :=
      mul_le_mul_of_nonneg_right h (le_of_lt hD_pos)
    linarith
  omega

theorem no_cycle_L5_large_V (n : Int) (hn : 0 < n)
    (a b c d e : Nat) (ha : 1 ≤ a) (hb : 1 ≤ b) (hc : 1 ≤ c) (hd : 1 ≤ d) (he : 1 ≤ e)
    (hV : 11 ≤ a + b + c + d + e)
    (heq : n * (2 ^ (a + b + c + d + e) - 3 ^ 5) = ghostR [a, b, c, d, e]) :
    n = 1 := by
  have hn_odd : ¬ 2 ∣ n := n_odd_L5 n a b c d e ha heq
  have hn3 : n ≠ 3 := n_ne_3_L5 n a b c d e heq
  have h243 : (3 : Int) ^ 5 = 243 := by norm_num
  rw [h243] at heq
  have hD_pos : (0 : Int) < 2 ^ (a + b + c + d + e) - 243 := by
    nlinarith [show (2048 : Int) ≤ 2 ^ (a + b + c + d + e) from
      le_trans (by norm_num : (2048 : Int) ≤ 2 ^ 11)
        (pow_le_pow_right₀ (by norm_num) hV)]
  have hR_lt := R_lt_5D_L5 a b c d e ha hb hc hd he hV
  have hn_lt : n < 5 := by
    by_contra h
    push_neg at h
    have : 5 * (2 ^ (a + b + c + d + e) - 243) ≤
        n * (2 ^ (a + b + c + d + e) - 243) :=
      mul_le_mul_of_nonneg_right h (le_of_lt hD_pos)
    linarith
  omega

/-! ## Exhaustive V-checks for length 4 -/

theorem no_cycle_L4_V7 (n : Int) (a b c d : Nat) (_ha : 1 ≤ a) (_hb : 1 ≤ b)
    (_hc : 1 ≤ c) (_hd : 1 ≤ d) (habcd : a + b + c + d = 7)
    (heq : n * (2 ^ 7 - 3 ^ 4) = ghostR [a, b, c, d]) :
    False := by
  rw [ghostR_four] at heq
  have : a ≤ 4 := by omega
  have : b ≤ 4 := by omega
  have : c ≤ 4 := by omega
  interval_cases a <;> interval_cases b <;> interval_cases c <;> omega

theorem cycle_L4_V8 (n : Int) (a b c d : Nat) (_ha : 1 ≤ a) (_hb : 1 ≤ b)
    (_hc : 1 ≤ c) (_hd : 1 ≤ d) (habcd : a + b + c + d = 8)
    (heq : n * (2 ^ 8 - 3 ^ 4) = ghostR [a, b, c, d]) :
    n = 1 := by
  rw [ghostR_four] at heq
  have : a ≤ 5 := by omega
  have : b ≤ 5 := by omega
  have : c ≤ 5 := by omega
  interval_cases a <;> interval_cases b <;> interval_cases c <;> omega

/-! ## Exhaustive V-checks for length 5 -/

theorem no_cycle_L5_V8 (n : Int) (a b c d e : Nat) (_ha : 1 ≤ a) (_hb : 1 ≤ b)
    (_hc : 1 ≤ c) (_hd : 1 ≤ d) (_he : 1 ≤ e) (habcde : a + b + c + d + e = 8)
    (heq : n * (2 ^ 8 - 3 ^ 5) = ghostR [a, b, c, d, e]) :
    False := by
  rw [ghostR_L5] at heq
  have : a ≤ 4 := by omega
  have : b ≤ 4 := by omega
  have : c ≤ 4 := by omega
  have : d ≤ 4 := by omega
  interval_cases a <;> interval_cases b <;> interval_cases c <;>
    interval_cases d <;> omega

theorem no_cycle_L5_V9 (n : Int) (a b c d e : Nat) (_ha : 1 ≤ a) (_hb : 1 ≤ b)
    (_hc : 1 ≤ c) (_hd : 1 ≤ d) (_he : 1 ≤ e) (habcde : a + b + c + d + e = 9)
    (heq : n * (2 ^ 9 - 3 ^ 5) = ghostR [a, b, c, d, e]) :
    False := by
  rw [ghostR_L5] at heq
  have : a ≤ 5 := by omega
  have : b ≤ 5 := by omega
  have : c ≤ 5 := by omega
  have : d ≤ 5 := by omega
  interval_cases a
  all_goals (interval_cases b <;> interval_cases c <;>
    interval_cases d <;> omega)

theorem cycle_L5_V10 (n : Int) (a b c d e : Nat) (_ha : 1 ≤ a) (_hb : 1 ≤ b)
    (_hc : 1 ≤ c) (_hd : 1 ≤ d) (_he : 1 ≤ e) (habcde : a + b + c + d + e = 10)
    (heq : n * (2 ^ 10 - 3 ^ 5) = ghostR [a, b, c, d, e]) :
    n = 1 := by
  rw [ghostR_L5] at heq
  have : a ≤ 6 := by omega
  have : b ≤ 6 := by omega
  have : c ≤ 6 := by omega
  have : d ≤ 6 := by omega
  interval_cases a
  all_goals (interval_cases b <;> interval_cases c <;>
    interval_cases d <;> omega)

/-! ## Abstract no-cycle theorems -/

theorem no_nontrivial_four_cycle (n : Int) (hn : 0 < n)
    (a b c d : Nat) (ha : 1 ≤ a) (hb : 1 ≤ b) (hc : 1 ≤ c) (hd : 1 ≤ d)
    (hV : 7 ≤ a + b + c + d)
    (heq : n * (2 ^ (a + b + c + d) - 3 ^ 4) = ghostR [a, b, c, d]) :
    n = 1 := by
  by_cases hV9 : 9 ≤ a + b + c + d
  · exact no_cycle_L4_large_V n hn a b c d ha hb hc hd hV9 heq
  · by_cases hV8 : a + b + c + d = 8
    · rw [hV8] at heq; exact cycle_L4_V8 n a b c d ha hb hc hd hV8 heq
    · have hV7 : a + b + c + d = 7 := by omega
      exfalso; rw [hV7] at heq
      exact no_cycle_L4_V7 n a b c d ha hb hc hd hV7 heq

theorem no_nontrivial_five_cycle (n : Int) (hn : 0 < n)
    (a b c d e : Nat) (ha : 1 ≤ a) (hb : 1 ≤ b) (hc : 1 ≤ c) (hd : 1 ≤ d) (he : 1 ≤ e)
    (hV : 8 ≤ a + b + c + d + e)
    (heq : n * (2 ^ (a + b + c + d + e) - 3 ^ 5) = ghostR [a, b, c, d, e]) :
    n = 1 := by
  by_cases hV11 : 11 ≤ a + b + c + d + e
  · exact no_cycle_L5_large_V n hn a b c d e ha hb hc hd he hV11 heq
  · by_cases hV10 : a + b + c + d + e = 10
    · rw [hV10] at heq
      exact cycle_L5_V10 n a b c d e ha hb hc hd he hV10 heq
    · by_cases hV9 : a + b + c + d + e = 9
      · exfalso; rw [hV9] at heq
        exact no_cycle_L5_V9 n a b c d e ha hb hc hd he hV9 heq
      · have hV8 : a + b + c + d + e = 8 := by omega
        exfalso; rw [hV8] at heq
        exact no_cycle_L5_V8 n a b c d e ha hb hc hd he hV8 heq

/-! ## Bridge from accelerated cycles to the cycle equation in ℤ -/

theorem accelerated_cycle_equation_int (k n : Nat)
    (hCycle : acceleratedOddIter k n = n) :
    (n : Int) * (2 ^ acceleratedTotalV k n - 3 ^ k) =
      ghostR (acceleratedTrace k n) := by
  have h := ParityWords.accelerated_cycle_equation k n hCycle
  have hZ : ((2 : Nat) ^ acceleratedTotalV k n * n : Int) =
      ((3 : Nat) ^ k * n + ParityWords.offset (acceleratedTrace k n) : Int) := by
    exact_mod_cast h
  unfold ghostR
  push_cast at hZ ⊢
  linarith

/-! ## UniformBound port -/

private theorem list_sum_ge_length (ds : List Nat)
    (hvalid : ∀ x ∈ ds, 1 ≤ x) : ds.length ≤ ds.sum := by
  induction ds with
  | nil => simp
  | cons d rest ih =>
    have hd : 1 ≤ d := hvalid d (by simp)
    have hrest : ∀ x ∈ rest, 1 ≤ x := fun x hx => hvalid x (by simp [hx])
    have := ih hrest
    simp [List.sum_cons, List.length_cons]
    omega

theorem n_lt_of_ghostR_lt_kD (n k D R : Int)
    (hD_pos : 0 < D) (heq : n * D = R) (hR_lt : R < k * D) :
    n < k := by
  have : n * D < k * D := by linarith
  exact lt_of_mul_lt_mul_right this (le_of_lt hD_pos)

end CycleExclusionL4L5

/-! ## Symbolic length-4 and length-5 exclusion via the integer cycle equation

Each canonical accelerated-trace entry is `oddPartSteps (3 m + 1)` for
`m` a positive odd, so every entry is `≥ 1`. Combined with
`pow_three_lt_pow_two_of_cycle` (forcing `3^L < 2^V`), the abstract
no-cycle theorems above (`no_nontrivial_four_cycle`,
`no_nontrivial_five_cycle`) apply directly. -/

theorem oddPartSteps_three_succ_pos_int (m : Nat) (hodd : m % 2 = 1) :
    1 ≤ oddPartSteps (3 * m + 1) := by
  have hEven : (3 * m + 1) % 2 = 0 := by omega
  have hPos : 0 < 3 * m + 1 := by omega
  rw [oddPartSteps_even_succ (3 * m + 1) hPos hEven]
  omega

/-- A length-4 accelerated odd cycle exists only at `q = 1`. -/
theorem isAcceleratedOddCycle_four_q_eq_one (q : Nat)
    (h : IsAcceleratedOddCycle 4 q) : q = 1 := by
  rcases h with ⟨_, hpos, hodd, hCycle⟩
  have hodd1 : acceleratedOddStep q % 2 = 1 := acceleratedOddStep_odd q
  have hodd2 : acceleratedOddStep (acceleratedOddStep q) % 2 = 1 :=
    acceleratedOddStep_odd _
  have hodd3 :
      acceleratedOddStep (acceleratedOddStep (acceleratedOddStep q)) % 2 = 1 :=
    acceleratedOddStep_odd _
  set a := oddPartSteps (3 * q + 1) with ha_def
  set b := oddPartSteps (3 * acceleratedOddStep q + 1) with hb_def
  set c := oddPartSteps (3 * acceleratedOddStep (acceleratedOddStep q) + 1)
    with hc_def
  set d := oddPartSteps
    (3 * acceleratedOddStep (acceleratedOddStep (acceleratedOddStep q)) + 1)
    with hd_def
  have ha : 1 ≤ a := oddPartSteps_three_succ_pos_int q hodd
  have hb : 1 ≤ b := oddPartSteps_three_succ_pos_int _ hodd1
  have hc : 1 ≤ c := oddPartSteps_three_succ_pos_int _ hodd2
  have hd : 1 ≤ d := oddPartSteps_three_succ_pos_int _ hodd3
  have hTrace : ParityWords.acceleratedTrace 4 q = [a, b, c, d] := rfl
  have hTotalV : ParityWords.acceleratedTotalV 4 q = a + b + c + d := by
    change ParityWords.totalV (ParityWords.acceleratedTrace 4 q) = a + b + c + d
    rw [hTrace]; simp [ParityWords.totalV]; ring
  -- V ≥ 7 from `pow_three_lt_pow_two_of_cycle`
  have hAdm : ParityWords.Admissible (ParityWords.acceleratedTrace 4 q) q :=
    ParityWords.admissible_acceleratedTrace 4 q
  have hApp : ParityWords.applyWord (ParityWords.acceleratedTrace 4 q) q = q := by
    rw [ParityWords.applyWord_acceleratedTrace]; exact hCycle
  have hLen : (ParityWords.acceleratedTrace 4 q).length = 4 :=
    ParityWords.length_acceleratedTrace 4 q
  have hNonempty : ParityWords.acceleratedTrace 4 q ≠ [] := by
    intro he; rw [he] at hLen; simp at hLen
  have hpw := ParityWords.pow_three_lt_pow_two_of_cycle
    (ParityWords.acceleratedTrace 4 q) q hNonempty hAdm hApp
  rw [hLen] at hpw
  have hV7 : 7 ≤ a + b + c + d := by
    have hpwV : (3 : Nat) ^ 4 < 2 ^ (a + b + c + d) := by
      have hTV :
          ParityWords.totalV (ParityWords.acceleratedTrace 4 q) = a + b + c + d :=
        hTotalV
      rw [hTV] at hpw; exact hpw
    have h81 : (3 : Nat) ^ 4 = 81 := by decide
    rw [h81] at hpwV
    by_contra hlt
    push_neg at hlt
    have hVle6 : a + b + c + d ≤ 6 := by omega
    have hPow : (2 : Nat) ^ (a + b + c + d) ≤ 2 ^ 6 :=
      Nat.pow_le_pow_right (by decide) hVle6
    have h64 : (2 : Nat) ^ 6 = 64 := by decide
    omega
  -- Cycle equation in ℤ
  have heqInt : (q : Int) * (2 ^ ParityWords.acceleratedTotalV 4 q - 3 ^ 4) =
      CycleExclusionL4L5.ghostR (ParityWords.acceleratedTrace 4 q) :=
    CycleExclusionL4L5.accelerated_cycle_equation_int 4 q hCycle
  rw [hTotalV, hTrace] at heqInt
  have hqInt_pos : (0 : Int) < (q : Int) := by exact_mod_cast hpos
  have hq1 : (q : Int) = 1 :=
    CycleExclusionL4L5.no_nontrivial_four_cycle
      (q : Int) hqInt_pos a b c d ha hb hc hd hV7 heqInt
  exact_mod_cast hq1

/-- No nontrivial length-4 accelerated odd cycle exists. -/
theorem not_isAcceleratedOddCycle_four_of_gt_one (q : Nat) (hq : 1 < q) :
    ¬ IsAcceleratedOddCycle 4 q := by
  intro h
  have hq1 : q = 1 := isAcceleratedOddCycle_four_q_eq_one q h
  omega

/-- A length-5 accelerated odd cycle exists only at `q = 1`. -/
theorem isAcceleratedOddCycle_five_q_eq_one (q : Nat)
    (h : IsAcceleratedOddCycle 5 q) : q = 1 := by
  rcases h with ⟨_, hpos, hodd, hCycle⟩
  have hodd1 : acceleratedOddStep q % 2 = 1 := acceleratedOddStep_odd q
  have hodd2 : acceleratedOddStep (acceleratedOddStep q) % 2 = 1 :=
    acceleratedOddStep_odd _
  have hodd3 :
      acceleratedOddStep (acceleratedOddStep (acceleratedOddStep q)) % 2 = 1 :=
    acceleratedOddStep_odd _
  have hodd4 :
      acceleratedOddStep (acceleratedOddStep
        (acceleratedOddStep (acceleratedOddStep q))) % 2 = 1 :=
    acceleratedOddStep_odd _
  set a := oddPartSteps (3 * q + 1) with ha_def
  set b := oddPartSteps (3 * acceleratedOddStep q + 1) with hb_def
  set c := oddPartSteps (3 * acceleratedOddStep (acceleratedOddStep q) + 1)
    with hc_def
  set d := oddPartSteps
    (3 * acceleratedOddStep (acceleratedOddStep (acceleratedOddStep q)) + 1)
    with hd_def
  set e := oddPartSteps
    (3 * acceleratedOddStep
      (acceleratedOddStep (acceleratedOddStep (acceleratedOddStep q))) + 1)
    with he_def
  have ha : 1 ≤ a := oddPartSteps_three_succ_pos_int q hodd
  have hb : 1 ≤ b := oddPartSteps_three_succ_pos_int _ hodd1
  have hc : 1 ≤ c := oddPartSteps_three_succ_pos_int _ hodd2
  have hd : 1 ≤ d := oddPartSteps_three_succ_pos_int _ hodd3
  have he : 1 ≤ e := oddPartSteps_three_succ_pos_int _ hodd4
  have hTrace : ParityWords.acceleratedTrace 5 q = [a, b, c, d, e] := rfl
  have hTotalV : ParityWords.acceleratedTotalV 5 q = a + b + c + d + e := by
    change ParityWords.totalV (ParityWords.acceleratedTrace 5 q) = a + b + c + d + e
    rw [hTrace]; simp [ParityWords.totalV]; ring
  have hAdm : ParityWords.Admissible (ParityWords.acceleratedTrace 5 q) q :=
    ParityWords.admissible_acceleratedTrace 5 q
  have hApp : ParityWords.applyWord (ParityWords.acceleratedTrace 5 q) q = q := by
    rw [ParityWords.applyWord_acceleratedTrace]; exact hCycle
  have hLen : (ParityWords.acceleratedTrace 5 q).length = 5 :=
    ParityWords.length_acceleratedTrace 5 q
  have hNonempty : ParityWords.acceleratedTrace 5 q ≠ [] := by
    intro h5; rw [h5] at hLen; simp at hLen
  have hpw := ParityWords.pow_three_lt_pow_two_of_cycle
    (ParityWords.acceleratedTrace 5 q) q hNonempty hAdm hApp
  rw [hLen] at hpw
  have hV8 : 8 ≤ a + b + c + d + e := by
    have hpwV : (3 : Nat) ^ 5 < 2 ^ (a + b + c + d + e) := by
      have hTV :
          ParityWords.totalV (ParityWords.acceleratedTrace 5 q) =
            a + b + c + d + e := hTotalV
      rw [hTV] at hpw; exact hpw
    have h243 : (3 : Nat) ^ 5 = 243 := by decide
    rw [h243] at hpwV
    by_contra hlt
    push_neg at hlt
    have hVle7 : a + b + c + d + e ≤ 7 := by omega
    have hPow : (2 : Nat) ^ (a + b + c + d + e) ≤ 2 ^ 7 :=
      Nat.pow_le_pow_right (by decide) hVle7
    have h128 : (2 : Nat) ^ 7 = 128 := by decide
    omega
  have heqInt : (q : Int) * (2 ^ ParityWords.acceleratedTotalV 5 q - 3 ^ 5) =
      CycleExclusionL4L5.ghostR (ParityWords.acceleratedTrace 5 q) :=
    CycleExclusionL4L5.accelerated_cycle_equation_int 5 q hCycle
  rw [hTotalV, hTrace] at heqInt
  have hqInt_pos : (0 : Int) < (q : Int) := by exact_mod_cast hpos
  have hq1 : (q : Int) = 1 :=
    CycleExclusionL4L5.no_nontrivial_five_cycle
      (q : Int) hqInt_pos a b c d e ha hb hc hd he hV8 heqInt
  exact_mod_cast hq1

/-- No nontrivial length-5 accelerated odd cycle exists. -/
theorem not_isAcceleratedOddCycle_five_of_gt_one (q : Nat) (hq : 1 < q) :
    ¬ IsAcceleratedOddCycle 5 q := by
  intro h
  have hq1 : q = 1 := isAcceleratedOddCycle_five_q_eq_one q h
  omega

/-! ## Headline upgrade: extracted accelerated period ≥ 6

Combining `not_isAcceleratedOddCycle_{one,two,three,four,five}_of_gt_one`,
no classical Collatz cycle counterexample has accelerated period `≤ 5`. -/

private theorem not_isAcceleratedOddCycle_le_five_of_gt_one
    (q k : Nat) (hq : 1 < q) (hk : 1 ≤ k) (hkle : k ≤ 5) :
    ¬ IsAcceleratedOddCycle k q := by
  match k, hk, hkle with
  | 1, _, _ => exact not_isAcceleratedOddCycle_one_of_gt_one q hq
  | 2, _, _ => exact not_isAcceleratedOddCycle_two_of_gt_one q hq
  | 3, _, _ => exact not_isAcceleratedOddCycle_three_of_gt_one q hq
  | 4, _, _ => exact not_isAcceleratedOddCycle_four_of_gt_one q hq
  | 5, _, _ => exact not_isAcceleratedOddCycle_five_of_gt_one q hq

/-- **Strengthened headline cycle result**: no classical Collatz cycle
counterexample has accelerated period `≤ 5`. The bridge from any cycle
counterexample produces a `(q, k)` with `k ≥ 6`. -/
theorem extracted_accelerated_period_ge_six
    (n : Nat) (hPosN : 0 < n) (hCE : CollatzEventualCycleCounterexample n) :
    ∃ q k : Nat, IsAcceleratedOddCycle k q ∧ 6 ≤ k := by
  rcases isAcceleratedOddCycle_of_collatz_cycle_counterexample n hPosN hCE
    with ⟨q, k, hQgt1, hCycle⟩
  refine ⟨q, k, hCycle, ?_⟩
  rcases Nat.lt_or_ge 5 k with h | h
  · omega
  · exact False.elim
      (not_isAcceleratedOddCycle_le_five_of_gt_one q k hQgt1 hCycle.1 h hCycle)
