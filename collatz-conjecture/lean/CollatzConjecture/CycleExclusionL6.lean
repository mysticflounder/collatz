/-
  Cycle exclusion at parity-word length L = 6.
  Generated from data/blueprint.db.
-/

import CollatzConjecture.SmallCycles
import CollatzConjecture.CycleResults
import CollatzConjecture.CycleExclusionL4L5
import Mathlib.Tactic

namespace CycleExclusionL6

open CycleExclusionL4L5

theorem ghostR_L6 (a b c d e f : Nat) :
    ghostR [a, b, c, d, e, f] =
      243 + 81 * 2 ^ a + 27 * 2 ^ (a + b) + 9 * 2 ^ (a + b + c) +
        3 * 2 ^ (a + b + c + d) + 2 ^ (a + b + c + d + e) := by
  simp [ghostR_cons, ghostR_nil]; ring

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

theorem n_odd_L6 (n : Int) (a b c d e f : Nat) (ha : 1 ≤ a)
    (heq : n * (2 ^ (a + b + c + d + e + f) - 3 ^ 6) = ghostR [a, b, c, d, e, f]) :
    ¬ 2 ∣ n := by
  intro ⟨m, hm⟩
  rw [hm, ghostR_L6, show (3 : Int) ^ 6 = 729 from by norm_num] at heq
  have heq_prime : 2 * (m * ((2 : Int) ^ (a + b + c + d + e + f) - 729)) -
      (81 * 2 ^ a + 27 * 2 ^ (a + b) + 9 * 2 ^ (a + b + c) +
        3 * 2 ^ (a + b + c + d) + 2 ^ (a + b + c + d + e)) = 243 := by linarith
  set a_prime := a - 1
  have ha_eq : a = a_prime + 1 := by omega
  obtain ⟨k, hk⟩ : (2 : Int) ∣
      (81 * 2 ^ a + 27 * 2 ^ (a + b) + 9 * 2 ^ (a + b + c) +
        3 * 2 ^ (a + b + c + d) + 2 ^ (a + b + c + d + e)) :=
    ⟨81 * 2 ^ a_prime + 27 * 2 ^ (a_prime + b) + 9 * 2 ^ (a_prime + b + c) +
      3 * 2 ^ (a_prime + b + c + d) + 2 ^ (a_prime + b + c + d + e),
      by rw [ha_eq]; ring⟩
  rw [hk] at heq_prime
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

