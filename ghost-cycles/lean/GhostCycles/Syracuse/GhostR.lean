/-
  Ghost Cycles of the Syracuse Map
  Equivalence of recursive and summation definitions of R

  Paper defines: R = Σᵢ₌₀^{L-1} 3^{L-1-i} · 2^{σᵢ}
    where σᵢ = v₁ + ... + vᵢ (partial sum, σ₀ = 0)

  Lean defines recursively:
    ghostR [] = 0
    ghostR (v :: vs) = 3^|vs| + 2^v · ghostR vs

  We prove equivalence via an auxiliary "shifted" version of the paper's
  formula, showing ghostR_shifted ds s = 2^s · ghostR ds.
-/

import GhostCycles.Syracuse.CycleEquation
import Mathlib.Tactic

namespace GhostCycles

/-! ## The paper's summation formula (shifted form)

  The paper's formula with an accumulated shift:
    ghostR_shifted [] s = 0
    ghostR_shifted (v :: vs) s = 3^|vs| · 2^s + ghostR_shifted vs (s + v)

  This computes Σᵢ 3^{L-1-i} · 2^{s + σᵢ}, matching the paper when s = 0.
-/

/-- The paper's summation formula with accumulated shift.
    ghostR_shifted ds s = Σᵢ 3^{|ds|-1-i} · 2^{s + σᵢ}. -/
def ghostR_shifted : List ℕ → ℕ → ℤ
  | [], _ => 0
  | v :: vs, s => (3 : ℤ) ^ vs.length * 2 ^ s + ghostR_shifted vs (s + v)

/-- The paper's summation formula (no shift).
    ghostR_paper ds = Σᵢ 3^{|ds|-1-i} · 2^{σᵢ}. -/
def ghostR_paper (ds : List ℕ) : ℤ := ghostR_shifted ds 0

/-! ## Key lemma: ghostR_shifted ds s = 2^s · ghostR ds

  This is the bridge between the two definitions.
  Proved by induction on ds.
-/

/-- **Bridge lemma.** The shifted paper formula equals 2^s times the
    recursive definition.

    ghostR_shifted ds s = 2^s · ghostR ds

    Proof by induction:
    - Base: both sides are 0.
    - Step: ghostR_shifted (v::vs) s
            = 3^|vs| · 2^s + ghostR_shifted vs (s+v)
            = 3^|vs| · 2^s + 2^(s+v) · ghostR vs    (by IH)
            = 2^s · (3^|vs| + 2^v · ghostR vs)
            = 2^s · ghostR (v::vs) -/
theorem ghostR_shifted_eq (ds : List ℕ) (s : ℕ) :
    ghostR_shifted ds s = 2 ^ s * ghostR ds := by
  induction ds generalizing s with
  | nil => simp [ghostR_shifted, ghostR]
  | cons v vs ih =>
    simp only [ghostR_shifted, ghostR]
    rw [ih (s + v)]
    rw [pow_add]
    ring

/-! ## The equivalence theorem -/

/-- **Equivalence of definitions.**
    The paper's summation formula Σᵢ 3^{L-1-i} · 2^{σᵢ} equals the
    recursive definition ghostR, for all deposit lists.

    This closes specification gap 1: we now KNOW (machine-verified) that
    our recursive `ghostR` computes the same thing as the paper's explicit
    summation. -/
theorem ghostR_eq_paper (ds : List ℕ) : ghostR ds = ghostR_paper ds := by
  unfold ghostR_paper
  rw [ghostR_shifted_eq]
  simp

end GhostCycles
