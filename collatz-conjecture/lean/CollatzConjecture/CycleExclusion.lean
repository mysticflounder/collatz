/-
  Cycle equation for parity-word periodic orbits.

  Phase 4 of the Collatz proof roadmap. If a parity word `v` closes up at
  `n` (i.e. `applyWord v n = n`), then by the block formula

      2 ^ totalV v * n = 3 ^ v.length * n + offset v.

  When `v` is non-empty and `n` is positive, this forces `3 ^ L < 2 ^ V`
  and yields the Diophantine cycle equation

      (2 ^ totalV v - 3 ^ v.length) * n = offset v.

  We also bridge accelerated odd orbits to parity words by recording the
  natural valuation at each step (`acceleratedTrace`), which is always
  admissible.

  This file uses only Lean core; no Mathlib dependency yet.
-/

import CollatzConjecture.ParityWords

namespace ParityWords

/-! ## Positivity of the affine offset -/

/-- The affine offset of a non-empty parity word is strictly positive. -/
theorem offset_pos : ∀ (v : ParityWord), v ≠ [] → 0 < offset v
  | [], h => absurd rfl h
  | _ :: rest, _ => by
      rw [offset_cons]
      exact Nat.lt_of_lt_of_le (Nat.pow_pos (by decide)) (Nat.le_add_right _ _)

/-! ## Cycle equation -/

/-- The cycle equation: a parity word that closes up at `n` gives the
identity `2 ^ V * n = 3 ^ L * n + offset v` directly from the block
formula. -/
theorem cycle_equation (v : ParityWord) (n : Nat)
    (hAdm : Admissible v n) (hCycle : applyWord v n = n) :
    2 ^ totalV v * n = 3 ^ v.length * n + offset v := by
  have h := applyWord_block_formula v n hAdm
  rw [hCycle] at h
  exact h

/-- Any non-trivial parity-word cycle forces the strict inequality
`3 ^ length v < 2 ^ totalV v`.

Note: positivity of `n` is *not* required: if a non-empty admissible word
satisfied `applyWord v 0 = 0`, the cycle equation would force the
positive `offset v` to vanish, which is already impossible. -/
theorem pow_three_lt_pow_two_of_cycle (v : ParityWord) (n : Nat)
    (hNonempty : v ≠ []) (hAdm : Admissible v n)
    (hCycle : applyWord v n = n) :
    3 ^ v.length < 2 ^ totalV v := by
  have heq : 2 ^ totalV v * n = 3 ^ v.length * n + offset v :=
    cycle_equation v n hAdm hCycle
  have hOffset : 0 < offset v := offset_pos v hNonempty
  rcases Nat.lt_or_ge (3 ^ v.length) (2 ^ totalV v) with h | h
  · exact h
  · exfalso
    have hMul_le : 2 ^ totalV v * n ≤ 3 ^ v.length * n :=
      Nat.mul_le_mul_right n h
    omega

/-- The Diophantine form of the cycle equation:
`(2 ^ totalV v - 3 ^ v.length) * n = offset v`.

The equation holds unconditionally given the cycle hypothesis: in the
regime `3 ^ v.length < 2 ^ totalV v` it is the genuine difference, and in
the (vacuous, by `pow_three_lt_pow_two_of_cycle`) opposite regime both
sides reduce to `0`. -/
theorem cycle_diophantine (v : ParityWord) (n : Nat)
    (hAdm : Admissible v n) (hCycle : applyWord v n = n) :
    (2 ^ totalV v - 3 ^ v.length) * n = offset v := by
  have heq : 2 ^ totalV v * n = 3 ^ v.length * n + offset v :=
    cycle_equation v n hAdm hCycle
  have hsub_mul : (2 ^ totalV v - 3 ^ v.length) * n =
      2 ^ totalV v * n - 3 ^ v.length * n :=
    Nat.sub_mul (2 ^ totalV v) (3 ^ v.length) n
  rw [hsub_mul, heq]
  omega

