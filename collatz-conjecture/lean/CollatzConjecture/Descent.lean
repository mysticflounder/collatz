/-
  Descent / non-descent and the counterexample extraction principle.

  Phase 5 of the Collatz proof roadmap. The roadmap warns that this is the
  least automatic branch: there is no clean "long blocks force descent"
  theorem available without external machinery. What this file *can* do
  symbolically is:

  - define `BlockDescent` and `BlockNonDescent` for parity-word blocks,
  - characterise descent arithmetically via the block formula,
  - show no descent is possible in the expanding regime `2^V ≤ 3^L`,
  - formalise minimal classical Collatz counterexamples and prove they
    have an orbit lower bound (the orbit never falls below `n`),
  - prove a minimal counterexample is necessarily odd, and
  - assemble the *counterexample extraction principle*: any Collatz
    counterexample yields a positive odd `n` whose accelerated orbit
    never descends below `n`, equivalently every accelerated trace from
    `n` is non-descending.

  This file uses only Lean core; `Classical.em` is invoked to drive the
  strong-induction case split on whether a smaller counterexample exists.
-/

import CollatzConjecture.AffineOrbits
import CollatzConjecture.Formulations

/-! ## Classical Collatz orbit positivity -/

/-- One classical Collatz step preserves positivity. -/
theorem collatzStep_pos (n : Nat) (hpos : 0 < n) : 0 < collatzStep n := by
  unfold collatzStep
  by_cases h : n % 2 = 0
  · rw [if_pos h]
    have h2 : 2 ≤ n := Nat.le_of_dvd hpos (Nat.dvd_of_mod_eq_zero h)
    exact Nat.div_pos h2 (by decide)
  · rw [if_neg h]
    exact Nat.succ_pos _

/-- Iterated classical Collatz steps preserve positivity. -/
theorem collatzIter_pos (k n : Nat) (hpos : 0 < n) : 0 < collatzIter k n := by
  induction k with
  | zero => exact hpos
  | succ k ih =>
      simp [collatzIter]
      exact collatzStep_pos _ ih

/-! ## Block descent and non-descent (parity-word level) -/

namespace ParityWords

/-- A parity word strictly decreases the value at `n`. -/
def BlockDescent (v : ParityWord) (n : Nat) : Prop := applyWord v n < n

/-- A parity word fails to decrease at `n`. -/
def BlockNonDescent (v : ParityWord) (n : Nat) : Prop := n ≤ applyWord v n

/-- The empty word never descends. -/
theorem blockNonDescent_nil (n : Nat) : BlockNonDescent [] n := Nat.le_refl n

/-- For admissible blocks, descent is exactly the arithmetic comparison
`3^L · n + offset v < 2^V · n`. -/
theorem blockDescent_iff_arith (v : ParityWord) (n : Nat)
    (hAdm : Admissible v n) :
    BlockDescent v n ↔ 3 ^ v.length * n + offset v < 2 ^ totalV v * n := by
  unfold BlockDescent
  have hpow_pos : 0 < 2 ^ totalV v := Nat.pow_pos (by decide)
  have heq : 2 ^ totalV v * applyWord v n = 3 ^ v.length * n + offset v :=
    applyWord_block_formula v n hAdm
  constructor
  · intro h
    calc 3 ^ v.length * n + offset v
        = 2 ^ totalV v * applyWord v n := heq.symm
      _ < 2 ^ totalV v * n := (Nat.mul_lt_mul_left hpow_pos).mpr h
  · intro h
    have h' : 2 ^ totalV v * applyWord v n < 2 ^ totalV v * n := by
      rw [heq]; exact h
    exact (Nat.mul_lt_mul_left hpow_pos).mp h'

/-- Non-descent of an admissible block is the arithmetic inequality
`2^V · n ≤ 3^L · n + offset v`. -/
theorem blockNonDescent_iff_arith (v : ParityWord) (n : Nat)
    (hAdm : Admissible v n) :
    BlockNonDescent v n ↔ 2 ^ totalV v * n ≤ 3 ^ v.length * n + offset v := by
  unfold BlockNonDescent
  have hpow_pos : 0 < 2 ^ totalV v := Nat.pow_pos (by decide)
  have heq : 2 ^ totalV v * applyWord v n = 3 ^ v.length * n + offset v :=
    applyWord_block_formula v n hAdm
  constructor
  · intro h
    calc 2 ^ totalV v * n
        ≤ 2 ^ totalV v * applyWord v n :=
          Nat.mul_le_mul_left _ h
      _ = 3 ^ v.length * n + offset v := heq
  · intro h
    have h' : 2 ^ totalV v * n ≤ 2 ^ totalV v * applyWord v n := by
      rw [heq]; exact h
    exact Nat.le_of_mul_le_mul_left h' hpow_pos

