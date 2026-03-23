/-
  Ghost Cycles of the Syracuse Map — Basic Definitions and Properties

  Core result: D = 2^V - 3^L is always odd (key for modular inverses).

  Reference: McKenna (2026), Sections 2 and 5.
-/

import Mathlib.Algebra.Ring.Parity
import Mathlib.Tactic

namespace GhostCycles

/-- 3^L is always odd. -/
theorem three_pow_odd (L : ℕ) : Odd ((3 : ℤ) ^ L) :=
  Odd.pow ⟨1, by ring⟩

/-- **D = 2^V - 3^L is odd for V ≥ 1.** -/
theorem ghostDenom_odd {V L : ℕ} (hV : 1 ≤ V) :
    Odd ((2 : ℤ) ^ V - 3 ^ L) := by
  have heven : Even ((2 : ℤ) ^ V) := by
    exact (even_two).pow_of_ne_zero (by omega : V ≠ 0)
  have hodd : Odd ((3 : ℤ) ^ L) := three_pow_odd L
  exact heven.sub_odd hodd

/-- D is nonzero when 2^V ≠ 3^L. -/
theorem ghostDenom_ne_zero {V L : ℕ} (h : (2 : ℤ) ^ V ≠ 3 ^ L) :
    (2 ^ V - 3 ^ L : ℤ) ≠ 0 := sub_ne_zero.mpr h

end GhostCycles
