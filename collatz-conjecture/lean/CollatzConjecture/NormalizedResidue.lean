/-
  Normalized residue representatives for solver-facing quotient targets.

  `ResidueObstruction.lean` states the forced odd residue condition directly:

      D*q ≡ offset + 3^k  (mod 2*3^k), with q odd.

  Solvers usually report a normalized residue for `q`. Since `D = 2^V` is
  even, it is not invertible modulo `2*3^k`; the safe normalization is:

      q is odd, and
      q ≡ invD * offset  (mod 3^k),

  where `invD` is a checked inverse witness for `D` modulo `3^k`.

  This file uses only Lean core.
-/

import CollatzConjecture.ResidueObstruction

namespace ParityWords

/-! ## Inverse-witness normalized residue -/

/-- A checked inverse witness for the accelerated denominator modulo `3^k`.

This is deliberately a witness predicate rather than a computed inverse. Solver
artifacts can provide `inv`, and Lean only has to check the modular identity. -/
def AcceleratedDenominatorInverse (k n inv : Nat) : Prop :=
  (acceleratedDenominator k n * inv) % acceleratedMultiplier k = 1

/-- The normalized residue for the output quotient modulo `3^k`, given an
inverse witness for the accelerated denominator. -/
def acceleratedNormalizedResidue (k n inv : Nat) : Nat :=
  (inv * acceleratedOffset k n) % acceleratedMultiplier k

/-- Normalized residue condition for the output quotient: odd parity plus the
modulo-`3^k` residue computed from a denominator inverse witness. -/
def AcceleratedOutputQuotientNormalizedResidue (k n inv q : Nat) : Prop :=
  q % 2 = 1 ∧ q % acceleratedMultiplier k = acceleratedNormalizedResidue k n inv

/-- A denominator inverse turns the coarse affine residue into the normalized
residue modulo `3^k`. -/
theorem output_mod_multiplier_eq_normalizedResidue_of_inverse
    (k n inv q : Nat)
    (hInv : AcceleratedDenominatorInverse k n inv)
    (hRes : AcceleratedOutputQuotientResidue k n q) :
    q % acceleratedMultiplier k = acceleratedNormalizedResidue k n inv := by
  unfold AcceleratedDenominatorInverse at hInv
  unfold AcceleratedOutputQuotientResidue at hRes
  unfold acceleratedNormalizedResidue
  calc
    q % acceleratedMultiplier k
        = (1 * q) % acceleratedMultiplier k := by simp
    _ = (((acceleratedDenominator k n * inv) % acceleratedMultiplier k) * q) %
          acceleratedMultiplier k := by
            rw [hInv]
    _ = ((acceleratedDenominator k n * inv) * q) %
          acceleratedMultiplier k := by
            rw [Nat.mod_mul_mod]
    _ = (inv * (acceleratedDenominator k n * q)) %
          acceleratedMultiplier k := by
            simp [Nat.mul_comm, Nat.mul_left_comm]
    _ = (inv * ((acceleratedDenominator k n * q) %
          acceleratedMultiplier k)) % acceleratedMultiplier k := by
            rw [Nat.mul_mod_mod]
    _ = (inv * (acceleratedOffset k n % acceleratedMultiplier k)) %
          acceleratedMultiplier k := by
            rw [hRes]
    _ = (inv * acceleratedOffset k n) % acceleratedMultiplier k := by
            rw [Nat.mul_mod_mod]

/-- The canonical output quotient from a positive odd start satisfies the
normalized residue condition for any checked inverse witness. -/
theorem acceleratedOutputQuotientNormalizedResidue_of_output
    (k n inv : Nat) (hpos : 0 < n) (hodd : n % 2 = 1)
    (hInv : AcceleratedDenominatorInverse k n inv) :
    AcceleratedOutputQuotientNormalizedResidue k n inv
      (acceleratedOddIter k n) := by
  constructor
  · exact acceleratedOddIter_odd k n hpos hodd
  · exact output_mod_multiplier_eq_normalizedResidue_of_inverse k n inv
      (acceleratedOddIter k n) hInv
      (acceleratedOutputQuotientResidue_of_output k n)

