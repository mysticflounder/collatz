/-
  Strategy reduction map for the Collatz proof scaffold.

  This file does not choose a proof strategy. It provides a small interface
  for splitting a candidate strategy into two independently checkable
  obligations:

  * coverage: every positive odd `n > 1` has a useful accelerated prefix;
  * local descent: every useful prefix gives affine descent.

  The existing descent theorem then assembles those obligations into the
  top-level Collatz conjecture.

  This file uses only Lean core.
-/

import CollatzConjecture.Descent

namespace ParityWords

/-! ## Generic prefix-strategy interface -/

/-- A strategy-specific predicate selecting accelerated prefixes.

`P n k` should be read as: for the start value `n`, the accelerated prefix of
length `k` has whatever structural property this strategy wants to exploit.
-/
abbrev PrefixStrategy := Nat → Nat → Prop

/-- Coverage obligation for a prefix strategy: every positive odd `n > 1`
has at least one selected accelerated prefix. -/
def StrategyCoversOddValues (P : PrefixStrategy) : Prop :=
  ∀ n : Nat, 1 < n → n % 2 = 1 → ∃ k : Nat, P n k

/-- Local arithmetic obligation for a prefix strategy: every selected prefix
is an affine descending canonical accelerated block. -/
def PrefixesForceAffineDescent (P : PrefixStrategy) : Prop :=
  ∀ n k : Nat, P n k → AcceleratedAffineDescent k n

/-- A covered strategy whose selected prefixes all descend supplies the
existing eventual affine descent criterion. -/
theorem EventuallyAcceleratedAffineDescent_of_strategy
    (P : PrefixStrategy)
    (hCover : StrategyCoversOddValues P)
    (hLocal : PrefixesForceAffineDescent P) :
    EventuallyAcceleratedAffineDescent := by
  intro n hgt hodd
  rcases hCover n hgt hodd with ⟨k, hk⟩
  exact ⟨k, hLocal n k hk⟩

/-! ## Multiplier-gap vocabulary -/

/-- The canonical accelerated prefix has crossed into the multiplier-gap
regime: its denominator beats the `3^k` numerator multiplier. -/
def AcceleratedMultiplierGap (k n : Nat) : Prop :=
  3 ^ k < acceleratedDenominator k n

/-- The same multiplier-gap condition written with the accumulated halving
budget `acceleratedTotalV`. -/
def AcceleratedTotalVGap (k n : Nat) : Prop :=
  3 ^ k < 2 ^ acceleratedTotalV k n

/-- Denominator and accumulated-halving versions of the multiplier-gap
condition are definitionally the same through the affine API. -/
theorem acceleratedMultiplierGap_iff_totalVGap (k n : Nat) :
    AcceleratedMultiplierGap k n ↔ AcceleratedTotalVGap k n := by
  unfold AcceleratedMultiplierGap AcceleratedTotalVGap
  rw [acceleratedDenominator_eq_pow_totalV]

/-- Offset margin needed for a multiplier-gap prefix to be descending. -/
def AcceleratedOffsetMargin (k n : Nat) : Prop :=
  offset (acceleratedTrace k n) <
    (acceleratedDenominator k n - 3 ^ k) * n

/-- Threshold margin form of the same descent condition. -/
def AcceleratedThresholdMargin (k n : Nat) : Prop :=
  offset (acceleratedTrace k n) /
    (acceleratedDenominator k n - 3 ^ k) < n

/-- The exact threshold obstruction to the multiplier-gap descent criterion:
even after the denominator beats `3^k`, the starting value is still at or
below the offset/gap threshold. -/
def AcceleratedThresholdObstruction (k n : Nat) : Prop :=
  AcceleratedMultiplierGap k n ∧
    n ≤ offset (acceleratedTrace k n) /
      (acceleratedDenominator k n - 3 ^ k)

/-- Once the multiplier gap is known, ruling out the threshold obstruction is
exactly the same as clearing the threshold margin. -/
theorem acceleratedThresholdMargin_iff_not_obstruction_of_gap
    (k n : Nat) (hGap : AcceleratedMultiplierGap k n) :
    AcceleratedThresholdMargin k n ↔
      ¬ AcceleratedThresholdObstruction k n := by
  constructor
  · intro hMargin hObs
    exact Nat.not_le_of_gt hMargin hObs.2
  · intro hNoObs
    unfold AcceleratedThresholdMargin
    apply Nat.lt_of_not_ge
    intro hLe
    exact hNoObs ⟨hGap, hLe⟩

/-- If a strategy's selected prefixes always have a multiplier gap and enough
offset margin, then those prefixes force affine descent. -/
theorem PrefixesForceAffineDescent_of_multiplierGap_offsetMargin
    (P : PrefixStrategy)
    (h : ∀ n k : Nat, P n k →
      AcceleratedMultiplierGap k n ∧ AcceleratedOffsetMargin k n) :
    PrefixesForceAffineDescent P := by
  intro n k hk
  rcases h n k hk with ⟨hGap, hOffset⟩
  exact acceleratedAffineDescent_of_multiplier_gap k n hGap hOffset