/-- The cycle equation as a divisibility statement:
`(2 ^ totalV v - 3 ^ v.length) ∣ offset v`. -/
theorem cycle_dvd (v : ParityWord) (n : Nat)
    (hAdm : Admissible v n) (hCycle : applyWord v n = n) :
    (2 ^ totalV v - 3 ^ v.length) ∣ offset v :=
  ⟨n, (cycle_diophantine v n hAdm hCycle).symm⟩

/-- The starting value of a non-trivial cycle is determined by the parity
word: `n = offset v / (2 ^ totalV v - 3 ^ v.length)`. -/
theorem cycle_quotient (v : ParityWord) (n : Nat)
    (hNonempty : v ≠ []) (hAdm : Admissible v n)
    (hCycle : applyWord v n = n) :
    n = offset v / (2 ^ totalV v - 3 ^ v.length) := by
  have hdiof := cycle_diophantine v n hAdm hCycle
  have hlt := pow_three_lt_pow_two_of_cycle v n hNonempty hAdm hCycle
  have hpos_diff : 0 < 2 ^ totalV v - 3 ^ v.length := Nat.sub_pos_of_lt hlt
  calc
    n = (2 ^ totalV v - 3 ^ v.length) * n / (2 ^ totalV v - 3 ^ v.length) := by
        rw [Nat.mul_div_cancel_left n hpos_diff]
    _ = offset v / (2 ^ totalV v - 3 ^ v.length) := by
        rw [hdiof]

/-! ## Concrete cycle exclusion: length 1

A length-1 admissible cycle has parity word `[k]` and forces the cycle
equation to `2^k · n = 3·n + 1`. Together with `n > 0`, this admits only
`n = 1` (with `k = 2`), capturing the trivial fixed point. -/

/-- Any length-1 admissible parity-word cycle at positive `n` forces `n = 1`. -/
theorem cycle_singleton_n_eq_one (k n : Nat) (hpos : 0 < n)
    (hAdm : Admissible [k] n) (hCycle : applyWord [k] n = n) : n = 1 := by
  have hEq : 2 ^ totalV [k] * n = 3 ^ ([k] : ParityWord).length * n + offset [k] :=
    cycle_equation [k] n hAdm hCycle
  have hTotalV : totalV [k] = k := by simp [totalV]
  have hLen : ([k] : ParityWord).length = 1 := rfl
  have hOffset : offset [k] = 1 := by simp [offset]
  rw [hTotalV, hLen, hOffset] at hEq
  have hReduce : 2 ^ k * n = 3 * n + 1 := by
    have h31 : (3 : Nat) ^ 1 = 3 := by decide
    rw [h31] at hEq
    exact hEq
  by_cases hcase : 2 ^ k ≤ 3
  · exfalso
    have hbound : 2 ^ k * n ≤ 3 * n := Nat.mul_le_mul_right n hcase
    omega
  · have h4 : 4 ≤ 2 ^ k := by omega
    have h4n : 4 * n ≤ 2 ^ k * n := Nat.mul_le_mul_right n h4
    omega

/-! ## Concrete cycle exclusion: length 2

A length-2 admissible cycle has parity word `[a, b]`, so `totalV = a + b`,
`length = 2`, and `offset = 3 + 2^a`. The cycle equation then reads

    2 ^ (a + b) · n = 9 · n + (3 + 2 ^ a).

We show that the only positive solution is `n = 1` (with `a + b = 4` and
`a = 2`, recovering the trivial fixed point as the cycle `1 → 1 → 1`). -/

