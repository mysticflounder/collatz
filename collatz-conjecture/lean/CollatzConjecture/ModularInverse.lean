/-
  Modular inverse side condition for normalized residue targets.

  The normalized residue interface in `NormalizedResidue.lean` asks for a
  witness `inv` satisfying

      D * inv ≡ 1  (mod 3^k),

  where `D = 2^V` is the accelerated denominator. This file discharges that
  witness obligation using mathlib's standard coprime / extended-gcd API.
-/

import CollatzConjecture.NormalizedResidue
import Mathlib.Data.Int.GCD
import Mathlib.Data.Nat.Prime.Basic

namespace ParityWords

/-! ## Denominator inverses modulo `3^k` -/

/-- The accelerated denominator `2^V` is coprime to the accelerated multiplier
`3^k`. -/
theorem acceleratedDenominator_coprime_multiplier (k n : Nat) :
    Nat.Coprime (acceleratedDenominator k n) (acceleratedMultiplier k) := by
  rw [acceleratedDenominator_eq_pow_totalV]
  unfold acceleratedMultiplier
  exact Nat.coprime_pow_primes
    (acceleratedTotalV k n) k Nat.prime_two Nat.prime_three
    (by decide : (2 : Nat) ≠ 3)

/-- A first multiplier gap cannot occur at `k = 0`, so the modulus `3^k` is
strictly larger than `1`. -/
theorem acceleratedMultiplier_one_lt_of_firstMultiplierGap
    (k n : Nat) (hFirst : FirstAcceleratedMultiplierGap k n) :
    1 < acceleratedMultiplier k := by
  cases k with
  | zero =>
      unfold FirstAcceleratedMultiplierGap AcceleratedMultiplierGap at hFirst
      simp [acceleratedDenominator_zero] at hFirst
  | succ j =>
      unfold acceleratedMultiplier
      calc
        1 < 3 := by decide
        _ ≤ 3 ^ j * 3 := Nat.le_mul_of_pos_left 3
          (by exact Nat.pow_pos (by decide : 0 < 3))
        _ = 3 ^ (j + 1) := by rw [Nat.pow_succ]

/-- Every first multiplier-gap prefix has a checked denominator inverse modulo
`3^k`. -/
theorem firstMultiplierGapDenominatorInverses :
    FirstMultiplierGapDenominatorInverses := by
  intro n k _hgt _hodd hFirst
  have hCoprime : Nat.Coprime
      (acceleratedDenominator k n) (acceleratedMultiplier k) :=
    acceleratedDenominator_coprime_multiplier k n
  have hMod : 1 < acceleratedMultiplier k :=
    acceleratedMultiplier_one_lt_of_firstMultiplierGap k n hFirst
  rcases Nat.exists_mul_mod_eq_one_of_coprime
      (k := acceleratedMultiplier k) (n := acceleratedDenominator k n)
      hCoprime hMod with ⟨inv, _hinvLt, hInv⟩
  exact ⟨inv, hInv⟩

end ParityWords

/-! ## Top-level normalized-residue assembly without inverse side condition -/

/-- First-multiplier-gap assembly in normalized residue-plus-interval form.
The denominator inverse witnesses are now supplied by
`ParityWords.firstMultiplierGapDenominatorInverses`. -/
theorem CollatzConjecture_of_firstMultiplierGap_no_normalizedResidueQuotient
    (hCover : ParityWords.EventuallyFirstAcceleratedMultiplierGap)
    (hNoNRQ :
      ParityWords.NoFirstMultiplierGapNormalizedResidueQuotientObstruction) :
    CollatzConjecture :=
  CollatzConjecture_of_firstMultiplierGap_no_normalizedResidueQuotient_with_inverses
    hCover ParityWords.firstMultiplierGapDenominatorInverses hNoNRQ
