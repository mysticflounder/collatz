/-
  Ghost Cycles of the Syracuse Map
  Concentrated Pattern Formula (Corollary of Theorem 7)

  For the concentrated pattern (1,...,1,e+1) with L entries:
    ghostR = 3^L - 2^L  (when e=1, i.e., pattern [1,...,1,2])

  More generally, for pattern [1,...,1,e+1]:
    ghostR = Σᵢ 3^{L-1-i} · 2^i · [last term gets 2^{L-1+e} not 2^{L-1}]

  This file proves the e=1 case: ghostR of the canonical pattern equals 3^L - 2^L.

  Reference: McKenna (2026), Corollary (Theorem conc), Section 9.
-/

import GhostCycles.Syracuse.CycleEquation
import Mathlib.Tactic

namespace GhostCycles

/-! ## The canonical e=1 pattern

  The concentrated pattern for cycle length L+1 with e=1 is
  [1, 1, ..., 1, 2] (L copies of 1, then one 2).
  Wait — for cycle length L, it's [1,...,1,2] with L entries total,
  where the last entry is 2 and the first L-1 entries are 1.
-/

/-- The canonical e=1 deposit pattern: L-1 ones followed by a 2.
    Total length = L, total valuation V = L+1. -/
def canonicalPattern : ℕ → List ℕ
  | 0 => []
  | n + 1 => 1 :: canonicalPattern n  -- builds [1,...,1] of length n, then we'd need to append 2

-- Actually, let's define it more directly
/-- The e=1 pattern of length L: [1, 1, ..., 1, 2] with L-1 ones and a final 2. -/
def e1Pattern (L : ℕ) : List ℕ :=
  List.replicate (L - 1) 1 ++ [2]

/-- Length of the e=1 pattern is L (for L ≥ 1). -/
theorem e1Pattern_length {L : ℕ} (hL : 1 ≤ L) : (e1Pattern L).length = L := by
  simp [e1Pattern, List.length_replicate]
  omega

/-- Sum of the e=1 pattern is L+1 (total valuation V = L+1). -/
theorem e1Pattern_sum {L : ℕ} (hL : 1 ≤ L) : (e1Pattern L).sum = L + 1 := by
  simp [e1Pattern, List.sum_replicate, List.sum_append, List.sum_cons, List.sum_nil]
  omega

/-! ## ghostR for simple patterns

  We prove ghostR by direct computation for small patterns,
  building toward the general formula.
-/

/-- ghostR [2] = 1. The simplest concentrated pattern (L=1, but L≥2 in practice). -/
@[simp] theorem ghostR_singleton_two : ghostR [2] = 1 := by
  simp [ghostR]

/-- ghostR [1, 2] = 5 = 3² - 2² = 9 - 4. -/
@[simp] theorem ghostR_one_two : ghostR [1, 2] = 5 := by
  simp [ghostR]

/-- ghostR [1, 1, 2] = 19 = 3³ - 2³ = 27 - 8. -/
@[simp] theorem ghostR_one_one_two : ghostR [1, 1, 2] = 19 := by
  simp [ghostR]

/-- ghostR [1, 1, 1, 2] = 65 = 3⁴ - 2⁴ = 81 - 16. -/
@[simp] theorem ghostR_one_one_one_two : ghostR [1, 1, 1, 2] = 65 := by
  simp [ghostR]

/-- ghostR [1, 1, 1, 1, 2] = 211 = 3⁵ - 2⁵ = 243 - 32. -/
@[simp] theorem ghostR_five : ghostR [1, 1, 1, 1, 2] = 211 := by
  simp [ghostR]

/-! ## The recurrence for ghostR with leading 1

  Key lemma: ghostR (1 :: vs) = 3 ^ |vs| + 2 * ghostR vs.
  When vs ends with 2 and all other entries are 1, this gives
  the recurrence ghostR(L) = 3^{L-1} + 2 · ghostR(L-1).
-/

/-- ghostR with a leading deposit of 1 satisfies the recurrence
    ghostR (1 :: vs) = 3^|vs| + 2 · ghostR vs. -/
theorem ghostR_cons_one (vs : List ℕ) :
    ghostR (1 :: vs) = 3 ^ vs.length + 2 * ghostR vs := by
  simp [ghostR]

/-- **The concentrated pattern formula (e=1).**

    ghostR of n ones followed by [2] equals 3^(n+1) - 2^(n+1).

    Proof by induction on n:
    - Base: ghostR [2] = 1 = 3 - 2.
    - Step: ghostR (1 :: pattern) = 3^|pattern| + 2 · ghostR pattern
            = 3^n + 2·(3^n - 2^n)  (by IH)
            = 3·3^n - 2·2^n
            = 3^(n+1) - 2^(n+1). -/
theorem ghostR_concentrated (n : ℕ) :
    ghostR (List.replicate n 1 ++ [2]) = 3 ^ (n + 1) - 2 ^ (n + 1) := by
  induction n with
  | zero => simp [ghostR]
  | succ k ih =>
    -- ghostR (1 :: replicate k 1 ++ [2]) = 3^|tail| + 2 · ghostR (replicate k 1 ++ [2])
    show ghostR (1 :: (List.replicate k 1 ++ [2])) = _
    rw [ghostR_cons_one]
    rw [ih]
    simp [List.length_replicate, List.length_append]
    ring

/-- **Corollary.** For cycle length L ≥ 1, the e=1 ghost has R = 3^L - 2^L. -/
theorem ghostR_e1 (L : ℕ) (hL : 1 ≤ L) :
    ghostR (e1Pattern L) = 3 ^ L - 2 ^ L := by
  obtain ⟨k, rfl⟩ : ∃ k, L = k + 1 := ⟨L - 1, by omega⟩
  simp [e1Pattern]
  exact ghostR_concentrated k

end GhostCycles
