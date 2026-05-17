/-
  Affine orbit API for parity-word blocks.

  `ParityWords.lean` proves the core block formula directly in terms of
  `totalV` and `offset`. This file packages that formula behind named
  numerator and denominator functions, so downstream cycle/descent arguments
  can cite a stable affine API.
-/

import CollatzConjecture.CycleExclusion

namespace ParityWords

/-! ## Affine data for arbitrary parity words -/

/-- Denominator of the affine block formula for a parity word. -/
def affineDenominator (v : ParityWord) : Nat := 2 ^ totalV v

/-- Numerator of the affine block formula for a parity word at input `n`. -/
def affineNumerator (v : ParityWord) (n : Nat) : Nat :=
  3 ^ v.length * n + offset v

@[simp] theorem affineDenominator_nil : affineDenominator [] = 1 := rfl

@[simp] theorem affineNumerator_nil (n : Nat) : affineNumerator [] n = n := by
  simp [affineNumerator]

theorem affineDenominator_pos (v : ParityWord) : 0 < affineDenominator v := by
  unfold affineDenominator
  exact Nat.pow_pos (by decide)

/-- Multiplicative part of the affine numerator. -/
def affineMultiplier (v : ParityWord) : Nat := 3 ^ v.length

@[simp] theorem affineMultiplier_nil : affineMultiplier [] = 1 := rfl

/-- The affine numerator split into its multiplicative and offset parts. -/
theorem affineNumerator_eq_multiplier_add_offset (v : ParityWord) (n : Nat) :
    affineNumerator v n = affineMultiplier v * n + offset v := rfl

/-- A multiplier gap plus an offset margin gives strict affine descent for
an arbitrary parity word. -/
theorem affineNumerator_lt_denominator_mul_of_offset_lt_gap
    (v : ParityWord) (n : Nat)
    (hGap : affineMultiplier v < affineDenominator v)
    (hOffset : offset v < (affineDenominator v - affineMultiplier v) * n) :
    affineNumerator v n < affineDenominator v * n := by
  have hOffset' : offset v < (affineDenominator v - 3 ^ v.length) * n := by
    simpa [affineMultiplier] using hOffset
  calc
    affineNumerator v n
        = 3 ^ v.length * n + offset v := rfl
    _ 
        < 3 ^ v.length * n +
            (affineDenominator v - 3 ^ v.length) * n :=
          Nat.add_lt_add_left hOffset' _
    _ = (3 ^ v.length + (affineDenominator v - 3 ^ v.length)) * n := by
          rw [Nat.add_mul]
    _ = affineDenominator v * n := by
          have hle : 3 ^ v.length ≤ affineDenominator v := by
            simpa [affineMultiplier] using Nat.le_of_lt hGap
          rw [Nat.add_sub_of_le hle]

/-- Contrapositive-friendly version: if a block does not descend despite
having a multiplier gap, its offset must be at least the gap times `n`. -/
theorem offset_ge_gap_mul_of_affineNumerator_ge_denominator_mul
    (v : ParityWord) (n : Nat)
    (hGap : affineMultiplier v < affineDenominator v)
    (hNonDesc : affineDenominator v * n ≤ affineNumerator v n) :
    (affineDenominator v - affineMultiplier v) * n ≤ offset v := by
  apply Nat.le_of_not_gt
  intro hOffset
  have hDesc := affineNumerator_lt_denominator_mul_of_offset_lt_gap v n hGap hOffset
  omega

/-- A bounded-offset form of the multiplier-gap descent criterion. -/
theorem affineNumerator_lt_denominator_mul_of_offset_le_bound
    (v : ParityWord) (n bound : Nat)
    (hGap : affineMultiplier v < affineDenominator v)
    (hBound : offset v ≤ bound)
    (hBoundLt : bound < (affineDenominator v - affineMultiplier v) * n) :
    affineNumerator v n < affineDenominator v * n := by
  exact affineNumerator_lt_denominator_mul_of_offset_lt_gap v n hGap
    (Nat.lt_of_le_of_lt hBound hBoundLt)

/-- Threshold form: under a multiplier gap, it is enough that the start is
larger than `offset / gap`. -/
theorem affineNumerator_lt_denominator_mul_of_start_gt_offset_div_gap
    (v : ParityWord) (n : Nat)
    (hGap : affineMultiplier v < affineDenominator v)
    (hStart : offset v / (affineDenominator v - affineMultiplier v) < n) :
    affineNumerator v n < affineDenominator v * n := by
  have hGapPos : 0 < affineDenominator v - affineMultiplier v :=
    Nat.sub_pos_of_lt hGap
  have hOffsetMul :
      offset v < n * (affineDenominator v - affineMultiplier v) :=
    Nat.lt_mul_of_div_lt hStart hGapPos
  have hOffset :
      offset v < (affineDenominator v - affineMultiplier v) * n := by
    simpa [Nat.mul_comm] using hOffsetMul
  exact affineNumerator_lt_denominator_mul_of_offset_lt_gap v n hGap hOffset