/-- If a strategy's selected prefixes always have a multiplier gap and clear
the affine threshold, then those prefixes force affine descent. -/
theorem PrefixesForceAffineDescent_of_multiplierGap_thresholdMargin
    (P : PrefixStrategy)
    (h : ∀ n k : Nat, P n k →
      AcceleratedMultiplierGap k n ∧ AcceleratedThresholdMargin k n) :
    PrefixesForceAffineDescent P := by
  intro n k hk
  rcases h n k hk with ⟨hGap, hStart⟩
  exact acceleratedAffineDescent_of_start_gt_offset_div_gap k n hGap hStart

/-! ## First multiplier-gap strategy shape -/

/-- `k` is the first canonical accelerated prefix where the multiplier gap
appears. This is a strategy candidate, not a theorem of coverage. -/
def FirstAcceleratedMultiplierGap (k n : Nat) : Prop :=
  AcceleratedMultiplierGap k n ∧
    ∀ j : Nat, j < k → ¬ AcceleratedMultiplierGap j n

/-- Global coverage obligation for the first-gap strategy. This is deliberately
separate because it is the hard dynamical part. -/
def EventuallyFirstAcceleratedMultiplierGap : Prop :=
  ∀ n : Nat, 1 < n → n % 2 = 1 →
    ∃ k : Nat, FirstAcceleratedMultiplierGap k n

/-- Local obligation for the first-gap strategy. This is the part intended for
affine/residue/SAT-style attacks. -/
def FirstMultiplierGapForcesDescent : Prop :=
  ∀ n k : Nat, 1 < n → n % 2 = 1 →
    FirstAcceleratedMultiplierGap k n → AcceleratedAffineDescent k n

/-- Local first-gap obstruction statement: no first multiplier-gap prefix is
allowed to remain below the offset/gap threshold. -/
def NoFirstMultiplierGapThresholdObstruction : Prop :=
  ∀ n k : Nat, 1 < n → n % 2 = 1 →
    FirstAcceleratedMultiplierGap k n →
      ¬ AcceleratedThresholdObstruction k n

/-- Ruling out the first-gap threshold obstruction proves the local first-gap
descent obligation. This is the intended target for residue/SAT-style work. -/
theorem FirstMultiplierGapForcesDescent_of_no_thresholdObstruction
    (hNoObs : NoFirstMultiplierGapThresholdObstruction) :
    FirstMultiplierGapForcesDescent := by
  intro n k hgt hodd hFirst
  have hGap : AcceleratedMultiplierGap k n := hFirst.1
  have hNo : ¬ AcceleratedThresholdObstruction k n :=
    hNoObs n k hgt hodd hFirst
  have hMargin : AcceleratedThresholdMargin k n :=
    (acceleratedThresholdMargin_iff_not_obstruction_of_gap k n hGap).mpr hNo
  exact acceleratedAffineDescent_of_start_gt_offset_div_gap k n hGap hMargin

/-- First-gap coverage plus the local first-gap descent lemma supplies the
existing eventual affine descent criterion. -/
theorem EventuallyAcceleratedAffineDescent_of_firstMultiplierGap
    (hCover : EventuallyFirstAcceleratedMultiplierGap)
    (hLocal : FirstMultiplierGapForcesDescent) :
    EventuallyAcceleratedAffineDescent := by
  intro n hgt hodd
  rcases hCover n hgt hodd with ⟨k, hk⟩
  exact ⟨k, hLocal n k hgt hodd hk⟩

end ParityWords

/-! ## Top-level assembly entry points -/

/-- Generic strategy assembly: coverage plus local descent proves the top-level
Collatz conjecture. -/
theorem CollatzConjecture_of_prefixStrategy
    (P : ParityWords.PrefixStrategy)
    (hCover : ParityWords.StrategyCoversOddValues P)
    (hLocal : ParityWords.PrefixesForceAffineDescent P) :
    CollatzConjecture :=
  CollatzConjecture_of_eventual_acceleratedAffine_descent
    (ParityWords.EventuallyAcceleratedAffineDescent_of_strategy P hCover hLocal)

/-- First-multiplier-gap assembly: if every positive odd `n > 1` has a first
multiplier-gap prefix and every such first-gap prefix descends, then Collatz
follows. -/
theorem CollatzConjecture_of_firstMultiplierGap
    (hCover : ParityWords.EventuallyFirstAcceleratedMultiplierGap)
    (hLocal : ParityWords.FirstMultiplierGapForcesDescent) :
    CollatzConjecture :=
  CollatzConjecture_of_eventual_acceleratedAffine_descent
    (ParityWords.EventuallyAcceleratedAffineDescent_of_firstMultiplierGap
      hCover hLocal)

/-- First-multiplier-gap assembly in obstruction form: if every positive odd
`n > 1` has a first multiplier-gap prefix, and no such prefix hits the
threshold obstruction, then Collatz follows. -/
theorem CollatzConjecture_of_firstMultiplierGap_no_thresholdObstruction
    (hCover : ParityWords.EventuallyFirstAcceleratedMultiplierGap)
    (hNoObs : ParityWords.NoFirstMultiplierGapThresholdObstruction) :
    CollatzConjecture :=
  CollatzConjecture_of_firstMultiplierGap hCover
    (ParityWords.FirstMultiplierGapForcesDescent_of_no_thresholdObstruction hNoObs)
