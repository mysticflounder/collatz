/-
  Ghost Cycles of the Syracuse Map
  Generalized Iteration Formula & Orbit Numerator Recurrence

  Generalizes the cycle equation iteration to arbitrary step constant c:
    If orbit(i+1) · 2^{v_i} = 3 · orbit(i) + c, then
    orbit(L) · 2^V = 3^L · orbit(0) + c · ghostR(ds)

  Setting c = 1 recovers the Syracuse iteration (CycleEquation.lean).
  Setting c = D recovers the orbit numerator recurrence (Paper A, Theorem 7 proof).

  Reference: McKenna (2026), Section 9, proof of Theorem 7.
-/

import GhostCycles.Syracuse.CycleEquation
import Mathlib.Tactic

namespace GhostCycles

/-- **Generalized Syracuse iteration.**

    For any step constant c: if `orbit(i+1) · 2^{v_i} = 3·orbit(i) + c`,
    then after all steps: `orbit(L) · 2^V = 3^L · orbit(0) + c · ghostR(ds)`.

    This generalizes `syracuse_iteration` (c = 1) and covers the orbit
    numerator recurrence (c = D). -/
theorem generalized_iteration (c : ℤ) :
    ∀ (ds : List ℕ) (orbit : ℕ → ℤ),
    (∀ i (h : i < ds.length),
      orbit (i + 1) * 2 ^ ds.get ⟨i, h⟩ = 3 * orbit i + c) →
    orbit ds.length * 2 ^ ds.sum = 3 ^ ds.length * orbit 0 + c * ghostR ds := by
  intro ds
  induction ds with
  | nil =>
    intro orbit _
    simp [ghostR]
  | cons v vs ih =>
    intro orbit hsteps
    have hstep0 : orbit 1 * 2 ^ v = 3 * orbit 0 + c :=
      hsteps 0 (by simp)
    have hsteps_shifted : ∀ i (h : i < vs.length),
        orbit (i + 1 + 1) * 2 ^ vs.get ⟨i, h⟩ = 3 * orbit (i + 1) + c := by
      intro i hi
      exact hsteps (i + 1) (by simp; omega)
    have ih_result := ih (fun j => orbit (j + 1)) hsteps_shifted
    simp only [] at ih_result
    simp only [ghostR, List.sum_cons, List.length_cons]
    -- Expand and substitute
    have expand : orbit (vs.length + 1) * (2 : ℤ) ^ (v + vs.sum) =
                  2 ^ v * (orbit (vs.length + 1) * 2 ^ vs.sum) := by ring
    rw [expand, ih_result]
    -- Use hstep0: orbit 1 * 2^v = 3 * orbit 0 + c
    have hcomm : (2 : ℤ) ^ v * orbit 1 = 3 * orbit 0 + c := by linarith [hstep0]
    calc 2 ^ v * (3 ^ vs.length * orbit (0 + 1) + c * ghostR vs)
        = 3 ^ vs.length * (2 ^ v * orbit 1) + 2 ^ v * (c * ghostR vs) := by ring
      _ = 3 ^ vs.length * (3 * orbit 0 + c) + 2 ^ v * (c * ghostR vs) := by rw [hcomm]
      _ = 3 ^ (vs.length + 1) * orbit 0 + c * (3 ^ vs.length + 2 ^ v * ghostR vs) := by ring

/-- **Generalized cycle equation.**
    When the orbit closes, the generalized iteration gives:
    orbit(0) · (2^V - 3^L) = c · ghostR(ds). -/
theorem generalized_cycle_equation (c : ℤ)
    (orbit : ℕ → ℤ) (ds : List ℕ)
    (hsteps : ∀ i (h : i < ds.length),
      orbit (i + 1) * 2 ^ ds.get ⟨i, h⟩ = 3 * orbit i + c)
    (hcycle : orbit ds.length = orbit 0) :
    orbit 0 * (2 ^ ds.sum - 3 ^ ds.length) = c * ghostR ds := by
  have iter := generalized_iteration c ds orbit hsteps
  rw [hcycle] at iter
  linarith

/-- **Orbit numerator iteration** (c = D).
    If R(i+1) · 2^{v_i} = 3·R(i) + D for each step, then
    R(L) · 2^V = 3^L · R(0) + D · ghostR(ds).

    This is the key step in the proof of the orbit formula (Theorem 7):
    it establishes the explicit solution of the first-order linear
    recurrence Q_{i+1} = 3·Q_i + D·2^{S_{i-1}}. -/
theorem orbit_numerator_iteration (D : ℤ) (ds : List ℕ) (R : ℕ → ℤ)
    (hsteps : ∀ i (h : i < ds.length),
      R (i + 1) * 2 ^ ds.get ⟨i, h⟩ = 3 * R i + D) :
    R ds.length * 2 ^ ds.sum = 3 ^ ds.length * R 0 + D * ghostR ds :=
  generalized_iteration D ds R hsteps

/-- **Original iteration as special case** (c = 1).
    Confirms that `syracuse_iteration` is a special case. -/
theorem syracuse_iteration' (ds : List ℕ) (orbit : ℕ → ℤ)
    (hsteps : ∀ i (h : i < ds.length),
      orbit (i + 1) * 2 ^ ds.get ⟨i, h⟩ = 3 * orbit i + 1) :
    orbit ds.length * 2 ^ ds.sum = 3 ^ ds.length * orbit 0 + ghostR ds := by
  have := generalized_iteration 1 ds orbit hsteps
  simpa using this

end GhostCycles