/-- The exact affine formula, written with the named numerator and
denominator. -/
theorem applyWord_affine_formula (v : ParityWord) (n : Nat)
    (hAdm : Admissible v n) :
    affineDenominator v * applyWord v n = affineNumerator v n := by
  simpa [affineDenominator, affineNumerator] using
    applyWord_block_formula v n hAdm

/-- Closed-form division version of the affine formula. -/
theorem applyWord_eq_affine_div (v : ParityWord) (n : Nat)
    (hAdm : Admissible v n) :
    applyWord v n = affineNumerator v n / affineDenominator v := by
  simpa [affineDenominator, affineNumerator] using applyWord_eq_div v n hAdm

/-! ## Composition under concatenation -/

/-- Total valuation is additive under concatenation. -/
theorem totalV_append : ∀ (u v : ParityWord), totalV (u ++ v) = totalV u + totalV v
  | [], v => by simp [totalV]
  | a :: rest, v => by
      rw [List.cons_append, totalV_cons, totalV_cons, totalV_append rest v]
      omega

/-- The affine offset of a concatenated word is obtained by scaling the
left offset by the right `3`-power and adding the right offset scaled by
the left denominator. -/
theorem offset_append : ∀ (u v : ParityWord),
    offset (u ++ v) = 3 ^ v.length * offset u + 2 ^ totalV u * offset v
  | [], v => by simp [offset, totalV]
  | a :: rest, v => by
      rw [List.cons_append, offset_cons, offset_cons, offset_append rest v,
        totalV_cons, List.length_append, Nat.pow_add, Nat.pow_add]
      simp [Nat.mul_add, Nat.add_assoc, Nat.mul_comm, Nat.mul_left_comm]

/-- Applying a concatenated parity word is the same as applying the left
word first and the right word second. -/
theorem applyWord_append : ∀ (u v : ParityWord) (n : Nat),
    applyWord (u ++ v) n = applyWord v (applyWord u n)
  | [], v, n => by simp [applyWord]
  | a :: rest, v, n => by
      rw [List.cons_append, applyWord_cons, applyWord_cons, applyWord_append rest v]

/-- Admissibility of a concatenated word splits at the intermediate value
reached after the left word. -/
theorem admissible_append : ∀ (u v : ParityWord) (n : Nat),
    Admissible (u ++ v) n ↔ Admissible u n ∧ Admissible v (applyWord u n)
  | [], v, n => by simp [Admissible, applyWord]
  | a :: rest, v, n => by
      rw [List.cons_append, applyWord_cons]
      constructor
      · intro h
        obtain ⟨hStep, hTail⟩ := h
        have hSplit := (admissible_append rest v (applyStep a n)).mp hTail
        exact ⟨⟨hStep, hSplit.left⟩, hSplit.right⟩
      · intro h
        obtain ⟨hLeft, hRight⟩ := h
        obtain ⟨hStep, hRest⟩ := hLeft
        exact ⟨hStep, (admissible_append rest v (applyStep a n)).mpr ⟨hRest, hRight⟩⟩

/-- Affine denominators multiply under concatenation. -/
theorem affineDenominator_append (u v : ParityWord) :
    affineDenominator (u ++ v) = affineDenominator u * affineDenominator v := by
  unfold affineDenominator
  rw [totalV_append, Nat.pow_add]

/-- Affine numerator composition for concatenated parity words, expressed
purely in terms of the affine data of the two words. -/
theorem affineNumerator_append (u v : ParityWord) (n : Nat) :
    affineNumerator (u ++ v) n =
      3 ^ v.length * affineNumerator u n + affineDenominator u * offset v := by
  unfold affineNumerator affineDenominator
  rw [List.length_append, Nat.pow_add, offset_append]
  simp [Nat.mul_add, Nat.add_assoc, Nat.mul_assoc, Nat.mul_comm]

/-- The affine block formula for a concatenated word can be computed by
first using the affine formula for the right word at the intermediate
value. -/
theorem applyWord_append_affine_formula (u v : ParityWord) (n : Nat)
    (hAdm : Admissible (u ++ v) n) :
    affineDenominator (u ++ v) * applyWord (u ++ v) n =
      affineDenominator u * affineNumerator v (applyWord u n) := by
  have hSplit := (admissible_append u v n).mp hAdm
  have hRight := applyWord_affine_formula v (applyWord u n) hSplit.right
  calc
    affineDenominator (u ++ v) * applyWord (u ++ v) n
        = affineDenominator u * affineDenominator v *
            applyWord v (applyWord u n) := by
          rw [affineDenominator_append, applyWord_append]
    _ = affineDenominator u *
          (affineDenominator v * applyWord v (applyWord u n)) := by
          rw [Nat.mul_assoc]
    _ = affineDenominator u * affineNumerator v (applyWord u n) := by
          rw [hRight]

