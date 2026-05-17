/-
  Parity words and exact affine block formulas.

  A parity word is a finite list of halving counts, each one recording the
  number of `n ↦ n / 2` steps performed in a single accelerated Collatz
  block. The block map associated with a parity word is

      T_v n = (3 ^ length v * n + offset v) / 2 ^ totalV v,

  defined here by direct iterated division (`applyWord`).

  Under the natural admissibility predicate (each block's `3 m + 1` is
  divisible by the corresponding power of two), the iterated form coincides
  with the closed-form division above. The main theorem of this file is the
  exact identity

      2 ^ totalV v * applyWord v n = 3 ^ length v * n + offset v.

  This file uses only Lean core; no Mathlib dependency yet.
-/

import CollatzConjecture.Accelerated

namespace ParityWords

/-- A parity word is a list of halving counts. Positivity of each entry is
not enforced by the type; it is enforced step-by-step by the admissibility
predicate, which requires that the corresponding power of two divide
`3 n + 1`. -/
abbrev ParityWord : Type := List Nat

/-- Total valuation of a parity word: the sum of all halving counts. -/
def totalV : ParityWord → Nat
  | [] => 0
  | v :: rest => v + totalV rest

/-- Affine offset associated to a parity word.

The recursion is

    offset [] = 0,
    offset (v :: rest) = 3 ^ rest.length + 2 ^ v * offset rest,

so that whenever `applyWord v n` is admissible the exact identity

    2 ^ totalV v * applyWord v n = 3 ^ v.length * n + offset v

holds. -/
def offset : ParityWord → Nat
  | [] => 0
  | v :: rest => 3 ^ rest.length + 2 ^ v * offset rest

/-- A single accelerated step parametrised by the halving count: the value
`(3 n + 1) / 2 ^ v` using natural-number division. The division is exact
exactly when `StepAdmissible v n` holds. -/
def applyStep (v n : Nat) : Nat := (3 * n + 1) / 2 ^ v

/-- Apply a parity word left-to-right: each successive list entry is the
halving count of the next block. -/
def applyWord : ParityWord → Nat → Nat
  | [], n => n
  | v :: rest, n => applyWord rest (applyStep v n)

/-- A single block step is admissible at `n` when `2 ^ v` exactly divides
`3 n + 1`. -/
def StepAdmissible (v n : Nat) : Prop := 2 ^ v ∣ (3 * n + 1)

/-- A parity word is admissible at `n` when every successive block in the
trajectory is `StepAdmissible`. -/
def Admissible : ParityWord → Nat → Prop
  | [], _ => True
  | v :: rest, n => StepAdmissible v n ∧ Admissible rest (applyStep v n)

/-! ## Computational unfoldings -/

@[simp] theorem totalV_nil : totalV [] = 0 := rfl

@[simp] theorem totalV_cons (v : Nat) (rest : ParityWord) :
    totalV (v :: rest) = v + totalV rest := rfl

@[simp] theorem offset_nil : offset [] = 0 := rfl

@[simp] theorem offset_cons (v : Nat) (rest : ParityWord) :
    offset (v :: rest) = 3 ^ rest.length + 2 ^ v * offset rest := rfl

@[simp] theorem applyWord_nil (n : Nat) : applyWord [] n = n := rfl

@[simp] theorem applyWord_cons (v : Nat) (rest : ParityWord) (n : Nat) :
    applyWord (v :: rest) n = applyWord rest (applyStep v n) := rfl

theorem admissible_nil (n : Nat) : Admissible [] n := trivial

theorem admissible_cons {v : Nat} {rest : ParityWord} {n : Nat}
    (hStep : StepAdmissible v n)
    (hRest : Admissible rest (applyStep v n)) :
    Admissible (v :: rest) n := ⟨hStep, hRest⟩

/-! ## Block formula -/

/-- The pre-multiplied exact block formula for an admissible parity word.

This is the core arithmetic identity of the parity-word framework: the
final iterated value of an admissible block, multiplied by the total
power-of-two divisor, equals the corresponding affine combination of the
initial value. -/
theorem applyWord_block_formula : ∀ (v : ParityWord) (n : Nat),
    Admissible v n →
    2 ^ totalV v * applyWord v n = 3 ^ v.length * n + offset v := by
  intro v
  induction v with
  | nil =>
      intro n _
      simp
  | cons w rest ih =>
      intro n hAdm
      obtain ⟨hStep, hRest⟩ := hAdm
      have hStepEq : 2 ^ w * applyStep w n = 3 * n + 1 := by
        unfold applyStep
        rw [Nat.mul_comm]
        exact Nat.div_mul_cancel hStep
      have hIH := ih (applyStep w n) hRest
      have hpow_add : 2 ^ (w + totalV rest) = 2 ^ w * 2 ^ totalV rest :=
        Nat.pow_add 2 w (totalV rest)
      have hLenSucc : (w :: rest).length = rest.length + 1 := rfl
      calc
        2 ^ totalV (w :: rest) * applyWord (w :: rest) n
            = 2 ^ w * 2 ^ totalV rest * applyWord rest (applyStep w n) := by
              simp [hpow_add]
        _ = 2 ^ w * (2 ^ totalV rest * applyWord rest (applyStep w n)) := by
              rw [Nat.mul_assoc]
        _ = 2 ^ w * (3 ^ rest.length * applyStep w n + offset rest) := by
              rw [hIH]
        _ = 2 ^ w * (3 ^ rest.length * applyStep w n) + 2 ^ w * offset rest := by
              rw [Nat.mul_add]
        _ = 3 ^ rest.length * (2 ^ w * applyStep w n) + 2 ^ w * offset rest := by
              rw [Nat.mul_left_comm]
        _ = 3 ^ rest.length * (3 * n + 1) + 2 ^ w * offset rest := by
              rw [hStepEq]
        _ = 3 ^ rest.length * (3 * n) + 3 ^ rest.length * 1 + 2 ^ w * offset rest := by
              rw [Nat.mul_add]
        _ = 3 ^ rest.length * 3 * n + 3 ^ rest.length + 2 ^ w * offset rest := by
              rw [Nat.mul_assoc, Nat.mul_one]
        _ = 3 ^ (rest.length + 1) * n + 3 ^ rest.length + 2 ^ w * offset rest := by
              rw [Nat.pow_succ]
        _ = 3 ^ (rest.length + 1) * n + (3 ^ rest.length + 2 ^ w * offset rest) := by
              rw [Nat.add_assoc]
        _ = 3 ^ (w :: rest).length * n + offset (w :: rest) := by
              rw [hLenSucc, offset_cons]

