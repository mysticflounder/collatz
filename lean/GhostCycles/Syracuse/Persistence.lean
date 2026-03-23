/-
  Ghost Cycles of the Syracuse Map
  R₁ is odd & Persistence of Ghost Cycles

  Key results:
  1. ghostR is odd for any valid (nonempty, positive) deposit pattern
  2. The orbit numerator recurrence: R_{i+1} · 2^{v_i} = 3·R_i + D
  3. Persistence: the exact cycle equation implies the modular congruence
     at every level k

  Reference: McKenna (2026), Sections 5 and 6.
-/

import GhostCycles.Syracuse.CycleEquation
import GhostCycles.Syracuse.Basic
import Mathlib.Algebra.Ring.Parity

namespace GhostCycles

/-! ## Oddness of R₁

  ghostR(v :: vs) = 3^|vs| + 2^v · ghostR(vs).
  Since 3^|vs| is odd and 2^v · (anything) is even when v ≥ 1,
  ghostR is odd for any nonempty list with first entry ≥ 1.
-/

/-- **R₁ is odd** for any deposit pattern with first deposit ≥ 1.
    Proof: the leading term 3^|vs| is odd, and 2^v · ghostR(vs) is even
    since v ≥ 1. Odd + even = odd. -/
theorem ghostR_odd {v : ℕ} {vs : List ℕ} (hv : 1 ≤ v) :
    Odd (ghostR (v :: vs)) := by
  unfold ghostR
  have hodd3 : Odd ((3 : ℤ) ^ vs.length) := three_pow_odd vs.length
  have heven2 : Even ((2 : ℤ) ^ v * ghostR vs) :=
    Even.mul_right (Even.pow_of_ne_zero even_two (by omega)) _
  exact hodd3.add_even heven2

/-! ## Orbit numerator recurrence

  From the Syracuse step relation n_{i+1} · 2^{v_i} = 3·n_i + 1,
  multiplying by D gives the numerator recurrence:
    (n_{i+1} · D) · 2^{v_i} = 3·(n_i · D) + D
-/

/-- **Orbit numerator recurrence.**
    Multiplying a Syracuse step by D transforms
    `n_{i+1} · 2^v = 3·n_i + 1` into
    `(n_{i+1}·D) · 2^v = 3·(n_i·D) + D`. -/
theorem numerator_recurrence (n_cur n_next D : ℤ) (v : ℕ)
    (hstep : n_next * 2 ^ v = 3 * n_cur + 1) :
    (n_next * D) * 2 ^ v = 3 * (n_cur * D) + D := by
  have : n_next * D * 2 ^ v = (n_next * 2 ^ v) * D := by ring
  rw [this, hstep]; ring

/-! ## Persistence (modular form)

  The exact cycle equation n₁ · D = R implies the modular version
  n₁ · D ≡ R (mod M) for any modulus M.
-/

/-- **Persistence of ghost cycles.**
    The exact identity `n₁ · D = R` implies `n₁ · D ≡ R (mod M)`
    for any modulus M. This is why case-(a) ghosts persist at every level. -/
theorem persistence_modular (n₁ D R : ℤ) (M : ℕ)
    (hexact : n₁ * D = R) :
    (n₁ * D) % (M : ℤ) = R % (M : ℤ) := by
  rw [hexact]

/-- **Full persistence corollary.**
    From the cycle equation (exact identity) and any modulus 2^k,
    the ghost cycle equation holds modulo 2^k. -/
theorem persistence_at_level
    (orbit : ℕ → ℤ) (ds : List ℕ) (k : ℕ)
    (hsteps : ∀ i (h : i < ds.length),
      orbit (i + 1) * 2 ^ ds.get ⟨i, h⟩ = 3 * orbit i + 1)
    (hcycle : orbit ds.length = orbit 0) :
    (orbit 0 * (2 ^ ds.sum - 3 ^ ds.length)) % (2 ^ k : ℤ) =
    (ghostR ds) % (2 ^ k : ℤ) := by
  have hexact := cycle_equation orbit ds hsteps hcycle
  rw [hexact]

end GhostCycles