/-- Any length-2 admissible parity-word cycle at positive `n` forces `n = 1`. -/
theorem cycle_pair_n_eq_one (a b n : Nat) (hpos : 0 < n)
    (hAdm : Admissible [a, b] n) (hCycle : applyWord [a, b] n = n) : n = 1 := by
  -- Specialise the cycle equation to length 2
  have hEq : 2 ^ totalV [a, b] * n =
      3 ^ ([a, b] : ParityWord).length * n + offset [a, b] :=
    cycle_equation [a, b] n hAdm hCycle
  have hTotalV : totalV [a, b] = a + b := by simp [totalV]
  have hLen : ([a, b] : ParityWord).length = 2 := rfl
  have hOffset : offset [a, b] = 3 + 2 ^ a := by simp [offset]
  rw [hTotalV, hLen, hOffset] at hEq
  have h_three_sq : (3 : Nat) ^ 2 = 9 := by decide
  rw [h_three_sq] at hEq
  -- hEq : 2 ^ (a + b) * n = 9 * n + (3 + 2 ^ a)
  have hA_le_AB : 2 ^ a ≤ 2 ^ (a + b) :=
    Nat.pow_le_pow_right (by decide) (Nat.le_add_right a b)
  have hA_pos : 1 ≤ 2 ^ a := Nat.pow_pos (by decide : 0 < 2)
  -- Either `n < 2` (forcing `n = 1` from `0 < n`) or `n ≥ 2` (impossible).
  rcases Nat.lt_or_ge n 2 with hsmall | hn2
  · omega
  exfalso
  -- Step 1: `2 ^ (a + b) ≥ 10` (else the cycle equation is absurd).
  have hAB_ge_10 : 10 ≤ 2 ^ (a + b) := by
    rcases Nat.lt_or_ge (2 ^ (a + b)) 10 with hlt | hge
    · exfalso
      have hAB_le : 2 ^ (a + b) ≤ 9 := by omega
      have hMul : 2 ^ (a + b) * n ≤ 9 * n := Nat.mul_le_mul_right n hAB_le
      omega
    · exact hge
  -- Step 2: `2 ^ (a + b) ≤ 21` (using `n ≥ 2` and `2 ^ a ≤ 2 ^ (a + b)`).
  have hSub_form : (2 ^ (a + b) - 9) * n = 3 + 2 ^ a := by
    have hsub_mul : (2 ^ (a + b) - 9) * n = 2 ^ (a + b) * n - 9 * n :=
      Nat.sub_mul (2 ^ (a + b)) 9 n
    rw [hsub_mul]
    omega
  have hSub_two : (2 ^ (a + b) - 9) * 2 ≤ 3 + 2 ^ a := by
    have h := Nat.mul_le_mul_left (2 ^ (a + b) - 9) hn2
    rw [hSub_form] at h
    exact h
  have hAB_le_21 : 2 ^ (a + b) ≤ 21 := by omega
  -- Step 3: `a + b = 4` (the only power of 2 in [10, 21] is 16).
  have h_ab_le_4 : a + b ≤ 4 := by
    rcases Nat.lt_or_ge (a + b) 5 with hle | hge
    · omega
    · exfalso
      have h_pow_ge : (2 : Nat) ^ 5 ≤ 2 ^ (a + b) :=
        Nat.pow_le_pow_right (by decide) hge
      have h32 : (2 : Nat) ^ 5 = 32 := by decide
      omega
  have h_ab_ge_4 : 4 ≤ a + b := by
    rcases Nat.lt_or_ge 4 (a + b + 1) with hge | hlt
    · omega
    · exfalso
      have h3 : a + b ≤ 3 := by omega
      have h_pow_le : 2 ^ (a + b) ≤ (2 : Nat) ^ 3 :=
        Nat.pow_le_pow_right (by decide) h3
      have h8 : (2 : Nat) ^ 3 = 8 := by decide
      omega
  have h_ab_eq : a + b = 4 := by omega
  rw [h_ab_eq] at hEq
  have h16 : (2 : Nat) ^ 4 = 16 := by decide
  rw [h16] at hEq
  -- hEq : 16 * n = 9 * n + (3 + 2 ^ a), i.e. 7n = 3 + 2^a
  -- Step 4: enumerate `a ∈ {0, 1, 2, 3, 4}` and rule out each via `omega`.
  have h_a_cases : a = 0 ∨ a = 1 ∨ a = 2 ∨ a = 3 ∨ a = 4 := by omega
  rcases h_a_cases with rfl | rfl | rfl | rfl | rfl
  · have h_two_a : (2 : Nat) ^ 0 = 1 := by decide
    rw [h_two_a] at hEq; omega
  · have h_two_a : (2 : Nat) ^ 1 = 2 := by decide
    rw [h_two_a] at hEq; omega
  · have h_two_a : (2 : Nat) ^ 2 = 4 := by decide
    rw [h_two_a] at hEq; omega
  · have h_two_a : (2 : Nat) ^ 3 = 8 := by decide
    rw [h_two_a] at hEq; omega
  · have h_two_a : (2 : Nat) ^ 4 = 16 := by decide
    rw [h_two_a] at hEq; omega

