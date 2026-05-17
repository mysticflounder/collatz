/-
  Strength checks for candidate Collatz reductions.

  This file records what the boundary-aware residue obstruction would imply
  about accelerated cycles. It does not prove the residue obstruction itself;
  instead, it makes explicit that the obstruction is strong enough to exclude
  a minimal nontrivial accelerated cycle once a first multiplier gap occurs
  inside the cycle window.
-/

import CollatzConjecture.FloorFreeResidue
import CollatzConjecture.SmallCycles

/-! ## Minimal accelerated cycle representatives -/

/-- `n` is a nontrivial accelerated cycle element and is minimal along the
first `k` iterates of that cycle. -/
def IsMinimalAcceleratedOddCycle (k n : Nat) : Prop :=
  IsAcceleratedOddCycle k n ∧
    1 < n ∧
      ∀ j : Nat, j ≤ k → n ≤ acceleratedOddIter j n

/-! ## Boundary residue obstruction excludes minimal cycles -/

/-- Any nontrivial accelerated odd cycle has a multiplier gap over its full
cycle length. -/
theorem acceleratedMultiplierGap_of_isAcceleratedOddCycle
    {k n : Nat}
    (hCycle : IsAcceleratedOddCycle k n) :
    ParityWords.AcceleratedMultiplierGap k n := by
  rcases hCycle with ⟨hkpos, _hnpos, _hodd, hIter⟩
  have hAdm :
      ParityWords.Admissible (ParityWords.acceleratedTrace k n) n :=
    ParityWords.admissible_acceleratedTrace k n
  have hApp :
      ParityWords.applyWord (ParityWords.acceleratedTrace k n) n = n := by
    rw [ParityWords.applyWord_acceleratedTrace]
    exact hIter
  have hNonempty : ParityWords.acceleratedTrace k n ≠ [] := by
    intro hNil
    have hLenZero : (ParityWords.acceleratedTrace k n).length = 0 := by
      rw [hNil]
      rfl
    rw [ParityWords.length_acceleratedTrace] at hLenZero
    omega
  have hGap :=
    ParityWords.pow_three_lt_pow_two_of_cycle
      (ParityWords.acceleratedTrace k n) n hNonempty hAdm hApp
  simpa [ParityWords.AcceleratedMultiplierGap,
    ParityWords.acceleratedDenominator_eq_pow_totalV,
    ParityWords.acceleratedTotalV,
    ParityWords.length_acceleratedTrace] using hGap

/-- Bounded least-search helper for multiplier gaps. -/
private theorem exists_firstAcceleratedMultiplierGap_le_of_bounded_gap
    {k n : Nat}
    (hBounded : ∃ i : Nat, i ≤ k ∧
      ParityWords.AcceleratedMultiplierGap i n) :
    ∃ j : Nat, j ≤ k ∧ ParityWords.FirstAcceleratedMultiplierGap j n := by
  classical
  induction k with
  | zero =>
      rcases hBounded with ⟨i, hiLe, hiGap⟩
      have hiZero : i = 0 := by omega
      subst i
      refine ⟨0, by omega, ⟨hiGap, ?_⟩⟩
      intro i hi
      omega
  | succ k ih =>
      by_cases hPrev : ∃ i : Nat, i ≤ k ∧
          ParityWords.AcceleratedMultiplierGap i n
      · rcases ih hPrev with ⟨j, hjLe, hFirst⟩
        exact ⟨j, by omega, hFirst⟩
      · have hCurrentGap :
            ParityWords.AcceleratedMultiplierGap (k + 1) n := by
          rcases hBounded with ⟨i, hiLe, hiGap⟩
          have hiEq : i = k + 1 := by
            by_cases hiLt : i < k + 1
            · have hiLeK : i ≤ k := by omega
              exact False.elim (hPrev ⟨i, hiLeK, hiGap⟩)
            · omega
          subst i
          exact hiGap
        refine ⟨k + 1, by omega, ⟨hCurrentGap, ?_⟩⟩
        intro i hiLt hGapI
        have hiLeK : i ≤ k := by omega
        exact hPrev ⟨i, hiLeK, hGapI⟩

