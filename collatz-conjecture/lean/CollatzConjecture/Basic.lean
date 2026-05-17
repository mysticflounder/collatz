/-
  Classical Collatz map and finite iteration.

  This file deliberately uses only Lean core. We can add mathlib imports later
  when the proof development actually needs them.
-/

import Init

/-! ## Classical Collatz map -/

/-- One step of the classical Collatz map on natural numbers.

For `n = 0` this returns `0`; the conjecture only quantifies over positive
`n`, so the zero convention is irrelevant to the mathematical statement. -/
def collatzStep (n : Nat) : Nat :=
  if n % 2 = 0 then n / 2 else 3 * n + 1

/-- `collatzIter k n` is the result of applying the classical Collatz step `k`
times to `n`. The finite iterate index avoids any recursive termination
assumption about Collatz itself. -/
def collatzIter : Nat → Nat → Nat
  | 0, n => n
  | k + 1, n => collatzStep (collatzIter k n)

@[simp] theorem collatzIter_zero (n : Nat) : collatzIter 0 n = n := rfl

@[simp] theorem collatzIter_succ (k n : Nat) :
    collatzIter (k + 1) n = collatzStep (collatzIter k n) := rfl

/-- Composition law for finite Collatz iteration. -/
theorem collatzIter_add (a b n : Nat) :
    collatzIter (a + b) n = collatzIter b (collatzIter a n) := by
  induction b with
  | zero => rfl
  | succ b ih =>
      rw [Nat.add_succ]
      exact congrArg collatzStep ih

/-! ## Reaching one -/

/-- `n` reaches `1` under classical Collatz iteration. -/
def CollatzReachesOne (n : Nat) : Prop :=
  ∃ k : Nat, collatzIter k n = 1

/-- A more general reachability predicate for later use. -/
def CollatzReaches (start target : Nat) : Prop :=
  ∃ k : Nat, collatzIter k start = target

theorem collatz_reaches_one_iff_reaches (n : Nat) :
    CollatzReachesOne n ↔ CollatzReaches n 1 := by
  rfl

/-- Reachability composes along classical Collatz orbits. -/
theorem collatzReaches_trans {a b c : Nat} :
    CollatzReaches a b → CollatzReaches b c → CollatzReaches a c := by
  intro hab hbc
  rcases hab with ⟨m, hm⟩
  rcases hbc with ⟨k, hk⟩
  refine ⟨m + k, ?_⟩
  calc
    collatzIter (m + k) a = collatzIter k (collatzIter m a) := by
      rw [collatzIter_add]
    _ = collatzIter k b := by rw [hm]
    _ = c := hk

/-- If `a` reaches `b` and `b` reaches `1`, then `a` reaches `1`. -/
theorem collatzReaches_trans_one {a b : Nat} :
    CollatzReaches a b → CollatzReachesOne b → CollatzReachesOne a := by
  intro hab hb
  exact collatzReaches_trans hab (by
    rcases hb with ⟨k, hk⟩
    exact ⟨k, hk⟩)

/-! ## Sanity checks for the statement -/

theorem collatz_reaches_one_one : CollatzReachesOne 1 := by
  exact ⟨0, rfl⟩

/-- Classical trajectory: 2 reaches 1 after one full Collatz step. -/
theorem collatz_two_reaches_one : collatzIter 1 2 = 1 := rfl

theorem collatz_reaches_one_two : CollatzReachesOne 2 := by
  exact ⟨1, collatz_two_reaches_one⟩