/-- Descent of an admissible block, written through the affine API. -/
theorem blockDescent_iff_affine (v : ParityWord) (n : Nat)
    (hAdm : Admissible v n) :
    BlockDescent v n ↔ affineNumerator v n < affineDenominator v * n := by
  simpa [affineNumerator, affineDenominator] using
    blockDescent_iff_arith v n hAdm

/-- Non-descent of an admissible block, written through the affine API. -/
theorem blockNonDescent_iff_affine (v : ParityWord) (n : Nat)
    (hAdm : Admissible v n) :
    BlockNonDescent v n ↔ affineDenominator v * n ≤ affineNumerator v n := by
  simpa [affineNumerator, affineDenominator] using
    blockNonDescent_iff_arith v n hAdm

/-- Non-descent of the canonical accelerated trace is exactly the
corresponding affine inequality. -/
theorem acceleratedTrace_nonDescent_iff_affine (k n : Nat) :
    BlockNonDescent (acceleratedTrace k n) n ↔
      acceleratedDenominator k n * n ≤ acceleratedNumerator k n := by
  simpa [acceleratedDenominator, acceleratedNumerator] using
    blockNonDescent_iff_affine (acceleratedTrace k n) n
      (admissible_acceleratedTrace k n)

/-- A canonical accelerated block strictly descends at `n`, stated purely
as an affine inequality. -/
def AcceleratedAffineDescent (k n : Nat) : Prop :=
  acceleratedNumerator k n < acceleratedDenominator k n * n

/-- A canonical accelerated block fails to descend at `n`, stated purely
as an affine inequality. -/
def AcceleratedAffineNonDescent (k n : Nat) : Prop :=
  acceleratedDenominator k n * n ≤ acceleratedNumerator k n

/-- Descent of the canonical accelerated trace is exactly the corresponding
strict affine inequality. -/
theorem acceleratedTrace_descent_iff_affine (k n : Nat) :
    BlockDescent (acceleratedTrace k n) n ↔ AcceleratedAffineDescent k n := by
  simpa [AcceleratedAffineDescent, acceleratedDenominator, acceleratedNumerator] using
    blockDescent_iff_affine (acceleratedTrace k n) n
      (admissible_acceleratedTrace k n)

/-- The affine descent inequality is equivalent to the accelerated iterate
actually dropping below the starting value. -/
theorem acceleratedOddIter_lt_iff_affine (k n : Nat) :
    acceleratedOddIter k n < n ↔ AcceleratedAffineDescent k n := by
  rw [← acceleratedTrace_descent_iff_affine k n]
  unfold BlockDescent
  rw [applyWord_acceleratedTrace]

/-- Multiplier gap plus offset margin gives affine descent for a canonical
accelerated trace. -/
theorem acceleratedAffineDescent_of_multiplier_gap
    (k n : Nat)
    (hGap : 3 ^ k < acceleratedDenominator k n)
    (hOffset : offset (acceleratedTrace k n) <
      (acceleratedDenominator k n - 3 ^ k) * n) :
    AcceleratedAffineDescent k n := by
  unfold AcceleratedAffineDescent acceleratedNumerator acceleratedDenominator
  have hGap' :
      affineMultiplier (acceleratedTrace k n) <
        affineDenominator (acceleratedTrace k n) := by
    simpa [affineMultiplier, length_acceleratedTrace] using hGap
  have hOffset' :
      offset (acceleratedTrace k n) <
        (affineDenominator (acceleratedTrace k n) -
          affineMultiplier (acceleratedTrace k n)) * n := by
    simpa [affineMultiplier, length_acceleratedTrace] using hOffset
  exact affineNumerator_lt_denominator_mul_of_offset_lt_gap
    (acceleratedTrace k n) n hGap' hOffset'

/-- Same multiplier-gap criterion, written with `acceleratedTotalV`. -/
theorem acceleratedAffineDescent_of_totalV_gap
    (k n : Nat)
    (hGap : 3 ^ k < 2 ^ acceleratedTotalV k n)
    (hOffset : offset (acceleratedTrace k n) <
      (2 ^ acceleratedTotalV k n - 3 ^ k) * n) :
    AcceleratedAffineDescent k n := by
  apply acceleratedAffineDescent_of_multiplier_gap k n
  · simpa [acceleratedDenominator_eq_pow_totalV] using hGap
  · simpa [acceleratedDenominator_eq_pow_totalV] using hOffset

