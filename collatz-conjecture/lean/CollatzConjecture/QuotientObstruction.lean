/-
  Quotient-form obstruction targets for accelerated affine prefixes.

  `ReductionMap.lean` isolates the local first-gap obstruction as

      n <= offset / gap

  where `n` is the starting value of the accelerated prefix. The search code
  more naturally reasons about the output quotient

      q = acceleratedOddIter k n

  through the affine identity

      D * q = 3^k * n + offset.

  This file bridges those views. A threshold obstruction forces the output
  quotient into the interval

      (offset + 3^k) / D < q <= offset / gap.

  This is still only a local obstruction target; it does not prove first-gap
  coverage.

  This file uses only Lean core.
-/

import CollatzConjecture.ReductionMap

namespace ParityWords

/-! ## Named affine components -/

/-- Gap between the accelerated denominator and the `3^k` multiplier. -/
def acceleratedGap (k n : Nat) : Nat :=
  acceleratedDenominator k n - 3 ^ k

/-- The accelerated affine offset. -/
def acceleratedOffset (k n : Nat) : Nat :=
  offset (acceleratedTrace k n)

/-- The `3^k` multiplier in the accelerated affine numerator. -/
def acceleratedMultiplier (k : Nat) : Nat :=
  3 ^ k

/-- A multiplier gap is exactly positivity of the named gap. -/
theorem acceleratedGap_pos_of_multiplierGap (k n : Nat)
    (hGap : AcceleratedMultiplierGap k n) :
    0 < acceleratedGap k n := by
  exact Nat.sub_pos_of_lt hGap

/-- Canonical accelerated affine identity, expanded into the components used
by the quotient interval. -/
theorem acceleratedOutput_affine_eq (k n : Nat) :
    acceleratedDenominator k n * acceleratedOddIter k n =
      acceleratedMultiplier k * n + acceleratedOffset k n := by
  have h := acceleratedOddIter_affine_formula k n
  unfold acceleratedNumerator affineNumerator at h
  simpa [acceleratedMultiplier, acceleratedOffset, length_acceleratedTrace] using h

/-! ## Quotient interval vocabulary -/

/-- Multiplicative form of the output quotient interval:

`offset + 3^k < D*q` and `gap*q <= offset`.

This avoids division and is the most direct form of the affine arithmetic. -/
def AcceleratedOutputQuotientIntervalMul (k n q : Nat) : Prop :=
  AcceleratedMultiplierGap k n ∧
    q = acceleratedOddIter k n ∧
      acceleratedOffset k n + acceleratedMultiplier k <
        acceleratedDenominator k n * q ∧
        acceleratedGap k n * q ≤ acceleratedOffset k n

/-- Divided form of the output quotient interval:

`(offset + 3^k) / D < q <= offset / gap`.

This is the shape expected from residue/quotient search artifacts. -/
def AcceleratedOutputQuotientInterval (k n q : Nat) : Prop :=
  AcceleratedMultiplierGap k n ∧
    q = acceleratedOddIter k n ∧
      (acceleratedOffset k n + acceleratedMultiplier k) /
          acceleratedDenominator k n < q ∧
        q ≤ acceleratedOffset k n / acceleratedGap k n

/-- Multiplicative and divided quotient intervals are equivalent under a
multiplier gap. -/
theorem acceleratedOutputQuotientInterval_iff_mul (k n q : Nat)
    (hGap : AcceleratedMultiplierGap k n) :
    AcceleratedOutputQuotientInterval k n q ↔
      AcceleratedOutputQuotientIntervalMul k n q := by
  have hDenPos : 0 < acceleratedDenominator k n :=
    acceleratedDenominator_pos k n
  have hGapPos : 0 < acceleratedGap k n :=
    acceleratedGap_pos_of_multiplierGap k n hGap
  constructor
  · intro h
    rcases h with ⟨hGap', hq, hLower, hUpper⟩
    refine ⟨hGap', hq, ?_, ?_⟩
    · have hLowerMul :=
        (Nat.div_lt_iff_lt_mul hDenPos).mp hLower
      simpa [Nat.mul_comm] using hLowerMul
    · have hUpperMul :=
        (Nat.le_div_iff_mul_le hGapPos).mp hUpper
      simpa [Nat.mul_comm] using hUpperMul
  · intro h
    rcases h with ⟨hGap', hq, hLower, hUpper⟩
    refine ⟨hGap', hq, ?_, ?_⟩
    · have hLowerDiv :=
        (Nat.div_lt_iff_lt_mul hDenPos).mpr (by
          simpa [Nat.mul_comm] using hLower)
      exact hLowerDiv
    · have hUpperDiv :=
        (Nat.le_div_iff_mul_le hGapPos).mpr (by
          simpa [Nat.mul_comm] using hUpper)
      exact hUpperDiv