/-- If some accelerated prefix has a multiplier gap, then there is a least
such prefix, and it is a first multiplier gap no later than the original
prefix. -/
theorem exists_firstAcceleratedMultiplierGap_le_of_gap
    {k n : Nat}
    (hGap : ParityWords.AcceleratedMultiplierGap k n) :
    ∃ j : Nat, j ≤ k ∧ ParityWords.FirstAcceleratedMultiplierGap j n := by
  exact exists_firstAcceleratedMultiplierGap_le_of_bounded_gap
    ⟨k, by omega, hGap⟩

/-- Every nontrivial accelerated odd cycle has a first multiplier gap within
its cycle length. -/
theorem exists_firstAcceleratedMultiplierGap_le_of_isAcceleratedOddCycle
    {k n : Nat}
    (hCycle : IsAcceleratedOddCycle k n) :
    ∃ j : Nat, j ≤ k ∧ ParityWords.FirstAcceleratedMultiplierGap j n := by
  exact exists_firstAcceleratedMultiplierGap_le_of_gap
    (acceleratedMultiplierGap_of_isAcceleratedOddCycle hCycle)

/-- The boundary-aware canonical-residue first-gap target rules out a
nontrivial accelerated cycle when `n` is the minimum cycle representative and
the first multiplier-gap prefix occurs within the cycle window.

This theorem is mainly a strength classifier: proving
`FirstMultiplierGapCanonicalResidueBoundaryGapBound` is at least strong enough
to eliminate nontrivial positive accelerated cycles. -/
theorem no_minimalAcceleratedOddCycle_at_firstGap_of_boundary
    (hBound : ParityWords.FirstMultiplierGapCanonicalResidueBoundaryGapBound)
    {k n j : Nat}
    (hMinCycle : IsMinimalAcceleratedOddCycle k n)
    (hFirst : ParityWords.FirstAcceleratedMultiplierGap j n)
    (hjle : j ≤ k) :
    False := by
  rcases hMinCycle with ⟨hCycle, hgt, hMin⟩
  have hNoQI :
      ParityWords.NoFirstMultiplierGapQuotientIntervalObstruction :=
    ParityWords.noFirstMultiplierGapQuotientInterval_of_canonicalResidueBoundaryGapBound
      hBound
  have hLower :
      ParityWords.acceleratedOffset j n + ParityWords.acceleratedMultiplier j <
        ParityWords.acceleratedDenominator j n *
          acceleratedOddIter j n :=
    ParityWords.acceleratedOutput_lower_mul_of_start_gt_one j n hgt
  have hUpper :
      ParityWords.acceleratedGap j n * acceleratedOddIter j n ≤
        ParityWords.acceleratedOffset j n :=
    ParityWords.acceleratedOutput_upper_mul_of_nonDescent j n hFirst.1
      (hMin j hjle)
  have hMul :
      ParityWords.AcceleratedOutputQuotientIntervalMul j n
        (acceleratedOddIter j n) := by
    exact ⟨hFirst.1, rfl, hLower, hUpper⟩
  have hQI :
      ParityWords.AcceleratedOutputQuotientInterval j n
        (acceleratedOddIter j n) :=
    (ParityWords.acceleratedOutputQuotientInterval_iff_mul j n
      (acceleratedOddIter j n) hFirst.1).mpr hMul
  exact hNoQI n j (acceleratedOddIter j n) hgt hCycle.2.2.1
    hFirst rfl hQI

/-- The boundary-aware canonical-residue first-gap target rules out any
nontrivial accelerated cycle represented by its minimal cycle element. -/
theorem no_minimalAcceleratedOddCycle_of_boundary
    (hBound : ParityWords.FirstMultiplierGapCanonicalResidueBoundaryGapBound)
    {k n : Nat}
    (hMinCycle : IsMinimalAcceleratedOddCycle k n) :
    False := by
  rcases exists_firstAcceleratedMultiplierGap_le_of_isAcceleratedOddCycle
      hMinCycle.1 with
    ⟨j, hjle, hFirst⟩
  exact no_minimalAcceleratedOddCycle_at_firstGap_of_boundary
    hBound hMinCycle hFirst hjle