/-- Bounded-offset form of the accelerated multiplier-gap criterion. -/
theorem acceleratedAffineDescent_of_offset_le_bound
    (k n bound : Nat)
    (hGap : 3 ^ k < acceleratedDenominator k n)
    (hBound : offset (acceleratedTrace k n) ≤ bound)
    (hBoundLt : bound < (acceleratedDenominator k n - 3 ^ k) * n) :
    AcceleratedAffineDescent k n := by
  apply acceleratedAffineDescent_of_multiplier_gap k n hGap
  exact Nat.lt_of_le_of_lt hBound hBoundLt

/-- Threshold form of the accelerated multiplier-gap criterion: under a
multiplier gap, `n` only needs to exceed `offset / gap`. -/
theorem acceleratedAffineDescent_of_start_gt_offset_div_gap
    (k n : Nat)
    (hGap : 3 ^ k < acceleratedDenominator k n)
    (hStart : offset (acceleratedTrace k n) /
      (acceleratedDenominator k n - 3 ^ k) < n) :
    AcceleratedAffineDescent k n := by
  unfold AcceleratedAffineDescent acceleratedNumerator acceleratedDenominator
  have hGap' :
      affineMultiplier (acceleratedTrace k n) <
        affineDenominator (acceleratedTrace k n) := by
    simpa [affineMultiplier, length_acceleratedTrace] using hGap
  have hStart' :
      offset (acceleratedTrace k n) /
        (affineDenominator (acceleratedTrace k n) -
          affineMultiplier (acceleratedTrace k n)) < n := by
    simpa [affineMultiplier, length_acceleratedTrace] using hStart
  exact affineNumerator_lt_denominator_mul_of_start_gt_offset_div_gap
    (acceleratedTrace k n) n hGap' hStart'

/-- Threshold form written with `acceleratedTotalV`. -/
theorem acceleratedAffineDescent_of_totalV_start_gt_offset_div_gap
    (k n : Nat)
    (hGap : 3 ^ k < 2 ^ acceleratedTotalV k n)
    (hStart : offset (acceleratedTrace k n) /
      (2 ^ acceleratedTotalV k n - 3 ^ k) < n) :
    AcceleratedAffineDescent k n := by
  apply acceleratedAffineDescent_of_start_gt_offset_div_gap k n
  · simpa [acceleratedDenominator_eq_pow_totalV] using hGap
  · simpa [acceleratedDenominator_eq_pow_totalV] using hStart

/-- If a canonical trace has a multiplier gap but does not descend, then
its offset must be at least the gap times the starting value. -/
theorem offset_ge_gap_mul_of_acceleratedAffineNonDescent
    (k n : Nat)
    (hGap : 3 ^ k < acceleratedDenominator k n)
    (hNonDesc : AcceleratedAffineNonDescent k n) :
    (acceleratedDenominator k n - 3 ^ k) * n ≤ offset (acceleratedTrace k n) := by
  unfold AcceleratedAffineNonDescent acceleratedNumerator acceleratedDenominator at hNonDesc
  have hGap' :
      affineMultiplier (acceleratedTrace k n) <
        affineDenominator (acceleratedTrace k n) := by
    simpa [affineMultiplier, length_acceleratedTrace] using hGap
  have hNonDesc' :
      affineDenominator (acceleratedTrace k n) * n ≤
        affineNumerator (acceleratedTrace k n) n := by
    exact hNonDesc
  have h := offset_ge_gap_mul_of_affineNumerator_ge_denominator_mul
    (acceleratedTrace k n) n hGap' hNonDesc'
  simpa [affineMultiplier, length_acceleratedTrace] using h

/-- Persistent non-descent of the accelerated trace, rewritten as a family
of affine inequalities. -/
theorem persistent_nonDescent_iff_acceleratedAffine (n : Nat) :
    (∀ k : Nat, BlockNonDescent (acceleratedTrace k n) n) ↔
      ∀ k : Nat, AcceleratedAffineNonDescent k n := by
  constructor
  · intro h k
    exact (acceleratedTrace_nonDescent_iff_affine k n).mp (h k)
  · intro h k
    exact (acceleratedTrace_nonDescent_iff_affine k n).mpr (h k)