/-! ## Concrete cycle exclusion: length 3 (positive entries)

For length 3 the symbolic statement is more delicate: the parity word
`[2, 0, 3]` is admissible at `n = 5` and closes up there (`5 → 4 → 13 → 5`).
That non-canonical word is *not* an accelerated trace, since `0` is not
a valid canonical valuation: each `3 m + 1` for `m` positive odd is even,
forcing every accelerated-trace entry to be `≥ 1`.

We therefore restrict to parity words with strictly positive entries.
This still covers all canonical accelerated traces, so the accelerated
length-3 cycle exclusion follows. -/

/-- Any length-3 admissible parity-word cycle at positive `n` with all
entries `≥ 1` forces `n = 1`. -/
theorem cycle_triple_n_eq_one (a b c n : Nat)
    (ha : 1 ≤ a) (hb : 1 ≤ b) (hc : 1 ≤ c) (hpos : 0 < n)
    (hAdm : Admissible [a, b, c] n) (hCycle : applyWord [a, b, c] n = n) :
    n = 1 := by
  have hEq : 2 ^ totalV [a, b, c] * n =
      3 ^ ([a, b, c] : ParityWord).length * n + offset [a, b, c] :=
    cycle_equation [a, b, c] n hAdm hCycle
  have hTotalV : totalV [a, b, c] = a + b + c := by
    show a + (b + (c + 0)) = a + b + c
    omega
  have hLen : ([a, b, c] : ParityWord).length = 3 := rfl
  have hOffset : offset [a, b, c] = 9 + 2 ^ a * (3 + 2 ^ b) := by simp [offset]
  rw [hTotalV, hLen, hOffset] at hEq
  have h27 : (3 : Nat) ^ 3 = 27 := by decide
  rw [h27] at hEq
  -- hEq : 2 ^ (a + b + c) * n = 27 * n + (9 + 2 ^ a * (3 + 2 ^ b))
  -- Expand offset: 9 + 2^a * (3 + 2^b) = 9 + 3 * 2^a + 2^a * 2^b
  have h_offset_expand : 2 ^ a * (3 + 2 ^ b) = 3 * 2 ^ a + 2 ^ a * 2 ^ b := by
    rw [Nat.mul_add, Nat.mul_comm (2 ^ a) 3]
  rw [h_offset_expand] at hEq
  -- hEq : 2 ^ (a + b + c) * n = 27 * n + (9 + (3 * 2 ^ a + 2 ^ a * 2 ^ b))
  rcases Nat.lt_or_ge n 2 with hn1 | hn2
  · omega
  exfalso
  -- Step 1: a + b + c ≥ 5 (else 2^(a+b+c) ≤ 16 contradicts the equation).
  have hSig_ge_5 : 5 ≤ a + b + c := by
    rcases Nat.lt_or_ge (a + b + c) 5 with hlt | hge
    · exfalso
      have h4 : a + b + c ≤ 4 := by omega
      have hT_le_16 : 2 ^ (a + b + c) ≤ 16 := by
        calc 2 ^ (a + b + c) ≤ (2 : Nat) ^ 4 :=
              Nat.pow_le_pow_right (by decide) h4
          _ = 16 := by decide
      have hMul_le : 2 ^ (a + b + c) * n ≤ 16 * n :=
        Nat.mul_le_mul_right n hT_le_16
      omega
    · exact hge
  -- Step 2: T ≥ 32 and T ≥ 27 (consequences of Σ ≥ 5).
  have hT_ge_32 : 32 ≤ 2 ^ (a + b + c) := by
    calc (32 : Nat) = 2 ^ 5 := by decide
      _ ≤ 2 ^ (a + b + c) := Nat.pow_le_pow_right (by decide) hSig_ge_5
  -- Step 3: bounds 4·2^a ≤ T  and  2·(2^a·2^b) ≤ T.
  have hAle : 4 * 2 ^ a ≤ 2 ^ (a + b + c) := by
    have h_eq : 4 * 2 ^ a = 2 ^ (a + 2) := by
      rw [Nat.pow_add]
      have h_pow : (2 : Nat) ^ 2 = 4 := by decide
      rw [h_pow, Nat.mul_comm]
    rw [h_eq]
    apply Nat.pow_le_pow_right (by decide)
    omega
  have hABle : 2 * (2 ^ a * 2 ^ b) ≤ 2 ^ (a + b + c) := by
    have h_le : a + b + 1 ≤ a + b + c := by omega
    have hpow : 2 ^ (a + b + 1) ≤ 2 ^ (a + b + c) :=
      Nat.pow_le_pow_right (by decide) h_le
    have h_eq : 2 ^ (a + b + 1) = 2 * (2 ^ a * 2 ^ b) := by
      rw [Nat.pow_add 2 (a + b) 1, Nat.pow_add 2 a b]
      have h_pow : (2 : Nat) ^ 1 = 2 := by decide
      rw [h_pow, Nat.mul_comm]
    rw [← h_eq]; exact hpow
  -- Step 4: Diophantine form (T - 27)·n = 9 + 3·2^a + 2^a·2^b.
  have hSub_form :
      (2 ^ (a + b + c) - 27) * n = 9 + (3 * 2 ^ a + 2 ^ a * 2 ^ b) := by
    have hsub_mul : (2 ^ (a + b + c) - 27) * n =
        2 ^ (a + b + c) * n - 27 * n :=
      Nat.sub_mul (2 ^ (a + b + c)) 27 n
    rw [hsub_mul]
    omega
  have hSub_two :
      (2 ^ (a + b + c) - 27) * 2 ≤ 9 + (3 * 2 ^ a + 2 ^ a * 2 ^ b) := by
    have h := Nat.mul_le_mul_left (2 ^ (a + b + c) - 27) hn2
    rw [hSub_form] at h
    exact h
  -- Step 5: bound T ≤ 84.
  have hT_le_84 : 2 ^ (a + b + c) ≤ 84 := by omega
  -- Step 6: a + b + c ≤ 6 (since 2^7 = 128 > 84).
  have hSig_le_6 : a + b + c ≤ 6 := by
    rcases Nat.lt_or_ge (a + b + c) 7 with hlt | hge
    · omega
    · exfalso
      have hT_ge_128 : 128 ≤ 2 ^ (a + b + c) := by
        calc (128 : Nat) = 2 ^ 7 := by decide
          _ ≤ 2 ^ (a + b + c) := Nat.pow_le_pow_right (by decide) hge
      omega
  -- Step 7: enumerate (a, b, c) with each ≥ 1 and 5 ≤ a+b+c ≤ 6.
  -- a ≤ 4 (since b, c ≥ 1 and a+b+c ≤ 6).
  have hAle4 : a ≤ 4 := by omega
  have hBle : b ≤ 5 := by omega
  -- Enumerate a, then b, then c.
  have h_a_cases : a = 1 ∨ a = 2 ∨ a = 3 ∨ a = 4 := by omega
  -- For each (a, b, c), substitute the explicit power-of-2 values and let omega refute.
  have h_pow1 : (2 : Nat) ^ 1 = 2 := by decide
  have h_pow2 : (2 : Nat) ^ 2 = 4 := by decide
  have h_pow3 : (2 : Nat) ^ 3 = 8 := by decide
  have h_pow4 : (2 : Nat) ^ 4 = 16 := by decide
  have h_pow5 : (2 : Nat) ^ 5 = 32 := by decide
  have h_pow6 : (2 : Nat) ^ 6 = 64 := by decide
  -- Substitute T as a power of 2.
  rcases h_a_cases with rfl | rfl | rfl | rfl
  -- a = 1
  · have h_b_cases : b = 1 ∨ b = 2 ∨ b = 3 ∨ b = 4 ∨ b = 5 := by omega
    rcases h_b_cases with rfl | rfl | rfl | rfl | rfl
    -- (1, 1, _): c ∈ {3, 4}
    · have h_c_cases : c = 3 ∨ c = 4 := by omega
      rcases h_c_cases with rfl | rfl
      · -- (1,1,3): 2^5 = 32, 2^1 = 2, 2^(1+1) = 4
        rw [show (1 + 1 + 3 : Nat) = 5 from rfl, h_pow5, h_pow1] at hEq
        have h11 : (2 : Nat) ^ 1 * 2 ^ 1 = 4 := by decide
        rw [h11] at hEq
        omega
      · rw [show (1 + 1 + 4 : Nat) = 6 from rfl, h_pow6, h_pow1] at hEq
        have h11 : (2 : Nat) ^ 1 * 2 ^ 1 = 4 := by decide
        rw [h11] at hEq
        omega
    -- (1, 2, _): c ∈ {2, 3}
    · have h_c_cases : c = 2 ∨ c = 3 := by omega
      rcases h_c_cases with rfl | rfl
      · rw [show (1 + 2 + 2 : Nat) = 5 from rfl, h_pow5, h_pow1] at hEq
        have h12 : (2 : Nat) ^ 1 * 2 ^ 2 = 8 := by decide
        rw [h12] at hEq
        omega
      · rw [show (1 + 2 + 3 : Nat) = 6 from rfl, h_pow6, h_pow1] at hEq
        have h12 : (2 : Nat) ^ 1 * 2 ^ 2 = 8 := by decide
        rw [h12] at hEq
        omega
    -- (1, 3, _): c ∈ {1, 2}
    · have h_c_cases : c = 1 ∨ c = 2 := by omega
      rcases h_c_cases with rfl | rfl
      · rw [show (1 + 3 + 1 : Nat) = 5 from rfl, h_pow5, h_pow1] at hEq
        have h13 : (2 : Nat) ^ 1 * 2 ^ 3 = 16 := by decide
        rw [h13] at hEq
        omega
      · rw [show (1 + 3 + 2 : Nat) = 6 from rfl, h_pow6, h_pow1] at hEq
        have h13 : (2 : Nat) ^ 1 * 2 ^ 3 = 16 := by decide
        rw [h13] at hEq
        omega
    -- (1, 4, _): c = 1
    · have h_c : c = 1 := by omega
      subst h_c
      rw [show (1 + 4 + 1 : Nat) = 6 from rfl, h_pow6, h_pow1] at hEq
      have h14 : (2 : Nat) ^ 1 * 2 ^ 4 = 32 := by decide
      rw [h14] at hEq
      omega
    -- (1, 5, _): c = 0, but c ≥ 1, contradiction
    · omega
  -- a = 2
  · have h_b_cases : b = 1 ∨ b = 2 ∨ b = 3 := by omega
    rcases h_b_cases with rfl | rfl | rfl
    -- (2, 1, _): c ∈ {2, 3}
    · have h_c_cases : c = 2 ∨ c = 3 := by omega
      rcases h_c_cases with rfl | rfl
      · rw [show (2 + 1 + 2 : Nat) = 5 from rfl, h_pow5, h_pow2] at hEq
        have h21 : (2 : Nat) ^ 2 * 2 ^ 1 = 8 := by decide
        rw [h21] at hEq
        omega
      · rw [show (2 + 1 + 3 : Nat) = 6 from rfl, h_pow6, h_pow2] at hEq
        have h21 : (2 : Nat) ^ 2 * 2 ^ 1 = 8 := by decide
        rw [h21] at hEq
        omega
    -- (2, 2, _): c ∈ {1, 2}
    · have h_c_cases : c = 1 ∨ c = 2 := by omega
      rcases h_c_cases with rfl | rfl
      · rw [show (2 + 2 + 1 : Nat) = 5 from rfl, h_pow5, h_pow2] at hEq
        have h22 : (2 : Nat) ^ 2 * 2 ^ 2 = 16 := by decide
        rw [h22] at hEq
        omega
      · rw [show (2 + 2 + 2 : Nat) = 6 from rfl, h_pow6, h_pow2] at hEq
        have h22 : (2 : Nat) ^ 2 * 2 ^ 2 = 16 := by decide
        rw [h22] at hEq
        omega
    -- (2, 3, _): c = 1
    · have h_c : c = 1 := by omega
      subst h_c
      rw [show (2 + 3 + 1 : Nat) = 6 from rfl, h_pow6, h_pow2] at hEq
      have h23 : (2 : Nat) ^ 2 * 2 ^ 3 = 32 := by decide
      rw [h23] at hEq
      omega
  -- a = 3
  · have h_b_cases : b = 1 ∨ b = 2 := by omega
    rcases h_b_cases with rfl | rfl
    -- (3, 1, _): c ∈ {1, 2}
    · have h_c_cases : c = 1 ∨ c = 2 := by omega
      rcases h_c_cases with rfl | rfl
      · rw [show (3 + 1 + 1 : Nat) = 5 from rfl, h_pow5, h_pow3] at hEq
        have h31 : (2 : Nat) ^ 3 * 2 ^ 1 = 16 := by decide
        rw [h31] at hEq
        omega
      · rw [show (3 + 1 + 2 : Nat) = 6 from rfl, h_pow6, h_pow3] at hEq
        have h31 : (2 : Nat) ^ 3 * 2 ^ 1 = 16 := by decide
        rw [h31] at hEq
        omega
    -- (3, 2, _): c = 1
    · have h_c : c = 1 := by omega
      subst h_c
      rw [show (3 + 2 + 1 : Nat) = 6 from rfl, h_pow6, h_pow3] at hEq
      have h32 : (2 : Nat) ^ 3 * 2 ^ 2 = 32 := by decide
      rw [h32] at hEq
      omega
  -- a = 4
  · have h_b : b = 1 := by omega
    subst h_b
    have h_c : c = 1 := by omega
    subst h_c
    rw [show (4 + 1 + 1 : Nat) = 6 from rfl, h_pow6, h_pow4] at hEq
    have h41 : (2 : Nat) ^ 4 * 2 ^ 1 = 32 := by decide
    rw [h41] at hEq
    omega

