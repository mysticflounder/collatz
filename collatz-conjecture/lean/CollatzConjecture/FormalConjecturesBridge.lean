/-
  Bridge between our internal Collatz scaffold and the canonical conjecture
  statement in `FormalConjectures.Wikipedia.CollatzConjecture` (from
  `google-deepmind/formal-conjectures`).

  The upstream definition `CollatzConjecture.collatzStep` uses `Even n`
  (Mathlib), while our internal `collatzStep` uses `n % 2 = 0` (Lean core).
  They are pointwise equal — this file proves that equality and lifts it
  to iteration so the two statements coincide.
-/

import CollatzConjecture.Basic
import FormalConjectures.Wikipedia.CollatzConjecture
import Mathlib.Algebra.Group.Nat.Even

/-! ## Pointwise equality with the upstream `collatzStep` -/

theorem collatzStep_eq_formal (n : Nat) :
    collatzStep n = _root_.CollatzConjecture.collatzStep n := by
  unfold collatzStep _root_.CollatzConjecture.collatzStep
  by_cases h : n % 2 = 0
  · simp [h, Nat.even_iff.mpr h]
  · have hodd : n % 2 = 1 := by omega
    have hnotEven : ¬ Even n := by
      rw [Nat.even_iff]; omega
    simp [h, hnotEven]

/- Iteration equivalence: the classical Collatz iterate matches
`Function.iterate` of the upstream step function. This is the bridge used
to replace our top-level `CollatzConjecture` definition with the upstream
formulation while keeping all internal lemmas in terms of our
`collatzIter` form. -/

theorem collatzIter_eq_formal_iterate (k n : Nat) :
    collatzIter k n = _root_.CollatzConjecture.collatzStep^[k] n := by
  induction k generalizing n with
  | zero => rfl
  | succ k ih =>
    rw [collatzIter_succ, Function.iterate_succ_apply']
    rw [ih, collatzStep_eq_formal]

/-- Reaching `1` under our `collatzIter` is equivalent to reaching `1`
under the upstream `Function.iterate` formulation. -/
theorem CollatzReachesOne_iff_formal_iterate (n : Nat) :
    CollatzReachesOne n ↔ ∃ m, _root_.CollatzConjecture.collatzStep^[m] n = 1 := by
  unfold CollatzReachesOne
  constructor
  · rintro ⟨k, hk⟩
    exact ⟨k, by rw [← collatzIter_eq_formal_iterate]; exact hk⟩
  · rintro ⟨m, hm⟩
    exact ⟨m, by rw [collatzIter_eq_formal_iterate]; exact hm⟩

/-! ## Integration with the upstream `collatz_conjecture` statement

The top-level `CollatzConjecture` (defined in `Formulations.lean`) is, by
construction, the universally quantified form of the upstream
`CollatzConjecture.collatz_conjecture` theorem statement. A proof of our
`CollatzConjecture` therefore discharges the upstream `sorry`. -/

/-- Discharging the upstream `collatz_conjecture` statement from our
top-level `CollatzConjecture`. The two are the same proposition modulo
the `n > 0` vs `0 < n` notation. -/
theorem collatz_conjecture_of_CollatzConjecture
    (h : ∀ n : Nat, 0 < n → ∃ m : Nat, _root_.CollatzConjecture.collatzStep^[m] n = 1)
    (n : ℕ) (hn : n > 0) :
    ∃ m, _root_.CollatzConjecture.collatzStep^[m] n = 1 :=
  h n hn
