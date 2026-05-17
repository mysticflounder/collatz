/-
  Stopping-time predicates for the classical Collatz map.
-/

import CollatzConjecture.Basic

/-! ## Stopping times -/

/-- `k` is a stopping time for `n` when the `k`th iterate is `1`.

This is not minimality; it is the existence predicate needed for the basic
conjecture. Minimal stopping times can be added later once we want the extra
well-ordering bookkeeping. -/
def IsCollatzStoppingTime (n k : Nat) : Prop :=
  collatzIter k n = 1

/-- `n` has some finite stopping time. -/
def HasCollatzStoppingTime (n : Nat) : Prop :=
  ∃ k : Nat, IsCollatzStoppingTime n k

theorem hasCollatzStoppingTime_iff_reaches_one (n : Nat) :
    HasCollatzStoppingTime n ↔ CollatzReachesOne n := by
  rfl

theorem collatz_stopping_time_one : IsCollatzStoppingTime 1 0 := rfl

theorem collatz_stopping_time_two : IsCollatzStoppingTime 2 1 := rfl

theorem hasCollatzStoppingTime_one : HasCollatzStoppingTime 1 := by
  exact ⟨0, collatz_stopping_time_one⟩

theorem hasCollatzStoppingTime_two : HasCollatzStoppingTime 2 := by
  exact ⟨1, collatz_stopping_time_two⟩