/-! ## Bridge from accelerated odd orbits to parity words

For each starting value `n` and step count `k`, the accelerated orbit
naturally produces the parity word recording the `2`-adic valuation
extracted at each step. The resulting word is always admissible at `n`,
and `applyWord` along this word reproduces the accelerated iterate. -/

/-- The parity word obtained from `k` accelerated odd-map steps starting
at `n`: each entry is the canonical valuation of the corresponding
`3 m + 1`. -/
def acceleratedTrace : Nat → Nat → ParityWord
  | 0, _ => []
  | k + 1, n =>
      oddPartSteps (3 * n + 1) :: acceleratedTrace k (acceleratedOddStep n)

@[simp] theorem acceleratedTrace_zero (n : Nat) : acceleratedTrace 0 n = [] := rfl

@[simp] theorem acceleratedTrace_succ (k n : Nat) :
    acceleratedTrace (k + 1) n =
      oddPartSteps (3 * n + 1) :: acceleratedTrace k (acceleratedOddStep n) := rfl

@[simp] theorem length_acceleratedTrace (k n : Nat) :
    (acceleratedTrace k n).length = k := by
  induction k generalizing n with
  | zero => rfl
  | succ k ih =>
      simp [acceleratedTrace_succ, ih]

/-- One step of the accelerated map can be written as one accelerated step
followed by `k` more applied to its image. -/
private theorem acceleratedOddIter_succ_left (k n : Nat) :
    acceleratedOddIter (k + 1) n = acceleratedOddIter k (acceleratedOddStep n) := by
  calc
    acceleratedOddIter (k + 1) n = acceleratedOddIter (1 + k) n := by
          rw [Nat.add_comm]
    _ = acceleratedOddIter k (acceleratedOddIter 1 n) := by
          rw [acceleratedOddIter_add]
    _ = acceleratedOddIter k (acceleratedOddStep n) := rfl