/-- A global long-block affine descent hypothesis for positive odd values:
every odd `n > 1` has some canonical accelerated block that drops below
`n`. This is a proof criterion, not a theorem claimed by the scaffold. -/
def EventuallyAcceleratedAffineDescent : Prop :=
  ∀ n : Nat, 1 < n → n % 2 = 1 → ∃ k : Nat, AcceleratedAffineDescent k n

/-- Threshold version of eventual affine descent: every positive odd
`n > 1` admits a canonical trace with multiplier gap and
`offset / gap < n`. -/
def EventuallyAcceleratedAffineThresholdDescent : Prop :=
  ∀ n : Nat, 1 < n → n % 2 = 1 →
    ∃ k : Nat,
      3 ^ k < acceleratedDenominator k n ∧
        offset (acceleratedTrace k n) /
          (acceleratedDenominator k n - 3 ^ k) < n

/-- The threshold criterion implies the direct affine descent criterion. -/
theorem EventuallyAcceleratedAffineDescent_of_threshold
    (h : EventuallyAcceleratedAffineThresholdDescent) :
    EventuallyAcceleratedAffineDescent := by
  intro n hgt hodd
  rcases h n hgt hodd with ⟨k, hGap, hStart⟩
  exact ⟨k, acceleratedAffineDescent_of_start_gt_offset_div_gap k n hGap hStart⟩

/-- In the expanding regime `2^V ≤ 3^L`, no admissible block can descend.

This is the symbolic statement that "to descend you must have at least
some halving budget over the multiplicative budget". -/
theorem not_blockDescent_in_expanding_regime (v : ParityWord) (n : Nat)
    (hAdm : Admissible v n)
    (hge : 2 ^ totalV v ≤ 3 ^ v.length) :
    ¬ BlockDescent v n := by
  rw [blockDescent_iff_arith v n hAdm]
  intro h
  have hMul_le : 2 ^ totalV v * n ≤ 3 ^ v.length * n :=
    Nat.mul_le_mul_right n hge
  omega

end ParityWords

/-! ## Minimal classical Collatz counterexample -/

/-- A counterexample is *minimal* if every smaller positive value reaches
`1`. -/
def MinimalCollatzCounterexample (n : Nat) : Prop :=
  CollatzCounterexample n ∧ ∀ m : Nat, 0 < m → m < n → CollatzReachesOne m

/-- If any positive Collatz counterexample exists, then a *minimal* one
exists. The proof is a strong-induction case split on whether a smaller
counterexample exists; the case split uses `Classical.em` because
`CollatzCounterexample` is not decidable. -/
theorem exists_minimal_of_counterexample :
    (∃ n, CollatzCounterexample n) → ∃ n, MinimalCollatzCounterexample n := by
  rintro ⟨n0, hn0⟩
  suffices h : ∀ n, CollatzCounterexample n → ∃ m, MinimalCollatzCounterexample m
    from h n0 hn0
  intro n
  induction n using Nat.strongRecOn with
  | ind n ih =>
      intro hn
      rcases Classical.em (∃ m, m < n ∧ CollatzCounterexample m) with hSmall | hSmall
      · rcases hSmall with ⟨m, hmlt, hmCE⟩
        exact ih m hmlt hmCE
      · refine ⟨n, hn, ?_⟩
        intro m hmpos hmlt
        have hNotCE : ¬ CollatzCounterexample m :=
          fun hCE => hSmall ⟨m, hmlt, hCE⟩
        have hNotAvoid : ¬ CollatzAvoidsOne m :=
          fun hAvoid => hNotCE ⟨hmpos, hAvoid⟩
        exact (reaches_one_iff_not_avoids_one m).mpr hNotAvoid

/-- A minimal counterexample's classical orbit is bounded below by `n`:
the orbit never falls strictly below the starting value. -/
theorem minimal_counterexample_orbit_lower_bound (n : Nat)
    (hMin : MinimalCollatzCounterexample n) :
    ∀ k : Nat, n ≤ collatzIter k n := by
  intro k
  rcases hMin with ⟨⟨hpos, hAvoid⟩, hSmaller⟩
  rcases Nat.lt_or_ge (collatzIter k n) n with hlt | hge
  · exfalso
    have hPosIter : 0 < collatzIter k n := collatzIter_pos k n hpos
    have hReach : CollatzReachesOne (collatzIter k n) :=
      hSmaller (collatzIter k n) hPosIter hlt
    rcases hReach with ⟨j, hj⟩
    have hReachN : collatzIter (k + j) n = 1 :=
      (collatzIter_add k j n).trans hj
    exact hAvoid (k + j) hReachN
  · exact hge

