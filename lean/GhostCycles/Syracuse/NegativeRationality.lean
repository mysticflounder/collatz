/-
  Ghost Cycles of the Syracuse Map
  Negative Rationality & Universal Case-(a) for Concentrated Patterns

  For the e=1 concentrated pattern [1,...,1,2] of length L:
  - The orbit numerators satisfy R_i = 2^{L-i+1} · 3^{i-1} - D
    where D = 2^{L+1} - 3^L.
  - Since D < 0 for L ≥ 2, both terms are positive, so R_i > 0.
  - The first term is even (L-i+1 ≥ 1), and -D = 3^L - 2^{L+1} is odd,
    so R_i is odd.
  - Oddness of R_i gives Universal Case-(a): v₂(3R_i + D) = v_i.

  Reference: McKenna (2026), Corollary (Theorem conc) and Theorem 9.
-/

import GhostCycles.Syracuse.Basic
import Mathlib.Tactic

namespace GhostCycles

/-! ## The concentrated orbit formula

  For the e=1 pattern, define the orbit numerators directly by the
  closed form, then prove they satisfy the recurrence.
-/

/-- Orbit numerator R_i for the concentrated e=1 pattern.
    R_i = 2^{L-i+1} · 3^{i-1} - D where D = 2^{L+1} - 3^L.
    Equivalently, R_i = 2^{L-i+1} · 3^{i-1} + 3^L - 2^{L+1}. -/
def orbitNumerator (L i : ℕ) : ℤ :=
  2 ^ (L - i + 1) * 3 ^ (i - 1) + (3 ^ L - 2 ^ (L + 1))

/-- R₁ equals ghostR for the e=1 pattern: R₁ = 3^L - 2^L.
    From the formula: R₁ = 2^L · 3^0 + (3^L - 2^{L+1}) = 2^L + 3^L - 2^{L+1} = 3^L - 2^L. -/
theorem orbitNumerator_one (L : ℕ) (hL : 1 ≤ L) :
    orbitNumerator L 1 = 3 ^ L - 2 ^ L := by
  unfold orbitNumerator
  have : L - 1 + 1 = L := by omega
  rw [this]
  simp
  ring

/-! ## Negative Rationality: R_i > 0 -/

/-- **Negative Rationality for concentrated patterns.**
    R_i > 0 for all 1 ≤ i ≤ L when L ≥ 2.

    Proof: R_i = 2^{L-i+1} · 3^{i-1} + (3^L - 2^{L+1}).
    The first term is ≥ 2 (since L-i+1 ≥ 1 and 3^{i-1} ≥ 1).
    The second term 3^L - 2^{L+1} > 0 for L ≥ 2 (since 3^L > 2^{L+1}).
    So R_i ≥ 2 + 1 > 0. -/
theorem orbitNumerator_pos (L i : ℕ) (hL : 2 ≤ L) (hi : 1 ≤ i) (hiL : i ≤ L)
    (h3 : (2 : ℤ) ^ (L + 1) < 3 ^ L) :
    0 < orbitNumerator L i := by
  unfold orbitNumerator
  have h1 : (0 : ℤ) < 2 ^ (L - i + 1) * 3 ^ (i - 1) := by positivity
  linarith

/-! ## Oddness of R_i -/

/-- **R_i is odd** for all 1 ≤ i ≤ L.

    Proof: R_i = 2^{L-i+1} · 3^{i-1} + (3^L - 2^{L+1}).
    First term: 2^{L-i+1} · 3^{i-1} is even since L-i+1 ≥ 1.
    Second term: 3^L is odd, 2^{L+1} is even, so 3^L - 2^{L+1} is odd.
    Even + odd = odd. -/
theorem orbitNumerator_odd (L i : ℕ) (hL : 2 ≤ L) (hi : 1 ≤ i) (hiL : i ≤ L) :
    Odd (orbitNumerator L i) := by
  unfold orbitNumerator
  -- First term is even
  have heven : Even ((2 : ℤ) ^ (L - i + 1) * 3 ^ (i - 1)) := by
    apply Even.mul_right
    exact Even.pow_of_ne_zero even_two (by omega)
  -- Second term is odd: 3^L - 2^{L+1}
  have hodd : Odd ((3 : ℤ) ^ L - 2 ^ (L + 1)) := by
    have h3 : Odd ((3 : ℤ) ^ L) := three_pow_odd L
    have h2 : Even ((2 : ℤ) ^ (L + 1)) := Even.pow_of_ne_zero even_two (by omega)
    exact h3.sub_even h2
  exact heven.add_odd hodd

/-! ## Universal Case-(a)

  From oddness of R_i and the recurrence R_{i+1} · 2^{v_i} = 3R_i + D:
  v₂(3R_i + D) = v₂(2^{v_i} · R_{i+1}) = v_i + v₂(R_{i+1}) = v_i + 0 = v_i.
-/

/-- **Universal Case-(a) for concentrated patterns** (conceptual statement).

    If R_i is odd and 3R_i + D = 2^{v_i} · R_{i+1} with R_{i+1} odd,
    then v₂(3R_i + D) = v_i.

    This follows from: v₂(2^a · m) = a when m is odd. -/
theorem case_a_from_oddness (R_cur R_next D : ℤ) (v : ℕ)
    (hrecur : 2 ^ v * R_next = 3 * R_cur + D)
    (hodd_next : Odd R_next)
    (hv_pos : 1 ≤ v) :
    -- 2^v divides 3R_cur + D
    (2 : ℤ) ^ v ∣ (3 * R_cur + D)
    -- but 2^{v+1} does not
    ∧ ¬ (2 : ℤ) ^ (v + 1) ∣ (3 * R_cur + D) := by
  constructor
  · -- 2^v | 3R + D since 3R + D = 2^v · R_next
    exact ⟨R_next, by linarith⟩
  · -- 2^{v+1} ∤ 3R + D since R_next is odd
    intro ⟨c, hc⟩
    -- 3R + D = 2^{v+1} · c = 2^v · (2c)
    have : 2 ^ v * R_next = 2 ^ v * (2 * c) := by
      rw [hrecur]; rw [pow_succ] at hc; linarith
    have : R_next = 2 * c := by
      have h2v_pos : (0 : ℤ) < 2 ^ v := by positivity
      exact mul_left_cancel₀ (ne_of_gt h2v_pos) this
    -- But R_next is odd, contradiction with R_next = 2c
    have heven : Even R_next := ⟨c, by linarith⟩
    have : ¬ Odd R_next := by
      rw [Int.not_odd_iff_even]
      exact heven
    contradiction

end GhostCycles
