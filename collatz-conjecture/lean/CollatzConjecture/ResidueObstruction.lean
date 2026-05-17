/-
  Residue-class side of the output-quotient obstruction.

  `QuotientObstruction.lean` gives the interval forced by a first-gap threshold
  obstruction. The affine identity also forces the output quotient into a
  residue class. For odd starts this can be stated modulo `2 * 3^k`:

      D * q ≡ offset + 3^k  (mod 2 * 3^k).

  Together with `q` odd, this is the Lean-side target corresponding to the
  "odd residue class modulo 2*3^k" used by the search code.

  This file uses only Lean core.
-/

import CollatzConjecture.QuotientObstruction

namespace ParityWords

/-! ## Residue vocabulary -/

/-- The affine identity forces `D*q` to be congruent to the offset modulo the
`3^k` multiplier. This is the coarse residue condition. -/
def AcceleratedOutputQuotientResidue (k n q : Nat) : Prop :=
  (acceleratedDenominator k n * q) % acceleratedMultiplier k =
    acceleratedOffset k n % acceleratedMultiplier k

/-- For odd starts, the affine identity forces the output quotient into the
odd residue class modulo `2 * 3^k`. The explicit `q % 2 = 1` conjunct records
that the output is an odd accelerated value. -/
def AcceleratedOutputQuotientOddResidue (k n q : Nat) : Prop :=
  q % 2 = 1 ∧
    (acceleratedDenominator k n * q) % (2 * acceleratedMultiplier k) =
      (acceleratedOffset k n + acceleratedMultiplier k) %
        (2 * acceleratedMultiplier k)

/-- If `n` is odd, then `a*n + b` is congruent to `b + a` modulo `2*a`. -/
theorem mul_odd_add_mod_two_mul (a b n : Nat) (hodd : n % 2 = 1) :
    (a * n + b) % (2 * a) = (b + a) % (2 * a) := by
  have hn : n = 2 * (n / 2) + 1 := by
    have h := Nat.mod_add_div n 2
    rw [hodd] at h
    omega
  rw [hn]
  calc
    (a * (2 * (n / 2) + 1) + b) % (2 * a)
        = (b + a + (2 * a) * (n / 2)) % (2 * a) := by
            congr 1
            simp [Nat.mul_add, Nat.mul_comm, Nat.mul_left_comm,
              Nat.add_assoc, Nat.add_comm, Nat.add_left_comm]
    _ = (b + a) % (2 * a) := by
          rw [Nat.add_mul_mod_self_left]

/-- The canonical accelerated output satisfies the coarse residue condition. -/
theorem acceleratedOutputQuotientResidue_of_output (k n : Nat) :
    AcceleratedOutputQuotientResidue k n (acceleratedOddIter k n) := by
  unfold AcceleratedOutputQuotientResidue
  rw [acceleratedOutput_affine_eq k n]
  simp [acceleratedMultiplier, acceleratedOffset]

/-- Any quotient equal to the canonical accelerated output satisfies the coarse
residue condition. -/
theorem acceleratedOutputQuotientResidue_of_eq (k n q : Nat)
    (hq : q = acceleratedOddIter k n) :
    AcceleratedOutputQuotientResidue k n q := by
  subst q
  exact acceleratedOutputQuotientResidue_of_output k n

/-- The canonical accelerated output from a positive odd start satisfies the
odd residue condition modulo `2 * 3^k`. -/
theorem acceleratedOutputQuotientOddResidue_of_output (k n : Nat)
    (hpos : 0 < n) (hodd : n % 2 = 1) :
    AcceleratedOutputQuotientOddResidue k n (acceleratedOddIter k n) := by
  constructor
  · exact acceleratedOddIter_odd k n hpos hodd
  · rw [acceleratedOutput_affine_eq k n]
    exact mul_odd_add_mod_two_mul
      (acceleratedMultiplier k) (acceleratedOffset k n) n hodd

/-- Any quotient equal to the canonical accelerated output from a positive odd
start satisfies the odd residue condition modulo `2 * 3^k`. -/
theorem acceleratedOutputQuotientOddResidue_of_eq (k n q : Nat)
    (hpos : 0 < n) (hodd : n % 2 = 1)
    (hq : q = acceleratedOddIter k n) :
    AcceleratedOutputQuotientOddResidue k n q := by
  subst q
  exact acceleratedOutputQuotientOddResidue_of_output k n hpos hodd

/-! ## Residue-plus-interval obstruction target -/

/-- Solver-facing local obstruction: the output quotient is simultaneously in
the forbidden interval and in the odd residue class forced by the affine
identity. -/
def AcceleratedResidueQuotientObstruction (k n q : Nat) : Prop :=
  AcceleratedOutputQuotientInterval k n q ∧
    AcceleratedOutputQuotientOddResidue k n q

/-- Local first-gap target in residue-plus-interval form. This is weaker than
ruling out the raw interval for all `q`, and matches the actual arithmetic
constraint the quotient must satisfy. -/
def NoFirstMultiplierGapResidueQuotientObstruction : Prop :=
  ∀ n k q : Nat, 1 < n → n % 2 = 1 →
    FirstAcceleratedMultiplierGap k n →
      q = acceleratedOddIter k n →
        ¬ AcceleratedResidueQuotientObstruction k n q

/-- Ruling out the residue-plus-interval obstruction rules out the threshold
obstruction used by the reduction map. -/
theorem NoFirstMultiplierGapThresholdObstruction_of_no_residueQuotient
    (hNoRQ : NoFirstMultiplierGapResidueQuotientObstruction) :
    NoFirstMultiplierGapThresholdObstruction := by
  intro n k hgt hodd hFirst hObs
  have hQI :
      AcceleratedOutputQuotientInterval k n (acceleratedOddIter k n) :=
    acceleratedOutputQuotientInterval_of_thresholdObstruction k n hgt hObs
  have hResidue :
      AcceleratedOutputQuotientOddResidue k n (acceleratedOddIter k n) :=
    acceleratedOutputQuotientOddResidue_of_output k n (by omega) hodd
  exact hNoRQ n k (acceleratedOddIter k n) hgt hodd hFirst rfl
    ⟨hQI, hResidue⟩

end ParityWords

/-! ## Top-level residue-obstruction assembly -/

/-- First-multiplier-gap assembly in residue-plus-interval form: if every
positive odd `n > 1` has a first multiplier-gap prefix, and no such prefix
puts its output quotient in the forced odd residue class inside the forbidden
interval, then Collatz follows. -/
theorem CollatzConjecture_of_firstMultiplierGap_no_residueQuotient
    (hCover : ParityWords.EventuallyFirstAcceleratedMultiplierGap)
    (hNoRQ : ParityWords.NoFirstMultiplierGapResidueQuotientObstruction) :
    CollatzConjecture :=
  CollatzConjecture_of_firstMultiplierGap_no_thresholdObstruction hCover
    (ParityWords.NoFirstMultiplierGapThresholdObstruction_of_no_residueQuotient hNoRQ)