/-- A minimal counterexample is necessarily odd: if it were even, its odd
part would be a smaller positive counterexample, contradicting minimality. -/
theorem minimal_counterexample_odd (n : Nat)
    (hMin : MinimalCollatzCounterexample n) :
    n % 2 = 1 := by
  rcases hMin with ⟨⟨hpos, hAvoid⟩, hSmaller⟩
  rcases Nat.mod_two_eq_zero_or_one n with hEven | hOdd
  · exfalso
    have hOddMod : oddPart n % 2 = 1 := oddPart_pos_odd n hpos
    have hOddPos : 0 < oddPart n := by
      rcases h : oddPart n with _ | k
      · rw [h] at hOddMod; cases hOddMod
      · exact Nat.succ_pos _
    have hStepsPos : 1 ≤ oddPartSteps n := by
      rw [oddPartSteps_even_succ n hpos hEven]
      exact Nat.succ_le_succ (Nat.zero_le _)
    have h2pow_ge : 2 ≤ 2 ^ oddPartSteps n := by
      have h := Nat.pow_le_pow_right (by decide : 1 ≤ 2) hStepsPos
      simpa using h
    have hFactor : n = 2 ^ oddPartSteps n * oddPart n :=
      oddPart_factorization n hpos
    have hMul_ge : 2 * oddPart n ≤ 2 ^ oddPartSteps n * oddPart n :=
      Nat.mul_le_mul_right (oddPart n) h2pow_ge
    have hOddLt : oddPart n < n := by omega
    have hOddAvoid : CollatzAvoidsOne (oddPart n) := by
      intro k hk
      have hReachOdd : CollatzReachesOne (oddPart n) := ⟨k, hk⟩
      have hReachN : CollatzReachesOne n :=
        (CollatzReachesOne_iff_oddPart n hpos).mpr hReachOdd
      rcases hReachN with ⟨j, hj⟩
      exact hAvoid j hj
    have hReach : CollatzReachesOne (oddPart n) :=
      hSmaller (oddPart n) hOddPos hOddLt
    rcases hReach with ⟨k, hk⟩
    exact hOddAvoid k hk
  · exact hOdd

/-- A minimal counterexample's accelerated orbit is bounded below by `n`. -/
theorem minimal_counterexample_accelerated_lower_bound (n : Nat)
    (hMin : MinimalCollatzCounterexample n) :
    ∀ k : Nat, n ≤ acceleratedOddIter k n := by
  intro k
  have hpos : 0 < n := hMin.1.1
  have hodd : n % 2 = 1 := minimal_counterexample_odd n hMin
  rcases acceleratedOddIter_reachable k n hpos hodd with ⟨m, hm⟩
  have hBound := minimal_counterexample_orbit_lower_bound n hMin m
  rw [hm] at hBound
  exact hBound

/-! ## Persistent non-descent and the extraction principle -/

namespace ParityWords

/-- Every initial segment of the accelerated trace from a minimal
counterexample is non-descending: the parity-word block at `n` returns to
a value `≥ n`. -/
theorem minimal_counterexample_persistent_nonDescent (n : Nat)
    (hMin : MinimalCollatzCounterexample n) :
    ∀ k : Nat, BlockNonDescent (acceleratedTrace k n) n := by
  intro k
  unfold BlockNonDescent
  rw [applyWord_acceleratedTrace]
  exact minimal_counterexample_accelerated_lower_bound n hMin k

/-- Every accelerated trace from a minimal counterexample satisfies the
affine non-descent inequality. -/
theorem minimal_counterexample_persistent_affine_nonDescent (n : Nat)
    (hMin : MinimalCollatzCounterexample n) :
    ∀ k : Nat, AcceleratedAffineNonDescent k n := by
  intro k
  exact (acceleratedTrace_nonDescent_iff_affine k n).mp
    (minimal_counterexample_persistent_nonDescent n hMin k)

/-- A minimal counterexample cannot have any affine descending accelerated
block. -/
theorem no_acceleratedAffine_descent_of_minimal_counterexample
    (n k : Nat) (hMin : MinimalCollatzCounterexample n) :
    ¬ AcceleratedAffineDescent k n := by
  intro hDesc
  have hNonDesc : AcceleratedAffineNonDescent k n :=
    minimal_counterexample_persistent_affine_nonDescent n hMin k
  unfold AcceleratedAffineDescent at hDesc
  unfold AcceleratedAffineNonDescent at hNonDesc
  omega