/-- The accelerated trace, applied as a parity word, reproduces the
accelerated odd iterate. -/
theorem applyWord_acceleratedTrace (k n : Nat) :
    applyWord (acceleratedTrace k n) n = acceleratedOddIter k n := by
  induction k generalizing n with
  | zero => rfl
  | succ k ih =>
      have h1 : applyStep (oddPartSteps (3 * n + 1)) n = acceleratedOddStep n :=
        applyStep_oddPartSteps_eq_acceleratedOddStep n
      calc
        applyWord (acceleratedTrace (k + 1) n) n
            = applyWord (acceleratedTrace k (acceleratedOddStep n))
                (applyStep (oddPartSteps (3 * n + 1)) n) := by
              rw [acceleratedTrace_succ, applyWord_cons]
        _ = applyWord (acceleratedTrace k (acceleratedOddStep n))
                (acceleratedOddStep n) := by rw [h1]
        _ = acceleratedOddIter k (acceleratedOddStep n) := ih (acceleratedOddStep n)
        _ = acceleratedOddIter (k + 1) n :=
              (acceleratedOddIter_succ_left k n).symm

/-- Every accelerated trace is admissible at its starting point. -/
theorem admissible_acceleratedTrace : ∀ (k n : Nat),
    Admissible (acceleratedTrace k n) n
  | 0, _ => trivial
  | k + 1, n => by
      have h1 : applyStep (oddPartSteps (3 * n + 1)) n = acceleratedOddStep n :=
        applyStep_oddPartSteps_eq_acceleratedOddStep n
      have hStep : StepAdmissible (oddPartSteps (3 * n + 1)) n :=
        stepAdmissible_oddPartSteps n
      have hRest : Admissible (acceleratedTrace k (acceleratedOddStep n))
          (acceleratedOddStep n) := admissible_acceleratedTrace k (acceleratedOddStep n)
      refine ⟨hStep, ?_⟩
      rw [h1]
      exact hRest

