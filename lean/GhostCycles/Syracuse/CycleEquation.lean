/-
  Ghost Cycles of the Syracuse Map
  Theorem 4: The Cycle Equation (PROPER formalization)

  Starting from the Syracuse step relation n_{i+1} · 2^{v_i} = 3·n_i + 1,
  we prove by induction that L iterations yield:
    n_{L+1} · 2^V = 3^L · n₁ + R
  When the cycle closes (n_{L+1} = n₁), this gives the cycle equation:
    n₁ · (2^V - 3^L) = R

  Reference: McKenna (2026), Section 5, Theorem 4.
-/

import Mathlib.Tactic

namespace GhostCycles

/-- The cumulative correction R, defined recursively on the deposit list.
    R([]) = 0
    R(v :: vs) = 3^|vs| + 2^v · R(vs)
    Equals Σᵢ 3^{L-1-i} · 2^{Sᵢ} where Sᵢ = v₁ + ... + vᵢ. -/
def ghostR : List ℕ → ℤ
  | [] => 0
  | v :: vs => 3 ^ vs.length + 2 ^ v * ghostR vs

/-- **Syracuse iteration formula.**
    If `orbit (i+1) · 2^{v_i} = 3 · orbit i + 1` for each step i,
    then `orbit L · 2^V = 3^L · orbit 0 + R`.
    Proved by induction on the deposit list, generalizing the orbit. -/
theorem syracuse_iteration :
    ∀ (ds : List ℕ) (orbit : ℕ → ℤ),
    (∀ i (h : i < ds.length),
      orbit (i + 1) * 2 ^ ds.get ⟨i, h⟩ = 3 * orbit i + 1) →
    orbit ds.length * 2 ^ ds.sum = 3 ^ ds.length * orbit 0 + ghostR ds := by
  intro ds
  induction ds with
  | nil =>
    intro orbit _
    simp [ghostR]
  | cons v vs ih =>
    intro orbit hsteps
    -- Step 0: orbit 1 · 2^v = 3 · orbit 0 + 1
    have hstep0 : orbit 1 * 2 ^ v = 3 * orbit 0 + 1 :=
      hsteps 0 (by simp)
    -- Apply IH to shifted orbit (fun j => orbit (j + 1))
    have hsteps_shifted : ∀ i (h : i < vs.length),
        orbit (i + 1 + 1) * 2 ^ vs.get ⟨i, h⟩ = 3 * orbit (i + 1) + 1 := by
      intro i hi
      exact hsteps (i + 1) (by simp; omega)
    have ih_result := ih (fun j => orbit (j + 1)) hsteps_shifted
    -- ih_result: orbit(|vs|+1) · 2^(sum vs) = 3^|vs| · orbit 1 + ghostR vs
    simp only [] at ih_result
    -- Combine: orbit(|vs|+1) · 2^(v + sum vs) = 3^(|vs|+1) · orbit 0 + ghostR(v::vs)
    simp only [ghostR, List.sum_cons, List.length_cons]
    -- Key step: substitute hstep0 into ih_result to eliminate orbit 1
    -- From ih_result: orbit(|vs|+1) * 2^(sum vs) = 3^|vs| * orbit 1 + ghostR vs
    -- From hstep0: orbit 1 * 2^v = 3 * orbit 0 + 1
    -- Multiply ih_result by 2^v:
    have h1 : orbit (vs.length + 1) * (2 : ℤ) ^ (v + vs.sum) =
              2 ^ v * (3 ^ vs.length * orbit (0 + 1) + ghostR vs) := by
      have : orbit (vs.length + 1) * (2 : ℤ) ^ (v + vs.sum) =
             2 ^ v * (orbit (vs.length + 1) * 2 ^ vs.sum) := by ring
      rw [this, ih_result]
    -- Now substitute: 2^v * 3^|vs| * orbit 1 = 3^|vs| * (3 * orbit 0 + 1)
    have h2 : (2 : ℤ) ^ v * (3 ^ vs.length * orbit (0 + 1)) =
              3 ^ vs.length * (3 * orbit 0 + 1) := by
      have hcomm : (2 : ℤ) ^ v * orbit 1 = 3 * orbit 0 + 1 := by linarith [hstep0]
      show (2 : ℤ) ^ v * (3 ^ vs.length * orbit 1) = _
      calc (2 : ℤ) ^ v * (3 ^ vs.length * orbit 1)
          = 3 ^ vs.length * (2 ^ v * orbit 1) := by ring
        _ = 3 ^ vs.length * (3 * orbit 0 + 1) := by rw [hcomm]
    -- 3^|vs| * (3 * orbit 0 + 1) = 3^(|vs|+1) * orbit 0 + 3^|vs|
    have h3 : (3 : ℤ) ^ vs.length * (3 * orbit 0 + 1) =
              3 ^ (vs.length + 1) * orbit 0 + 3 ^ vs.length := by ring
    linarith [h1, h2, h3]

/-- **Theorem 4 (Cycle Equation).**

    If orbit elements satisfy the Syracuse step relation
    `n_{i+1} · 2^{vᵢ} = 3·nᵢ + 1` for each i, and the cycle closes
    (orbit L = orbit 0), then:

      n₁ · (2^V - 3^L) = R

    This is an **exact integer identity**, derived directly from the
    Syracuse dynamics. No modular arithmetic or sorry blocks. -/
theorem cycle_equation
    (orbit : ℕ → ℤ)
    (ds : List ℕ)
    (hsteps : ∀ i (h : i < ds.length),
      orbit (i + 1) * 2 ^ ds.get ⟨i, h⟩ = 3 * orbit i + 1)
    (hcycle : orbit ds.length = orbit 0) :
    orbit 0 * (2 ^ ds.sum - 3 ^ ds.length) = ghostR ds := by
  have iter := syracuse_iteration ds orbit hsteps
  rw [hcycle] at iter
  linarith

end GhostCycles
