/-
  Floor-free residue obstruction reduction.

  The quotient-obstruction layer says that a bad first multiplier-gap prefix
  would put the accelerated output `q` in the interval

      gap * q <= offset.

  The strategy search now produces a floor-free target for the canonical odd
  residue representative `r` modulo `2 * 3^k`:

      offset < gap * r.

  Since every positive quotient in that residue class is at least `r`, this
  floor-free inequality rules out the quotient interval without reasoning about
  floors or least compatible starts. There is one important boundary shape:
  if `offset = gap * r`, the upper endpoint allows only `q = r`; the lower
  endpoint still excludes it when `D * r <= offset + 3^k`.
-/

import CollatzConjecture.NormalizedResidue

namespace ParityWords

/-! ## Canonical quotient residues -/

/-- `r` is the canonical positive representative of `q` modulo `modulus`.

The strict upper bound is intentional: for the odd modulus representatives we
use below, the excluded endpoint is even and therefore not a valid odd
representative anyway. -/
def CanonicalResidueRepresentative (modulus q r : Nat) : Prop :=
  0 < r ∧ r < modulus ∧ q % modulus = r

/-- The representative of a positive residue class modulo `modulus` is no
larger than any natural number in that class. -/
theorem canonicalResidueRepresentative_le
    {modulus q r : Nat}
    (hRep : CanonicalResidueRepresentative modulus q r) :
    r ≤ q := by
  rcases hRep with ⟨_hrPos, _hrLt, hmod⟩
  have hModLe : q % modulus ≤ q := Nat.mod_le q modulus
  omega

/-- Canonical odd representative modulo `2 * 3^k` for the accelerated output
quotient. -/
def AcceleratedCanonicalQuotientResidue (k q r : Nat) : Prop :=
  CanonicalResidueRepresentative (2 * acceleratedMultiplier k) q r

/-- Floor-free residue lower bound for a canonical accelerated quotient
representative. -/
def AcceleratedResidueGapBound (k n r : Nat) : Prop :=
  acceleratedOffset k n < acceleratedGap k n * r

/-- Stronger floor-free residue lower bound suggested by the bounded search:
the canonical residue clears five times the affine offset. -/
def AcceleratedResidueStrongGapBound (k n r : Nat) : Prop :=
  5 * acceleratedOffset k n < acceleratedGap k n * r

/-- Boundary-aware floor-free residue condition. In the strict case it is the
ordinary gap bound. In the equality case, the lower quotient-interval endpoint
must exclude the canonical representative. -/
def AcceleratedResidueBoundaryGapBound (k n r : Nat) : Prop :=
  acceleratedOffset k n < acceleratedGap k n * r ∨
    acceleratedOffset k n = acceleratedGap k n * r ∧
      acceleratedDenominator k n * r ≤
        acceleratedOffset k n + acceleratedMultiplier k

/-- The `5B` bound is stronger than the bound needed to rule out the forbidden
interval. -/
theorem acceleratedResidueGapBound_of_strong
    (k n r : Nat)
    (hStrong : AcceleratedResidueStrongGapBound k n r) :
    AcceleratedResidueGapBound k n r := by
  unfold AcceleratedResidueStrongGapBound at hStrong
  unfold AcceleratedResidueGapBound
  have hOffsetLe : acceleratedOffset k n ≤ 5 * acceleratedOffset k n := by
    omega
  exact Nat.lt_of_le_of_lt hOffsetLe hStrong

/-! ## Floor-free bound excludes quotient intervals -/

/-- If a canonical quotient residue representative already clears the
gap/offset bound, then no quotient in that residue class can lie in the
forbidden interval. -/
theorem not_outputQuotientInterval_of_canonicalResidueGapBound
    (k n q r : Nat)
    (hRep : AcceleratedCanonicalQuotientResidue k q r)
    (hBound : AcceleratedResidueGapBound k n r) :
    ¬ AcceleratedOutputQuotientInterval k n q := by
  intro hInterval
  have hrLeQ : r ≤ q := canonicalResidueRepresentative_le hRep
  have hGapLe :
      acceleratedGap k n * r ≤ acceleratedGap k n * q :=
    Nat.mul_le_mul_left (acceleratedGap k n) hrLeQ
  have hUpper : acceleratedGap k n * q ≤ acceleratedOffset k n := by
    have hMul :=
      (acceleratedOutputQuotientInterval_iff_mul k n q hInterval.1).mp
        hInterval
    exact hMul.2.2.2
  have hContr : acceleratedGap k n * r ≤ acceleratedOffset k n :=
    Nat.le_trans hGapLe hUpper
  exact Nat.not_lt_of_ge hContr hBound