/-- Any quotient equal to the canonical output quotient satisfies the
normalized residue condition for any checked inverse witness. -/
theorem acceleratedOutputQuotientNormalizedResidue_of_eq
    (k n inv q : Nat) (hpos : 0 < n) (hodd : n % 2 = 1)
    (hq : q = acceleratedOddIter k n)
    (hInv : AcceleratedDenominatorInverse k n inv) :
    AcceleratedOutputQuotientNormalizedResidue k n inv q := by
  subst q
  exact acceleratedOutputQuotientNormalizedResidue_of_output k n inv hpos hodd hInv

/-! ## Normalized residue-plus-interval obstruction target -/

/-- Solver-facing normalized obstruction: the output quotient is in the
forbidden interval and matches the normalized residue produced from a checked
denominator inverse. -/
def AcceleratedNormalizedResidueQuotientObstruction
    (k n inv q : Nat) : Prop :=
  AcceleratedOutputQuotientInterval k n q ∧
    AcceleratedDenominatorInverse k n inv ∧
      AcceleratedOutputQuotientNormalizedResidue k n inv q

/-- Separate inverse-existence obligation for first-gap prefixes.

This is mathematically routine (`2^V` is invertible modulo `3^k`) but kept as
an explicit hypothesis until the number-theory lemma is formalized. -/
def FirstMultiplierGapDenominatorInverses : Prop :=
  ∀ n k : Nat, 1 < n → n % 2 = 1 →
    FirstAcceleratedMultiplierGap k n →
      ∃ inv : Nat, AcceleratedDenominatorInverse k n inv

/-- Local first-gap target in normalized residue-plus-interval form. -/
def NoFirstMultiplierGapNormalizedResidueQuotientObstruction : Prop :=
  ∀ n k q inv : Nat, 1 < n → n % 2 = 1 →
    FirstAcceleratedMultiplierGap k n →
      q = acceleratedOddIter k n →
        AcceleratedDenominatorInverse k n inv →
          ¬ AcceleratedNormalizedResidueQuotientObstruction k n inv q

/-- Ruling out the normalized residue-plus-interval obstruction, together
with inverse witnesses for first-gap prefixes, rules out the threshold
obstruction used by the reduction map. -/
theorem NoFirstMultiplierGapThresholdObstruction_of_no_normalizedResidueQuotient
    (hInvs : FirstMultiplierGapDenominatorInverses)
    (hNoNRQ : NoFirstMultiplierGapNormalizedResidueQuotientObstruction) :
    NoFirstMultiplierGapThresholdObstruction := by
  intro n k hgt hodd hFirst hObs
  rcases hInvs n k hgt hodd hFirst with ⟨inv, hInv⟩
  have hQI :
      AcceleratedOutputQuotientInterval k n (acceleratedOddIter k n) :=
    acceleratedOutputQuotientInterval_of_thresholdObstruction k n hgt hObs
  have hNorm :
      AcceleratedOutputQuotientNormalizedResidue k n inv
        (acceleratedOddIter k n) :=
    acceleratedOutputQuotientNormalizedResidue_of_output k n inv (by omega) hodd hInv
  exact hNoNRQ n k (acceleratedOddIter k n) inv hgt hodd hFirst rfl hInv
    ⟨hQI, hInv, hNorm⟩

end ParityWords

/-! ## Top-level normalized-residue assembly -/

/-- First-multiplier-gap assembly in normalized residue-plus-interval form with
explicit inverse witnesses. `ModularInverse.lean` discharges this side
condition and provides the public theorem without the `hInvs` hypothesis. -/
theorem CollatzConjecture_of_firstMultiplierGap_no_normalizedResidueQuotient_with_inverses
    (hCover : ParityWords.EventuallyFirstAcceleratedMultiplierGap)
    (hInvs : ParityWords.FirstMultiplierGapDenominatorInverses)
    (hNoNRQ :
      ParityWords.NoFirstMultiplierGapNormalizedResidueQuotientObstruction) :
    CollatzConjecture :=
  CollatzConjecture_of_firstMultiplierGap_no_thresholdObstruction hCover
    (ParityWords.NoFirstMultiplierGapThresholdObstruction_of_no_normalizedResidueQuotient
      hInvs hNoNRQ)
