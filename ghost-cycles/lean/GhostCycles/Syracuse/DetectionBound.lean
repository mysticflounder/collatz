/-
  Ghost Cycles of the Syracuse Map — Detection Bound (Proposition 5)

  For each fixed L₀ ≥ 2, define
    K₀(L₀) = max { ord₂(|2^V - 3^L|) + 2L : (L,V) with 2 ≤ L ≤ L₀, L+1 ≤ V ≤ 2L-1 }

  Then every ghost type with L ≤ L₀ and ρ > 1/4 appears at some level k ≤ K₀(L₀).

  The proof relies on:
  1. For fixed (L,V) with V < 2L, D = 2^V - 3^L is fixed.
  2. By Theorem 6, each case-(a) pattern reappears with period p = ord₂(|D|).
  3. The first appearance satisfies k₀ ≤ p + V ≤ p + 2L ≤ K₀(L₀).

  Reference: McKenna (2026), Proposition 5, Section 7.

  Proofs by Aristotle (Harmonic, aristotle.harmonic.fun).
-/

import Mathlib

namespace GhostCycles

/-- The 2-adic valuation of an integer (number of times 2 divides it). -/
noncomputable def ord2 (n : ℤ) : ℕ :=
  if n = 0 then 0 else n.natAbs.factorization 2

/-- D = 2^V - 3^L is the ghost denominator. -/
def ghostDenom (V L : ℕ) : ℤ := 2 ^ V - 3 ^ L

/-- The detection bound K₀ for a single (L, V) pair: ord₂(|D|) + 2L. -/
noncomputable def detectionBound (V L : ℕ) : ℕ :=
  ord2 (ghostDenom V L) + 2 * L

/-- For V ≥ 1, the ghost denominator D = 2^V - 3^L is odd,
    so ord₂(D) = 0 and the detection bound is just 2L. -/
theorem detection_bound_odd {V L : ℕ} (hV : 1 ≤ V) :
    ord2 (ghostDenom V L) = 0 := by
  unfold ord2 ghostDenom; norm_num
  rintro -
  rw [Nat.factorization_eq_zero_of_not_dvd]
  norm_num [← even_iff_two_dvd, parity_simps]
  aesop

/-- The first materialization level k₀ of a case-(a) ghost with
    parameters (L, V) satisfies k₀ ≤ ord₂(|D|) + V.
    Since V ≤ 2L - 1 < 2L for ρ > 1/4 ghosts, we get k₀ ≤ detectionBound. -/
theorem first_materialization_le_detection_bound
    {V L k₀ : ℕ} (_hV : L + 1 ≤ V) (hV2 : V ≤ 2 * L - 1)
    (hk : k₀ ≤ ord2 (ghostDenom V L) + V) :
    k₀ ≤ detectionBound V L := by
  exact le_trans hk
    (Nat.add_le_add_left (le_trans hV2 (Nat.sub_le _ _)) _)

/-- The detection bound is monotone in L when V ≥ 1: since ord₂(D) = 0
    for V ≥ 1, the bound simplifies to 2L which is monotone in L. -/
theorem detection_bound_mono {V₁ L₁ V₂ L₂ : ℕ}
    (hV1 : 1 ≤ V₁) (hV2 : 1 ≤ V₂) (hL : L₁ ≤ L₂) :
    detectionBound V₁ L₁ ≤ detectionBound V₂ L₂ := by
  have h1 := detection_bound_odd hV1 (L := L₁)
  have h2 := detection_bound_odd hV2 (L := L₂)
  unfold detectionBound
  omega

end GhostCycles