/-- Route (c): finite range-check. R_lt_7D and the R ≥ 5·D lower bound force V into a finite window; enumerate (v₁,…,v₆) candidates with Decidable.decide. -/
theorem n_ne_5_L6_route_c (n : Int) (a b c d e f : Nat)
    (ha : 1 ≤ a) (hb : 1 ≤ b) (hc : 1 ≤ c) (hd : 1 ≤ d) (he : 1 ≤ e) (hf : 1 ≤ f)
    (heq : n * (2 ^ (a + b + c + d + e + f) - 3 ^ 6) = ghostR [a, b, c, d, e, f]) :
    n ≠ 5 := by
  intro hn5
  rw [hn5, ghostR_L6, show (3 : Int) ^ 6 = 729 from by norm_num] at heq
  -- heq : 5 * (2^V - 729) = 243 + 81·2^a + ... + 2^(a+b+c+d+e)
  -- Rewrite each 2^(a+...) as 2^a * 2^(...) to factor out 2^a.
  have hpow_ab : (2 : Int) ^ (a + b) = 2 ^ a * 2 ^ b := by rw [pow_add]
  have hpow_abc : (2 : Int) ^ (a + b + c) = 2 ^ a * 2 ^ (b + c) := by
    rw [show a + b + c = a + (b + c) from by ring, pow_add]
  have hpow_abcd : (2 : Int) ^ (a + b + c + d) = 2 ^ a * 2 ^ (b + c + d) := by
    rw [show a + b + c + d = a + (b + c + d) from by ring, pow_add]
  have hpow_abcde : (2 : Int) ^ (a + b + c + d + e) = 2 ^ a * 2 ^ (b + c + d + e) := by
    rw [show a + b + c + d + e = a + (b + c + d + e) from by ring, pow_add]
  have hpow_V : (2 : Int) ^ (a + b + c + d + e + f) =
      2 ^ a * 2 ^ (b + c + d + e + f) := by
    rw [show a + b + c + d + e + f = a + (b + c + d + e + f) from by ring, pow_add]
  -- Rearrange: 5·2^V - 5·729 = 243 + 2^a · K
  -- so 2^a · (5·2^(b+...+f) - 81 - 27·2^b - 9·2^(b+c) - 3·2^(b+c+d) - 2^(b+c+d+e))
  --   = 3888
  have heq2 : (2 : Int) ^ a *
      (5 * 2 ^ (b + c + d + e + f) -
        (81 + 27 * 2 ^ b + 9 * 2 ^ (b + c) + 3 * 2 ^ (b + c + d) + 2 ^ (b + c + d + e)))
      = 3888 := by
    rw [hpow_V, hpow_ab, hpow_abc, hpow_abcd, hpow_abcde] at heq
    linarith
  -- Hence 2^a divides 3888 = 2^4 · 243.
  have hdvd_a : (2 : Int) ^ a ∣ 3888 := ⟨_, heq2.symm⟩
  -- From 2^a ∣ 3888, conclude a ≤ 4.
  have ha_le : a ≤ 4 := by
    by_contra hlt
    push_neg at hlt
    -- a ≥ 5, so 2^a ≥ 2^5 = 32.
    have h32 : (32 : Int) ≤ 2 ^ a :=
      le_trans (by norm_num : (32 : Int) ≤ 2 ^ 5)
        (pow_le_pow_right₀ (by norm_num) (by omega))
    -- 2^a ∣ 3888, but 2^5 ∤ 3888.
    -- 3888 = 2^4 · 243, so 2^5 ∣ 3888 ⟹ 2 ∣ 243, false.
    have h2_5 : (2 : Int) ^ 5 ∣ 3888 :=
      dvd_trans (pow_dvd_pow 2 (by omega : 5 ≤ a)) hdvd_a
    have : (32 : Int) ∣ 3888 := by simpa using h2_5
    omega
  -- Re-express heq using V = a + (b+c+d+e+f) factoring 2^a:
  -- 5·2^a·2^(b+...+f) - 3645 = 243 + 2^a·(81 + 27·2^b + ... + 2^(b+c+d+e))
  -- We'll repeat the 2-adic bound for b, c, d, e in turn. After interval_cases a,
  -- substitute a and use the same factoring trick on b.
  -- The constant on RHS of `2^b * (...) = N` is:
  --   a=1: N = 5·729/2^? ...
  --   Cleanest: compute the master equation
  --     5·2^V - 5·729 = 243 + 81·2^a + 27·2^(a+b) + ... + 2^(a+b+c+d+e)
  --   Rearrange to factor 2^b: 2^b·(...) + constant = constant.
  --
  -- Begin: factor 2^b from the b+1...e+1 terms.
  have hpow_bc : (2 : Int) ^ (b + c) = 2 ^ b * 2 ^ c := by rw [pow_add]
  have hpow_bcd : (2 : Int) ^ (b + c + d) = 2 ^ b * 2 ^ (c + d) := by
    rw [show b + c + d = b + (c + d) from by ring, pow_add]
  have hpow_bcde : (2 : Int) ^ (b + c + d + e) = 2 ^ b * 2 ^ (c + d + e) := by
    rw [show b + c + d + e = b + (c + d + e) from by ring, pow_add]
  have hpow_VprimeB : (2 : Int) ^ (b + c + d + e + f) =
      2 ^ b * 2 ^ (c + d + e + f) := by
    rw [show b + c + d + e + f = b + (c + d + e + f) from by ring, pow_add]
  -- From heq2, derive: 2^b · (5·2^(c+...+f) - 27 - 9·2^c - 3·2^(c+d) - 2^(c+d+e))
  --                    = 81 + 3888 / 2^a
  -- We do this after fixing a.
  interval_cases a
  -- Case a = 1: 2 * (...) = 3888 ⟹ ... = 1944. Then 2^b | 2025.
  · -- heq2 : 2^1 * (5·2^V' - 81 - 27·2^b - 9·2^(b+c) - ... ) = 3888
    have heq3 : (2 : Int) ^ b *
        (5 * 2 ^ (c + d + e + f) -
          (27 + 9 * 2 ^ c + 3 * 2 ^ (c + d) + 2 ^ (c + d + e))) = 2025 := by
      rw [hpow_VprimeB, hpow_bc, hpow_bcd, hpow_bcde] at heq2
      linarith
    have hdvd_b : (2 : Int) ^ b ∣ 2025 := ⟨_, heq3.symm⟩
    -- 2025 is odd, so 2^b | 2025 ⟹ b = 0, contradicting b ≥ 1.
    have h2 : (2 : Int) ∣ 2025 :=
      dvd_trans (dvd_pow_self 2 (by omega : b ≠ 0)) hdvd_b
    omega
  -- Case a = 2: 4 * (...) = 3888 ⟹ ... = 972. Then 2^b | 1053.
  · have heq3 : (2 : Int) ^ b *
        (5 * 2 ^ (c + d + e + f) -
          (27 + 9 * 2 ^ c + 3 * 2 ^ (c + d) + 2 ^ (c + d + e))) = 1053 := by
      rw [hpow_VprimeB, hpow_bc, hpow_bcd, hpow_bcde] at heq2
      linarith
    have hdvd_b : (2 : Int) ^ b ∣ 1053 := ⟨_, heq3.symm⟩
    have h2 : (2 : Int) ∣ 1053 :=
      dvd_trans (dvd_pow_self 2 (by omega : b ≠ 0)) hdvd_b
    omega
  -- Case a = 3: 8 * (...) = 3888 ⟹ ... = 486. Then 2^b | 567.
  · have heq3 : (2 : Int) ^ b *
        (5 * 2 ^ (c + d + e + f) -
          (27 + 9 * 2 ^ c + 3 * 2 ^ (c + d) + 2 ^ (c + d + e))) = 567 := by
      rw [hpow_VprimeB, hpow_bc, hpow_bcd, hpow_bcde] at heq2
      linarith
    have hdvd_b : (2 : Int) ^ b ∣ 567 := ⟨_, heq3.symm⟩
    have h2 : (2 : Int) ∣ 567 :=
      dvd_trans (dvd_pow_self 2 (by omega : b ≠ 0)) hdvd_b
    omega
  -- Case a = 4: 16 * (...) = 3888 ⟹ ... = 243. Then 2^b | 324.
  · have heq3 : (2 : Int) ^ b *
        (5 * 2 ^ (c + d + e + f) -
          (27 + 9 * 2 ^ c + 3 * 2 ^ (c + d) + 2 ^ (c + d + e))) = 324 := by
      rw [hpow_VprimeB, hpow_bc, hpow_bcd, hpow_bcde] at heq2
      linarith
    have hdvd_b : (2 : Int) ^ b ∣ 324 := ⟨_, heq3.symm⟩
    -- 324 = 4·81, so 2^b | 324 ⟹ b ≤ 2.
    have hb_le : b ≤ 2 := by
      by_contra hlt
      push_neg at hlt
      have h8 : (8 : Int) ∣ 324 :=
        dvd_trans (pow_dvd_pow 2 (by omega : 3 ≤ b)) hdvd_b
      omega
    -- Factor 2^c from c+d+e terms inside heq3.
    have hpow_cd : (2 : Int) ^ (c + d) = 2 ^ c * 2 ^ d := by rw [pow_add]
    have hpow_cde : (2 : Int) ^ (c + d + e) = 2 ^ c * 2 ^ (d + e) := by
      rw [show c + d + e = c + (d + e) from by ring, pow_add]
    have hpow_VprimeC : (2 : Int) ^ (c + d + e + f) =
        2 ^ c * 2 ^ (d + e + f) := by
      rw [show c + d + e + f = c + (d + e + f) from by ring, pow_add]
    interval_cases b
    -- Sub-case (a,b) = (4,1): 2·(...) = 324 ⟹ ... = 162.
    -- 5·2^(c+d+e+f) - 27 - 9·2^c - 3·2^(c+d) - 2^(c+d+e) = 162.
    -- 5·2^V'' - 9·2^c - 3·2^(c+d) - 2^(c+d+e) = 189.
    -- 2^c · (5·2^(d+e+f) - 9 - 3·2^d - 2^(d+e)) = 189.
    -- 189 = 27·7 odd, so c ≤ 0, contradiction.
    · have heq4 : (2 : Int) ^ c *
          (5 * 2 ^ (d + e + f) - (9 + 3 * 2 ^ d + 2 ^ (d + e))) = 189 := by
        rw [hpow_VprimeC, hpow_cd, hpow_cde] at heq3
        linarith
      have hdvd_c : (2 : Int) ^ c ∣ 189 := ⟨_, heq4.symm⟩
      have h2 : (2 : Int) ∣ 189 :=
        dvd_trans (dvd_pow_self 2 (by omega : c ≠ 0)) hdvd_c
      omega
    -- Sub-case (a,b) = (4,2): 4·(...) = 324 ⟹ ... = 81.
    -- 5·2^(c+d+e+f) - 27 - 9·2^c - 3·2^(c+d) - 2^(c+d+e) = 81.
    -- 5·2^V'' - 9·2^c - 3·2^(c+d) - 2^(c+d+e) = 108.
    -- 2^c · (5·2^(d+e+f) - 9 - 3·2^d - 2^(d+e)) = 108.
    -- 108 = 4·27, so c ≤ 2.
    · have heq4 : (2 : Int) ^ c *
          (5 * 2 ^ (d + e + f) - (9 + 3 * 2 ^ d + 2 ^ (d + e))) = 108 := by
        rw [hpow_VprimeC, hpow_cd, hpow_cde] at heq3
        linarith
      have hdvd_c : (2 : Int) ^ c ∣ 108 := ⟨_, heq4.symm⟩
      have hc_le : c ≤ 2 := by
        by_contra hlt
        push_neg at hlt
        have h8 : (8 : Int) ∣ 108 :=
          dvd_trans (pow_dvd_pow 2 (by omega : 3 ≤ c)) hdvd_c
        omega
      -- Factor 2^d from d, d+e terms.
      have hpow_de : (2 : Int) ^ (d + e) = 2 ^ d * 2 ^ e := by rw [pow_add]
      have hpow_VprimeD : (2 : Int) ^ (d + e + f) =
          2 ^ d * 2 ^ (e + f) := by
        rw [show d + e + f = d + (e + f) from by ring, pow_add]
      interval_cases c
      -- Sub-case (a,b,c) = (4,2,1): 2·(...) = 108 ⟹ ... = 54.
      -- 5·2^(d+e+f) - 9 - 3·2^d - 2^(d+e) = 54.
      -- 5·2^V''' - 3·2^d - 2^(d+e) = 63.
      -- 2^d · (5·2^(e+f) - 3 - 2^e) = 63.
      -- 63 odd, d ≤ 0, contradiction.
      · have heq5 : (2 : Int) ^ d *
            (5 * 2 ^ (e + f) - (3 + 2 ^ e)) = 63 := by
          rw [hpow_VprimeD, hpow_de] at heq4
          linarith
        have hdvd_d : (2 : Int) ^ d ∣ 63 := ⟨_, heq5.symm⟩
        have h2 : (2 : Int) ∣ 63 :=
          dvd_trans (dvd_pow_self 2 (by omega : d ≠ 0)) hdvd_d
        omega
      -- Sub-case (a,b,c) = (4,2,2): 4·(...) = 108 ⟹ ... = 27.
      -- 5·2^(d+e+f) - 9 - 3·2^d - 2^(d+e) = 27.
      -- 5·2^V''' - 3·2^d - 2^(d+e) = 36.
      -- 2^d · (5·2^(e+f) - 3 - 2^e) = 36.
      -- 36 = 4·9, d ≤ 2.
      · have heq5 : (2 : Int) ^ d *
            (5 * 2 ^ (e + f) - (3 + 2 ^ e)) = 36 := by
          rw [hpow_VprimeD, hpow_de] at heq4
          linarith
        have hdvd_d : (2 : Int) ^ d ∣ 36 := ⟨_, heq5.symm⟩
        have hd_le : d ≤ 2 := by
          by_contra hlt
          push_neg at hlt
          have h8 : (8 : Int) ∣ 36 :=
            dvd_trans (pow_dvd_pow 2 (by omega : 3 ≤ d)) hdvd_d
          omega
        -- Factor 2^e from e term.
        have hpow_VprimeE : (2 : Int) ^ (e + f) = 2 ^ e * 2 ^ f := by rw [pow_add]
        interval_cases d
        -- Sub-case (a,b,c,d) = (4,2,2,1): 2·(...) = 36 ⟹ ... = 18.
        -- 5·2^(e+f) - 3 - 2^e = 18.
        -- 5·2^(e+f) - 2^e = 21.
        -- 2^e · (5·2^f - 1) = 21.
        -- 21 = 3·7 odd, e ≤ 0, contradiction.
        · have heq6 : (2 : Int) ^ e *
              (5 * 2 ^ f - 1) = 21 := by
            rw [hpow_VprimeE] at heq5
            linarith
          have hdvd_e : (2 : Int) ^ e ∣ 21 := ⟨_, heq6.symm⟩
          have h2 : (2 : Int) ∣ 21 :=
            dvd_trans (dvd_pow_self 2 (by omega : e ≠ 0)) hdvd_e
          omega
        -- Sub-case (a,b,c,d) = (4,2,2,2): 4·(...) = 36 ⟹ ... = 9.
        -- 5·2^(e+f) - 3 - 2^e = 9.
        -- 5·2^(e+f) - 2^e = 12.
        -- 2^e · (5·2^f - 1) = 12.
        -- 12 = 4·3, e ≤ 2.
        · have heq6 : (2 : Int) ^ e *
              (5 * 2 ^ f - 1) = 12 := by
            rw [hpow_VprimeE] at heq5
            linarith
          have hdvd_e : (2 : Int) ^ e ∣ 12 := ⟨_, heq6.symm⟩
          have he_le : e ≤ 2 := by
            by_contra hlt
            push_neg at hlt
            have h8 : (8 : Int) ∣ 12 :=
              dvd_trans (pow_dvd_pow 2 (by omega : 3 ≤ e)) hdvd_e
            omega
          interval_cases e
          -- (a,b,c,d,e) = (4,2,2,2,1): 2·(5·2^f - 1) = 12 ⟹ 5·2^f - 1 = 6 ⟹ 5·2^f = 7.
          · -- 5·2^f = 7 has no positive integer solution.
            have : 5 * (2 : Int) ^ f = 7 := by linarith
            -- 5·2^f ≥ 5·2 = 10 > 7 (since f ≥ 1).
            have hpow_f : (2 : Int) ≤ 2 ^ f :=
              le_trans (by norm_num : (2 : Int) ≤ 2 ^ 1)
                (pow_le_pow_right₀ (by norm_num) hf)
            linarith
          -- (a,b,c,d,e) = (4,2,2,2,2): 4·(5·2^f - 1) = 12 ⟹ 5·2^f - 1 = 3 ⟹ 5·2^f = 4.
          · have : 5 * (2 : Int) ^ f = 4 := by linarith
            have hpow_f : (2 : Int) ≤ 2 ^ f :=
              le_trans (by norm_num : (2 : Int) ≤ 2 ^ 1)
                (pow_le_pow_right₀ (by norm_num) hf)
            linarith

theorem n_ne_5_L6 (n : Int) (a b c d e f : Nat)
    (ha : 1 ≤ a) (hb : 1 ≤ b) (hc : 1 ≤ c) (hd : 1 ≤ d) (he : 1 ≤ e) (hf : 1 ≤ f)
    (heq : n * (2 ^ (a + b + c + d + e + f) - 3 ^ 6) = ghostR [a, b, c, d, e, f]) :
    n ≠ 5 := by exact n_ne_5_L6_route_c n a b c d e f ha hb hc hd he hf heq

-- check: Positivity spot-check at V=10, tuple (5,1,1,1,1,1).
example : (5 : Int) * (2 ^ 10 - 729) ≠ ghostR [5, 1, 1, 1, 1, 1] := by decide

-- check: Positivity spot-check at V=11.
example : (5 : Int) * (2 ^ 11 - 729) ≠ ghostR [1, 1, 1, 1, 1, 6] := by decide

-- check: Positivity spot-check at V=14 (R<7D regime).
example : (5 : Int) * (2 ^ 14 - 729) ≠ ghostR [2, 2, 2, 2, 2, 4] := by decide

-- check: Arithmetic witness: the L=6 equation does have a no-positivity solution at (q=5; a=2,b=0,c=3,d=2,e=0,f=3), V=10. With positivity (each v_i >= 1) this tuple is invalid, so n_ne_5_L6 with positivity is unaffected. Compiles green.
example : (5 : Int) * (2 ^ 10 - 3 ^ 6) = ghostR [2, 0, 3, 2, 0, 3] := by decide

-- check: Positivity spot-check at V=10, tuple (1,1,1,1,1,5): 5·(2^10−729)=1475, ghostR=665, ≠. Confirms positivity-respecting CE-neighbor at V=10 does not satisfy q=5.
example : (5 : Int) * (2 ^ 10 - 729) ≠ ghostR [1, 1, 1, 1, 1, 5] := by decide

theorem no_cycle_L6_large_V (n : Int) (hn : 0 < n)
    (a b c d e f : Nat) (ha : 1 ≤ a) (hb : 1 ≤ b) (hc : 1 ≤ c) (hd : 1 ≤ d)
    (he : 1 ≤ e) (hf : 1 ≤ f)
    (hV : 14 ≤ a + b + c + d + e + f)
    (heq : n * (2 ^ (a + b + c + d + e + f) - 3 ^ 6) = ghostR [a, b, c, d, e, f]) :
    n = 1 := by
  have hRlt : ghostR [a, b, c, d, e, f] <
      7 * (2 ^ (a + b + c + d + e + f) - 729) :=
    R_lt_7D_L6 a b c d e f ha hb hc hd he hf hV
  have h729 : (3 : Int) ^ 6 = 729 := by norm_num
  rw [h729] at heq
  set D : Int := (2 : Int) ^ (a + b + c + d + e + f) - 729 with hD_def
  have hD_pos : 0 < D := by
    have h14 : ((2 : Int) ^ 14 : Int) ≤ (2 : Int) ^ (a + b + c + d + e + f) :=
      pow_le_pow_right₀ (by norm_num) (by omega)
    have h214 : (729 : Int) < 2 ^ 14 := by norm_num
    have : (729 : Int) < (2 : Int) ^ (a + b + c + d + e + f) := by linarith
    simpa [hD_def] using sub_pos.mpr this
  have hnD_lt : n * D < 7 * D := by
    have : n * D = ghostR [a, b, c, d, e, f] := by simpa [hD_def] using heq
    linarith
  have hn_lt7 : n < 7 := by
    by_contra h
    push_neg at h
    have hge : 7 * D ≤ n * D :=
      mul_le_mul_of_nonneg_right h (le_of_lt hD_pos)
    linarith
  have hn_odd : ¬ (2 : Int) ∣ n := by
    have heq' : n * ((2 : Int) ^ (a + b + c + d + e + f) - 3 ^ 6) =
        ghostR [a, b, c, d, e, f] := by
      simpa [h729] using heq
    exact n_odd_L6 n a b c d e f ha heq'
  have hn_ne3 : n ≠ 3 := by
    have heq' : n * ((2 : Int) ^ (a + b + c + d + e + f) - 3 ^ 6) =
        ghostR [a, b, c, d, e, f] := by
      simpa [h729] using heq
    exact n_ne_3_L6 n a b c d e f heq'
  have hn_ne5 : n ≠ 5 := by
    have heq' : n * ((2 : Int) ^ (a + b + c + d + e + f) - 3 ^ 6) =
        ghostR [a, b, c, d, e, f] := by
      simpa [h729] using heq
    exact n_ne_5_L6 n a b c d e f ha hb hc hd he hf heq'
  interval_cases n
  · rfl
  · exact absurd ⟨1, rfl⟩ hn_odd
  · exact absurd rfl hn_ne3
  · exact absurd ⟨2, rfl⟩ hn_odd
  · exact absurd rfl hn_ne5
  · exact absurd ⟨3, rfl⟩ hn_odd


theorem no_cycle_L6_V10 (n : Int) (a b c d e f : Nat) (_ha : 1 ≤ a) (_hb : 1 ≤ b)
    (_hc : 1 ≤ c) (_hd : 1 ≤ d) (_he : 1 ≤ e) (_hf : 1 ≤ f)
    (habcdef : a + b + c + d + e + f = 10)
    (heq : n * (2 ^ 10 - 3 ^ 6) = ghostR [a, b, c, d, e, f]) :
    False := by
  rw [show (3 : Int) ^ 6 = 729 from by norm_num, ghostR_L6] at heq
  have hba : a ≤ 5 := by omega
  have hbb : b ≤ 5 := by omega
  have hbc : c ≤ 5 := by omega
  have hbd : d ≤ 5 := by omega
  have hbe : e ≤ 5 := by omega
  interval_cases a <;> interval_cases b <;> interval_cases c <;>
    interval_cases d <;> interval_cases e <;> omega


set_option maxHeartbeats 400000 in
-- 6^5 = 7776 interval_cases × omega leaves exceed default 200000 budget.
theorem no_cycle_L6_V11 (n : Int) (a b c d e f : Nat) (_ha : 1 ≤ a) (_hb : 1 ≤ b)
    (_hc : 1 ≤ c) (_hd : 1 ≤ d) (_he : 1 ≤ e) (_hf : 1 ≤ f)
    (habcdef : a + b + c + d + e + f = 11)
    (heq : n * (2 ^ 11 - 3 ^ 6) = ghostR [a, b, c, d, e, f]) :
    False := by
  rw [show (3 : Int) ^ 6 = 729 from by norm_num, ghostR_L6] at heq
  have hba : a ≤ 6 := by omega
  have hbb : b ≤ 6 := by omega
  have hbc : c ≤ 6 := by omega
  have hbd : d ≤ 6 := by omega
  have hbe : e ≤ 6 := by omega
  interval_cases a <;> interval_cases b <;> interval_cases c <;>
    interval_cases d <;> interval_cases e <;> omega


set_option maxHeartbeats 1000000 in
-- 7^5 = 16807 interval_cases × omega leaves; one leaf (a..f=2) yields n=1, the rest are vacuous False.
theorem cycle_L6_V12 (n : Int) (a b c d e f : Nat) (_ha : 1 ≤ a) (_hb : 1 ≤ b)
    (_hc : 1 ≤ c) (_hd : 1 ≤ d) (_he : 1 ≤ e) (_hf : 1 ≤ f)
    (habcdef : a + b + c + d + e + f = 12)
    (heq : n * (2 ^ 12 - 3 ^ 6) = ghostR [a, b, c, d, e, f]) :
    n = 1 := by
  rw [show (3 : Int) ^ 6 = 729 from by norm_num, ghostR_L6] at heq
  have hba : a ≤ 7 := by omega
  have hbb : b ≤ 7 := by omega
  have hbc : c ≤ 7 := by omega
  have hbd : d ≤ 7 := by omega
  have hbe : e ≤ 7 := by omega
  interval_cases a <;> interval_cases b <;> interval_cases c <;>
    interval_cases d <;> interval_cases e <;> omega


set_option maxHeartbeats 2000000 in
-- 8^5 = 32768 interval_cases × omega leaves; every leaf is vacuously False (no R ≡ 0 mod 7463 witness at V=13).
theorem cycle_L6_V13 (n : Int) (a b c d e f : Nat) (_ha : 1 ≤ a) (_hb : 1 ≤ b)
    (_hc : 1 ≤ c) (_hd : 1 ≤ d) (_he : 1 ≤ e) (_hf : 1 ≤ f)
    (habcdef : a + b + c + d + e + f = 13)
    (heq : n * (2 ^ 13 - 3 ^ 6) = ghostR [a, b, c, d, e, f]) :
    n = 1 := by
  rw [show (3 : Int) ^ 6 = 729 from by norm_num, ghostR_L6] at heq
  have hba : a ≤ 8 := by omega
  have hbb : b ≤ 8 := by omega
  have hbc : c ≤ 8 := by omega
  have hbd : d ≤ 8 := by omega
  have hbe : e ≤ 8 := by omega
  interval_cases a <;> interval_cases b <;> interval_cases c <;>
    interval_cases d <;> interval_cases e <;> omega


theorem no_nontrivial_six_cycle (n : Int) (hn : 0 < n)
    (a b c d e f : Nat) (ha : 1 ≤ a) (hb : 1 ≤ b) (hc : 1 ≤ c) (hd : 1 ≤ d)
    (he : 1 ≤ e) (hf : 1 ≤ f)
    (hV : 10 ≤ a + b + c + d + e + f)
    (heq : n * (2 ^ (a + b + c + d + e + f) - 3 ^ 6) = ghostR [a, b, c, d, e, f]) :
    n = 1 := by
  by_cases hV14 : 14 ≤ a + b + c + d + e + f
  · exact no_cycle_L6_large_V n hn a b c d e f ha hb hc hd he hf hV14 heq
  · by_cases hV13 : a + b + c + d + e + f = 13
    · rw [hV13] at heq
      exact cycle_L6_V13 n a b c d e f ha hb hc hd he hf hV13 heq
    · by_cases hV12 : a + b + c + d + e + f = 12
      · rw [hV12] at heq
        exact cycle_L6_V12 n a b c d e f ha hb hc hd he hf hV12 heq
      · by_cases hV11 : a + b + c + d + e + f = 11
        · exfalso; rw [hV11] at heq
          exact no_cycle_L6_V11 n a b c d e f ha hb hc hd he hf hV11 heq
        · have hV10 : a + b + c + d + e + f = 10 := by omega
          exfalso; rw [hV10] at heq
          exact no_cycle_L6_V10 n a b c d e f ha hb hc hd he hf hV10 heq


theorem isAcceleratedOddCycle_six_q_eq_one (q : Nat)
    (h : IsAcceleratedOddCycle 6 q) : q = 1 := by
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
  have hodd5 :
      acceleratedOddStep (acceleratedOddStep
        (acceleratedOddStep (acceleratedOddStep (acceleratedOddStep q)))) % 2 = 1 :=
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
  set f := oddPartSteps
    (3 * acceleratedOddStep (acceleratedOddStep
      (acceleratedOddStep (acceleratedOddStep (acceleratedOddStep q)))) + 1)
    with hf_def
  have ha : 1 ≤ a := oddPartSteps_three_succ_pos_int q hodd
  have hb : 1 ≤ b := oddPartSteps_three_succ_pos_int _ hodd1
  have hc : 1 ≤ c := oddPartSteps_three_succ_pos_int _ hodd2
  have hd : 1 ≤ d := oddPartSteps_three_succ_pos_int _ hodd3
  have he : 1 ≤ e := oddPartSteps_three_succ_pos_int _ hodd4
  have hf : 1 ≤ f := oddPartSteps_three_succ_pos_int _ hodd5
  have hTrace : ParityWords.acceleratedTrace 6 q = [a, b, c, d, e, f] := rfl
  have hTotalV : ParityWords.acceleratedTotalV 6 q = a + b + c + d + e + f := by
    change ParityWords.totalV (ParityWords.acceleratedTrace 6 q) =
      a + b + c + d + e + f
    rw [hTrace]; simp [ParityWords.totalV]; ring
  have hAdm : ParityWords.Admissible (ParityWords.acceleratedTrace 6 q) q :=
    ParityWords.admissible_acceleratedTrace 6 q
  have hApp : ParityWords.applyWord (ParityWords.acceleratedTrace 6 q) q = q := by
    rw [ParityWords.applyWord_acceleratedTrace]; exact hCycle
  have hLen : (ParityWords.acceleratedTrace 6 q).length = 6 :=
    ParityWords.length_acceleratedTrace 6 q
  have hNonempty : ParityWords.acceleratedTrace 6 q ≠ [] := by
    intro h6; rw [h6] at hLen; simp at hLen
  have hpw := ParityWords.pow_three_lt_pow_two_of_cycle
    (ParityWords.acceleratedTrace 6 q) q hNonempty hAdm hApp
  rw [hLen] at hpw
  have hV10 : 10 ≤ a + b + c + d + e + f := by
    have hpwV : (3 : Nat) ^ 6 < 2 ^ (a + b + c + d + e + f) := by
      have hTV :
          ParityWords.totalV (ParityWords.acceleratedTrace 6 q) =
            a + b + c + d + e + f := hTotalV
      rw [hTV] at hpw; exact hpw
    have h729 : (3 : Nat) ^ 6 = 729 := by decide
    rw [h729] at hpwV
    by_contra hlt
    push_neg at hlt
    have hVle9 : a + b + c + d + e + f ≤ 9 := by omega
    have hPow : (2 : Nat) ^ (a + b + c + d + e + f) ≤ 2 ^ 9 :=
      Nat.pow_le_pow_right (by decide) hVle9
    have h512 : (2 : Nat) ^ 9 = 512 := by decide
    omega
  have heqInt : (q : Int) * (2 ^ ParityWords.acceleratedTotalV 6 q - 3 ^ 6) =
      CycleExclusionL4L5.ghostR (ParityWords.acceleratedTrace 6 q) :=
    CycleExclusionL4L5.accelerated_cycle_equation_int 6 q hCycle
  rw [hTotalV, hTrace] at heqInt
  have hqInt_pos : (0 : Int) < (q : Int) := by exact_mod_cast hpos
  have hq1 : (q : Int) = 1 :=
    no_nontrivial_six_cycle (q : Int) hqInt_pos a b c d e f ha hb hc hd he hf
      hV10 heqInt
  exact_mod_cast hq1


end CycleExclusionL6