/-! ## Threshold obstruction implies quotient interval obstruction -/

/-- Positive starts force the output quotient above the lower endpoint of the
interval, in multiplicative form. -/
theorem acceleratedOutput_lower_mul_of_start_gt_one (k n : Nat)
    (hgt : 1 < n) :
    acceleratedOffset k n + acceleratedMultiplier k <
      acceleratedDenominator k n * acceleratedOddIter k n := by
  have hFormula := acceleratedOutput_affine_eq k n
  have hMulPos : 0 < acceleratedMultiplier k := by
    unfold acceleratedMultiplier
    exact Nat.pow_pos (by decide)
  have hCore : acceleratedMultiplier k < acceleratedMultiplier k * n := by
    simpa using
      (Nat.mul_lt_mul_of_pos_left hgt hMulPos :
        acceleratedMultiplier k * 1 < acceleratedMultiplier k * n)
  calc
    acceleratedOffset k n + acceleratedMultiplier k
        < acceleratedOffset k n + acceleratedMultiplier k * n :=
          Nat.add_lt_add_left hCore _
    _ = acceleratedMultiplier k * n + acceleratedOffset k n := by
          rw [Nat.add_comm]
    _ = acceleratedDenominator k n * acceleratedOddIter k n := hFormula.symm

/-- A threshold obstruction implies the accelerated output has not descended
below the starting value. -/
theorem acceleratedOddIter_ge_of_thresholdObstruction (k n : Nat)
    (hObs : AcceleratedThresholdObstruction k n) :
    n ≤ acceleratedOddIter k n := by
  have hGap : AcceleratedMultiplierGap k n := hObs.1
  have hGapPos : 0 < acceleratedGap k n :=
    acceleratedGap_pos_of_multiplierGap k n hGap
  have hThresholdMul :
      n * acceleratedGap k n ≤ acceleratedOffset k n := by
    have h := (Nat.le_div_iff_mul_le hGapPos).mp hObs.2
    simpa [acceleratedGap, acceleratedOffset] using h
  have hDenSplit :
      acceleratedDenominator k n =
        acceleratedMultiplier k + acceleratedGap k n := by
    unfold AcceleratedMultiplierGap at hGap
    unfold acceleratedGap acceleratedMultiplier
    exact (Nat.add_sub_of_le (Nat.le_of_lt hGap)).symm
  have hFormula := acceleratedOutput_affine_eq k n
  have hNonDescMul :
      acceleratedDenominator k n * n ≤
        acceleratedDenominator k n * acceleratedOddIter k n := by
    rw [hFormula]
    calc
      acceleratedDenominator k n * n
          = (acceleratedMultiplier k + acceleratedGap k n) * n := by
              rw [hDenSplit]
      _ = acceleratedMultiplier k * n + acceleratedGap k n * n := by
              rw [Nat.add_mul]
      _ ≤ acceleratedMultiplier k * n + acceleratedOffset k n := by
              exact Nat.add_le_add_left
                (by simpa [Nat.mul_comm] using hThresholdMul) _
  exact Nat.le_of_mul_le_mul_left hNonDescMul (acceleratedDenominator_pos k n)