/-- Total valuation of an accelerated trace from `n`: the sum of the
canonical valuations along the orbit. This is presented as a definition
to avoid expanding the recursion at each use site. -/
def acceleratedTotalV (k n : Nat) : Nat := totalV (acceleratedTrace k n)

@[simp] theorem acceleratedTotalV_zero (n : Nat) : acceleratedTotalV 0 n = 0 := rfl

theorem acceleratedTotalV_succ (k n : Nat) :
    acceleratedTotalV (k + 1) n =
      oddPartSteps (3 * n + 1) + acceleratedTotalV k (acceleratedOddStep n) := by
  unfold acceleratedTotalV
  rw [acceleratedTrace_succ, totalV_cons]

/-! ## Cycle equation, accelerated form -/

/-- An accelerated odd-map cycle starting at `n` satisfies the
parity-word cycle equation under the natural admissible trace. -/
theorem accelerated_cycle_equation (k n : Nat)
    (hCycle : acceleratedOddIter k n = n) :
    2 ^ acceleratedTotalV k n * n =
      3 ^ k * n + offset (acceleratedTrace k n) := by
  have hAdm : Admissible (acceleratedTrace k n) n := admissible_acceleratedTrace k n
  have hApp : applyWord (acceleratedTrace k n) n = n := by
    rw [applyWord_acceleratedTrace]; exact hCycle
  have hEq := cycle_equation (acceleratedTrace k n) n hAdm hApp
  have hLen : (acceleratedTrace k n).length = k := length_acceleratedTrace k n
  rw [hLen] at hEq
  exact hEq

/-- Sanity check: the trivial accelerated cycle at `n = 1` (parity word
`[2]`) satisfies the cycle equation `4 · 1 = 3 · 1 + 1`. -/
theorem trivial_cycle_equation_one :
    2 ^ totalV [2] * (1 : Nat) = 3 ^ ([2] : ParityWord).length * 1 + offset [2] := by
  decide

end ParityWords