/-- Closed-form block formula for an admissible parity word: the iterated
applications coincide with a single floor division of an affine
combination. -/
theorem applyWord_eq_div (v : ParityWord) (n : Nat) (hAdm : Admissible v n) :
    applyWord v n = (3 ^ v.length * n + offset v) / 2 ^ totalV v := by
  have hpow_pos : 0 < 2 ^ totalV v := Nat.pow_pos (by decide)
  have hMul : 2 ^ totalV v * applyWord v n = 3 ^ v.length * n + offset v :=
    applyWord_block_formula v n hAdm
  calc
    applyWord v n
        = 2 ^ totalV v * applyWord v n / 2 ^ totalV v := by
          rw [Nat.mul_div_cancel_left _ hpow_pos]
    _ = (3 ^ v.length * n + offset v) / 2 ^ totalV v := by
          rw [hMul]

/-- Exact divisibility characterisation of admissibility for a single block.

A block of valuation `v` is admissible at `n` iff `2 ^ v ∣ (3 n + 1)`; this
is by definition, but is recorded here as a named lemma for downstream
use. -/
theorem stepAdmissible_iff_dvd (v n : Nat) :
    StepAdmissible v n ↔ 2 ^ v ∣ (3 * n + 1) := Iff.rfl

/-! ## Bridge to the accelerated odd map -/

/-- The odd part of a positive natural is the result of dividing by the
canonical power of two. -/
theorem oddPart_eq_div (n : Nat) (hpos : 0 < n) :
    oddPart n = n / 2 ^ oddPartSteps n := by
  have hpow_pos : 0 < 2 ^ oddPartSteps n := Nat.pow_pos (by decide)
  have hfact : n = 2 ^ oddPartSteps n * oddPart n :=
    oddPart_factorization n hpos
  have hcancel :
      (2 ^ oddPartSteps n * oddPart n) / 2 ^ oddPartSteps n = oddPart n :=
    Nat.mul_div_cancel_left _ hpow_pos
  calc
    oddPart n
        = (2 ^ oddPartSteps n * oddPart n) / 2 ^ oddPartSteps n := hcancel.symm
    _ = n / 2 ^ oddPartSteps n := by rw [← hfact]

/-- The natural valuation extracted by `oddPartSteps` always produces an
admissible single block. -/
theorem stepAdmissible_oddPartSteps (n : Nat) :
    StepAdmissible (oddPartSteps (3 * n + 1)) n := by
  have hpos : 0 < 3 * n + 1 := Nat.succ_pos _
  exact ⟨oddPart (3 * n + 1), oddPart_factorization (3 * n + 1) hpos⟩

/-- Applying a parity-word block with the canonical valuation reproduces
the accelerated odd map. -/
theorem applyStep_oddPartSteps_eq_acceleratedOddStep (n : Nat) :
    applyStep (oddPartSteps (3 * n + 1)) n = acceleratedOddStep n := by
  have hpos : 0 < 3 * n + 1 := Nat.succ_pos _
  show (3 * n + 1) / 2 ^ oddPartSteps (3 * n + 1) = oddPart (3 * n + 1)
  exact (oddPart_eq_div (3 * n + 1) hpos).symm

/-! ## Length-zero and length-one sanity checks -/

/-- The empty parity word leaves the input unchanged. -/
theorem applyWord_nil_eq (n : Nat) : applyWord [] n = n := rfl

/-- A single-block parity word `[v]` with valuation `v` reduces `n` to
`(3 n + 1) / 2 ^ v`. -/
theorem applyWord_singleton (v n : Nat) :
    applyWord [v] n = applyStep v n := rfl

/-- The block formula on a single-block word, written explicitly. -/
theorem applyWord_singleton_block_formula (v n : Nat)
    (hAdm : StepAdmissible v n) :
    2 ^ v * applyStep v n = 3 * n + 1 := by
  have hWordAdm : Admissible [v] n := ⟨hAdm, trivial⟩
  have h := applyWord_block_formula [v] n hWordAdm
  -- length = 1, totalV = v, offset = 1, applyWord [v] n = applyStep v n
  simpa [totalV, offset, applyWord, applyStep, List.length, Nat.pow_one,
    Nat.mul_one, Nat.pow_zero, Nat.one_mul] using h

end ParityWords