/-- The boundary-aware floor-free condition rules out the forbidden quotient
interval. -/
theorem not_outputQuotientInterval_of_canonicalResidueBoundaryGapBound
    (k n q r : Nat)
    (hRep : AcceleratedCanonicalQuotientResidue k q r)
    (hBound : AcceleratedResidueBoundaryGapBound k n r) :
    ¬ AcceleratedOutputQuotientInterval k n q := by
  intro hInterval
  rcases hBound with hStrict | hBoundary
  · exact not_outputQuotientInterval_of_canonicalResidueGapBound
      k n q r hRep hStrict hInterval
  · rcases hBoundary with ⟨hEq, hLowerBoundary⟩
    have hMul :=
      (acceleratedOutputQuotientInterval_iff_mul k n q hInterval.1).mp
        hInterval
    rcases hMul with ⟨hGap, _hq, hLower, hUpper⟩
    have hrLeQ : r ≤ q := canonicalResidueRepresentative_le hRep
    rcases Nat.lt_or_eq_of_le hrLeQ with hrLtQ | hrEqQ
    · have hGapPos : 0 < acceleratedGap k n :=
        acceleratedGap_pos_of_multiplierGap k n hGap
      have hGapLt :
          acceleratedGap k n * r < acceleratedGap k n * q :=
        Nat.mul_lt_mul_of_pos_left hrLtQ hGapPos
      have hOffsetLt : acceleratedOffset k n < acceleratedGap k n * q := by
        rw [hEq]
        exact hGapLt
      exact Nat.not_lt_of_ge hUpper hOffsetLt
    · have hDqLe :
          acceleratedDenominator k n * q ≤
            acceleratedOffset k n + acceleratedMultiplier k := by
        rw [← hrEqQ]
        exact hLowerBoundary
      exact Nat.not_lt_of_ge hDqLe hLower

/-! ## First-gap local target in floor-free residue form -/

/-- Local first-gap target using a canonical residue representative and a
floor-free gap/offset inequality. -/
def FirstMultiplierGapCanonicalResidueGapBound : Prop :=
  ∀ n k q r : Nat, 1 < n → n % 2 = 1 →
    FirstAcceleratedMultiplierGap k n →
      q = acceleratedOddIter k n →
        AcceleratedCanonicalQuotientResidue k q r →
          AcceleratedResidueGapBound k n r

/-- Stronger local first-gap target matching the current computational
invariant: the canonical quotient residue clears `5 * offset`. -/
def FirstMultiplierGapCanonicalResidueStrongGapBound : Prop :=
  ∀ n k q r : Nat, 1 < n → n % 2 = 1 →
    FirstAcceleratedMultiplierGap k n →
      q = acceleratedOddIter k n →
        AcceleratedCanonicalQuotientResidue k q r →
          AcceleratedResidueStrongGapBound k n r

/-- Boundary-aware first-gap target matching the refined computation:
usually `offset < gap * r`, with the exact endpoint case discharged by the
lower quotient-interval bound. -/
def FirstMultiplierGapCanonicalResidueBoundaryGapBound : Prop :=
  ∀ n k q r : Nat, 1 < n → n % 2 = 1 →
    FirstAcceleratedMultiplierGap k n →
      q = acceleratedOddIter k n →
        AcceleratedCanonicalQuotientResidue k q r →
          AcceleratedResidueBoundaryGapBound k n r

/-- The stronger `5B` target implies the sufficient floor-free target. -/
theorem firstMultiplierGapCanonicalResidueGapBound_of_strong
    (hStrong : FirstMultiplierGapCanonicalResidueStrongGapBound) :
    FirstMultiplierGapCanonicalResidueGapBound := by
  intro n k q r hgt hodd hFirst hq hRep
  exact acceleratedResidueGapBound_of_strong k n r
    (hStrong n k q r hgt hodd hFirst hq hRep)

/-- The floor-free residue-gap target implies the existing quotient-interval
local target. -/
theorem noFirstMultiplierGapQuotientInterval_of_canonicalResidueGapBound
    (hBound : FirstMultiplierGapCanonicalResidueGapBound) :
    NoFirstMultiplierGapQuotientIntervalObstruction := by
  intro n k q hgt hodd hFirst hq hInterval
  let modulus := 2 * acceleratedMultiplier k
  let r := q % modulus
  have hModulusPos : 0 < modulus := by
    unfold modulus acceleratedMultiplier
    exact Nat.mul_pos (by decide : 0 < 2)
      (Nat.pow_pos (by decide : 0 < 3))
  have hRep : AcceleratedCanonicalQuotientResidue k q r := by
    unfold AcceleratedCanonicalQuotientResidue CanonicalResidueRepresentative r
    refine ⟨?_, ?_, rfl⟩
    · have hOdd : q % 2 = 1 := by
        rw [hq]
        exact acceleratedOddIter_odd k n (by omega) hodd
      apply Nat.pos_of_ne_zero
      intro hEqZero
      have hEvenMod : (q % modulus) % 2 = 0 := by
        rw [hEqZero]
      have hModulusEven : 2 ∣ modulus := by
        unfold modulus
        exact ⟨acceleratedMultiplier k, rfl⟩
      have hqModTwo :
          (q % modulus) % 2 = q % 2 := by
        exact Nat.mod_mod_of_dvd q hModulusEven
      omega
    · simpa [modulus] using Nat.mod_lt q hModulusPos
  exact not_outputQuotientInterval_of_canonicalResidueGapBound k n q r hRep
    (hBound n k q r hgt hodd hFirst hq hRep) hInterval