/-- Equivalent composition statement with the named numerator for the
concatenated word. -/
theorem affineNumerator_append_of_admissible (u v : ParityWord) (n : Nat)
    (hAdm : Admissible (u ++ v) n) :
    affineNumerator (u ++ v) n =
      affineDenominator u * affineNumerator v (applyWord u n) := by
  have hLeft := applyWord_affine_formula (u ++ v) n hAdm
  rw [← hLeft]
  exact applyWord_append_affine_formula u v n hAdm

/-! ## Affine data for canonical accelerated traces -/

/-- Denominator of the canonical affine formula for `k` accelerated steps
from `n`. -/
def acceleratedDenominator (k n : Nat) : Nat :=
  affineDenominator (acceleratedTrace k n)

/-- Numerator of the canonical affine formula for `k` accelerated steps
from `n`. -/
def acceleratedNumerator (k n : Nat) : Nat :=
  affineNumerator (acceleratedTrace k n) n

@[simp] theorem acceleratedDenominator_zero (n : Nat) :
    acceleratedDenominator 0 n = 1 := rfl

@[simp] theorem acceleratedNumerator_zero (n : Nat) :
    acceleratedNumerator 0 n = n := by
  simp [acceleratedNumerator]

theorem acceleratedDenominator_eq_pow_totalV (k n : Nat) :
    acceleratedDenominator k n = 2 ^ acceleratedTotalV k n := by
  rfl

theorem acceleratedDenominator_pos (k n : Nat) :
    0 < acceleratedDenominator k n :=
  affineDenominator_pos (acceleratedTrace k n)

/-- Canonical accelerated traces split at an intermediate accelerated
iterate. -/
theorem acceleratedTrace_add : ∀ (a b n : Nat),
    acceleratedTrace (a + b) n =
      acceleratedTrace a n ++ acceleratedTrace b (acceleratedOddIter a n)
  | 0, b, n => by simp [acceleratedTrace]
  | a + 1, b, n => by
      have hIter : acceleratedOddIter a (acceleratedOddStep n) =
          acceleratedOddIter (a + 1) n := by
        simpa [Nat.add_comm] using (acceleratedOddIter_add 1 a n).symm
      rw [Nat.succ_add]
      simp [acceleratedTrace_succ, acceleratedTrace_add a b (acceleratedOddStep n), hIter]

/-- Total valuation of canonical accelerated traces is additive under a
split of the accelerated orbit. -/
theorem acceleratedTotalV_add (a b n : Nat) :
    acceleratedTotalV (a + b) n =
      acceleratedTotalV a n + acceleratedTotalV b (acceleratedOddIter a n) := by
  unfold acceleratedTotalV
  rw [acceleratedTrace_add, totalV_append]

/-- Canonical accelerated denominators multiply under a split of the
accelerated orbit. -/
theorem acceleratedDenominator_add (a b n : Nat) :
    acceleratedDenominator (a + b) n =
      acceleratedDenominator a n * acceleratedDenominator b (acceleratedOddIter a n) := by
  unfold acceleratedDenominator
  rw [acceleratedTrace_add, affineDenominator_append]

/-- Canonical accelerated numerators compose under a split of the
accelerated orbit. -/
theorem acceleratedNumerator_add (a b n : Nat) :
    acceleratedNumerator (a + b) n =
      acceleratedDenominator a n *
        acceleratedNumerator b (acceleratedOddIter a n) := by
  unfold acceleratedNumerator acceleratedDenominator
  rw [acceleratedTrace_add]
  have hAdm : Admissible
      (acceleratedTrace a n ++ acceleratedTrace b (acceleratedOddIter a n)) n := by
    rw [← acceleratedTrace_add]
    exact admissible_acceleratedTrace (a + b) n
  simpa [applyWord_acceleratedTrace] using
    affineNumerator_append_of_admissible
      (acceleratedTrace a n) (acceleratedTrace b (acceleratedOddIter a n)) n hAdm

/-- The canonical affine formula for accelerated odd iterates. -/
theorem acceleratedOddIter_affine_formula (k n : Nat) :
    acceleratedDenominator k n * acceleratedOddIter k n =
      acceleratedNumerator k n := by
  unfold acceleratedDenominator acceleratedNumerator
  rw [← applyWord_acceleratedTrace k n]
  exact applyWord_affine_formula (acceleratedTrace k n) n
    (admissible_acceleratedTrace k n)

/-- Closed-form division version of the canonical accelerated affine
formula. -/
theorem acceleratedOddIter_eq_affine_div (k n : Nat) :
    acceleratedOddIter k n = acceleratedNumerator k n / acceleratedDenominator k n := by
  unfold acceleratedDenominator acceleratedNumerator
  rw [← applyWord_acceleratedTrace k n]
  exact applyWord_eq_affine_div (acceleratedTrace k n) n
    (admissible_acceleratedTrace k n)

end ParityWords