end ParityWords

/-! ## Long-block affine descent criterion -/

/-- An affine descending accelerated block reaches a smaller positive value
by a finite classical Collatz orbit segment. -/
theorem collatzReaches_smaller_of_acceleratedAffine_descent
    (k n : Nat) (hpos : 0 < n) (hodd : n % 2 = 1)
    (hDesc : ParityWords.AcceleratedAffineDescent k n) :
    ∃ m : Nat, 0 < m ∧ m % 2 = 1 ∧ m < n ∧ CollatzReaches n m := by
  have hOdd : acceleratedOddIter k n % 2 = 1 :=
    acceleratedOddIter_odd k n hpos hodd
  refine ⟨acceleratedOddIter k n, ?_, hOdd, ?_, ?_⟩
  ·
    rcases h : acceleratedOddIter k n with _ | m
    · rw [h] at hOdd
      cases hOdd
    · exact Nat.succ_pos _
  · exact (ParityWords.acceleratedOddIter_lt_iff_affine k n).mpr hDesc
  · exact acceleratedOddIter_reachable k n hpos hodd

/-- If every positive odd value above `1` admits some affine descending
accelerated block, then the Collatz conjecture follows. -/
theorem CollatzConjecture_of_eventual_acceleratedAffine_descent
    (hDesc : ParityWords.EventuallyAcceleratedAffineDescent) :
    CollatzConjecture := by
  rw [CollatzConjecture_iff_on_odd]
  intro n
  induction n using Nat.strongRecOn with
  | ind n ih =>
      intro hpos hodd
      by_cases hOne : n = 1
      · exact ⟨0, by simp [collatzIter, hOne]⟩
      · have hgt : 1 < n := by omega
        rcases hDesc n hgt hodd with ⟨k, hkDesc⟩
        rcases collatzReaches_smaller_of_acceleratedAffine_descent k n hpos hodd hkDesc
          with ⟨m, hmpos, hmodd, hmlt, hReachM⟩
        have hM : CollatzReachesOne m := ih m hmlt hmpos hmodd
        exact collatzReaches_trans_one hReachM hM

/-- Threshold version of the long-block descent criterion. -/
theorem CollatzConjecture_of_eventual_acceleratedAffine_threshold_descent
    (hDesc : ParityWords.EventuallyAcceleratedAffineThresholdDescent) :
    CollatzConjecture :=
  CollatzConjecture_of_eventual_acceleratedAffine_descent
    (ParityWords.EventuallyAcceleratedAffineDescent_of_threshold hDesc)

/-- Counterexample extraction principle: if any positive Collatz
counterexample exists, then there is a positive odd `n` whose accelerated
orbit never descends below `n`.

Equivalently, every accelerated trace from such an `n` is admissible (by
`admissible_acceleratedTrace`) and non-descending in the `BlockNonDescent`
sense. This isolates the divergence branch as the symbolic problem of
ruling out persistent non-descending admissible parity-word trajectories. -/
theorem counterexample_extraction :
    (∃ n, CollatzCounterexample n) →
      ∃ n : Nat,
        0 < n ∧ n % 2 = 1 ∧ CollatzAvoidsOne n ∧
          ∀ k : Nat, n ≤ acceleratedOddIter k n := by
  intro h
  rcases exists_minimal_of_counterexample h with ⟨n, hMin⟩
  exact ⟨n, hMin.1.1, minimal_counterexample_odd n hMin, hMin.1.2,
    minimal_counterexample_accelerated_lower_bound n hMin⟩

/-- Affine version of the counterexample extraction principle: any
counterexample yields a positive odd counterexample whose canonical
accelerated trace satisfies every affine non-descent inequality. -/
theorem counterexample_extraction_affine :
    (∃ n, CollatzCounterexample n) →
      ∃ n : Nat,
        0 < n ∧ n % 2 = 1 ∧ CollatzAvoidsOne n ∧
          ∀ k : Nat, ParityWords.AcceleratedAffineNonDescent k n := by
  intro h
  rcases exists_minimal_of_counterexample h with ⟨n, hMin⟩
  exact ⟨n, hMin.1.1, minimal_counterexample_odd n hMin, hMin.1.2,
    ParityWords.minimal_counterexample_persistent_affine_nonDescent n hMin⟩