/-- The stronger `5B` floor-free residue-gap target also implies the existing
quotient-interval local target. -/
theorem noFirstMultiplierGapQuotientInterval_of_canonicalResidueStrongGapBound
    (hStrong : FirstMultiplierGapCanonicalResidueStrongGapBound) :
    NoFirstMultiplierGapQuotientIntervalObstruction :=
  noFirstMultiplierGapQuotientInterval_of_canonicalResidueGapBound
    (firstMultiplierGapCanonicalResidueGapBound_of_strong hStrong)

/-- The boundary-aware floor-free target implies the existing quotient-interval
local target. -/
theorem noFirstMultiplierGapQuotientInterval_of_canonicalResidueBoundaryGapBound
    (hBound : FirstMultiplierGapCanonicalResidueBoundaryGapBound) :
    NoFirstMultiplierGapQuotientIntervalObstruction := by
  intro n k q hgt hodd hFirst hq hInterval
  let modulus := 2 * acceleratedMultiplier k
  let r := q % modulus
  have hModulusPos : 0 < modulus := by
    unfold modulus acceleratedMultiplier
    exact Nat.mul_pos (by decide : 0 < 2)
      (Nat.pow_pos (by decide : 0 < 3))
  have hRep : AcceleratedCanonicalQuotientResidue k q r := by
    unfold AcceleratedCanonicalQuotientResidue CanonicalResidueRepresentative r
    refine ⟨?_, ?_, rfl⟩
    · have hOdd : q % 2 = 1 := by
        rw [hq]
        exact acceleratedOddIter_odd k n (by omega) hodd
      apply Nat.pos_of_ne_zero
      intro hEqZero
      have hEvenMod : (q % modulus) % 2 = 0 := by
        rw [hEqZero]
      have hModulusEven : 2 ∣ modulus := by
        unfold modulus
        exact ⟨acceleratedMultiplier k, rfl⟩
      have hqModTwo :
          (q % modulus) % 2 = q % 2 := by
        exact Nat.mod_mod_of_dvd q hModulusEven
      omega
    · simpa [modulus] using Nat.mod_lt q hModulusPos
  exact not_outputQuotientInterval_of_canonicalResidueBoundaryGapBound
    k n q r hRep (hBound n k q r hgt hodd hFirst hq hRep) hInterval

end ParityWords

/-! ## Top-level floor-free residue assembly -/

/-- First-multiplier-gap assembly through the floor-free canonical residue
gap bound. -/
theorem CollatzConjecture_of_firstMultiplierGap_canonicalResidueGapBound
    (hCover : ParityWords.EventuallyFirstAcceleratedMultiplierGap)
    (hBound : ParityWords.FirstMultiplierGapCanonicalResidueGapBound) :
    CollatzConjecture :=
  CollatzConjecture_of_firstMultiplierGap_no_quotientInterval hCover
    (ParityWords.noFirstMultiplierGapQuotientInterval_of_canonicalResidueGapBound
      hBound)

/-- First-multiplier-gap assembly through the empirically suggested strong
floor-free canonical residue gap bound `5 * offset < gap * r`. -/
theorem CollatzConjecture_of_firstMultiplierGap_canonicalResidueStrongGapBound
    (hCover : ParityWords.EventuallyFirstAcceleratedMultiplierGap)
    (hStrong :
      ParityWords.FirstMultiplierGapCanonicalResidueStrongGapBound) :
    CollatzConjecture :=
  CollatzConjecture_of_firstMultiplierGap_no_quotientInterval hCover
    (ParityWords.noFirstMultiplierGapQuotientInterval_of_canonicalResidueStrongGapBound
      hStrong)

/-- First-multiplier-gap assembly through the refined boundary-aware
floor-free canonical residue gap bound. -/
theorem CollatzConjecture_of_firstMultiplierGap_canonicalResidueBoundaryGapBound
    (hCover : ParityWords.EventuallyFirstAcceleratedMultiplierGap)
    (hBound :
      ParityWords.FirstMultiplierGapCanonicalResidueBoundaryGapBound) :
    CollatzConjecture :=
  CollatzConjecture_of_firstMultiplierGap_no_quotientInterval hCover
    (ParityWords.noFirstMultiplierGapQuotientInterval_of_canonicalResidueBoundaryGapBound
      hBound)