/-- Non-descent plus the affine identity forces the output quotient below the
upper endpoint of the interval, in multiplicative form. -/
theorem acceleratedOutput_upper_mul_of_nonDescent (k n : Nat)
    (hGap : AcceleratedMultiplierGap k n)
    (hNonDesc : n ≤ acceleratedOddIter k n) :
    acceleratedGap k n * acceleratedOddIter k n ≤ acceleratedOffset k n := by
  have hFormula := acceleratedOutput_affine_eq k n
  have hMulLe :
      acceleratedMultiplier k * n ≤
        acceleratedMultiplier k * acceleratedOddIter k n :=
    Nat.mul_le_mul_left (acceleratedMultiplier k) hNonDesc
  have hDenLe :
      acceleratedDenominator k n * acceleratedOddIter k n ≤
        acceleratedMultiplier k * acceleratedOddIter k n +
          acceleratedOffset k n := by
    rw [hFormula]
    exact Nat.add_le_add_right hMulLe _
  have hDenSplit :
      acceleratedDenominator k n =
        acceleratedMultiplier k + acceleratedGap k n := by
    unfold AcceleratedMultiplierGap at hGap
    unfold acceleratedGap acceleratedMultiplier
    exact (Nat.add_sub_of_le (Nat.le_of_lt hGap)).symm
  have hExpanded :
      acceleratedMultiplier k * acceleratedOddIter k n +
        acceleratedGap k n * acceleratedOddIter k n ≤
          acceleratedMultiplier k * acceleratedOddIter k n +
            acceleratedOffset k n := by
    calc
      acceleratedMultiplier k * acceleratedOddIter k n +
          acceleratedGap k n * acceleratedOddIter k n
          = (acceleratedMultiplier k + acceleratedGap k n) *
              acceleratedOddIter k n := by
                rw [Nat.add_mul]
      _ = acceleratedDenominator k n * acceleratedOddIter k n := by
              rw [← hDenSplit]
      _ ≤ acceleratedMultiplier k * acceleratedOddIter k n +
            acceleratedOffset k n := hDenLe
  omega

/-- A threshold obstruction at a positive start forces the output quotient
into the multiplicative interval obstruction. -/
theorem acceleratedOutputQuotientIntervalMul_of_thresholdObstruction
    (k n : Nat) (hgt : 1 < n)
    (hObs : AcceleratedThresholdObstruction k n) :
    AcceleratedOutputQuotientIntervalMul k n (acceleratedOddIter k n) := by
  refine ⟨hObs.1, rfl, ?_, ?_⟩
  · exact acceleratedOutput_lower_mul_of_start_gt_one k n hgt
  · exact acceleratedOutput_upper_mul_of_nonDescent k n hObs.1
      (acceleratedOddIter_ge_of_thresholdObstruction k n hObs)

/-- A threshold obstruction at a positive start forces the output quotient
into the divided interval obstruction. -/
theorem acceleratedOutputQuotientInterval_of_thresholdObstruction
    (k n : Nat) (hgt : 1 < n)
    (hObs : AcceleratedThresholdObstruction k n) :
    AcceleratedOutputQuotientInterval k n (acceleratedOddIter k n) := by
  have hMul :=
    acceleratedOutputQuotientIntervalMul_of_thresholdObstruction k n hgt hObs
  exact (acceleratedOutputQuotientInterval_iff_mul
    k n (acceleratedOddIter k n) hObs.1).mpr hMul

/-! ## First-gap quotient-obstruction strategy target -/

/-- Local first-gap quotient-obstruction target: no first multiplier-gap prefix
may put its output quotient in the forbidden interval. -/
def NoFirstMultiplierGapQuotientIntervalObstruction : Prop :=
  ∀ n k q : Nat, 1 < n → n % 2 = 1 →
    FirstAcceleratedMultiplierGap k n →
      q = acceleratedOddIter k n →
        ¬ AcceleratedOutputQuotientInterval k n q

/-- Ruling out the quotient interval obstruction rules out the threshold
obstruction used by `ReductionMap.lean`. -/
theorem NoFirstMultiplierGapThresholdObstruction_of_no_quotientInterval
    (hNoQI : NoFirstMultiplierGapQuotientIntervalObstruction) :
    NoFirstMultiplierGapThresholdObstruction := by
  intro n k hgt hodd hFirst hObs
  have hQI :=
    acceleratedOutputQuotientInterval_of_thresholdObstruction k n hgt hObs
  exact hNoQI n k (acceleratedOddIter k n) hgt hodd hFirst rfl hQI

end ParityWords

/-! ## Top-level quotient-obstruction assembly -/

/-- First-multiplier-gap assembly in output-quotient form: if every positive
odd `n > 1` has a first multiplier-gap prefix, and no such prefix puts its
output quotient in the forbidden interval, then Collatz follows. -/
theorem CollatzConjecture_of_firstMultiplierGap_no_quotientInterval
    (hCover : ParityWords.EventuallyFirstAcceleratedMultiplierGap)
    (hNoQI : ParityWords.NoFirstMultiplierGapQuotientIntervalObstruction) :
    CollatzConjecture :=
  CollatzConjecture_of_firstMultiplierGap_no_thresholdObstruction hCover
    (ParityWords.NoFirstMultiplierGapThresholdObstruction_of_no_quotientInterval hNoQI)
